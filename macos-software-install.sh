#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'
source ./lib/cecho
source ./lib/sw_install

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS software installation because not on macOS"
  exit 2
fi

cecho "----                             ----" $white
cecho "---- macOS Software Installation ----" $white
cecho "----                             ----" $white
echo ""
cecho "This will take a while. The computer should be plugged in and have a solid network connection." $red
cecho "If you don't wish to do this now, you can run 'make software-mac' later." $red
echo ""
cecho "Continue? (y/N)" $red
CONTINUE=false
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  exit 0
fi

mkdir -p "$HOME/.local/dotfiles/software"

echo -e "This script will use ${magenta}sudo${_reset}; enter your password to authenticate if prompted."
# Ask for the administrator password upfront and run a keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sw_install /usr/local/bin/mas "brew install mas"

sw_install /Applications/Xcode.app "mas install 497799835"
if ! xcode-select --print-path | grep -c "/Applications/Xcode.app" >/dev/null ; then
  sudo xcode-select --install
  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
fi
if ! xcodebuild -checkFirstLaunchStatus; then
  sudo xcodebuild -runFirstLaunch
fi

# sw_install's brew_[cask_]install uses `brew caveats`:
sw_install /usr/local/Cellar/brew-caveats \
  "brew tap rafaelgarrido/homebrew-caveats && brew install brew-caveats"

# untap caskroom/versions, which conflicts with homebrew/cask-versions:
if brew tap | grep -c caskroom/versions >/dev/null ; then
  brew untap caskroom/versions
fi

# tap the various casks that may be required:
if ! brew tap | grep -c homebrew/cask-versions >/dev/null ; then
  brew tap homebrew/cask-versions
fi
if ! brew tap | grep -c homebrew/cask-drivers >/dev/null ; then
  brew tap homebrew/cask-drivers
fi
if ! brew tap | grep -c homebrew/cask-fonts >/dev/null ; then
  brew tap homebrew/cask-fonts
fi
if ! brew tap | grep -c filippo.io/yubikey-agent >/dev/null ; then
  brew tap filippo.io/yubikey-agent https://filippo.io/yubikey-agent
fi
if ! brew tap | grep -c showwin/speedtest >/dev/null ; then
  brew tap showwin/speedtest
fi
if ! brew tap | grep -c wagoodman/dive >/dev/null ; then
  brew tap wagoodman/dive
fi

# begin with basic Homebrew installs:
# some of these (node, go, mas) are used later in this setup script.
sw_install /usr/local/bin/ag "brew_install ag"
sw_install /usr/local/bin/aws "brew_install awscli"
sw_install /usr/local/bin/bandwhich "brew_install bandwhich"
sw_install /usr/local/bin/bettercap "brew_install bettercap"
sw_install /usr/local/Cellar/bash-completion "brew_install bash-completion"
sw_install /usr/local/bin/cloc "brew_install cloc"
sw_install /usr/local/opt/coreutils/libexec/gnubin "brew_install coreutils"
sw_install /usr/local/bin/cowsay "brew_install cowsay"
sw_install /usr/local/opt/curl/bin/curl "brew_install curl"
sw_install /usr/local/bin/diff-so-fancy "brew_install diff-so-fancy"
sw_install /usr/local/bin/dust "brew_install dust"
sw_install /usr/local/bin/exa "brew_install exa"
sw_install /usr/local/bin/fzf "brew_install fzf"
sw_install /usr/local/bin/git "brew_install git"
sw_install /usr/local/bin/go "brew_install go"
sw_install /usr/local/bin/brew-gomod "brew install FiloSottile/gomod/brew-gomod"
sw_install /usr/local/bin/ggrep "brew_install grep"
sw_install /usr/local/bin/gron "brew_install gron"
sw_install /usr/local/bin/hexyl "brew_install hexyl"
sw_install /usr/local/bin/http "brew_install httpie"
sw_install /usr/local/bin/htop "brew_install htop"
sw_install /usr/local/bin/jq "brew_install jq"
sw_install /usr/local/bin/lua "brew_install lua"
sw_install /usr/local/bin/mdcat "brew_install mdcat"
sw_install /usr/local/sbin/mtr "brew_install mtr"
sw_install /usr/local/bin/mysides "brew_cask_install mysides"
sw_install /usr/local/bin/nano "brew_install nano"
sw_install /usr/local/bin/ncdu "brew_install ncdu"
sw_install /usr/local/bin/nmap "brew_install nmap"
sw_install /usr/local/bin/nnn "brew_install nnn"
sw_install /usr/local/bin/node "brew_install node"
sw_install /usr/local/bin/python3 "brew_install python"
sw_install /usr/local/bin/rdfind "brew_install rdfind"
sw_install /usr/local/bin/screen "brew_install screen"
sw_install /usr/local/bin/shellcheck "brew_install shellcheck"
sw_install /usr/local/bin/shfmt "brew_install shfmt"
sw_install /usr/local/bin/speedtest "brew_install speedtest"
sw_install /usr/local/opt/sqlite/bin/sqlite3 "brew_install sqlite"
sw_install /usr/local/bin/stow "brew_install stow"
sw_install /usr/local/Cellar/syncthing "brew_install syncthing && brew services start syncthing" \
  "- [ ] Begin syncing \`~/Sync\`\n- [ ] Update [Syncthing devices note](bear://x-callback-url/open-note?id=0FC65581-3166-44CF-99E6-4E82089EE4F0-316-0000A2DF53A3E8CD)"
sw_install /usr/local/bin/telnet "brew_install telnet"
sw_install /usr/local/bin/terminal-notifier "brew_install terminal-notifier"
sw_install /usr/local/bin/tig "brew_install tig"
sw_install /usr/local/bin/todos "brew_install tofrodos"
sw_install /usr/local/bin/trash "brew_install trash"
sw_install /usr/local/bin/tree "brew_install tree"
sw_install /usr/local/bin/wakeonlan "brew_install wakeonlan"
sw_install /usr/local/bin/wget "brew_install wget"
sw_install /usr/local/bin/xz "brew_install xz"
sw_install /usr/local/bin/yamllint "brew_install yamllint"
sw_install /usr/local/bin/yarn "brew_install yarn"
sw_install /usr/local/bin/yubikey-agent "brew_install yubikey-agent && brew services start yubikey-agent" \
  "- [ ] Use \`yubikey-agent -setup\` to generate a new SSH key, if needed"

sw_install "$HOME/Library/QuickLook/QLMarkdown.qlgenerator" \
  "brew_cask_install qlmarkdown"
sw_install "$HOME/Library/QuickLook/QuickLookJSON.qlgenerator" \
  "brew_cask_install quicklook-json"

sw_install /usr/local/bin/entr "brew_install entr"
# Fix "entr: Too many files listed; the hard limit for your login class is 256."
# http://eradman.com/entrproject/limits.html
_install_entr_workaround() {
  pushd /Library/LaunchDaemons
  sudo curl -sO "https://dropbox.dzombak.com/limit.maxfiles.plist"
  popd
}
sw_install /Library/LaunchDaemons/limit.maxfiles.plist _install_entr_workaround

# provides envsubst:
sw_install /usr/local/bin/gettext "brew_install gettext && brew link --force gettext"

# Install basic tools which use stuff we just installed via Homebrew:
sw_install /usr/local/bin/emoj 'npm install -g emoj@">=2.0.0"'
sw_install /usr/local/bin/markdown-toc 'npm install -g markdown-toc'
sw_install /usr/local/bin/nativefier 'npm install -g nativefier'
sw_install /usr/local/bin/bundler 'sudo gem install bundler'
sw_install /usr/local/bin/mdless 'sudo gem install mdless'
sw_install /usr/local/bin/qrcp "brew gomod github.com/claudiodangelis/qrcp"

# metar: CLI metar lookup tool
_install_metar() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'metar-work')
  git clone "https://github.com/RyuKojiro/metar.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  make
  sudo make install
  popd
}
sw_install /usr/local/bin/metar _install_metar

# my listening wrapper for lsof
_install_listening() {
  if [ -f "$HOME/opt/bin/listening" ]; then
    mv "$HOME/opt/bin/listening" /usr/local/bin
  else
    pushd /usr/local/bin
    wget https://gist.githubusercontent.com/cdzombak/fc0c0acbba9c302571add6dcd6d10deb/raw/c607f9fcc182ecc5d0fcc844bff67c1709847b55/listening
    chmod +x listening
    popd
  fi
}
sw_install "/usr/local/bin/listening" _install_listening

# my tool which keeps Keybase out of Finder favorites
_install_keybase_favorite_cleaner() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'remove-keybase-finder-favorite')
  git clone "https://github.com/cdzombak/remove-keybase-finder-favorite.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  chmod +x ./install.sh
  ./install.sh
  popd
}
sw_install /usr/local/opt/com.dzombak.remove-keybase-finder-favorite/bin/remove-keybase-finder-favorite _install_keybase_favorite_cleaner

_install_gmail_cleaner() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'gmail-cleaner')
  git clone "https://github.com/cdzombak/gmail-cleaner.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  make build-darwin-amd64
  cp ./out/darwin-amd64/gmail-cleaner "$HOME/opt/bin/gmail-cleaner"
  popd
  mkdir -p "$HOME/.config/gmail-cleaner-personal"
  # shellcheck disable=SC2129
  echo "## gmail-cleaner" >> "$HOME/SystemSetup.md"
  echo "" >> "$HOME/SystemSetup.md"
  echo -e "- [ ] Put credentials & token in ~/.config/gmail-cleaner-personal" >> "$HOME/SystemSetup.md"
  echo "" >> "$HOME/SystemSetup.md"
}
sw_install "$HOME/opt/bin/gmail-cleaner" _install_gmail_cleaner

# Move on to macOS applications:

_install_instapaper_reader() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'instapaper-reader')
  git clone "https://github.com/cdzombak/instapaper-reader.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  make install-mac
  popd
}
sw_install "/Applications/Instapaper Reader.app" _install_instapaper_reader \
  "- [ ] Sign in to Instapaper"

_install_ejector() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'ejector-work')
  pushd "$TMP_DIR"
  wget "https://ejector.app/releases/Ejector1.0.0.zip"
  unzip Ejector1.0.0.zip -d /Applications
  rm -rf /Applications/__MACOSX
  popd
}
sw_install /Applications/Ejector.app _install_ejector \
  "- [ ] Configure (start at login)\n- [ ] License"

sw_install "/Applications/1Password 7.app" "brew_cask_install 1password" \
  "- [ ] Sign in to 1Password account & start syncing\n- [ ] Enable 1Password Safari extension\n- [ ] Customize All Vaults\n- [ ] Set keyboard shortcuts\n- [ ] Enable Alfred integration"
sw_install "$HOME/Library/Screen Savers/Aerial.saver" "brew_cask_install aerial" \
  "- [ ] Configure screen saver (as desired)"
sw_install "/Applications/Alfred 4.app" "brew_cask_install alfred" \
  "- [ ] Launch & walk through setup\n- [ ] Disable Spotlight keyboard shortcut\n- [ ] Use Command-Space for Alfred\n- [ ] Sync settings from \`~/Sync/Configs\`\n- [ ] Enable automatic snippet expansion"
sw_install /Applications/AppCleaner.app "brew_cask_install appcleaner" \
  "- [ ] Enable SmartDelete (automatic watching for deleted apps)\n- [ ] Enable automatic updates"
sw_install /Applications/Arq.app "brew_cask_install arq" \
  "- [ ] Setup backups to Wasabi\n- [ ] Setup backups to Goliath\n- [ ] Add destination to \`curie\` & \`fresnel\`, as desired\n- [ ] Setup emails via Mailgun\n- [ ] Enable automatic updates\n- [ ] Enable backup using administrator privileges\n- [ ] Pause backups on battery power\n- [ ] Enable backup thinning"
sw_install "/Applications/Bartender 3.app" "brew_cask_install bartender" \
  "- [ ] Configure based on current favorite system/screenshots in \`~/Sync/Configs\`"
sw_install "$HOME/Library/Screen Savers/Brooklyn.saver" "brew_cask_install brooklyn" \
  "- [ ] Configure screen saver (as desired)"
sw_install "/Applications/Choosy.app" "brew_cask_install choosy" \
  "- [ ] License Choosy\n- [ ] Enable Choosy & Start at Login\n- [ ] Configure Choosy/Import and Tweak Choosy Config\n- [ ] Enable Choosy Safari extension"
sw_install /Applications/CommandQ.app "brew_cask_install commandq" \
  "- [ ] License\n- [ ] Enable Start at Login"
sw_install /Applications/FastScripts.app "brew_cask_install fastscripts" \
  "- [ ] License\n- [ ] Launch at login"
sw_install /Applications/Fork.app "brew_cask_install fork"
sw_install "/Applications/Google Chrome.app" "brew_cask_install google-chrome" \
  "- [ ] Sign into relevant Google Accounts"
sw_install "/Applications/Google Drive File Stream.app" "brew_cask_install google-drive-file-stream" \
  "- [ ] Sign into relevant Google Account\n- [ ] Verify Start at Login is set"
sw_install "/Applications/GPG Keychain.app" "brew_cask_install gpg-suite-no-mail" \
  "- [ ] Import/generate GPG keys as needed"
sw_install /Applications/Hammerspoon.app "brew_cask_install hammerspoon" \
  "- [ ] Configure to run at login\n- [ ] Enable Accessibility"
sw_install /Applications/IINA.app "brew_cask_install iina"
sw_install "/Applications/iStat Menus.app" "brew_cask_install istat-menus" \
  "- [ ] License\n- [ ] Configure based on current favorite system\n- [ ] Add to Today view"
sw_install /Applications/iTerm.app "brew_cask_install iterm2" \
  "- [ ] Sync settings from \`~/Sync/Configs\`, taking care not to overwrite the files there"
sw_install "/Applications/JetBrains Toolbox.app" "brew_cask_install jetbrains-toolbox" \
  "- [ ] Sign into JetBrains account\n- [ ] Enable automatic updates\n- [ ] Enable 'Generate Shell Scripts'\n- [ ] Enable 'Run at Login'\n- [ ] Install IDEs as desired\n- [ ] Enable Settings Repository syncing\n- [ ] Install plugins based on docs in \`~/Sync/Configs\`"
sw_install /Applications/Kaleidoscope.app "brew_cask_install kaleidoscope" \
  "- [ ] License\n- [ ] Set font: Meslo LG M Regular, size 13"
sw_install /Applications/Keybase.app "brew_cask_install keybase" \
  "- [ ] Sign in"
sw_install /Applications/LaunchControl.app "brew_cask_install launchcontrol" \
  "- [ ] License"
sw_install /Applications/LICEcap.app "brew_cask_install licecap"
sw_install /Applications/OmniDiskSweeper.app "brew_cask_install omnidisksweeper"
sw_install /Applications/OmniOutliner.app "brew_cask_install omnioutliner" \
  "- [ ] License\n- [ ] Link template folder in \`~/Sync/Configs/OmniOutliner\`"
sw_install /Applications/Paw.app "brew_cask_install paw" \
  "- [ ] Sign in / License"
sw_install /Applications/Rocket.app "brew_cask_install rocket" \
  "- [ ] Enable Accessibility\n- [ ] License\n- [ ] Enable Ctrl-Shift-M browse shortcut\n- [ ] Start at Login"
sw_install /Applications/SensibleSideButtons.app "brew_cask_install sensiblesidebuttons" \
  "- [ ] Start at Login\n- [ ] Enable\n- [ ] Enable Accessibility"
sw_install /Applications/Slack.app "brew_cask_install slack" \
  "- [ ] Sign in to Slack accounts"
sw_install /Applications/Sonos.app "brew_cask_install sonos"
sw_install /Applications/Spotify.app "brew_cask_install spotify"
sw_install "/Applications/Sublime Merge.app" "brew_cask_install sublime-merge"
sw_install "/Applications/The Unarchiver.app" "brew_cask_install the-unarchiver"
sw_install "/Applications/Transmit.app" "brew_cask_install transmit" \
  "- [ ] License\n- [ ] Sign into Panic Sync\n- [ ] Configure application"
sw_install "/Applications/Typora.app" "brew_cask_install typora" \
  "- [ ] Associate with Markdown files"
sw_install /Applications/Wireshark.app "brew_cask_install wireshark"

if [ -e "/Applications/Fantastical 2.app" ] && [ ! -e "/Applications/Fantastical.app" ]; then
  echo "Renaming 'Fantastical 2.app' to 'Fantastical.app'..."
  osascript -e "tell application \"Fantastical 2\" to quit"
  mv "/Applications/Fantastical 2.app" "/Applications/Fantastical.app"
fi
sw_install "/Applications/Fantastical.app" "brew_cask_install fantastical" \
  "- [ ] Enable 'Run in Background'\n- [ ] Sign into Flexibits account (via Apple)\n- [ ] Configure calendar accounts\n- [ ] Add to Today view\n- [ ] Configure application preferences\n- [ ] Enable color menu bar icon"

_install_dash() {
  brew cask install dash
  open -a Dash
  set +e
  open "$HOME/iCloud Drive/Software/Licenses/license.dash-license"
  set -e
}
sw_install /Applications/Dash.app _install_dash \
  "- [ ] Sync settings from \`~/Sync/Configs\`\n- [ ] Sync snippets\n- [ ] Arrange docsets as desired\n- [ ] License"

_install_sublimetext() {
  brew cask install sublime-text
  SUBLIMETEXT_INSTALLED_PKGS_DIR="$HOME/Library/Application Support/Sublime Text 3/Installed Packages"
  mkdir -p "$SUBLIMETEXT_INSTALLED_PKGS_DIR"
  pushd "$SUBLIMETEXT_INSTALLED_PKGS_DIR"
  wget https://packagecontrol.io/Package%20Control.sublime-package
  popd
  SUBLIMETEXT_PKGS_DIR="$HOME/Library/Application Support/Sublime Text 3/Packages"
  mkdir -p "$SUBLIMETEXT_PKGS_DIR"
  pushd "$SUBLIMETEXT_PKGS_DIR"
  git clone git@github.com:cdzombak/sublime-text-config.git User
  popd
}
sw_install "/Applications/Sublime Text.app" _install_sublimetext \
  "- [ ] Open the application and allow Package Control to finish installing packages as configured\n- [ ] License"
if [ ! -f /etc/paths.d/cdz.SublimeText ]; then
  # TODO(cdzombak): this may not work on Catalina
  #                 https://github.com/cdzombak/dotfiles/issues/15
  set -x
  sudo rm -f /etc/paths.d/cdz.SublimeText
  echo '/Applications/Sublime Text.app/Contents/SharedSupport/bin' | sudo tee -a /etc/paths.d/cdz.SublimeText > /dev/null
  set +x
fi
if [ ! -L "$HOME/.config/sublimetext" ]; then
  set -x
  ln -s "$HOME/Library/Application Support/Sublime Text 3/Packages/User" "$HOME/.config/sublimetext"
  set +x
fi
if [ -L "$HOME/.sublime-config" ]; then
  rm "$HOME/.sublime-config"
fi

_install_redeye() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'redeye-work')
  pushd "$TMP_DIR"
  wget "https://www.hexedbits.com/downloads/redeye.zip"
  unzip redeye.zip -d /Applications
  rm -rf /Applications/__MACOSX
  popd
}
sw_install "/Applications/Red Eye.app" _install_redeye

sw_install "$HOME/Library/Fonts/MesloLGM-Regular.ttf" "brew_cask_install font-meslo-lg"
sw_install "$HOME/Library/Fonts/Meslo LG M Regular for Powerline.otf" "brew_cask_install font-meslo-for-powerline"
sw_install "$HOME/Library/Fonts/NationalPark-Regular.otf" "brew_cask_install font-national-park"

sw_install "/Applications/Marked 2.app" "brew_cask_install marked" \
  "- [ ] License\n- [ ] Install Custom CSS from \`~/Sync/Configs\`"
if [ ! -L /Applications/Marked.app ]; then
  # compatibility with old "Open in Marked" IntelliJ plugin which hardcodes this path to Marked:
  ln -s "/Applications/Marked 2.app" /Applications/Marked.app
fi

_install_json_viewer() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'json-viewer')
  git clone "git@github.com:cdzombak/jsonview.git" "$TMP_DIR"
  pushd "$TMP_DIR/app"
  make install-mac
  popd
}
sw_install "/Applications/JSON Viewer.app" _install_json_viewer

# macOS Applications from Mac App Store:

sw_install /Applications/Bear.app "mas install 1091189122" \
  "- [ ] Assign keyboard shortcuts\n- [ ] Enable Bear Safari extension"
sw_install /Applications/Better.app "mas install 1121192229" \
  "- [ ] Enable Better Blocker Safari extension"
# sw_install /Applications/Byword.app "mas install 420212497"
sw_install /Applications/ColorSnapper2.app "mas install 969418666"
sw_install /Applications/Claquette.app "mas install 587748131"
sw_install "/Applications/Day One.app" "mas install 1055511498 && sudo bash /Applications/Day\ One.app/Contents/Resources/install_cli.sh" \
  "- [ ] Sign into Day One account\n- [ ] Enable Day One Safari extension\n- [ ] Sign into Day One Safari extension\n- [ ] Disable global shortcut"
sw_install /Applications/Deliveries.app "mas install 924726344" \
  "- [ ] Sign into Junecloud account\n- [ ] Enable background upadting\n- [ ] Add to Today view\n- [ ] Disable all notifications options, except showing in Notification Center"
sw_install /Applications/Diagrams.app "mas install 1276248849"
sw_install /Applications/Discovery.app "mas install 1381004916"
sw_install /Applications/Expressions.app "mas install 913158085"
sw_install "/Applications/GIF Brewery 3.app" "mas install 1081413713"
sw_install "/Applications/Front and Center.app" "mas install 1493996622"
sw_install /Applications/IPinator.app "mas install 959111981" \
  "- [ ] Add to Today view"
sw_install /Applications/Numbers.app "mas install 409203825"
sw_install /Applications/Pages.app "mas install 409201541"
sw_install /Applications/Pastebot.app "mas install 1179623856" \
  "- [ ] Start at login\n- [ ] Set/confirm Shift-Command-V global shortcut\n- [ ] Configure, especially Always Paste Plain Text"
sw_install /Applications/PDFScanner.app "mas install 410968114"
sw_install /Applications/RadarScope.app "mas install 432027450" \
  "- [ ] Restore purchases\n- [ ] Sign into relevant accounts"
sw_install /Applications/Reeder.app "mas install 1449412482" \
  "- [ ] Sign into Feedbin\n- [ ] Feedbin settings: sync every 15m; sync on wake; unread count in app icon; keep 2 days archive"
sw_install "/Applications/WiFi Explorer.app" "mas install 494803304"
sw_install "/Applications/Triode.app" "mas install 1450027401"

_install_things() {
  mas install 904280696 # Things
  brew cask install thingsmacsandboxhelper
}
sw_install "/Applications/Things3.app" _install_things \
  "- [ ] Sign into Things Cloud account\n- [ ] Configure as desired\n- [ ] Add to Today view"

_install_thingshub() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'thingshub')
  git clone "https://github.com/cdzombak/thingshub.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  make install
  popd
  mkdir -p "$HOME/.local"
  touch "$HOME/.local/thingshubd.list"
  pushd "$TMP_DIR/thingshubd"
  make install
  popd
}
sw_install "/usr/local/bin/thingshub" _install_thingshub

_install_unshorten() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'unshorten')
  git clone "https://github.com/cdzombak/unshorten.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  make install
  popd
}
sw_install "/usr/local/bin/unshorten" _install_unshorten

# Install Webster's 1913 Dictionary
# mirrored from https://github.com/ponychicken/WebsterParser/releases/tag/0.0.2
# See: http://jsomers.net/blog/dictionary
_install_websters() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'dictionary')
  pushd "$TMP_DIR"
  wget https://dropbox.dzombak.com/websters-1913/Webster.s.1913.dictionary.zip
  unzip Webster.s.1913.dictionary.zip -d "$HOME/Library/Dictionaries/"
  rm -rf "$HOME/Library/Dictionaries/__MACOSX"
  popd
  cecho "Opening Dictionary.app; please rearrange Webster’s 1913 to the top / as desired." $white
  open -a Dictionary
}
sw_install "$HOME/Library/Dictionaries/Webster’s 1913.dictionary" _install_websters \
  "- [ ] Drag Webster’s 1913 to the top of the list in Dictionary.app's Preferences"

sw_install /Applications/AccessControlKitty.app "mas install 1450391666" "- [ ] Enable AccessControlKitty in System Preferences/Extensions"

# Solarized for Xcode
# if this source disappears, there's also my copy in Sync/Configs
_install_xcode_solarized() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'solarized-xcode')
  git clone "https://github.com/stackia/solarized-xcode.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  xcode_color_themes_dir="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
  mkdir -p "$xcode_color_themes_dir"
  cp ./*.dvtcolortheme "$xcode_color_themes_dir"
  popd
}
sw_install "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/Solarized Light.dvtcolortheme" _install_xcode_solarized "- [ ] Enable color theme in Xcode\n- [ ] Customize font & size"

_install_setapp() {
  brew cask install setapp
  open -a "$(brew cask info setapp | grep '/usr/local/caskroom' | cut -d' ' -f1)/Install Setapp.app"
  while [ ! -e /Applications/Setapp.app ]; do
    cecho "Please complete Setapp installation." $white
    read -p "Press [Enter] to continue..."
  done
}
sw_install /Applications/Setapp.app _install_setapp \
  "- [ ] Sign in to Setapp\n- [ ] Install & configure applications from Setapp Favorites (as desired)"

sw_install "/Applications/Easy CSV Editor.app" "mas install 1171346381" \
  "- [ ] Associate with CSV files"

sw_install "/Applications/JSON Editor.app" "mas install 567740330" \
  "- [ ] Associate with JSON files"

sw_install "/Applications/PLIST Editor.app" "mas install 1157491961" \
  "- [ ] Associate with PLIST files"

_install_ears() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'ears')
  pushd "$TMP_DIR"
  wget -O ears.zip "https://clickontyler.com/ears/download/v1/"
  unzip ears.zip -d "/Applications/"
  rm -rf "/Applications/__MACOSX"
  popd
}
sw_install "/Applications/Ears.app" _install_ears \
  "- [ ] License Ears\n- [ ] Add AirPods Pro\n- [ ] Configure as desired\n- [ ] Hide macOS volume control in menu bar"

sw_install "$HOME/Library/Sounds/Honk.aiff" "wget -P $HOME/Library/Sounds https://dropbox.dzombak.com/Honk.aiff" \
  "- [ ] Set Honk as system error sound, as desired"

echo ""
cecho "--- Interactive Section ---" $white
cecho "The remaining applications/tools are not installed by default, since they may be unneeded/unwanted in some system setups." $white

GOINTERACTIVE=true
cecho "Skip the interactive section? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  GOINTERACTIVE=false
  echo "Moving on."
fi

if $GOINTERACTIVE; then

echo ""
cecho "--- Utilities ---" $white
echo ""

_install_netdata() {
  cecho "Install Netdata? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install netdata
    brew services start netdata
  fi
}
sw_install /usr/local/sbin/netdata _install_netdata

_install_superduper(){
  cecho "Install SuperDuper? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install superduper
    # shellcheck disable=SC2129
    echo "## SuperDuper.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Add this system to backup strategy/plan/routine" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install "/Applications/SuperDuper!.app" _install_superduper

if [ ! -e "$HOME/.local/dotfiles/software/no-home-hardware-utils" ]; then
  echo ""
  cecho "Install utilities for home hardware devices (Garmin, MyHarmony, ScanSnap)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install /Applications/ScanSnap "brew_cask_install fujitsu-scansnap-manager"
    sw_install /Applications/MyHarmony.app "brew_cask_install logitech-myharmony"
    sw_install "/Applications/Garmin Express.app" "brew_cask_install garmin-express"
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.local/dotfiles/software/no-home-hardware-utils"
  fi
fi

_install_iperf3() {
  cecho "Install iperf3? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install iperf3
  fi
}
sw_install /usr/local/bin/iperf3 _install_iperf3

_install_angryipscan() {
  cecho "Install Angry IP Scanner? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install angry-ip-scanner
  fi
}
sw_install "/Applications/Angry IP Scanner.app" _install_angryipscan

_install_balena_etcher() {
  cecho "Install balena etcher (for burning SD card images)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install balenaetcher
  fi
}
sw_install /Applications/balenaEtcher.app _install_balena_etcher

_install_coconutbattery() {
  cecho "Install CoconutBattery? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install coconutbattery
  fi
}
sw_install /Applications/coconutBattery.app _install_coconutbattery

_install_sshuttle() {
  cecho "Install sshuttle (proxy server that works as a poor man's VPN)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install sshuttle
  fi
}
sw_install /usr/local/bin/sshuttle _install_sshuttle

_install_ivpn_client() {
  cecho "Install IVPN client? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install ivpn
  fi
}
sw_install /Applications/IVPN.app _install_ivpn_client

if [ -e "/Applications/TorBrowser.app" ]; then
  if [ ! -e "/Applications/Tor Browser.app" ]; then
    mv "/Applications/TorBrowser.app" "/Applications/Tor Browser.app"
  else
    trash "/Applications/TorBrowser.app"
  fi
fi

_install_torbrowser() {
  cecho "Install Tor Browser? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install tor-browser
  fi
}
sw_install "/Applications/Tor Browser.app" _install_torbrowser

_install_daisydisk() {
  cecho "Install DaisyDisk? (note: OmniDiskSweeper is installed already) (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 411643860 # DaisyDisk
  fi
}
sw_install /Applications/DaisyDisk.app _install_daisydisk

if [ ! -e "$HOME/.local/dotfiles/software/no-screensconnect" ]; then
  _install_screensconnect() {
    cecho "Install Screens Connect? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew cask install screens-connect
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.local/dotfiles/software/no-screensconnect"
    fi
  }
  sw_install "/Applications/Screens Connect.app" _install_screensconnect
fi

_install_vncviewer() {
  cecho "Install VNC Viewer? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install vnc-viewer
  fi
}
sw_install "/Applications/VNC Viewer.app" _install_vncviewer

_install_cubicsdr() {
  cecho "Install CubicSDR? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install cubicsdr
  fi
}
sw_install /Applications/CubicSDR.app _install_cubicsdr

_install_mactracker() {
  cecho "Install MacTracker? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 430255202 # MacTracker
  fi
}
sw_install /Applications/MacTracker.app _install_mactracker

echo "Install/update my notify-me script (requires SSH setup & authorized to log in to burr)? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  if [ -f "$HOME/opt/bin/notify-me" ]; then
    rm "$HOME/opt/bin/notify-me"
  fi
  scp cdzombak@burr.cdzombak.net:/home/cdzombak/opt/bin/notify-me "$HOME/opt/bin/notify-me"
fi

echo ""
cecho "--- Dev Tools ---" $white
echo ""

cecho "Install some common Go tools (golint, goimports, gorc)? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install "/usr/local/bin/golint" "brew gomod golang.org/x/lint/golint"
  sw_install "/usr/local/bin/goimports" "brew gomod golang.org/x/tools/cmd/goimports"
  sw_install "/usr/local/bin/gorc" "brew gomod github.com/stretchr/gorc"
fi

cecho "Install common Python tools (virtualenv, pipenv, pyenv)? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install /usr/local/bin/virtualenv 'PIP_REQUIRE_VIRTUALENV="0" pip install virtualenv'
  sw_install /usr/local/bin/pipenv "brew_install pipenv"
  # optional, but recommended build deps w/pyenv: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  sw_install /usr/local/bin/pyenv "brew install pyenv openssl readline sqlite3 xz zlib"
fi

cecho "Install common Python code quality tools (flake8, pylint, pycodestyle)? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install /usr/local/bin/flake8 "brew_install flake8"
  sw_install /usr/local/bin/pylint "brew_install pylint"
  sw_install /usr/local/bin/pycodestyle "brew_install pycodestyle"
fi

cecho "Install Docker & related tools? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install /Applications/Docker.app "brew_cask_install docker"
  sw_install /usr/local/bin/dockerfilelint 'npm install -g dockerfilelint@">=1.5.0"'
  sw_install /usr/local/bin/dive "brew_install dive"
fi

_install_virtualbox() {
  cecho "Install VirtualBox? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install virtualbox virtualbox-extension-pack
    mkdir -p "$HOME/VirtualBox VMs"
    mkdir -p "$HOME/VM Images"
  fi
}
sw_install /Applications/VirtualBox.app _install_virtualbox

_install_gcloud_sdk() {
  cecho "Install Google Cloud SDK? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install google-cloud-sdk
  fi
}
sw_install /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk _install_gcloud_sdk

_install_kail() {
  cecho "Install kail (kubernetes tail)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if ! brew tap | grep -c boz/repo >/dev/null ; then
      brew tap boz/repo
    fi
    brew install boz/repo/kail
  fi
}
sw_install /usr/local/bin/kail _install_kail

_install_k9s() {
  cecho "Install k9s (https://github.com/derailed/k9s)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install derailed/k9s/k9s
  fi
}
sw_install /usr/local/bin/k9s _install_k9s

_install_lensapp() {
  cecho "Install Lens for k8s (https://github.com/lensapp/lens)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    set -x
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'lens')
    pushd "$TMP_DIR" >/dev/null
    curl -s https://api.github.com/repos/lensapp/lens/releases/latest | jq -r ".assets[].browser_download_url" | grep ".dmg$" | xargs wget -q -O Lens.dmg
    hdiutil attach Lens.dmg
    for d in /Volumes/Lens*/; do
      if [ -e "$d""Lens.app" ]; then
        cp -R "$d""Lens.app" /Applications/
        hdiutil detach "$d"
        break
      fi
    done
    popd >/dev/null
    set +x
  fi
}
sw_install /Applications/Lens.app _install_lensapp

echo ""
cecho "Install Java tools (JDK, Maven, Gradle completion for bash/zsh)? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install /usr/local/Caskroom/java "brew_cask_install java"
  sw_install /usr/local/Cellar/gradle-completion "brew_install gradle-completion"
  sw_install /usr/local/bin/mvn "brew_install maven"
fi

_install_sbt() {
  cecho "Install Scala tools (sbt)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install sbt
  fi
}
sw_install /usr/local/bin/sbt _install_sbt

_install_tsc() {
  cecho "Install tsc (TypeScript compiler)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
     npm install -g typescript
  fi
}
sw_install /usr/local/bin/tsc _install_tsc

cecho "Install React Native CLI & related tools? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install /usr/local/bin/watchman "brew_install watchman"
  sw_install /usr/local/bin/react-native "npm install -g react-native-cli"
fi

cecho "Install JS/TS code quality tools (prettier, eslint, jshint)? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
   sw_install /usr/local/bin/prettier 'brew_install prettier'
   sw_install /usr/local/bin/eslint 'brew_install eslint'
   sw_install /usr/local/bin/jshint 'npm install -g jshint'
fi

_install_nodemon() {
  cecho "Install nodemon (filesystem watcher for Node/NPM projects)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
     npm install -g nodemon
  fi
}
sw_install /usr/local/bin/nodemon _install_nodemon

_install_carthage() {
  cecho "Install Carthage? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install carthage
  fi
}
sw_install /usr/local/bin/carthage _install_carthage

_install_fastlane() {
  cecho "Install Fastlane? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install fastlane
  fi
}
sw_install "$HOME/.fastlane/bin/fastlane" _install_fastlane

_install_gotask() {
  cecho "Install task (simpler Make alternative written in Go)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install go-task/tap/go-task
  fi
}
sw_install /usr/local/bin/task _install_gotask

cecho "Install Latex tools? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  cecho "TODO(cdzombak): script artifacts checks for Latex tools" $red
  echo "           See: https://github.com/cdzombak/dotfiles/issues/9"
  brew cask install mactex
  brew cask install texmaker
fi

_install_wwdcapp() {
  cecho "Install WWDC macOS application (for watching/downloading videos)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install wwdc
  fi
}
sw_install /Applications/WWDC.app _install_wwdcapp

_install_sfsymbols() {
  cecho "Install Apple's SF Symbols Mac app? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
     brew cask install sf-symbols
  fi
}
sw_install "/Applications/SF Symbols.app" _install_sfsymbols

cecho "Database tools..." $white
cecho "There are a lot of options here: JetBrains DataGrip/IntelliJ, MySQLWorkbench, Liya (SQLite), plus tools from Setapp (favorite is SQLPro)." $white

_install_mysqlworkbench() {
  cecho "Install MySQLWorkbench? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install mysqlworkbench
  fi
}
sw_install /Applications/MySQLWorkbench.app _install_mysqlworkbench

_install_liya() {
  cecho "Install Liya (for SQLite, from Mac App Store)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 455484422 # Liya - SQLite
  fi
}
sw_install /Applications/Liya.app _install_liya

echo ""
cecho "--- Media Tools ---" $white
echo ""

_install_calibre() {
  cecho "Install Calibre? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install calibre
  fi
}
sw_install /Applications/calibre.app _install_calibre

_install_pixelmator() {
  cecho "Install Pixelmator? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 407963104
  fi
}
sw_install /Applications/Pixelmator.app _install_pixelmator

if [ ! -e "$HOME/.local/dotfiles/software/no-adobecc" ]; then
  _install_adobe_cc() {
    cecho "Install Adobe Creative Cloud? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew cask install adobe-creative-cloud
      # shellcheck disable=SC2129
      echo "## Adobe Creative Cloud" >> "$HOME/SystemSetup.md"
      echo "" >> "$HOME/SystemSetup.md"
      echo -e "- [ ] Sign into Adobe Account\n-[ ] Install Lightroom\n- [ ] Install Photoshop" >> "$HOME/SystemSetup.md"
      echo "" >> "$HOME/SystemSetup.md"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.local/dotfiles/software/no-adobecc"
    fi
  }
  sw_install "/Applications/Adobe Creative Cloud" _install_adobe_cc
fi

if [ ! -e "$HOME/.local/dotfiles/software/no-applepromediatools" ]; then
  echo ""
  cecho "Install Logic Pro, Final Cut Pro, and related tools? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install "/Applications/Logic Pro X.app" "mas install 634148309"
    sw_install "/Applications/Compressor.app" "mas install 424390742"
    sw_install "/Applications/Final Cut Pro.app" "mas install 424389933"
    sw_install "/Applications/Motion.app" "mas install 434290957"
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.local/dotfiles/software/no-applepromediatools"
  fi
fi

_install_youtubedl() {
  cecho "Install youtube-dl? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install youtube-dl
  fi
}
sw_install /usr/local/bin/youtube-dl _install_youtubedl

if [ ! -e "$HOME/.local/dotfiles/software/no-handbrake" ]; then
  _install_handbrake() {
    cecho "Install Handbrake? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew cask install handbrake
      sw_install /usr/local/lib/libmp3lame.dylib "brew_install lame"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.local/dotfiles/software/no-handbrake"
    fi
  }
  sw_install /Applications/Handbrake.app _install_handbrake
fi

echo ""
cecho "Install podcasting utilities (Skype + Call Recorder)? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install /Applications/Skype.app "brew_cask_install skype" \
    "- [ ] Sign in\n- [ ] Install Ecamm Call Recorder"
  cecho "To install Ecamm Call Recorder, download it from your customer link (in 1Password, or your email archive - look for email from supportdesk@ecamm.com)" $red
fi

_install_photosweeper() {
  cecho "Install PhotoSweeper X? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install photosweeper-x
  fi
}
sw_install "/Applications/PhotoSweeper X.app" _install_photosweeper

_install_fileloupe() {
  cecho "Install Fileloupe media browser? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 944693506 # Fileloupe
  fi
}
sw_install /Applications/Fileloupe.app _install_fileloupe

cecho "Install/update my quick ffmpeg media conversion scripts? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'ffmpegscripts')
  git clone "https://github.com/cdzombak/quick-ffmpeg-scripts.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  chmod +x ./install.sh
  ./install.sh
  popd
fi

echo ""
cecho "--- Music / Podcasts / Reading ---" $white
echo ""

_install_plexdesktop() {
  cecho "Install Plex Desktop? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install plex
    # shellcheck disable=SC2129
    echo "## Plex.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Sign into Plex account\n- [ ] Reorder sidebar based on screenshots in \`~/Sync/Configs\` / as desired" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/Plex.app _install_plexdesktop

_install_plexamp() {
  cecho "Install Plexamp? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install plexamp
    # shellcheck disable=SC2129
    echo "## Plexamp.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Sign into Plex account" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/Plex.app _install_plexamp

_install_neptunes() {
  cecho "Install NepTunes? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1006739057
    # shellcheck disable=SC2129
    echo "## NepTunes.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Sign into last.fm\n-[ ] Configure" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/NepTunes.app _install_neptunes

_install_pocketcasts() {
  cecho "Install Pocket Casts? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install pocket-casts
  fi
}
sw_install "/Applications/Pocket Casts.app" _install_pocketcasts

_install_kindle() {
  cecho "Install Kindle? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 405399194 # Kindle
  fi
}
sw_install /Applications/Kindle.app _install_kindle

echo ""
cecho "--- Office Tools ---" $white
echo ""

_install_zoom() {
  cecho "Install Zoom for videoconferencing? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # keep Zoom from installing its shitty local webserver thing
    rm -rf "$HOME/.zoomus"
    touch "$HOME/.zoomus"
    brew cask install zoomus
  fi
}
sw_install /Applications/zoom.us.app _install_zoom \
  "- [ ] Enable microphone mute when joining meeting"

_install_omnigraffle() {
  cecho "Install OmniGraffle? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install omnigraffle
    # shellcheck disable=SC2129
    echo "## OmniGraffle.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] License" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/OmniGraffle.app _install_omnigraffle

_install_monodraw() {
  cecho "Install Monodraw? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install monodraw
  fi
}
sw_install /Applications/Monodraw.app _install_monodraw

_install_keynote() {
  cecho "Install Keynote? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 409183694 # Keynote
  fi
}
sw_install /Applications/Keynote.app _install_keynote

_install_deckset() {
  cecho "Install Deckset? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install deckset
  fi
}
sw_install /Applications/Deckset.app _install_deckset

_install_calca() {
  cecho "Install Calca? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 635758264 # Calca
  fi
}
sw_install /Applications/Calca.app _install_calca

_install_tableflip() {
  cecho "Install TableFlip (Markdown table utility)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install tableflip
  fi
}
sw_install /Applications/TableFlip.app _install_tableflip

_install_tadam() {
  cecho "Install Tadam focus timer? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 531349534 # Tadam
  fi
}
sw_install /Applications/Tadam.app _install_tadam

echo ""
cecho "--- Games & Social Networking ---" $white
echo ""

if [ ! -e "$HOME/.local/dotfiles/software/no-social" ]; then
  cecho "Install social networking software (Caprine, Flume, Tweetbot)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install /Applications/Caprine.app "brew_cask_install caprine"
    # shellcheck disable=SC2129
    echo "## Caprine.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Sign into Facebook account" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"

    _install_flume() {
      cecho 'Please install Flume from Setapp.' $white
      open /Applications/Setapp.app
    }
    sw_install /Applications/Setapp/Flume.app _install_flume
    # shellcheck disable=SC2129
    echo "## Flume.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Install app from Setapp\n- [ ] Sign into Instagram account" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"

    sw_install /Applications/Tweetbot.app "mas install 1384080005"
    # shellcheck disable=SC2129
    echo "## Tweetbot.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Sign into Twitter accounts\n- [ ] Configure/disable notifications" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    # https://twitter.com/dancounsell/status/667011332894535682
    cecho "Set: Avoid t.co in Tweetbot-Mac" $cyan
    set -x
    defaults write com.tapbots.TweetbotMac OpenURLsDirectly YES
    set +x
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.local/dotfiles/software/no-social"
  fi
fi

if [ ! -e "$HOME/.local/dotfiles/software/no-nsnake" ]; then
  _install_nsnake() {
    cecho "Install nsnake? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install nsnake
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.local/dotfiles/software/no-nsnake"
    fi
  }
  sw_install /usr/local/bin/nsnake _install_nsnake
fi

if [ ! -e "$HOME/.local/dotfiles/software/no-minimetro" ]; then
  _install_minimetro() {
    cecho "Install Mini Metro? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      mas install 1047760200 # Mini Metro
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.local/dotfiles/software/no-minimetro"
    fi
  }
  sw_install "/Applications/Mini Metro.app" _install_minimetro
fi

if [ ! -e "$HOME/.local/dotfiles/software/no-simcity" ]; then
  _install_simcity() {
    cecho "Install SimCity 4 Deluxe? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      mas install 804079949 # SimCity 4 Deluxe Edition
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.local/dotfiles/software/no-simcity"
    fi
  }
  sw_install "/Applications/Sim City 4 Deluxe Edition.app" _install_simcity
fi

fi # $GOINTERACTIVE

echo ""
cecho "--- Removing software I no longer use ---" $white
echo ""

REMOVED_ANYTHING=false

verify_smartdelete() {
  while ! pgrep "net.freemacsoft.AppCleaner-SmartDelete" >/dev/null; do
    cecho "Please enable AppCleaner's 'Smart Delete' feature, via the app's preferences." $white
    open -a AppCleaner
    read -p "Press [Enter] to continue..."
  done
}

if [ -e "/usr/local/bin/gpg" ]; then
  if ! ls -la /usr/local/bin/gpg | grep -c "MacGPG" >/dev/null ; then
    echo "GnuPG (Homebrew install; use MacGPG instead)..."
    brew uninstall gnupg
    REMOVED_ANYTHING=true
  fi
fi

if [ -e "/Applications/AltTab.app" ]; then
  echo "AltTab..."
  verify_smartdelete
  trash /Applications/AltTab.app
  REMOVED_ANYTHING=true
fi

if [ -e "/Applications/Bunch.app" ]; then
  echo "Bunch..."
  verify_smartdelete
  trash /Applications/Bunch.app
  REMOVED_ANYTHING=true
fi

if [ -e "/Applications/Burn.app" ]; then
  echo "Burn (CD burner)..."
  verify_smartdelete
  trash /Applications/Burn.app
  REMOVED_ANYTHING=true
fi

if [ -e "/Applications/Due.app" ]; then
  echo "Due (Reminders app; syncing seems broken)..."
  verify_smartdelete
  trash /Applications/Due.app
  REMOVED_ANYTHING=true
fi

if [ -e "/Applications/Grasshopper.app" ]; then
  echo "Grasshopper..."
  verify_smartdelete
  trash /Applications/Grasshopper.app
  REMOVED_ANYTHING=true
fi

if [ -e "/Applications/Living Earth Desktop.app" ]; then
  echo "Living Earth Desktop..."
  verify_smartdelete
  trash "/Applications/Living Earth Desktop.app"
  REMOVED_ANYTHING=true
fi

if [ -e "/Applications/OmniFocus.app" ]; then
  echo "OmniFocus..."
  verify_smartdelete
  trash /Applications/OmniFocus.app
  REMOVED_ANYTHING=true
fi

if [ -e "/Applications/TIDAL.app" ]; then
  echo "TIDAL..."
  verify_smartdelete
  trash /Applications/TIDAL.app
  REMOVED_ANYTHING=true
fi

if [ -e /Applications/Wavebox.app ]; then
  echo "Wavebox..."
  verify_smartdelete
  trash /Applications/Wavebox.app
  REMOVED_ANYTHING=true
fi

if [ -e /Applications/WireGuard.app ]; then
  echo "WireGuard Client..."
  verify_smartdelete
  trash /Applications/WireGuard.app
  REMOVED_ANYTHING=true
fi

if ! $REMOVED_ANYTHING; then
  echo "Nothing to do."
fi

echo ""
cecho "--- Installations that run after most others due to complexities/cleanups ---" $white
echo ""

echo "Cleaning up kubectl installed via gcloud/docker ..."
if command -v gcloud >/dev/null; then
  if gcloud components list --only-local-state | grep -c "kubectl" >/dev/null; then
    echo "Uninstalling kubectl via gcloud."
    gcloud components remove kubectl
  fi
fi
if file -h /usr/local/bin/kubectl | grep -c "Applications/Docker.app/Contents/Resources/bin" >/dev/null; then
  echo "Removing kubectl symlink to Docker.app."
  rm /usr/local/bin/kubectl
fi
_install_kubectl() {
  echo ""
  cecho "Install kubectl? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install kubectl
  fi
}
sw_install /usr/local/bin/kubectl _install_kubectl
echo ""

echo ""
cecho "--- Stuff that failed the last time this script was used ---" $white
echo ""

set +e

_install_swiftsh() {
  echo ""
  cecho "Install swift-sh? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install mxcl/made/swift-sh
  fi
}
sw_install /usr/local/bin/swift-sh _install_swiftsh

_install_sqlint() {
  echo ""
  cecho "Install sqlint? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo xcode-select --switch /Library/Developer/CommandLineTools
    sudo gem install sqlint
    sudo xcode-select --switch /Applications/Xcode.app
  fi
}
sw_install /usr/local/bin/sqlint _install_sqlint

set -e

echo ""
cecho "✔ Done!" $green
