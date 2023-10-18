#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux system configuration because not on Linux"
  exit 2
fi

# TODO: integrate steps from:
# bear://x-callback-url/open-note?id=6453EDF4-8098-4A38-9A38-6C3B5E998FE6-6789-0002B536C0EBDAC8 (es-1)
# bear://x-callback-url/open-note?id=3C9ECE79-4E00-4CCF-BD33-80A9AE8C5048-706-00007B5CDE30D28A (burr)
# bear://x-callback-url/open-note?id=47909024-B314-4E63-87C6-8FEF6824EFEE (PiAlarm)

if ! command -v dkpg-reconfigure &> /dev/null; then
  echo "dpkg-reconfigure not found; stopping."
  exit 1
fi

if command -v raspi-config &> /dev/null; then
  echo "Configure with raspi-config? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo raspi-config
    exit 0
  fi
fi

echo "Configure locales? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sudo dpkg-reconfigure locales
fi

echo "Configure timezone? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sudo dpkg-reconfigure tzdata
fi
