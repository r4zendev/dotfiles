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
