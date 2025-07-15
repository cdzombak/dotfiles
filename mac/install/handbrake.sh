#!/usr/bin/env bash
set -euo pipefail

brew install --cask handbrake
brew install lame libdvdcss

sudo mkdir -p /usr/local/lib

if [ ! -f /usr/local/lib/libdvdcss.2.dylib ]; then
    sudo cp "$(brew --prefix)/lib/libdvdcss.2.dylib" /usr/local/lib
fi
if [ ! -f /usr/local/lib/libdvdcss.a ]; then
    sudo cp "$(brew --prefix)/lib/libdvdcss.a" /usr/local/lib
fi
if [ ! -e /usr/local/lib/libdvdcss.dylib ]; then
    sudo cp "$(brew --prefix)/lib/libdvdcss.dylib" /usr/local/lib
fi
