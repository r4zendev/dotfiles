function app-id --description "Get application ID from package name"
    if test (count $argv) -eq 0
        echo "Usage: app-id <package-name>"
        return 1
    end

    # Get all desktop files from package
    set -l desktop_files (pacman -Ql $argv[1] 2>/dev/null | grep "\.desktop\$" | awk '{print $2}')

    if test -z "$desktop_files"
        echo "No desktop file found for package: $argv[1]"
        return 1
    end

    # If multiple files, prefer the simplest one (shortest basename, no dashes after package name)
    set -l app_ids
    for file in $desktop_files
        set -a app_ids (basename "$file" .desktop)
    end

    # Filter: prefer exact match with package name first
    for id in $app_ids
        if test "$id" = "$argv[1]"
            echo $id
            return 0
        end
    end

    # Otherwise, prefer shortest name (usually the main app)
    set -l shortest (printf "%s\n" $app_ids | awk '{print length, $0}' | sort -n | head -1 | cut -d' ' -f2-)

    if test (count $app_ids) -gt 1
        echo "Multiple IDs found, using shortest: $shortest" >&2
        echo "All options: $app_ids" >&2
    end

    echo $shortest
end
