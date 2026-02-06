#!/usr/bin/env bash

color=$(hyprpicker -al 2>/dev/null)

[ -z "$color" ] && exit 0

gdbus call --session \
    --dest org.freedesktop.Notifications \
    --object-path /org/freedesktop/Notifications \
    --method org.freedesktop.Notifications.Notify \
    "Color Picker" 0 "" \
    "<span foreground='$color'>$color</span> copied to clipboard" \
    "" '[]' '{"transient": <true>}' 5000 \
    > /dev/null
