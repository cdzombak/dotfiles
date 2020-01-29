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
# Ask for the administrator password upfront and run a keep-alive to update
# existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sw_install /Applications/Xcode.app "mas install 497799835"

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
sw_install /usr/local/Cellar/bash-completion "brew_install bash-completion"
sw_install /usr/local/bin/cloc "brew_install cloc"
sw_install /usr/local/opt/coreutils/libexec/gnubin "brew_install coreutils"
sw_install /usr/local/bin/cowsay "brew_install cowsay"
sw_install /usr/local/opt/curl/bin/curl "brew_install curl"
sw_install /usr/local/bin/diff-so-fancy "brew_install diff-so-fancy"
sw_install /usr/local/bin/dive "brew_install dive"
sw_install /usr/local/bin/dust "brew_install dust"
sw_install /usr/local/bin/eslint "brew_install eslint"
sw_install /usr/local/bin/exa "brew_install exa"
sw_install /usr/local/bin/flake8 "brew_install flake8"
sw_install /usr/local/bin/fzf "brew_install fzf"
sw_install /usr/local/bin/git "brew_install git"
sw_install /usr/local/bin/go "brew_install go"
sw_install /usr/local/bin/ggrep "brew_install grep"
sw_install /usr/local/bin/gron "brew_install gron"
sw_install /usr/local/bin/hexyl "brew_install hexyl"
sw_install /usr/local/bin/htop "brew_install htop"
sw_install /usr/local/bin/jq "brew_install jq"
sw_install /usr/local/bin/lua "brew_install lua"
sw_install /usr/local/bin/mas "brew_install mas"
sw_install /usr/local/bin/mdcat "brew_install mdcat"
sw_install /usr/local/sbin/mtr "brew_install mtr"
sw_install /usr/local/bin/mysides "brew_cask_install mysides"
sw_install /usr/local/bin/nano "brew_install nano"
sw_install /usr/local/bin/ncdu "brew_install ncdu"
sw_install /usr/local/bin/nmap "brew_install nmap"
sw_install /usr/local/bin/nnn "brew_install nnn"
sw_install /usr/local/bin/node "brew_install node"
sw_install /usr/local/bin/prettier "brew_install prettier"
sw_install /usr/local/bin/pycodestyle "brew_install pycodestyle"
sw_install /usr/local/bin/python3 "brew_install python"
sw_install /usr/local/bin/rdfind "brew_install rdfind"
sw_install /usr/local/bin/screen "brew_install screen"
sw_install /usr/local/bin/shellcheck "brew_install shellcheck"
sw_install /usr/local/bin/shfmt "brew_install shfmt"
sw_install /usr/local/bin/speedtest "brew_install speedtest"
sw_install /usr/local/opt/sqlite/bin/sqlite3 "brew_install sqlite"
sw_install /usr/local/bin/stow "brew_install stow"
sw_install /usr/local/Cellar/syncthing "brew_install syncthing && brew services start syncthing" \
  "- [ ] Begin syncing ~/Sync"
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

sw_install /usr/local/bin/golangci-lint 'brew_install golangci/tap/golangci-lint'
sw_install /usr/local/bin/task 'brew_install go-task/tap/go-task'

sw_install /usr/local/bin/dockerfilelint 'npm install -g dockerfilelint@">=1.5.0"'
sw_install /usr/local/bin/emoj 'npm install -g emoj@">=2.0.0"'
sw_install /usr/local/bin/jshint 'npm install -g jshint'
sw_install /usr/local/bin/markdown-toc 'npm install -g markdown-toc'
sw_install /usr/local/bin/tsc 'npm install -g typescript'

sw_install /usr/local/bin/mdless 'sudo gem install mdless'
sw_install /usr/local/bin/sqlint 'sudo gem install sqlint'

sw_install /usr/local/bin/virtualenv 'PIP_REQUIRE_VIRTUALENV="0" pip install virtualenv'

# setup a bare-bones go env and install some basic/helpful Go tools:
export GOPATH="$HOME/go"
export GOROOT=/usr/local/opt/go/libexec
export PATH="$GOROOT/bin:$HOME/go/bin:$HOME/code/go/bin:$PATH"
sw_install "$HOME/go/bin/golint" "go get golang.org/x/lint/golint"
sw_install "$HOME/go/bin/goimports" "go get golang.org/x/tools/cmd/goimports"
sw_install "$HOME/go/bin/gorc" "go get github.com/stretchr/gorc"

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
  pushd "$HOME/opt/bin"
  wget https://gist.githubusercontent.com/cdzombak/fc0c0acbba9c302571add6dcd6d10deb/raw/c607f9fcc182ecc5d0fcc844bff67c1709847b55/listening
  chmod +x listening
  popd
}
sw_install "$HOME/opt/bin/listening" _install_listening

# my tool which keeps Keybase out of Finder favorites
_install_keybase_favorite_cleaner() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'remove-keybase-finder-favorite')
  git clone "https://github.com/cdzombak/remove-keybase-finder-favorite.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  chmod +x ./install.sh
  ./install.sh
  popd
}
sw_install /usr/local/bin/com.dzombak.remove-keybase-finder-favorite _install_keybase_favorite_cleaner

# Move on to macOS applications:

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
  "- [ ] Sign in to 1Password account & start syncing\n- [ ] Enable 1Password Safari extension"
sw_install "$HOME/Library/Screen Savers/Aerial.saver" "brew_cask_install aerial"
sw_install "/Applications/Alfred 4.app" "brew_cask_install alfred" \
  "- [ ] Sync settings from \`~/Sync/Configs\`"
sw_install /Applications/AppCleaner.app "brew_cask_install appcleaner" \
  "- [ ] Enable SmartDelete (automatic watching for deleted apps)"
sw_install /Applications/Arq.app "brew_cask_install arq" \
  "- [ ] Setup backups to Wasabi"
sw_install "/Applications/Bartender 3.app" "brew_cask_install bartender" \
  "- [ ] Configure based on current favorite system/screenshots in \`~/Sync/Configs\`"
sw_install "$HOME/Library/Screen Savers/Brooklyn.saver" "brew_cask_install brooklyn" \
  "- [ ] Configure screen saver"
sw_install "/Applications/Bunch.app" "brew_cask_install bunch" \
  "- [ ] Sync settings from \`~/Sync/Configs\`"
sw_install "/Applications/Choosy.app" "brew_cask_install choosy" \
  "- [ ] Configure Choosy\n- [ ] Enable Choosy Safari extension"
sw_install /Applications/Dash.app "brew_cask_install dash" \
  "- [ ] Sync settings from \`~/Sync/Configs\`\n- [ ] Sync snippets\n- [ ] Arrange docsets"
sw_install /Applications/Docker.app "brew_cask_install docker"
sw_install /Applications/FastScripts.app "brew_cask_install fastscripts"
sw_install "/Applications/Fantastical 2.app" "brew_cask_install fantastical" \
  "- [ ] Enable 'Run in Background'\n- [ ] Sign into Flexibits account (via Apple)- [ ] Configure calendar accounts\n- [ ] Add to Today view\n- [ ] Configure application preferences"
sw_install /Applications/Fork.app "brew_cask_install fork" \
  "- [ ] Configure applications & Git path\n- [ ] Install CLI tool"
sw_install "/Applications/Google Chrome.app" "brew_cask_install google-chrome" \
  "- [ ] Sign into relevant Google Accounts"
sw_install "/Applications/Google Drive File Stream.app" "brew_cask_install google-drive-file-stream" \
  "- [ ] Sign into relevant Google Account"
sw_install "/Applications/GPG Keychain.app" "brew_cask_install gpg-suite-no-mail" \
  "- [ ] Import GPG keys as needed"
sw_install /Applications/Hammerspoon.app "brew_cask_install hammerspoon" \
  "- [ ] Configure to run at login"
sw_install /Applications/IINA.app "brew_cask_install iina" \
  "- [ ] Enable Safari extension (as desired)"
sw_install "/Applications/iStat Menus.app" "brew_cask_install istat-menus" \
  "- [ ] Configure based on current favorite system\n- [ ] Add to Today view"
sw_install /Applications/iTerm.app "brew_cask_install iterm2" \
  "- [ ] Sync settings from \`~/Sync/Configs\`, taking care not to overwrite the files there"
sw_install "/Applications/JetBrains Toolbox.app" "brew_cask_install jetbrains-toolbox" \
  "- [ ] Sign into JetBrains account\n- [ ] Enable automatic updates\n- [ ] Enable 'Generate Shell Scripts'\n- [ ] Enable 'Run at Login'\n- [ ] Install IntelliJ\n- [ ] Install GoLand\n- [ ] Install Android Studio\n- [ ] Install WebStorm\n- [ ] Enable Settings Repository syncing\n- [ ] Install plugins based on docs in \`~/Sync/Configs\`"
sw_install /Applications/Kaleidoscope.app "brew_cask_install kaleidoscope" \
  "- [ ] License"
sw_install /Applications/Keybase.app "brew_cask_install keybase" \
  "- [ ] Sign in"
sw_install /Applications/LaunchControl.app "brew_cask_install launchcontrol" \
  "- [ ] License"
sw_install /Applications/LICEcap.app "brew_cask_install licecap"
sw_install /Applications/OmniDiskSweeper.app "brew_cask_install omnidisksweeper"
sw_install /Applications/OmniOutliner.app "brew_cask_install omnioutliner" \
  "- [ ] License\n- [ ] Import templates from \`~/Sync/Configs\`"
sw_install /Applications/Paw.app "brew_cask_install paw" \
  "- [ ] Sign in / License"
sw_install /Applications/Rocket.app "brew_cask_install rocket" \
  "- [ ] License\n- [ ] Start at Login"
sw_install /Applications/SensibleSideButtons.app "brew_cask_install sensiblesidebuttons" \
  "- [ ] Start at Login\n- [ ] Enable"
sw_install /Applications/Slack.app "brew_cask_install slack" \
  "- [ ] Sign in to Slack accounts"
sw_install /Applications/Sonos.app "brew_cask_install sonos"
sw_install /Applications/Spotify.app "brew_cask_install spotify"
sw_install "/Applications/Sublime Merge.app" "brew_cask_install sublime-merge"
sw_install /Applications/TIDAL.app "brew_cask_install tidal"
sw_install "/Applications/The Unarchiver.app" "brew_cask_install the-unarchiver"
sw_install "/Applications/Transmit.app" "brew_cask_install transmit" \
  "- [ ] License\n- [ ] Sign into Panic Sync"
sw_install "/Applications/Typora.app" "brew_cask_install typora" \
  "- [ ] Associate with Markdown files"
sw_install /Applications/Wavebox.app "brew_cask_install wavebox" \
  "- [ ] Sign into personal Google account for license\n- [ ] Sign into other relevant Google accounts"
sw_install /Applications/Wireshark.app "brew_cask_install wireshark"

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
  if [ ! -L ~/.sublime-config ]; then
    ln -s ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User ~/.sublime-config
  fi
}
sw_install "/Applications/Sublime Text.app" _install_sublimetext \
  "- [ ] Open the application and allow Package Control to finish installing packages as configured- [ ] License"

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

if [ ! -L ~/Applications/toolbox-idea ]; then
  ln -s ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U ~/Applications/toolbox-idea
fi
if [ ! -L ~/Applications/toolbox-goland ]; then
  ln -s ~/Library/Application\ Support/JetBrains/Toolbox/apps/Goland ~/Applications/toolbox-goland
fi
if [ ! -L ~/Applications/toolbox-webstorm ]; then
  ln -s ~/Library/Application\ Support/JetBrains/Toolbox/apps/WebStorm ~/Applications/toolbox-webstorm
fi
if [ ! -L ~/Applications/toolbox-androidstudio ]; then
  ln -s ~/Library/Application\ Support/JetBrains/Toolbox/apps/AndroidStudio ~/Applications/toolbox-androidstudio
fi

# macOS Applications from Mac App Store:

sw_install /Applications/Bear.app "mas install 1091189122" \
  "- [ ] Enable Bear Safari extension"
sw_install /Applications/Better.app "mas install 1121192229" \
  "- [ ] Enable Better Blocker Safari extension"
# sw_install /Applications/Byword.app "mas install 420212497"
sw_install /Applications/ColorSnapper2.app "mas install 969418666"
sw_install "/Applications/Day One.app" "mas install 1055511498" \
  "- [ ] Sign into Day One account\n- [ ] Enable Day One Safari extension\n- [ ] Sign into Day One Safari extension"
sw_install /Applications/Deliveries.app "mas install 924726344" \
  "- [ ] Sign into Junecloud account\n- [ ] Add to Today view"
sw_install /Applications/Discovery.app "mas install 1381004916"
sw_install /Applications/Expressions.app "mas install 913158085"
sw_install "/Applications/GIF Brewery 3.app" "mas install 1081413713"
sw_install /Applications/IPinator.app "mas install 959111981" \
  "- [ ] Add to Today view"
sw_install "/Applications/Living Earth Desktop.app" "mas install 539362919" \
  "- [ ] Configure sync\n- [ ] Start at login\n- [ ] Disable desktop & etc. features"
sw_install /Applications/Numbers.app "mas install 409203825"
sw_install /Applications/Pages.app "mas install 409201541"
sw_install /Applications/Pastebot.app "mas install 1179623856" \
  "- [ ] Start at login\n-[ ] Set Shift-Command-V global shortcut\n-[ ] Configure\n- [ ] Always Paste Plain Text"
sw_install /Applications/PDFScanner.app "mas install 410968114"
sw_install /Applications/RadarScope.app "mas install 432027450" \
  "- [ ] Restore purchases\n- [ ] Sign into relevant accounts"
sw_install /Applications/Reeder.app "mas install 1449412482" \
  "- [ ] Sign into Feedbin\n- [ ] Configure as desired"
sw_install "/Applications/WiFi Explorer.app" "mas install 494803304"
sw_install "/Applications/Triode.app" "mas install 1450027401"

_install_things() {
  mas install 904280696 # Things
  brew cask install thingsmacsandboxhelper
}
sw_install "/Applications/Things3.app" _install_things \
  "- [ ] Sign into Things Cloud account\n-[ ] Configure\n- [ ] Add to Today view"

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

cecho "Set: In Xcode, show how long it takes to build your project" $cyan
set -x
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
set +x

cecho "Set: In Xcode, enable faster build times by leveraging multi-core CPU" $cyan
set -x
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks `sysctl -n hw.ncpu`
set +x

sw_install /Applications/Setapp "brew_cask_install setapp && open /Applications/Setapp.app" \
  "- [ ] Sign in to Setapp\n- [ ] Install applications from Setapp Favorites (as desired)\n- [ ] Disable Setapp in Dock, Menu Bar, and Finder sidebar\n- [ ] Disable showing non-installed apps in Spotlight"

sw_install "/Applications/Easy CSV Editor.app" "mas install 1171346381" \
  "- [ ] Associate with CSV files"

sw_install "/Applications/JSON Editor.app" "mas install 567740330" \
  "- [ ] Associate with JSON files"

sw_install "/Applications/PLIST Editor.app" "mas install 1157491961" \
  "- [ ] Associate with PLIST files"

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
  cecho "Install Netdata locally? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install netdata
    brew services start netdata
  fi
}
sw_install /usr/local/sbin/netdata _install_netdata

_install_iperf3() {
  cecho "Install iperf3? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install iperf3
  fi
}
sw_install /usr/local/bin/iperf3 _install_iperf3

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

_install_ivpn_client() {
  cecho "Install IVPN client? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install ivpn
  fi
}
sw_install /Applications/IVPN.app _install_ivpn_client

_install_wireguard_client() {
  cecho "Install WireGuard client? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1451685025
  fi
}
sw_install /Applications/WireGuard.app _install_wireguard_client

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

echo ""
cecho "--- Dev Tools ---" $white
echo ""

_install_sfsymbols() {
  cecho "Install Apple's SF Symbols Mac app? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
     brew cask install sf-symbols
  fi
}
sw_install "/Applications/SF Symbols.app" _install_sfsymbols

cecho "Install React Native CLI & related tools? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install /usr/local/bin/watchman "brew_install watchman"
  sw_install /usr/local/bin/react-native "npm install -g react-native-cli"
fi

_install_nodemon() {
  cecho "Install nodemon (filesystem watcher for Node/NPM projects)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
     npm install -g nodemon
  fi
}
sw_install /usr/local/bin/nodemon _install_nodemon

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

_install_gcloud_sdk() {
  cecho "Install Google Cloud SDK? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install google-cloud-sdk
  fi
}
sw_install /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk _install_gcloud_sdk

_install_wwdcapp() {
  cecho "Install WWDC macOS application (for watching/downloading videos)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install wwdc
  fi
}
sw_install /Applications/WWDC.app _install_wwdcapp

cecho "Install Latex tools? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  cecho "TODO(cdzombak): script artifacts check for Latex tools" $red
  brew cask install mactex
  brew cask install texmaker
fi

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

_install_kindle() {
  cecho "Install Kindle? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 405399194 # Kindle
  fi
}
sw_install /Applications/Kindle.app _install_kindle

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

_install_pixelmator() {
  cecho "Install Pixelmator? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 407963104
  fi
}
sw_install /Applications/Pixelmator.app _install_pixelmator

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

_install_fileloupe() {
  cecho "Install Fileloupe media browser? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 944693506 # Fileloupe
  fi
}
sw_install /Applications/Fileloupe.app _install_fileloupe

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
cecho "--- Music / Podcasts ---" $white
echo ""

_install_plexdesktop() {
  cecho "Install Plex Desktop? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install plex
    # shellcheck disable=SC2129
    echo "## Plex.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Sign into Plex account" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/Plex.app _install_plexdesktop

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

echo ""
cecho "--- Office Tools ---" $white
echo ""

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

_install_zoom() {
  cecho "Install Zoom for videoconferencing? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew cask install zoomus
  fi
}
sw_install /Applications/zoom.us.app _install_zoom

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

if [ ! -e "$HOME/.local/dotfiles/software/no-grasshopper" ]; then
  _install_grasshopper() {
    cecho "Install Grasshopper (phone software)? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'grasshopper-work')
      pushd "$TMP_DIR"
      wget http://dl.grasshopper.com/Grasshopper.dmg
      hdiutil attach ./Grasshopper.dmg
      cp -rv /Volumes/Grasshopper/Grasshopper.app /Applications/
      popd
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.local/dotfiles/software/no-grasshopper"
    fi
  }
  sw_install /Applications/Grasshopper.app _install_grasshopper
fi

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
cecho "--- Removing software that's no longer used ---" $white
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

if [ -e "/Applications/OmniFocus.app" ]; then
  echo "OmniFocus..."
  verify_smartdelete
  trash /Applications/OmniFocus.app
  REMOVED_ANYTHING=true
fi

if [ -e "/Applications/Plexamp.app" ]; then
  echo "Plexamp..."
  verify_smartdelete
  trash /Applications/Plexamp.app
  REMOVED_ANYTHING=true
fi

if ! $REMOVED_ANYTHING; then
  echo "Nothing to do."
fi

echo ""
cecho "--- Finally, stuff that failed the last time this script was used..." $white
echo ""

_install_swiftsh() {
  echo ""
  cecho "Install swift-sh? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install mxcl/made/swift-sh
  fi
}
sw_install /usr/local/bin/swift-sh _install_swiftsh

echo ""
cecho "✔ Done!" $green
