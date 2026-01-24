function fkill --description "Kill processes with fzf selection"
    set -l pids (
        ps -eo pid,ppid,user,%cpu,%mem,stat,start,time,command --sort=-%mem |
        tail -n +2 |
        fzf \
            --multi \
            --no-preview \
            --prompt "💀  Kill> " \
            --header "TAB: select | CTRL-S: toggle all | ALT-C: sort CPU | ALT-M: sort MEM | ENTER: kill" \
            --border-label=" Process Manager (sorted by MEM) " \
            --bind "ctrl-s:toggle-all" \
            --bind "alt-c:change-border-label( Process Manager (sorted by CPU) )+reload(ps -eo pid,ppid,user,%cpu,%mem,stat,start,time,command --sort=-%cpu | tail -n +2)" \
            --bind "alt-m:change-border-label( Process Manager (sorted by MEM) )+reload(ps -eo pid,ppid,user,%cpu,%mem,stat,start,time,command --sort=-%mem | tail -n +2)" |
        awk '{print $1}'
    )

    if test -n "$pids"
        for pid in $pids
            echo "Killing process $pid..."
            kill -TERM $pid 2>/dev/null
            or kill -KILL $pid 2>/dev/null
        end
    end
end
