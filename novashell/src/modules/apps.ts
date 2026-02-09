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

function getDesktopId(app: AstalApps.Application): string {
	if (typeof app.get_desktop_id === "function") {
		return app.get_desktop_id() ?? "";
	}

	return "";
}

export function filterExcludedApps(
	apps: Array<AstalApps.Application>,
): Array<AstalApps.Application> {
	const exclude =
		(generalConfig.getProperty("apps.exclude", "object") as string[]) || [];
	if (!exclude.length) return apps;

	return apps.filter((app) => {
		const name = app.get_name()?.toLowerCase() || "";
		const desktop = getDesktopId(app).toLowerCase();
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
	if (!appsList.length) appsList = astalApps.get_list();
	return appsList;
}

export function updateApps(): void {
	astalApps.reload();
	appsList = astalApps.get_list();
}

export function getAstalApps(): AstalApps.Apps {
	return astalApps;
}

export function queryApps(text: string): Array<AstalApps.Application> {
	return astalApps.fuzzy_query(text);
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

function normalizeOverrideKey(value: string): string {
	return value
		.trim()
		.toLowerCase()
		.replace(/\.desktop$/i, "")
		.replace(/-/g, "_");
}

const canonicalIconAliases: Record<string, string> = {
	ghostty: "com.mitchellh.ghostty",
	"com.mitchellh.ghostty": "com.mitchellh.ghostty",
	telegram: "telegram-desktop",
	telegramdesktop: "telegram-desktop",
	"org.telegram.desktop": "telegram-desktop",
	helium: "helium-browser",
};

const forceRegularIconAliases: Record<string, string> = {
	ghostty: "com.mitchellh.ghostty",
	"com.mitchellh.ghostty": "com.mitchellh.ghostty",
};

function buildOverrideAliases(value: string): Set<string> {
	const normalized = normalizeOverrideKey(value);
	const aliases = new Set<string>([normalized]);

	for (const token of normalized.split(/[._\s]+/g)) {
		if (token) aliases.add(token);
	}

	return aliases;
}

function resolveForcedRegularIcon(
	candidates: Array<string | null | undefined>,
): string | undefined {
	for (const candidate of candidates) {
		if (!candidate) continue;
		for (const alias of buildOverrideAliases(candidate)) {
			const forced = forceRegularIconAliases[alias];
			if (forced && lookupIcon(forced)) return forced;
		}
	}

	return undefined;
}

function findOverrideIcon(
	candidates: Array<string | null | undefined>,
): string | undefined {
	const defaultOverrides: Record<string, string> = {
		"org.telegram.desktop": "telegram-desktop",
		telegram: "telegram-desktop",
		telegramdesktop: "telegram-desktop",
	};

	const overrides = generalConfig.getProperty(
		"apps.icon_overrides",
		"object",
	) as Record<string, string> | null;

	const aliases = new Set<string>();
	for (const candidate of candidates) {
		if (!candidate) continue;
		for (const alias of buildOverrideAliases(candidate)) aliases.add(alias);
	}

	if (aliases.size === 0) return undefined;

	if (overrides) {
		for (const [key, value] of Object.entries(overrides)) {
			if (!aliases.has(normalizeOverrideKey(key))) continue;
			if (lookupIcon(value)) return value;
		}
	}

	for (const [key, value] of Object.entries(defaultOverrides)) {
		if (!aliases.has(normalizeOverrideKey(key))) continue;
		if (lookupIcon(value)) return value;
	}

	return undefined;
}

const symbolicIconBlacklist = new Set([
	normalizeOverrideKey("com.mitchellh.ghostty"),
	normalizeOverrideKey("ghostty"),
]);

function shouldSkipSymbolic(
	app: string | AstalApps.Application,
	iconName: string,
): boolean {
	const candidates: string[] = [iconName];

	if (typeof app === "string") {
		candidates.push(app);
	} else {
		candidates.push(app.wmClass ?? "", getDesktopId(app), app.name ?? "");
	}

	for (const candidate of candidates) {
		if (!candidate) continue;
		if (symbolicIconBlacklist.has(normalizeOverrideKey(candidate))) {
			return true;
		}
	}

	if (resolveForcedRegularIcon(candidates)) return true;

	return false;
}

export function getAppsByName(
	appName: string,
): Array<AstalApps.Application> | undefined {
	const query = appName.trim().toLowerCase();
	const exact: Array<AstalApps.Application> = [];
	const partial: Array<AstalApps.Application> = [];

	for (const app of getApps()) {
		const name = app.get_name().trim().toLowerCase();
		const wm = app?.wmClass?.trim().toLowerCase() ?? "";

		if (name === query || wm === query) exact.push(app);
		else if (name.includes(query) || query.includes(name) || wm.includes(query))
			partial.push(app);
	}

	if (exact.length > 0) return exact;
	if (partial.length > 0) return partial;
	return undefined;
}

export function getIconByAppName(appName: string): string | undefined {
	if (!appName) return undefined;

	const override = findOverrideIcon([appName]);
	if (override) return override;

	const aliasIcon = canonicalIconAliases[normalizeOverrideKey(appName)];
	if (aliasIcon && lookupIcon(aliasIcon)) return aliasIcon;

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

	const override = findOverrideIcon([
		app.wmClass,
		getDesktopId(app),
		app.iconName,
		app.name,
	]);
	if (override) return override;

	if (app.iconName && lookupIcon(app.iconName)) return app.iconName;

	if (app.wmClass) return getIconByAppName(app.wmClass);

	return getIconByAppName(app.name);
}

export function getSymbolicIcon(
	app: string | AstalApps.Application,
): string | undefined {
	const icon = getAppIcon(app);
	if (!icon || shouldSkipSymbolic(app, icon)) return undefined;

	return lookupIcon(`${icon}-symbolic`) ? `${icon}-symbolic` : undefined;
}

export type ResolvedIcon = { name: string; symbolic: boolean };

export function resolveIconFromClasses(
	className?: string | null,
	initialClass?: string | null,
	fallback = "application-x-executable-symbolic",
): ResolvedIcon {
	const normalize = (value?: string | null) => (value ?? "").trim();
	const cls = normalize(className);
	const init = normalize(initialClass);
	const forced = resolveForcedRegularIcon([cls, init]);
	if (forced) return { name: forced, symbolic: false };

	if (
		cls.toLowerCase().includes("ghostty") ||
		init.toLowerCase().includes("ghostty")
	) {
		return { name: "com.mitchellh.ghostty", symbolic: false };
	}

	if (cls) {
		const resolved = resolveIcon(cls, fallback);
		if (resolved.name !== fallback) return resolved;
	}

	if (init) {
		return resolveIcon(init, fallback);
	}

	return resolveIcon(cls || init, fallback);
}

export function resolveIcon(
	app: string | AstalApps.Application,
	fallback = "application-x-executable-symbolic",
): ResolvedIcon {
	const forced =
		typeof app === "string"
			? resolveForcedRegularIcon([app])
			: resolveForcedRegularIcon([
					app.wmClass,
					app.iconName,
					app.name,
					getDesktopId(app),
				]);
	if (forced) return { name: forced, symbolic: false };

	const symbolic = getSymbolicIcon(app);
	if (symbolic) return { name: symbolic, symbolic: true };

	const regular = getAppIcon(app);
	if (regular) return { name: regular, symbolic: false };

	return { name: fallback, symbolic: fallback.endsWith("-symbolic") };
}
