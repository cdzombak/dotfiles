#!/usr/bin/env bash
set -euo pipefail

brew install --cask mutedeck
# /opt/homebrew/Caskroom/mutedeck/2.6.1/MuteDeck-2.6.1-Installer.app
MD_INSTALLER_NAME="$(brew info --cask mutedeck | grep -i "Installer.app" | cut -d' ' -f1)" # MuteDeck-2.6.1-Installer.app
MD_VDIR="$(echo "$MD_INSTALLER_NAME" | cut -d'-' -f2)" # 2.6.1
set +e
open "$(brew --prefix)"/Caskroom/mutedeck/"$MD_VDIR"/"$MD_INSTALLER_NAME"
set -e
echo ""
cecho "Please finish installing MuteDeck ..."
read -rp "(press enter/return to continue)"
