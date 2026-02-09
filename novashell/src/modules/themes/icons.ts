import AstalApps from "gi://AstalApps";
import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib?version=2.0";

import { writeFileAsync } from "ags/file";
import { Gdk, Gtk } from "ags/gtk4";
import { execAsync } from "ags/process";

import { generalConfig } from "~/config";
import {
	ICON_THEME_META_FILE,
	ICON_THEME_OVERLAY_SOURCE,
	ICON_THEME_SOURCE_CANDIDATES,
	NOVASHELL_ICON_THEME_NAME,
} from "./icon-theme";
import type { ColorData } from "./types";
import { ensureDirectory } from "./utils";

type IconThemeSource = {
	name: string;
	path: string;
};

type IconThemeMeta = {
	accent: string;
	sourceTheme: string;
	overridesSignature: string;
};

const SYSTEM_ICON_DIR = "/usr/share/icons";
const SCRIPT_RESOURCE_PREFIX = "/io/github/razen/novashell/scripts";
const SCRIPT_CACHE_DIR = `${GLib.get_user_cache_dir()}/novashell/scripts`;
const SCRIPT_ALIASES = {
	recolor: "icons-recolor.py",
	overlayApps: "icons-overlay-apps.py",
	overlayCategories: "icons-overlay-categories.py",
} as const;
const ICON_THEME_LOCK_DIR = ".novashell-mono.lock";

const astalApps = new AstalApps.Apps();
let iconThemeUpdateQueue: Promise<void> = Promise.resolve();

function decodeResource(path: string): string {
	const bytes = Gio.resources_lookup_data(path, null).get_data();
	return new TextDecoder().decode(bytes);
}

function readTextFile(path: string): string | null {
	const file = Gio.File.new_for_path(path);
	if (!file.query_exists(null)) return null;

	try {
		const [ok, bytes] = file.load_contents(null);
		if (!ok) return null;
		return new TextDecoder().decode(bytes);
	} catch {
		return null;
	}
}

async function ensureScript(alias: string): Promise<string> {
	ensureDirectory(SCRIPT_CACHE_DIR);

	const scriptPath = `${SCRIPT_CACHE_DIR}/${alias}`;
	const resourcePath = `${SCRIPT_RESOURCE_PREFIX}/${alias}`;
	const resourceContent = decodeResource(resourcePath);
	const currentContent = readTextFile(scriptPath);

	if (currentContent !== resourceContent) {
		await writeFileAsync(scriptPath, resourceContent);
	}

	return scriptPath;
}

async function runScript(alias: string, args: Array<string>): Promise<void> {
	const scriptPath = await ensureScript(alias);
	await execAsync(["python3", scriptPath, ...args]);
}

function trimQuotes(value: string): string {
	return value.trim().replace(/^'/, "").replace(/'$/, "");
}

function getIconThemePath(themeName: string): string | null {
	const userTheme = `${GLib.get_user_data_dir()}/icons/${themeName}`;
	if (GLib.file_test(userTheme, GLib.FileTest.IS_DIR)) return userTheme;

	const systemTheme = `${SYSTEM_ICON_DIR}/${themeName}`;
	if (GLib.file_test(systemTheme, GLib.FileTest.IS_DIR)) return systemTheme;

	return null;
}

function getIconThemePaths(themeName: string): Array<string> {
	const paths: Array<string> = [];

	const userTheme = `${GLib.get_user_data_dir()}/icons/${themeName}`;
	if (GLib.file_test(userTheme, GLib.FileTest.IS_DIR)) paths.push(userTheme);

	const systemTheme = `${SYSTEM_ICON_DIR}/${themeName}`;
	if (
		GLib.file_test(systemTheme, GLib.FileTest.IS_DIR) &&
		!paths.includes(systemTheme)
	) {
		paths.push(systemTheme);
	}

	return paths;
}

async function getCurrentGtkIconTheme(): Promise<string | null> {
	try {
		const output = await execAsync([
			"gsettings",
			"get",
			"org.gnome.desktop.interface",
			"icon-theme",
		]);
		return trimQuotes(output);
	} catch {
		return null;
	}
}

async function resolveSourceTheme(): Promise<IconThemeSource> {
	const checked = new Set<string>();
	const candidates: string[] = [...ICON_THEME_SOURCE_CANDIDATES];

	const current = await getCurrentGtkIconTheme();
	if (
		current &&
		current !== NOVASHELL_ICON_THEME_NAME &&
		!candidates.includes(current)
	) {
		candidates.push(current);
	}

	for (const themeName of candidates) {
		if (
			checked.has(themeName) ||
			themeName.trim().length === 0 ||
			themeName === NOVASHELL_ICON_THEME_NAME
		) {
			continue;
		}

		checked.add(themeName);
		const path = getIconThemePath(themeName);
		if (path) return { name: themeName, path };
	}

	throw new Error(
		`IconUtils: Couldn't locate source icon theme. Checked: ${candidates.join(", ")}`,
	);
}

async function resolveRegularThemeName(): Promise<string> {
	const configured = generalConfig.getProperty(
		"theme.icon_theme_regular",
		"string",
	) as string | null;
	if (configured && getIconThemePath(configured)) return configured;

	const current = await getCurrentGtkIconTheme();
	if (
		current &&
		current !== NOVASHELL_ICON_THEME_NAME &&
		getIconThemePath(current)
	) {
		return current;
	}

	const fallbacks = [
		ICON_THEME_OVERLAY_SOURCE,
		...ICON_THEME_SOURCE_CANDIDATES,
		"hicolor",
	];
	for (const name of fallbacks) {
		if (getIconThemePath(name)) return name;
	}

	return "hicolor";
}

function loadThemeMeta(metaPath: string): IconThemeMeta | null {
	const text = readTextFile(metaPath);
	if (!text) return null;

	try {
		const parsed = JSON.parse(text) as Partial<IconThemeMeta>;
		if (
			typeof parsed.accent !== "string" ||
			typeof parsed.sourceTheme !== "string"
		) {
			return null;
		}

		return {
			accent: parsed.accent,
			sourceTheme: parsed.sourceTheme,
			overridesSignature:
				typeof parsed.overridesSignature === "string"
					? parsed.overridesSignature
					: "",
		};
	} catch {
		return null;
	}
}

async function saveThemeMeta(
	metaPath: string,
	meta: IconThemeMeta,
): Promise<void> {
	await writeFileAsync(metaPath, `${JSON.stringify(meta, null, "\t")}\n`).catch(
		(e: Error) => {
			console.error(`IconUtils: Failed to write icon metadata: ${e.message}`);
		},
	);
}

function expandIconNameAliases(name: string, into: Set<string>): void {
	const normalized = name.trim();
	if (!normalized) return;
	if (normalized.includes("/") || normalized.includes("\\")) return;

	const noDesktop = normalized.replace(/\.desktop$/i, "");
	const variants = [
		normalized,
		normalized.toLowerCase(),
		noDesktop,
		noDesktop.toLowerCase(),
		noDesktop.replaceAll("_", "-"),
		noDesktop.replaceAll("-", "_"),
	];

	if (noDesktop.includes(".")) {
		const split = noDesktop.split(".").filter(Boolean);
		variants.push(split[split.length - 1]);
	}

	for (const variant of variants) {
		const trimmed = variant.trim();
		if (trimmed) into.add(trimmed);
	}
}

function getDesktopId(app: AstalApps.Application): string {
	if (typeof app.get_desktop_id === "function") {
		return app.get_desktop_id() ?? "";
	}

	return "";
}

function getOverlayIconNames(): Array<string> {
	const names = new Set<string>();

	const overrides = generalConfig.getProperty(
		"apps.icon_overrides",
		"object",
	) as Record<string, string> | null;

	if (overrides) {
		for (const iconName of Object.values(overrides)) {
			expandIconNameAliases(iconName, names);
		}
	}

	for (const app of astalApps.get_list()) {
		expandIconNameAliases(app.iconName ?? "", names);
		expandIconNameAliases(app.wmClass ?? "", names);
		expandIconNameAliases(getDesktopId(app), names);
	}

	return [...names].sort();
}

function getOverridesSignature(names: Array<string>): string {
	return names.map((name) => name.toLowerCase()).join(",");
}

function isIconGenerationEnabled(): boolean {
	return (
		(generalConfig.getProperty("theme.icon_generation_enabled", "boolean") as
			| boolean
			| null) !== false
	);
}

async function copyThemeSource(
	source: string,
	destination: string,
): Promise<void> {
	await execAsync(["mkdir", "-p", destination]);
	await execAsync(["cp", "-a", `${source}/.`, destination]);
}

async function updateThemeInherits(themePath: string): Promise<void> {
	const indexPath = `${themePath}/index.theme`;
	const content = readTextFile(indexPath);
	if (!content) return;

	const desired = ["Novashell-Icons", "Papirus-Dark", "Papirus", "hicolor"];
	let updated = content;

	if (/^Inherits=/m.test(updated)) {
		updated = updated.replace(/^Inherits=.*$/m, (line) => {
			const existing = line
				.replace(/^Inherits=/, "")
				.split(",")
				.map((name) => name.trim())
				.filter((name) => name.length > 0);
			const merged = [
				...desired,
				...existing.filter((n) => !desired.includes(n)),
			];
			return `Inherits=${merged.join(",")}`;
		});
	} else {
		updated = updated.replace(
			/^\[Icon Theme\]$/m,
			`[Icon Theme]\nInherits=${desired.join(",")}`,
		);
	}

	if (updated !== content) {
		await writeFileAsync(indexPath, updated).catch(() => {});
	}
}

async function copyOverlayCategories(destination: string): Promise<void> {
	for (const overlayPath of getIconThemePaths(ICON_THEME_OVERLAY_SOURCE)) {
		await runScript(SCRIPT_ALIASES.overlayCategories, [
			destination,
			overlayPath,
		]);
	}
}

async function copyOverlayIcons(
	destination: string,
	iconNames: Array<string>,
	accent: string,
): Promise<void> {
	if (iconNames.length === 0) return;

	const sourceNames = [
		...new Set([ICON_THEME_OVERLAY_SOURCE, "hicolor"]),
	] as Array<string>;

	for (const sourceName of sourceNames) {
		for (const overlayPath of getIconThemePaths(sourceName)) {
			await runScript(SCRIPT_ALIASES.overlayApps, [
				destination,
				overlayPath,
				iconNames.join(","),
				accent,
			]);
		}
	}
}

async function recolorTheme(
	destination: string,
	accent: string,
): Promise<void> {
	await runScript(SCRIPT_ALIASES.recolor, [destination, accent]);
}

async function refreshIconCache(themePath: string): Promise<void> {
	await execAsync(["gtk4-update-icon-cache", "-f", "-t", themePath]).catch(
		(e: Error) => {
			console.error(`IconUtils: gtk4-update-icon-cache failed: ${e.message}`);
		},
	);
}

async function applyThemeSelection(themeName: string): Promise<void> {
	await execAsync([
		"gsettings",
		"set",
		"org.gnome.desktop.interface",
		"icon-theme",
		themeName,
	]).catch((e: Error) => {
		console.error(`IconUtils: Failed to set GTK icon theme: ${e.message}`);
	});

	await execAsync([
		"kwriteconfig6",
		"--file",
		"kdeglobals",
		"--group",
		"Icons",
		"--key",
		"Theme",
		themeName,
	]).catch((e: Error) => {
		console.error(`IconUtils: Failed to set KDE icon theme: ${e.message}`);
	});

	await execAsync([
		"bash",
		"-c",
		"command -v kbuildsycoca6 >/dev/null && kbuildsycoca6 >/dev/null 2>&1 || true",
	]).catch(() => {});

	const display = Gdk.Display.get_default();
	if (display) {
		const iconTheme = Gtk.IconTheme.get_for_display(display);
		if (iconTheme.get_theme_name() === themeName) {
			iconTheme.set_theme_name("hicolor");
		}
		iconTheme.set_theme_name(themeName);
	}
}

async function cleanupTempThemes(iconsRoot: string): Promise<void> {
	await execAsync(["rm", "-rf", `${iconsRoot}/${ICON_THEME_LOCK_DIR}`]).catch(
		() => {},
	);

	const dir = Gio.File.new_for_path(iconsRoot);
	if (!dir.query_exists(null)) return;

	try {
		const enumerator = dir.enumerate_children(
			"standard::name,standard::type",
			Gio.FileQueryInfoFlags.NONE,
			null,
		);

		while (true) {
			const info = enumerator.next_file(null);
			if (!info) break;

			const name = info.get_name();
			if (
				name.startsWith(`${NOVASHELL_ICON_THEME_NAME}.tmp-`) ||
				name.startsWith(`${NOVASHELL_ICON_THEME_NAME}.bak-`)
			) {
				await execAsync(["rm", "-rf", `${iconsRoot}/${name}`]).catch(() => {});
			}
		}
	} catch {}
}

async function applyRegularTheme(): Promise<void> {
	const regularTheme = await resolveRegularThemeName();
	await applyThemeSelection(regularTheme);
}

async function applyIconThemeUpdate(data: ColorData): Promise<void> {
	if (!isIconGenerationEnabled()) {
		await applyRegularTheme();
		return;
	}

	const accent = (data.accent || data.colors.color4).toLowerCase();
	const overlayIconNames = getOverlayIconNames();
	const overlaysSignature = getOverridesSignature(overlayIconNames);

	const iconsRoot = `${GLib.get_user_data_dir()}/icons`;
	const generatedThemePath = `${iconsRoot}/${NOVASHELL_ICON_THEME_NAME}`;
	const generatedIndexPath = `${generatedThemePath}/index.theme`;
	const metadataPath = `${generatedThemePath}/${ICON_THEME_META_FILE}`;

	ensureDirectory(iconsRoot);
	ensureDirectory(SCRIPT_CACHE_DIR);
	await cleanupTempThemes(iconsRoot);

	let source: IconThemeSource;
	try {
		source = await resolveSourceTheme();
	} catch (e) {
		console.error(`${e}`);
		if (!GLib.file_test(generatedIndexPath, GLib.FileTest.EXISTS)) {
			await applyRegularTheme();
		}
		return;
	}

	const themeExists = GLib.file_test(generatedThemePath, GLib.FileTest.IS_DIR);
	const existingMeta = loadThemeMeta(metadataPath);
	const needsRegeneration =
		!themeExists ||
		!existingMeta ||
		existingMeta.accent !== accent ||
		existingMeta.sourceTheme !== source.name ||
		existingMeta.overridesSignature !== overlaysSignature;

	if (needsRegeneration) {
		const tempThemePath = `${iconsRoot}/${NOVASHELL_ICON_THEME_NAME}.tmp-${GLib.get_monotonic_time()}`;
		const tempMetaPath = `${tempThemePath}/${ICON_THEME_META_FILE}`;
		const backupThemePath = `${iconsRoot}/${NOVASHELL_ICON_THEME_NAME}.bak-${GLib.get_monotonic_time()}`;

		try {
			await execAsync(["rm", "-rf", tempThemePath]);
			await execAsync(["rm", "-rf", backupThemePath]);

			await copyThemeSource(source.path, tempThemePath);
			await updateThemeInherits(tempThemePath);
			await copyOverlayCategories(tempThemePath);
			await copyOverlayIcons(tempThemePath, overlayIconNames, accent);
			await recolorTheme(tempThemePath, accent);
			await refreshIconCache(tempThemePath);
			await saveThemeMeta(tempMetaPath, {
				accent,
				sourceTheme: source.name,
				overridesSignature: overlaysSignature,
			});

			if (GLib.file_test(generatedThemePath, GLib.FileTest.IS_DIR)) {
				await execAsync(["mv", generatedThemePath, backupThemePath]);
			}

			await execAsync(["mv", tempThemePath, generatedThemePath]);
			await execAsync(["rm", "-rf", backupThemePath]).catch(() => {});
		} catch (e) {
			if (
				GLib.file_test(backupThemePath, GLib.FileTest.IS_DIR) &&
				!GLib.file_test(generatedThemePath, GLib.FileTest.IS_DIR)
			) {
				await execAsync(["mv", backupThemePath, generatedThemePath]).catch(
					() => {},
				);
			}
			await execAsync(["rm", "-rf", tempThemePath]).catch(() => {});
			console.error(`IconUtils: Failed to build icon theme: ${e}`);
			return;
		}
	}

	if (GLib.file_test(generatedIndexPath, GLib.FileTest.EXISTS)) {
		await applyThemeSelection(NOVASHELL_ICON_THEME_NAME);
	} else {
		console.error(
			"IconUtils: Generated icon theme missing index.theme, falling back",
		);
		await applyThemeSelection(source.name);
	}
}

export async function updateIconTheme(data: ColorData): Promise<void> {
	iconThemeUpdateQueue = iconThemeUpdateQueue
		.then(() => applyIconThemeUpdate(data))
		.catch((e) => {
			console.error(`IconUtils: Queued update failed: ${e}`);
		});

	return iconThemeUpdateQueue;
}
