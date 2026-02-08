import { createRoot, getScope } from "ags";
import { Gtk } from "ags/gtk4";

import { Pages } from "~/window/control-center/widgets/pages";
import { TileBluetooth } from "~/window/control-center/widgets/tiles/Bluetooth";
import { TileDND } from "~/window/control-center/widgets/tiles/DoNotDisturb";
import { TileLanguage } from "~/window/control-center/widgets/tiles/Language";
import { TileNetwork } from "~/window/control-center/widgets/tiles/Network";
import { TileNightLight } from "~/window/control-center/widgets/tiles/NightLight";
import { TileRecording } from "~/window/control-center/widgets/tiles/Recording";

export let TilesPages: Pages | undefined;
export const tileList: Array<() => JSX.Element | Gtk.Widget> = [
	TileNetwork,
	TileBluetooth,
	TileRecording,
	TileDND,
	TileNightLight,
	TileLanguage,
] as Array<() => Gtk.Widget>;

export function Tiles(): Gtk.Widget {
	return createRoot((dispose) => {
		getScope().onCleanup(() => {
			TilesPages = undefined;
		});

		return (
			<Gtk.Box
				class={"tiles-container"}
				orientation={Gtk.Orientation.VERTICAL}
				onDestroy={() => dispose()}
			>
				<Gtk.FlowBox
					orientation={Gtk.Orientation.HORIZONTAL}
					rowSpacing={6}
					columnSpacing={6}
					minChildrenPerLine={2}
					activateOnSingleClick
					maxChildrenPerLine={2}
					hexpand
					homogeneous
				>
					{tileList.map((t) => t())}
				</Gtk.FlowBox>

				<Pages
					class={"tile-pages"}
					$={(self) => {
						TilesPages = self;
					}}
				/>
			</Gtk.Box>
		) as Gtk.Box;
	});
}
