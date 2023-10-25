#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux stow setup because not on Linux"
  exit 2
fi

IS_ROOT=false
if [ "$EUID" -eq 0 ]; then
  if [ "$HOME" != "/root" ]; then
    echo "[!] you appear to be root but HOME is not /root; exiting."
    exit 1
  fi
  IS_ROOT=true
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho

echo ""
cecho "--- Link Linux configuration files in $HOME ---" "$white"
echo ""

cd "$SCRIPT_DIR/.."
stow --target="$HOME" --ignore="DS_Store" nano
stow --target="$HOME" --ignore="DS_Store" tig
if ! "$IS_ROOT"; then
  stow --target="$HOME" --ignore="DS_Store" screen
fi
cd "$SCRIPT_DIR"
stow --target="$HOME" --ignore="DS_Store" git
touch "$HOME"/.gitconfig.local
"$SCRIPT_DIR"/bash/integrate.sh

cecho "✔ Done." $green
