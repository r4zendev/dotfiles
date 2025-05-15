local wezterm = require("wezterm")
local act = wezterm.action

-- Use persistent state to store NSFW mode and current background image
local background_image = wezterm.GLOBAL.minimal_mode
if background_image == nil then
  background_image = true
  wezterm.GLOBAL.minimal_mode = background_image
end

local allow_nsfw = wezterm.GLOBAL.allow_nsfw
if allow_nsfw == nil then
  allow_nsfw = false
  wezterm.GLOBAL.allow_nsfw = allow_nsfw
end

-- Store current background image path
local current_background_image = wezterm.GLOBAL.current_background_image

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
  { family = "JetBrains Mono", scale = 1.2, weight = "Bold" },
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
      { family = "JetBrains Mono", scale = 1.2, weight = "Bold" },
    }),
  },
}

config.font_size = 16.0
config.adjust_window_size_when_changing_font_size = false

config.cursor_blink_rate = 0

config.send_composed_key_when_right_alt_is_pressed = false
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
  { key = "l", mods = "CMD", action = act.ShowDebugOverlay },
  { key = "w", mods = "CMD|SHIFT", action = act.EmitEvent("toggle-nsfw") },
  { key = "m", mods = "CMD|SHIFT", action = act.EmitEvent("toggle-background-image") },
  { key = "r", mods = "CMD|SHIFT", action = act.EmitEvent("refresh-background-image") },
  { key = "i", mods = "CMD|SHIFT", action = act.EmitEvent("show-background-image-path") },
}

-----------------------------------------------------------
-- Background image
-----------------------------------------------------------

local BACKGROUND_IMAGE_WIDTH = "Cover"
local BACKGROUND_COLOR_OPACITY = 1
local BACKGROUND_IMAGE_OPACITY = 1

local function is_image(filename)
  return filename:match("%.jpg$")
    or filename:match("%.jpeg$")
    or filename:match("%.png$")
    or filename:match("%.gif$")
end

local function get_background_images()
  local images = {}
  local images_dir = wezterm.home_dir .. "/.config/wezterm/images"

  local success, _, _ = wezterm.run_child_process({ "test", "-d", images_dir })
  if not success then
    wezterm.log_warn("Images directory doesn't exist: " .. images_dir)
    return images
  end

  local success, stdout, _ = wezterm.run_child_process({ "ls", images_dir })
  if success then
    for filename in string.gmatch(stdout, "[^\r\n]+") do
      if is_image(filename) then
        table.insert(images, images_dir .. "/" .. filename)
      end
    end
  end

  if allow_nsfw then
    local nsfw_dir = images_dir .. "/nsfw"
    local nsfw_success, _, _ = wezterm.run_child_process({ "test", "-d", nsfw_dir })
    if nsfw_success then
      local nsfw_success, nsfw_stdout, _ = wezterm.run_child_process({ "ls", nsfw_dir })
      if nsfw_success then
        for filename in string.gmatch(nsfw_stdout, "[^\r\n]+") do
          if is_image(filename) then
            table.insert(images, nsfw_dir .. "/" .. filename)
          end
        end
      end
    else
      wezterm.log_warn("NSFW directory doesn't exist: " .. nsfw_dir)
    end
  end

  return images
end

wezterm.on("toggle-nsfw", function(window, _)
  allow_nsfw = not allow_nsfw

  wezterm.GLOBAL.allow_nsfw = allow_nsfw

  local status_message = "NSFW mode: " .. (allow_nsfw and "ON" or "OFF")
  wezterm.log_info(status_message)

  window:toast_notification("WezTerm", status_message, nil, 1000)
end)

wezterm.on("refresh-background-image", function(window, _)
  if not background_image then
    window:toast_notification("WezTerm", "Background image is OFF", nil, 1500)
    return
  end

  local images = get_background_images()

  if #images == 0 then
    window:toast_notification("WezTerm", "No background images found", nil, 3000)
    return
  end

  local image_path = images[math.random(#images)]
  current_background_image = image_path
  wezterm.GLOBAL.current_background_image = image_path

  window:set_config_overrides({
    background = {
      {
        source = { Color = config.colors.background or "black" },
        width = "100%",
        height = "100%",
        opacity = BACKGROUND_COLOR_OPACITY,
      },
      {
        source = { File = image_path },
        width = BACKGROUND_IMAGE_WIDTH,
        height = "100%",
        horizontal_align = "Center",
        repeat_x = "NoRepeat",
        opacity = BACKGROUND_IMAGE_OPACITY,
        hsb = { brightness = 0.05, hue = 1.0, saturation = 1.0 },
      },
    },
  })

  -- window:toast_notification("WezTerm", "Background refreshed", nil, 1500)
end)

wezterm.on("toggle-background-image", function(window, _)
  background_image = not background_image
  wezterm.GLOBAL.minimal_mode = background_image

  local status_message = "Background image: " .. (background_image and "ON" or "OFF")
  wezterm.log_info(status_message)

  window:toast_notification("WezTerm", status_message, nil, 3000)

  if not background_image then
    window:set_config_overrides({
      background = {
        {
          source = { Color = "#000000" },
          width = "100%",
          height = "100%",
          opacity = 1.0,
        },
      },
    })
  else
    -- Ensure we have a current background image set
    if not current_background_image then
      local images = get_background_images()
      if #images > 0 then
        current_background_image = images[math.random(#images)]
        wezterm.GLOBAL.current_background_image = current_background_image
      end
    end

    -- Always use the stored current_background_image when toggling back on
    if current_background_image then
      window:set_config_overrides({
        background = {
          {
            source = { Color = config.colors.background or "black" },
            width = "100%",
            height = "100%",
            opacity = BACKGROUND_COLOR_OPACITY,
          },
          {
            source = { File = current_background_image },
            width = BACKGROUND_IMAGE_WIDTH,
            height = "100%",
            horizontal_align = "Center",
            repeat_x = "NoRepeat",
            opacity = BACKGROUND_IMAGE_OPACITY,
            hsb = { brightness = 0.05, hue = 1.0, saturation = 1.0 },
          },
        },
      })
    end
  end
end)

wezterm.on("show-background-image-path", function(window, _)
  if not background_image then
    window:toast_notification("WezTerm", "Background image is OFF", nil, 2000)
    return
  end

  if not current_background_image then
    window:toast_notification("WezTerm", "No background image set", nil, 2000)
    return
  end

  -- Extract just the filename from the path
  local _, filename = string.match(current_background_image, "(.-)([^\\/]-%.?[^%.\\/]*)$")

  -- Copy the full path to clipboard
  local success, _, _ = wezterm.run_child_process({
    "bash",
    "-c",
    "echo -n '" .. current_background_image .. "' | pbcopy",
  })
  local clipboard_message = success and " (copied to clipboard)" or ""

  window:toast_notification(
    "Current Background",
    (filename or current_background_image) .. clipboard_message,
    nil,
    4000
  )
end)

local images = get_background_images()

if not current_background_image and #images > 0 then
  current_background_image = images[math.random(#images)]
  wezterm.GLOBAL.current_background_image = current_background_image
end

local image_to_use = current_background_image
if not image_to_use and #images > 0 then
  image_to_use = images[math.random(#images)]

  current_background_image = image_to_use
  wezterm.GLOBAL.current_background_image = current_background_image
end

config.background = {
  {
    source = { Color = config.colors.background or "black" },
    width = "100%",
    height = "100%",
    opacity = BACKGROUND_COLOR_OPACITY,
  },
  {
    source = { File = image_to_use },

    width = BACKGROUND_IMAGE_WIDTH,
    height = "100%",
    horizontal_align = "Center",
    repeat_x = "NoRepeat",

    opacity = BACKGROUND_IMAGE_OPACITY,
    hsb = { brightness = 0.05, hue = 1.0, saturation = 1.0 },
  },
}

return config
