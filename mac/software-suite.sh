#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho
source "$LIB_DIR"/sw_install

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS software installation because not on macOS"
  exit 2
fi

cecho "----                      ----" $white
cecho "---- macOS Software Suite ----" $white
cecho "----                      ----" $white
echo ""
cecho "On a new system this will take a while. The computer should be plugged in and have a solid network connection." $red
echo ""

echo ""
cecho "--- Choices ---" $white
echo ""

mkdir -p "$HOME/.config/dotfiles/software"

# cleanup old, unused choices:
rm -f "$HOME/.config/dotfiles/software/no-ecobee-wrapper"
rm -f "$HOME/.config/dotfiles/software/no-home-hardware-utils"
rm -f "$HOME/.config/dotfiles/software/no-octopi-dzhome"
rm -f "$HOME/.config/dotfiles/software/no-*.app"
rm -f "$HOME/.config/dotfiles/software/no-applepromediatools"

# migrate choices:
if [ -e "$HOME/.config/dotfiles/software/no-caprine" ]; then
  touch "$HOME/.config/dotfiles/software/no-messenger"
  rm "$HOME/.config/dotfiles/software/no-caprine"
fi
if [ -e "$HOME/.config/dotfiles/software/no-mastonaut" ]; then
  touch "$HOME/.config/dotfiles/software/no-ivory"
  trash "$HOME/.config/dotfiles/software/no-mastonaut"
fi

# set default choices:
touch "$HOME/.config/dotfiles/software/no-boop"

if [ "$(ls -A "$HOME/.config/dotfiles/software")" ] ; then
  cecho "Please review these currently-persisted choices in ~/.config/dotfiles/software:" $white
  ls -C "$HOME/.config/dotfiles/software"
  echo ""
  echo "Remove any individual choice directly in a separate window, or reset all using \`make reset-choices\`."
  # shellcheck disable=SC2162
  read -p "Press [Enter] to continue..."
fi

echo ""
cecho "--- sudo ---" $white
echo ""

echo -e "This script will use ${magenta}sudo${_reset}; enter your password to authenticate if prompted."
# Authenticate upfront and run a keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -v -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
cecho "--- App Store ---" $white
echo ""
cecho "You need to be signed into the App Store to continue." $white
cecho "Open the App Store? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  open -a "App Store"
  cecho "Verify you are signed into the App Store." $white
  # shellcheck disable=SC2162
  read -p "Press [Enter] to continue..."
fi

echo ""
cecho "--- Preflight ---" $white
echo ""

if [ -e "$HOME/.nvm/nvm.sh" ]; then
  echo ""
  cecho "nvm is installed and will be deactivated in this shell." $red
  set +e
  . "$HOME/.nvm/nvm.sh"
  echo "+ npm deactivate"
  nvm deactivate
  echo "+ which node"
  which node
  echo "+ which npm"
  which npm
  set -e
fi

# build out /usr/local tree, since we try to install stuff there:
if [ -w /usr/local ]; then
  mkdir -p /usr/local/bin
  mkdir -p /usr/local/sbin
  mkdir -p /usr/local/share/man/man1
else
  sudo mkdir -p /usr/local/bin
  sudo mkdir -p /usr/local/sbin
  sudo mkdir -p /usr/local/share/man/man1
fi

echo ""
cecho "--- Pre-Install Migrations ---" $white
echo ""

if brew tap | grep "filosottile/gomod" >/dev/null ; then
  echo "Replacing brew-gomod by my fork ..."
  echo "https://github.com/FiloSottile/homebrew-gomod/issues/7"
  brew uninstall brew-gomod
  brew untap filosottile/gomod
fi

if [ -e "/Applications/Alfred 4.app" ]; then
  echo "Upgrading Alfred ..."
  brew reinstall --cask alfred
fi

if [ -e "/Applications/DxOPhotoLab7.app" ]; then
  echo "DxO PhotoLab: manual upgrade required ..."
  trash "/Applications/DxOPhotoLab7.app"
  "$SCRIPT_DIR"/mac-install -config ./install.yaml -only photolab
  open "https://www.dxo.com/dxo-photolab/download/"
fi

if [ -e "/Applications/Acorn 7.app" ]; then
  echo "Acorn: manual upgrade required ..."
  trash "/Applications/Acorn 7.app"
  "$SCRIPT_DIR"/mac-install -config ./install.yaml -only acorn
fi

if [ -e /Applications/Arduino.app ]; then
  echo "Migrating away from deprecated Arduino cask ..."
  brew install arduino-cli
  brew install --cask arduino-ide
  brew uninstall arduino
fi

if [ -e /Applications/Paw.app ]; then
  echo "Migrating Paw to RapidAPI ..."
  brew install --cask rapidapi
  brew uninstall --cask paw
fi

if [ -e "/Applications/Sonos S1 Controller.app" ]; then
  echo "Removing Sonos S1 controller ..."
  brew uninstall --cask --force sonos
  rm -rf "/Applications/Sonos S1 Controller.app"
  brew cleanup
  brew update
fi

if [ -e /opt/homebrew/Cellar/gem-mdless/1.0.37 ]; then
  echo "Move to Homebrew packaged mdless..."
  brew gem uninstall mdless
  brew install mdless
fi
if gem list | grep -c mdless >/dev/null; then
  echo "Move to Homebrew packaged mdless..."
  sudo gem uninstall mdless
  brew install mdless
fi

if [ "$(utiluti --version)" != "1.3" ]; then
  echo "Remove outdated utiluti..."
  sudo rm /usr/local/bin/utiluti
fi

echo ""
cecho "--- Core Suite Setup ---" $white
echo ""

env \
  ASDF_PYTHON="$(cat ~/.tool-versions | grep python | head -n 1 | cut -d' ' -f 2)" \
  ASDF_NODEJS="$(cat ~/.tool-versions | grep nodejs | head -n 1 | cut -d' ' -f 2)" \
  "$SCRIPT_DIR"/mac-install -config "$SCRIPT_DIR"/install-asdf.yaml

echo ""
cecho "Skip optional installs? (y/N)" $white
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  "$SCRIPT_DIR"/mac-install -config "$SCRIPT_DIR"/install.yaml -skip-optional
else
  "$SCRIPT_DIR"/mac-install -config "$SCRIPT_DIR"/install.yaml
fi

if [ ! -L /Applications/Marked.app ]; then
  # compatibility with old "Open in Marked" IntelliJ plugin which hardcodes this path to Marked:
  ln -s "/Applications/Marked 2.app" /Applications/Marked.app
  chflags -h hidden /Applications/Marked.app
fi


### Uninstalls:
"$SCRIPT_DIR"/software-suite-uninstalls.sh


echo ""
cecho "--- Cleanup & Tidy ---" $white
echo ""

if command -v gcloud >/dev/null; then
  if gcloud components list --only-local-state | grep -c "kubectl" >/dev/null; then
    echo "Cleaning up kubectl installed via gcloud/docker ..."
    gcloud components remove kubectl
  fi
fi
if file -h /usr/local/bin/kubectl | grep -c "Applications/Docker.app/Contents/Resources/bin" >/dev/null; then
  echo "Removing kubectl symlink to Docker.app."
  sudo rm /usr/local/bin/kubectl
fi
if file -h /opt/homebrew/bin/kubectl | grep -c "Applications/Docker.app/Contents/Resources/bin" >/dev/null; then
  echo "Removing kubectl symlink to Docker.app."
  sudo rm /opt/homebrew/bin/kubectl
fi

if gem list | grep -c sqlint >/dev/null; then
  echo "Cleaning up gems installed without brew-gem ..."
  sudo gem uninstall sqlint
fi
if gem list | grep -c pg_query >/dev/null; then
  echo "Cleaning up gems installed without brew-gem ..."
  sudo gem uninstall pg_query
fi

if [ -L "$HOME/.sublime-config" ]; then
  rm "$HOME/.sublime-config"
fi

echo ""
cecho "--- Optional components that have failed previously ---" $white
echo ""

set +e

_install_sqlint() {
  echo ""
  cecho "Install sqlint? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew gem install sqlint
  fi
}
sw_install "$(brew --prefix)"/bin/sqlint _install_sqlint

set -e


echo ""
cecho "--- Post-Install Configuration ---" $white
echo ""

if [ ! -f "$HOME/.netrc" ]; then
  cp ./.netrc.template "$HOME/.netrc"
  chmod 600 "$HOME/.netrc"
fi
# shellcheck disable=SC2088
setupnote "~/.netrc" "- [ ] Set dropbox.dzombak.com credentials"

if [ -d /opt/homebrew ]; then
  cecho "Set path for macOS .apps to include /usr/local and /opt/homebrew..." $white
  sudo launchctl config user path "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/Applications/Sublime Text.app/Contents/SharedSupport/bin:/usr/local/sbin:/opt/homebrew/sbin:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/usr/local/opt/go/libexec/bin"
else
  cecho "Set path for macOS .apps to include /usr/local..." $white
  sudo launchctl config user path "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/Applications/Sublime Text.app/Contents/SharedSupport/bin:/usr/local/sbin:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/usr/local/opt/go/libexec/bin"
fi
echo ""

# Further configuration ...
# - for applications installed as part of the software install script
# - using tools installed as part of the software install script

cecho "--- Application Configuration ---" $white
echo "If these don't apply, open the affected app, quit it, and re-run this script. As a last resort, try rebooting, and run this script again."
echo ""

echo "Xcode ..."
"$SCRIPT_DIR"/postinstall/xcode.sh

if [ -e "/Applications/Setapp/CodeRunner.app" ]; then
  echo "CodeRunner (Setapp)..."
  defaults write com.krill.CodeRunner-setapp ColorTheme -string "Solarized (light)"
  defaults write com.krill.CodeRunner-setapp DefaultTabModeSoftTabs 1
  if ! grep -c "CodeRunner" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## CodeRunner" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Set font to Meslo LG L 14pt" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Remove the million default file type associations" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Configure as desired" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
fi

if [ -e "/Applications/Google Chrome.app" ]; then
  echo "Google Chrome..."
  # echo ""
  # echo "Using the system-native print preview dialog in Chrome"
  # defaults write com.google.Chrome DisablePrintPreview -bool true
  # defaults write com.google.Chrome.canary DisablePrintPreview -bool true

  echo "  Disable annoying Chrome swipe-to-navigate gesture"
  defaults write com.google.Chrome.plist AppleEnableSwipeNavigateWithScrolls -bool FALSE
fi

if [ -e "/Applications/Setapp/Grids.app" ]; then
  echo "Grids ..."
  defaults write "com.thinktimecreations.Grids" "Application.DoNotShowLoginWarning" '1'
  setupnote "Grids" \
    "- [ ] Disable menu bar icon\n- [ ] Disable most or all notifications\n- [ ] Set spacing to \`16\`\n- [ ] Set picture size to \`4\`\n- [ ] Do not show stories or ads\n- [ ] Sign in"
fi


if [ -e "/Applications/Setapp/HazeOver.app" ]; then
echo "HazeOver ..."
  defaults write com.pointum.hazeover-setapp Animation -float "0.05"
  defaults write com.pointum.hazeover-setapp AskSecondaryDisplay -bool false
  defaults write com.pointum.hazeover-setapp Enabled -bool true
  defaults write com.pointum.hazeover-setapp IndependentScreens -bool true
  defaults write com.pointum.hazeover-setapp Intensity -float "5.167723137178133"
  defaults write com.pointum.hazeover-setapp MultiFocus -bool true
  setupnote "HazeOver" \
    "- [ ] Hide in menu bar\n- [ ] Start at Login"
fi


if [ -e "/Applications/Setapp/Keysmith.app" ]; then
echo "Keysmith ..."
  defaults write "app.keysmith.Keysmith-setapp" "shouldEnableEnhancedAXModeInBrowsers" '1'
  if ! grep -c "Keysmith.app" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## Keysmith.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Change quick launcher shortcut to Ctrl+Option+Command+Space, to avoid Finder search conflict" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Enable sync via Syncthing" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Hide in menu bar" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
fi


if [ -e "/Applications/Setapp/Marked 2.app" ]; then
echo "Marked (Setapp)..."
  defaults write com.brettterpstra.marked2-setapp WebKitDeveloperExtras -bool true
  defaults write com.brettterpstra.marked2-setapp convertGithubCheckboxes -bool true
  defaults write com.brettterpstra.marked2-setapp defaultProcessor -string "Discount (GFM)"
  defaults write com.brettterpstra.marked2-setapp defaultSyntaxStyle -string "GitHub"
  defaults write com.brettterpstra.marked2-setapp externalEditor -string "Typora"
  defaults write com.brettterpstra.marked2-setapp externalImageEditor -string "Pixelmator"
  defaults write com.brettterpstra.marked2-setapp includeMathJax -bool true
  defaults write com.brettterpstra.marked2-setapp isMultiMarkdownDefault -bool false
  defaults write com.brettterpstra.marked2-setapp syntaxHighlight -bool true
fi


if [ -e "/Applications/Setapp/Mission Control Plus.app" ]; then
echo "Mission Control Plus ..."
  if ! grep -c "Mission Control Plus.app" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## Mission Control Plus.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Disable complex keyboard shortcuts" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Hide in menu bar" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
fi


if [ -e "/Applications/Setapp/Path Finder.app" ]; then
echo "Path Finder ..."
  defaults write com.cocoatech.PathFinder-setapp disableWarnOnQuit -bool true
  defaults write com.cocoatech.PathFinder-setapp globalAppsMenuEnabled -bool false
  defaults write com.cocoatech.PathFinder-setapp kOpenTextEditDocumentsInTextEditor -bool false
  defaults write com.cocoatech.PathFinder-setapp kTerminalApplicationPath "/Applications/iTerm.app"
  defaults write com.cocoatech.PathFinder-setapp textEditorApplicationPath "/Applications/Sublime Text.app"
fi


if [ -e "/Applications/Setapp/SQLPro Studio.app" ]; then
echo "SQLPro Studio ..."
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-DisableSampleConnections" '1'
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-QueryMenuKeyEquivalentMask" '1048576'
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-QueryMenuKeyEquivalent" '"\U21a9"'
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-CommentUncommentShortcutKeyEquivalent" '/'
fi

echo ""
cecho "--- Permissions: Homebrew / Zsh / usr/local ---" $white
echo ""

echo -e "This fix will use ${magenta}sudo${_reset}; enter your password to authenticate if prompted."
# Authenticate upfront and run a keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -v -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

WHOAMI="$(whoami)"
if [ -d /usr/local/share/zsh ]; then
  sudo chown "$WHOAMI":staff /usr/local/share/zsh
  sudo chown "$WHOAMI":staff /usr/local/share/zsh/site-functions
  sudo chmod -R 755 /usr/local/share/zsh
fi

if [ -d /opt/homebrew/share/zsh ]; then
  sudo chown "$WHOAMI":staff /opt/homebrew/share/zsh
  sudo chown "$WHOAMI":staff /opt/homebrew/share/zsh/site-functions
  sudo chmod -R 755 /opt/homebrew/share/zsh
fi

sudo chown -R "$(whoami):staff" /usr/local/bin
sudo chmod 755 /usr/local/bin

pushd "$HOME/.zsh" >/dev/null
find . -type f ! -path "./zsh-syntax-highlighting/*" ! -path "./zsh-syntax-highlighting" -exec chmod 600 {} \;
find . -type d ! -path "./zsh-syntax-highlighting/*" ! -path "./zsh-syntax-highlighting" -exec chmod 700 {} \;
popd >/dev/null


### ~/Applications / Dock Icons:
"$SCRIPT_DIR"/software-suite-home-applications.sh


echo ""
cecho "✔ Done!" $green
