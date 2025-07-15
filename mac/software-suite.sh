#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho

# TODO(cdzombak): stow, read tool-versions for asdf version; inject via env
ASDF_INSTALL_PY_VERSION="3.13.2"
ASDF_INSTALL_NODE_VERSION="22.13.1"

# TODO(cdzombak): vibetunnel (/Applications/VibeTunnel.app ; /opt/homebrew/bin/vt) (brew install --cask vibetunnel)
# TODO(cdzombak): claude ( brew install --cask claude; /Applications/Claude.app )
# TODO(cdzombak): claude sync; MCP servers
# TODO(cdzombak): claude code ( npm install -g @anthropic-ai/claude-code )
# TODO(cdzombak): whispr app
# TODO(cdzombak): ollama, devin, GH copilot (web apps)
# TODO(cdzombak): review brew-gomod fork

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS software installation because not on macOS"
  exit 2
fi

cecho "----                      ----" $white
cecho "---- macOS Software Suite ----" $white
cecho "----                      ----" $white
echo ""
cecho "On a new system this will take a while. The computer should be plugged in and have a solid network connection." $red
cecho "Continue? (y/N)" $red
CONTINUE=false
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi
if ! $CONTINUE; then
  exit 0
fi

echo ""
cecho "--- Choices ---" $white
echo ""

mkdir -p "$HOME/.config/dotfiles/software"

# cleanup old, unused choices:
rm -f "$HOME/.config/dotfiles/software/no-ecobee-wrapper"
rm -f "$HOME/.config/dotfiles/software/no-home-hardware-utils"
rm -f "$HOME/.config/dotfiles/software/no-octopi-dzhome"
rm -f "$HOME/.config/dotfiles/software/no-*.app"

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
  echo ""
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

echo ""
cecho "--- Core Suite Setup ---" $white
echo ""

./mac-install -config install-asdf.yaml

echo ""
cecho "Skip optional installs? (y/N)" $white
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  ./mac-install -config install.yaml -skip-optional
else
  ./mac-install -config install.yaml
fi

if [ ! -L /Applications/Marked.app ]; then
  # compatibility with old "Open in Marked" IntelliJ plugin which hardcodes this path to Marked:
  ln -s "/Applications/Marked 2.app" /Applications/Marked.app
  chflags -h hidden /Applications/Marked.app
fi


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


"$SCRIPT_DIR"/software-suite-home-applications.sh


echo ""
cecho "✔ Done!" $green
