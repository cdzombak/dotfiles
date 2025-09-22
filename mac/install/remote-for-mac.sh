#!/usr/bin/env bash
set -euo pipefail

TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'remotehelperapp-work')
pushd "$TMP_DIR"
wget -O "RemoteForMac.zip" "https://cherpake.com/latest.php?os=mac"
unzip ./RemoteForMac.zip
sudo installer -pkg ./Remote-for-Mac-*.pkg -target /
popd
