#!/usr/bin/env bash
STATE_FILE="/tmp/hypr_opacity_full"
poke='hl.window_rule({ name = "refresh-poke", match = { class = "^never-match$" }, enabled = false })'
if [ -f "$STATE_FILE" ]; then
    hyprctl eval "hl.config({ decoration = { inactive_opacity = 0.9 } }) $poke"
    rm "$STATE_FILE"
else
    hyprctl eval "hl.config({ decoration = { inactive_opacity = 1.0 } }) $poke"
    touch "$STATE_FILE"
fi
