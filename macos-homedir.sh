#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS homedir setup because not on macOS"
  exit 2
fi

mkdir -p "$HOME/.shell-completion-local"
mkdir -p "$HOME/opt/bin"
mkdir -p "$HOME/opt/lib"
mkdir -p "$HOME/opt/sbin"
mkdir -p "$HOME/opt/share/man"
mkdir -p "$HOME/tmp"

# keep Zoom from installing its shitty local webserver thing
rm -rf "$HOME/.zoomus"
touch "$HOME/.zoomus"

echo ""
echo "Create dev workflow directories? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mkdir -p "$HOME/code"
  mkdir -p "$HOME/env"
  mkdir -p "$HOME/go/bin"
  mkdir -p "$HOME/go/src"
fi

echo ""
echo "Create links from ~ to Dropbox (for WORK computer)? (y/N)"
echo "(eg. ~/Documents/Dropbox, etc.)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  ln -s "$HOME/Dropbox/Desktop" "$HOME/Desktop/Dropbox"
  ln -s "$HOME/Dropbox/Documents" "$HOME/Documents/Dropbox"
  ln -s "$HOME/Dropbox/Photos" "$HOME/Pictures/Dropbox"
fi
