function fgit --description "Browse and open git tracked files with fzf"
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Not in a git repository"
        return 1
    end

    set -l preview_script 'bash -c \'
        if [ -d "{}" ]; then
            eza --tree --level=2 --icons --all --color=always --group-directories-first "{}"
        else
            bat --color=always --style=numbers,changes,header --line-range=:500 "{}"
        fi
    \''

    set -l selected (
        git ls-files 2>/dev/null |
        fzf \
            --prompt "🌳  Git Files> " \
            --header "ALT-M: modified | ALT-S: all tracked | ALT-U: untracked | ENTER: edit" \
            --preview "$preview_script" \
            --preview-window "right:60%:border-left:wrap" \
            --border-label=" Git Repository " \
            --bind "ctrl-/:toggle-preview" \
            --bind "ctrl-d:half-page-down" \
            --bind "ctrl-u:half-page-up" \
            --bind "alt-m:change-prompt(📝  Modified> )+reload(git diff --name-only)" \
            --bind "alt-s:change-prompt(🌳  Git Files> )+reload(git ls-files)" \
            --bind "alt-u:change-prompt(  Untracked> )+reload(git ls-files --others --exclude-standard)"
    )

    if test -n "$selected"
        eval $EDITOR "$selected"
    end
end
