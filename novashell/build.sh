
set -e

cd "$(dirname "$0")"

output="./build"

while getopts r:o:bdh args; do
    case "$args" in
        r)
            gresources_target=${OPTARG}
            ;;
        b)
            keep_gresource=true
            ;;
        o)
            output=${OPTARG}
            ;;
        d)
            is_devel=true
            ;;
        h)
            echo "\
novashell's build script.
use \`build:release\` for release builds.

options:
  -r \$file: specify gresource's target path (default: \`\$output/resources.gresource\`)
  -o \$path: specify the build's output directory (default: \`./build\`)
  -b: only target gresource in the build, keeping the file in the output dir
  -d: enable developer mode in the build
  -h: show this help message"
            exit 0
            ;;
    esac
done

if [[ -d "$output" ]] && [[ ! -z "$(ls -A -w1 $output)" ]]; then
    echo "[info] cleaning previous build"
    rm -rf $output/*
else
    mkdir -p $output
fi

echo "[info] compiling gresource"
gres_target=`[[ "$keep_gresource" ]] && echo -n "$output/resources.gresource" || \
    echo -n "${gresources_target:-$output/resources.gresource}"`
mkdir -p `dirname "$gres_target"`
glib-compile-resources resources.gresource.xml \
    --sourcedir ./resources \
    --target "$gres_target"

echo "[info] bundling project"
ags --gtk 4 bundle src/app.ts $output/novashell \
    -r ./src \
    --alias "~=$(pwd)/src" \
    -d "DEVEL=`[[ $is_devel ]] && echo -n true || echo -n false`" \
    -d "NOVASHELL_VERSION='`cat package.json | jq -r .version`'" \
    -d "GRESOURCES_FILE='$(realpath ${gresources_target:-$output/resources.gresource})'" \
    -d "SOURCE_DIR='$(pwd)'" \
|| rm -rf src/node_modules

echo "[info] creating nsh wrapper"
cat > $output/nsh << 'WRAPPER'
#!/bin/bash
DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"

# nsh build outputs to terminal directly
if [[ "$1" == "build" ]]; then
    exec "$DIR/novashell" "$@"
fi

LOG="${XDG_CACHE_HOME:-$HOME/.cache}/novashell/novashell.log"
mkdir -p "$(dirname "$LOG")"

# Truncate log on fresh start (no args = primary instance)
[[ $# -eq 0 ]] && : > "$LOG"

exec "$DIR/novashell" "$@" >>"$LOG" 2>&1
WRAPPER
chmod +x $output/nsh
