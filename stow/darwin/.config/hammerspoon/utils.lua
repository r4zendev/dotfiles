local M = {}

M.repeatBind = function(mods, key, callback, delay, interval)
	local timer = nil

	hs.hotkey.bind(mods, key, function() -- Pressed
		callback() -- Execute immediately
		timer = hs.timer.doAfter(delay, function()
			timer = hs.timer.new(interval, callback):start()
		end)
	end, function() -- Released
		if timer then
			timer:stop()
			timer = nil
		end
	end)
end

return M
