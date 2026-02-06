import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib?version=2.0";

import { readFile, writeFileAsync } from "ags/file";
import { execAsync } from "ags/process";

import { Gdk, Gtk } from "ags/gtk4";

import {
	broadcastTerminalColors,
	generateFishColors,
	generateTmuxColors,
	reloadFish,
	reloadNeovim,
	reloadTmux,
	updateBtopColors,
	updateGhosttyColors,
	updateGtkColors,
	updateHyprlandColors,
	updateQtColors,
} from "~/modules/color-utils";
import { decoder } from "~/modules/utils";
import { Wallpaper } from "~/modules/wallpaper";

/** handles stylesheet compiling and reloading */
export class Stylesheet {
	private static instance: Stylesheet;
	#outputPath = Gio.File.new_for_path(
		`${GLib.get_user_cache_dir()}/novashell/style`,
	);
	#stylesPaths: Array<string>;
	#themeProvider: Gtk.CssProvider | null = null;
	readonly #sassStyles = {
		modules: ["sass:color"].map((mod) => `@use "${mod}";`).join("\n"),
		colors: "",
		mixins: "",
		rules: "",
	};
	public get stylePath() {
		return this.#outputPath.get_path()!;
	}

	public static getDefault(): Stylesheet {
		if (!Stylesheet.instance) Stylesheet.instance = new Stylesheet();

		return Stylesheet.instance;
	}

	private bundle(): string {
		return `${this.#sassStyles.modules}\n\n${
			this.#sassStyles.colors
		}\n${this.#sassStyles.mixins}\n${this.#sassStyles.rules}`.trim();
	}

	private async compile(): Promise<void> {
		const sass = this.bundle();
		await writeFileAsync(`${this.stylePath}/sass.scss`, sass).catch((_e) => {
			const e = _e as Error;
			console.error(
				`Stylesheet: Couldn't write Sass to cache. Stderr: ${
					e.message
				}\n${e.stack}`,
			);
		});
		await execAsync(
			`bash -c "sass ${this.stylePath}/sass.scss ${this.stylePath}/style.css"`,
		).catch((_e) => {
			const e = _e as Error;
			console.error(
				`Stylesheet: An error occurred on compile-time! Stderr: ${
					e.message
				}\n${e.stack}`,
			);
		});
	}

	public getStyleSheet(): string {
		return readFile(`${this.stylePath}/style.css`);
	}

	public getColorDefinitions(): string {
		const data = Wallpaper.getDefault().getData();
		const colors = {
			...data.special,
			...data.colors,
			accent: data.accent || data.colors.color4,
		};

		return Object.keys(colors)
			.map((name) => `$${name}: ${colors[name as keyof typeof colors]};`)
			.join("\n");
	}

	private organizeModuleImports(sass: string) {
		return sass
			.replaceAll(
				/[@](use|forward|import) ["'](.*)["']?[;]?\n/gi,
				(_, impType, imp) => {
					imp = (imp as string).replace(/["';]/g, "");

					// add sass modules on top
					if (
						!this.#sassStyles.modules.includes(imp) &&
						/^(sass|.*http|.*https)/.test(imp)
					)
						this.#sassStyles.modules = this.#sassStyles.modules.concat(
							`\n@${impType} "${imp}";`,
						);

					return "";
				},
			)
			.replace(/(colors|mixins|wal)\./g, "");
	}

	/** Re-read color definitions from colors.json, recompile SCSS, and apply to all windows + external apps. */
	public reloadColors(): void {
		const defs = this.getColorDefinitions();
		this.#sassStyles.colors = `${defs}\n${this.organizeModuleImports(
			this.getStyleData("/io/github/razen/novashell/styles/colors"),
		)}`;
		this.applyExternalColors();
	}

	public compileApply(): void {
		this.compile()
			.then(() => {
				const css = this.getStyleSheet();

				if (!this.#themeProvider) {
					this.#themeProvider = Gtk.CssProvider.new();
					Gtk.StyleContext.add_provider_for_display(
						Gdk.Display.get_default()!,
						this.#themeProvider,
						Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
					);
				}

				this.#themeProvider.load_from_string(css);
			})
			.catch((_e) => {
				const e = _e as Error;
				console.error(
					`Stylesheet: An error occurred at compile-time. Stderr: ${
						e.message
					}\n${e.stack}`,
				);
			});
	}

	private getStyleData(path: string): string {
		return decoder.decode(Gio.resources_lookup_data(path, null).get_data()!);
	}

	constructor() {
		if (!this.#outputPath.query_exists(null))
			this.#outputPath.make_directory_with_parents(null);

		this.#stylesPaths = Gio.resources_enumerate_children(
			"/io/github/razen/novashell/styles",
			null,
		).map((name) => `/io/github/razen/novashell/styles/${name}`);

		// Rules won't change at runtime in a common build,
		// so no need to worry about this.
		// But in a development build, there should be support
		// hot-reloading the gresource, this is a TODO
		this.#stylesPaths.forEach((path) => {
			const name = path.split("/")[path.split("/").length - 1];

			switch (name) {
				case "colors":
					this.#sassStyles.colors = `${this.getColorDefinitions()}\n${this.organizeModuleImports(
						this.getStyleData(path),
					)}`;
					break;
				case "mixins":
					this.#sassStyles.mixins = `${this.organizeModuleImports(
						this.getStyleData(path),
					)}`;
					break;

				default:
					this.#sassStyles.rules = `${this.#sassStyles.rules}\n${this.organizeModuleImports(
						this.getStyleData(path),
					)}`;
					break;
			}
		});

		this.applyExternalColors();

		// Reload when Wallpaper finishes generating colors from image
		Wallpaper.getDefault().connect("colors-reloaded", () => {
			this.reloadColors();
		});
	}

	private applyExternalColors(): void {
		this.compileApply();

		const data = Wallpaper.getDefault().getData();
		updateHyprlandColors(data);

		broadcastTerminalColors(data);

		const themeId = data.name;
		Promise.all([
			updateGhosttyColors(data),
			generateFishColors(data),
			updateBtopColors(data),
			updateGtkColors(data),
			updateQtColors(data),
			generateTmuxColors(data),
		]).then(() => {
			reloadTmux();
			reloadFish();
			reloadNeovim(themeId);
		}).catch((e) => {
			console.error(`Stylesheet: Error applying external colors: ${e}`);
		});
	}
}
