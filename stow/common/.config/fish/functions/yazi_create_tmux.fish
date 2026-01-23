function yazi_create_tmux --description "Create a new tmux session from yazi file chooser"
    set tmp (mktemp)
    yazi --chooser-file="$tmp"
    set chosen (cat $tmp)
    rm $tmp

    if test -n "$chosen"
        test -d "$chosen" && set dir "$chosen" || set dir (dirname "$chosen")
        set name (basename "$dir" | tr "." "_")
        tmux new-session -c "$dir" -d -s "$name"
        tmux switch-client -t "$name"
        tmux send-keys -t "$name" "nvim '$chosen'" Enter
    end
end
