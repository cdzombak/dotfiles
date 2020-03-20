#!/usr/bin/env bash

# On macOS systems, verify Homebrew is installed, and install it if not.
# On non-macOS systems, exit without error.

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping Homebrew setup because not on macOS"
  exit 0
fi

command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

if [ ! -f /etc/paths.d/cdz.Homebrew ]; then
  # TODO(cdzombak): this may not work on Catalina
  #                 https://github.com/cdzombak/dotfiles/issues/15
  set -x
  sudo rm -f /etc/paths.d/cdz.Homebrew
  echo -e '/usr/local/bin\n/usr/local/sbin' | sudo tee -a /etc/paths.d/cdz.Homebrew > /dev/null
  set +x
fi
