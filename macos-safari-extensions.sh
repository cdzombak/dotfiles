#!/usr/bin/env bash
set -eo pipefail
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
  "- [ ] Sign in to 1Password account & start syncing\n- [ ] Enable 1Password Safari extension\n- [ ] Customize All Vaults\n- [ ] Set keyboard shortcuts\n- [ ] Enable Alfred integration\n- [ ] Config: Hide in Menu Bar\n- [ ] Config: Open in background at login\n- [ ] Disable all Safari autofill features but \"Other Forms\"\n- [ ] Enable Apple Watch unlocking"

sw_install /Applications/Bear.app "mas install 1091189122" \
  "- [ ] Enable Bear Safari extension"

sw_install /Applications/Better.app "mas install 1121192229" \
  "- [ ] Enable Better Blocker Safari extension"

sw_install "/Applications/Choosy.app" "brew_cask_install choosy" \
  "- [ ] License Choosy\n- [ ] Enable Choosy & Start at Login\n- [ ] Configure Choosy/Import and Tweak Choosy Config\n- [ ] Enable Choosy Safari extension"

sw_install "/Applications/RSS Button for Safari.app" "mas install 1437501942" \
  "- [ ] Configure for Reeder.app\n- [ ] Enable RSS Button Safari extension"

sw_install "/Applications/StopTheMadness.app" "mas install 1376402589" \
  "- [ ] Enable StopTheMadness Safari Extension\n- [ ] Enable Open Link With -> Choosy\n- [ ] Install Firefox extension\n- [ ] Configure"

_install_stopthenews() {
  set -x
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'stopthenews')
  pushd "$TMP_DIR" >/dev/null
  curl -s https://api.github.com/repos/lapcat/StopTheNews/releases/latest | jq -r ".assets[].browser_download_url" | grep ".zip$" | xargs wget -q -O StopTheNews.zip
  unzip StopTheNews.zip
  cp -R StopTheNews.app /Applications/StopTheNews.app
  popd >/dev/null
  set +x
}
sw_install /Applications/StopTheNews.app _install_stopthenews

sw_install "/Applications/Tabs to Links.app" "mas install 1451408472" \
  "- [ ] Enable Tabs to Links Safari extension"

# Save current IFS state
OLDIFS=$IFS
# Determine OS version
IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"
# restore IFS to previous state
IFS=$OLDIFS
if [[ ${osvers_major} -ge 11 ]]; then
  cecho "Extensions not supported on older OS versions ..." $white

  sw_install "/Applications/Hush.app" "mas install 1544743900" \
    "- [ ] Enable Safari extension"
fi

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
echo -e "\n## Safari Extensions ($(date +%A\ %F))" >> "$HOME/SystemSetup.md"
echo "" >> "$HOME/SystemSetup.md"
echo -e "- [ ] Reconfigure Safari toolbar based on current favorite system" >> "$HOME/SystemSetup.md"
echo "" >> "$HOME/SystemSetup.md"
