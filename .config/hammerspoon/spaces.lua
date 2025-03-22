local spaces = require("hs.spaces")
local menubar = hs.menubar.new()

local function updateMenubar()
	local currentSpaceID = spaces.focusedSpace()
	local allSpaces = spaces.allSpaces()

	local allSpaceIDs = {}
	for _, spaceList in pairs(allSpaces) do
		for _, spaceID in ipairs(spaceList) do
			table.insert(allSpaceIDs, spaceID)
		end
	end

	table.sort(allSpaceIDs)

	local currentPosition = 0
	for i, spaceID in ipairs(allSpaceIDs) do
		if spaceID == currentSpaceID then
			currentPosition = i
			break
		end
	end

	menubar:setTitle("💠 " .. currentPosition .. "/" .. #allSpaceIDs)
end

local appWatcher = hs.application.watcher.new(function(_, eventType, _)
	if eventType == hs.application.watcher.activated then
		updateMenubar()
	end
end)

local spaceTimer = hs.timer.new(2, updateMenubar)
spaceTimer:start()

appWatcher:start()
updateMenubar()
