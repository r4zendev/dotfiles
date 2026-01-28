#!/bin/bash

# Combined mic status + hyprwhspr widget
# Shows: muted state, recording state, and hyprwhspr status

HYPRWHSPR_TRAY="/usr/lib/hyprwhspr/config/hyprland/hyprwhspr-tray.sh"

get_mic_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q "\[MUTED\]"
}

while true; do
    muted=$(get_mic_muted && echo "true" || echo "false")

    # Get hyprwhspr state (returns JSON)
    if [[ -x "$HYPRWHSPR_TRAY" ]]; then
        hyprwhspr_json=$("$HYPRWHSPR_TRAY" status 2>/dev/null)
    else
        hyprwhspr_json='{"text":"","class":"unavailable","tooltip":"hyprwhspr not installed"}'
    fi

    hyprwhspr_class=$(printf '%s' "$hyprwhspr_json" | jq -r '.class // "unknown"')
    # Get tooltip, convert literal \n to real newlines, strip _ts: cache lines
    hyprwhspr_tooltip=$(printf '%s' "$hyprwhspr_json" | jq -r '.tooltip // ""' | sed -e 's/\\n/\n/g' -e '/_ts:/d')

    # Determine display based on combined state
    if [[ "$muted" == "true" ]]; then
        text="󰍭 MUTE"
        class="muted"
        mic_line="Microphone: muted"
    elif [[ "$hyprwhspr_class" == "recording" ]]; then
        text="● REC"
        class="recording"
        mic_line="Microphone: recording"
    elif [[ "$hyprwhspr_class" == "error" ]]; then
        text="󰍬 ERR"
        class="error"
        mic_line="Microphone: active"
    elif [[ "$hyprwhspr_class" == "ready" ]]; then
        text="󰍬"
        class="ready"
        mic_line="Microphone: active"
    else
        text="󰍬"
        class="stopped"
        mic_line="Microphone: active (hyprwhspr stopped)"
    fi

    # Build tooltip: mic status line + original hyprwhspr tooltip
    # Use jq to safely construct JSON with proper escaping
    tooltip="${mic_line}
${hyprwhspr_tooltip}"

    jq -cn --arg text "$text" --arg class "$class" --arg tooltip "$tooltip" \
        '{"text":$text,"class":$class,"tooltip":$tooltip}'

    sleep 0.5
done
