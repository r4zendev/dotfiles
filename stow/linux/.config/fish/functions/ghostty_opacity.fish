function ghostty_opacity --description "Adjust Ghostty background opacity"
    set -l bg_file "$HOME/.config/ghostty/background"
    set -l state_file "$HOME/.config/ghostty/.opacity-state"

    function _reload_ghostty
        # Trigger Ghostty to reload config using Hyprland's native sendshortcut
        pgrep -x ghostty &>/dev/null; or return

        set -l ghostty_addresses (hyprctl clients -j | jq -r '.[] | select(.class == "com.mitchellh.ghostty") | .address')
        test -n "$ghostty_addresses"; or return

        set -l current_window (hyprctl activewindow -j | jq -r '.address')

        for address in $ghostty_addresses
            hyprctl dispatch focuswindow "address:$address" &>/dev/null
            sleep 0.1
            hyprctl dispatch sendshortcut "CTRL SHIFT, comma, address:$address" &>/dev/null
        end

        # Restore focus to original window
        test -n "$current_window"; and hyprctl dispatch focuswindow "address:$current_window" &>/dev/null
    end

    # Get current opacity from state file or default to 0.8
    set -l current 0.8
    test -f "$state_file"; and set current (cat "$state_file")

    switch $argv[1]
        case up increase
            set current (math "min(1.0, $current + 0.05)")
        case down decrease
            set current (math "max(0.0, $current - 0.05)")
        case set
            test -n "$argv[2]"; and set current $argv[2]
        case '*'
            echo "Usage: ghostty_opacity {up|down|set <value>}"
            return 1
    end

    # Save state and write to background file
    echo $current >"$state_file"
    echo "background-opacity = $current" >"$bg_file"

    _reload_ghostty
    echo "Opacity: $current"
end
