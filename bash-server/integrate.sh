#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ "$(uname)" == "Darwin" ]; then
  echo "Skipping bash-server setup because on macOS"
  exit 2
fi

# On Ubuntu, we get a default Bash config in our homedir, which we just want to customize a little bit.
# We do this by sourcing an additional config file here, rather than adding all changes to ~/.bashrc.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RC_APPEND_LINE="source \"$DIR/bashrc_append\""
grep -qF 'include "/bashrc_append"' ~/.bashrc || (echo "" >> ~/.bashrc ; echo "$RC_APPEND_LINE" >> ~/.bashrc)

ln -s "$DIR/.bash_profile" $HOME/.bash_profile
