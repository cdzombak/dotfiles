#!/usr/bin/env bash
set -euo pipefail

local LATEST_PORTMAP_TAG="PortMap-2.0.1"
set -x
TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'portmap-work')
pushd "$TMP_DIR"
curl -s "https://api.github.com/repos/monkeydom/TCMPortMapper/releases/tags/$LATEST_PORTMAP_TAG" | jq -r ".assets[].browser_download_url" | grep "PortMap" | grep ".zip" | xargs wget -q -O portmap.zip
unzip portmap.zip
rm portmap.zip
cp -R "Port Map.app" "/Applications/Port Map.app"
popd
set +x
