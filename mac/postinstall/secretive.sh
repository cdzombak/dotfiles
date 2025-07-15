#!/usr/bin/env bash
set -euo pipefail

if [ -e "$HOME/.ssh/config.templates/secretive-agent" ] && [ ! -e "$HOME/.ssh/config.local/secretive-agent" ]; then
    mkdir -p "$HOME/.ssh/config.local/"
    ln -s "$HOME/.ssh/config.templates/secretive-agent" "$HOME/.ssh/config.local/secretive-agent"
fi
