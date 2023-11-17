#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux software setup because not on Linux"
  exit 2
fi

if [ ! -x /usr/bin/apt ]; then
  echo "Skipping Linux software setup because /usr/bin/apt is not available"
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
  mkdir -p /root/.local
  ln -s /usr /root/.local/.nano-root

  echo "Run software install script as a regular user; it uses sudo where needed."
  exit 0
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/sw_install
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

if [ ! -e "$HOME/.config/dotfiles/no-ufw" ] && profile_public_server && ! dpkg-query -W ufw >/dev/null; then
  sudo apt install -y ufw
fi

echo "Installing self-packaged software via apt-get..."
sudo apt-get install -y apply-crontab dirshard listening runner restic unshorten
# TODO(cdzombak): add remote-edit/apg once it's in beta

# Cron+Runner logging config per my convention:
mkdir -p "$HOME"/log/runner
cat << EOF > "$HOME"/crontab.d/01-paths.cron
PATH=$HOME/opt/bin:/usr/local/bin:/usr/bin:/bin
RUNNER_LOG_DIR=$HOME/log/runner

EOF
cat << EOF > "$HOME"/crontab.d/90-runner-logs-cleanup.cron

## Runner logs cleanup
0  0  *  *  *  runner -job-name "Cleanup Runner Logs" -work-dir $HOME/log/runner -- find . -mtime +7 -name "*.log" -delete
EOF
sudo mkdir /var/log/runner
cat << EOF | sudo tee /etc/cron.daily/runner-logs-cleanup >/dev/null
#!/bin/sh
find /var/log/runner -mtime +30 -name "*.log" -delete
EOF
sudo chmod 0755 /etc/cron.daily/runner-logs-cleanup

if [ "$(uname -m)" = "x86_64" ]; then
  sudo apt-get install -y bandwhich
else
  echo "Bandwhich: unsupported architecture. Check https://github.com/imsnif/bandwhich/releases to see if non-x86_64 builds are available."
fi

if [ ! -d /etc/restic-backup ]; then
  echo "Setting up restic scaffolding in /etc/restic-backup..."
  "$SCRIPT_DIR"/restic-scaffolding/install.sh
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
  chmod 0755 "$HOME/opt/bin/notify-me"
fi

if [ ! -e "$HOME/.config/dotfiles/no-netdata" ] && ! dpkg-query -W netdata >/dev/null; then
  echo "Install Netdata? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh --stable-channel --native-only
    setupnote "Netdata" \
      "- [ ] Listen on port 9998\n- [ ] Make accessible via Tailscale with HTTPS\n- [ ] Monitor all services for this server\n- [ ] Configure per [my Netdata config document](bear://x-callback-url/open-note?id=E9620D65-2100-46CB-A798-02EFA52B6BE5-57092-00053B45CF64BCAE)"
    sudo mkdir -p /etc/netdata/health.d
    sudo cp "$SCRIPT_DIR"/netdata/user_process_count.conf /etc/netdata/health.d/user_process_count.conf
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-netdata"
  fi
fi

echo "Customize MOTD..."
curl -s https://gist.githubusercontent.com/cdzombak/07c5d97e4186dcc73ac4452fbf816387/raw/9f9dd275c22c35649fe3c7b0eebd5e25a2b7d5f1/install.sh | sudo bash

_rm_avahi() {
  echo "Remove avahi-daemon ..."
  set +e
  sudo apt remove --purge -y avahi-daemon && sudo apt autoremove -y
  set -e
}
if dpkg-query -W avahi-daemon >/dev/null; then
  if is_server; then
    _rm_avahi
  else
    echo "Remove avahi-daemon? (y/N)"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then _rm_avahi; fi
  fi
fi

if is_tiny; then
  echo ""
  echo "--- Raspberry Pi & Similar ---"
  echo ""

  echo "Daily apt clean cron job ..."
  sudo apt-get install -y apt-daily-clean

  if is_raspbian && [ ! -e "$HOME/.config/dotfiles/no-disable-hdmi" ] && ! dpkg-query -W pi-disable-hdmi >/dev/null; then
    echo "Disable Raspberry Pi HDMI output? (y/N)"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      sudo apt-get install -y pi-disable-hdmi
    else
      echo "Won't ask again next time this script is run."
      touch "$HOME/.config/dotfiles/no-disable-hdmi"
    fi
  fi

  # TODO(cdzombak): offer to install pi reliability wifi check script/cronjob
  # TODO(cdzombak): watchdog
  # TODO(cdzombak): other Pi reliability stuff, to the extent it can be automated
fi

echo ""
echo "--- Nginx + Certbot ---"
echo ""

_install_certbot_snap() {
  _install_snapd
  sudo snap install --classic certbot
  sudo ln -s /snap/bin/certbot /usr/bin/certbot
  sudo mkdir -p /var/www/letsencrypt/.well-known/acme-challenge
  sudo chown -R www-data:www-data /var/www/letsencrypt
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

if profile_server && ! command -v nginx >/dev/null; then
  echo "Install nginx? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo apt install nginx

    mkdir -p "$HOME/src"
    git clone https://github.com/cdzombak/nginx_ensite.git "$HOME/src"/nginx_ensite
    pushd "$HOME/src"/nginx_ensite
    sudo make install
    popd

    if [ -e /etc/rsyslog.d/22-logzio-linux.conf ]; then
      echo "system appears to use logz.io"
      echo "Enter your logz.io token: "
      read -r LOGZ_TOKEN
      TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'logz-nginx')
      pushd "$TMP_DIR"
      curl -sLO https://github.com/logzio/logzio-shipper/raw/master/dist/logzio-rsyslog.tar.gz
      tar xzf logzio-rsyslog.tar.gz
      sudo rsyslog/install.sh -t nginx -a "$LOGZ_TOKEN" -l "listener.logz.io"
      popd
    fi
  fi

  echo "Install certbot (via snap)? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    _install_certbot_snap
  fi
fi

echo ""
echo "--- Docker ---"
echo ""

if [ ! -e "$HOME/.config/dotfiles/no-docker" ] && ! command -v docker >/dev/null; then
  echo "Install Docker? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    "$SCRIPT_DIR"/docker/docker-install.sh

    if [ -e /etc/rsyslog.d/22-logzio-linux.conf ]; then
      echo "system appears to use logz.io"
      echo "Enter your logz.io token: "
      read -r LOGZ_TOKEN
      "$SCRIPT_DIR/docker/setup-logz.sh" "$LOGZ_TOKEN"
      if [ -x /usr/sbin/netdata ]; then
        setupnote "logz.io docker shipper" \
          "- [ ] Ingest Prometheus metrics to Netdata (from \`127.0.0.1:6002\`; \`sudo /etc/netdata/edit-config go.d/prometheus.conf\`)"
      fi
      setupnote "Docker" \
        "- [ ] Run /opt/docker/gen-data-dhparam.sh (if needed for internal/Tailscale https-portal containers)"
    fi
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-docker"
  fi
fi

echo ""
echo "--- Logz.io ---"
echo ""

_logz_setup() {
  echo "Enter your logz.io token: "
  read -r LOGZ_TOKEN

  echo "syslog..."
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'logz-linux')
  pushd "$TMP_DIR"
  curl -sLO https://github.com/logzio/logzio-shipper/raw/master/dist/logzio-rsyslog.tar.gz
  tar xzf logzio-rsyslog.tar.gz
  sudo rsyslog/install.sh -t linux -a "$LOGZ_TOKEN" -l "listener.logz.io"
  popd

  if command -v nginx >/dev/null; then
    echo "nginx..."
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'logz-nginx')
    pushd "$TMP_DIR"
    curl -sLO https://github.com/logzio/logzio-shipper/raw/master/dist/logzio-rsyslog.tar.gz
    tar xzf logzio-rsyslog.tar.gz
    sudo rsyslog/install.sh -t nginx -a "$LOGZ_TOKEN" -l "listener.logz.io"
    popd
  fi

  if command -v docker >/dev/null; then
    echo "docker..."
    "$SCRIPT_DIR/docker/setup-logz.sh" "$LOGZ_TOKEN"
    if [ -x /usr/sbin/netdata ]; then
      setupnote "logz.io docker shipper" "- [ ] Ingest Prometheus metrics to Netdata (use 127.0.0.1:6002)"
    fi
  fi
}
if [ ! -e "$HOME/.config/dotfiles/no-logzio" ] && [ ! -e /etc/rsyslog.d/22-logzio-linux.conf ]; then
  echo "Setup log shipping to logz.io? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    _logz_setup
    # TODO(cdzombak): if Pi, review logrotate / rsyslog setup (ref. blog posts once complete)
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-logzio"
  fi
fi

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
    sudo apt-get update
    sudo apt-get install syncthing
    sudo systemctl enable syncthing@cdzombak.service
    setupnote "Syncthing" \
      "- [ ] Make GUI accessible via Tailscale\n- [ ] Set GUI password\n- [ ] Add ID to Syncthing Devices note\n- [ ] Start syncing folders as desired"
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
if dpkg-query -W golang >/dev/null 2>&1; then
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
    sudo chmod 0755 /etc/cron.daily/yt-dlp-update
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-yt-dlp"
  fi
fi
