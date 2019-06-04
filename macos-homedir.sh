#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS homedir setup because not on macOS"
  exit 2
fi

mkdir -p "$HOME/.shell-completion-local"
mkdir -p "$HOME/env"
mkdir -p "$HOME/opt/bin"
mkdir -p "$HOME/opt/sbin"
mkdir -p "$HOME/opt/lib"
mkdir -p "$HOME/tmp"
