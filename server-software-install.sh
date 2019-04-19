#!/usr/bin/env bash

set -euo pipefail

if [ "$(uname)" == "Darwin" ]; then
  echo "Skipping Linux software setup because on macOS"
  exit 2
fi

sudo apt-get -y install jq

# install dust: A more intuitive version of du in rust
if [ ! -x "/usr/local/bin/dust" ]; then
  TMP_DIR=`mktemp -d 2>/dev/null || mktemp -d -t 'dust-work'`
  pushd "$TMP_DIR"
  curl -s https://api.github.com/repos/bootandy/dust/releases/latest | jq -r ".assets[].browser_download_url" | grep "linux" | xargs wget -q -O dust.tar.gz
  tar xzf dust.tar.gz
  cp dust $HOME/opt/bin
  popd
fi
