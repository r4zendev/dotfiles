function frg --description "Interactive ripgrep search with live preview"
    # Initial query from arguments or empty
    set -l initial_query "$argv"

    set -l RG_PREFIX "rg --column --line-number --no-heading --color=always --smart-case --hidden"

    set -l selected (
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$initial_query' 2>/dev/null" \
        fzf --ansi \
            --disabled \
            --bind "change:reload:$RG_PREFIX {q} 2>/dev/null || true" \
            --bind "start:unbind(ctrl-r)" \
            --prompt "🔍  Search> " \
            --header "Type to search | ENTER: open file at line" \
            --border-label=" Live Ripgrep " \
            --delimiter : \
            --preview "bat --color=always --style=numbers,changes --highlight-line {2} {1}" \
            --preview-window 'up,70%,border-bottom,+{2}+3/3,wrap' \
            --color 'hl:-1:underline,hl+:-1:underline:reverse' \
            --query "$initial_query"
    )

    if test -n "$selected"
        set -l file (echo $selected | cut -d: -f1)
        set -l line (echo $selected | cut -d: -f2)
        eval $EDITOR "+$line" "$file"
    end
end
