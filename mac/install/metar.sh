#!/usr/bin/env bash
set -euo pipefail

git clone https://github.com/RyuKojiro/metar.git /tmp/metar
pushd /tmp/metar
make install
popd
rm -rf /tmp/metar
