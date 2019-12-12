#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'
source ./lib/cecho
source ./lib/sw_install

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping Safari extensions setup because not on macOS"
  exit 2
fi

if ! ls "$HOME/Library/Safari/Extensions" >/dev/null; then
  echo ""
  cecho "This script requires Full Disk Access, in order to check the contents of ~/Library/Safari/Extensions." $red
  echo ""
  cecho "Please allow '$TERM_PROGRAM' Full Disk Access, restart '$TERM_PROGRAM', and run this script again (via 'make mac-safari-extensions' or macos-safari-extensions.sh)." $red
  open "x-apple.systempreferences:com.apple.preference.security"
  exit 0
fi

sw_install "$HOME/Library/Safari/Extensions/Choosy.safariextz" \
  "open -a Safari.app 'https://www.choosyosx.com/browsers'" \
  "- [ ] Install Choosy extension from https://www.choosyosx.com/browsers"

sw_install "$HOME/Library/Safari/Extensions/Day One Quick Entry.safariextz" \
  "open -a Safari.app 'https://dayoneapp.com/extensions'" \
  "- [ ] Install Day One extension from https://dayoneapp.com/extensions\n- [ ] Sign into Day One extension"

sw_install "/Applications/1Password 7.app" "brew_cask_install 1password" \
  "- [ ] Sign in to 1Password account & start syncing\n- [ ] Enable 1Password Safari extension"

sw_install /Applications/Bear.app "mas install 1091189122" \
  "- [ ] Enable Bear Safari Extension"

sw_install /Applications/Better.app "mas install 1121192229" \
  "- [ ] Enable Better Blocker in Safari"

sw_install /Applications/IINA.app "brew_cask_install iina" \
  "- [ ] Enable IINA Safari extension (as desired)"

sw_install /Applications/Instapaper.app "mas install 1481302432" \
  "- [ ] Sign in\n- [ ] Enable Instapaper Safari Extension"

sw_install "/Applications/Tabs to Links.app" "mas install 1451408472" \
  "- [ ] Enable Tabs to Links Safari Extension"

# shellcheck disable=SC2129
echo "## Safari Extensions" >> "$HOME/SystemSetup.md"
echo "" >> "$HOME/SystemSetup.md"
echo -e "- [ ] Configure Safari toolbar based on current favorite system" >> "$HOME/SystemSetup.md"
echo "" >> "$HOME/SystemSetup.md"
