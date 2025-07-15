#!/usr/bin/env bash
set -euo pipefail

if [ -e "$HOME/.ssh/config.templates/yubikey-agent" ] && [ ! -e "$HOME/.ssh/config.local/yubikey-agent" ]; then
    mkdir -p "$HOME/.ssh/config.local/"
    ln -s "$HOME/.ssh/config.templates/yubikey-agent" "$HOME/.ssh/config.local/yubikey-agent"
fi
