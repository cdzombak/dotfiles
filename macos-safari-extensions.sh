#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'
source ./lib/cecho
source ./lib/sw_install

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping Safari extensions setup because not on macOS"
  exit 2
fi

cecho "----                                ----" $white
cecho "---- Safari Extensions Installation ----" $white
cecho "----                                ----" $white
echo ""

sw_install "/Applications/1Password 7.app" "brew_cask_install 1password" \
  "- [ ] Sign in to 1Password account & start syncing\n- [ ] Enable 1Password Safari extension"

sw_install /Applications/Bear.app "mas install 1091189122" \
  "- [ ] Enable Bear Safari extension"

sw_install /Applications/Better.app "mas install 1121192229" \
  "- [ ] Enable Better Blocker Safari extension"

sw_install "/Applications/Choosy.app" "brew_cask_install choosy" \
  "- [ ] Configure Choosy\n- [ ] Enable Choosy Safari extension"

sw_install "/Applications/Day One.app" "mas install 1055511498" \
  "- [ ] Sign into Day One account\n- [ ] Enable Day One Safari extension\n- [ ] Sign into Day One Safari extension"

sw_install /Applications/IINA.app "brew_cask_install iina" \
  "- [ ] Enable IINA Safari extension (as desired)"

sw_install /Applications/Instapaper.app "mas install 1481302432" \
  "- [ ] Sign in\n- [ ] Enable Instapaper Safari extension"

sw_install "/Applications/Tabs to Links.app" "mas install 1451408472" \
  "- [ ] Enable Tabs to Links Safari extension"

cecho "Open Safari for configuration now? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  open -a Safari
fi

# shellcheck disable=SC2129
echo "## Safari Extensions ($(date +%A\ %F))" >> "$HOME/SystemSetup.md"
echo "" >> "$HOME/SystemSetup.md"
echo -e "- [ ] Reconfigure Safari toolbar based on current favorite system" >> "$HOME/SystemSetup.md"
echo "" >> "$HOME/SystemSetup.md"
