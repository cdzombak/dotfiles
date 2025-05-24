#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho
# shellcheck disable=SC1091
source "$LIB_DIR"/sw_install

exit 0

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS Finder Sidebar setup because not on macOS"
  exit 2
fi

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
  "Downloads -> file:///Users/$WHOAMI/Downloads/"
  "Sync -> file:///Users/$WHOAMI/Sync/"
  "tmp -> file:///Users/$WHOAMI/tmp/"
)

if [ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]; then
  EXPECTED_SIDEBAR_CONTENT+=("Transit -> file:///Users/cdzombak/Library/Mobile%20Documents/com~apple~CloudDocs/Transit/")
else
  EXPECTED_SIDEBAR_CONTENT+=("Transit -> file:///Users/cdzombak/Sync/Transit/")
fi

if diff -r "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents/" "$HOME/Documents" >/dev/null 2>&1 ; then
  # On Big Sur, if iCloud Documents is enabled, Documents doesn't seem to show in this list as expected. Weirdly, Desktop does.
  # Save current IFS state
  OLDIFS=$IFS
  # Determine OS version
  IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"
  # restore IFS to previous state
  IFS=$OLDIFS
  if [[ ${osvers_major} -lt 11 ]]; then
    # on older OS than Big Sur, we can still check for Documents in the sidebar
    EXPECTED_SIDEBAR_CONTENT+=("Documents -> file:///Users/$WHOAMI/Documents/")
  fi
else
  # iCloud Documents is not enabled
  EXPECTED_SIDEBAR_CONTENT+=("Documents -> file:///Users/$WHOAMI/Documents/")
fi

# remove anything that shouldn't be there...
mysides list | while read -r LINE; do
  # only looking at file:// URLs; don't mess with " -> nwnode://domain-AirDrop"
  if ! echo "$LINE" | grep -c "file://" >/dev/null; then continue; fi
  # skip CloudMounter sidebar entries
  if echo "$LINE" | grep -c "CMVolumes" >/dev/null; then continue; fi
  # skip Google Drive sidebar entry
  if echo "$LINE" | grep -c "GoogleDrive" >/dev/null; then continue; fi

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
