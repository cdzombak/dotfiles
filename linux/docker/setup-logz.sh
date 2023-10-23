#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ $# -ne 1 ]; then
  echo "usage: $(basename "$0") LOGZIO_TOKEN"
  exit 1
fi

sudo mkdir -p /opt/docker/compose/logzio
sudo cp "$SCRIPT_DIR"/logz-docker-compose.yml /opt/docker/compose/logzio/docker-compose.yml
sudo chown -R root:docker /opt/docker/compose/logzio
sudo chmod 0775 /opt/docker/compose/logzio
sudo chmod 0660 /opt/docker/compose/logzio/docker-compose.yml
sudo sed -i "s/__MYLOGZIOTOKEN__/$1/g" /opt/docker/compose/logzio/docker-compose.yml
pushd /opt/docker/compose/logzio
sudo docker compose up -d
popd
