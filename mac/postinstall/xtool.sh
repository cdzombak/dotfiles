#!/usr/bin/env bash
set -euo pipefail

if [ ! -e "$HOME/.xtoolbak.json" ]; then
    echo '{ "backups_location": "sub_dir", "backups_folder": "_Xtoolbak" }' | jq . > "$HOME/.xtoolbak.json"
fi

if [ ! -e "$HOME/.config/xtoolconfig.json" ]; then
    ln -s "$HOME/.config/macos/xtoolconfig.json" "$HOME/.config/xtoolconfig.json"
fi
