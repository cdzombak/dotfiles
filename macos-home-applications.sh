#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source ./lib/cecho
source ./lib/sw_install # includes setupnote function

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS ~/Applications setup because not on macOS"
  exit 2
fi

echo ""
cecho "--- ~/Applications Folders (for Dock) ---" $white
echo ""

if [ ! -d "$HOME/Applications/Dev Tools" ]; then
  setupnote "Dock/Dev Tools" "- [ ] Add Dev Tools to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Dev Tools"
if ! fileicon test "$HOME/Applications/Dev Tools"; then
  fileicon set "$HOME/Applications/Dev Tools" "./macOS Configs/Dock Icons/Dev Tools.png"
fi

if [ -e "/Applications/Dash.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Dash" ]; then
  ln -s "/Applications/Dash.app" "$HOME/Applications/Dev Tools/Dash"
fi
if [ -e "/Applications/iTerm.app" ] && [ ! -e "$HOME/Applications/Dev Tools/iTerm" ]; then
  ln -s "/Applications/iTerm.app" "$HOME/Applications/Dev Tools/iTerm"
fi
if [ -e "/Applications/Sublime Text.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Sublime Text" ]; then
  ln -s "/Applications/Sublime Text.app" "$HOME/Applications/Dev Tools/Sublime Text"
fi
if [ -e "$HOME/Applications/JetBrains Toolbox/GoLand.app" ] && [ ! -e "$HOME/Applications/Dev Tools/GoLand" ]; then
  ln -s "$HOME/Applications/JetBrains Toolbox/GoLand.app" "$HOME/Applications/Dev Tools/GoLand"
fi
if [ -e "$HOME/Applications/JetBrains Toolbox/PyCharm Professional Edition.app" ] && [ ! -e "$HOME/Applications/Dev Tools/PyCharm" ]; then
  ln -s "$HOME/Applications/JetBrains Toolbox/PyCharm Professional Edition.app" "$HOME/Applications/Dev Tools/PyCharm"
fi
if [ -e "$HOME/Applications/JetBrains Toolbox/WebStorm.app" ] && [ ! -e "$HOME/Applications/Dev Tools/WebStorm" ]; then
  ln -s "$HOME/Applications/JetBrains Toolbox/WebStorm.app" "$HOME/Applications/Dev Tools/WebStorm"
fi
if [ -e "$HOME/Applications/Clock.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Clock" ]; then
  ln -s "$HOME/Applications/Clock.app" "$HOME/Applications/Dev Tools/Clock"
fi
if [ -e "$HOME/Applications/JSON Viewer.app" ] && [ ! -e "$HOME/Applications/Dev Tools/JSON Viewer" ]; then
  ln -s "$HOME/Applications/JSON Viewer.app" "$HOME/Applications/Dev Tools/JSON Viewer"
fi

if [ ! -d "$HOME/Applications/Hobby Tools" ]; then
  setupnote "Dock/Hobby Tools" "- [ ] Add Hobby Tools to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Hobby Tools"
if ! fileicon test "$HOME/Applications/Hobby Tools"; then
  fileicon set "$HOME/Applications/Hobby Tools" "./macOS Configs/Dock Icons/Hobby Tools.png"
fi

if [ -e "/Applications/Ultimaker-Cura.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Cura" ]; then
  ln -s "/Applications/Ultimaker-Cura.app" "$HOME/Applications/Hobby Tools/Cura"
fi
if [ -e "$HOME/Applications/Autodesk Fusion 360.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Fusion 360" ]; then
  ln -s "$HOME/Applications/Autodesk Fusion 360.app" "$HOME/Applications/Hobby Tools/Fusion 360"
fi

if [ ! -d "$HOME/Applications/Media" ]; then
  setupnote "Dock/Media" "- [ ] Add Media to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Media"
if ! fileicon test "$HOME/Applications/Media"; then
  fileicon set "$HOME/Applications/Media" "./macOS Configs/Dock Icons/Media.png"
fi

if [ -e "/Applications/calibre.app" ] && [ ! -e "$HOME/Applications/Media/Calibre" ]; then
  ln -s "/Applications/calibre.app" "$HOME/Applications/Media/Calibre"
fi
if [ -e "/Applications/Doppler.app" ] && [ ! -e "$HOME/Applications/Media/Doppler" ]; then
  ln -s "/Applications/Doppler.app" "$HOME/Applications/Media/Doppler"
fi
if [ -e "/Applications/Doppler Transfer.app" ] && [ ! -e "$HOME/Applications/Media/Doppler Transfer" ]; then
  ln -s "/Applications/Doppler Transfer.app" "$HOME/Applications/Media/Doppler Transfer"
fi
if [ -e "/Applications/Infuse.app" ] && [ ! -e "$HOME/Applications/Media/Infuse" ]; then
  ln -s "/Applications/Infuse.app" "$HOME/Applications/Media/Infuse"
fi
if [[ -L "$HOME/Applications/Media/Lofi Cafe" ]] && [[ ! -e "$HOME/Applications/Media/Lofi Cafe" ]];then
  rm "$HOME/Applications/Media/Lofi Cafe"
fi
if [ -e "/Applications/Lofi Cafe.app" ] && [ ! -e "$HOME/Applications/Media/Lofi Cafe" ]; then
  ln -s "/Applications/Lofi Cafe.app" "$HOME/Applications/Media/Lofi Cafe"
elif [ -e "$HOME/Applications/Lofi Cafe.app" ] && [ ! -e "$HOME/Applications/Media/Lofi Cafe" ]; then
  ln -s "$HOME/Applications/Lofi Cafe.app" "$HOME/Applications/Media/Lofi Cafe"
fi
if [ -e "/Applications/Plex.app" ] && [ ! -e "$HOME/Applications/Media/Plex" ]; then
  ln -s "/Applications/Plex.app" "$HOME/Applications/Media/Plex"
fi
if [ -e "/Applications/Plexamp.app" ] && [ ! -e "$HOME/Applications/Media/Plexamp" ]; then
  ln -s "/Applications/Plexamp.app" "$HOME/Applications/Media/Plexamp"
fi
if [ -e "/Applications/Spotify.app" ] && [ ! -e "$HOME/Applications/Media/Spotify" ]; then
  ln -s "/Applications/Spotify.app" "$HOME/Applications/Media/Spotify"
fi
if [ -e "/Applications/Sonos.app" ] && [ ! -e "$HOME/Applications/Media/Sonos" ]; then
  ln -s "/Applications/Sonos.app" "$HOME/Applications/Media/Sonos"
fi
if [ -e "$HOME/Applications/Transmission Remote.app" ] && [ ! -e "$HOME/Applications/Media/Transmission" ]; then
  ln -s "$HOME/Applications/Transmission Remote.app" "$HOME/Applications/Media/Transmission"
fi

if [ ! -d "$HOME/Applications/Photo Tools" ]; then
  setupnote "Dock/Photo Tools" "- [ ] Add Photo Tools to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Photo Tools"
if ! fileicon test "$HOME/Applications/Photo Tools"; then
  fileicon set "$HOME/Applications/Photo Tools" "./macOS Configs/Dock Icons/Photo Tools.png"
fi

if [ -e "/Applications/Acorn.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Acorn" ]; then
  ln -s "/Applications/Acorn.app" "$HOME/Applications/Photo Tools/Acorn"
fi
if [ -e "/Applications/Affinity Photo 2.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Affinity Photo" ]; then
  ln -s "/Applications/Affinity Photo 2.app" "$HOME/Applications/Photo Tools/Affinity Photo"
fi
if [ -e "/Applications/DXOPhotoLab6.app" ] && [ ! -e "$HOME/Applications/Photo Tools/DXO PhotoLab" ]; then
  ln -s "/Applications/DXOPhotoLab6.app" "$HOME/Applications/Photo Tools/DXO PhotoLab"
fi
if [ -e "/Applications/DxO FilmPack 6.app" ] && [ ! -e "$HOME/Applications/Photo Tools/DxO FilmPack" ]; then
  ln -s "/Applications/DxO FilmPack 6.app" "$HOME/Applications/Photo Tools/DxO FilmPack"
fi
if [ -e "/Applications/Fileloupe.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Fileloupe" ]; then
  ln -s "/Applications/Fileloupe.app" "$HOME/Applications/Photo Tools/Fileloupe"
fi
if [ -e "/Applications/PhotoSweeper X.app" ] && [ ! -e "$HOME/Applications/Photo Tools/PhotoSweeper X" ]; then
  ln -s "/Applications/PhotoSweeper X.app" "$HOME/Applications/Photo Tools/PhotoSweeper X"
fi
if [ -e "/System/Applications/Photos.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Photos" ]; then
  ln -s "/System/Applications/Photos.app" "$HOME/Applications/Photo Tools/Photos"
fi
if [ -e "/Applications/Pixelmator Pro.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Pixelmator Pro" ]; then
  ln -s "/Applications/Pixelmator Pro.app" "$HOME/Applications/Photo Tools/Pixelmator Pro"
fi
if [ -e "/System/Applications/Preview.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Preview" ]; then
  ln -s "/System/Applications/Preview.app" "$HOME/Applications/Photo Tools/Preview"
fi
if [ -e "/Applications/RAW Power.app" ] && [ ! -e "$HOME/Applications/Photo Tools/RAW Power" ]; then
  ln -s "/Applications/RAW Power.app" "$HOME/Applications/Photo Tools/RAW Power"
fi
if [ -e "/Applications/Topaz Sharpen AI.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Topaz Sharpen AI" ]; then
  ln -s "/Applications/Topaz Sharpen AI.app" "$HOME/Applications/Photo Tools/Topaz Sharpen AI"
fi
if [ -e "/Applications/Setapp/Squash.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Squash" ]; then
  ln -s "/Applications/Setapp/Squash.app" "$HOME/Applications/Photo Tools/Squash"
fi

if [ ! -d "$HOME/Applications/Social Media" ]; then
  setupnote "Dock/Social Media" "- [ ] Add Social Media to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Social Media"
if ! fileicon test "$HOME/Applications/Social Media"; then
  fileicon set "$HOME/Applications/Social Media" "./macOS Configs/Dock Icons/Social Media.png"
fi

if [ -e "/Applications/Caprine.app" ] && [ ! -e "$HOME/Applications/Social Media/Caprine" ]; then
  ln -s "/Applications/Caprine.app" "$HOME/Applications/Social Media/Caprine"
fi
if [ -e "/Applications/Discord.app" ] && [ ! -e "$HOME/Applications/Social Media/Discord" ]; then
  ln -s "/Applications/Discord.app" "$HOME/Applications/Social Media/Discord"
fi
if [ -e "/Applications/Setapp/Grids.app" ] && [ ! -e "$HOME/Applications/Social Media/Grids" ]; then
  ln -s "/Applications/Setapp/Grids.app" "$HOME/Applications/Social Media/Grids"
fi
if [ -e "/Applications/Ice Cubes.app" ] && [ ! -e "$HOME/Applications/Social Media/Ice Cubes" ]; then
  ln -s "/Applications/Ice Cubes.app" "$HOME/Applications/Social Media/Ice Cubes"
fi
if [ -e "/Applications/Mastonaut.app" ] && [ ! -e "$HOME/Applications/Social Media/Mastonaut" ]; then
  ln -s "/Applications/Mastonaut.app" "$HOME/Applications/Social Media/Mastonaut"
fi
if [ -e "/Applications/Slack.app" ] && [ ! -e "$HOME/Applications/Social Media/Slack" ]; then
  ln -s "/Applications/Slack.app" "$HOME/Applications/Social Media/Slack"
fi

if [ ! -d "$HOME/Applications/System Tools" ]; then
  setupnote "Dock/System Tools" "- [ ] Add System Tools to Dock, if desired"
fi
mkdir -p "$HOME/Applications/System Tools"
if ! fileicon test "$HOME/Applications/System Tools"; then
  fileicon set "$HOME/Applications/System Tools" "./macOS Configs/Dock Icons/System Tools.png"
fi

if [ -e "/Applications/LaunchControl.app" ] && [ ! -e "$HOME/Applications/System Tools/LaunchControl" ]; then
  ln -s "/Applications/LaunchControl.app" "$HOME/Applications/System Tools/LaunchControl"
fi
if [ -e "/System/Applications/App Store.app" ] && [ ! -e "$HOME/Applications/System Tools/App Store" ]; then
  ln -s "/System/Applications/App Store.app" "$HOME/Applications/System Tools/App Store"
fi
if [ -e "/Applications/Sloth.app" ] && [ ! -e "$HOME/Applications/System Tools/Sloth" ]; then
  ln -s "/Applications/Sloth.app" "$HOME/Applications/System Tools/Sloth"
fi
if [ -e "/Applications/Setapp/Screens.app" ] && [ ! -e "$HOME/Applications/System Tools/Screens" ]; then
  ln -s "/Applications/Setapp/Screens.app" "$HOME/Applications/System Tools/Screens"
fi
if [ -e "/Applications/Transmit.app" ] && [ ! -e "$HOME/Applications/System Tools/Transmit" ]; then
  ln -s "/Applications/Transmit.app" "$HOME/Applications/System Tools/Transmit"
fi
if [ -e "/Applications/iTerm.app" ] && [ ! -e "$HOME/Applications/System Tools/iTerm" ]; then
  ln -s "/Applications/iTerm.app" "$HOME/Applications/System Tools/iTerm"
fi
if [ -e "/System/Applications/Shortcuts.app" ] && [ ! -e "$HOME/Applications/System Tools/Shortcuts" ]; then
  ln -s "/System/Applications/Shortcuts.app" "$HOME/Applications/System Tools/Shortcuts"
fi
if [ -e "/System/Applications/System Settings.app" ] && [ ! -e "$HOME/Applications/System Tools/System Settings" ]; then
  ln -s "/System/Applications/System Settings.app" "$HOME/Applications/System Tools/System Settings"
fi

cecho "✔ Done." $green
