import { createBinding } from "ags";

import { Notifications } from "~/modules/notifications";
import { Tile } from "~/window/control-center/widgets/tiles/Tile";

export const TileDND = () => (
	<Tile
		title={"Do Not Disturb"}
		description={createBinding(
			Notifications.getDefault().getNotifd(),
			"dontDisturb",
		).as((dnd: boolean) => (dnd ? "Enabled" : "Disabled"))}
		onDisabled={() =>
			(Notifications.getDefault().getNotifd().dontDisturb = false)
		}
		onEnabled={() =>
			(Notifications.getDefault().getNotifd().dontDisturb = true)
		}
		icon={"minus-circle-filled-symbolic"}
		state={Notifications.getDefault().getNotifd().dontDisturb}
		toggleOnClick
	/>
);
