local wezterm = require("wezterm")
local act = wezterm.action

local fish_path = "/opt/homebrew/bin/fish"

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.default_prog = { fish_path }
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
	{
		family = "Monaspace Argon",
		scale = 1.2,
		weight = "Medium",
		harfbuzz_features = { "calt", "ss01", "ss02", "ss03", "ss04" },
	},
	-- Monaspace не поддерживает кириллицу.
	{ family = "Inconsolata LGC Nerd Font Mono", scale = 1.2, weight = "Bold" },
})
config.font_rules = {
	{
		italic = true,
		font = wezterm.font_with_fallback({
			{
				family = "Monaspace Argon",
				scale = 1.2,
				weight = "Medium",
				harfbuzz_features = { "calt", "ss01", "ss02", "ss03", "ss04" },
			},
			{ family = "Inconsolata LGC Nerd Font Mono", scale = 1.2, weight = "Bold" },
		}),
	},
}
config.font_size = 18.0

-- Window settings
config.window_background_opacity = 0.6
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

	-- Doesn't seem to work in tmux (Shift-Left click works though)
	--
	-- {
	-- 	event = { Up = { streak = 1, button = "Left" } },
	-- 	mods = "CMD",
	-- 	action = wezterm.action.Multiple({
	-- 		wezterm.action.OpenLinkAtMouseCursor,
	-- 		wezterm.action.Nop,
	-- 	}),
	-- },
}

-- send <c-t>N on ctrl-N
-- nvim config has bindings for harpoon tab using these
config.keys = {
	{ key = "1", mods = "CTRL", action = wezterm.action.SendString("\x14\x31") },
	{ key = "2", mods = "CTRL", action = wezterm.action.SendString("\x14\x32") },
	{ key = "3", mods = "CTRL", action = wezterm.action.SendString("\x14\x33") },
	{ key = "4", mods = "CTRL", action = wezterm.action.SendString("\x14\x34") },
	{ key = "5", mods = "CTRL", action = wezterm.action.SendString("\x14\x35") },
	{ key = "6", mods = "CTRL", action = wezterm.action.SendString("\x14\x36") },
	{ key = "7", mods = "CTRL", action = wezterm.action.SendString("\x14\x37") },
	{ key = "8", mods = "CTRL", action = wezterm.action.SendString("\x14\x38") },
	{ key = "9", mods = "CTRL", action = wezterm.action.SendString("\x14\x39") },
	-- { key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },
}

config.adjust_window_size_when_changing_font_size = true

config.send_composed_key_when_right_alt_is_pressed = false

config.cursor_blink_rate = 0

return config
