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
cecho "--- Application Keyboard Shortcuts ---" $white
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
    "Print…" = "@~^$p";
}'

echo ""
cecho "--- Finder Sidebar ---" $white
echo ""

WHOAMI="$(whoami)"

EXPECTED_SIDEBAR_CONTENT=(
  # formatted as output of `mysides list`
  # excluding AirDrop.
  "Applications -> file:///Applications/"
  "$WHOAMI -> file:///Users/$WHOAMI/"
  "Desktop -> file:///Users/$WHOAMI/Desktop/"
  "Documents -> file:///Users/$WHOAMI/Documents/"
  "Downloads -> file:///Users/$WHOAMI/Downloads/"
  "tmp -> file:///Users/$WHOAMI/tmp/"
  "Sync -> file:///Users/$WHOAMI/Sync/"
)

# remove anything that shouldn't be there...
mysides list | while read -r LINE; do
  # only looking at file:// URLs; don't mess with " -> nwnode://domain-AirDrop"
  if ! echo "$LINE" | grep -c "file://" >/dev/null; then continue; fi

  NAME="$(echo "$LINE" | awk 'BEGIN {FS=" -> "} {print $1}')"
  URI="$(echo "$LINE" | awk 'BEGIN {FS=" -> "} {print $2}')"
  FOUND=false
  # if EXPECTED_SIDEBAR_CONTENT contains this line, continue to the next line:
  for i in "${EXPECTED_SIDEBAR_CONTENT[@]}"; do
    if [ "$i" == "$LINE" ] ; then FOUND=true; fi
  done
  if $FOUND; then
    cecho "✔ Found $NAME in Finder sidebar as expected." $green
    continue
  fi

  # otherwise, we don't want this one:
  cecho "Removing unwanted Finder sidebar item $NAME ($URI)..." $yellow
  mysides remove "$NAME"
done

for i in "${EXPECTED_SIDEBAR_CONTENT[@]}"; do
  if ! mysides list | grep -c "$i" >/dev/null; then
    # this line is missing from sidebar; add it
    NAME="$(echo "$i" | awk 'BEGIN {FS=" -> "} {print $1}')"
    URI="$(echo "$i" | awk 'BEGIN {FS=" -> "} {print $2}')"
    cecho "Adding Finder sidebar item $NAME ($URI)..." $cyan
    mysides add "$NAME" "$URI"
  fi
done

echo ""
cecho "--- Additional Application Configuration ---" $white
echo ""

echo "Rocket..."
defaults write net.matthewpalmer.Rocket deactivated-apps '(
    Slack,
    HipChat,
    Xcode,
    Terminal,
    iTerm2,
    "Sublime Text",
    "Sublime Text 2",
    "IntelliJ IDEA",
    goland,
    "jetbrains-toolbox-launcher",
    Dash,
    studio,
    Bear
)'
defaults write net.matthewpalmer.Rocket "deactivated-website-patterns" '(
    "github.com",
    "trello.com",
    "slack.com",
    "pinboard.in",
    "a2mi.social",
    "git.grooveid.net",
    "app.logz.io",
    "mail.google.com"
)'
