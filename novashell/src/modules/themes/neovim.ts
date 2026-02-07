import { execAsync } from "ags/process";

const NOVASHELL_TO_NVIM_THEME: Record<string, string> = {
	"Tokyo Night": "Tokyo Night",
	Everforest: "Everforest",
	"Catppuccin Mocha": "Catppuccin",
};

export function reloadNeovim(themeName?: string): void {
	const nvimTheme = (themeName && NOVASHELL_TO_NVIM_THEME[themeName]) || "System (pywal)";
	const escaped = nvimTheme.replace(/'/g, "\\'");
	execAsync([
		"bash", "-c",
		`for sock in /run/user/1000/nvim.*.0; do [ -e "$sock" ] && nvim --server "$sock" --remote-send ':lua require("core.colorscheme").apply("${escaped}")<CR>' 2>/dev/null; done`,
	])
		.then(() => {})
		.catch(() => {});
}
