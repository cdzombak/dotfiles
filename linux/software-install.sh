#!/usr/bin/env bash
set -euo pipefail

# TODO(cdzombak): postfix
# TODO(cdzombak): sample restic script and stub config files in /etc daily cron & folder
# TODO(cdzombak): logz.io for system and core services (what's the easiest, lowest friction way to set this up?)
# TODO(cdzombak): logz.io for docker

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux software setup because not on Linux"
  exit 2
fi

if [ ! -x /usr/bin/apt ]; then
  echo "Skipping Linux software setup because /usr/bin/apt is not available"
  exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1091
source "$SCRIPT_DIR"/swprof

_install_snapd() {
  if ! dpkg-query -W snapd >/dev/null; then
    sudo apt install snapd
  fi
}

# Authenticate upfront and run a keep-alive to update `sudo` time stamp until script has finished
echo "This script will use sudo; enter your password to authenticate if prompted."
sudo -v
while true; do sudo -v -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
echo "--- Sources ---"
echo ""

echo "Setting up dist.cdzombak.net apt repos ..."
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://dist.cdzombak.net/deb.key | sudo gpg --dearmor -o /etc/apt/keyrings/dist-cdzombak-net.gpg
sudo chmod 0644 /etc/apt/keyrings/dist-cdzombak-net.gpg
echo -e "deb [signed-by=/etc/apt/keyrings/dist-cdzombak-net.gpg] https://dist.cdzombak.net/deb/oss any oss\ndeb [signed-by=/etc/apt/keyrings/dist-cdzombak-net.gpg] https://dist.cdzombak.net/deb/3p any 3p\n" | sudo tee /etc/apt/sources.list.d/dist-cdzombak-net.list > /dev/null
sudo apt update -y

echo ""
echo "--- Core ---"
echo ""

echo "Installing common packages via apt..."
sudo apt install -y make tig tree htop nnn traceroute dnsutils screen molly-guard nano jq wget zip unzip

if [ ! -L "$HOME/.local/.nano-root" ]; then
  mkdir -p "$HOME/.local"
  ln -s /usr "$HOME/.local/.nano-root"
fi

if profile_public_server && ! dpkg-query -W fail2ban >/dev/null; then
  sudo apt install -y fail2ban
fi

if [ ! -e "$HOME/.config/dotfiles/no-ufw" ] && ! dpkg-query -W ufw >/dev/null; then
  echo "Install ufw? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo apt install -y ufw
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-ufw"
  fi
fi

echo "Installing self-packaged software via apt-get..."
sudo apt-get install -y apply-crontab dirshard listening runner restic remote-edit unshorten

if [ "$(uname -m)" = "x86_64" ]; then
  sudo apt-get install -y bandwhich
else
  echo "Bandwhich: unsupported architecture. Check https://github.com/imsnif/bandwhich/releases to see if non-x86_64 builds are available."
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

if [ ! -e "$HOME/.config/dotfiles/no-netdata" ] && ! dpkg-query -W netdata >/dev/null; then
  echo "Install Netdata? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh --stable-channel --native-only
    # TODO(cdzombak): netdata configuration, accessibility via tailscale
    # see bear://x-callback-url/open-note?id=E9620D65-2100-46CB-A798-02EFA52B6BE5-57092-00053B45CF64BCAE
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-netdata"
  fi
fi

echo ""
echo "--- Nginx + Certbot ---"
echo ""

_install_certbot_snap() {
  _install_snapd
  sudo snap install --classic certbot
  sudo ln -s /snap/bin/certbot /usr/bin/certbot
}
if dpkg-query -W certbot >/dev/null; then
  echo "Switch certbot to snap-based install? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo apt-get remove certbot
    sudo apt autoremove
    _install_certbot_snap
  fi
fi

if ! command -v nginx >/dev/null; then
  echo "Install nginx? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo apt install nginx
  fi

  echo "Install certbot (via snap)? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    _install_certbot_snap
  fi

  echo "Install nginx_ensite/dissite scripts? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    git clone https://github.com/perusio/nginx_ensite.git /tmp/nginx_ensite
    pushd /tmp/nginx_ensite
    sudo make install
    popd
    rm -rf /tmp/nginx_ensite
  fi
fi

echo ""
echo "--- Docker ---"
echo ""

_install_docker() {
  sudo apt-get install ca-certificates curl gnupg -y
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/"$(lsb_release -is | tr '[:upper:]' '[:lower:]')"/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt -y update
  sudo apt install docker-ce -y
  if [ ! -e /etc/docker/daemon.json ]; then
    echo "{}" | sudo tee /etc/docker/daemon.json > /dev/null
    sudo chown root:docker /etc/docker/daemon.json
  fi
  sudo jq ".[\"log-driver\"]=\"local\"" /etc/docker/daemon.json > /tmp/daemon.json.tmp
  sudo mv /tmp/daemon.json.tmp /etc/docker/daemon.json
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker "$(whoami)"
  sudo useradd -r -s /usr/sbin/nologin dockerapps
  if [ ! -d /opt/docker ]; then
    sudo mkdir -p /opt/docker/compose
    sudo mkdir -p /opt/docker/data
    sudo mkdir -p /opt/docker/src
    pushd /opt/docker/compose
    sudo git init
    popd
    sudo chown -R root:docker /opt/docker
    sudo chmod -R g+w /opt/docker
  fi
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
echo "--- Logz.io ---"
echo ""

# TODO: for Docker to logzio:
# https://docs.logz.io/shipping/log-sources/docker.html#logzio-logging-plugin-config
# docker plugin install logzio/logzio-logging-plugin:1.0.2 --alias logzio/logzio-logging-plugin
# docker plugin enable logzio/logzio-logging-plugin
# verify:
# docker plugin ls --filter enabled=true
# TODO: configure daemon.json
# {
#   "log-driver": "logzio/logzio-logging-plugin",
#   "log-opts": {
#     "logzio-url": "<<LISTENER-HOST>>",
#     "logzio-token": "<<LOG-SHIPPING-TOKEN>>",
#     "logzio-dir-path": "<dir_path_to_logs_disk_queue>"
#   }
# }
# sudo mkdir /opt/docker/data/logzio && sudo chown root:docker /opt/docker/data/logzio

# for system to logzio:
# curl -sLO https://github.com/logzio/logzio-shipper/raw/master/dist/logzio-rsyslog.tar.gz \
#   && tar xzf logzio-rsyslog.tar.gz \
#   && sudo rsyslog/install.sh -t linux -a "TOKEN" -l "listener.logz.io" \
#   && rm logzio-rsyslog.tar.gz
# curl -sLO https://github.com/logzio/logzio-shipper/raw/master/dist/logzio-rsyslog.tar.gz \
#   && tar xzf logzio-rsyslog.tar.gz \
#   && sudo rsyslog/install.sh -t nginx -a "TOKEN" -l "listener.logz.io" \
#   && rm logzio-rsyslog.tar.gz

echo ""
echo "--- Tailscale ---"
echo ""

if [ ! -e "$HOME/.config/dotfiles/no-tailscale" ] && ! dpkg-query -W tailscale >/dev/null; then
  echo "Install Tailscale? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    "$SCRIPT_DIR"/tailscale/ts-install.sh
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-tailscale"
  fi
fi

echo ""
echo "--- Syncthing ---"
echo ""

if [ ! -e "$HOME/.config/dotfiles/no-syncthing" ] && ! dpkg-query -W syncthing >/dev/null; then
  echo "Install Syncthing? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt-get update && sudo apt-get install syncthing
    # TODO(cdzombak): syncthing configuration (add ID to note, GUI password and accessibility via tailscale, start syncing)
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-syncthing"
  fi
fi

echo ""
echo "--- Golang ---"
echo ""

_install_go_snap() {
  _install_snapd
  sudo snap install go --classic
  sudo ln -s /snap/bin/go /usr/bin/go
}
if dpkg-query -W golang >/dev/null; then
  echo "Switch Golang to snap-based install? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo apt remove golang
    sudo apt autoremove
    _install_go_snap
  fi
elif [ ! -e "$HOME/.config/dotfiles/no-snap-golang" ] && [ ! -e /snap/bin/go ]; then
  echo "Install Golang (via snap)? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    _install_go_snap
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-snap-golang"
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
/usr/local/bin/yt-dlp -qU
EOF
    sudo chown root:root /etc/cron.daily/yt-dlp-update
    sudo chmod 0755 /etc/cron.daily/yt-dlp-update
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-yt-dlp"
  fi
fi
