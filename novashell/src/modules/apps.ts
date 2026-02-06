import AstalApps from "gi://AstalApps";
import AstalHyprland from "gi://AstalHyprland";

import { Gdk, Gtk } from "ags/gtk4";
import { execAsync } from "ags/process";

import { generalConfig } from "~/config";

export const uwsmIsActive: boolean = await execAsync("uwsm check is-active")
	.then(() => true)
	.catch(() => false);
const astalApps: AstalApps.Apps = new AstalApps.Apps();

let appsList: Array<AstalApps.Application> = [];

function filterExcludedApps(
	apps: Array<AstalApps.Application>,
): Array<AstalApps.Application> {
	const exclude =
		(generalConfig.getProperty("apps.exclude", "object") as string[]) || [];
	if (!exclude.length) return apps;

	return apps.filter((app) => {
		const name = app.get_name()?.toLowerCase() || "";
		const desktop = app.get_desktop_id()?.toLowerCase() || "";
		const wmClass = app.wmClass?.toLowerCase() || "";

		return !exclude.some((ex) => {
			const exLower = ex.toLowerCase();
			return (
				name.includes(exLower) ||
				desktop.includes(exLower) ||
				wmClass.includes(exLower)
			);
		});
	});
}

export function getApps(): Array<AstalApps.Application> {
	if (!appsList.length) appsList = filterExcludedApps(astalApps.get_list());
	return appsList;
}

export function updateApps(): void {
	astalApps.reload();
	appsList = filterExcludedApps(astalApps.get_list());
}

export function getAstalApps(): AstalApps.Apps {
	return astalApps;
}

/** fuzzy query with exclusion filter applied */
export function queryApps(text: string): Array<AstalApps.Application> {
	return filterExcludedApps(astalApps.fuzzy_query(text));
}

/** execute apps and commands using Hyprland's exec dispatcher.
    supports desktop entries and usage of uwsm if it's active */
export function execApp(
	app: AstalApps.Application | string,
	dispatchExecArgs?: string,
) {
	const executable =
		typeof app === "string" ? app : app.executable.replace(/%[fFcuUik]/g, "");

	if (typeof app !== "string") app.frequency++;

	AstalHyprland.get_default().dispatch(
		"exec",
		`${dispatchExecArgs ? `${dispatchExecArgs} ` : ""}${
			uwsmIsActive
				? "uwsm-app -- "
				: executable.endsWith(".desktop")
					? "gtk-launch "
					: ""
		}${executable}`,
	);
}

export function lookupIcon(name: string): boolean {
	return Gtk.IconTheme.get_for_display(Gdk.Display.get_default()!)?.has_icon(
		name,
	);
}

export function getAppsByName(
	appName: string,
): Array<AstalApps.Application> | undefined {
	const query = appName.trim().toLowerCase();
	const exact: Array<AstalApps.Application> = [];
	const partial: Array<AstalApps.Application> = [];

	getApps().map((app: AstalApps.Application) => {
		const name = app.get_name().trim().toLowerCase();
		const wm = app?.wmClass?.trim().toLowerCase() ?? "";

		if (name === query || wm === query) exact.push(app);
		else if (name.includes(query) || query.includes(name) || wm.includes(query))
			partial.push(app);
	});

	if (exact.length > 0) return exact;
	if (partial.length > 0) return partial;
	return undefined;
}

export function getIconByAppName(appName: string): string | undefined {
	if (!appName) return undefined;

	// Check user-configured overrides first (normalize hyphens/underscores for matching)
	const overrides = generalConfig.getProperty(
		"apps.icon_overrides",
		"object",
	) as Record<string, string> | null;
	if (overrides && Object.keys(overrides).length > 0) {
		const normalized = appName.replace(/-/g, "_").toLowerCase();
		for (const [key, value] of Object.entries(overrides)) {
			const keyNormalized = key.replace(/-/g, "_").toLowerCase();
			if (key === appName || keyNormalized === normalized) {
				if (lookupIcon(value)) return value;
			}
		}
	}

	if (lookupIcon(appName)) return appName;

	if (lookupIcon(appName.toLowerCase())) return appName.toLowerCase();

	const nameReverseDNS = appName.split(".");
	const lastItem = nameReverseDNS[nameReverseDNS.length - 1];
	const lastPretty = `${lastItem.charAt(0).toUpperCase()}${lastItem.substring(1, lastItem.length)}`;

	const uppercaseRDNS = nameReverseDNS
		.slice(0, nameReverseDNS.length - 1)
		.concat(lastPretty)
		.join(".");

	if (lookupIcon(uppercaseRDNS)) return uppercaseRDNS;

	if (lookupIcon(nameReverseDNS[nameReverseDNS.length - 1]))
		return nameReverseDNS[nameReverseDNS.length - 1];

	const found: AstalApps.Application | undefined = getAppsByName(appName)?.[0];
	if (found) return found?.iconName;

	return undefined;
}

export function getAppIcon(
	app: string | AstalApps.Application,
): string | undefined {
	if (!app) return undefined;

	if (typeof app === "string") return getIconByAppName(app);

	if (app.iconName && lookupIcon(app.iconName)) return app.iconName;

	if (app.wmClass) return getIconByAppName(app.wmClass);

	return getIconByAppName(app.name);
}

export function getSymbolicIcon(
	app: string | AstalApps.Application,
): string | undefined {
	const icon = getAppIcon(app);

	return icon && lookupIcon(`${icon}-symbolic`)
		? `${icon}-symbolic`
		: undefined;
}
