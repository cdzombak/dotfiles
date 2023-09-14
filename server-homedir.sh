#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux software setup because not on Linux"
  exit 2
fi

mkdir -p "$HOME/.config/dotfiles"
mkdir -p "$HOME/opt/bin"
mkdir -p "$HOME/opt/lib"
mkdir -p "$HOME/opt/sbin"
mkdir -p "$HOME/opt/share/man"
mkdir -p "$HOME/scripts"
mkdir -p "$HOME/tmp"

if [ ! -d "$HOME/go" ] && [ ! -e "$HOME/.config/dotfiles/no-home-go-dir" ]; then
  echo ""
  echo "Create ~/go? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mkdir -p "$HOME/go/bin"
    mkdir -p "$HOME/go/src"
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-home-go-dir"
  fi
fi
