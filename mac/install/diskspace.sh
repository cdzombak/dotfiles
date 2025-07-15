#!/usr/bin/env bash
set -euo pipefail

# https://github.com/scriptingosx/diskspace reports the various free space measure possible on APFS
set -x
TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'diskspace-work')
pushd "$TMP_DIR"
curl -s "https://api.github.com/repos/scriptingosx/diskspace/releases/latest" | jq -r ".assets[].browser_download_url" | grep ".pkg" | xargs wget -q -O diskspace.pkg
sudo installer -pkg ./diskspace.pkg -target /
popd
set +x
