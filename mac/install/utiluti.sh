#!/usr/bin/env bash
set -euo pipefail

# https://github.com/scriptingosx/utiluti is a macOS command-line to work with default apps
set -x
TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'utiluti-work')
pushd "$TMP_DIR"
curl -s "https://api.github.com/repos/scriptingosx/utiluti/releases/latest" | jq -r ".assets[].browser_download_url" | grep ".pkg" | xargs wget -q -O utiluti.pkg
sudo installer -pkg ./utiluti.pkg -target /
popd
set +x
