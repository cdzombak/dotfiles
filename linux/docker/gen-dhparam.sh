#!/usr/bin/env bash
set -euo pipefail

# generate dhparam.pem for use in internal (Tailscale) https-portal[0]
# containers, so the container doesn't spend startup time generating them
# [0]: https://hub.docker.com/r/steveltn/https-portal

# /opt/docker/data/ is expected to exist and be writable by the user running
# this script (they should be in the sudo and docker groups)

openssl dhparam -out /opt/docker/data/dhparam.pem 2048
sudo chown root:docker /opt/docker/data/dhparam.pem
sudo chmod 0444 /opt/docker/data/dhparam.pem
