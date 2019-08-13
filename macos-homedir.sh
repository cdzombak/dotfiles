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

ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/iCloud Drive"

ln -s ~/Sync ~/Dropbox
ln -s ~/Sync/env ~/env
ln -s ~/Sync/public ~/Public/burr

echo ""
echo "Create link to Books & Articles in iCloud Drive? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Library" "$HOME/Books and Articles"
fi

echo ""
echo "Create links from Desktop/Documents to iCloud Drive (for WORK computer)? (y/N)"
echo "(eg. ~/Documents/Dropbox, etc.)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Desktop" "$HOME/Desktop/iCloud"
  ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents" "$HOME/Documents/iCloud"
fi
