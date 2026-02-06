import AstalBluetooth from "gi://AstalBluetooth";

import { createBinding, createComputed } from "ags";

import { Bluetooth } from "~/modules/bluetooth";
import { secureBaseBinding } from "~/modules/utils";
import { BluetoothPage } from "~/window/control-center/widgets/pages/Bluetooth";
import { TilesPages } from "~/window/control-center/widgets/tiles";
import { Tile } from "~/window/control-center/widgets/tiles/Tile";

export const TileBluetooth = () => (
	<Tile
		title={createBinding(Bluetooth.getDefault(), "lastDevice").as(
			(dev) => dev?.alias ?? "Bluetooth",
		)}
		visible={createBinding(Bluetooth.getDefault(), "isAvailable")}
		description={secureBaseBinding<typeof Bluetooth.prototype.lastDevice>(
			createBinding(Bluetooth.getDefault(), "lastDevice"),
			"batteryPercentage",
			null,
		).as((bat) =>
			bat !== null && bat > 0
				? `Battery: ${Math.floor(bat * 100)}%`
				: bat !== null
					? "Connected"
					: "",
		)}
		onEnabled={() => Bluetooth.getDefault().adapter?.set_powered(true)}
		onDisabled={() => Bluetooth.getDefault().adapter?.set_powered(false)}
		onClicked={() => TilesPages?.toggle(BluetoothPage)}
		hasArrow
		state={createBinding(AstalBluetooth.get_default(), "isPowered")}
		icon={createComputed(
			[
				createBinding(AstalBluetooth.get_default(), "isPowered"),
				createBinding(AstalBluetooth.get_default(), "isConnected"),
			],
			(powered: boolean, isConnected: boolean) =>
				powered
					? isConnected
						? "bluetooth-active-symbolic"
						: "bluetooth-symbolic"
					: "bluetooth-disabled-symbolic",
		)}
	/>
);
