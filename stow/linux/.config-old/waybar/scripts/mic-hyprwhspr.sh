#!/bin/bash

# Self-contained mic + hyprwhspr waybar widget
# No dependency on upstream hyprwhspr-tray.sh
#
# Actions: status (default, continuous), record, restart, mute
# Bindings: left=record, right=mute, middle=restart

ICON_PATH="/usr/lib/hyprwhspr/share/assets/hyprwhspr.png"
CONTROLS="Left click: record
Right click: mute/unmute
Middle click: restart"

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

mic_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q "\[MUTED\]"
}

mic_info() {
    local spec
    spec=$(timeout 0.2s pactl list sources 2>/dev/null \
        | awk -v D="$(pactl get-default-source 2>/dev/null)" \
            '/^[[:space:]]*Name:/{name=$2} /^[[:space:]]*Sample Specification:/{spec=$3" "$4" "$5} name==D && spec{print spec; exit}')
    [[ -n "$spec" ]] && echo "Mic: $spec" || echo ""
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

emit_status() {
    local text class mic_line

    if mic_muted; then
        text="󰍭 MUTE"
        class="muted"
        mic_line="Microphone: muted"
    elif is_recording; then
        text="● REC"
        class="recording"
        mic_line="Microphone: recording"
    elif is_running; then
        if systemctl --user is-failed --quiet hyprwhspr.service 2>/dev/null; then
            text="󰍬 ERR"
            class="error"
            mic_line="Microphone: active"
        else
            text="󰍬"
            class="ready"
            mic_line="Microphone: active"
        fi
    else
        text="󰍬"
        class="stopped"
        mic_line="Microphone: active (hyprwhspr stopped)"
    fi

    local mic_hw
    mic_hw=$(mic_info)
    local tooltip="${mic_line}${mic_hw:+
${mic_hw}}

${CONTROLS}"

    jq -cn --arg text "$text" --arg class "$class" --arg tooltip "$tooltip" \
        '{"text":$text,"class":$class,"tooltip":$tooltip}'
}

case "${1:-status}" in
    record)  do_record ;;
    restart) do_restart ;;
    mute)    do_mute ;;
    status)
        while true; do
            emit_status
            sleep 0.5
        done
        ;;
    *) echo "Usage: $0 {status|record|restart|mute}" ;;
esac
