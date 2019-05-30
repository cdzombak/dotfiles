#!/usr/bin/env bash

# TODO: python & python tools (2/3, virtualenv, pip)
# TODO: osx automation & curie match integration
# TODO: followup steps (configuration, menubar, etc. esp. Choosy)
# TODO: qlgenerators - see Dropbox and cask possibilities

set -euo pipefail
IFS=$'\n\t'

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS setup because not on macOS"
  exit 2
fi

echo "---- macOS Software Installation ----"
echo "This will take a while. The computer should be plugged in and have a solid network connection."
echo "If you don't wish to do this now, you can run make software-mac later."
echo "Continue? (y/N)"
CONTINUE=false
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  exit 0
fi

brew install \
  ag \
  awscli \
  bash-completion \
  cloc \
  coreutils \
  curl \
  dep \
  entr \
  eslint \
  flake8 \
  fzf \
  git \
  gnupg \
  go \
  grep \
  htop \
  iperf3 \
  jq \
  lua \
  mas \
  mtr \
  nano \
  nativefier \
  ncdu \
  nmap \
  node \
  pycodestyle \
  ripgrep \
  screen \
  shellcheck \
  shfmt \
  sqlite \
  stow \
  telnet \
  terminal-notifier \
  the_silver_searcher \
  tig \
  tldr \
  tofrodos \
  trash \
  tree \
  wakeonlan \
  wget \
  xz \
  yamllint \
  yarn

brew tap caskroom/versions
brew tap homebrew/cask-drivers
brew tap homebrew/cask-fonts

brew tap wagoodman/dive
brew install dive

npm install -g emoj@">=2.0.0"
npm install -g dockerfilelint@">=1.5.0"

sudo gem install mdless sqlint

echo ""
echo "Install Java tools? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install java
  brew install gradle-completion maven
fi

echo ""
echo "Install Scala tools? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew install sbt
fi

echo ""
echo "Install Carthage? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew install carthage
fi

echo ""
echo "Install Google Cloud SDK? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install google-cloud-sdk
fi

echo ""
echo "Install WWDC macOS application (for videos, etc.)? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install wwdc
fi

echo ""
echo "Install Latex tools? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install mactex texmaker
fi

echo ""
echo "Install Netdata locally? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew install netdata && brew services start netdata
fi

echo ""
echo "-- Database tools."
echo "-- There are a lot of options here: MySQLWorkbench, Liya (SQLite), IntelliJ, plus tools from Setapp (favorite is SQLPro)."

echo ""
echo "Install MySQLWorkbench? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install mysqlworkbench
fi

echo ""
echo "Install Liya (for SQLite, from Mac App Store)? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 455484422 # Liya - SQLite
fi

echo ""
echo "--"
echo ""

# install dust: A more intuitive version of du in rust
if [ ! -x "/usr/local/bin/dust" ]; then
  TMP_DIR=`mktemp -d 2>/dev/null || mktemp -d -t 'dust-work'`
  pushd "$TMP_DIR"
  curl -s https://api.github.com/repos/bootandy/dust/releases/latest | jq -r ".assets[].browser_download_url" | grep "darwin" | xargs wget -q -O dust.tar.gz
  tar xzf dust.tar.gz
  cp dust /usr/local/bin/
  popd
fi

# install metar: CLI metar lookup tool
if [ ! -x "/usr/local/bin/metar" ]; then
  TMP_DIR=`mktemp -d 2>/dev/null || mktemp -d -t 'metar-work'`
  git clone "https://github.com/RyuKojiro/metar.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  make
  sudo make install
  popd
fi

brew cask install \
  1password \
  aerial \
  alfred \
  appcleaner \
  arq \
  bartender \
  brooklyn \
  choosy \
  dash \
  docker \
  dropbox \
  fantastical \
  fork \
  google-chrome \
  google-drive-file-stream \
  iterm2 \
  fastscripts \
  font-meslo-lg \
  font-meslo-for-powerline \
  gpg-suite-no-mail \
  hammerspoon \
  iina \
  istat-menus \
  jetbrains-toolbox \
  kaleidoscope \
  launchcontrol \
  licecap \
  marked \
  omnidisksweeper \
  omnioutliner \
  paw \
  rocket \
  sensiblesidebuttons \
  slack \
  sonos \
  spotify \
  sublime-text \
  sublime-merge \
  thingsmacsandboxhelper \
  the-unarchiver \
  tor-browser \
  transmit \
  wavebox \
  wireshark

echo ""
echo "Install balena etcher (for burning SD card images)? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install balenaetcher
fi

echo ""
echo "Install CoconutBattery? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install coconutbattery
fi

echo ""
echo "Install IVPN client? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install ivpn
fi

echo ""
echo "Install Mendeley Desktop? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install mendeley
fi

echo ""
echo "Install OSXFuse (for use with Transmit Disk)? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install osxfuse
fi

echo ""
echo "Install PhotoSweeper X? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install photosweeper-x
fi

echo ""
echo "Install Plexamp? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install plexamp
fi

echo ""
echo "Install SuperDuper? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install superduper
fi

echo ""
echo "Install home hardware utilities? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install fujitsu-scansnap-manager logitech-myharmony garmin-express
fi

echo ""
echo "Install podcasting utilities? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install skype
  open "https://www.ecamm.com/mac/callrecorder/"
fi

mas install 1091189122 # Bear
mas install 1121192229 # Better Blocker
mas install 420212497 # Byword
mas install 969418666 # ColorSnapper
mas install 1055511498 # Day One
mas install 1381004916 # Discovery network browser
mas install 924726344 # Deliveries
mas install 524373870 # Due
mas install 913158085 # Expressions
mas install 1081413713 # GIF Brewery
mas install 959111981 # IPinator
mas install 927292435 # iStat Mini
mas install 539362919 # Living Earth
mas install 1006739057 # NepTunes
mas install 1179623856 # Pastebot
mas install 410968114 # PDFScanner (Scanning & OCR)
mas install 432027450 # RadarScope
mas install 1449412482 # Reeder 4
mas install 904280696 # Things
mas install 494803304 # Wifi Explorer

echo ""
echo "Install social networking software? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install caprine
  mas install 792425898 # Flume for Instagram
  mas install 1384080005 # Tweetbot 3

  # https://twitter.com/dancounsell/status/667011332894535682
  echo "Avoid t.co in Tweetbot-Mac"
  defaults write com.tapbots.TweetbotMac OpenURLsDirectly YES
fi

echo ""
echo "Install Adobe Creative Cloud? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install adobe-creative-cloud
fi

echo ""
echo "Install Keynote? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 409183694 # Keynote
fi

echo ""
echo "Install Deckset? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install deckset
fi

echo ""
echo "Install Zoom for videoconferencing? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install zoomus
fi

mas install 409203825 409201541 # Numbers, Pages
mas install 497799835 1450391666 # Xcode, # AccessControlKitty for Xcode

echo "In Xcode, show how long it takes to build your project"
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

echo "In Xcode, enable faster build times by leveraging multi-core CPU"
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks `sysctl -n hw.ncpu`

echo ""
echo "Wrapping up soon...now we'll check on some less-frequently used software."

echo ""
echo "Install Logic/Final Cut and related tools? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 634148309 # Logic Pro X
  mas install 424390742 # Compressor
  mas install 434290957 # Motion
  mas install 424389933 # Final Cut Pro
fi

echo ""
echo "Install games? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew install nsnake
  mas install 1047760200 # Mini Metro
  mas install 804079949 # SimCity 4 Deluxe Edition
fi

echo ""
echo "Install Calca? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 635758264 # Calca
fi

echo ""
echo "Install CubicSDR? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install cubicsdr
fi

echo ""
echo "Install DaisyDisk? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 411643860 # DaisyDisk
fi

echo ""
echo "Install Fileloupe media browser? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 944693506 # Fileloupe
fi

echo ""
echo "Install Handbrake? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install handbrake
  brew install lame
fi

echo ""
echo "Install Kindle? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 405399194 # Kindle
fi

echo ""
echo "Install MacTracker? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 430255202 # MacTracker
fi

echo ""
echo "Install TableFlip (Markdown table utility)? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install tableflip
fi

echo ""
echo "Install Tadam focus timer? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 531349534 # Tadam
fi

# echo ""
# echo "Install Tomato One focus timer? (y/N)"
# read -r response
# if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
#   mas install 907364780 # Tomato One
# fi

echo ""
echo "Install youtube-dl? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew install youtube-dl
fi

if [ ! -d "/Applications/Setapp" ]; then
  brew cask install setapp
fi

open "https://ejector.app/releases/latest/"
open "https://codingmonkeys.de/portmap/"

# at the very end, since last time on a fresh machine this failed:
echo ""
echo "Install swift-sh? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew install mxcl/made/swift-sh
fi
