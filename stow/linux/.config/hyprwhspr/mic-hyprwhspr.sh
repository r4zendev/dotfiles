#!/bin/bash

# Self-contained mic + hyprwhspr control script
# Actions: record, restart, mute

ICON_PATH="/usr/lib/hyprwhspr/share/assets/hyprwhspr.png"

notify() {
    command -v notify-send &>/dev/null && notify-send -i "$ICON_PATH" "hyprwhspr" "$1" -u "${2:-normal}"
}

is_running() {
    systemctl --user is-active --quiet hyprwhspr.service
}

is_recording() {
    is_running || return 1
    local status_file="$HOME/.config/hyprwhspr/recording_status"
    [[ -f "$status_file" ]] && [[ "$(cat "$status_file" 2>/dev/null)" == "true" ]] || return 1
    # Check audio_level staleness to detect crashed recordings
    local level_file="$HOME/.config/hyprwhspr/audio_level"
    if [[ -f "$level_file" ]]; then
        local age=$(( $(date +%s) - $(stat -c %Y "$level_file" 2>/dev/null || echo 0) ))
        [[ $age -le 2 ]]
    else
        local status_age=$(( $(date +%s) - $(stat -c %Y "$status_file" 2>/dev/null || echo 0) ))
        [[ $status_age -le 1 ]]
    fi
}

do_record() {
    local control_file="$HOME/.config/hyprwhspr/recording_control"
    if is_recording; then
        echo "stop" > "$control_file"
    else
        if ! is_running; then
            systemctl --user start hyprwhspr.service
            sleep 0.5
        fi
        echo "start" > "$control_file"
    fi
}

do_restart() {
    systemctl --user restart hyprwhspr.service
    notify "Restarted"
}

do_mute() {
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
}

case "${1:-}" in
    record)  do_record ;;
    restart) do_restart ;;
    mute)    do_mute ;;
    *) echo "Usage: $0 {record|restart|mute}" ;;
esac
