#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho
# shellcheck disable=SC1091
source "$LIB_DIR"/sw_install

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

mkdir -p "$HOME/.config/dotfiles/software"

# cleanup old, unused choices:
rm -f "$HOME/.config/dotfiles/software/no-ecobee-wrapper"
rm -f "$HOME/.config/dotfiles/software/no-home-hardware-utils"
rm -f "$HOME/.config/dotfiles/software/no-octopi-dzhome"

# default choices which you can override in another window if desired:
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

if [ -e "$HOME/.nvm/nvm.sh" ]; then
  echo ""
  cecho "nvm is installed and will be deactivated in this shell." $red
  echo "This ensures that system-level node, installed directly by homebrew, is used to install packages globally."
  # shellcheck disable=SC2162
  read -p "Press [Enter] to continue..."
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

echo ""
echo -e "This script will use ${magenta}sudo${_reset}; enter your password to authenticate if prompted."
# Authenticate upfront and run a keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -v -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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
sw_install "$(brew --prefix)/bin/mas" "brew install mas"

sw_install /Applications/Xcode.app "mas install 497799835"
if ! xcode-select --print-path | grep -c "/Applications/Xcode.app" >/dev/null ; then
  sudo xcode-select --install
  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
fi
if ! xcodebuild -checkFirstLaunchStatus; then
  sudo xcodebuild -runFirstLaunch
fi

# sw_install's brew_[cask_]install uses `brew caveats`:
sw_install "$(brew --prefix)/Cellar/brew-caveats" \
  "brew tap rafaelgarrido/homebrew-caveats && brew install brew-caveats"

# untap caskroom/versions, which conflicts with homebrew/cask-versions:
if brew tap | grep -c caskroom/versions >/dev/null ; then
  brew untap caskroom/versions
fi

# tap various casks that may be required:
brew tap | grep -c homebrew/cask-versions >/dev/null || brew tap homebrew/cask-versions
brew tap | grep -c homebrew/cask-fonts >/dev/null || brew tap homebrew/cask-fonts

# begin with core/base Homebrew installs:
# some of these (node, go, mas) are used later in this setup script.
sw_install "$(brew --prefix)/bin/ag" "brew_install ag"
sw_install "$(brew --prefix)/Cellar/bash-completion" "brew_install bash-completion"
sw_install "$(brew --prefix)/bin/bandwhich" "brew_install bandwhich"
sw_install "$(brew --prefix)/bin/brew-gem" "brew_install brew-gem"
sw_install "$(brew --prefix)/bin/cidrtool" "brew_install cdzombak/oss/cidrtool"
sw_install "$(brew --prefix)/opt/coreutils/libexec/gnubin" "brew_install coreutils"
sw_install "$(brew --prefix)/opt/curl/bin/curl" "brew_install curl"
sw_install "$(brew --prefix)/bin/diff-so-fancy" "brew_install diff-so-fancy"
sw_install "$(brew --prefix)/bin/ddgr" "brew_install ddgr"
sw_install "$(brew --prefix)/bin/duf" "brew_install duf"
sw_install "$(brew --prefix)/bin/dust" "brew_install dust"
sw_install "$(brew --prefix)/bin/duti" "brew_install duti"
sw_install "$(brew --prefix)/bin/fileicon" "brew_install fileicon"
sw_install "$(brew --prefix)/bin/fzf" "brew_install fzf"
sw_install "$(brew --prefix)/bin/git" "brew_install git"
sw_install "$(brew --prefix)/bin/git-lfs" "brew_install git-lfs"
sudo git lfs install --system --skip-repo
sw_install "$(brew --prefix)/bin/go" "brew_install go" \
  "- [ ] Set \`GOPRIVATE\` as needed via: \`go env -w GOPRIVATE=host.com/org\`"
sw_install "$(brew --prefix)/bin/ggrep" "brew_install grep"
sw_install "$(brew --prefix)/bin/gron" "brew_install gron"
sw_install "$(brew --prefix)/bin/htop" "brew_install htop"
sw_install "$(brew --prefix)/bin/imagesnap" "brew_install imagesnap"
sw_install "$(brew --prefix)/bin/jsonnet-lint" "brew_install go-jsonnet"
sw_install "$(brew --prefix)/bin/jq" "brew_install jq"
sw_install "$(brew --prefix)/bin/listening" "brew_install cdzombak/oss/listening"
sw_install "$(brew --prefix)/bin/lua" "brew_install lua"
sw_install "$(brew --prefix)/bin/mdcat" "brew_install mdcat"
sw_install "$(brew --prefix)/bin/mdless" "brew install mdless"
sw_install "$(brew --prefix)/bin/mogrify" "brew_install imagemagick"
if [ ! -e "$(brew --prefix)/bin/mysides" ] && [ ! -e "/usr/local/bin/mysides" ]; then
  brew install --cask mysides
fi
sw_install "$(brew --prefix)/bin/nano" "brew_install nano"
sw_install "$(brew --prefix)/bin/ncdu" "brew_install ncdu"
sw_install "$(brew --prefix)/bin/nnn" "brew_install nnn"
sw_install "$(brew --prefix)/bin/node" "brew_install node"
sw_install "$(brew --prefix)/bin/ocr" "brew_install schappim/ocr/ocr"
sw_install "$(brew --prefix)/bin/pdate" "brew_install cdzombak/oss/pdate"
sw_install "$(brew --prefix)/bin/pdffonts" "brew_install poppler"
sw_install "$(brew --prefix)/bin/pngcrush" "brew_install pngcrush"
sw_install "$(brew --prefix)/bin/prettierd" "brew_install fsouza/prettierd/prettierd"
sw_install "$(brew --prefix)/bin/pup" "brew_install pup" # CLI HTML parsing; supports weblink script
sw_install "$(brew --prefix)/bin/python3" "brew_install python"
sw_install "/Applications/QuickLook Video.app" "brew_install qlvideo"
sw_install "$(brew --prefix)/bin/rdfind" "brew_install rdfind"
sw_install "$(brew --prefix)/bin/screen" "brew_install screen"
sw_install "$(brew --prefix)/bin/shellcheck" "brew_install shellcheck"
sw_install "$(brew --prefix)/bin/shfmt" "brew_install shfmt"
sw_install "$(brew --prefix)/opt/sqlite/bin/sqlite3" "brew_install sqlite"
sw_install "$(brew --prefix)/bin/stow" "brew_install stow"
sw_install "$(brew --prefix)/Cellar/syncthing" "brew_install syncthing && brew services start syncthing" \
  "- [ ] Begin syncing \`~/.config/macos\`\n- [ ] Begin syncing \`~/Sync\`\n- [ ] Sync folder: Staggered file versioning, 60 days\n- [ ] Add \`#include globalstignore\` to ignore lists\n- [ ] Minimum disk space 10% in app settings\n- [ ] Update [Syncthing devices note](bear://x-callback-url/open-note?id=0FC65581-3166-44CF-99E6-4E82089EE4F0-316-0000A2DF53A3E8CD)"
sw_install "$(brew --prefix)/bin/terminal-notifier" "brew_install terminal-notifier"
sw_install "$(brew --prefix)/bin/tig" "brew_install tig"
sw_install "$(brew --prefix)/bin/todos" "brew_install tofrodos"
sw_install "$(brew --prefix)/bin/trash" "brew_install trash"
sw_install "$(brew --prefix)/bin/tree" "brew_install tree"
sw_install "$(brew --prefix)/bin/unshorten" "brew_install cdzombak/oss/unshorten"
sw_install "$(brew --prefix)/bin/wget" "brew_install wget"
sw_install "$(brew --prefix)/bin/windowstack2" "brew_install cdzombak/oss/windowstack2"
sw_install "$(brew --prefix)/bin/xz" "brew_install xz"
sw_install "$(brew --prefix)/bin/yamllint" "brew_install yamllint"

set +e
if brew tap | grep "filosottile/gomod" >/dev/null ; then
  echo "replacing brew-gomod by my fork ..."
  echo "https://github.com/FiloSottile/homebrew-gomod/issues/7"
  brew uninstall brew-gomod
  brew untap filosottile/gomod
fi
set -e
sw_install "$(brew --prefix)/bin/brew-gomod" "brew install cdzombak/gomod/brew-gomod"

_install_tealdeer() {
  brew install tealdeer
  "$(brew --prefix)/bin/tldr" --update >/dev/null &
}
sw_install "$(brew --prefix)/bin/tldr" _install_tealdeer

# provides envsubst:
sw_install "$(brew --prefix)/bin/gettext" "brew_install gettext && brew link --force gettext"

# Install tools which use stuff we just installed via Homebrew:
sw_install "$(brew --prefix)/bin/markdown-toc" 'npm install -g markdown-toc'
sw_install "$(brew --prefix)/bin/nativefier" 'npm install -g nativefier'
sw_install "$(brew --prefix)/bin/bundler" "brew gem install bundler"
sw_install "$(brew --prefix)/bin/fpm" "brew gem install fpm"
sw_install "$(brew --prefix)/bin/rubocop" "brew gem install rubocop"
sw_install "$(brew --prefix)/bin/plistwatch" "brew gomod github.com/catilac/plistwatch"

# metar: CLI metar lookup tool
_install_metar() {
  DEST_DIR="$HOME/3p_code/metar"
  git clone "https://github.com/RyuKojiro/metar.git" "$DEST_DIR"
  pushd "$DEST_DIR"
  make
  if [ -w /usr/local/bin ]; then make install; else sudo make install; fi
  popd
  chmod 0555 "$DEST_DIR"
}
sw_install /usr/local/bin/metar _install_metar

# Move on to macOS applications:

sw_install "/Applications/1Password.app" "brew_cask_install 1password" \
  "- [ ] Sign in to accounts: personal; work as needed
- [ ] Do not show in menu bar
- [ ] Start at login
- [ ] No keyboard shortcut for: Quick Access; Lock 1Password
- [ ] Show 1Password: Ctrl-Shift-Command-Backslash
- [ ] Autofill: Command-Backslash
- [ ] Appearance -> Density: Compact
- [ ] Appearance -> Always show in Sidebar: Categories and Tags
- [ ] Security: enable unlock with Apple Watch
- [ ] Security: hold Option to toggle revealed fields
- [ ] Privacy -> Watchtower: Enable all Watchtower features
- [ ] Developer: enable CLI integration"
sw_install "$(brew --prefix)"/bin/op "brew_cask_install 1password-cli"
sw_install "$HOME/Library/Screen Savers/Aerial.saver" "brew_cask_install aerial" \
  "- [ ] Configure screen saver (as desired)"
if [ -e "/Applications/Alfred 4.app" ]; then
  brew reinstall --cask alfred
fi
sw_install "/Applications/Alfred 5.app" "brew_cask_install alfred" \
  "- [ ] Launch & walk through setup\n- [ ] Disable Spotlight keyboard shortcut\n- [ ] Use Command-Space for Alfred\n- [ ] Sync settings from \`~/.config/macos\`\n- [ ] Enable automatic snippet expansion\n- [ ] Enable browser bookmarks\n- [ ] Change theme\n- [ ] Sweep through synced workflows, fixing as needed"
  sw_install "/Applications/Apparency.app" "brew_cask_install apparency"
sw_install /Applications/AppCleaner.app "brew_cask_install appcleaner" \
  "- [ ] Enable SmartDelete (automatic watching for deleted apps)\n- [ ] Enable automatic updates\n- [ ] Allow Full Disk Access"
sw_install /Applications/Arq.app "brew_cask_install arq" \
  "- [ ] Setup onsite backups as desired\n- [ ] Setup offsite backups as desired\n- [ ] Setup emails via Mailgun\n- [ ] Pause backups on battery power\n- [ ] Enable backup thinning"
if [ ! -e "/Applications/Bartender 5.app" ]; then
  sw_install "/Applications/Bartender _.app" "brew_cask_install bartender" \
    "- [ ] Configure based on current favorite system/screenshots in \`~/.config/macos\`"
fi
sw_install "$HOME/Library/Screen Savers/Brooklyn.saver" "brew_cask_install brooklyn" \
  "- [ ] Configure screen saver (as desired)"
sw_install "/Applications/Choosy.app" "brew_cask_install choosy" \
  "- [ ] License Choosy\n- [ ] Enable Choosy & Start at Login\n- [ ] Set as default browser\n- [ ] Configure Choosy/Import and Tweak Choosy Config"
sw_install /Applications/CommandQ.app "brew_cask_install commandq" \
  "- [ ] License\n- [ ] Enable Start at Login"
sw_install /Applications/FastScripts.app "brew_cask_install fastscripts" \
  "- [ ] License\n- [ ] Launch at login"
sw_install "/Applications/GitHub Desktop.app" "brew_cask_install github" \
  "- [ ] Sign in\n- [ ] Set external editor and shell\n- [ ] Install CLI tool"
sw_install "/Applications/GPG Keychain.app" "brew_cask_install gpg-suite-no-mail" \
  "- [ ] Import/generate GPG keys as needed"
sw_install /Applications/Hammerspoon.app "brew_cask_install hammerspoon" \
  "- [ ] Configure to run at login\n- [ ] Enable Accessibility"
sw_install "/Applications/Hex Fiend.app" "brew_cask_install hex-fiend"
sw_install /Applications/IINA.app "brew_cask_install iina"
sw_install /Applications/iTerm.app "brew_cask_install iterm2" \
  "- [ ] Allow Full Disk Access\n- [ ] Sync settings from \`~/.config/macos\`, taking care not to overwrite the files there\n- [ ] Make default term"
sw_install /Applications/Kaleidoscope.app "brew_cask_install kaleidoscope" \
  "- [ ] License\n- [ ] Set terminal app\n- [ ] Set font: Meslo LG M Regular, size 14\n- [ ] Enable Finder extension\n- [ ] Enable Safari extension"
sw_install /Applications/Latest.app "brew_cask_install latest"
sw_install /Applications/LaunchControl.app "brew_cask_install launchcontrol" \
  "- [ ] License\n- [ ] Allow full disk access\n- [ ] Install and allow full disk access for \`fdautil\`\n- [ ] Enable QuickLaunch\n- [ ] Hide QuickLaunch in Bartender bar"
sw_install /Applications/LICEcap.app "brew_cask_install licecap"
if [ ! -e "$HOME/.config/dotfiles/software/no-mimestream" ]; then
  sw_install /Applications/Mimestream.app "brew_cask_install mimestream" \
    "- [ ] Add personal accounts; set account name\n- [ ] Customize main window & message window toolbars\n- [ ] Increase font size\n- [ ] Notification config: Show in Notification Center and display badge"
fi
sw_install "/Applications/noTunes.app" "brew_cask_install notunes" \
  "- [ ] Launch\n- [ ] Hide in Bartender\n- [ ] Add to Login Items"
sw_install /Applications/OmniDiskSweeper.app "brew_cask_install omnidisksweeper" \
  "- [ ] Allow full disk access"
sw_install "/Applications/Raindrop.io.app" "brew_cask_install raindropio" \
  "- [ ] Sign in"
sw_install /Applications/SensibleSideButtons.app "brew_cask_install sensiblesidebuttons" \
  "- [ ] Start at Login\n- [ ] Enable\n- [ ] Enable Accessibility control"
sw_install "/Applications/Shortcat.app" "brew_cask_install shortcat" \
  "- [ ] Grant permissions\n- [ ] Assign shortcut Alt-Command-Space (move Finder Search to Ctrl-Command-Space if needed)\n- [ ] Launch at Login\n- [ ] Hide in menu bar, next to Alfred"
sw_install /Applications/Sloth.app "brew_cask_install sloth"
sw_install /Applications/Spotify.app "brew_cask_install spotify" \
  "- [ ] Sign in\n- [ ] Disable launching at login"
sw_install "/Applications/Tailscale.app" "brew_cask_install tailscale" \
  "- [ ] Sign in"
sw_install "/Applications/The Unarchiver.app" "brew_cask_install the-unarchiver"
sw_install "/Applications/Typora.app" "brew_cask_install typora" \
  "- [ ] Associate with Markdown files\n- [ ] License"

_install_sublimetext() {
  brew install --cask sublime-text
  SUBLIMETEXT_INSTALLED_PKGS_DIR="$HOME/Library/Application Support/Sublime Text 3/Installed Packages"
  mkdir -p "$SUBLIMETEXT_INSTALLED_PKGS_DIR"
  pushd "$SUBLIMETEXT_INSTALLED_PKGS_DIR"
  wget https://packagecontrol.io/Package%20Control.sublime-package
  popd
  SUBLIMETEXT_PKGS_DIR="$HOME/Library/Application Support/Sublime Text 3/Packages"
  mkdir -p "$SUBLIMETEXT_PKGS_DIR"
  pushd "$SUBLIMETEXT_PKGS_DIR"
  cecho "This might be a good point to generate a GitHub personal access token for this device, to be stored in the local login keychain:" $white
  cecho "https://github.com/settings/tokens" $cyan
  git clone git@github.com:cdzombak/sublime-text-config.git User
  popd
}
sw_install "/Applications/Sublime Text.app" _install_sublimetext \
  "- [ ] Open the application and allow Package Control to finish installing packages as configured\n- [ ] License"
# if [ ! -f /etc/paths.d/cdz.SublimeText ]; then
#   set -x
#   sudo rm -f /etc/paths.d/cdz.SublimeText
#   echo '/Applications/Sublime Text.app/Contents/SharedSupport/bin' | sudo tee -a /etc/paths.d/cdz.SublimeText > /dev/null
#   set +x
# fi
if [ ! -L "$HOME/.config/sublimetext" ]; then
  set -x
  ln -s "$HOME/Library/Application Support/Sublime Text 3/Packages/User" "$HOME/.config/sublimetext"
  set +x
fi
if [ -L "$HOME/.sublime-config" ]; then
  rm "$HOME/.sublime-config"
fi

_install_suspicious_package() {
  brew install --cask suspicious-package
  # if [ ! -f /etc/paths.d/cdz.SuspiciousPackage ]; then
  #   set -x
  #   sudo rm -f /etc/paths.d/cdz.SuspiciousPackage
  #   echo '/Applications/Suspicious Package.app/Contents/SharedSupport' | sudo tee -a /etc/paths.d/cdz.SuspiciousPackage > /dev/null
  #   set +x
  # fi
}
sw_install "/Applications/Suspicious Package.app" _install_suspicious_package

_install_whatsyoursign() {
  brew install --cask whatsyoursign
  open -a "$(brew info --cask whatsyoursign | grep -i "$(brew --prefix)/caskroom" | cut -d' ' -f1)/WhatsYourSign Installer.app"
  while [ ! -e /Applications/WhatsYourSign.app ]; do
    cecho "Please complete WhatsYourSign installation." $white
    # shellcheck disable=SC2162
    read -p "Press [Enter] to continue..."
  done
}
sw_install /Applications/WhatsYourSign.app _install_whatsyoursign

_install_redeye() {
  setupnote "Red Eye.app" "- [ ] Install from \`iCloud Drive/Software\`"
}
sw_install "/Applications/Red Eye.app" _install_redeye

sw_install "$HOME/Library/Fonts/MesloLGM-Regular.ttf" "brew_cask_install font-meslo-lg"
sw_install "$HOME/Library/Fonts/Meslo LG M Regular for Powerline.otf" "brew_cask_install font-meslo-for-powerline"
sw_install "$HOME/Library/Fonts/NationalPark-Regular.otf" "brew_cask_install font-national-park"

sw_install "/Applications/Marked 2.app" "brew_cask_install marked" \
  "- [ ] License\n- [ ] Install Custom CSS from \`~/.config/macos\`"
if [ ! -L /Applications/Marked.app ]; then
  # compatibility with old "Open in Marked" IntelliJ plugin which hardcodes this path to Marked:
  ln -s "/Applications/Marked 2.app" /Applications/Marked.app
  chflags -h hidden /Applications/Marked.app
fi

sw_install "/Applications/KeyCastr.app" "brew_cask_install keycastr" \
  "- [ ] Set bezel to 70% opacity (from default 80)\n- [ ] Hide in Dock; show only in menu bar"

# macOS Applications from Mac App Store:

sw_install "/Applications/1Password for Safari.app" "mas install 1569813296" \
  "- [ ] Enable in Safari\n- [ ] Always allow on every site\n- [ ] Show in Toolbar (arrange to left: Back/Forward, RSS, 1Password) \n- [ ] Disable all Safari autofill features but \"Other Forms\""
if [ ! -e "$HOME/.config/dotfiles/software/no-bear" ]; then
  sw_install /Applications/Bear.app "mas install 1091189122" \
    "- [ ] Assign keyboard shortcuts\n- [ ] Enable Bear Safari extension"
fi
# sw_install /Applications/Byword.app "mas install 420212497"
sw_install /Applications/Dropover.app "mas install 1355679052" \
  "- [ ] Start at login\n- [ ] Restore purchase"
sw_install /Applications/Due.app "mas install 524373870" \
  "- [ ] Assign keyboard shortcut Ctrl-Shift-U\n- [ ] Start at Login\n- [ ] Enable Dropbox Sync\n- [ ] Customize Notifications\n- [ ] Restore purchases"
sw_install "/Applications/Instapaper Save.app" "mas install 1481302432" \
  "- [ ] Sign in\n- [ ] Enable system share extension (_not_ Safari extension)"
sw_install /Applications/NewFileMenu.app "mas install 1064959555" \
  "- [ ] Enable Finder extension\n- [ ] Enable opening file after creation\n- [ ] Disable menu bar item\n- [ ] Disable all templates except plain text and shell script\n- [ ] Add Markdown template (located in .config/macos/NewFileMenu)"
sw_install /Applications/Numbers.app "mas install 409203825"
sw_install /Applications/Pages.app "mas install 409201541"
sw_install "/Applications/Paint S.app" "mas install 736473980" \
  "- [ ] Restore purchases"
sw_install /Applications/Pastebot.app "mas install 1179623856" \
  "- [ ] Start at login\n- [ ] Set/confirm Shift-Command-V global shortcut\n- [ ] Configure, especially Always Paste Plain Text\n- [ ] Enable Accessibility control"
sw_install /Applications/PCalc.app "mas install 403504866"
sw_install "/Applications/PDF Viewer.app" "mas install 1120099014"
sw_install /Applications/Peek.app "mas install 1554235898" \
  "- [ ] Enable Accessibility access as required\n- [ ] Change max preview size to Medium 500K\n- [ ] Change font: Meslo LG M 12pt"
sw_install "/Applications/Poolsuite FM.app" "mas install 1514817810" \
  "- [ ] Sign in"
sw_install /Applications/RadarScope.app "mas install 432027450" \
  "- [ ] Restore purchases\n- [ ] Sign into relevant accounts"
sw_install /Applications/Reeder.app "mas install 1529448980" \
  "- [ ] Sign into Feedbin\n- [ ] Feedbin settings: sync every 15m; sync on wake; unread count in app icon; keep 2 days archive"
sw_install "/Applications/Service Station.app" "mas install 1503136033" \
  "- [ ] Install/sync current configuration\n- [ ] Enable Finder extension\n- [ ] Allow access to \`/\`\n- [ ] Restore purchases"
sw_install "/Applications/Shareful.app" "mas install 1522267256" \
    "- [ ] Enable share extensions: Copy, Open In, Save As"
sw_install /Applications/Soro.app "mas install 1550457805"

_install_things() {
  mas install 904280696 # Things
  brew install --cask thingsmacsandboxhelper
}
# nb. Things shows in Finder as Things.app but its filename is Things3.app
sw_install "/Applications/Things3.app" _install_things \
  "- [ ] Sign into Things Cloud account\n- [ ] Set keyboard shortcuts\n- [ ] Enable autofill via Things Helper\n- [ ] Set calendar & reminders integration settings"

_install_hosts_timer() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'hosts-timer')
  git clone "https://github.com/cdzombak/hosts-timer.git" "$TMP_DIR"
  pushd "$TMP_DIR"
  if [ -w /usr/local ]; then make install; else sudo make install; fi
  popd
  echo "cdzombak ALL=NOPASSWD: /usr/local/bin/hosts-timer" | sudo tee -a /etc/sudoers.d/cdzombak-hosts-timer > /dev/null
  sudo chown root:wheel /etc/sudoers.d/cdzombak-hosts-timer
  sudo chmod 440 /etc/sudoers.d/cdzombak-hosts-timer
  # disable HN by default:
  sudo hosts-timer -install news.ycombinator.com
  sudo hosts-timer -install hckrnews.com
}
sw_install "/usr/local/bin/hosts-timer" _install_hosts_timer

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
  "- [ ] Arrange/enable dictionaries in Dictionary.app as desired"

# Solarized for Xcode
# if this source disappears, there's also my copy in ~/.config/macos
_install_xcode_solarized() {
  DEST_DIR="$HOME/3p_code/solarized-xcode"
  git clone "https://github.com/stackia/solarized-xcode.git" "$DEST_DIR"
  pushd "$DEST_DIR"
  chmod +x ./install.sh
  ./install.sh
  chmod 0555 "$DEST_DIR"
  popd
}
sw_install "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/Solarized Light.xccolortheme" _install_xcode_solarized "- [ ] Enable color theme in Xcode\n- [ ] Customize font & size"

_install_setapp() {
  brew install --cask setapp
}
sw_install /Applications/Setapp.app _install_setapp \
  "- [ ] Sign in to Setapp\n- [ ] Disable \"Show in Finder Sidebar\"\n- [ ] Install applications as desired from Setapp Favorites\n- [ ] Re-run post-install configuration script\n- [ ] Disable global search shortcut\n- [ ] Disable the launch agent \`com.setapp.DesktopClient.SetappLauncher\` using LaunchControl (disable, unload, and change disabled override)"

_install_ears() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'ears')
  pushd "$TMP_DIR"
  wget -O ears.zip "https://download.retina.studio/ears/v1/"
  unzip ears.zip -d "/Applications/"
  rm -rf "/Applications/__MACOSX"
  popd
}
sw_install "/Applications/Ears.app" _install_ears \
  "- [ ] License Ears
- [ ] Configure: Start at Login; Key combo Ctrl-Shift-E; Notify about audio device changes; Show in Menu Bar
- [ ] Favorite devices: AirPods Pro and Sony ANC Phones
- [ ] Linked devices: AirPods Pro/Webcam Mic, Sony ANC Phones/Webcam Mic, AirPods Pro/Lavalier Mic, Sony ANC Phones/Lavalier Mic
- [ ] Notifications: banners, show on lock screen, hide in Notification Center, show previews always"

sw_install "$HOME/Library/Sounds/Honk.aiff" "wget -P $HOME/Library/Sounds https://dropbox.dzombak.com/Honk.aiff"

_install_diskspace() {
  # https://github.com/scriptingosx/diskspace reports the various free space measure possible on APFS
  set -x
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'diskspace-work')
  pushd "$TMP_DIR"
  curl -s "https://api.github.com/repos/scriptingosx/diskspace/releases/latest" | jq -r ".assets[].browser_download_url" | grep ".pkg" | xargs wget -q -O diskspace.pkg
  sudo installer -pkg ./diskspace.pkg -target /
  popd
  set +x
}
sw_install "/usr/local/bin/diskspace" _install_diskspace

if [ ! -e "/Applications/Tembo.app" ]; then
  setupnote "Tembo" "- [ ] [Download](https://www.houdah.com/tembo/download.html) and install Tembo\n- [ ] Register (details in 1Password)\n- [ ] Grant permissions (in Privacy tab)\n- [ ] Enable helper; hide Menu Bar icon\n- [ ] Set global shortcut Ctrl-Shift-Space\n- [ ] Set Groups, Defaults, locations per config screenshots"
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

YES_INSTALL_KUBECTL=false

if $GOINTERACTIVE; then

if [ ! -e "$HOME/.config/dotfiles/software/no-dayone" ]; then
  _install_dayone() {
    cecho "Install Day One? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      mas install 1055511498
      sudo bash "/Applications/Day One.app/Contents/Resources/install_cli.sh"
      setupnote "Day One.app" \
        "- [ ] Sign into Day One account\n- [ ] Disable global shortcut\n- [ ] Disable creating tags from hashtags\n- [ ] Disable daily prompt"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-dayone"
    fi
  }
  sw_install "/Applications/Day One.app" _install_dayone
fi

echo ""
cecho "--- Utilities ---" $white
echo ""

_install_istat(){
  cecho "Install iStat Menus? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask istat-menus
    setupnote "iStat Menus.app" \
      "- [ ] License\n- [ ] Configure based on current favorite system"
  fi
}
sw_install "/Applications/iStat Menus.app" _install_istat

echo ""
cecho "Install/update my notify-me script? (y/N)" $magenta
echo "(requires auth to dropbox.dzombak.com/_auth)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  if [ -f "$HOME/opt/bin/notify-me" ]; then
    rm "$HOME/opt/bin/notify-me"
  fi
  if [ -e "$HOME/.netrc" ] && ! grep -c "dropbox.dzombak.com login cdzombak password PUT_" "$HOME/.netrc" >/dev/null; then
    curl -f -s --netrc --output "$HOME/opt/bin/notify-me" https://dropbox.dzombak.com/_auth/notify-me
  else
    curl -f -u cdzombak --output "$HOME/opt/bin/notify-me" https://dropbox.dzombak.com/_auth/notify-me
  fi
  chmod 755 "$HOME/opt/bin/notify-me"
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-secretive" ]; then
  _install_secretive() {
    cecho "Install Secretive (Touch ID SSH agent)? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask secretive
      if [ -e "$HOME/.ssh/config.templates/secretive-agent" ] && [ ! -e "$HOME/.ssh/config.local/secretive-agent" ]; then
        mkdir -p "$HOME/.ssh/config.local/"
        ln -s "$HOME/.ssh/config.templates/secretive-agent" "$HOME/.ssh/config.local/secretive-agent"
      fi
      setupnote "Secretive.app" \
        "- [ ] Walk through setup\n- [ ] Generate a key for this machine\n- [ ] Add key to SSH config"
    fi
  }
  sw_install "/Applications/Secretive.app" _install_secretive
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-yubikey-ssh-agent" ]; then
  _install_yubikey_agent() {
    cecho "Install Yubikey SSH Agent? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      if ! brew tap | grep -c filippo.io/yubikey-agent >/dev/null ; then
        brew tap filippo.io/yubikey-agent https://filippo.io/yubikey-agent
      fi
      brew install yubikey-agent && brew services start yubikey-agent
      if [ -e "$HOME/.ssh/config.templates/yubikey-agent" ] && [ ! -e "$HOME/.ssh/config.local/yubikey-agent" ]; then
        mkdir -p "$HOME/.ssh/config.local/"
        ln -s "$HOME/.ssh/config.templates/yubikey-agent" "$HOME/.ssh/config.local/yubikey-agent"
      fi
      setupnote "yubikey-agent" "- [ ] Use \`yubikey-agent -setup\` to generate a new SSH key, if needed\n- [ ] Add new public key to SSH config"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-yubikey-ssh-agent"
    fi
  }
  sw_install "$(brew --prefix)/bin/yubikey-agent" _install_yubikey_agent
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-ykman" ]; then
  _install_ykman() {
    cecho "Install ykman (CLI YubiKey management tool)? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install ykman
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-ykman"
    fi
  }
  sw_install "/Applications/YubiKey Manager.app" _install_ykman
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-yubikey-manager" ]; then
  _install_yubikey_manager() {
    cecho "Install Yubikey Manager? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask yubico-yubikey-manager
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-yubikey-manager"
    fi
  }
  sw_install "/Applications/YubiKey Manager.app" _install_yubikey_manager
fi

_install_elgatocc() {
  brew install --cask elgato-control-center
  setupnote "Elgato Control Center.app" \
    "- [ ] Arrange in menu bar"
}

_install_mutedeck() {
  brew install --cask mutedeck
  # /opt/homebrew/Caskroom/mutedeck/2.6.1/MuteDeck-2.6.1-Installer.app
  MD_INSTALLER_NAME="$(brew info --cask mutedeck | grep -i "Installer.app" | cut -d' ' -f1)" # MuteDeck-2.6.1-Installer.app
  MD_VDIR="$(echo "$MD_INSTALLER_NAME" | cut -d'-' -f2)" # 2.6.1
  set +e
  open "$(brew --prefix)"/Caskroom/mutedeck/"$MD_VDIR"/"$MD_INSTALLER_NAME"
  set -e
  echo ""
  cecho "Please finish installing MuteDeck ..."
  read -rp "(press enter/return to continue)"
  setupnote "MuteDeck" \
"- [ ] Enable Accessibility permissions
- [ ] Enable System Microphone & Zoom only
- [ ] Start at login
- [ ] Don't open window at start
- [ ] Hide in Bartender Bar"
}

if [ ! -e "$HOME/.config/dotfiles/software/no-stream-deck" ]; then
  _install_streamdeck() {
    echo ""
    cecho "Install Elgato Stream Deck utility? (y/N)" $magenta
    echo "(and associated tools)"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask elgato-stream-deck
      setupnote "Elgato Stream Deck.app" \
"- [ ] Enable Accessibility permissions
- [ ] Install plugins: [Control Center](https://marketplace.elgato.com/product/control-center-39a4fa43-1afe-457a-8a19-b5d386e77d53), [Cosmetic Key](https://marketplace.elgato.com/product/cosmetic-key-077407b5-299b-479c-a921-6a3ffec677da), [MuteDeck](https://marketplace.elgato.com/product/mutedeck-5d494067-d9fa-4798-b40e-aca3b09f50a2) or [Zoom](https://marketplace.elgato.com/product/zoom-plugin-a588eabf-fced-401b-a7e3-c12e81bbf75c)
- [ ] Install icons: [Material](https://marketplace.elgato.com/product/material-1c32abe8-341b-4cba-8e2b-186d6ed96070), [Mana](https://marketplace.elgato.com/product/mana-icons-f69dadd1-fd29-463f-b49d-8af9f7567fb6), [Pure](https://marketplace.elgato.com/product/pure-a994a0a5-049c-4382-b73f-417553e1d8bb), [Entype](https://marketplace.elgato.com/product/entypo-854efe00-6c8c-4532-854f-d5a2b3e3acae), [Hexaza](https://marketplace.elgato.com/product/hexaza-3d4ed1dc-bf33-4f30-9ecd-201769f10c0d)
- [ ] Restore config backup/saved profiles as desired
- [ ] Configure as desired"
        brew install --cask elgato-control-center
      if [ ! -e "/Applications/Elgato Control Center.app" ]; then
        _install_elgatocc
      fi
      if [ ! -e "/Applications/MuteDeck" ]; then
        _install_mutedeck
      fi
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-stream-deck"
    fi
  }
  sw_install "/Applications/Elgato Stream Deck.app" _install_streamdeck
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-elgato-control-center" ]; then
  _install_ask_control_center_elgato() {
    echo ""
    cecho "Install Elgato Control Center utility? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      _install_elgatocc
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-elgato-control-center"
    fi
  }
  sw_install "/Applications/Elgato Control Center.app" _install_ask_control_center_elgato
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-mutedeck" ]; then
  _install_ask_mutedeck() {
    echo ""
    cecho "Install MuteDeck? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      _install_mutedeck
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-mutedeck"
    fi
  }
  sw_install "/Applications/MuteDeck" _install_ask_mutedeck
fi

# ScanSnap is now connected exclusively to Curie and syncs scans via iCloud:
# if [ ! -e "$HOME/.config/dotfiles/software/no-home-hardware-utils" ]; then
#    _install_scansnap() {
#     echo ""
#     cecho "Install Fusitsu ScanSnap utility? (y/N)" $magenta
#     read -r response
#     if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
#       sw_install /Applications/ScanSnap "brew_cask_install fujitsu-scansnap-manager" \
#         "- [ ] Right click Dock icon -> Options and enable OCR on all pages\n- [ ] Disable launching at login"
#     else
#       echo "Won't ask again next time this script is run."
#       touch "$HOME/.config/dotfiles/software/no-home-hardware-utils"
#     fi
#   }
#   sw_install /Applications/ScanSnap _install_scansnap
# fi

# MyHarmony isn't supported on anything newer than Mojave:
# sw_install /Applications/MyHarmony.app "brew_cask_install logitech-myharmony"

_install_logitune() {
  cecho "Install LogiTune (for C920 webcam)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'logitune-work')
    pushd "$TMP_DIR"
    curl -L -o LogiTuneInstaller.dmg https://software.vc.logitech.com/downloads/tune/LogiTuneInstaller.dmg
    hdiutil mount LogiTuneInstaller.dmg
    open "/Volumes/LogiTuneInstaller/LogiTuneInstaller.app"
    cecho "Please complete installation with the LogiTune Installer app, and wait until the app opens." $white
    # shellcheck disable=SC2162
    read -p "Press [Enter] to continue..."
    hdiutil unmount "/Volumes/LogiTuneInstaller"
    osascript -e 'tell application "LogiTune" to quit'
    sudo launchctl disable gui/501/com.logitech.logitune.launcher
    popd
    setupnote "LogiTune.app" "- [ ] Disable meeting notifications/calendar integration\n- [ ] Configure webcam as desired"
  fi
}
sw_install "/Applications/LogiTune.app" _install_logitune

_install_iContactControl() {
  cecho "Install iContactControl (for iContact Pro webcam)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    setupnote "iContactControl" \
      "- [ ] Download and install from [icontactcamera.com/blogs/news/discover-your-best-virtual-self-with-icontact-controller](https://icontactcamera.com/blogs/news/discover-your-best-virtual-self-with-icontact-controller)
- [ ] Additional setup steps TKTK"
    cecho "[i] iContactControl cannot be installed automatically." $white
    echo "    Install it from https://icontactcamera.com/blogs/news/discover-your-best-virtual-self-with-icontact-controller"
    echo "    Installation steps have been added to the system setup checklist."
    # shellcheck disable=SC2162
    read -p "    Press [Enter] to continue..."
  fi
}
sw_install "/Applications/iContactControl.app" _install_iContactControl

_install_handmirror() {
  cecho "Install Hand Mirror (webcam preview app)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1502839586
    setupnote "Hand Mirror.app" "- [ ] Set shortcut: Ctrl-Shift-Cmd-M\n- [ ] Set open at login as desired\n- [ ] Select correct webcam\n- [ ] Position in menu bar\n- [ ] Restore purchase"
  fi
}
sw_install "/Applications/Hand Mirror.app" _install_handmirror

_install_portmap() {
  local LATEST_PORTMAP_TAG="PortMap-2.0.1"
  set -x
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'portmap-work')
  pushd "$TMP_DIR"
  curl -s "https://api.github.com/repos/monkeydom/TCMPortMapper/releases/tags/$LATEST_PORTMAP_TAG" | jq -r ".assets[].browser_download_url" | grep "PortMap" | grep ".zip" | xargs wget -q -O portmap.zip
  unzip portmap.zip
  rm portmap.zip
  cp -R "Port Map.app" "/Applications/Port Map.app"
  popd
  set +x
}

if [ ! -e "$HOME/.config/dotfiles/software/no-betterdisplay" ]; then
  _install_betterdisplay() {
    cecho "Install BetterDisplay? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask betterdisplay
      setupnote "BetterDisplay.app" \
        "- [ ] License\n- [ ] Configure as desired"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-betterdisplay"
    fi
  }
  sw_install /Applications/BetterDisplay.app _install_betterdisplay
fi

echo ""
cecho "Install network tools? (y/N)" $magenta
echo "(Discovery, iperf3, mtr, nmap, Port Map, speedtest, telnet, Wifi Explorer)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install /Applications/Discovery.app "mas install 1381004916"
  sw_install "$(brew --prefix)/bin/iperf3" "brew_install iperf3"
  sw_install "$(brew --prefix)/sbin/mtr" "brew_install mtr"
  sw_install "$(brew --prefix)/bin/nmap" "brew_install nmap"
  brew tap | grep -c showwin/speedtest >/dev/null || brew tap showwin/speedtest
  sw_install "$(brew --prefix)/bin/speedtest" "brew_install speedtest"
  sw_install "$(brew --prefix)/bin/telnet" "brew_install telnet"
  sw_install "/Applications/Port Map.app" _install_portmap
  sw_install "/Applications/WiFi Explorer.app" "mas install 494803304"
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-wireshark" ]; then
  _install_wireshark() {
    cecho "Install Wireshark? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask wireshark
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-wireshark"
    fi
  }
  sw_install /Applications/Wireshark.app _install_wireshark
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-bettercap" ]; then
  _install_bettercap() {
    cecho "Install Bettercap? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install bettercap
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-bettercap"
    fi
  }
  sw_install "$(brew --prefix)/bin/bettercap" _install_bettercap
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-rpi-imager" ]; then
  _install_rpi_imager() {
    cecho "Install Raspberry Pi Imager? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask raspberry-pi-imager
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-rpi-imager"
    fi
  }
  sw_install "/Applications/Raspberry Pi Imager.app" _install_rpi_imager
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-balena-etcher" ]; then
  _install_balena_etcher() {
    cecho "Install balena etcher (for burning SD card images)? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask balenaetcher
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-balena-etcher"
    fi
  }
  sw_install /Applications/balenaEtcher.app _install_balena_etcher
fi

_install_fio() {
  cecho "Install fio (CLI-based Flexible IO tester)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install fio
  fi
}
sw_install "$(brew --prefix)/bin/fio" _install_fio

_install_f3() {
  cecho "Install f3 (flash memory card tester)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install f3
  fi
}
sw_install "$(brew --prefix)/bin/f3read" _install_f3

_install_superduper(){
  cecho "Install SuperDuper? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask superduper
    setupnote "SuperDuper.app" "- [ ] Add this system to backup strategy/plan/routine"
  fi
}
sw_install "/Applications/SuperDuper!.app" _install_superduper

if [ ! -e "$HOME/.config/dotfiles/software/no-ivpn" ]; then
  _install_ivpn_client() {
    cecho "Install IVPN client? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask ivpn
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-ivpn"
    fi
  }
  sw_install /Applications/IVPN.app _install_ivpn_client
fi

if [ -e "/Applications/TorBrowser.app" ]; then
  if [ ! -e "/Applications/Tor Browser.app" ]; then
    mv "/Applications/TorBrowser.app" "/Applications/Tor Browser.app"
  else
    trash "/Applications/TorBrowser.app"
  fi
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-tor" ]; then
  _install_torbrowser() {
    cecho "Install Tor Browser? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask tor-browser
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-tor"
    fi
  }
  sw_install "/Applications/Tor Browser.app" _install_torbrowser
fi

_install_vncviewer() {
  cecho "Install VNC Viewer? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask vnc-viewer
  fi
}
sw_install "/Applications/VNC Viewer.app" _install_vncviewer

if [ ! -e "$HOME/.config/dotfiles/software/no-transmit" ]; then
  _install_transmit() {
    cecho "Install Transmit? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask Transmit
      setupnote "Transmit" \
        "- [ ] License\n- [ ] Sign into Panic Sync (Transmit and Nova repository)\n- [ ] Configure application"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-transmit"
    fi
  }
  sw_install "/Applications/Transmit.app" _install_transmit
fi

echo ""
cecho "--- Dev Tools ---" $white
echo ""

cecho "Install basic development tools? (y/N)" $magenta
echo "(Expressions, Fork, Sublime Merge, TextBuddy, cloc, hexyl, file watchers)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  # GUI dev tools:
  sw_install /Applications/Expressions.app "mas install 913158085"
  sw_install /Applications/Fork.app "brew_cask_install fork" \
    "- [ ] Activate license\n- [ ] Switch to Stable update channel\n- [ ] Set Git instance (use Homebrew Git)\n- [ ] Set Terminal tool (iTerm2)\n- [ ] Set Diff & Merge tools (Kaleidoscope)\n- [ ] Set GitHub Desktop as default GitHub tool\n- [ ] Sign into GitHub account (as desired)"
  sw_install "/Applications/Sublime Merge.app" "brew_cask_install sublime-merge" \
    "- [ ] License"
  sw_install "/Applications/TextBuddy.app" "brew_cask_install textbuddy" \
    "- [ ] Assign global shortcut Ctrl+Shift+T\n- [ ] License"

  # Via Setapp:
  if [ ! -e /Applications/Setapp/CodeRunner.app ]; then
    cecho "Please install CodeRunner via Setapp." $white
    open "https://setapp.com/apps/coderunner"
  fi

  # CLI tools, not installed by default on non-dev machines:
  sw_install "$(brew --prefix)/bin/cloc" "brew_install cloc"
  sw_install "$(brew --prefix)/bin/hexyl" "brew_install hexyl"

  # Various file watchers, popular in various communities/with various toolchains:
  sw_install "$(brew --prefix)/bin/air" "brew gomod github.com/cosmtrek/air"
  sw_install "$(brew --prefix)/bin/entr" "brew_install entr"
  sw_install /usr/local/bin/nodemon "npm install -g nodemon" # drop-in watcher for Node projects
  sw_install "$(brew --prefix)/bin/watchman" "brew_install watchman" # popular for React Native
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-boop" ]; then
  _install_boop() {
    cecho "Install Boop? (y/N)" $magenta
    echo "(OSS TextBuddy alternative)"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      mas install 1518425043
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-boop"
    fi
  }
  sw_install "/Applications/Boop.app" _install_boop
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-jetbrains" ]; then
  _install_jetbrains() {
    cecho "Install JetBrains Toolbox? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask jetbrains-toolbox
      setupnote "JetBrains Toolbox.app" \
        "- [ ] Sign into JetBrains account\n- [ ] Enable automatic updates\n- [ ] Enable 'Generate Shell Scripts' to \`~/opt/bin\`\n- [ ] Enable 'Run at Login'\n- [ ] Install IDEs as desired\n- [ ] Enable settings & plugin syncing"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-jetbrains"
    fi
  }
  sw_install "/Applications/JetBrains Toolbox.app" _install_jetbrains
fi

_install_ask_dash() {
  cecho "Install Dash? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask dash
    setupnote "Dash.app" \
      "- [ ] Sync settings from \`~/.config/macos\`\n- [ ] Sync snippets\n- [ ] Review & Arrange docsets as desired\n- [ ] License"
  fi
}
sw_install /Applications/Dash.app _install_ask_dash

_install_ask_jsoneditor() {
  cecho "Install JSON Editor? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 567740330
    setupnote "JSON Editor.app" "- [ ] Associate with JSON files"
  fi
}
sw_install "/Applications/JSON Editor.app" _install_ask_jsoneditor

_install_csveditor() {
  cecho "Install CSV Editor? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install "/Applications/Easy CSV Editor.app" "mas install 1171346381" \
      "- [ ] Associate with CSV files"
  fi
}
sw_install "/Applications/Easy CSV Editor.app" _install_csveditor

_install_plist_editor() {
  cecho "Install PLIST Editor? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install "/Applications/PLIST Editor.app" "mas install 1157491961" \
      "- [ ] Associate with PLIST files"
  fi
}
sw_install "/Applications/PLIST Editor.app" _install_plist_editor

_install_wwdcapp() {
  cecho "Install WWDC macOS application (for watching/downloading videos)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask wwdc
  fi
}
sw_install /Applications/WWDC.app _install_wwdcapp

_install_sfsymbols() {
  cecho "Install Apple's SF Symbols Mac app? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
     brew install --cask sf-symbols
  fi
}
sw_install "/Applications/SF Symbols.app" _install_sfsymbols

echo ""
cecho "HTTP/API Tools..." $white
echo ""

_install_paw() {
  cecho "Install ~Paw~ RapidAPI? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install /Applications/RapidAPI.app "brew_cask_install rapidapi" \
      "- [ ] Sign in / License\n- [ ] Set font: Meslo LG M 13"
  fi
}
sw_install /Applications/RapidAPI.app _install_paw

echo ""
cecho "Install HTTP tools? (y/N)" $magenta
echo "(httpie for CLI; HTTP Toolkit for GUI)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install "/Applications/HTTP Toolkit.app" "brew_cask_install http-toolkit"
  sw_install "$(brew --prefix)/bin/http" "brew_install httpie"
fi

_install_websocat() {
  cecho "Install websocat? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install websocat
  fi
}
sw_install "$(brew --prefix)/bin/websocat" _install_websocat

echo ""
cecho "Languages & Tools..." $white
echo ""

echo ""
cecho "Install common Go tools? (y/N)" $magenta
echo "(golint, goimports, gorc, pkger, golangci-lint, ifacemaker)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install "$(brew --prefix)/bin/golint" "brew gomod golang.org/x/lint/golint"
  sw_install "$(brew --prefix)/bin/goimports" "brew gomod golang.org/x/tools/cmd/goimports"
  sw_install "$(brew --prefix)/bin/gorc" "brew gomod github.com/stretchr/gorc"
  sw_install "$(brew --prefix)/bin/pkger" "brew gomod github.com/markbates/pkger/cmd/pkger"
  sw_install "$(brew --prefix)/bin/golangci-lint" "brew_install golangci-lint"
  sw_install "$(brew --prefix)/bin/ifacemaker" "brew gomod github.com/vburenin/ifacemaker@master"
fi

echo ""
cecho "Install Python env management tools? (y/N)" $magenta
echo "(virtualenv, pipenv, pyenv)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install "$(brew --prefix)/bin/virtualenv" "brew_install virtualenv" # 'PIP_REQUIRE_VIRTUALENV="0" $(brew --prefix)/bin/pip3 install virtualenv'
  sw_install "$(brew --prefix)/bin/pipenv" "brew_install pipenv"
  # optional, but recommended build deps w/pyenv: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  sw_install "$(brew --prefix)/bin/pyenv" "brew install pyenv openssl readline sqlite3 xz zlib"
fi

echo ""
cecho "Install common Python code quality tools? (y/N)" $magenta
echo "(black, flake8, pycodestyle, pylint)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install "$(brew --prefix)/bin/black" "brew_install black"
  sw_install "$(brew --prefix)/bin/flake8" "brew_install flake8"
  sw_install "$(brew --prefix)/bin/pylint" "brew_install pylint"
  sw_install "$(brew --prefix)/bin/pycodestyle" "brew_install pycodestyle"
fi

echo ""
cecho "Install common JS/TS tools? (y/N)" $magenta
echo "(corepack, nvm, pnpm, tsc, yarn; prettier, eslint, jshint)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install "$(brew --prefix)"/bin/corepack "brew_install corepack"
  mkdir -p "$HOME/.nvm" && sw_install "$(brew --prefix)"/opt/nvm "brew_install nvm"
  corepack enable pnpm
  sw_install "$(brew --prefix)"/bin/tsc 'brew_install tsc'
  corepack enable yarn
  sw_install "$(brew --prefix)/bin/prettier" 'brew_install prettier'
  sw_install "$(brew --prefix)/bin/eslint" 'brew_install eslint'
  sw_install "$(brew --prefix)/bin/jshint" 'npm install -g jshint'
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-embedded-tools" ]; then
  cecho "Install embedded development tools (Arduino, PlatformIO)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      sw_install "$(brew --prefix)/bin/arduino-cli" 'brew_install arduino-cli'
      sw_install "/Applications/Arduino IDE.app" 'brew_cask_install arduino-ide'
      sw_install "$(brew --prefix)/bin/platformio" 'brew_install platformio'
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/software/no-embedded-tools"
  fi
fi

_install_ask_script_debugger() {
  cecho "Install Script Debugger (for AppleScript)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask script-debugger
  fi
}
sw_install "/Applications/Script Debugger.app" _install_ask_script_debugger

if [ ! -e "$HOME/.config/dotfiles/software/no-carthage" ]; then
  cecho "Install Carthage? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install "$(brew --prefix)"/bin/carthage 'brew_install carthage'
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/software/no-carthage"
  fi
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-react-native" ]; then
  cecho "Install React Native CLI? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install /usr/local/bin/react-native "npm install -g react-native-cli"
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/software/no-react-native"
  fi
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-sbt" ]; then
  cecho "Install Scala tools (sbt)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install "$(brew --prefix)/bin/sbt" 'brew_install sbt'
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/software/no-sbt"
  fi
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-java-devtools" ]; then
  echo ""
  cecho "Install Java tools (JDK, Maven, Gradle completion for bash/zsh)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sw_install "$(brew --prefix)/Caskroom/java" "brew_cask_install java"
    sw_install "$(brew --prefix)/Cellar/gradle-completion" "brew_install gradle-completion"
    sw_install "$(brew --prefix)/bin/mvn" "brew_install maven"
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/software/no-java-devtools"
  fi
fi

cecho "Install Latex tools? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install "/Applications/TeX" "brew_cask_install mactex"
  sw_install "/Applications/texmaker.app" "brew_cask_install texmaker"
fi

echo ""
cecho "Cloud CLIs..." $white
echo ""

_install_awscli() {
  cecho "Install AWS CLI? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install awscli
  fi
}
sw_install "$(brew --prefix)/bin/aws" _install_awscli

_install_docli() {
  cecho "Install DigitalOcean CLI? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install doctl
  fi
}
sw_install "$(brew --prefix)/bin/doctl" _install_docli

_install_gcloud_sdk() {
  cecho "Install Google Cloud SDK? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask google-cloud-sdk
  fi
}
sw_install "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" _install_gcloud_sdk

echo ""
cecho "Virtualization, Docker, K8s..." $white
echo ""

if [ ! -e /Applications/Docker.app ] && [ ! -e /Applications/OrbStack.app ]; then
  echo ""
  cecho "Install OrbStack? (y/N)" $magenta
  echo "(answering Yes will skip asking about Docker Desktop installation)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask orbstack
    setupnote "OrbStack.app" \
      "- [ ] Start at login; show in menu bar\n- [ ] Automatically download updates\n- [ ] Set memory and CPU limits as desired"
    if [ -e "$HOME"/.ssh/config.templates/orbstack ] && [ ! -e "$HOME"/.ssh/config.local/orbstack ]; then
      ln -s "$HOME"/.ssh/config.templates/orbstack "$HOME"/.ssh/config.local/orbstack
    fi
    mkdir -p "$HOME/opt/docker/compose"
    mkdir -p "$HOME/opt/docker/data"
  fi
fi

if [ ! -e /Applications/Docker.app ] && [ ! -e /Applications/OrbStack.app ]; then
  echo ""
  cecho "Install Docker? (y/N)" $magenta
  echo "(answering Yes will skip asking about OrbStack installation in the future)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask docker
    setupnote "Docker.app" \
      "- [ ] Disable application starting at login, as desired\n- [ ] Disable weekly tips\n- [ ] Enable Docker Compose V2, as desired"
    mkdir -p "$HOME/opt/docker/compose"
    mkdir -p "$HOME/opt/docker/data"
  fi
fi

echo ""
cecho "Install Docker/container tools (act, dive, dockerfilelint, hadolint, periodic-docker-pull)? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sw_install "$(brew --prefix)/bin/act" "brew_install act"
  brew tap | grep -c wagoodman/dive >/dev/null || brew tap wagoodman/dive
  sw_install "$(brew --prefix)/bin/dive" "brew_install dive"
  sw_install "$(brew --prefix)/bin/hadolint" "brew_install hadolint"
  sw_install "$(brew --prefix)/bin/_periodic_docker_pull" "brew_install cdzombak/oss/periodic-docker-pull"
  sw_install "$(brew --prefix)/bin/dockerfilelint" 'npm install -g dockerfilelint'
fi

if ! uname -p | grep -c "arm" >/dev/null; then
  _install_virtualbox() {
    cecho "Install VirtualBox? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask virtualbox virtualbox-extension-pack
      mkdir -p "$HOME/VirtualBox VMs"
      mkdir -p "$HOME/VM Images"
    fi
  }
  sw_install /Applications/VirtualBox.app _install_virtualbox
fi

echo ""
cecho "Install Kubernetes tools? (y/N)" $magenta
echo "(k9s [CLI k8s manager], kail [k8s tail], Lens [GUI k8s IDE])"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  YES_INSTALL_KUBECTL=true
  brew tap | grep -c boz/repo >/dev/null || brew tap boz/repo
  sw_install "$(brew --prefix)/bin/kail" "brew_install boz/repo/kail"
  sw_install "$(brew --prefix)/bin/k9s" "brew_install derailed/k9s/k9s"
  sw_install "/Applications/Lens.app" "brew_cask_install lens"
fi

_install_servercat() {
  cecho "Install ServerCat? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1501532023
    setupnote "ServerCat.app" \
      "- [ ] Add servers as desired"
  fi
}
sw_install "/Applications/ServerCat.app" _install_servercat

echo ""
cecho "--- CAD, 3DP, EE, Radio ---" $white
echo ""

if [ ! -e "$HOME/.config/dotfiles/software/no-bambu-studio" ]; then
  _install_bambustudio() {
    cecho "Install Bambu Studio? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask bambu-studio
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-bambu-studio"
    fi
  }
  sw_install "/Applications/BambuStudio.app" _install_bambustudio
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-cura" ]; then
  _install_cura() {
    cecho "Install Cura? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask ultimaker-cura
      setupnote "Ultimaker Cura" \
        "- [ ] Sign In\n- [ ] Install Mesh Tools extension\n- [ ] Restore settings etc. from most recent backup (Extensions > Cura Backups)"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-cura"
    fi
  }
  sw_install "/Applications/UltiMaker Cura.app" _install_cura
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-fusion360" ]; then
  _install_f360() {
    cecho "Install Autodesk Fusion? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask autodesk-fusion360
      setupnote "Autodesk Fusion" "- [ ] Sign In"
      chflags -h hidden "$HOME/Applications/Remove Autodesk Fusion.app"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-fusion360"
    fi
  }
  sw_install "$HOME/Applications/Autodesk Fusion.app" _install_f360
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-openscad" ]; then
  _install_openscad() {
    cecho "Install OpenSCAD? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask homebrew/cask-versions/openscad-snapshot
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-openscad"
    fi
  }
  sw_install /Applications/OpenSCAD.app _install_openscad
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-meshman3dviewer" ]; then
  _install_meshman3dviewer() {
    cecho "Install Meshman 3D Viewer? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      mas install 1502933106
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-meshman3dviewer"
    fi
  }
  sw_install "/Applications/Meshman 3D Viewer PRO.app" _install_meshman3dviewer
fi

if [ -e "$HOME/.config/dotfiles/software/no-kicad" ]; then
  mv "$HOME/.config/dotfiles/software/no-kicad" "$HOME/.config/dotfiles/software/no-ee-tools"
fi
if [ ! -e "$HOME/.config/dotfiles/software/no-ee-tools" ]; then
  cecho "Install EE tools (LTSpice, KiCad)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
     sw_install /Applications/KiCad 'brew_cask_install kicad'
     sw_install /Applications/LTSpice.app 'brew_cask_install ltspice'
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/software/no-ee-tools"
  fi
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-cubicsdr" ]; then
  _install_cubicsdr() {
    cecho "Install CubicSDR? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask cubicsdr
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-cubicsdr"
    fi
  }
  sw_install /Applications/CubicSDR.app _install_cubicsdr
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-chirp" ]; then
  _install_chirp() {
    cecho "Install CHIRP (radio programming tool)? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask chirp
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-chirp"
    fi
  }
  sw_install /Applications/CHIRP.app _install_chirp
fi

echo ""
cecho "--- Office & Communication ---" $white
echo ""

_install_firefox() {
  cecho "Install Firefox? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask firefox
    setupnote "Firefox.app" \
        "- [ ] Sign into Firefox Sync\n- [ ] Change device name\n- [ ] Sync uBlock settings from cloud storage\n- [ ] Customize toolbar\n- [ ] Remove default bookmarks\n- [ ] Disable Pocket (\`about:config\` and disable \`extensions.pocket.enabled\`)"
  fi
}
sw_install /Applications/Firefox.app _install_firefox

if [ ! -e "$HOME/.config/dotfiles/software/no-slack" ]; then
  _install_slack() {
    cecho "Install Slack? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      sw_install /Applications/Slack.app "brew_cask_install slack" \
        "- [ ] Sign in to Slack accounts"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-slack"
    fi
  }
  sw_install /Applications/Slack.app _install_slack
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-zoom" ]; then
  _install_zoom() {
    cecho "Install Zoom for videoconferencing? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      # keep Zoom from installing its shitty local webserver thing
      rm -rf "$HOME/.zoomus"
      touch "$HOME/.zoomus"
      brew install --cask zoom
      setupnote "Zoom.app" \
        "- [ ] Enable microphone mute when joining meeting\n- [ ] Disable video when joining meeting\n- [ ] Generally configure as desired"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-zoom"
    fi
  }
fi

_install_signal() {
  cecho "Install Signal? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask signal
    setupnote "Signal.app" \
        "- [ ] Authenticate with phone"
  fi
}
sw_install /Applications/Signal.app _install_signal

if [ ! -e "$HOME/.config/dotfiles/software/no-google-drive" ]; then
  _install_gdrive() {
    cecho "Install Google Drive? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask google-drive
      setupnote "Google Drive.app" \
        "- [ ] Authenticate"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-google-drive"
    fi
  }
  sw_install "/Applications/Google Drive.app" _install_gdrive
fi

_install_clocker() {
  cecho "Install Clocker? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1056643111
  fi
}
sw_install /Applications/Clocker.app _install_clocker

_install_diagrams() {
  cecho "Install Diagrams? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1276248849
  fi
}
sw_install /Applications/Diagrams.app _install_diagrams

_install_drawio() {
  cecho "Install Draw.io app? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask drawio
  fi
}
sw_install /Applications/draw.io.app _install_drawio

_install_monodraw() {
  cecho "Install Monodraw? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask monodraw
    # shellcheck disable=SC2129
    echo "## Monodraw.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Register (link in 1Password)" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/Monodraw.app _install_monodraw

_install_omnigraffle() {
  cecho "Install OmniGraffle? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask omnigraffle
    # shellcheck disable=SC2129
    echo "## OmniGraffle.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] License" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/OmniGraffle.app _install_omnigraffle

_install_omnioutliner() {
  cecho "Install OmniOutliner? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask omnioutliner
    setupnote "OmniOutliner" "- [ ] License\n- [ ] Link template folder in \`~/.config/macos/OmniOutliner\`"
  fi
}
sw_install /Applications/OmniOutliner.app _install_omnioutliner

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
    brew install --cask deckset
  fi
}
sw_install /Applications/Deckset.app _install_deckset

_install_pdfscanner() {
  cecho "Install PDF Scanner (PDF scan & compression tool)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 410968114
  fi
}
sw_install /Applications/PDFScanner.app _install_pdfscanner

_install_tableflip() {
  cecho "Install TableFlip (Markdown table utility)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask tableflip
  fi
}
sw_install /Applications/TableFlip.app _install_tableflip

_install_calca() {
  cecho "Install Calca? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 635758264 # Calca
  fi
}
sw_install /Applications/Calca.app _install_calca

echo ""
cecho "--- Media Tools ---" $white
echo ""

if [ -e "/Applications/Pixelmator.app" ]; then
  echo "Replacing Pixelmator Classic by Pixelmator Pro..."
  mas install 1289583905
  sudo rm -rf "/Applications/Pixelmator.app"
fi

_install_pixelmator() {
  cecho "Install Pixelmator? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1289583905
  fi
}
sw_install "/Applications/Pixelmator Pro.app" _install_pixelmator

_install_acorn() {
  cecho "Install Acorn? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1547371478
  fi
}
sw_install "/Applications/Acorn.app" _install_acorn

_install_affinity_photo() {
  cecho "Install Affinity Photo? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask affinity-photo
  fi
}
sw_install "/Applications/Affinity Photo 2.app" _install_affinity_photo

_install_raw_power() {
  cecho "Install RAW Power? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1157116444
  fi
}
sw_install "/Applications/RAW Power.app" _install_raw_power

_install_topaz_sharpen() {
  cecho "Install Topaz Sharpen AI? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask topaz-sharpen-ai
  fi
}
sw_install "/Applications/Topaz Sharpen AI.app" _install_topaz_sharpen

_install_note_dxophotolab() {
  cecho "Install DxO PhotoLab? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    setupnote "DxO PhotoLab" "- [ ] Download and install from [dxo.com/dxo-photolab/download](https://www.dxo.com/dxo-photolab/download/)"
    cecho "[i] DxO PhotoLab cannot be installed automatically." $white
    echo "    Install it from https://www.dxo.com/dxo-photolab/download"
    echo "    Installation steps have been added to the system setup checklist."
    # shellcheck disable=SC2162
    read -p "    Press [Enter] to continue..."
  fi
}
sw_install "/Applications/DXOPhotoLab7.app" _install_note_dxophotolab

_install_note_dxofilmpack() {
  cecho "Install DxO FilmPack? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    setupnote "DxO FilmPack" "- [ ] Download and install from [dxo.com/dxo-filmpack/download](https://www.dxo.com/dxo-filmpack/download/)"
    cecho "[i] DxO FilmPack cannot be installed automatically." $white
    echo "    Install it from https://www.dxo.com/dxo-filmpack/download"
    echo "    Installation steps have been added to the system setup checklist."
    # shellcheck disable=SC2162
    read -p "    Press [Enter] to continue..."
  fi
}
sw_install "/Applications/DxO FilmPack 7.app" _install_note_dxofilmpack

_install_note_sigmaphotopro() {
  cecho "Install Sigma Photo Pro? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    setupnote "Sigma Photo Pro" "- [ ] Download and install from [sigma-global.com/en/support/software/sigma-photo-pro](https://www.sigma-global.com/en/support/software/sigma-photo-pro/?os=mac)"
    cecho "[i] Sigma Photo Pro cannot be installed automatically." $white
    echo "    Install it from https://www.sigma-global.com/en/support/software/sigma-photo-pro/?os=mac"
    echo "    Installation steps have been added to the system setup checklist."
    # shellcheck disable=SC2162
    read -p "    Press [Enter] to continue..."
  fi
}
sw_install "/Applications/SIGMA Photo Pro 6.app" _install_note_sigmaphotopro

_install_note_sigmaoptimizationpro() {
  cecho "Install Sigma Optimization Pro? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    setupnote "Sigma Optimization Pro" "- [ ] Download and install from [sigma-global.com/en/support/software/sigma-optimization-pro](https://www.sigma-global.com/en/support/software/sigma-optimization-pro/?os=mac)"
    cecho "[i] Sigma Optimization Pro cannot be installed automatically." $white
    echo "    Install it from https://www.sigma-global.com/en/support/software/sigma-optimization-pro/?os=mac"
    echo "    Installation steps have been added to the system setup checklist."
    # shellcheck disable=SC2162
    read -p "    Press [Enter] to continue..."
  fi
}
sw_install "/Applications/SIGMA Optimization Pro.app" _install_note_sigmaoptimizationpro

_install_x3f_qlgenerator() {
  cecho "Install X3F QL Plugin.qlgenerator? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'x3fqlgenerator')
    pushd "$TMP_DIR"
    wget https://dropbox.dzombak.com/X3F-QL-Plugin.qlgenerator.zip
    mkdir -p "$HOME/Library/QuickLook/"
    unzip X3F-QL-Plugin.qlgenerator.zip -d "$HOME/Library/QuickLook/"
    rm -rf "$HOME/Library/QuickLook/__MACOSX"
    popd

    setupnote "X3F QL Plugin.qlgenerator" "- [ ] Enable in System Settings"
  fi
}
sw_install "$HOME/Library/QuickLook/X3F QL Plugin.qlgenerator" _install_x3f_qlgenerator

_install_mandatory_x3f_tools() {
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'x3ftools')
  pushd "$TMP_DIR"
  curl -s https://api.github.com/repos/Kalpanika/x3f/releases/latest | jq -r ".assets[].browser_download_url" | grep "osx-universal" | xargs wget -q -O x3ftools.tar.gz
  tar xzvf x3ftools.tar.gz
  cp ./x3f_tools-*/bin/* "$HOME/opt/bin"
  popd
}

_install_xtool() {
  cecho "Install xtool? (y/N)" $magenta
  echo "( https://github.com/cdzombak/xtool )"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    _install_mandatory_x3f_tools

    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'xtool')
    pushd "$TMP_DIR"
    git clone https://github.com/cdzombak/xtool.git
    cd xtool
    sudo make install
    popd

    if [ ! -e "$HOME/.xtoolbak.json" ]; then
      echo '{ "backups_location": "sub_dir", "backups_folder": "_Xtoolbak" }' | jq . > "$HOME/.xtoolbak.json"
    fi
    if [ ! -e "$HOME/.config/xtoolconfig.json" ]; then
      ln -s "$HOME/.config/macos/xtoolconfig.json" "$HOME/.config/xtoolconfig.json"
    fi
  fi
}
sw_install "/usr/local/bin/xtool" _install_xtool

if [ -e /usr/local/bin/xtool ]; then
  if [ ! -e "$HOME/Library/Scripts/Applications/Finder/xtool - Inspect GPS.scpt" ]; then
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'xtool')
    pushd "$TMP_DIR"
    git clone https://github.com/cdzombak/xtool.git
    cd xtool
    make applescript-install
    popd

    rm -f "$HOME/Library/Scripts/Applications/Finder/xtool - Camswap Sfp.scpt"
  fi
fi

_install_x3f_tools() {
  cecho "Install x3f_extract? (y/N)" $magenta
  echo "( https://github.com/Kalpanika/x3f )"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    _install_mandatory_x3f_tools
  fi
}
sw_install "$HOME/opt/bin/x3f_extract" _install_x3f_tools

_install_photosweeper() {
  cecho "Install PhotoSweeper X? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask photosweeper-x
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

_install_colorsnapper() {
  cecho "Install ColorSnapper? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 969418666
  fi
}
sw_install /Applications/ColorSnapper2.app _install_colorsnapper

_install_geotag() {
  cecho "Install GeoTag? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask geotag
    mkdir -p "$HOME/tmp/GeoTag Backups"
    # shellcheck disable=SC2129
    echo "## /Applications/GeoTag.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Set backups directory to \`~/tmp/GeoTag Backups\`" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/GeoTag.app _install_geotag

_install_avenue() {
  cecho "Install Avenue (GPX viewer)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1523681067
  fi
}
sw_install "/Applications/Avenue.app" _install_avenue

if [ ! -e "$HOME/.config/dotfiles/software/no-adobecc" ]; then
  _install_adobe_cc() {
    cecho "Install Adobe Creative Cloud? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask adobe-creative-cloud
      # shellcheck disable=SC2129
      echo "## Adobe Creative Cloud" >> "$HOME/SystemSetup.md"
      echo "" >> "$HOME/SystemSetup.md"
      echo -e "- [ ] Sign into Adobe Account\n-[ ] Install Lightroom\n- [ ] Install Photoshop" >> "$HOME/SystemSetup.md"
      echo "" >> "$HOME/SystemSetup.md"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-adobecc"
    fi
  }
  sw_install "/Applications/Adobe Creative Cloud" _install_adobe_cc
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-applepromediatools" ]; then
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
    touch "$HOME/.config/dotfiles/software/no-applepromediatools"
  fi
fi

_install_claquette() {
  cecho "Install Claquette (lightweight simple video editing tool)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 587748131
  fi
}
sw_install /Applications/Claquette.app _install_claquette

_install_tag_editor() {
  cecho "Install Tag Editor? (amvidia.com/tag-editor) (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask tageditor
    setupnote "Tag Editor.app" "- [ ] License"
  fi
}
sw_install "/Applications/Tag Editor.app" _install_tag_editor

_install_youtubedl() {
  cecho "Install ~youtube-dl~ yt-dlp? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # brew install youtube-dl
    brew install yt-dlp
  fi
}
sw_install "$(brew --prefix)/bin/yt-dlp" _install_youtubedl

_install_quickmediaconv() {
  echo ""
  cecho "Install quick media conversion scripts? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install cdzombak/oss/quick-media-conv
  fi
}
sw_install "$(brew --prefix)/bin/flv2mp4" _install_quickmediaconv

if [ ! -e "$HOME/.config/dotfiles/software/no-handbrake" ]; then
  _install_handbrake() {
    cecho "Install Handbrake? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask handbrake
      sw_install "$(brew --prefix)/lib/libmp3lame.dylib" "brew_install lame"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-handbrake"
    fi
  }
  sw_install /Applications/Handbrake.app _install_handbrake
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-calibre" ]; then
  _install_calibre() {
    cecho "Install Calibre + Android File Transfer tool? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask calibre
      brew install --cask android-file-transfer
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-calibre"
    fi
  }
  sw_install /Applications/calibre.app _install_calibre
fi

echo ""
cecho "--- Home ---" $white
echo ""

if [ -e "/Applications/Sonos S1 Controller.app" ]; then
  brew uninstall --cask --force sonos
  rm -rf "/Applications/Sonos S1 Controller.app"
  brew cleanup
  brew update
fi
_install_sonos() {
  cecho "Install Sonos? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask sonos
    # shellcheck disable=SC2129
    echo "## Sonos.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "**Note:** do not enable notifications." >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install "/Applications/Sonos.app" _install_sonos

_install_parcel() {
  cecho "Install Parcel (package tracker)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 639968404
    setupnote "Parcel.app" \
      "- [ ] Allow notifications\n- [ ] Tweak system notification settings (all off except \"Show in Notification Center\")\n- [ ] Enable calendar integration"
  fi
}
sw_install "/Applications/Parcel.app" _install_parcel

echo ""
cecho "--- Music / Podcasts / Reading ---" $white
echo ""

_install_plexamp() {
  cecho "Install Plexamp? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask plexamp
    # shellcheck disable=SC2129
    echo "## Plexamp.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Sign into Plex account" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Turn off notifications (Settings > Appearance)" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Disable crossfades (Settings > Playback)" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Set 160Kbps conversion bitrate (Settings > Music Quality)" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/Plexamp.app _install_plexamp

_install_infuse() {
  cecho "Install Infuse? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1136220934
    setupnote "Infuse.app" \
      "- [ ] Sign into Plex servers as desired\n- [ ] Add file shares as desired\n- [ ] Disable file shares in Library views\n- [ ] Restore purchases"
  fi
}
sw_install /Applications/Infuse.app _install_infuse

_install_plexdesktop() {
  cecho "Install Plex Desktop? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask plex
    # shellcheck disable=SC2129
    echo "## Plex.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Sign into Plex account" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
}
sw_install /Applications/Plex.app _install_plexdesktop

_install_pocketcasts() {
  cecho "Install Pocket Casts? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask pocket-casts
  fi
}
sw_install "/Applications/Pocket Casts.app" _install_pocketcasts

_install_ytmusic() {
  cecho "Install YT Music? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install --cask yt-music
  fi
}
sw_install "/Applications/YT Music.app" _install_ytmusic

_install_triode() {
  cecho "Install Triode? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 1450027401
  fi
}
sw_install "/Applications/Triode.app" _install_triode

_install_kindle() {
  cecho "Install Kindle? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mas install 405399194 # Kindle
  fi
}
sw_install /Applications/Kindle.app _install_kindle

if [ ! -e "$HOME/.config/dotfiles/software/no-remotehelperapp" ]; then
  _install_remotehelperapp() {
    cecho "Install Remote Helper app (companion to iOS Remote Control app)? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'remotehelperapp-work')
      pushd "$TMP_DIR"
      wget --quiet -O "RemoteForMac.zip" "https://cherpake.com/download-latest"
      unzip ./RemoteForMac.zip
      sudo installer -pkg ./Remote-for-Mac-*.pkg -target /
      popd
      # shellcheck disable=SC2129
      echo "## Remote for Mac.app" >> "$HOME/SystemSetup.md"
      echo "" >> "$HOME/SystemSetup.md"
      echo -e "- [ ] Work through required permissions" >> "$HOME/SystemSetup.md"
      echo "" >> "$HOME/SystemSetup.md"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-remotehelperapp"
    fi
  }
  sw_install "/Applications/Remote for Mac.app" _install_remotehelperapp
fi

echo ""
cecho "--- Social Networking ---" $white
echo ""

if [ ! -e "$HOME/.config/dotfiles/software/no-discord" ]; then
  _install_discord() {
    cecho "Install Discord? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask discord
      setupnote "Discord" "- [ ] Login\n- [ ] Disable unread message badge (Preferences > Notifications)\n- [ ] Disable notification sounds in System Preferences"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-discord"
    fi
  }
  sw_install /Applications/Discord.app _install_discord
fi


if [ -e "$HOME/.config/dotfiles/software/no-mastonaut" ]; then
  touch "$HOME/.config/dotfiles/software/no-ivory"
  trash "$HOME/.config/dotfiles/software/no-mastonaut"
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-ivory" ]; then
  _install_ivory() {
    cecho "Install Ivory (Mastodon client)? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      mas install 6444602274
      setupnote "Ivory" "- [ ] Sign into personal a2mi.social Mastodon account\n- [ ] Restore purchases\n- [ ] Enable notifications\n- [ ] Notification settings (system level): Disable banners & sounds; previews only when unlocked\n- [ ] Sign into Instapaper"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-ivory"
    fi
  }
  sw_install /Applications/Ivory.app _install_ivory
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-mona" ]; then
  _install_mona() {
    cecho "Install Mona (Mastodon client)? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      mas install 1659154653
      setupnote "Mona" "- [ ] Sign into personal a2mi.social Mastodon account\n- [ ] Restore purchases\n- [ ] Disallow notifications (for now)"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-mona"
    fi
  }
  sw_install /Applications/Mona.app _install_mona
fi

if [ -e "$HOME/.config/dotfiles/software/no-caprine" ]; then
  touch "$HOME/.config/dotfiles/software/no-messenger"
  rm "$HOME/.config/dotfiles/software/no-caprine"
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-messenger" ]; then
  _install_messenger() {
    cecho "Install Facebook Messenger? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask messenger
      setupnote "Messenger.app" "- [ ] Sign into Facebook account"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-messenger"
    fi
  }
  sw_install /Applications/Messenger.app _install_messenger
fi

echo ""
cecho "--- Games ---" $white
echo ""

if [ ! -e "$HOME/.config/dotfiles/software/no-steam" ]; then
  _install_steam() {
    cecho "Install Steam? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      sw_install /Applications/Steam.app "brew install --cask steam" \
        "- [ ] Launch & sign in\n- [ ] Remove login item in System Preferences/Users & Groups\n- [ ] Disable & unload \`com.valvesoftware.steamclean\` launchd job"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-steam"
    fi
  }
  sw_install /Applications/Steam.app _install_steam
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-nsnake" ]; then
  _install_nsnake() {
    cecho "Install nsnake? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install nsnake
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-nsnake"
    fi
  }
  sw_install "$(brew --prefix)/bin/nsnake" _install_nsnake
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-blackink" ]; then
  _install_blackink() {
    cecho "Install Black Ink (crossword puzzle app)? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'black-ink-work')
      pushd "$TMP_DIR"
      wget --quiet "https://redsweater.com/blackink/BlackInkLatest.zip"
      unzip ./BlackInkLatest.zip
      cp -R "Black Ink.app" /Applications/
      popd
      # shellcheck disable=SC2129
      echo "## Black Ink.app" >> "$HOME/SystemSetup.md"
      echo "" >> "$HOME/SystemSetup.md"
      echo -e "- [ ] License\n- [ ] Enable software updates" >> "$HOME/SystemSetup.md"
      echo "" >> "$HOME/SystemSetup.md"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-blackink"
    fi
  }
  sw_install "/Applications/Black Ink.app" _install_blackink
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-minimetro" ]; then
  _install_minimetro() {
    cecho "Install Mini Metro? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      mas install 1047760200 # Mini Metro
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-minimetro"
    fi
  }
  sw_install "/Applications/Mini Metro.app" _install_minimetro
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-simcity" ]; then
  _install_simcity() {
    cecho "Install SimCity 4 Deluxe? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      mas install 804079949 # SimCity 4 Deluxe Edition
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-simcity"
    fi
  }
  sw_install "/Applications/Sim City 4 Deluxe Edition.app" _install_simcity
fi

if [ ! -e "$HOME/.config/dotfiles/software/no-flyingtoasters" ]; then
  _install_flyingtoasters() {
    cecho "Install Flying Toasters screen saver? (y/N)" $magenta
    echo "(Can also be changed to other screen savers from https://www.bryanbraun.com/after-dark-css )"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install --cask webviewscreensaver --no-quarantine
      setupnote "Flying Toasters (WebViewScreenSaver)" "- [ ] Set URL to \`https://www.bryanbraun.com/after-dark-css/all/flying-toasters.html\`\n- [ ] Set other URLs from https://www.bryanbraun.com/after-dark-css as desired"
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/software/no-flyingtoasters"
    fi
  }
  sw_install "$HOME/Library/Screen Savers/WebViewScreenSaver.saver" _install_flyingtoasters
fi

fi # $GOINTERACTIVE

echo ""
cecho "---- Safari Extensions Installation ----" $white
echo ""

sw_install /Applications/Wipr.app "mas install 1320666476" \
  "- [ ] Enable extensions\n- [ ] Hide in Safari toolbar"

sw_install "/Applications/RSS Button for Safari.app" "mas install 1437501942" \
  "- [ ] Configure for Reeder.app\n- [ ] Enable RSS Button Safari extension"

sw_install "/Applications/Save to Raindrop.io.app" "mas install 1549370672" \
  "- [ ]  Enable Save to Raindrop Safari extension"

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

sw_install "/Applications/Wayback Machine.app" "mas install 1472432422" \
  "- [ ] Enable Wayback Machine Safari extnsion (as desired)"

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

# if [ -e "$(brew --prefix)/bin/gpg" ]; then
#   if ! ls -la "$(brew --prefix)/bin/gpg" | grep -c "MacGPG" >/dev/null ; then
#     echo "GnuPG (Homebrew install; use MacGPG instead)..."
#     brew uninstall gnupg
#     REMOVED_ANYTHING=true
#   fi
# fi

if [ -e "/Applications/AccessControlKitty.app" ]; then
  echo "AccessControlKitty Xcode extension..."
  verify_smartdelete
  trash /Applications/AccessControlKitty.app
fi

if [ -e "/Applications/AirBuddy.app" ]; then
  echo "AirBuddy..."
  verify_smartdelete
  trash /Applications/AirBuddy.app
fi

if [ -e "/Applications/AltTab.app" ]; then
  echo "AltTab..."
  verify_smartdelete
  trash /Applications/AltTab.app
fi

if [ -e "/Applications/Angry IP Scanner.app" ]; then
  echo "Angry IP Scanner..."
  brew uninstall --cask angry-ip-scanner
fi

if [ -e "/Applications/Bartender 3.app" ] && [ -e "/Applications/Bartender 4.app" ]; then
  echo "Bartender 3 (replaced by Bartender 4) ..."
  verify_smartdelete
  trash "/Applications/Bartender 3.app"
fi

if [ -e "/Applications/Better.app" ]; then
  echo "Better Blocker..."
  verify_smartdelete
  trash /Applications/Better.app
fi

if [ -e "/Applications/Bunch.app" ]; then
  echo "Bunch..."
  verify_smartdelete
  trash /Applications/Bunch.app
fi

if [ -e "/Applications/Burn.app" ]; then
  echo "Burn (CD burner)..."
  verify_smartdelete
  trash /Applications/Burn.app
fi

if [ -e "/Applications/Caprine.app" ]; then
  echo "Caprine..."
  verify_smartdelete
  trash /Applications/Caprine.app
fi

if [ -e "/Applications/Cardhop.app" ]; then
  echo "Cardhop..."
  verify_smartdelete
  trash /Applications/Cardhop.app
fi

if [ -e /Applications/CARROTweather.app ]; then
  echo "CARROTweather..."
  verify_smartdelete
  trash /Applications/CARROTweather.app
fi

if [ -e /Applications/coconutBattery.app ]; then
  echo "coconutBattery..."
  set +e
  verify_smartdelete
  osascript -e "tell application \"coconutBattery\" to quit"
  trash /Applications/coconutBattery.app
  set -e
fi

if [ -e /Applications/DaisyDisk.app ]; then
  echo "DaisyDisk..."
  set +e
  verify_smartdelete
  osascript -e "tell application \"DaisyDisk\" to quit"
  trash /Applications/DaisyDisk.app
  set -e
fi

if [ -e "/Applications/Deliveries.app" ]; then
  osascript -e 'quit app "Deliveries"'
  verify_smartdelete
  trash "/Applications/Deliveries.app"
fi

if [ -e "$(brew --prefix)/bin/dog" ]; then
  echo "dog..."
  brew uninstall dog
fi

if [ -e "/Applications/Downlink.app" ]; then
  echo "Downlink..."
  verify_smartdelete
  trash /Applications/Downlink.app
fi

if [ -e /usr/local/bin/emoj ]; then
  echo "emoj..."
  npm uninstall -g emoj
fi

if [ -e "$(brew --prefix)/bin/exa" ]; then
  echo "exa..."
  brew uninstall exa
fi

if [ -e "/Applications/Fantastical.app" ]; then
  echo "Fantastical..."
  set +e
  verify_smartdelete
  osascript -e "tell application \"Fantastical\" to quit"
  trash /Applications/Fantastical.app
  set -e
fi

if [ -e "/Applications/Front and Center.app" ]; then
  echo "Front And Center..."
  verify_smartdelete
  osascript -e 'tell application "Front and Center" to quit'
  trash "/Applications/Front and Center.app"
fi

if [ -e "/Applications/Garmin Express.app" ]; then
  echo "Garmin Express..."
  verify_smartdelete
  osascript -e 'tell application "Garmin Express" to quit'
  brew uninstall --cask garmin-express || trash "/Applications/Garmin Express.app"
fi

if [ -e "/Applications/GIF Brewery 3.app" ]; then
  echo "GIF Brewery 3..."
  verify_smartdelete
  trash "/Applications/GIF Brewery 3.app"
fi

if [ -e "/Applications/Setapp/Glyphfinder.app" ]; then
  echo "Glyphfinder..."
  verify_smartdelete
  osascript -e "tell application \"Glyphfinder\" to quit"
  trash /Applications/Setapp/Glyphfinder.app
fi

if [ -e "$HOME/opt/bin/gmail-cleaner" ]; then
  echo "gmail-cleaner..."
  trash "$HOME/opt/bin/gmail-cleaner"
fi

if [ -e "$HOME/.config/gmail-cleaner-personal" ]; then
  echo "gmail-cleaner config..."
  trash "$HOME/.config/gmail-cleaner-personal"
fi

if [ -e "/Applications/Google Drive File Stream.app" ]; then
  echo "Google Drive File Stream (use CloudMounter or Google Drive instead)..."
  verify_smartdelete
  osascript -e 'tell application "Google Drive File Stream" to quit'
  brew uninstall --cask google-drive-file-stream || trash "/Applications/Google Drive File Stream.app"
fi

if [ -e "/Applications/Grasshopper.app" ]; then
  echo "Grasshopper..."
  verify_smartdelete
  trash /Applications/Grasshopper.app
fi

if [ -e "/Applications/Ice Cubes.app" ] ; then
  echo "Ice Cubes..."
  verify_smartdelete
  trash "/Applications/Ice Cubes.app"
fi

if [ -e "/Applications/Instapaper.app" ] ; then
  echo "Instapaper (it's a bad app)..."
  verify_smartdelete
  trash "/Applications/Instapaper.app"
fi

if [ -e /Applications/IPinator.app ]; then
  echo "IPinator..."
  verify_smartdelete
  trash "/Applications/IPinator.app"
fi

if [ -e "/Applications/Keybase.app" ]; then
  echo "Keybase..."
  verify_smartdelete
  brew uninstall --zap --cask keybase
fi

if [ -e /usr/local/opt/com.dzombak.remove-keybase-finder-favorite/bin/remove-keybase-finder-favorite ]; then
  echo "cdzombak/remove-keybase-finder-favorite..."
  launchctl unload "$HOME/Library/LaunchAgents/com.dzombak.remove-keybase-finder-favorite.plist"
  rm -f "$HOME/Library/LaunchAgents/com.dzombak.remove-keybase-finder-favorite.plist"
  rm -rf /usr/local/opt/com.dzombak.remove-keybase-finder-favorite
fi

if [ -e "/Applications/Living Earth Desktop.app" ]; then
  echo "Living Earth Desktop..."
  verify_smartdelete
  trash "/Applications/Living Earth Desktop.app"
fi

if [ -e "/Applications/Lunar.app" ]; then
  echo "Lunar..."
  verify_smartdelete
  set +e
  osascript -e "tell application \"Lunar\" to quit"
  set -e
  trash "/Applications/Lunar.app"
fi
rm -f "$HOME/.config/dotfiles/software/no-lunar"

if [ -e /Applications/MagicHighlighter.app ]; then
  echo "MagicHighlighter..."
  verify_smartdelete
  trash "/Applications/MagicHighlighter.app"
fi

if [ -e /Library/Mail/Bundles/MailTrackerBlocker.mailbundle ]; then
  echo "mailtrackerblocker..."
  brew uninstall mailtrackerblocker
fi

if [ -e /Applications/Mastonaut.app ]; then
  echo "Mastonaut..."
  verify_smartdelete
  trash "/Applications/Mastonaut.app"
fi

if [ -e /Applications/NepTunes.app ]; then
  echo "NepTunes..."
  verify_smartdelete
  trash "/Applications/NepTunes.app"
fi

if [ -e /Applications/Notability.app ]; then
  echo "Notability..."
  verify_smartdelete
  trash "/Applications/Notability.app"
fi

if [ -e "/Applications/OmniFocus.app" ]; then
  echo "OmniFocus..."
  verify_smartdelete
  trash /Applications/OmniFocus.app
fi

if [ -e "/Applications/Pins.app" ]; then
  echo "Pins..."
  verify_smartdelete
  trash /Applications/Pins.app
fi

if [ -e "$HOME/Library/QuickLook/QLMarkdown.qlgenerator" ]; then
  echo "QLMarkdown (use Peek.app from Mac App Store)..."
  brew uninstall --cask qlmarkdown
fi

# qrcp isn't building for me atm, and I've never really used it:
if [ -e "$(brew --prefix)/bin/qrcp" ]; then
  echo "qrcp..."
  brew uninstall gomod-qrcp
fi
if [ -e "$(brew --prefix)/Cellar/gomod-qrcp/" ]; then
  echo "qrcp (build folder)..."
  rm -rf "$(brew --prefix)/Cellar/gomod-qrcp/"
fi

if [ -e "$HOME/Library/QuickLook/QuickLookJSON.qlgenerator" ]; then
  echo "quicklook-json (use Peek.app from Mac App Store)..."
  brew uninstall --cask quicklook-json
fi

if [ -e "/Applications/Rocket.app" ]; then
  echo "Rocket..."
  verify_smartdelete
  set +e
  osascript -e "tell application \"Rocket\" to quit"
  trash "$HOME/Library/Scripts/Restart Rocket.scpt"
  set -e
  trash /Applications/Rocket.app
fi

if [ -e "/Applications/Screens Connect.app" ]; then
  echo "Screens Connect..."
  verify_smartdelete
  set +e
  osascript -e "tell application \"Screens Connect\" to quit"
  set -e
  trash "/Applications/Screens Connect.app"
fi

if [ -e "/Applications/StopTheMadness.app" ]; then
  verify_smartdelete
  echo "StopTheMadness..."
  trash "/Applications/StopTheMadness.app"
fi

if [ -e /Applications/Tadam.app ]; then
  echo "Tadam..."
  set +e
  verify_smartdelete
  osascript -e "tell application \"Tadam\" to quit"
  trash /Applications/Tadam.app
  set -e
fi

if [ -e "$(brew --prefix)/bin/task" ]; then
  echo "task ..."
  brew uninstall go-task/tap/go-task
fi

if [ -e /usr/local/bin/thingshub ]; then
  echo "ThingsHub..."
  trash /usr/local/bin/thingshub
fi

if [ -e "$HOME/Library/LaunchAgents/com.dzombak.thingshubd.plist" ]; then
  echo "thingshubd launch agent..."
  launchctl unload -w "$HOME/Library/LaunchAgents/com.dzombak.thingshubd.plist"
  trash "$HOME/Library/LaunchAgents/com.dzombak.thingshubd.plist"
fi

if [ -e /usr/local/opt/thingshubd ]; then
  echo "thingshubd..."
  trash /usr/local/opt/thingshubd
fi

if [ -e "/Applications/TIDAL.app" ]; then
  echo "TIDAL..."
  verify_smartdelete
  trash /Applications/TIDAL.app
fi

if [ -e /Applications/Tweetbot.app ]; then
  echo "Tweetbot..."
  verify_smartdelete
  trash /Applications/Tweetbot.app
fi

if [ -e "$(brew --prefix)/bin/wakeonlan" ]; then
  echo "wakeonlan..."
  brew uninstall wakeonlan
fi

if [ -e "/Applications/Vitals.app" ]; then
  echo "Vitals..."
  brew uninstall --cask vitals
  brew untap hmarr/tap
fi


if [ -e /Applications/Wavebox.app ]; then
  echo "Wavebox..."
  verify_smartdelete
  trash /Applications/Wavebox.app
fi

if [ -e /Applications/WireGuard.app ]; then
  echo "WireGuard Client..."
  verify_smartdelete
  trash /Applications/WireGuard.app
fi

if [ -e "/Applications/Magic Lasso.app" ]; then
  echo "Magic Lasso..."
  verify_smartdelete
  trash "/Applications/Magic Lasso.app"
fi

if [ -e /Applications/Hush.app ]; then
  echo "Hush..."
  verify_smartdelete
  trash /Applications/Hush.app
fi

echo ""
cecho "--- Cleanup/Tidy/Migrations ---" $white
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
  sudo rm /usr/local/bin/kubectl
fi
if file -h /opt/homebrew/bin/kubectl | grep -c "Applications/Docker.app/Contents/Resources/bin" >/dev/null; then
  echo "Removing kubectl symlink to Docker.app."
  sudo rm /opt/homebrew/bin/kubectl
fi

if $YES_INSTALL_KUBECTL; then
  sw_install "$(brew --prefix)/bin/kubectl" "brew_install kubectl"
else
  _install_kubectl() {
    echo ""
    cecho "Install kubectl? (y/N)" $magenta
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      brew install kubectl
    fi
  }
  sw_install "$(brew --prefix)/bin/kubectl" _install_kubectl
fi
echo ""

echo "Move to Homebrew packaged mdless..."
if [ -e /opt/homebrew/Cellar/gem-mdless/1.0.37 ]; then
  brew gem uninstall mdless
  brew install mdless
fi
if gem list | grep -c mdless >/dev/null; then
  sudo gem uninstall mdless
  brew install mdless
fi

echo "Cleaning up gems installed without brew-gem ..."
if gem list | grep -c sqlint >/dev/null; then
  sudo gem uninstall sqlint
fi
if gem list | grep -c pg_query >/dev/null; then
  sudo gem uninstall pg_query
fi

echo ""
cecho "--- Optional installs that have failed previously ---" $white
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
cecho "✔ Done!" $green
