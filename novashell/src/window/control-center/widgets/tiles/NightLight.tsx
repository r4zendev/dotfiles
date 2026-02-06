import { createBinding, createComputed } from "ags";

import { NightLight } from "~/modules/nightlight";
import { isInstalled } from "~/modules/utils";
import { PageNightLight } from "~/window/control-center/widgets/pages/NightLight";
import { TilesPages } from "~/window/control-center/widgets/tiles";
import { Tile } from "~/window/control-center/widgets/tiles/Tile";

export const TileNightLight = () => (
	<Tile
		title={"Night Light"}
		icon={"weather-clear-night-symbolic"}
		description={createComputed(
			[
				createBinding(NightLight.getDefault(), "identity"),
				createBinding(NightLight.getDefault(), "temperature"),
				createBinding(NightLight.getDefault(), "gamma"),
			],
			(identity, temp, gamma) =>
				!identity
					? `${
							temp === NightLight.identityTemperature ? "Fidelity" : `${temp}K`
						} ${gamma < NightLight.maxGamma ? `(${gamma}%)` : ""}`
					: "Disabled",
		)}
		hasArrow
		visible={isInstalled("hyprsunset")}
		onDisabled={() => (NightLight.getDefault().identity = true)}
		onEnabled={() => (NightLight.getDefault().identity = false)}
		onClicked={() => TilesPages?.toggle(PageNightLight)}
		state={createBinding(NightLight.getDefault(), "identity").as(
			(identity) => !identity,
		)}
	/>
);
