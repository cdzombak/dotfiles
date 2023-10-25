#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

sudo mkdir -p /opt/tailscale/cert
sudo cp "$SCRIPT_DIR"/on-renew.sh /opt/tailscale/cert/on-renew.sh
sudo chmod 0750 /opt/tailscale/cert/on-renew.sh
sudo cp "$SCRIPT_DIR"/tailscale-cert.sh /etc/cron.weekly/tailscale-cert
sudo chmod 0750 /etc/cron.weekly/tailscale-cert

sudo /etc/cron.weekly/tailscale-cert
sudo mkdir /opt/tailscale/cert/https-portal
sudo ln /opt/tailscale/cert/cert.pem /opt/tailscale/cert/https-portal/signed.crt
sudo ln /opt/tailscale/cert/cert.pem /opt/tailscale/cert/https-portal/chained.crt
sudo ln /opt/tailscale/cert/key.pem /opt/tailscale/cert/https-portal/domain.key
sudo chown root:root /opt/tailscale/cert/https-portal
sudo chmod 0555 /opt/tailscale/cert/https-portal
sudo chown root:root /opt/tailscale/cert/https-portal/*
sudo chmod 0444 /opt/tailscale/cert/https-portal/*

sudo mkdir -p /etc/systemd/system/tailscaled.service.d
sudo chmod 0755 /etc/systemd/system/tailscaled.service.d
sudo cp "$SCRIPT_DIR"/override.conf /etc/systemd/system/tailscaled.service.d/override.conf
sudo chmod 0644 /etc/systemd/system/tailscaled.service.d/override.conf
sudo systemctl daemon-reload
