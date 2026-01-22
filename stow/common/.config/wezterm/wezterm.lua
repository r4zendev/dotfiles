local wezterm = require("wezterm")
local act = wezterm.action

local function init_global(key, default)
  if wezterm.GLOBAL[key] == nil then
    wezterm.GLOBAL[key] = default
  end
  return wezterm.GLOBAL[key]
end

local is_darwin = wezterm.target_triple and wezterm.target_triple:find("darwin") ~= nil
local enable_background_images = is_darwin
local primary_mod = is_darwin and "CMD" or "CTRL"
local primary_shift_mod = primary_mod .. "|SHIFT"

local background_enabled = enable_background_images and init_global("minimal_mode", true) or false
local allow_nsfw = init_global("allow_nsfw", false)
local allow_restricted = init_global("allow_restricted", false)
local allow_explicit = init_global("allow_explicit", false)
local exclude_default = init_global("exclude_default", false)
local current_background_image = wezterm.GLOBAL.current_background_image
local background_brightness = init_global("background_brightness", 0.05)

local config = wezterm.config_builder and wezterm.config_builder() or {}

local default_shell = os.getenv("SHELL") or "fish"
config.default_prog = { default_shell }
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
config.hide_mouse_cursor_when_typing = true
config.use_ime = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"
config.window_padding = { left = 12, right = 12, top = 8, bottom = 8 }
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.inactive_pane_hsb = { saturation = 0.24, brightness = 0.5 }
config.selection_word_boundary = " \t\n{}[]()\"'`,;:│"

config.keys = {
  { key = "l", mods = primary_mod, action = act.ShowDebugOverlay },
}

if enable_background_images then
  table.insert(config.keys, { key = "w", mods = primary_shift_mod, action = act.EmitEvent("toggle-nsfw") })
  table.insert(config.keys, { key = "t", mods = primary_shift_mod, action = act.EmitEvent("toggle-restricted") })
  table.insert(config.keys, { key = "e", mods = primary_shift_mod, action = act.EmitEvent("toggle-explicit") })
  table.insert(config.keys, { key = "d", mods = primary_shift_mod, action = act.EmitEvent("toggle-default") })
  table.insert(config.keys, { key = "m", mods = primary_shift_mod, action = act.EmitEvent("toggle-background-image") })
  table.insert(config.keys, { key = "r", mods = primary_shift_mod, action = act.EmitEvent("refresh-background-image") })
  table.insert(config.keys, { key = "i", mods = primary_shift_mod, action = act.EmitEvent("show-background-image-path") })
  table.insert(config.keys, { key = ";", mods = primary_shift_mod, action = act.EmitEvent("increase-background-brightness") })
  table.insert(config.keys, { key = ".", mods = primary_shift_mod, action = act.EmitEvent("decrease-background-brightness") })
end

local IMAGES_DIR = wezterm.home_dir .. "/.config/term-images"
local BRIGHTNESS_STEP = 0.05

local function is_image(filename)
  return filename:match("%.jpg$")
    or filename:match("%.jpeg$")
    or filename:match("%.png$")
    or filename:match("%.gif$")
end

local function load_images_from_dir(dir)
  local images = {}
  local success, stdout = wezterm.run_child_process({ "ls", dir })
  if success then
    for filename in string.gmatch(stdout, "[^\r\n]+") do
      if is_image(filename) then
        table.insert(images, dir .. "/" .. filename)
      end
    end
  end
  return images
end

local function get_background_images()
  local images = {}
  local success = wezterm.run_child_process({ "test", "-d", IMAGES_DIR })
  if not success then
    return images
  end

  if not exclude_default then
    images = load_images_from_dir(IMAGES_DIR)
  end

  if allow_nsfw then
    local nsfw_dir = IMAGES_DIR .. "/nsfw"
    if wezterm.run_child_process({ "test", "-d", nsfw_dir }) then
      for _, img in ipairs(load_images_from_dir(nsfw_dir)) do
        table.insert(images, img)
      end
    end
  end

  if allow_restricted then
    local restricted_dir = IMAGES_DIR .. "/restricted"
    if wezterm.run_child_process({ "test", "-d", restricted_dir }) then
      for _, img in ipairs(load_images_from_dir(restricted_dir)) do
        table.insert(images, img)
      end
    end
  end

  if allow_explicit then
    local explicit_dir = IMAGES_DIR .. "/explicit"
    if wezterm.run_child_process({ "test", "-d", explicit_dir }) then
      for _, img in ipairs(load_images_from_dir(explicit_dir)) do
        table.insert(images, img)
      end
    end
  end

  return images
end

local function create_background_layers(image_path, brightness)
  return {
    { source = { Color = config.colors.background }, width = "100%", height = "100%", opacity = 1 },
    {
      source = { File = image_path },
      width = "Cover",
      height = "100%",
      horizontal_align = "Center",
      repeat_x = "NoRepeat",
      opacity = 1,
      hsb = { brightness = brightness, hue = 1.0, saturation = 1.0 },
    },
  }
end

local function apply_background(window, image_path, brightness)
  window:set_config_overrides({ background = create_background_layers(image_path, brightness) })
end

local function toggle_category(category_name, global_key)
  return function(window, _)
    local new_value = not wezterm.GLOBAL[global_key]
    wezterm.GLOBAL[global_key] = new_value
    if global_key == "allow_nsfw" then
      allow_nsfw = new_value
    elseif global_key == "allow_restricted" then
      allow_restricted = new_value
    elseif global_key == "allow_explicit" then
      allow_explicit = new_value
    elseif global_key == "exclude_default" then
      exclude_default = new_value
    end
    window:toast_notification(
      "WezTerm",
      category_name .. ": " .. (new_value and "ON" or "OFF"),
      nil,
      1000
    )
  end
end

if enable_background_images then
  wezterm.on("toggle-nsfw", toggle_category("NSFW mode", "allow_nsfw"))
  wezterm.on("toggle-restricted", toggle_category("Restricted mode", "allow_restricted"))
  wezterm.on("toggle-explicit", toggle_category("Explicit mode", "allow_explicit"))
  wezterm.on("toggle-default", toggle_category("Exclude default", "exclude_default"))
end

wezterm.on("refresh-background-image", function(window, _)
  if not enable_background_images then
    return
  end
  if not background_enabled then
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
  apply_background(window, image_path, background_brightness)
end)

wezterm.on("toggle-background-image", function(window, _)
  if not enable_background_images then
    return
  end
  background_enabled = not background_enabled
  wezterm.GLOBAL.minimal_mode = background_enabled
  window:toast_notification(
    "WezTerm",
    "Background image: " .. (background_enabled and "ON" or "OFF"),
    nil,
    3000
  )

  if not background_enabled then
    window:set_config_overrides({
      background = {
        { source = { Color = "#000000" }, width = "100%", height = "100%", opacity = 1.0 },
      },
    })
  else
    if not current_background_image then
      local images = get_background_images()
      if #images > 0 then
        current_background_image = images[math.random(#images)]
        wezterm.GLOBAL.current_background_image = current_background_image
      end
    end
    if current_background_image then
      apply_background(window, current_background_image, background_brightness)
    end
  end
end)

wezterm.on("show-background-image-path", function(window, _)
  if not enable_background_images then
    return
  end
  if not background_enabled or not current_background_image then
    window:toast_notification("WezTerm", "No background image set", nil, 2000)
    return
  end

  local _, filename = string.match(current_background_image, "(.-)([^\\/]-%.?[^%.\\/]*)$")
  local copy_cmd = is_darwin and "pbcopy" or "wl-copy"
  local success = wezterm.run_child_process({
    "bash",
    "-c",
    "echo -n '" .. current_background_image .. "' | " .. copy_cmd,
  })

  window:toast_notification(
    "Current Background",
    (filename or current_background_image) .. (success and " (copied to clipboard)" or ""),
    nil,
    4000
  )
end)

local function adjust_brightness(window, delta)
  background_brightness = math.max(0.0, math.min(1.0, background_brightness + delta))
  wezterm.GLOBAL.background_brightness = background_brightness
  if background_enabled and current_background_image then
    apply_background(window, current_background_image, background_brightness)
  end
end

wezterm.on("increase-background-brightness", function(window, _)
  adjust_brightness(window, BRIGHTNESS_STEP)
end)

wezterm.on("decrease-background-brightness", function(window, _)
  adjust_brightness(window, -BRIGHTNESS_STEP)
end)

if enable_background_images then
  local images = get_background_images()
  if not current_background_image and #images > 0 then
    current_background_image = images[math.random(#images)]
    wezterm.GLOBAL.current_background_image = current_background_image
  end

  if current_background_image then
    config.background = create_background_layers(current_background_image, background_brightness)
  end
end

return config
