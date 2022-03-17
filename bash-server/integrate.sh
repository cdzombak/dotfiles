#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ "$(uname)" == "Darwin" ]; then
  echo "Skipping bash-server setup because on macOS"
  exit 2
fi

# On Debian/Ubuntu, we get a default Bash config in our homedir, which we just want to customize a little bit.
# We do this by sourcing an additional config file here, rather than adding all changes to ~/.bashrc.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RC_APPEND_LINE="source \"$DIR/bashrc_append\""
grep -qF "/bashrc_append" ~/.bashrc || (echo "" >> ~/.bashrc ; echo "$RC_APPEND_LINE" >> ~/.bashrc)

if [ ! -e "$HOME/.bash_profile" ]; then
  ln -s "$DIR/.bash_profile" "$HOME/.bash_profile"
else
  if [ ! -L "$HOME/.bash_profile" ]; then
    echo "Warning: .bash_profile exists but is not a symlink."
    echo "         Manually integrate that file into dotfiles/bash-server."
  fi
fi
