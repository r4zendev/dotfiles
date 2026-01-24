function wallpaper --description "Manage Hyprland wallpapers via swww"
    set -l sf "$HOME/.config/hypr/.wallpaper-state"
    set -l dir "$HOME/.config/wallpapers"

    test -d (dirname "$sf"); or mkdir -p (dirname "$sf")

    function _get -a key -a sf
        test -f "$sf"; and grep "^$key=" "$sf" | cut -d= -f2
    end

    function _set -a key -a val -a sf
        set -l t (mktemp)
        test -f "$sf"; and grep -v "^$key=" "$sf" >"$t"
        echo "$key=$val" >>"$t"
        mv "$t" "$sf"
    end

    function _notify -a msg
        notify-send -t 1500 -h string:x-canonical-private-synchronous:wallpaper Wallpaper "$msg"
    end

    # Collect images based on enabled categories
    set -l imgs
    if test (_get exclude_default "$sf") != true
        for f in $dir/*.{jpg,jpeg,png,gif}
            test -f "$f"; and set -a imgs "$f"
        end
    end
    for cat in nsfw restricted explicit
        if test (_get allow_$cat "$sf") = true; and test -d "$dir/$cat"
            for f in $dir/$cat/*.{jpg,jpeg,png,gif}
                test -f "$f"; and set -a imgs "$f"
            end
        end
    end

    switch $argv[1]
        case random
            test (count $imgs) -eq 0; and _notify "No images"; and return 1
            set -l img $imgs[(random 1 (count $imgs))]
            _set current_image "$img" "$sf"
            _set enabled true "$sf"
            swww img "$img" --transition-type fade --transition-duration 0.3
            _notify (basename "$img")

        case toggle
            if test (_get enabled "$sf") = true
                _set enabled false "$sf"
                swww clear 000000
                _notify OFF
            else
                set -l img (_get current_image "$sf")
                if test -z "$img" -o ! -f "$img"
                    test (count $imgs) -gt 0; and set img $imgs[(random 1 (count $imgs))]; and _set current_image "$img" "$sf"
                end
                if test -n "$img" -a -f "$img"
                    _set enabled true "$sf"
                    swww img "$img" --transition-type fade --transition-duration 0.3
                    _notify ON
                end
            end

        case toggle-nsfw toggle-restricted toggle-explicit toggle-default
            set -l key (string replace "toggle-" "" $argv[1])
            test $key = default; and set key exclude_default; or set key "allow_$key"
            set -l cur (_get $key "$sf")
            if test "$cur" = true
                _set $key false "$sf"
                _notify "$key: OFF"
            else
                _set $key true "$sf"
                _notify "$key: ON"
            end

        case show
            set -l img (_get current_image "$sf")
            test -n "$img"; and echo "$img" | wl-copy; and _notify Copied; and echo "$img"

        case status
            echo "enabled: "(_get enabled "$sf")
            echo "image: "(_get current_image "$sf")
            echo "nsfw: "(_get allow_nsfw "$sf")"  restricted: "(_get allow_restricted "$sf")"  explicit: "(_get allow_explicit "$sf")"  exclude_default: "(_get exclude_default "$sf")
            echo "available: "(count $imgs)

        case '*'
            echo "Usage: wallpaper {random|toggle|toggle-nsfw|toggle-restricted|toggle-explicit|toggle-default|show|status}"
    end
end
