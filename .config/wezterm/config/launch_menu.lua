local global = require("global")

local launch_menu = {}

if global.is_macos then
  launch_menu = {
		{ label = "zsh", args = { "/opt/homebrew/bin/zsh" } },
		{ label = "fish", args = { "/opt/homebrew/bin/fish" } },
	}
elseif global.is_windows then
	launch_menu = {
		{
			label = "PowerShell Core",
			args = { "pwsh" },
		},
		{
			label = "Command Prompt",
			args = { "cmd" },
		},
		{
			label = "Git Bash",
			args = { "C:\\Program Files\\Git\\git-bash.exe" },
		},
		{
			label = "Windows PowerShell",
			args = { "powershell" },
		},
	}
end

return launch_menu
