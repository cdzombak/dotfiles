#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source ./lib/cecho

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping Rosetta install because not on macOS"
  exit 2
fi

# based on https://github.com/rtrouton/rtrouton_scripts/tree/master/rtrouton_scripts/install_rosetta_on_apple_silicon

# Save current IFS state
OLDIFS=$IFS

# Determine OS version
IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"

# restore IFS to previous state
IFS=$OLDIFS

cecho "---- macOS Rosetta Install ----" $white
echo ""

# Check to see if the Mac is reporting itself as running macOS 11
if [[ ${osvers_major} -ge 11 ]]; then
  # Check to see if the Mac needs Rosetta installed by testing the processor
  if /usr/sbin/sysctl -n machdep.cpu.brand_string | grep -c -o "Intel"; then
    echo "Intel processor detected. No need to install Rosetta."
  else
    # Check Rosetta LaunchDaemon.
    # If no LaunchDaemon is found, perform a non-interactive install of Rosetta.
    if [[ ! -f "/Library/Apple/System/Library/LaunchDaemons/com.apple.oahd.plist" ]]; then
        echo "Requesting Rosetta install..."
        sudo /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        if [[ $? -eq 0 ]]; then
          cecho "✔ Rosetta has been successfully installed." $green
        else
          cecho "Rosetta installation failed!" $red
          exit 1
        fi
    else
      cecho "✔ Rosetta is already installed. Nothing to do." $green
    fi
  fi
else
  echo "Detected macOS $osvers_major.$osvers_minor.$osvers_dot_version."
  echo "No need to install Rosetta on this version."
fi
