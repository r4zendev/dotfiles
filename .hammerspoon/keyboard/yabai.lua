-- https://github.com/koekeishiya/yabai
--
-- ██╗   ██╗ █████╗ ██████╗  █████╗ ██╗
-- ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗██║
--  ╚████╔╝ ███████║██████╔╝███████║██║
--   ╚██╔╝  ██╔══██║██╔══██╗██╔══██║██║
--    ██║   ██║  ██║██████╔╝██║  ██║██║
--    ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝

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

local function repeatBind(mods, key, commands, delay, interval)
	local timer = nil

	hs.hotkey.bind(mods, key, function() -- Pressed
		yabai(commands) -- Execute immediately
		timer = hs.timer.doAfter(delay, function()
			timer = hs.timer
				.new(interval, function()
					yabai(commands)
				end)
				:start()
		end)
	end, function() -- Released
		if timer then
			timer:stop()
			timer = nil
		end
	end)
end

local function alt(key, commands)
	repeatBind({ "alt" }, key, commands, 0.3, 0.1)
end

local function altShift(key, commands)
	repeatBind({ "alt", "shift" }, key, commands, 0.3, 0.1)
end

--
--
--
-- Alpha (rotation, resizing, other actions)
alt("f", { sequence = { "window --toggle zoom-fullscreen" } })
alt("r", { sequence = { "space --rotate 90" } })

alt("a", { primary = "window --resize right:-20:0 2> /dev/null", fallback = "window --resize left:-20:0 2> /dev/null" })
alt("d", { primary = "window --resize right:20:0 2> /dev/null", fallback = "window --resize left:20:0 2> /dev/null" })

alt("w", { sequence = { "space --balance" } })
alt("s", { sequence = { "space --rotate 180" } })
-- alt("w", { primary = "window --resize right:-20:0 2> /dev/null", fallback = "window --resize left:-20:0 2> /dev/null" })
-- alt("s", { primary = "window --resize right:-20:0 2> /dev/null", fallback = "window --resize left:-20:0 2> /dev/null" })

alt("t", { sequence = { "window --toggle float", "window --grid 4:4:1:1:2:2" } })
alt("e", { sequence = { "window --toggle split" } }) -- toggle window split type

-- create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
-- shift + alt - n : yabai -m space --create && \
--                    index="$(yabai -m query --spaces --display | jq 'map(select(."native-fullscreen" == 0))[-1].index')" && \
--                    yabai -m window --space "${index}" && \
--                    yabai -m space --focus "${index}"

-- alt("a", { sequence = { "window --rotate 90" } })
-- alt("d", { sequence = { "space --rotate 90" } })
-- alt("t", { sequence = { "window --toggle float", "window --grid 4:4:1:1:2:2" } })
--
-- alt("l", { sequence = { "space --focus recent" } })
-- alt("m", { sequence = { "space --toggle mission-control" } })
-- alt("p", { sequence = { "window --toggle pip" } })
-- alt("g", { sequence = { "space --toggle padding", "space --toggle gap" } })

-- special characters
alt("'", { sequence = { "space --layout stack" } })
alt(";", { sequence = { "space --layout bsp" } })
alt("tab", { sequence = { "space --focus recent" } })

--
--
--
-- Home row (focus between windows or swap them)
local homeRow = { h = "west", j = "south", k = "north", l = "east" }

-- Cycle windows
alt("j", { primary = "window --focus prev", fallback = "window --focus last" })
alt("k", { primary = "window --focus next", fallback = "window --focus first" })

-- Cycle spaces
alt("h", { primary = "space --focus prev", fallback = "space --focus last" })
alt("l", { primary = "space --focus next", fallback = "space --focus first" })

-- Swap windows
for key, direction in pairs(homeRow) do
	-- alt(key, { sequence = { "window --focus " .. direction } })
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
