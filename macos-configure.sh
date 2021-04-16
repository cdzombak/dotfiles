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

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

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
echo "Expand the save and print panels by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo ""
echo "Speed up sheet show & hide animations"
defaults write NSGlobalDomain NSWindowResizeTime .1

echo ""
echo "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo ""
echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo ""
echo "Enable automatic software update checks"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

echo ""
echo "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo ""
echo "Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo ""
echo "Install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

echo ""
echo "Save screenshots as PNG, with a lowercase file extension"
defaults write com.apple.screencapture type png

echo ""
echo "Write screenshots to disk right away, without floating thumbnail"
defaults write "com.apple.screencapture" "show-thumbnail" '0'

echo ""
echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo ""
echo "Don't automatically hide the menu bar"
defaults write -g "_HIHideMenuBar" '0'

echo ""
echo "Customize menu bar clock appearance"
defaults write "com.apple.menuextra.clock" "ShowDayOfWeek" '0'
defaults write "com.apple.menuextra.clock" "ShowDayOfMonth" '0'
defaults write "com.apple.menuextra.clock" "DateFormat" '"H:mm"'
defaults write "com.apple.menuextra.clock" "Show24Hour" '1'

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
# Follow the keyboard focus while zoomed in
# defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

echo ""
echo "Show scrollbars only while scrolling"
defaults write -g AppleShowScrollBars -string WhenScrolling

echo ""
echo "Click in scroll bar to jump to the spot that's clicked"
defaults write -g "AppleScrollerPagingBehavior" '1'

echo ""
echo "Disable automatic capitalization as it’s annoying when typing code"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo ""
echo "Disable automatic period substitution as it’s annoying when typing code"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo ""
echo "Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo ""
echo "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

###############################################################################
# Screen
###############################################################################

# echo ""
# echo "Enabling subpixel font rendering on non-Apple LCDs"
# defaults write NSGlobalDomain AppleFontSmoothing -int 2

# https://tonsky.me/blog/monitors/ convinced me to try this:
echo ""
echo "Disabling subpixel font smoothing"
defaults write NSGlobalDomain AppleFontSmoothing -int 0

###############################################################################
# Security
###############################################################################

echo ""
cecho "Enable the firewall? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
fi

###############################################################################
# Finder
###############################################################################

echo ""
echo "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo ""
cecho "Show icons for external hard drives and removable media on the desktop? (y/N)" $magenta
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
else
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
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

echo ""
echo "Expand File Info panes: General, Open With, Sharing & Permissions"
# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

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
# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

echo ""
echo "Disable Dock magnification"
defaults write "com.apple.dock" "magnification" '0'
# Disable Dock magnification even when holding down Ctrl-Shift
defaults write com.apple.dock largesize -int 1

echo ""
echo "Set Dock size"
defaults write "com.apple.dock" "tilesize" '46'

killall Dock

###############################################################################
# Chrome, Safari, & WebKit
###############################################################################

echo ""
echo "Enable Safari's debug & development features"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write "com.apple.Safari" "WebKitPreferences.developerExtrasEnabled" '1'
defaults write "com.apple.Safari" "IncludeDevelopMenu" '1'
defaults write "com.apple.Safari.SandboxBroker" "ShowDevelopMenu" '1'

# Add a context menu item for showing the Web Inspector in web views
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

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
echo "Show the full URL in the address bar"
# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo ""
echo "Prevent Safari from opening 'safe' files by default"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo ""
echo "Set Safari’s home page to about:blank"
# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

echo ""
echo "Warn about fraudulent websites"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

echo ""
echo "Disable Java"
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

echo ""
echo "Enable Do Not Track"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo ""
echo "Update extensions automatically"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

echo ""
echo "Disable tab switching w/command-#"
defaults write "com.apple.Safari" "Command1Through9SwitchesTabs" '0'

###############################################################################
# Mail
###############################################################################

echo ""
echo "[Mail.app] Set email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>'"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo ""
echo "Disable new message sound"
defaults write "com.apple.mail" "NewMessagesSoundName" '""'

echo ""
echo "Check for new messages frequency: Automatic"
defaults write "com.apple.mail" "AutoFetch" '1'
defaults write "com.apple.mail" "PollTime" '"-1"'

echo ""
echo "Customize message fonts & sizes"
defaults write "com.apple.mail" "NSFontSize" '15'
defaults write "com.apple.mail" "NSFixedPitchFont" '"MesloLGM-Regular"'
defaults write "com.apple.mail" "NSFixedPitchFontSize" '14'

echo ""
echo "Show all member addresses when sending to a group"
defaults write "com.apple.mail-shared" "ExpandPrivateAliases" '1'

###############################################################################
# iTunes
###############################################################################

if [ ! -e "$HOME/.local/dotfiles/no-itunes-config" ]; then
  echo ""
  cecho "Configure iTunes for a 'client' computer (eg. not the master on home Mac Mini server)? (y/N)" $magenta
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo ""
    echo "[iTunes] Delete downloaded movies/shows after watching"
    defaults write com.apple.iTunes automaticallyDeleteVideoAssetsAfterWatching -bool true

    echo ""
    echo "[iTunes] Disable features I don't use, including Apple Music"
    defaults write com.apple.iTunes disableAppleMusic -bool true
    defaults write com.apple.iTunes disableMusicSocial -bool true
    defaults write com.apple.iTunes disableMusicStore -bool false
    defaults write com.apple.iTunes disablePodcasts -bool true
    defaults write com.apple.iTunes disableRadio -bool false
    defaults write com.apple.iTunes disableShareLibraryInfo -bool false
    defaults write com.apple.iTunes disableSharedMusic -bool false
    defaults write com.apple.iTunes dontAutomaticallySyncIPods -bool true
  fi
  echo "Won't ask about this again the next time this script runs."
  touch "$HOME/.local/dotfiles/no-itunes-config"
fi

###############################################################################
# Shell & Terminal
###############################################################################

if [[ $SHELL != *"/zsh" ]]; then
  echo ""
  echo "Set zsh as default shell"
  chsh -s "$(command -v zsh)"
else
  echo ""
  echo "zsh is already the current shell"
fi

echo ""
echo "Use UTF-8 only in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

echo ""
echo "Set 'Often' update frequency in Activity Monitor"
defaults write "com.apple.ActivityMonitor" "UpdatePeriod" '2'

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
echo "Messages.app text size"
defaults write com.apple.iChat TextSize 7

echo ""
echo "Photos.app Keyboard shortcut: ⌥T to Adjust Date & Time"
# shellcheck disable=SC2016
defaults write com.apple.Photos NSUserKeyEquivalents '{
    "Adjust Date and Time\U2026" = "~t";
}'

echo ""
cecho "✔ Done." $green
echo ""
cecho "macOS configuration complete." $white
cecho "Note that some of these changes require a logout/restart to take effect." $white
cecho "Please restart the system." $red
