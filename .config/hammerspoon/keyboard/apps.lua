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
	{ ".", "Settings" },
	{ "/", "Activity Monitor" },
	{ "p", "Finder", { mods = { "cmd" }, keys = "n" } },
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
			hs.eventtap.keyStroke(app[3].mods, app[3].keys)
		end
	end)
end
