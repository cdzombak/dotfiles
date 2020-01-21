#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" != "Linux" ]; then
  echo "Skipping Linux software setup because not on Linux"
  exit 2
fi

mkdir -p "$HOME/opt/bin"

if [ -x /usr/bin/apt ]; then
  echo "Installing packages via apt; this will require sudo..."
  set -x
  sudo apt update
  sudo apt install tig tree htop traceroute dnsutils
  set +e
  sudo apt install nnn # not available until Ubuntu 18.x; this is expected to fail on earlier systems
  set -e
  set +x
elif [ -x /usr/bin/dnf ]; then
  echo "Installing packages via dnf; this will require sudo..."
  set -x
  sudo dnf install tig tree htop nnn traceroute bind-utils
  set +x
elif [ -x /usr/bin/yum ]; then
  echo "Installing packages via yum; this will require sudo..."
  set -x
  sudo yum install tig tree htop nnn traceroute bind-utils
  set +x
else
  echo ""
  echo "[!] Could not find apt, dnf, or yum; don't know how to install packages on this system."
  echo ""
fi

# install dust: A more intuitive version of du in rust
echo "Installing dust..."
if [ -x "$HOME/opt/bin/dust" ]; then
  # remove outdated version:
  set +e
  if ! "$HOME/opt/bin/dust" -V | grep -c "0.4.4" >/dev/null ; then
    rm "$HOME/opt/bin/dust"
  fi
  set -e
fi
# TODO(cdzombak): this will break when this is run on arm or when dust releases a linux/arm binary
if [ ! -x "$HOME/opt/bin/dust" ]; then
  set -x
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'dust-work')
  pushd "$TMP_DIR"
  curl -s https://api.github.com/repos/bootandy/dust/releases/latest | jq -r ".assets[].browser_download_url" | grep "linux" | xargs wget -q -O dust.tar.gz
  tar xzf dust.tar.gz
  cp dust "$HOME/opt/bin"
  popd
  set +x
else
  echo "dust is already installed."
fi

# install my listening wrapper for netstat
echo "Installing listening..."
if [ ! -x "$HOME/opt/bin/listening" ]; then
  set -x
  pushd "$HOME/opt/bin"
  wget https://gist.githubusercontent.com/cdzombak/fc0c0acbba9c302571add6dcd6d10deb/raw/c607f9fcc182ecc5d0fcc844bff67c1709847b55/listening
  chmod +x listening
  popd
  set +x
else
  echo "listening is already installed."
fi

# install a more recent version of nano
echo "Installing a recent nano..."
NANO_V="4.4"
if [ -x "/usr/local/bin/nano" ]; then
  # remove outdated version:
  set +e
  if ! "/usr/local/bin/nano" -V | grep -c "$NANO_V" >/dev/null ; then
    sudo mv "/usr/local/bin/nano" "/usr/local/bin/nano.bak"
  fi
  set -e
fi
if [ ! -x "/usr/local/bin/nano" ]; then
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

  wget "https://www.nano-editor.org/dist/v4/nano-$NANO_V.tar.gz"
  tar -xzvf "nano-$NANO_V.tar.gz"
  cd "./nano-$NANO_V"

  ./configure \
    --prefix=/usr/local \
    --disable-libmagic \
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
