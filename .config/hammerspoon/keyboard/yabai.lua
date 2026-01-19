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

alt("f", { sequence = { "window --toggle zoom-fullscreen" } })
alt("r", { sequence = { "space --rotate 90" } })

-- stylua: ignore start
alt("a", { primary = "window --resize right:-20:0 2> /dev/null", fallback = "window --resize left:-20:0 2> /dev/null" })
alt("d", { primary = "window --resize right:20:0 2> /dev/null", fallback = "window --resize left:20:0 2> /dev/null" })
alt("left", { primary = "window --resize right:-20:0 2> /dev/null", fallback = "window --resize left:-20:0 2> /dev/null" })
alt("right", { primary = "window --resize right:20:0 2> /dev/null", fallback = "window --resize left:20:0 2> /dev/null" })
alt("up", { primary = "window --resize bottom:0:-20 2> /dev/null", fallback = "window --resize top:0:-20 2> /dev/null" })
alt("down", { primary = "window --resize bottom:0:20 2> /dev/null", fallback = "window --resize top:0:20 2> /dev/null" })
-- stylua: ignore end

alt("w", { sequence = { "space --balance" } })
alt("s", { sequence = { "space --rotate 180" } })

alt("t", { sequence = { "window --toggle float", "window --grid 4:4:1:1:2:2" } })
alt("e", { sequence = { "window --toggle split" } }) -- toggle window split type
alt("g", { sequence = { "space --toggle padding", "space --toggle gap" } })

hs.hotkey.bind({ "alt", "shift" }, "n", function()
  yabai({ sequence = { "space --create" } })

  local json_str = hs.execute("/opt/homebrew/bin/yabai -m query --spaces --display", true)
  local spaces = hs.json.decode(json_str)

  local index = nil
  for _, space in ipairs(spaces) do
    if not space["is-native-fullscreen"] then
      index = space.index
    end
  end

  yabai({ sequence = { "window --space " .. index } })
  yabai({ sequence = { "space --focus " .. index } })
end)

alt(";", { sequence = { "space --layout bsp" } })
alt("tab", { sequence = { "space --focus recent" } })

local homeRow = { h = "west", j = "south", k = "north", l = "east" }

alt("j", { primary = "window --focus prev", fallback = "window --focus last" }, 0.3, 0.1)
alt("k", { primary = "window --focus next", fallback = "window --focus first" }, 0.3, 0.1)
-- alt("h", { primary = "window --focus west" }, 0.3, 0.1)
-- alt("j", { primary = "window --focus south" }, 0.3, 0.1)
-- alt("k", { primary = "window --focus north" }, 0.3, 0.1)
-- alt("l", { primary = "window --focus east" }, 0.3, 0.1)

alt("m", { primary = "space --focus prev", fallback = "space --focus last" }, 0.3, 0.1)
alt(",", { primary = "space --focus next", fallback = "space --focus first" }, 0.3, 0.1)
alt(".", { primary = "space --focus last" }, 0.3, 0.1)

for key, direction in pairs(homeRow) do
  altShift(key, { sequence = { "window --swap " .. direction } })
end

for i = 1, 9 do
  local num = tostring(i)

  alt(num, { sequence = { "space --focus " .. num } })
  altShift(num, { sequence = { "window --space " .. num, "space --focus " .. num } })
end
