#!/usr/bin/env bash
set -euo pipefail

# versions:
LATEST_BANDWHICH="0.20.0"
LATEST_DUST="0.6.0"
LATEST_RESTIC="0.12.0"
NANO_V5x="5.4"

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux software setup because not on Linux"
  exit 2
fi

echo "This script will use sudo; enter your password to authenticate if prompted."
# Ask for the administrator password upfront and run a keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

mkdir -p "$HOME/opt/bin"

if [ -x /usr/bin/apt ]; then
  echo "Installing common packages via apt..."
  set -x
  sudo apt -y update
  sudo apt -y install tig tree htop traceroute dnsutils screen molly-guard
  set +e
  echo "nnn is not available until Ubuntu 18.x; this installation is expected to fail on earlier systems:"
  sudo apt -y install nnn
  set -e
  set +x
elif [ -x /usr/bin/dnf ]; then
  echo "Installing common packages via dnf..."
  set -x
  sudo dnf -y install tig tree htop nnn traceroute bind-utils screen molly-guard
  set +x
elif [ -x /usr/bin/yum ]; then
  echo "Installing common packages via yum..."
  set -x
  sudo yum -y install tig tree htop nnn traceroute bind-utils screen molly-guard
  set +x
else
  echo ""
  echo "[!] Could not find apt, dnf, or yum; don't know how to install packages on this system."
  echo ""
fi

# install dust: A more intuitive version of du in rust
# see https://github.com/bootandy/dust/releases
echo "Installing dust..."
if [ -x "$HOME/opt/bin/dust" ]; then
  echo " Moving dust from ~ to /usr/local..."
  sudo mv "$HOME/opt/bin/dust" /usr/local/bin/dust
fi
if [ -x /usr/local/bin/dust ]; then
  # remove outdated version:
  if ! /usr/local/bin/dust -V | grep -c "$LATEST_DUST" >/dev/null ; then
    echo " Removing outdated dust..."
    sudo rm /usr/local/bin/dust
  fi
fi
if [ ! -x /usr/local/bin/dust ]; then
  set -x
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'dust-work')
  pushd "$TMP_DIR"
  if uname -a | grep -c -i arm >/dev/null; then
    curl -s "https://api.github.com/repos/bootandy/dust/releases/tags/v$LATEST_DUST" | jq -r ".assets[].browser_download_url" | grep "linux" | grep "arm" | xargs wget -q -O dust.tar.gz
  elif uname -a | grep -c -i x86_64 >/dev/null; then
    curl -s "https://api.github.com/repos/bootandy/dust/releases/tags/v$LATEST_DUST" | jq -r ".assets[].browser_download_url" | grep "linux-musl" | grep "x86_64" | xargs wget -q -O dust.tar.gz
  else
    curl -s "https://api.github.com/repos/bootandy/dust/releases/tags/v$LATEST_DUST" | jq -r ".assets[].browser_download_url" | grep "linux-musl" | grep "i686" | xargs wget -q -O dust.tar.gz
  fi
  tar xzf dust.tar.gz
  rm dust.tar.gz
  sudo cp ./dust*/dust /usr/local/bin
  sudo chmod +x /usr/local/bin/dust
  popd
  set +x
else
  echo "dust is already installed."
fi

# install bandwhich: Terminal bandwidth utilization tool
# see https://github.com/imsnif/bandwhich/releases
echo "Installing bandwhich..."
if [ -x "$HOME/opt/bin/bandwhich" ]; then
  echo " Moving bandwhich from ~ to /usr/local..."
  sudo mv "$HOME/opt/bin/bandwhich" /usr/local/bin/bandwhich
fi
if [ -x /usr/local/bin/bandwhich ]; then
  # remove outdated version:
  if ! /usr/local/bin/bandwhich -V | grep -c "$LATEST_BANDWHICH" >/dev/null ; then
    echo " Removing outdated bandwhich..."
    sudo rm /usr/local/bin/bandwhich
  fi
fi
if [ ! -x /usr/local/bin/bandwhich ]; then
  if uname -a | grep -c -i x86_64 >/dev/null; then
    set -x
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'bandwhich-work')
    pushd "$TMP_DIR"
    curl -s "https://api.github.com/repos/imsnif/bandwhich/releases/tags/$LATEST_BANDWHICH" | jq -r ".assets[].browser_download_url" | grep "linux-musl" | grep "x86_64" | xargs wget -q -O bandwhich.tar.gz
    tar xzf bandwhich.tar.gz
    rm bandwhich.tar.gz
    sudo cp ./bandwhich /usr/local/bin
    sudo chmod +x /usr/local/bin/bandwhich
    sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep /usr/local/bin/bandwhich
    popd
    set +x
  else
    echo "[!] Unsupported arch. bandwhich only has a build for x86_64; check https://github.com/imsnif/bandwhich/releases to see if this has changed."
  fi
else
  echo "bandwhich is already installed."
fi

# install restic: Fast, secure, efficient backup program
# see https://github.com/restic/restic/releases
echo "Installing restic..."
if [ -x /usr/local/bin/restic ]; then
  # remove outdated version:
  if ! /usr/local/bin/restic version | grep -c "$LATEST_RESTIC" >/dev/null ; then
    echo " Removing outdated restic..."
    sudo rm /usr/local/bin/restic
  fi
fi
if [ ! -x /usr/local/bin/restic ]; then
  set -x
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'dust-work')
  pushd "$TMP_DIR"
  if uname -a | grep -c -i arm >/dev/null; then
    # TODO(cdzombak): arm64 is also available, but I don't think I have any arm64 systems atm
    curl -s "https://api.github.com/repos/restic/restic/releases/tags/v$LATEST_RESTIC" | jq -r ".assets[].browser_download_url" | grep "linux" | grep "arm\." | xargs wget -q -O restic.bz2
  elif uname -a | grep -c -i x86_64 >/dev/null; then
    curl -s "https://api.github.com/repos/restic/restic/releases/tags/v$LATEST_RESTIC" | jq -r ".assets[].browser_download_url" | grep "linux" | grep "amd64" | xargs wget -q -O restic.bz2
  else
    curl -s "https://api.github.com/repos/restic/restic/releases/tags/v$LATEST_RESTIC" | jq -r ".assets[].browser_download_url" | grep "linux" | grep "386" | xargs wget -q -O restic.bz2
  fi
  bunzip2 restic.bz2
  sudo cp ./restic /usr/local/bin/restic
  sudo chmod +x /usr/local/bin/restic
  popd
  set +x
else
  echo "restic is already installed."
fi

# install my listening wrapper for netstat
echo "Installing listening..."
if [ ! -x "/usr/local/bin/listening" ]; then
  if [ -e "$HOME/opt/bin/listening" ]; then
    echo " Moving listening from ~ to /usr/local..."
    sudo mv "$HOME/opt/bin/listening" /usr/local/bin
  else
    set -x
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'listening-work')
    pushd "$TMP_DIR"
    wget https://gist.githubusercontent.com/cdzombak/fc0c0acbba9c302571add6dcd6d10deb/raw/c607f9fcc182ecc5d0fcc844bff67c1709847b55/listening
    chmod +x ./listening
    sudo mv ./listening /usr/local/bin
    popd
    set +x
  fi
else
  echo "listening is already installed."
fi

# install a more recent version of nano
echo "Installing a recent nano..."
if [ -x /usr/local/bin/nano ]; then
  # remove outdated version:
  if ! /usr/local/bin/nano -V | grep -c "$NANO_V5x" >/dev/null ; then
    sudo mkdir -p /usr/local/opt/nano/bin
    sudo mv /usr/local/bin/nano /usr/local/opt/nano/bin/nano.bak
  fi
fi
if [ ! -x /usr/local/bin/nano ]; then
  set -x
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'nano-working')
  pushd "$TMP_DIR"

  if [ -x /usr/bin/apt-get ]; then
    sudo apt-get -y install build-essential
    sudo apt-get -y build-dep nano
  elif [ -x /usr/bin/dnf ]; then
    sudo dnf -y group install "Development Tools"
    sudo dnf -y builddep nano
  elif [ -x /usr/bin/yum ]; then
    sudo yum -y groupinstall "Development Tools"
    sudo yum -y builddep nano
  else
    echo "[!] Don't know how to install build tools and dependencies. This may fail."
    echo "    (package manager is not apt, dnf, or yum)"
  fi

  wget "https://www.nano-editor.org/dist/v5/nano-$NANO_V5x.tar.gz"
  tar -xzvf "nano-$NANO_V5x.tar.gz"
  cd "./nano-$NANO_V5x"

  ./configure \
    --prefix=/usr/local \
    --enable-libmagic \
    --enable-utf8 \
    --enable-nanorc \
    --enable-color \
    --enable-multibuffer
  make

  if [ -x /usr/bin/apt-get ]; then
    sudo apt-get remove nano
  elif [ -x /usr/bin/dnf ]; then
    sudo dnf remove nano
  elif [ -x /usr/bin/yum ]; then
    sudo yum remove nano
  else
    echo "[!] Don't know how to remove the stock nano installation. Do this manually."
    echo "    (package manager is not apt, dnf, or yum)"
  fi

  sudo make install-strip
  sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nano 50

  popd # $TMP_DIR
  set +x

  echo ""
  echo "If necessary, run 'sudo update-alternatives --config editor' to select the new nano installation."
  echo ""
else
  echo "nano is already installed."
fi

if [ ! -L "$HOME/.local/.nano-root" ]; then
  mkdir -p "$HOME/.local"
  ln -s /usr/local "$HOME/.local/.nano-root"
fi

echo "Install/update my notify-me script? (requires auth to dropbox.dzombak.com/_auth) (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  if [ -f "$HOME/opt/bin/notify-me" ]; then
    rm "$HOME/opt/bin/notify-me"
  fi
  set -x
  curl -f -u cdzombak --output "$HOME/opt/bin/notify-me" https://dropbox.dzombak.com/_auth/notify-me
  chmod 755 "$HOME/opt/bin/notify-me"
  set +x
fi

if [ ! -e "$HOME/.local/dotfiles/no-ffmpeg-scripts" ]; then
  echo "Install/update my quick ffmpeg media conversion scripts? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    set -x
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'ffmpegscripts')
    git clone "https://github.com/cdzombak/quick-ffmpeg-scripts.git" "$TMP_DIR"
    pushd "$TMP_DIR"
    chmod +x ./install.sh
    ./install.sh
    popd
    set +x
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.local/dotfiles/no-ffmpeg-scripts"
  fi
fi
