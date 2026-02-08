# Usage:
#
# Record full screen with audio
# frec
#
# Record a selected region (use slurp to select)
# frec -g (slurp)
#
# Record a specific output/monitor
# frec -o DP-1

# --codec-param="crf=23"  # Default (high quality)
# --codec-param="crf=28"  # Current (good quality, smaller)
# --codec-param="crf=32"  # Lower quality (even smaller)
# --codec-param="crf=18"  # Very high quality (larger files)

function frec
    function _notify -a msg
        notify-send -e -t 1500 -a "Screen Recording" "$msg"
    end

    set rand_hex (openssl rand -hex 8)
    set output_file "$HOME/Documents/recordings/output-$rand_hex.mp4"

    mkdir -p (dirname $output_file)

    echo "Recording with wf-recorder..."

    set audio_source (pactl list sources short | grep -m1 'monitor' | awk '{print $2}')

    if test -n "$audio_source"
        echo "Capturing audio from: $audio_source"
        wf-recorder --audio="$audio_source" --codec=libx264 --codec-param="preset=medium" --codec-param="crf=28" -f $output_file $argv
    else
        echo "No audio source found, recording video only"
        wf-recorder --codec=libx264 --codec-param="preset=medium" --codec-param="crf=28" -f $output_file $argv
    end

    echo "Recording saved to: $output_file"

    echo -n $output_file | wl-copy
    echo "Path copied to clipboard"

    _notify "Saved and copied: "(basename "$output_file")
end
