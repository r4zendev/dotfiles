function hide-apps --description "Toggle app visibility in fuzzel launcher"
    set override_dir "$HOME/.local/share/applications"
    mkdir -p $override_dir

    # Get all .desktop files
    set all_apps (find /usr/share/applications ~/.local/share/applications -name "*.desktop" -printf "%f\n" 2>/dev/null | sort -u)

    # Build menu
    set menu_items
    for app in $all_apps
        # Try to get app name
        set app_name (grep -m1 "^Name=" "/usr/share/applications/$app" 2>/dev/null | cut -d= -f2)
        if test -z "$app_name"
            set app_name (grep -m1 "^Name=" "$override_dir/$app" 2>/dev/null | cut -d= -f2)
        end

        # Check if hidden
        if test -f "$override_dir/$app"; and grep -q "NoDisplay=true" "$override_dir/$app" 2>/dev/null
            set menu_items $menu_items "[HIDDEN] $app_name ($app)"
        else
            set menu_items $menu_items "$app_name ($app)"
        end
    end

    # Show fuzzel menu
    set selection (printf '%s\n' $menu_items | fuzzel --dmenu --prompt="Toggle app: " --width=60)

    if test -n "$selection"
        # Extract desktop filename
        set desktop_file (string match -r '\([^)]+\)$' "$selection" | string trim -c '()')

        if string match -q "[HIDDEN]*" "$selection"
            # Unhide the app
            rm "$override_dir/$desktop_file" 2>/dev/null
            set cleaned_name (string replace "[HIDDEN] " "" "$selection")
            notify-send "App Unhidden" "$cleaned_name" -t 2000
        else
            # Hide the app
            echo -e "[Desktop Entry]\nNoDisplay=true" > "$override_dir/$desktop_file"
            notify-send "App Hidden" "$selection" -t 2000
        end
    end
end
