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
  end
end
