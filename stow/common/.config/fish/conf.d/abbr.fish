# These always run last and override whatever
function fish_user_key_bindings
    bind ctrl-space 'commandline -i " "'
end

if test (uname) = Darwin
    abbr -a gdu gdu-go
    abbr -a gimp "open /Applicatons/GIMP.app"
end

abbr -a b bun
abbr -a v nvim
abbr -a p pnpm
abbr -a cc "claude --dangerously-skip-permissions"
abbr -a ccr "claude --dangerously-skip-permissions --resume"
abbr -a oc opencode
abbr -a ls "lsd --group-dirs first -A"
abbr -a yt youtube-tui

abbr -a gs "git status"
abbr -a gd "git diff"
abbr -a gl "git log"
abbr -a gck "git checkout"
abbr -a grh "git reset --hard && git clean -fd"
abbr -a gcl "git clean -fdx"

abbr -a ga "git add ."
abbr -a gc --position anywhere --set-cursor 'git commit -m "%"'
abbr -a gp "git push origin HEAD"
abbr -a gwip "ga && gc wip && gp"
abbr -a gca "git commit --amend --no-edit"

abbr -a gss "git add . && git stash"
abbr -a gsp "git stash pop"

abbr -a gdd --position anywhere --set-cursor 'nvim -c "DiffviewOpen %"'
abbr -a gd1 --position anywhere --set-cursor 'nvim -c "DiffviewOpen HEAD~1%..HEAD"'
