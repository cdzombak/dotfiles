#!/usr/bin/env bash
set -euo pipefail

IS_ROOT=false
if [ "$EUID" -eq 0 ]; then
  if [ "$HOME" != "/root" ]; then
    echo "[!] you appear to be root but HOME is not /root; exiting."
    exit 1
  fi
  IS_ROOT=true
fi

if ! compgen -G "/home/cdzombak/.config/dotfiles/sw-profile*" > /dev/null; then
  mkdir -p "/home/cdzombak/.config/dotfiles"
  if $IS_ROOT; then chown cdzombak:cdzombak "/home/cdzombak/.config/dotfiles"; fi

  PS3="Select a profile for this system: "
  select opt in Desktop "Home Server" "Public Server"; do
    case $opt in
      Desktop)
        touch "/home/cdzombak/.config/dotfiles/sw-profile-desktop"
        break
        ;;
      "Home Server")
        touch "/home/cdzombak/.config/dotfiles/sw-profile-home-server"
        break
        ;;
      "Public Server")
        touch "/home/cdzombak/.config/dotfiles/sw-profile-public-server"
        break
        ;;
      *)
        echo "Invalid selection."
        ;;
    esac
  done
  if $IS_ROOT; then chown cdzombak:cdzombak "/home/cdzombak/.config/dotfiles/sw-profile*"; fi
fi
