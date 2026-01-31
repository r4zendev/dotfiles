#!/bin/bash
STATE_FILE="/tmp/hypr_opacity_full"
if [ -f "$STATE_FILE" ]; then
    hyprctl keyword decoration:inactive_opacity 0.9
    rm "$STATE_FILE"
else
    hyprctl keyword decoration:inactive_opacity 1.0
    touch "$STATE_FILE"
fi
