local modal = hs.hotkey.modal.new()
local fish = "/opt/homebrew/bin/fish"
local src = "source ~/.config/fish/conf.d/functions.fish; ghostty_bg "

local function reload()
  hs.timer.doAfter(0.05, function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Ghostty" then
      hs.eventtap.keyStroke({"cmd", "shift"}, ",", 0, app)
    end
  end)
end

local function run(cmd, doReload)
  hs.task.new(fish, function() if doReload ~= false then reload() end end, {"-c", src .. cmd}):start()
end

local function toggle(cmd, label)
  hs.task.new(fish, function()
    hs.task.new(fish, function(_, out)
      local val = out:match(label .. ": (%a+)")
      hs.alert.show(label .. ": " .. (val == "true" and "ON" or "OFF"), 1)
    end, {"-c", src .. "status"}):start()
  end, {"-c", src .. cmd}):start()
end

modal:bind({"cmd", "shift"}, "m", function() run("toggle") end)
modal:bind({"cmd", "shift"}, "r", function() run("random") end)
modal:bind({"cmd", "shift"}, "w", function() toggle("toggle-nsfw", "nsfw") end)
modal:bind({"cmd", "shift"}, "t", function() toggle("toggle-restricted", "restricted") end)
modal:bind({"cmd", "shift"}, "e", function() toggle("toggle-explicit", "explicit") end)
modal:bind({"cmd", "shift"}, "d", function() toggle("toggle-default", "exclude_default") end)
modal:bind({"cmd", "shift"}, "i", function() run("show", false) end)
modal:bind({"cmd", "shift"}, ";", function() run("brightness-up") end)
modal:bind({"cmd", "shift"}, ".", function() run("brightness-down") end)

local filter = hs.window.filter.new("Ghostty")
filter:subscribe(hs.window.filter.windowFocused, function() modal:enter() end)
filter:subscribe(hs.window.filter.windowUnfocused, function() modal:exit() end)

hs.application.watcher.new(function(name, event)
  if event == hs.application.watcher.activated then
    if name == "Ghostty" then modal:enter() else modal:exit() end
  elseif event == hs.application.watcher.deactivated and name == "Ghostty" then
    modal:exit()
  end
end):start()

modal:exit()
