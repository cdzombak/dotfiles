#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping linux/bash config because not on Linux"
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

grep -qF "#CDZ_BASHRC_SCREEN_TITLE" ~/.bashrc || (echo """

#CDZ_BASHRC_SCREEN_TITLE:start
case \"\$TERM\" in
    screen*)
        # This is the escape sequence ESC k ESC
        SCREENTITLE='\[\033k\W\033\134\]'
        ;;
    *)
        SCREENTITLE=''
        ;;
esac
PS1=\"\${SCREENTITLE}\${PS1}\"
#CDZ_BASHRC_SCREEN_TITLE:end

""" >> ~/.bashrc)

if $IS_ROOT; then
  grep -qF "#CDZ_ROOT_RED_PROMPT" ~/.bashrc || (echo """

#CDZ_ROOT_RED_PROMPT:start
RED='\[\\033[0;31m\]'
NOCOLOR='\[\\033[0m\]'
export PS1=\"\${SCREENTITLE}\${RED}\${PS1}\${NOCOLOR}\"
#CDZ_ROOT_RED_PROMPT:end

""" >> ~/.bashrc)
fi

# On Debian/Ubuntu/Raspbian, we get a default Bash config in our homedir, which we just want to customize.
# We do this by sourcing an additional config file here, rather than adding all changes to ~/.bashrc.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RC_APPEND_LINE="source \"$SCRIPT_DIR/bashrc_append\""
grep -qF "/bashrc_append" ~/.bashrc || (echo "" >> ~/.bashrc ; echo "$RC_APPEND_LINE" >> ~/.bashrc)

if [ ! -e "$HOME/.bash_profile" ]; then
  if $IS_ROOT; then
    ln -s "$SCRIPT_DIR/.bash_profile_root" "$HOME/.bash_profile"
  else
    ln -s "$SCRIPT_DIR/.bash_profile" "$HOME/.bash_profile"
  fi
else
  if [ ! -L "$HOME/.bash_profile" ]; then
    echo "Warning: .bash_profile exists but is not a symlink."
    echo "         Manually integrate that file into dotfiles/linux/bash."
  fi
fi
