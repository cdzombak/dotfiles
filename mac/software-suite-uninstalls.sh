#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS software uninstalls because not on macOS"
  exit 2
fi

echo ""
cecho "--- Removing software I no longer use ---" $white
echo ""

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

if [ -e "/Applications/Bartender 5.app" ]; then
  echo "Bartender (5)..."
  verify_smartdelete
  killall "Bartender 5"
  trash "/Applications/Bartender 5.app"
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

if [ -e "/Applications/Elgato Control Center.app" ]; then
  set +e
  osascript -e 'quit app "Elgato Control Center"'
  echo "Elgato Control Center..."
  verify_smartdelete
  trash "/Applications/Elgato Control Center.app"
  set -e
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

if [ -e "$(brew --prefix)/opt/nvm" ] ; then
  echo "nvm ..."
  brew uninstall nvm
  trash "$HOME/.nvm"
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

if [ -e "$(brew --prefix)/bin/pyenv" ] ; then
  echo "pyenv ..."
  brew uninstall pyenv
  trash "$HOME/.pyenv"
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

if [ -e "/Applications/Screens.app" ]; then
  echo "Screens 4..."
  verify_smartdelete
  trash "/Applications/Screens.app"
fi

if [ -e "/Applications/SensibleSideButtons.app" ]; then
  echo "SensibleSideButtons..."
  set +e
  osascript -e "tell application \"SensibleSideButtons\" to quit"
  set -e
  verify_smartdelete
  trash /Applications/SensibleSideButtons.app
fi

if [ -e "/Applications/Setapp/Screens.app" ]; then
  echo "Screens 4..."
  verify_smartdelete
  trash "/Applications/Setapp/Screens.app"
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

if [ -e "/Applications/Tag Editor.app" ]; then
  echo "Tag Editor..."
  verify_smartdelete
  brew uninstall --cask tageditor
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

if [ -e /Applications/IVPN.app ]; then
  echo "IVPN..."
  verify_smartdelete
  trash /Applications/IVPN.app
fi

if [ -e "$(brew --prefix)/bin/mysides" ] ; then
  echo "mysides ..."
  brew uninstall mysides
fi

if [ -e "$(brew --prefix)/bin/nativefier" ] ; then
  echo "nativefier ..."
  brew uninstall nativefier
fi
