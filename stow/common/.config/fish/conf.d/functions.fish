function frec
  set rand_hex (openssl rand -hex 8)
  ffmpeg -f avfoundation -capture_cursor 1 -capture_mouse_clicks 1 -i "$argv" -ar 48000 -f mp4 "$HOME/projects/r4zendotdev/screen-recordings/output-$rand_hex.mp4"
end

function fdev
  ffmpeg -f avfoundation -list_devices true -i ''
end

function fish_title
  echo (basename $PWD)
  # if [ $_ = "fish" ]
  #   echo (basename $PWD)
  # else
  #   echo $_
  # end
end

function frg --description "rg tui built with fzf and bat"
  rg --smart-case --hidden --sortr=modified --fixed-strings --color=always --line-number --no-heading "$argv" |
  fzf --ansi \
  --color 'hl:-1:underline,hl+:-1:underline:reverse' \
  --delimiter ':' \
  --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
  --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
  --bind "enter:become($EDITOR +{2} {1})"
end

function yazi_create_tmux --description "Create a new tmux session from yazi file chooser"
  set tmp (mktemp)
  yazi --chooser-file="$tmp"
  set chosen (cat $tmp)
  rm $tmp

  if test -n "$chosen"
      test -d "$chosen" && set dir "$chosen" || set dir (dirname "$chosen")
      set name (basename "$dir" | tr "." "_")
      tmux new-session -c "$dir" -d -s "$name"
      tmux switch-client -t "$name"
      tmux send-keys -t "$name" "nvim '$chosen'" Enter
  end
end

if test (uname) = Linux
function app-id --description "Get application ID from package name"
  if test (count $argv) -eq 0
    echo "Usage: app-id <package-name>"
    return 1
  end

  set -l desktop_file (pacman -Ql $argv[1] 2>/dev/null | grep "\.desktop\$" | awk '{print $2}')

  if test -n "$desktop_file"
    basename "$desktop_file" .desktop
  else
    echo "No desktop file found for package: $argv[1]"
    return 1
  end
end
end

if test (uname) = Darwin
function ghostty_bg --description "Manage Ghostty background images"
  set -l sf "$HOME/.config/ghostty/.bg-state"
  set -l cf "$HOME/.config/ghostty/background"
  set -l dir "$HOME/.config/term-images"

  function _get -a key -a sf
    test -f "$sf"; and grep "^$key=" "$sf" | cut -d= -f2
  end

  function _set -a key -a val -a sf
    set -l t (mktemp)
    test -f "$sf"; and grep -v "^$key=" "$sf" > "$t"
    echo "$key=$val" >> "$t"
    mv "$t" "$sf"
  end

  function _apply -a img -a opacity -a cf
    printf "background-opacity = 1.0\nbackground-image = %s\nbackground-image-opacity = %s\nbackground-image-fit = cover\n" "$img" "$opacity" > "$cf"
  end

  function _remove -a cf
    printf "# background disabled\n" > "$cf"
  end

  # Ghostty background image management
  set -l imgs
  if test (_get exclude_default "$sf") != "true"
    for f in $dir/*.jpg $dir/*.jpeg $dir/*.png $dir/*.gif; test -f "$f"; and set -a imgs "$f"; end
  end
  for cat in nsfw restricted explicit
    if test (_get allow_$cat "$sf") = "true"; and test -d "$dir/$cat"
      for f in $dir/$cat/*.jpg $dir/$cat/*.jpeg $dir/$cat/*.png $dir/$cat/*.gif; test -f "$f"; and set -a imgs "$f"; end
    end
  end

  switch $argv[1]
    case random
      test (count $imgs) -eq 0; and echo "No images"; and return 1
      set -l img $imgs[(random 1 (count $imgs))]
      set -l b (_get brightness "$sf"); test -z "$b"; and set b 0.25
      _set current_image "$img" "$sf"; _set enabled true "$sf"; _apply "$img" "$b" "$cf"
    case toggle
      if test (_get enabled "$sf") = "true"
        _set enabled false "$sf"; _remove "$cf"
      else
        set -l img (_get current_image "$sf"); set -l b (_get brightness "$sf"); test -z "$b"; and set b 0.25
        if test -z "$img" -o ! -f "$img"
          test (count $imgs) -gt 0; and set img $imgs[(random 1 (count $imgs))]; and _set current_image "$img" "$sf"
        end
        test -n "$img" -a -f "$img"; and _set enabled true "$sf"; and _apply "$img" "$b" "$cf"
      end
    case toggle-nsfw toggle-restricted toggle-explicit toggle-default
      set -l key (string replace "toggle-" "" $argv[1])
      test $key = "default"; and set key "exclude_default"; or set key "allow_$key"
      set -l cur (_get $key "$sf")
      if test "$cur" = "true"; _set $key false "$sf"; else; _set $key true "$sf"; end
    case brightness-up brightness-down
      set -l b (_get brightness "$sf"); test -z "$b"; and set b 0.25
      test $argv[1] = "brightness-up"; and set b (math "min(1,$b+0.05)"); or set b (math "max(0,$b-0.05)")
      _set brightness $b "$sf"
      set -l img (_get current_image "$sf")
      test (_get enabled "$sf") = "true" -a -f "$img"; and _apply "$img" "$b" "$cf"
    case show
      set -l img (_get current_image "$sf"); test -n "$img"; and echo $img | pbcopy; and echo $img
    case status
      echo "enabled: "(_get enabled "$sf")"  brightness: "(_get brightness "$sf")
      echo "image: "(_get current_image "$sf")
      echo "nsfw: "(_get allow_nsfw "$sf")"  restricted: "(_get allow_restricted "$sf")"  explicit: "(_get allow_explicit "$sf")"  exclude_default: "(_get exclude_default "$sf")
      echo "available: "(count $imgs)
    case '*'
      echo "Usage: ghostty_bg {random|toggle|toggle-nsfw|toggle-restricted|toggle-explicit|toggle-default|brightness-up|brightness-down|show|status}"
  end
end
end
