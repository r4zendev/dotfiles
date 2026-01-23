function frec
  set rand_hex (openssl rand -hex 8)
  ffmpeg -f avfoundation -capture_cursor 1 -capture_mouse_clicks 1 -i "$argv" -ar 48000 -f mp4 "$HOME/projects/r4zendotdev/screen-recordings/output-$rand_hex.mp4"
end
