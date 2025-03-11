---Toogles focus of a given app
---@param appName string
local toggleFocus = function(appName)
	local app = hs.application.get(appName)
	if app then
		if app:isFrontmost() then
			app:hide()
		else
			app:activate()
		end
	else
		hs.application.launchOrFocus(appName)
	end
end

local bindings = {
	{ "q", "QuickTime Player" },
	{ ".", "Settings" },
	{ "/", "Activity Monitor" },
	{ "p", "Finder", { { "cmd", "n" } } },
	{ "o", "Obsidian" },
	{ "b", "Brave" },
	{ "a", "WezTerm" },
	{ "z", "zoom.us" },
	-- NOTE: reserved for arrow keys
	-- { "h", "" },
	-- { "j", "" },
	-- { "k", "" },
	-- { "l", "" },
}

for _, app in ipairs(bindings) do
	hs.hotkey.bind({ "alt" }, app[1], function()
		toggleFocus(app[2])

		if app[3] then
			for _, key in ipairs(app[3]) do
				hs.eventtap.keyStroke(key[1], key[2])
			end
		end
	end)
end
