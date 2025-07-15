#!/usr/bin/env bash
set -euo pipefail

TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'remotehelperapp-work')
pushd "$TMP_DIR"
wget --quiet -O "RemoteForMac.zip" "https://cherpake.com/download-latest"
unzip ./RemoteForMac.zip
sudo installer -pkg ./Remote-for-Mac-*.pkg -target /
popd
