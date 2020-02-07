#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source ./lib/cecho

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS configuration because not on macOS"
  exit 2
fi

# inspired by:
#   brandonb927's osx-for-hackers.sh: https://gist.github.com/brandonb927/3195465
#   andrewsardone's dotfiles: https://github.com/andrewsardone/dotfiles/blob/master/osx/osx-defaults

cecho "----                     ----" $white
cecho "---- macOS Configuration ----" $white
cecho "----                     ----" $white
echo ""

# Set continue to false by default
CONTINUE=false

cecho "###############################################" $red
cecho "#        DO NOT RUN THIS SCRIPT BLINDLY       #" $red
cecho "#                                             #" $red
cecho "#              READ IT THOROUGHLY             #" $red
cecho "#         AND EDIT TO SUIT YOUR NEEDS         #" $red
cecho "###############################################" $red
echo ""

cecho "Have you read through the script you're about to run and " $red
cecho "understood the changes it will make to your computer? (y/N)" $red
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  exit 1
fi

echo -e "This script will use ${magenta}sudo${_reset}; enter your password to authenticate if prompted."
# Ask for the administrator password upfront and run a keep-alive to update
# existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX
###############################################################################

if [ ! -e "$HOME/.local/dotfiles/no-set-computer-name" ]; then
  echo ""
  cecho "Would you like to set your computer name (as done via System Preferences >> Sharing)?  (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "What would you like it to be? [no backslashes]"
    read COMPUTER_NAME
    sudo scutil --set ComputerName "$COMPUTER_NAME"
    sudo scutil --set HostName "$COMPUTER_NAME"
    sudo scutil --set LocalHostName "$COMPUTER_NAME"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"
  else
    touch "$HOME/.local/dotfiles/no-set-computer-name"
    echo "Won't ask again the next time this script runs."
  fi
fi

echo ""
echo "Expanding the save and print panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo ""
echo "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo ""
echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo ""
echo "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo ""
echo "Save screenshots with a lowercase file extension"
defaults write com.apple.screencapture type png

################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
################################################################################

echo ""
echo "Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Use scroll gesture with the Ctrl (^) modifier key to zoom
# defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
# defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

###############################################################################
# Screen
###############################################################################

echo ""
echo "Enabling subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

###############################################################################
# Finder
###############################################################################

echo ""
echo "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo ""
cecho "Show icons for hard drives, servers, and removable media on the desktop? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
else
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
fi

echo ""
echo "[Finder] Show status bar in Finder by default"
defaults write com.apple.finder ShowStatusBar -bool true

echo ""
echo "Avoid creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo ""
echo ""
cecho "Hide all desktop icons? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.finder CreateDesktop -bool false
else
  defaults write com.apple.finder CreateDesktop -bool true
fi

echo ""
echo "[Finder] Allow text selection in Quick Look/Preview in Finder by default"
defaults write com.apple.finder QLEnableTextSelection -bool true

# The following error happens on fresh installs:
# Set: Entry, ":FK_StandardViewSettings:IconViewSettings:arrangeBy", Does Not Exist
echo ""
cecho "Enable snap-to-grid for icons on the desktop and in other icon views? (y/N)" $magenta
cecho "nb. SELECT NO ON FRESH INSTALLS to avoid exiting with error." $red
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
fi

echo ""
echo "[Finder] Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo ""
echo "[Finder] Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo ""
echo "[Finder] When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo ""
echo "[Finder] Open new tabs, not windows, by default"
defaults write com.apple.finder FinderSpawnTab -bool true

echo ""
echo "[Finder] Remove items in Trash after 30 days"
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

echo ""
echo "[Finder] New windows open to home directory"
defaults write com.apple.finder NewWindowTarget "PfHm"
defaults write com.apple.finder NewWindowTargetPath "file:///Users/$(whoami)/"

echo ""
echo "[Finder] Warn when emptying trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool true

###############################################################################
# Dock & Mission Control
###############################################################################

echo ""
echo "Speed up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.2
defaults write com.apple.dock "expose-group-by-app" -bool true

if [ ! -e "$HOME/.local/dotfiles/no-ask-dock-auto-hide-delay" ]; then
  echo ""
  cecho "Minimize the Dock auto-hiding delay? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.dock autohide-delay -float 0.1
    defaults write com.apple.dock autohide-time-modifier -float 0.5
  fi
  echo "Won't ask about this again the next time this script runs."
  touch "$HOME/.local/dotfiles/no-ask-dock-auto-hide-delay"
fi

echo ""
cecho "Auto-hide the Dock? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.dock autohide -bool true
else
  defaults write com.apple.dock autohide -bool false
fi

echo ""
echo "Pin Dock to the right side"
defaults write com.apple.Dock orientation -string right

echo ""
echo "Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo ""
echo "Hide recent applications in Dock"
defaults write com.apple.dock show-recents -bool false

# this fades out currently-hidden apps, but I'm not sure yet if I like it
# defaults write com.apple.Dock showhidden -bool yes

echo ""
echo "Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

###############################################################################
# Chrome, Safari, & WebKit
###############################################################################

echo ""
echo "Enable Safari's debug & development features"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
echo "Disable preloading top search hit in Safari"
defaults write com.apple.Safari PreloadTopHit -bool false

echo ""
echo "Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo ""
echo "Show Safari's status bar."
defaults write com.apple.Safari ShowStatusBar -bool true

echo ""
echo "Prevent Safari from opening 'safe' files by default"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

###############################################################################
# Mail
###############################################################################

echo ""
echo "[Mail.app] Set email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>'"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

###############################################################################
# Shell & Terminal
###############################################################################

echo ""
echo "Set zsh as default shell"
chsh -s "$(command -v zsh)"

echo ""
echo "Use UTF-8 only in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

###############################################################################
# Time Machine
###############################################################################

echo ""
echo "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# echo "Disable local Time Machine backups"
# hash tmutil &> /dev/null && sudo tmutil disablelocal

echo ""
echo "Disable Time Machine"
hash tmutil &> /dev/null && sudo tmutil disable

###############################################################################
# TextEdit
###############################################################################

echo ""
echo "[TextEdit] Use plain text mode for new documents"
defaults write com.apple.TextEdit RichText -int 0

echo ""
echo "[TextEdit] Open and save files as UTF-8"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Keyboard Shortcuts
###############################################################################

# App keyboard shortcuts:
#   read via `defaults read com.BUNDLE_ID NSUserKeyEquivalents`, or -g for the global domain
#   meta-keys: @ for Command, $ for Shift, ~ for Alt and ^ for Ctrl
#   via http://hints.macworld.com/article.php?story=20131123074223584

echo ""
echo "Global Keyboard shortcuts: ⌘P to Save PDF; ^⇧⌘V to Paste and Match Style"
# shellcheck disable=SC2016
defaults write -g NSUserKeyEquivalents '{
  "Paste and Match Style" = "@^$v";
  "Save as PDF…" = "@p";
}'

echo ""
echo "Finder.app Keyboard shortcut: ⇧⌘O to Documents"
# shellcheck disable=SC2016
defaults write com.apple.finder NSUserKeyEquivalents '{
  Documents = "@$o";
}'

echo ""
echo "Mail.app Keyboard shortcut: ⇧⌘K to Clear Flag"
# shellcheck disable=SC2016
defaults write com.apple.mail NSUserKeyEquivalents '{
  "Clear Flag" = "@$k";
}'

echo ""
echo "Messages.app Keyboard shortcut: ⇧⌘W to Delete Conversation"
# shellcheck disable=SC2016
defaults write com.apple.iChat NSUserKeyEquivalents '{
  "Delete Conversation\U2026" = "@$w";
}'

echo ""
cecho "✔ Done." $green
echo ""
cecho "macOS configuration complete." $white
cecho "Note that some of these changes require a logout/restart to take effect." $white
cecho "Please restart the system." $red
