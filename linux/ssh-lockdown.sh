#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux system configuration because not on Linux"
  exit 2
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

if ! grep -c "^Include /etc/ssh/sshd_config.d/\*.conf$" /etc/ssh/sshd_config >/dev/null ; then
  echo "[!!!] SKIPPING automatic SSH lockdown because /etc/ssh/sshd_config does not include sshd_config.d/*.conf"
  echo " !!!  Fix this and then rerun ssh-lockdown.sh"
  exit 0
fi

if [ ! -e /etc/ssh/sshd_config.d/99-cdzombak.conf ]; then
  if [ ! -s "$HOME"/.ssh/authorized_keys ]; then
    echo "[!!!] SKIPPING automatic SSH lockdown because you have no authorized_keys"
    echo " !!!  Set up SSH public-key auth and then rerun ssh-lockdown.sh"
    exit 0
  else
    sudo mkdir -p /etc/ssh/sshd_config.d
    echo "PermitRootLogin no" | sudo tee /etc/ssh/sshd_config.d/99-cdzombak.conf
    echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config.d/99-cdzombak.conf
    echo "KbdInteractiveAuthentication no" | sudo tee -a /etc/ssh/sshd_config.d/99-cdzombak.conf
  fi
fi
