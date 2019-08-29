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

if [ ! -d "$HOME/code" ] || [ ! -d "$HOME/env" ] || [ ! -d "$HOME/go" ]; then
  echo ""
  echo "Create dev workflow directories? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mkdir -p "$HOME/code"
    mkdir -p "$HOME/go/bin"
    mkdir -p "$HOME/go/src"
  fi
fi

# Integrate iCloud Drive & Syncthing into ~ via symlinks:
# even if Syncthing isn't setup yet, create broken links to ~/Sync; they'll work later

if [ ! -L "$HOME/iCloud Drive" ]; then
  ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/iCloud Drive"
fi

if [ ! -L "$HOME/Dropbox" ]; then
  ln -s "$HOME/Sync" "$HOME/Dropbox"
fi

if [ ! -L "$HOME/env" ]; then
  ln -s "$HOME/Sync/env" "$HOME/env"
fi

if [ ! -L "$HOME/Public/burr" ]; then
  ln -s "$HOME/Sync/public" "$HOME/Public/burr"
fi

if [ ! -L "$HOME/Books and Articles" ]; then
  echo ""
  echo "Create link to Books & Articles in iCloud Drive? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Library" "$HOME/Books and Articles"
  fi
fi

if ! diff -r "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents/" "$HOME/Documents" >/dev/null ; then
  if [ ! -L "$HOME/Desktop/iCloud" ] || [ ! -L "$HOME/Documents/iCloud" ]; then
    echo ""
    echo "Desktop/Documents in iCloud appears to be disabled."
    echo "Create links from Desktop/Documents to iCloud Drive (for WORK computer)? (y/N)"
    echo "(eg. ~/Documents/Dropbox, etc.)"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Desktop" "$HOME/Desktop/iCloud"
      ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents" "$HOME/Documents/iCloud"
    fi
  fi
fi
