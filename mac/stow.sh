#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS stow setup because not on macOS"
  exit 2
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho

echo ""
cecho "--- Link macOS configuration files in $HOME ---" "$white"
echo ""

cd "$SCRIPT_DIR/.."
stow --target="$HOME" --ignore="DS_Store" nano
stow --target="$HOME" --ignore="DS_Store" screen
stow --target="$HOME" --ignore="DS_Store" tig
cd "$SCRIPT_DIR"
stow --target="$HOME" --ignore="DS_Store" act
stow --target="$HOME" --ignore="DS_Store" hammerspoon
stow --target="$HOME" --ignore="DS_Store" git
stow --target="$HOME" --ignore="DS_Store" login
stow --target="$HOME" --ignore="DS_Store" ruby
stow --target="$HOME" --ignore="DS_Store" zsh
stow --target="$HOME" --ignore="DS_Store" asdf
[ -L "$HOME/.kubectl_aliases" ] || ln -s "$SCRIPT_DIR"/kubectl-aliases/.kubectl_aliases "$HOME/.kubectl_aliases"

cecho "✔ Done." $green
