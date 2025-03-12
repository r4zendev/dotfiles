function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# nul - ctrl-space
bind -k nul expand-abbr

abbr -a b "bun"
abbr -a v "nvim"
abbr -a p "pnpm"
abbr -a g "lazygit"
abbr -a d "lazydocker"
abbr -a ls "lsd -a"
abbr -a gdu "gdu-go"

abbr -a gs "git status"

abbr -a gd --position anywhere --set-cursor "nvim -c 'DiffviewOpen %'"
abbr -a gl "git log"
abbr -a gck "git checkout"

abbr -a ga "git add ."
abbr -a ga_ "git add"
abbr -a gc "git commit -m"
abbr -a gp "git push origin HEAD"
abbr -a gap "ga && gc wip && gp"

abbr -a gss "git stash"
abbr -a gsv "git add . && git stash"
abbr -a gsp "git stash pop"
abbr -a gca "git commit --amend --no-edit"

# lis-a t ffmpeg devices
abbr -a fdev "ffmpeg -f avfoundation -list_devices true -i ''"
# cap-a ture and save to random hash file
abbr -a frec --position anywhere --set-cursor "ffmpeg -f avfoundation -i '%:' -vf format=yuv420p -c:v libx264 -preset ultrafast -tune zerolatency -crf 23 -f mp4 '$HOME/projects/r4zendotdev/screen-recordings/output-$(openssl rand -hex 8).mp4'"
