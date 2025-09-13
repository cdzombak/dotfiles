#!/usr/bin/env bash
set -euo pipefail

brew install --cask sublime-text

SUBLIMETEXT_INSTALLED_PKGS_DIR="$HOME/Library/Application Support/Sublime Text 3/Installed Packages"
mkdir -p "$SUBLIMETEXT_INSTALLED_PKGS_DIR"
pushd "$SUBLIMETEXT_INSTALLED_PKGS_DIR"
wget https://packagecontrol.io/Package%20Control.sublime-package
popd

SUBLIMETEXT_PKGS_DIR="$HOME/Library/Application Support/Sublime Text 3/Packages"
mkdir -p "$SUBLIMETEXT_PKGS_DIR"
pushd "$SUBLIMETEXT_PKGS_DIR"
echo "This might be a good point to generate a GitHub personal access token for this device, to be stored in the local login keychain:"
echo "https://github.com/settings/tokens"
git clone git@github.com:cdzombak/sublime-text-config.git User
popd
