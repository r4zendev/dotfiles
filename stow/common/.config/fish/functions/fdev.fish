function fdev
    ffmpeg -f avfoundation -list_devices true -i ''
end
