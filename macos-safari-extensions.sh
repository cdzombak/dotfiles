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
  "- [ ] License Choosy\n- [ ] Configure Choosy/Import and Tweak Choosy Config\n- [ ] Enable Choosy Safari extension"

sw_install "/Applications/Day One.app" "mas install 1055511498" \
  "- [ ] Sign into Day One account\n- [ ] Enable Day One Safari extension\n- [ ] Sign into Day One Safari extension"

sw_install /Applications/Instapaper.app "mas install 1481302432" \
  "- [ ] Sign in\n- [ ] Enable Instapaper Safari extension"

sw_install "/Applications/RSS Button for Safari.app" "mas install 1437501942" \
  "- [ ] Configure for Reeder.app\n- [ ] Enable RSS Button Safari extension"

sw_install "/Applications/StopTheMadness.app" "mas install 1376402589" \
  "- [ ] Enable StopTheMadness Safari Extension\n- [ ] Enable Open Link With -> Choosy\n- [ ] Install Chrome extension in commonly-used profiles ([chrome://extensions](chrome://extensions/))"

sw_install "/Applications/Tabs to Links.app" "mas install 1451408472" \
  "- [ ] Enable Tabs to Links Safari extension"

cecho "Open Safari for configuration now? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  open -a Safari
  set +e
  osascript -e '
activate application "Safari"
tell application "System Events" to keystroke "," using command down
'
  set -e
fi

# shellcheck disable=SC2129
echo "## Safari Extensions ($(date +%A\ %F))" >> "$HOME/SystemSetup.md"
echo "" >> "$HOME/SystemSetup.md"
echo -e "- [ ] Reconfigure Safari toolbar based on current favorite system" >> "$HOME/SystemSetup.md"
echo "" >> "$HOME/SystemSetup.md"
