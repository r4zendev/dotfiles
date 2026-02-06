function wallpaper --description "Manage Hyprland wallpapers via swww"
    set -l dir "$HOME/wallpapers"

    function _notify -a msg
        notify-send -t 1500 -h string:x-canonical-private-synchronous:wallpaper Wallpaper "$msg"
    end

    # Collect images based on enabled categories
    set -l imgs
    if test "(wallpaper-state get exclude_default)" != true
        for f in $dir/*.{jpg,jpeg,png,gif}
            test -f "$f"; and set -a imgs "$f"
        end
    end
    for cat in nsfw restricted explicit
        if test "(wallpaper-state get allow_$cat)" = true; and test -d "$dir/$cat"
            for f in $dir/$cat/*.{jpg,jpeg,png,gif}
                test -f "$f"; and set -a imgs "$f"
            end
        end
    end

    switch $argv[1]
        case random
            test (count $imgs) -eq 0; and _notify "No images"; and return 1
            set -l img $imgs[(random 1 (count $imgs))]
            wallpaper-state set current_image "$img"
            wallpaper-state set enabled true
            swww img "$img" --transition-type fade --transition-duration 0.3
            _notify (basename "$img")

        case toggle
            if test "(wallpaper-state get enabled)" = true
                wallpaper-state set enabled false
                swww clear 000000
                _notify OFF
            else
                set -l img (wallpaper-state get current_image)
                if test -z "$img" -o ! -f "$img"
                    test (count $imgs) -gt 0; and set img $imgs[(random 1 (count $imgs))]; and wallpaper-state set current_image "$img"
                end
                if test -n "$img" -a -f "$img"
                    wallpaper-state set enabled true
                    swww img "$img" --transition-type fade --transition-duration 0.3
                    _notify ON
                end
            end

        case toggle-nsfw toggle-restricted toggle-explicit toggle-default
            set -l key (string replace "toggle-" "" $argv[1])
            test $key = default; and set key exclude_default; or set key "allow_$key"
            set -l cur (wallpaper-state get $key)
            if test "x$cur" = xtrue
                wallpaper-state set $key false
                _notify "$key: OFF"
            else
                wallpaper-state set $key true
                _notify "$key: ON"
            end

        case show
            set -l img (wallpaper-state get current_image)
            test -n "$img"; and echo "$img" | wl-copy; and _notify Copied; and echo "$img"

        case status
            echo "enabled: "(wallpaper-state get enabled)
            echo "image: "(wallpaper-state get current_image)
            echo "nsfw: "(wallpaper-state get allow_nsfw)"  restricted: "(wallpaper-state get allow_restricted)"  explicit: "(wallpaper-state get allow_explicit)"  exclude_default: "(wallpaper-state get exclude_default)
            echo "available: "(count $imgs)

        case '*'
            echo "Usage: wallpaper {random|toggle|toggle-nsfw|toggle-restricted|toggle-explicit|toggle-default|show|status}"
    end
end
