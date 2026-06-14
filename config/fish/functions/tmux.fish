function tmux --wraps tmux --description 'Attach to an existing session instead of spawning a new one'
    if test (count $argv) -gt 0
        command tmux $argv
        return
    end

    if command tmux has-session 2>/dev/null
        command tmux attach
        return
    end

    command tmux start-server
    if test -L ~/.local/share/tmux/resurrect/last
        for i in (seq 30)
            command tmux has-session 2>/dev/null; and break
            sleep 0.1
        end
    end
    command tmux attach 2>/dev/null; or command tmux new-session
end
