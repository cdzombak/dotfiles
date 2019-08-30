#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source ./lib/cecho

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS setup because not on macOS"
  exit 2
fi

# inspired by:
#   brandonb927's osx-for-hackers.sh: https://gist.github.com/brandonb927/3195465
#   andrewsardone's dotfiles: https://github.com/andrewsardone/dotfiles/blob/master/osx/osx-defaults

# app keyboard shortcuts:
#   read via defaults read com.BUNDLE_ID NSUserKeyEquivalents
#   meta-keys: @ for Command, $ for Shift, ~ for Alt and ^ for Ctrl
#   via http://hints.macworld.com/article.php?story=20131123074223584

# Set continue to false by default
CONTINUE=false

echo ""
cecho "###############################################" $red
cecho "#        DO NOT RUN THIS SCRIPT BLINDLY       #" $red
cecho "#         YOU'LL PROBABLY REGRET IT...        #" $red
cecho "#                                             #" $red
cecho "#              READ IT THOROUGHLY             #" $red
cecho "#         AND EDIT TO SUIT YOUR NEEDS         #" $red
cecho "###############################################" $red
echo ""

echo ""
cecho "Have you read through the script you're about to run and " $red
cecho "understood that it will make changes to your computer? (y/N)" $red
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  cecho "Please go read the script, it only takes a few minutes" $red
  exit 1
fi

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX
###############################################################################

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

###############################################################################
# General Power and Performance modifications
###############################################################################

# echo ""
# cecho "Disable the menubar transparency? (y/N)" $magenta
# read -r response
# if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
#   defaults write com.apple.universalaccess reduceTransparency -bool true
# fi

# echo ""
# echo "Speeding up wake from sleep to 24 hours from an hour"
# # http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
# sudo pmset -a standbydelay 86400

################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
################################################################################

# echo ""
# echo "Enabling full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)"
# defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

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
fi

echo ""
echo "Show status bar in Finder by default"
# read -r response
# if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
defaults write com.apple.finder ShowStatusBar -bool true
# fi

echo ""
echo "Avoid creation of .DS_Store files on network volumes"
# read -r response
# if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# fi

echo ""
echo ""
cecho "Hide all desktop icons? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.finder CreateDesktop -bool false
fi

echo ""
echo "Allowing text selection in Quick Look/Preview in Finder by default"
defaults write com.apple.finder QLEnableTextSelection -bool true

# echo ""
# echo "Show item info near icons on the desktop and in other icon views? (y/n)"
# read -r response
# if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
#   /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
#   /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
#   /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# fi

# echo ""
# echo "Show item info to the right of the icons on the desktop? (y/n)"
# read -r response
# if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
#   /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
# fi

# Set: Entry, ":FK_StandardViewSettings:IconViewSettings:arrangeBy", Does Not Exist
# happens on fresh installs
echo ""
cecho "Enable snap-to-grid for icons on the desktop and in other icon views? (y/N)" $magenta
cecho "SELECT NO ON FRESH INSTALLS" $red
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
fi

# echo ""
# echo "Disable the “Are you sure you want to open this application?" dialog
# defaults write com.apple.LaunchServices LSQuarantine -bool false

# echo ""
# echo "Do not hide the Library folder w/in Finder"
# chflags nohidden ~/Library/

echo ""
echo "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo ""
echo "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo ""
echo "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

###############################################################################
# Dock & Mission Control
###############################################################################

echo ""
echo "Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.2
defaults write com.apple.dock "expose-group-by-app" -bool true

echo ""
cecho "Set Dock to auto-hide and minimize the auto-hiding delay? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0.1
  defaults write com.apple.dock autohide-time-modifier -float 0.5
fi

echo ""
echo "Pinning Dock to the right side"
defaults write com.apple.Dock orientation -string right

echo ""
echo "Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo ""
echo "Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

###############################################################################
# Chrome, Safari, & WebKit
###############################################################################

# echo ""
# echo "Privacy: Don’t send search queries to Apple"
# defaults write com.apple.Safari UniversalSearchEnabled -bool false
# defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo ""
echo "Enabling Safari's debug & development features"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
echo "Disable preloading top search hit in Safari"
defaults write com.apple.Safari PreloadTopHit -bool false

echo ""
echo "Adding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# echo ""
# echo "Show Safari's status bar."
# defaults write com.apple.Safari ShowStatusBar -bool true

echo ""
echo "Prevent Safari from opening 'safe' files by default"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# echo ""
# echo "Using the system-native print preview dialog in Chrome"
# defaults write com.google.Chrome DisablePrintPreview -bool true
# defaults write com.google.Chrome.canary DisablePrintPreview -bool true

echo ""
echo "Disable annoying Chrome swipe-to-navigate gesture"
defaults write com.google.Chrome.plist AppleEnableSwipeNavigateWithScrolls -bool FALSE

###############################################################################
# Mail
###############################################################################

echo ""
echo "Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo ""
echo "Add the keyboard shortcut ⌘ + ⇧ + K to clear flag in Mail.app"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Clear Flag" "@\$k"

###############################################################################
# IntelliJ
###############################################################################

echo ""
echo "Disable IntelliJ IDEA key repeat fix"
defaults write com.jetbrains.intellij.ce ApplePressAndHoldEnabled -bool false

###############################################################################
# Shell & Terminal
###############################################################################

echo ""
echo "Set zsh as default shell"
chsh -s $(which zsh)

echo ""
echo "Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

###############################################################################
# Xcode
###############################################################################

# See http://merowing.info/2015/12/little-things-that-can-make-your-life-easier-in-2016/

echo ""
echo "In Xcode, show how long it takes to build your project"
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

echo ""
echo "In Xcode, enable faster build times by leveraging multi-core CPU"
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks `sysctl -n hw.ncpu`

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
echo "Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

echo ""
echo "Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Tweetbot
###############################################################################

# https://twitter.com/dancounsell/status/667011332894535682
echo ""
echo "Avoid t.co in Tweetbot-Mac"
defaults write com.tapbots.TweetbotMac OpenURLsDirectly YES

###############################################################################
# Messages
###############################################################################

# echo ""
# echo "Messages.app keyboard shortcuts"
# defaults write com.apple.iChat NSUserKeyEquivalents -dict-add "Delete Conversation" "@~^c"
# defaults write com.apple.iChat NSUserKeyEquivalents -dict-add "Delete Conversation\\U2026" "@^\$w"

###############################################################################
# Kill affected applications
###############################################################################

echo ""
cecho "Done!" $cyan
echo ""
cecho "################################################################################" $white
echo ""
echo "Note that some of these changes require a logout/restart to take effect."
cecho "Please restart the system." $red
echo ""
