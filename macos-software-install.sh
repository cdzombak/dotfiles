#!/usr/bin/env bash

set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS setup because not on macOS"
  exit 2
fi

# TODO: python & python tools (brew: pycodestyle) (2/3, virtualenv, pip)
# TODO: sublime, config, lint deps
# TODO: osx automation & curie match integration
# TODO: review and simplify configure
# TODO: followup steps (configuration, menubar, etc. esp. Choosy)
# TODO: setapp programatically?

brew install \
  bash-completion \
  cloc \
  fzf \
  git \
  htop \
  iperf3 \
  jq \
  mas \
  nano \
  nativefier \
  nmap \
  node \
  screen \
  sqlite \
  stow \
  telnet \
  terminal-notifier \
  wakeonlan \
  wget \
  xz \
  yarn

brew tap caskroom/versions
brew tap homebrew/cask-drivers
brew tap homebrew/cask-fonts

echo ""
echo "Install Java tools? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install java java8
  brew install gradle-completion maven
fi

echo ""
echo "Install Google Cloud SDK? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install google-cloud-sdk
fi

echo ""
echo "Install Latex tools? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install mactex texmaker
fi

# install dust: A more intuitive version of du in rust
if [ ! -x "/usr/local/bin/dust" ]; then
  TMP_DIR=`mktemp -d 2>/dev/null || mktemp -d -t 'dust-work'`
  pushd "$TMP_DIR"
  curl -s https://api.github.com/repos/bootandy/dust/releases/latest | jq -r ".assets[].browser_download_url" | grep "darwin" | xargs wget -q -O dust.tar.gz
  tar xzf dust.tar.gz
  cp dust /usr/local/bin/
  popd
fi

if [ ! -d "/Applications/Setapp" ]; then
  brew cask install setapp
fi

brew cask install \
  1password \
  aerial \
  alfred \
  arq \
  brooklyn \
  caprine \
  choosy \
  dash \
  docker \
  dropbox \
  fantastical \
  fork \
  google-chrome \
  google-drive-file-stream \
  iterm2 \
  ejector \
  fastscripts \
  font-meslo-for-powerline \
  gpg-suite-no-mail \
  hammerspoon \
  iina \
  istat-menus \
  jetbrains-toolbox \
  kaleidoscope \
  licecap \
  marked \
  omnioutliner \
  paw \
  rocket \
  sensiblesidebuttons \
  slack \
  sonos \
  spotify \
  sublime-text \
  thingsmacsandboxhelper \
  tor-browser \
  transmit \
  wavebox

echo ""
echo "Install Plexamp? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install plexamp
fi

echo ""
echo "Install home hardware utilities? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  brew cask install fujitsu-scansnap-manager logitech-myharmony
fi

mas install 1091189122 # Bear
mas install 1121192229 # Better Blocker
mas install 1055511498 # Day One
mas install 1381004916 # Discovery network browser
mas install 924726344 # Deliveries
mas install 524373870 # Due
mas install 959111981 # IPinator
mas install 539362919 # Living Earth
mas install 455484422 # Liya - SQLite
mas install 1006739057 # NepTunes
mas install 1179623856 # Pastebot
mas install 432027450 # RadarScope
mas install 880001334 # Reeder 3
mas install 904280696 # Things
mas install 494803304 # Wifi Explorer

echo ""
echo "Install Keynote? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  mas install 409183694 # Keynote
fi

mas install 409203825 409201541 # Numbers, Pages
mas install 497799835 1450391666 # Xcode, # AccessControlKitty for Xcode
