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

IS_ROOT=false
if [ "$EUID" -eq 0 ]; then
  if [ "$HOME" != "/root" ]; then
    echo "[!] you appear to be root but HOME is not /root; exiting."
    exit 1
  fi
  IS_ROOT=true
fi
if $IS_ROOT; then
  echo "Run configuration script as a regular user; it uses sudo where needed."
  exit 0
fi

echo "chris@dzombak.com" > "$HOME"/.forward
echo "chris@dzombak.com" | sudo tee /root/.forward

if command -v raspi-config > /dev/null; then
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
  dpkg-query -W locales >/dev/null 2>&1 || sudo apt install -y locales
  sudo dpkg-reconfigure locales
fi

echo "Configure timezone? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sudo dpkg-reconfigure tzdata
fi

if [ ! -e /etc/sysctl.d/90-cdz-netdev.conf ]; then
  echo "net.core.netdev_budget=900" | sudo tee /etc/sysctl.d/90-cdz-netdev.conf
  echo "net.core.netdev_budget_usecs=6000" | sudo tee -a /etc/sysctl.d/90-cdz-netdev.conf
fi

echo "Clean MOTD..."
sudo rm -f /etc/update-motd.d/10-help-text \
  /etc/update-motd.d/50-motd-news \
  /etc/update-motd.d/51-cloudguest \
  /etc/update-motd.d/80-livepatch \
  /etc/update-motd.d/91-contract-ua-esm-status \
  /etc/update-motd.d/35-armbian-tips
