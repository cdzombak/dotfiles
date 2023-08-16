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
if [ -e "/Applications/Fork.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Fork" ]; then
  ln -s "/Applications/Fork.app" "$HOME/Applications/Dev Tools/Fork"
fi
if [ -e "/Applications/iTerm.app" ] && [ ! -e "$HOME/Applications/Dev Tools/iTerm" ]; then
  ln -s "/Applications/iTerm.app" "$HOME/Applications/Dev Tools/iTerm"
fi
if [ -e "/Applications/Kaleidoscope.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Kaleidoscope" ]; then
  ln -s "/Applications/Kaleidoscope.app" "$HOME/Applications/Dev Tools/Kaleidoscope"
fi
if [ -e "/Applications/Expressions.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Expressions" ]; then
  ln -s "/Applications/Expressions.app" "$HOME/Applications/Dev Tools/Expressions"
fi
if [ -e "/Applications/Xcode.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Xcode" ]; then
  ln -s "/Applications/Xcode.app" "$HOME/Applications/Dev Tools/Xcode"
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

if [ -e "/Applications/UltiMaker Cura.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Cura" ]; then
  ln -s "/Applications/Ultimaker Cura.app" "$HOME/Applications/Hobby Tools/Cura"
fi
if [ -e "/Applications/Raspberry Pi Imager.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Raspberry Pi Imager" ]; then
  ln -s "/Applications/Raspberry Pi Imager.app" "$HOME/Applications/Hobby Tools/Raspberry Pi Imager"
fi
if [ -e "/Applications/Arduino.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Arduino" ]; then
  ln -s "/Applications/Arduino.app" "$HOME/Applications/Hobby Tools/Arduino"
fi
if [ -e "$HOME/Applications/Autodesk Fusion 360.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Fusion 360" ]; then
  ln -s "$HOME/Applications/Autodesk Fusion 360.app" "$HOME/Applications/Hobby Tools/Fusion 360"
fi
if [ -e "/Applications/RadarScope.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/RadarScope" ]; then
  # maybe not a perfect match, but Close Enough
  ln -s "/Applications/RadarScope.app" "$HOME/Applications/Hobby Tools/RadarScope"
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
if [ -e "$HOME/Applications/Instapaper Reader.app" ] && [ ! -e "$HOME/Applications/Media/Instapaper Reader" ]; then
  ln -s "$HOME/Applications/Instapaper Reader.app" "$HOME/Applications/Media/Instapaper Reader"
fi
if [ -e "/Applications/Instapaper Reader.app" ] && [ ! -e "$HOME/Applications/Media/Instapaper Reader" ]; then
  ln -s "/Applications/Instapaper Reader.app" "$HOME/Applications/Media/Instapaper Reader"
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
if [ -e "/Applications/Triode.app" ] && [ ! -e "$HOME/Applications/Media/Triode" ]; then
  ln -s "/Applications/Triode.app" "$HOME/Applications/Media/Triode"
fi
if [ -e "/Applications/Tag Editor.app" ] && [ ! -e "$HOME/Applications/Media/Tag Editor" ]; then
  ln -s "/Applications/Tag Editor.app" "$HOME/Applications/Media/Tag Editor"
fi
if [ -e "/Applications/Pocket Casts.app" ] && [ ! -e "$HOME/Applications/Media/Pocket Casts" ]; then
  ln -s "/Applications/Pocket Casts.app" "$HOME/Applications/Media/Pocket Casts"
fi
if [ -e "/Applications/Poolsuite FM.app" ] && [ ! -e "$HOME/Applications/Media/Poolsuite" ]; then
  ln -s "/Applications/Poolsuite FM.app" "$HOME/Applications/Media/Poolsuite"
fi
if [ -e "$HOME/Applications/Transmission Remote.app" ] && [ ! -e "$HOME/Applications/Media/Transmission" ]; then
  ln -s "$HOME/Applications/Transmission Remote.app" "$HOME/Applications/Media/Transmission"
fi
if [ -e "/Applications/Raindrop.io.app" ] && [ ! -e "$HOME/Applications/Media/Raindrop.io" ]; then
  ln -s "/Applications/Raindrop.io.app" "$HOME/Applications/Media/Raindrop.io"
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
if [ -e "/Applications/Setapp/Luminar Neo.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Luminar Neo" ]; then
  ln -s "/Applications/Setapp/Luminar Neo.app" "$HOME/Applications/Photo Tools/Luminar Neo"
fi
if [ -e "/Applications/GeoTag.app" ] && [ ! -e "$HOME/Applications/Photo Tools/GeoTag" ]; then
  ln -s "/Applications/GeoTag.app" "$HOME/Applications/Photo Tools/GeoTag"
fi
if [ -e "/Applications/SIGMA Photo Pro 6.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Sigma Photo Pro" ]; then
  ln -s "/Applications/SIGMA Photo Pro 6.app" "$HOME/Applications/Photo Tools/Sigma Photo Pro"
fi
if [ -e "/Applications/Neat Image v9 Standalone/Neat Image v9.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Neat Image" ]; then
  ln -s "/Applications/Neat Image v9 Standalone/Neat Image v9.app" "$HOME/Applications/Photo Tools/Neat Image"
fi
if [ -e "/Applications/Peakto.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Peakto" ]; then
  ln -s "/Applications/Peakto.app" "$HOME/Applications/Photo Tools/Peakto"
fi

if [ ! -d "$HOME/Applications/Social Media" ]; then
  setupnote "Dock/Social Media" "- [ ] Add Social Media to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Social Media"
if ! fileicon test "$HOME/Applications/Social Media"; then
  fileicon set "$HOME/Applications/Social Media" "./macOS Configs/Dock Icons/Social Media.png"
fi

if [ -e "/Applications/Messenger.app" ] && [ ! -e "$HOME/Applications/Social Media/Messenger" ]; then
  ln -s "/Applications/Messenger.app" "$HOME/Applications/Social Media/Messenger"
fi
if [ -e "/Applications/Discord.app" ] && [ ! -e "$HOME/Applications/Social Media/Discord" ]; then
  ln -s "/Applications/Discord.app" "$HOME/Applications/Social Media/Discord"
fi
if [ -e "/Applications/Setapp/Grids.app" ] && [ ! -e "$HOME/Applications/Social Media/Grids" ]; then
  ln -s "/Applications/Setapp/Grids.app" "$HOME/Applications/Social Media/Grids"
fi
if [ -e "/Applications/Slack.app" ] && [ ! -e "$HOME/Applications/Social Media/Slack" ]; then
  ln -s "/Applications/Slack.app" "$HOME/Applications/Social Media/Slack"
fi
if [ -e "/Applications/Ivory.app" ] && [ ! -e "$HOME/Applications/Social Media/Ivory" ]; then
  ln -s "/Applications/Ivory.app" "$HOME/Applications/Social Media/Ivory"
fi
if [ -e "/Applications/Mona.app" ] && [ ! -e "$HOME/Applications/Social Media/Mona" ]; then
  ln -s "/Applications/Mona.app" "$HOME/Applications/Social Media/Mona"
fi

rm -f "$HOME/Applications/Social Media/Ice Cubes"
rm -f "$HOME/Applications/Social Media/Mastonaut"
rm -f "$HOME/Applications/Social Media/Caprine"

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
if [ -e "/Applications/Setapp/ForkLift.app" ] && [ ! -e "$HOME/Applications/System Tools/ForkLift" ]; then
  ln -s "/Applications/Setapp/ForkLift.app" "$HOME/Applications/System Tools/ForkLift"
fi
if [ -e "/Applications/OmniDiskSweeper.app" ] && [ ! -e "$HOME/Applications/System Tools/OmniDiskSweeper" ]; then
  ln -s "/Applications/OmniDiskSweeper.app" "$HOME/Applications/System Tools/OmniDiskSweeper"
fi
if [ -e "/System/Applications/Shortcuts.app" ] && [ ! -e "$HOME/Applications/System Tools/Shortcuts" ]; then
  ln -s "/System/Applications/Shortcuts.app" "$HOME/Applications/System Tools/Shortcuts"
fi
if [ -e "/System/Applications/System Settings.app" ] && [ ! -e "$HOME/Applications/System Tools/System Settings" ]; then
  ln -s "/System/Applications/System Settings.app" "$HOME/Applications/System Tools/System Settings"
fi
if [ -e "/Applications/Latest.app" ] && [ ! -e "$HOME/Applications/System Tools/Latest" ]; then
  ln -s "/Applications/Latest.app" "$HOME/Applications/System Tools/Latest"
fi

cecho "✔ Done." $green
