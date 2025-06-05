#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho
# shellcheck disable=SC1091
source "$LIB_DIR"/sw_install

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
  fileicon set "$HOME/Applications/Dev Tools" "$SCRIPT_DIR/macOS Resources/Dock Icons/Dev Tools.png"
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
if [ -e "$HOME/Applications/GoLand.app" ] && [ ! -e "$HOME/Applications/Dev Tools/GoLand" ]; then
  ln -s "$HOME/Applications/GoLand.app" "$HOME/Applications/Dev Tools/GoLand"
fi
rm -f "$HOME/Applications/Dev Tools/PyCharm"
if [ -e "$HOME/Applications/PyCharm.app" ] && [ ! -e "$HOME/Applications/Dev Tools/PyCharm" ]; then
  ln -s "$HOME/Applications/PyCharm.app" "$HOME/Applications/Dev Tools/PyCharm"
fi
if [ -e "$HOME/Applications/DataGrip.app" ] && [ ! -e "$HOME/Applications/Dev Tools/DataGrip" ]; then
  ln -s "$HOME/Applications/DataGrip.app" "$HOME/Applications/Dev Tools/DataGrip"
fi
if [ -e "$HOME/Applications/PhpStorm.app" ] && [ ! -e "$HOME/Applications/Dev Tools/PhpStorm" ]; then
  ln -s "$HOME/Applications/PhpStorm.app" "$HOME/Applications/Dev Tools/PhpStorm"
fi
if [ -e "$HOME/Applications/WebStorm.app" ] && [ ! -e "$HOME/Applications/Dev Tools/WebStorm" ]; then
  ln -s "$HOME/Applications/WebStorm.app" "$HOME/Applications/Dev Tools/WebStorm"
fi
if [ -e "$HOME/Applications/Clock.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Clock" ]; then
  ln -s "$HOME/Applications/Clock.app" "$HOME/Applications/Dev Tools/Clock"
fi
if [ -e "$HOME/Applications/JSON Viewer.app" ] && [ ! -e "$HOME/Applications/Dev Tools/JSON Viewer" ]; then
  ln -s "$HOME/Applications/JSON Viewer.app" "$HOME/Applications/Dev Tools/JSON Viewer"
fi
if [ -e "$HOME/Applications/CLion.app" ] && [ ! -e "$HOME/Applications/Dev Tools/CLion" ]; then
  ln -s "$HOME/Applications/CLion.app" "$HOME/Applications/Dev Tools/CLion"
fi
if [ -e "$HOME/Applications/Fleet.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Fleet" ]; then
  ln -s "$HOME/Applications/Fleet.app" "$HOME/Applications/Dev Tools/Fleet"
fi
if [ -e "$HOME/Applications/IntelliJ IDEA Ultimate.app" ] && [ ! -e "$HOME/Applications/Dev Tools/IntelliJ IDEA" ]; then
  ln -s "$HOME/Applications/IntelliJ IDEA Ultimate.app" "$HOME/Applications/Dev Tools/IntelliJ IDEA"
fi
if [ -e "$HOME/Applications/OrbStack.app" ] && [ ! -e "$HOME/Applications/Dev Tools/OrbStack" ]; then
  ln -s "$HOME/Applications/OrbStack.app" "$HOME/Applications/Dev Tools/OrbStack"
fi
if [ -e "$HOME/Applications/GitHub Desktop.app" ] && [ ! -e "$HOME/Applications/Dev Tools/GitHub Desktop" ]; then
  ln -s "$HOME/Applications/GitHub Desktop.app" "$HOME/Applications/Dev Tools/GitHub Desktop"
fi
if [ -e "$HOME/Applications/Visual Studio Code.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Visual Studio Code" ]; then
  ln -s "$HOME/Applications/Visual Studio Code.app" "$HOME/Applications/Dev Tools/Visual Studio Code"
fi
if [ -e "/Applications/Cursor.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Cursor" ]; then
  ln -s "/Applications/Cursor.app" "$HOME/Applications/Dev Tools/Cursor"
fi
if [ -e "/Applications/Taska.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Taska" ]; then
  ln -s "/Applications/Taska.app" "$HOME/Applications/Dev Tools/Taska"
fi
if [ -e "/Applications/Setapp/Squash.app" ] && [ ! -e "$HOME/Applications/Dev Tools/Squash" ]; then
  ln -s "/Applications/Setapp/Squash.app" "$HOME/Applications/Dev Tools/Squash"
fi

if [ ! -d "$HOME/Applications/Hobby Tools" ]; then
  setupnote "Dock/Hobby Tools" "- [ ] Add Hobby Tools to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Hobby Tools"
if ! fileicon test "$HOME/Applications/Hobby Tools"; then
  fileicon set "$HOME/Applications/Hobby Tools" "$SCRIPT_DIR/macOS Resources/Dock Icons/Hobby Tools.png"
fi

if [ -e "/Applications/UltiMaker Cura.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Cura" ]; then
  ln -s "/Applications/Ultimaker Cura.app" "$HOME/Applications/Hobby Tools/Cura"
fi
if [ -e "/Applications/Raspberry Pi Imager.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Raspberry Pi Imager" ]; then
  ln -s "/Applications/Raspberry Pi Imager.app" "$HOME/Applications/Hobby Tools/Raspberry Pi Imager"
fi
if [ -e "/Applications/Arduino IDE.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Arduino IDE" ]; then
  ln -s "/Applications/Arduino IDE.app" "$HOME/Applications/Hobby Tools/Arduino IDE"
fi
if [ -e "$HOME/Applications/Autodesk Fusion.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Fusion" ]; then
  ln -s "$HOME/Applications/Autodesk Fusion.app" "$HOME/Applications/Hobby Tools/Fusion"
fi
if [ -e "/Applications/OpenSCAD.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/OpenSCAD" ]; then
  ln -s "/Applications/OpenSCAD.app" "$HOME/Applications/Hobby Tools/OpenSCAD"
fi
if [ -e "/Applications/RadarScope.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/RadarScope" ]; then
  ln -s "/Applications/RadarScope.app" "$HOME/Applications/Hobby Tools/RadarScope"
fi
if [ -e "/Applications/LTSpice.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/LTSpice" ]; then
  ln -s "/Applications/LTSpice.app" "$HOME/Applications/Hobby Tools/LTSpice"
fi
if [ -e "/Applications/Qucs-S.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Qucs-S" ]; then
  ln -s "/Applications/Qucs-S.app" "$HOME/Applications/Hobby Tools/Qucs-S"
fi
if [ -e "/Applications/KiCad/KiCad.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/KiCad" ]; then
  ln -s "/Applications/KiCad/KiCad.app" "$HOME/Applications/Hobby Tools/KiCad"
fi
if [ -e "/Applications/BambuStudio.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Bambu Studio" ]; then
  ln -s "/Applications/BambuStudio.app" "$HOME/Applications/Hobby Tools/Bambu Studio"
fi
if [ -e "/Applications/Meshman 3D Viewer PRO.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/Meshman 3D Viewer" ]; then
  ln -s "/Applications/Meshman 3D Viewer PRO.app" "$HOME/Applications/Hobby Tools/Meshman 3D Viewer"
fi
if [ -e "/Applications/MQTTAnalyzer.app" ] && [ ! -e "$HOME/Applications/Hobby Tools/MQTTAnalyzer" ]; then
  ln -s "/Applications/MQTTAnalyzer.app" "$HOME/Applications/Hobby Tools/MQTTAnalyzer"
fi

if [ ! -d "$HOME/Applications/Media" ]; then
  setupnote "Dock/Media" "- [ ] Add Media to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Media"
if ! fileicon test "$HOME/Applications/Media"; then
  fileicon set "$HOME/Applications/Media" "$SCRIPT_DIR/macOS Resources/Dock Icons/Media.png"
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
if [ -e "$HOME/Applications/Lofi ATC.app" ] && [ ! -e "$HOME/Applications/Media/Lofi ATC" ]; then
  ln -s "$HOME/Applications/Lofi ATC.app" "$HOME/Applications/Media/Lofi ATC"
fi
if [ -e "$HOME/Applications/Lofi Cafe.app" ] && [ ! -e "$HOME/Applications/Media/Lofi Cafe" ]; then
  ln -s "$HOME/Applications/Lofi Cafe.app" "$HOME/Applications/Media/Lofi Cafe"
elif [ -e "$HOME/Applications/lofi.cafe.app" ] && [ ! -e "$HOME/Applications/Media/Lofi Cafe" ]; then
  ln -s "$HOME/Applications/lofi.cafe.app" "$HOME/Applications/Media/Lofi Cafe"
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
if [ -e "/Applications/Raindrop.io.app" ] && [ ! -e "$HOME/Applications/Media/Raindrop.io" ]; then
  ln -s "/Applications/Raindrop.io.app" "$HOME/Applications/Media/Raindrop.io"
fi
if [ -e "/Applications/YT Music.app" ] && [ ! -e "$HOME/Applications/Media/YT Music" ]; then
  ln -s "/Applications/YT Music.app" "$HOME/Applications/Media/YT Music"
fi
if [ -e "/Applications/Setapp/Clariti.app" ] && [ ! -e "$HOME/Applications/Media/Clariti" ]; then
  ln -s "/Applications/Setapp/Clariti.app" "$HOME/Applications/Media/Clariti"
fi
rm -f "$HOME/Applications/Media/Transmission"

if [ ! -d "$HOME/Applications/Photo Tools" ]; then
  setupnote "Dock/Photo Tools" "- [ ] Add Photo Tools to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Photo Tools"
if ! fileicon test "$HOME/Applications/Photo Tools"; then
  fileicon set "$HOME/Applications/Photo Tools" "$SCRIPT_DIR/macOS Resources/Dock Icons/Photo Tools.png"
fi

if [ -e "/Applications/Acorn.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Acorn" ]; then
  ln -s "/Applications/Acorn.app" "$HOME/Applications/Photo Tools/Acorn"
fi
if [ -e "/Applications/Affinity Photo 2.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Affinity Photo" ]; then
  ln -s "/Applications/Affinity Photo 2.app" "$HOME/Applications/Photo Tools/Affinity Photo"
fi
rm -f "$HOME/Applications/Photo Tools/DXO PhotoLab"
rm -f "$HOME/Applications/Photo Tools/DxO FilmPack"
if [ -e "/Applications/DXOPhotoLab7.app" ] && [ ! -e "$HOME/Applications/Photo Tools/DXO PhotoLab" ]; then
  ln -s "/Applications/DXOPhotoLab7.app" "$HOME/Applications/Photo Tools/DXO PhotoLab"
fi
if [ -e "/Applications/DxO FilmPack 7.app" ] && [ ! -e "$HOME/Applications/Photo Tools/DxO FilmPack" ]; then
  ln -s "/Applications/DxO FilmPack 7.app" "$HOME/Applications/Photo Tools/DxO FilmPack"
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
if [ -e "/Applications/Inkscape.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Inkscape" ]; then
  ln -s "/Applications/Inkscape.app" "$HOME/Applications/Photo Tools/Inkscape"
fi
if [ -e "$HOME/Applications/Flickr.app" ] && [ ! -e "$HOME/Applications/Photo Tools/Flickr" ]; then
  ln -s "$HOME/Applications/Flickr.app" "$HOME/Applications/Photo Tools/Flickr"
fi

if [ ! -d "$HOME/Applications/Social Media" ]; then
  setupnote "Dock/Social Media" "- [ ] Add Social Media to Dock, if desired"
fi
mkdir -p "$HOME/Applications/Social Media"
if ! fileicon test "$HOME/Applications/Social Media"; then
  fileicon set "$HOME/Applications/Social Media" "$SCRIPT_DIR/macOS Resources/Dock Icons/Social Media.png"
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
  fileicon set "$HOME/Applications/System Tools" "$SCRIPT_DIR/macOS Resources/Dock Icons/System Tools.png"
fi

if [ -e "/Applications/Arq.app" ] && [ ! -e "$HOME/Applications/System Tools/Arq" ]; then
  ln -s "/Applications/Arq.app" "$HOME/Applications/System Tools/Arq"
fi
if [ -e "/Applications/Tailscale.app" ] && [ ! -e "$HOME/Applications/System Tools/Tailscale" ]; then
  ln -s "/Applications/Tailscale.app" "$HOME/Applications/System Tools/Tailscale"
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
if [ -e "$HOME/Applications/System Tools/Screens" ]; then
  rm "$HOME/Applications/System Tools/Screens"
fi
if [ -e "/Applications/Screens 5.app" ] && [ ! -e "$HOME/Applications/System Tools/Screens 5" ]; then
  ln -s "/Applications/Screens 5.app" "$HOME/Applications/System Tools/Screens 5"
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
if [ -e "/Applications/ServerCat.app" ] && [ ! -e "$HOME/Applications/System Tools/ServerCat" ]; then
  ln -s "/Applications/ServerCat.app" "$HOME/Applications/System Tools/ServerCat"
fi
if [ -e "/Applications/Restic-Browser.app" ] && [ ! -e "$HOME/Applications/System Tools/Restic Browser" ]; then
  ln -s "/Applications/Restic-Browser.app" "$HOME/Applications/System Tools/Restic Browser"
fi
if [ -e "/Applications/Tintd.app" ] && [ ! -e "$HOME/Applications/System Tools/Tintd" ]; then
  ln -s "/Applications/Tintd.app" "$HOME/Applications/System Tools/Tintd"
fi

cecho "✔ Done." $green
