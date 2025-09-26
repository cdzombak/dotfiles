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

# Function to create application folder with icon
# Args: category_folder
create_app_folder() {
  local category_folder="$1"
  local folder_path="$HOME/Applications/$category_folder"
  local icon_path="$SCRIPT_DIR/macOS Resources/Dock Icons/$category_folder.png"

  if [ ! -d "$folder_path" ]; then
    setupnote "Dock/$category_folder" "- [ ] Add $category_folder to Dock, if desired"
  fi
  mkdir -p "$folder_path"
  if ! fileicon test "$folder_path"; then
    fileicon set "$folder_path" "$icon_path"
  fi
}

# Function to create application shortcuts
# Args: category_folder, app_path, [shortcut_name]
create_app_link() {
  local category_folder="$1"
  local app_path="$2"
  local shortcut_name="${3:-$(basename "$app_path" .app)}"
  local link_path="$HOME/Applications/$category_folder/$shortcut_name"
  if [ -e "$app_path" ]; then
    ln -shf "$app_path" "$link_path"
  fi
}

echo ""
cecho "--- ~/Applications Folders (for Dock) ---" $white
echo ""

create_app_folder "Dev Tools"

create_app_link "Dev Tools" "/Applications/Dash.app"
create_app_link "Dev Tools" "/Applications/Fork.app"
create_app_link "Dev Tools" "/Applications/iTerm.app"
create_app_link "Dev Tools" "/Applications/Expressions.app"
create_app_link "Dev Tools" "/Applications/Xcode.app"
create_app_link "Dev Tools" "/Applications/Sublime Text.app"
create_app_link "Dev Tools" "$HOME/Applications/GoLand.app"
create_app_link "Dev Tools" "$HOME/Applications/PyCharm.app"
create_app_link "Dev Tools" "$HOME/Applications/DataGrip.app"
create_app_link "Dev Tools" "$HOME/Applications/PhpStorm.app"
create_app_link "Dev Tools" "$HOME/Applications/WebStorm.app"
create_app_link "Dev Tools" "$HOME/Applications/Clock.app"
create_app_link "Dev Tools" "$HOME/Applications/JSON Viewer.app"
create_app_link "Dev Tools" "$HOME/Applications/CLion.app"
create_app_link "Dev Tools" "$HOME/Applications/Fleet.app"
create_app_link "Dev Tools" "$HOME/Applications/IntelliJ IDEA Ultimate.app" "IntelliJ IDEA"
create_app_link "Dev Tools" "$HOME/Applications/OrbStack.app"
create_app_link "Dev Tools" "$HOME/Applications/GitHub Desktop.app"
create_app_link "Dev Tools" "$HOME/Applications/Visual Studio Code.app"
create_app_link "Dev Tools" "/Applications/Taska.app"
create_app_link "Dev Tools" "/Applications/Setapp/Squash.app"

create_app_folder "Hobby Tools"

create_app_link "Hobby Tools" "/Applications/UltiMaker Cura.app" "Cura"
create_app_link "Hobby Tools" "/Applications/Ultimaker Cura.app" "Cura"
create_app_link "Hobby Tools" "/Applications/Raspberry Pi Imager.app"
create_app_link "Hobby Tools" "/Applications/Arduino IDE.app"
create_app_link "Hobby Tools" "$HOME/Applications/Autodesk Fusion.app" "Fusion"
create_app_link "Hobby Tools" "/Applications/OpenSCAD.app"
create_app_link "Hobby Tools" "/Applications/RadarScope.app"
create_app_link "Hobby Tools" "/Applications/LTSpice.app"
create_app_link "Hobby Tools" "/Applications/Qucs-S.app"
create_app_link "Hobby Tools" "/Applications/KiCad/KiCad.app"
create_app_link "Hobby Tools" "/Applications/BambuStudio.app" "Bambu Studio"
create_app_link "Hobby Tools" "/Applications/Meshman 3D Viewer PRO.app" "Meshman 3D Viewer"
create_app_link "Hobby Tools" "/Applications/MQTTAnalyzer.app"
create_app_link "Hobby Tools" "/Applications/SDR++.app"

rm -f "$HOME/Applications/Hobby Tools/CubicSDR"

create_app_folder "Media"

create_app_link "Media" "/Applications/calibre.app" "Calibre"
create_app_link "Media" "/Applications/Doppler.app"
create_app_link "Media" "/Applications/Doppler Transfer.app"
create_app_link "Media" "/Applications/Infuse.app"
create_app_link "Media" "$HOME/Applications/Instapaper Reader.app"
create_app_link "Media" "$HOME/Applications/Lofi ATC.app"
create_app_link "Media" "$HOME/Applications/Lofi Cafe.app" "Lofi Cafe"
create_app_link "Media" "$HOME/Applications/lofi.cafe.app" "Lofi Cafe"
create_app_link "Media" "/Applications/Plex.app"
create_app_link "Media" "/Applications/Plexamp.app"
create_app_link "Media" "/Applications/Spotify.app"
create_app_link "Media" "/Applications/Sonos.app"
create_app_link "Media" "/Applications/Triode.app"
create_app_link "Media" "/Applications/Tag Editor.app"
create_app_link "Media" "/Applications/Pocket Casts.app"
create_app_link "Media" "/Applications/Poolsuite FM.app" "Poolsuite"
create_app_link "Media" "/Applications/Raindrop.io.app"
create_app_link "Media" "/Applications/YT Music.app"
create_app_link "Media" "/Applications/Clariti.app"

rm -f "$HOME/Applications/Media/Transmission"

create_app_folder "Photo Tools"

create_app_link "Photo Tools" "/Applications/Acorn.app"
create_app_link "Photo Tools" "/Applications/Affinity Photo 2.app" "Affinity Photo"
create_app_link "Photo Tools" "/Applications/DXOPhotoLab8.app" "DXO PhotoLab"
create_app_link "Photo Tools" "/Applications/DxO FilmPack 7.app" "DxO FilmPack"
create_app_link "Photo Tools" "/Applications/Fileloupe.app"
create_app_link "Photo Tools" "/Applications/PhotoSweeper X.app"
create_app_link "Photo Tools" "/System/Applications/Photos.app"
create_app_link "Photo Tools" "/Applications/Pixelmator Pro.app"
create_app_link "Photo Tools" "/Applications/PhotosRevive.app"
create_app_link "Photo Tools" "/System/Applications/Preview.app"
create_app_link "Photo Tools" "/Applications/RAW Power.app"
create_app_link "Photo Tools" "/Applications/Topaz Sharpen AI.app"
create_app_link "Photo Tools" "/Applications/Setapp/Squash.app"
create_app_link "Photo Tools" "/Applications/Setapp/Luminar Neo.app"
create_app_link "Photo Tools" "/Applications/MetaImage.app"
create_app_link "Photo Tools" "/Applications/GeoTag.app"
create_app_link "Photo Tools" "/Applications/SIGMA Photo Pro 6.app" "Sigma Photo Pro"
create_app_link "Photo Tools" "/Applications/Neat Image v9 Standalone/Neat Image v9.app" "Neat Image"
create_app_link "Photo Tools" "/Applications/Peakto.app"
create_app_link "Photo Tools" "/Applications/Inkscape.app"
create_app_link "Photo Tools" "$HOME/Applications/Flickr.app"

create_app_folder "Social Media"

create_app_link "Social Media" "/Applications/Messenger.app"
create_app_link "Social Media" "/Applications/Discord.app"
create_app_link "Social Media" "/Applications/Setapp/Grids.app"
create_app_link "Social Media" "/Applications/Slack.app"
create_app_link "Social Media" "/Applications/Ivory.app"
create_app_link "Social Media" "/Applications/Mona.app"

rm -f "$HOME/Applications/Social Media/Ice Cubes"
rm -f "$HOME/Applications/Social Media/Mastonaut"
rm -f "$HOME/Applications/Social Media/Caprine"

create_app_folder "System Tools"

create_app_link "System Tools" "/Applications/Arq.app"
create_app_link "System Tools" "/Applications/Tailscale.app"
create_app_link "System Tools" "/Applications/LaunchControl.app"
create_app_link "System Tools" "/System/Applications/App Store.app"
create_app_link "System Tools" "/Applications/Sloth.app"
create_app_link "System Tools" "/Applications/Screens 5.app" "Screens"
create_app_link "System Tools" "/Applications/Transmit.app"
create_app_link "System Tools" "/Applications/iTerm.app"
create_app_link "System Tools" "/Applications/Setapp/ForkLift.app"
create_app_link "System Tools" "/Applications/OmniDiskSweeper.app"
create_app_link "System Tools" "/System/Applications/Shortcuts.app"
create_app_link "System Tools" "/System/Applications/System Settings.app"
create_app_link "System Tools" "/Applications/Latest.app"
create_app_link "System Tools" "/Applications/ServerCat.app"
create_app_link "System Tools" "/Applications/Restic-Browser.app" "Restic Browser"
create_app_link "System Tools" "/Applications/Tintd.app"

create_app_folder "AI Tools"

create_app_link "AI Tools" "/Applications/Talktastic.app"
create_app_link "AI Tools" "/Applications/Claude.app"
create_app_link "AI Tools" "$HOME/Applications/OpenWebUI.app"
create_app_link "AI Tools" "$HOME/Applications/Devin.app"
create_app_link "AI Tools" "$HOME/Applications/GitHub Copilot.app"
create_app_link "AI Tools" "/Applications/VibeTunnel.app"
create_app_link "AI Tools" "/Applications/Conductor.app"
create_app_link "AI Tools" "/Applications/Windsurf.app"
create_app_link "AI Tools" "$HOME/Applications/claudia"
create_app_link "AI Tools" "$HOME/Applications/Google AI Studio.app"

cecho "✔ Done." $green
