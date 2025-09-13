#!/usr/bin/env bash
set -euo pipefail
trap 'echo "exit $? at line $LINENO from: $BASH_COMMAND"' ERR

git clone https://github.com/RyuKojiro/metar.git /tmp/metar
pushd /tmp/metar
sudo make install
popd
sudo rm -rf /tmp/metar
