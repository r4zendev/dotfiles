-- Reload config automatically
local configFileWatcher
local reloadConfig = function()
	hs.alert.show("Reloading...")
	configFileWatcher:stop()
	configFileWatcher = nil
	hs.reload()
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.config/hammerspoon/", reloadConfig)
configFileWatcher:start()

hs.notify.new({ title = "Hammerspoon", subTitle = "Hammerspoon config has successfully loaded." }):send()
