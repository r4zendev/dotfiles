#!/bin/bash

# Get default audio source (microphone)
while true; do
    # Check if mic is muted
    muted=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -o "\[MUTED\]")

    if [ -n "$muted" ]; then
        # Muted
        echo '{"text":"󰍭 MUTE","class":"muted","tooltip":"Microphone muted"}'
    else
        # Unmuted
        echo '{"text":"󰍬","class":"unmuted","tooltip":"Microphone active"}'
    fi

    # Update every 0.5 seconds for responsiveness
    sleep 0.5
done
