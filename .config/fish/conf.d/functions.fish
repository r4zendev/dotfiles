function frec
    set rand_hex (openssl rand -hex 8)
    ffmpeg -f avfoundation -i "$argv" -ar 48000 -f mp4 "$HOME/projects/r4zendotdev/screen-recordings/output-$rand_hex.mp4"
end

function fdev
    ffmpeg -f avfoundation -list_devices true -i ''
end
