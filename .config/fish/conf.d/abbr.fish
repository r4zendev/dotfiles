function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

abbr v "nvim"
abbr n "nvim"
abbr p "pnpm"
abbr g "lazygit"
abbr d "lazydocker"
abbr ls "lsd -a"

abbr gs "git status"

abbr gd "git diff"
abbr gl "git log"
abbr gck "git checkout"

abbr ga "git add ."
abbr ga_ "git add"
abbr gc "git commit -m"
abbr gp "git push origin HEAD"
abbr gap "ga && gc wip && gp"

abbr gss "git stash"
abbr gsv "git add . && git stash"
abbr gsp "git stash pop"
abbr gca "git commit --amend --no-edit"
