#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" == "Darwin" ]; then
  echo "Skipping Linux software setup because on macOS"
  exit 2
fi

mkdir -p "$HOME/opt/bin"

echo "Installing packages from apt; this will require sudo..."
set -x
sudo apt update
sudo apt install tig tree htop traceroute dnsutils
set +e
sudo apt install nnn
set -e
set +x

# install dust: A more intuitive version of du in rust
echo "Installing dust..."
if [ -x "$HOME/opt/bin/dust" ]; then
  # remove outdated version:
  set +e
  if ! "$HOME/opt/bin/dust -V" | grep -c "0.4.4" >/dev/null ; then
    rm "$HOME/opt/bin/dust"
  fi
  set -e
fi
if [ ! -x "$HOME/opt/bin/dust" ]; then
  set -x
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'dust-work')
  pushd "$TMP_DIR"
  curl -s https://api.github.com/repos/bootandy/dust/releases/latest | jq -r ".assets[].browser_download_url" | grep "linux" | xargs wget -q -O dust.tar.gz
  tar xzf dust.tar.gz
  cp dust "$HOME/opt/bin"
  popd
  set +x
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
fi

# install a more recent version of nano
echo "Installing a recent nano..."
if [ ! -x "/usr/local/bin/nano" ]; then
  set -x
  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'nano-working')
  pushd "$TMP_DIR"

  sudo apt-get -y build-dep nano
  sudo apt-get -y install build-essential

  NANO_V="4.4"
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

  sudo apt-get remove nano
  sudo make install-strip
  sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nano 50

  popd # $TMP_DIR
  set +x

  echo ""
  echo "If necessary, run 'sudo update-alternatives --config editor' to select the new nano installation."
  echo ""
fi
