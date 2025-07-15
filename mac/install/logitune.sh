#!/usr/bin/env bash
set -euo pipefail

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
