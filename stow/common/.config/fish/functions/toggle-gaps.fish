function toggle-gaps --description "Toggle Hyprland gaps between default and zero"
    set gaps_in (hyprctl -j getoption general:gaps_in | jq -r '.custom' | awk '{print $1}')

    if test "$gaps_in" = "0"
        hyprctl keyword general:gaps_in 8
        hyprctl keyword general:gaps_out 15
    else
        hyprctl keyword general:gaps_in 0
        hyprctl keyword general:gaps_out 0
    end
end
