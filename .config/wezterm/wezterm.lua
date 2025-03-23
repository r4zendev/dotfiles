local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_prog = { "/opt/homebrew/bin/fish" }
config.term = "xterm-256color"

config.colors = {
	foreground = "#a6accd",
	background = "#252b37",

	ansi = {
		"#252b37",
		"#d0679d",
		"#5de4c7",
		"#fffac2",
		"#89ddff",
		"#fae4fc",
		"#add7ff",
		"#ffffff",
	},

	brights = {
		"#a6accd",
		"#d0679d",
		"#5de4c7",
		"#fffac2",
		"#add7ff",
		"#fcc5e9",
		"#89ddff",
		"#ffffff",
	},

	cursor_bg = "#a6accd",
	cursor_fg = "#252b37",
	cursor_border = "#a6accd",

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

config.font_size = 16.0
config.adjust_window_size_when_changing_font_size = false

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

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

config.hide_mouse_cursor_when_typing = true

config.selection_word_boundary = " \t\n{}[]()\"'`,;:│"

config.mouse_bindings = {}

config.window_background_opacity = 0.8
config.macos_window_background_blur = 40

wezterm.on("toggle-opacity-blur", function(window, _)
	local overrides = window:get_config_overrides() or {}

	if overrides.window_background_opacity or overrides.macos_window_background_blur then
		overrides.window_background_opacity = nil
		overrides.macos_window_background_blur = nil
	else
		overrides.window_background_opacity = 0.2
		overrides.macos_window_background_blur = 10
	end

	window:set_config_overrides(overrides)
end)

-- send <c-t>N on ctrl-N
-- nvim config has bindings for harpoon tab using these
config.keys = {
	{ key = "1", mods = "CTRL", action = act.SendString("\x14\x31") },
	{ key = "2", mods = "CTRL", action = act.SendString("\x14\x32") },
	{ key = "3", mods = "CTRL", action = act.SendString("\x14\x33") },
	{ key = "4", mods = "CTRL", action = act.SendString("\x14\x34") },
	{ key = "5", mods = "CTRL", action = act.SendString("\x14\x35") },
	{ key = "6", mods = "CTRL", action = act.SendString("\x14\x36") },
	{ key = "7", mods = "CTRL", action = act.SendString("\x14\x37") },
	{ key = "8", mods = "CTRL", action = act.SendString("\x14\x38") },
	{ key = "9", mods = "CTRL", action = act.SendString("\x14\x39") },
	{ key = "b", mods = "CMD", action = act.EmitEvent("toggle-opacity-blur") },
}

config.send_composed_key_when_right_alt_is_pressed = false

config.cursor_blink_rate = 0

return config
