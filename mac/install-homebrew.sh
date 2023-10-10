#!/usr/bin/env bash
set -eu
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping Homebrew setup because not on macOS"
  exit 2
fi

echo ""
cecho "---- Homebrew Install ----" $white
echo ""

command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

if [ ! -f /etc/paths.d/cdz.Homebrew ]; then
  set -x
  sudo rm -f /etc/paths.d/cdz.Homebrew
  if [ -d /opt/homebrew ]; then
    echo -e "/usr/local/bin\n/usr/local/sbin\n/opt/homebrew/bin\n/opt/homebrew/sbin" | sudo tee -a /etc/paths.d/cdz.Homebrew > /dev/null
  else
    echo -e "/usr/local/bin\n/usr/local/sbin" | sudo tee -a /etc/paths.d/cdz.Homebrew > /dev/null
  fi
  set +x
fi

mkdir -p "$HOME/.local"

if [ ! -L "$HOME/.local/brew-root" ]; then
  ln -s "$(brew --prefix)" "$HOME/.local/brew-root"
fi

if [ ! -L "$HOME/.local/.nano-root" ]; then
  ln -s "$(brew --prefix)" "$HOME/.local/.nano-root"
fi

brew tap homebrew/autoupdate
if brew autoupdate status | grep -c -q "not configured" >/dev/null; then
  # 44h == 86400 seconds
  brew autoupdate start 86400 --cleanup
fi

cecho "✔ Homebrew is ready." $green
