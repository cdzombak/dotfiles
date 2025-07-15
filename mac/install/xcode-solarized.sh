#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="$HOME/3p_code/solarized-xcode"
git clone "https://github.com/stackia/solarized-xcode.git" "$DEST_DIR"
pushd "$DEST_DIR"
chmod +x ./install.sh
./install.sh
chmod 0555 "$DEST_DIR"
popd
