import AstalTray from "gi://AstalTray";
import Gio from "gi://Gio?version=2.0";
import type GObject from "gi://GObject?version=2.0";

import { createBinding, createComputed, For, With } from "ags";
import { Gdk, Gtk } from "ags/gtk4";

import { getAppIcon, lookupIcon } from "~/modules/apps";

const astalTray = AstalTray.get_default();

function resolveTrayIcon(item: AstalTray.TrayItem): Gio.Icon | null {
	const gicon = item.gicon;

	// Check if the themed icon actually exists in the current theme
	if (gicon instanceof Gio.ThemedIcon) {
		const names = gicon.get_names();
		if (names?.some((name: string) => lookupIcon(name))) return gicon;

		// Themed icon not found — try app icon lookup as fallback
		const appIcon = getAppIcon(item.id) ?? getAppIcon(item.title);
		if (appIcon) return Gio.ThemedIcon.new(appIcon);
	}

	return gicon;
}

export const Tray = () => {
	const items = createBinding(astalTray, "items").as((items) =>
		items.filter((item) => item?.gicon),
	);

	return (
		<Gtk.Box class={"tray"} spacing={10}>
			<For each={items}>
				{(item: AstalTray.TrayItem) => (
					<Gtk.Box class={"item"}>
						<With
							value={createComputed([
								createBinding(item, "actionGroup"),
								createBinding(item, "menuModel"),
							])}
						>
							{([actionGroup, menuModel]: [Gio.ActionGroup, Gio.MenuModel]) => {
								const popover = Gtk.PopoverMenu.new_from_model(menuModel);
								popover.insert_action_group("dbusmenu", actionGroup);
								popover.hasArrow = false;

								return (
									<Gtk.Box
										class={"item"}
										tooltipMarkup={createBinding(item, "tooltipMarkup")}
										tooltipText={createBinding(item, "tooltipText")}
										$={(self) => {
											const conns: Map<GObject.Object, number> = new Map();
											const gestureClick = Gtk.GestureClick.new();
											gestureClick.set_button(0);

											self.add_controller(gestureClick);

											conns.set(
												gestureClick,
												gestureClick.connect("released", (gesture, _, x, y) => {
													if (
														gesture.get_current_button() === Gdk.BUTTON_PRIMARY
													) {
														item.activate(x, y);
														return;
													}

													if (
														gesture.get_current_button() ===
														Gdk.BUTTON_SECONDARY
													) {
														item.about_to_show();
														popover.popup();
													}
												}),
											);
										}}
									>
										<Gtk.Image
											gicon={createBinding(item, "gicon").as(() =>
												resolveTrayIcon(item),
											)}
											pixelSize={16}
										/>
										{popover}
									</Gtk.Box>
								);
							}}
						</With>
					</Gtk.Box>
				)}
			</For>
		</Gtk.Box>
	);
};
