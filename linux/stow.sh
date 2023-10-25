#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux stow setup because not on Linux"
  exit 2
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
stow --target="$HOME" --ignore="DS_Store" screen
stow --target="$HOME" --ignore="DS_Store" tig
cd "$SCRIPT_DIR"
stow --target="$HOME" --ignore="DS_Store" git
touch ~/.gitconfig.local
"$SCRIPT_DIR"/bash/integrate.sh

cecho "✔ Done." $green
