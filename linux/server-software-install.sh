#!/usr/bin/env bash
set -euo pipefail

# TODO(cdzombak): restructure into mac/linux shared/server/client
# TODO: systemsetup list for Linux server & client (ssh disable root & password, backups; Pi hardening; DNS; hostname
# TODO: logz.io for system and core services (what's the easiest, lowest friction way to set this up?)
# TODO: logz.io for docker

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux software setup because not on Linux"
  exit 2
fi

if [ ! -x /usr/bin/apt ]; then
  echo "Skipping Linux software setup because /usr/bin/apt is not available"
  exit 1
fi

# Authenticate upfront and run a keep-alive to update `sudo` time stamp until script has finished
echo "This script will use sudo; enter your password to authenticate if prompted."
sudo -v
while true; do sudo -v -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
echo "--- Sources ---"
echo ""

if [ ! -f /etc/apt/sources.list.d/cdzombak_oss_any.list ]; then
  echo "Setting up cdzombak/oss/any PackageCloud apt repo..."
  curl -s https://packagecloud.io/install/repositories/cdzombak/oss/script.deb.sh?any=true | sudo bash
fi
if [ ! -f /etc/apt/sources.list.d/cdzombak_3p_any.list ]; then
  echo "Setting up cdzombak/3p/any PackageCloud apt repo..."
  curl -s https://packagecloud.io/install/repositories/cdzombak/3p/script.deb.sh?any=true | sudo bash
fi
sudo apt -y update

echo ""
echo "--- Core ---"
echo ""

echo "Installing common packages via apt..."
sudo apt -y install tig tree htop nnn traceroute dnsutils screen molly-guard nano jq wget

if [ ! -L "$HOME/.local/.nano-root" ]; then
  mkdir -p "$HOME/.local"
  ln -s /usr "$HOME/.local/.nano-root"
fi

if [ ! -e "$HOME/.config/dotfiles/no-fail2ban" ] && ! dpkg-query -W fail2ban >/dev/null; then
  echo "Install fail2ban? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo apt -y install fail2ban
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-fail2ban"
  fi
fi

if [ ! -e "$HOME/.config/dotfiles/no-ufw" ] && ! dpkg-query -W ufw >/dev/null; then
  echo "Install ufw? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo apt -y install ufw
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-ufw"
  fi
fi

echo "Installing self-packaged software via apt-get..."
sudo apt-get -y install apply-crontab dirshard listening runner restic

if [ "$(uname -m)" = "x86_64" ]; then
  sudo apt-get -y install bandwhich
else
  echo "[!] Bandwhich: unsupported architecture. Check https://github.com/imsnif/bandwhich/releases to see if non-x86_64 builds are available."
fi

if [ ! -d "$HOME/crontab.d" ]; then
  echo "Setting up ~/crontab.d for use with apply-crontab..."
  apply-crontab -i
fi

if ! command -v op >/dev/null; then
  echo "Installing 1Password CLI..."
  # from https://developer.1password.com/docs/cli/get-started/:
  # Add the key for the 1Password apt repository:
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  # Add the 1Password apt repository:
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | sudo tee /etc/apt/sources.list.d/1password.list
  # Add the debsig-verify policy:
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  # Install 1Password CLI:
  sudo apt -y update && sudo apt -y install 1password-cli
fi

echo "Install/update notify-me script? (y/N)"
echo "(requires auth to dropbox.dzombak.com/_auth)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  curl -f -u cdzombak --output "$HOME/opt/bin/notify-me" https://dropbox.dzombak.com/_auth/notify-me
  chmod 755 "$HOME/opt/bin/notify-me"
fi

echo ""
echo "--- Docker ---"
echo ""

_install_docker() {
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/"$(lsb_release -is | tr '[:upper:]' '[:lower:]')"/gpg | sudo apt-key add -
  DEBARCH=""
  if [ "$(uname -m)" = "x86_64" ]; then
    DEBARCH="amd64"
  elif [ "$(uname -m)" = "aarch64" ]; then
    DEBARCH="arm64"
  else
    echo "[!] This Docker setup script doesn't (yet) support architecture '$(uname -m)'.";
    echo "    Skipping Docker install for now."
    return
  fi
  sudo add-apt-repository "deb [arch=$DEBARCH] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable"
  sudo apt -y update
  apt-cache policy docker-ce
  echo "Does the above apt-cache policy indicate Docker will be installed from download.docker.com? (y/N)"
  read -r response
  if [[ ! $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Okay. Skipping Docker install for now."
    return
  fi
  sudo apt install docker-ce -y
  if [ ! -e /etc/docker/daemon.json ]; then
    echo "{}" | sudo tee /etc/docker/daemon.json > /dev/null
  fi
  jq ".[\"log-driver\"]=\"local\"" /etc/docker/daemon.json > /tmp/daemon.json.tmp
  sudo mv /tmp/daemon.json.tmp /etc/docker/daemon.json
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker "$(whoami)"
}
if [ ! -e "$HOME/.config/dotfiles/no-docker" ] && ! command -v docker >/dev/null; then
  echo "Install Docker? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    _install_docker
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-docker"
  fi
fi

echo ""
echo "--- Media Tools ---"
echo ""

if [ ! -e "$HOME/.config/dotfiles/no-ffmpeg-scripts" ] && ! dpkg-query -W quick-media-conv >/dev/null; then
  echo "Install quick media conversion scripts? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo apt-get install -y quick-media-conv
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-ffmpeg-scripts"
  fi
fi

if [ ! -e "$HOME/.config/dotfiles/no-yt-dlp" ] && ! command -v yt-dlp >/dev/null; then
  echo "Install yt-dlp? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
    cat << EOF | sudo tee /etc/cron.daily/yt-dlp-update >/dev/null
#!/bin/sh
/usr/local/bin/yt-dlp -U
EOF
    sudo chown root:root /etc/cron.daily/yt-dlp-update
    sudo chmod 0755 /etc/cron.daily/yt-dlp-update
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-yt-dlp"
  fi
fi
