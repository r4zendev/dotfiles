local wezterm = require("wezterm")
local act = wezterm.action

local zsh_path = "/opt/homebrew/bin/zsh"

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.default_prog = { zsh_path, "-l" }
config.term = "xterm-256color"

-- Appearance
config.colors = {
	-- Default colors
	foreground = "#a6accd",
	background = "#252b37",

	-- Normal colors
	ansi = {
		"#252b37", -- black
		"#d0679d", -- red
		"#5de4c7", -- green
		"#fffac2", -- yellow
		"#89ddff", -- blue
		"#fae4fc", -- magenta
		"#add7ff", -- cyan
		"#ffffff", -- white
	},

	-- Bright colors
	brights = {
		"#a6accd", -- bright black
		"#d0679d", -- bright red
		"#5de4c7", -- bright green
		"#fffac2", -- bright yellow
		"#add7ff", -- bright blue
		"#fcc5e9", -- bright magenta
		"#89ddff", -- bright cyan
		"#ffffff", -- bright white
	},

	-- Cursor colors
	cursor_bg = "#a6accd",
	cursor_fg = "#252b37",
	cursor_border = "#a6accd",

	-- Selection
	selection_fg = "none",
	selection_bg = "#303340",
}

config.font = wezterm.font_with_fallback({
	{ family = "Monaspace Xenon", scale = 1.2, weight = "DemiBold" },
	{ family = "JetBrains Mono", weight = "Medium" },
})
config.font_rules = {
	{
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "Monaspace Xenon", scale = 1.2, weight = "DemiBold" },
		}),
	},
}
config.font_size = 18.0

-- Window settings
config.window_background_opacity = 0.8
config.macos_window_background_blur = 40 -- Using a numeric value instead of boolean
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"
config.window_padding = {
	left = 18,
	right = 18,
	top = 16,
	bottom = 16,
}

-- Window/Tab/Pane Management
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

-- Mouse settings
config.hide_mouse_cursor_when_typing = true

-- Selection
config.selection_word_boundary = " \t\n{}[]()\"'`,;:│"

-- Mouse bindings
config.mouse_bindings = {
	-- Right click paste
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act.PasteFrom("Clipboard"),
	},
}

config.adjust_window_size_when_changing_font_size = true

return config
