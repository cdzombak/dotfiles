#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source ./lib/cecho

# Further configuration ...
# - for applications installed as part of the software install script
# - using tools installed as part of the software install script

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS configuration because not on macOS"
  exit 2
fi

echo ""
cecho "--- Keyboard Shortcuts ---" $white
echo "If these don't apply after rebooting, open the affected app, quit it, and re-run this script."
echo ""

echo "Bear ..."
# shellcheck disable=SC2016
defaults write net.shinyfrog.bear NSUserKeyEquivalents '{
  Archive = "^$a";
  Back = "^\\U2190";
  Forward = "^\\U2192";
}'

echo "Day One ..."
# shellcheck disable=SC2016
defaults write com.bloombuilt.dayone-mac NSUserKeyEquivalents '{
  "Main Window" = "@0";
}'

echo "Fantastical ..."
# shellcheck disable=SC2016
defaults write com.flexibits.fantastical2.mac NSUserKeyEquivalents '{
  "Refresh All" = "@r";
  Reminders = "@^$r";
}'

echo "Things ..."
# shellcheck disable=SC2016
defaults write com.culturedcode.ThingsMac NSUserKeyEquivalents '{
  "New Repeating To-Do" = "@$r";
}'

echo "Xcode ..."
# shellcheck disable=SC2016
defaults write com.apple.dt.Xcode NSUserKeyEquivalents '{
    "Jump to Generated Interface" = "@^$i";
    "Print\\U2026" = "@~^$p";
}'

