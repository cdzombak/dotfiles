#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux system configuration because not on Linux"
  exit 2
fi

if [ ! -x /usr/sbin/dpkg-reconfigure ]; then
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

echo "chris@dzombak.com" > "$HOME"/.forward
echo "chris@dzombak.com" | sudo tee /root/.forward

if [ ! -e /etc/sysctl.d/90-cdz-netdev.conf ]; then
  echo "net.core.netdev_budget=900" | sudo tee /etc/sysctl.d/90-cdz-netdev.conf
  echo "net.core.netdev_budget_usecs=6000" | sudo tee -a /etc/sysctl.d/90-cdz-netdev.conf
fi
