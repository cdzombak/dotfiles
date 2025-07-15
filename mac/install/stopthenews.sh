#!/usr/bin/env bash
set -euo pipefail

set -x
TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'stopthenews')
pushd "$TMP_DIR" >/dev/null
curl -s https://api.github.com/repos/lapcat/StopTheNews/releases/latest | jq -r ".assets[].browser_download_url" | grep ".zip$" | xargs wget -q -O StopTheNews.zip
unzip StopTheNews.zip
cp -R StopTheNews.app /Applications/StopTheNews.app
popd >/dev/null
set +x
