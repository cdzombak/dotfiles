#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ "$(uname)" == "Darwin" ]; then
  echo "Skipping bash-server setup because on macOS"
  exit 2
fi

mkdir -p "$HOME/opt/bin"
mkdir -p "$HOME/opt/lib"
mkdir -p "$HOME/opt/sbin"
mkdir -p "$HOME/opt/share/man"
mkdir -p "$HOME/scripts"
mkdir -p "$HOME/tmp"

if [ ! -d "$HOME/go" ]; then
  echo ""
  echo "Create ~/go? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mkdir -p "$HOME/go/bin"
    mkdir -p "$HOME/go/src"
  fi
fi
