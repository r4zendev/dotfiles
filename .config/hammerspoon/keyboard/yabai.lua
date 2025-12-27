-- https://github.com/koekeishiya/yabai
--
-- ██╗   ██╗ █████╗ ██████╗  █████╗ ██╗
-- ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗██║
--  ╚████╔╝ ███████║██████╔╝███████║██║
--   ╚██╔╝  ██╔══██║██╔══██╗██╔══██║██║
--    ██║   ██║  ██║██████╔╝██║  ██║██║
--    ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝

local utils = require("utils")

local function yabai(args)
  if type(args) == "table" then
    if args.primary then
      -- Try primary command, fallback if it fails
      if not os.execute("/opt/homebrew/bin/yabai -m " .. args.primary) and args.fallback then
        os.execute("/opt/homebrew/bin/yabai -m " .. args.fallback)
      end
    elseif args.sequence then
      -- Execute multiple commands in sequence
      for _, cmd in ipairs(args.sequence) do
        os.execute("/opt/homebrew/bin/yabai -m " .. cmd)
      end
    end
  end
end

local function alt(key, commands, delay, interval)
  utils.repeatBind({ "alt" }, key, function()
    yabai(commands)
  end, delay or 0.1, interval or 0.01)
end

local function altShift(key, commands, delay, interval)
  utils.repeatBind({ "alt", "shift" }, key, function()
    yabai(commands)
  end, delay or 0.1, interval or 0.01)
end

--
--
--
-- Alpha (rotation, resizing, other actions)
alt("f", { sequence = { "window --toggle zoom-fullscreen" } })
alt("r", { sequence = { "space --rotate 90" } })

-- stylua: ignore start
alt("a", {primary = "window --resize right:-20:0 2> /dev/null", fallback = "window --resize left:-20:0 2> /dev/null",})
alt("d", {primary = "window --resize right:20:0 2> /dev/null", fallback = "window --resize left:20:0 2> /dev/null",})
-- stylua: ignore end

alt("w", { sequence = { "space --balance" } })
alt("s", { sequence = { "space --rotate 180" } })
-- alt("w", { primary = "window --resize right:-20:0 2> /dev/null", fallback = "window --resize left:-20:0 2> /dev/null" })
-- alt("s", { primary = "window --resize right:-20:0 2> /dev/null", fallback = "window --resize left:-20:0 2> /dev/null" })

-- using alt+t in claude because they don't allow to rebind 🤡
altShift("t", { sequence = { "window --toggle float", "window --grid 4:4:1:1:2:2" } })
alt("e", { sequence = { "window --toggle split" } }) -- toggle window split type
alt("g", { sequence = { "space --toggle padding", "space --toggle gap" } })

-- create desktop, move window and follow focus
hs.hotkey.bind({ "alt", "shift" }, "n", function()
  -- Create new space
  yabai({ sequence = { "space --create" } })

  -- Capture output of yabai displays
  local json_str = hs.execute("/opt/homebrew/bin/yabai -m query --spaces --display", true)

  -- Decode json to table
  local spaces = hs.json.decode(json_str)

  -- Find last active window index (non-fullscreen)
  local index = nil
  for _, space in ipairs(spaces) do
    if not space["is-native-fullscreen"] then
      index = space.index
    end
  end

  -- Move window and switch to new space
  yabai({ sequence = { "window --space " .. index } })
  yabai({ sequence = { "space --focus " .. index } })
end)

-- special characters
alt(";", { sequence = { "space --layout bsp" } })
alt("tab", { sequence = { "space --focus recent" } })

--
--
--
-- Home row (cycle/swap windows & cycle spaces)
local homeRow = { h = "west", j = "south", k = "north", l = "east" }

-- Cycle windows
alt("j", { primary = "window --focus prev", fallback = "window --focus last" }, 0.3, 0.1)
alt("k", { primary = "window --focus next", fallback = "window --focus first" }, 0.3, 0.1)
-- alt("h", { primary = "window --focus west" }, 0.3, 0.1)
-- alt("j", { primary = "window --focus south" }, 0.3, 0.1)
-- alt("k", { primary = "window --focus north" }, 0.3, 0.1)
-- alt("l", { primary = "window --focus east" }, 0.3, 0.1)

-- Cycle spaces
alt("m", { primary = "space --focus prev", fallback = "space --focus last" }, 0.3, 0.1)
alt(",", { primary = "space --focus next", fallback = "space --focus first" }, 0.3, 0.1)
alt(".", { primary = "space --focus last" }, 0.3, 0.1)

-- Swap windows
for key, direction in pairs(homeRow) do
  altShift(key, { sequence = { "window --swap " .. direction } })
end

--
--
--
-- Numbers (focus desktops or move windows to them)
for i = 1, 9 do
  local num = tostring(i)

  alt(num, { sequence = { "space --focus " .. num } })
  altShift(num, { sequence = { "window --space " .. num, "space --focus " .. num } })
end
