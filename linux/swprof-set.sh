#!/usr/bin/env bash
set -euo pipefail

if ! compgen -G "$HOME/.config/dotfiles/sw-profile*" > /dev/null; then
  mkdir -p "$HOME/.config/dotfiles"

  PS3="Select a profile for this system: "
  select opt in Desktop "Home Server" "Public Server"; do
    case $opt in
      Desktop)
        touch "$HOME/.config/dotfiles/sw-profile-desktop"
        break
        ;;
      "Home Server")
        touch "$HOME/.config/dotfiles/sw-profile-home-server"
        break
        ;;
      "Public Server")
        touch "$HOME/.config/dotfiles/sw-profile-public-server"
        break
        ;;
      *)
        echo "Invalid selection."
        ;;
    esac
  done
fi
