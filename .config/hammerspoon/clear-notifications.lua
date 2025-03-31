hs.hotkey.bind({ "ctrl", "alt" }, "C", function()
	-- Get the screen dimensions
	local screen = hs.screen.mainScreen()
	local frame = screen:frame()

	-- Calculate position for top-right corner notification center button
	-- The button is typically in the top-right corner, a bit inset from the edge
	local notificationCenterX = frame.w - 15
	local notificationCenterY = 15

	-- Save current mouse position to restore later
	local originalMousePosition = hs.mouse.getAbsolutePosition()

	-- Move mouse to notification center button position and click to open
	hs.mouse.setAbsolutePosition({ x = notificationCenterX, y = notificationCenterY })
	hs.timer.usleep(100000) -- 100ms delay
	hs.eventtap.leftClick({ x = notificationCenterX, y = notificationCenterY })

	-- Wait for notification center to open
	hs.timer.usleep(500000) -- 500ms delay

	-- Clear notifications
	hs.task
		.new("/usr/bin/osascript", nil, {
			"-l",
			"JavaScript",
			os.getenv("HOME") .. "/.config/hammerspoon/jxa/close-notifications.js",
		})
		:start()

	-- Wait for notifications to be cleared
	hs.timer.usleep(500000) -- 500ms delay

	-- Click again to close the notification center
	hs.mouse.setAbsolutePosition({ x = notificationCenterX, y = notificationCenterY })
	hs.timer.usleep(100000) -- 100ms delay
	hs.eventtap.leftClick({ x = notificationCenterX, y = notificationCenterY })

	-- Restore original mouse position
	hs.timer.usleep(100000) -- 100ms delay
	hs.mouse.setAbsolutePosition(originalMousePosition)

	hs.alert.show("Cleared notifications")
end)
