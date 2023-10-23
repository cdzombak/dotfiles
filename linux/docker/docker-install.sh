#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/"$(lsb_release -is | tr '[:upper:]' '[:lower:]')"/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt -y update
sudo apt install docker-ce -y

sudo cp -f "$SCRIPT_DIR"/daemon.json /etc/docker/daemon.json
sudo chown root:docker /etc/docker/daemon.json

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
