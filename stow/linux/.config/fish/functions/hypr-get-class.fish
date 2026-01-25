function hypr-get-class --description "Get window class from running Hyprland windows"
    if test (count $argv) -eq 0
        # Show all classes
        hyprctl clients -j | jq -r '.[] | .class' | sort -u
    else
        # Filter by pattern
        hyprctl clients -j | jq -r --arg pattern "$argv[1]" \
            '.[] | select(.class | test($pattern; "i")) | "\(.class) - \(.title)"'
    end
end
