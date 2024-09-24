#!/usr/bin/env bash
set -uo pipefail

PROGNAME="$(basename "$0")"
function my_log() {
  >&2 echo "$1"
  systemd-cat -t "$PROGNAME" echo "$1"
  wall "$1"
}

WLAN_IF="${WLAN_IF:-wlan0}"
WLAN_GW=$(ip route show 0.0.0.0/0 dev "$WLAN_IF" | cut -d' ' -f3)
PING_TARGET="${PING_TARGET:-$WLAN_GW}"

if ping -i5 -c10 "$PING_TARGET" > /dev/null; then
  exit 0
fi

if sudo iw dev "$WLAN_IF" get power_save | grep -c -i ": on" >/dev/null; then
  my_log "connection to $PING_TARGET appears down; disabling power_save for $WLAN_IF"
  sudo iw dev "$WLAN_IF" set power_save off

  if ping -i5 -c10 "$PING_TARGET" > /dev/null; then
    exit 0
  fi
fi

my_log "connection to $PING_TARGET appears down; restarting $WLAN_IF (+DHCP)!"
if systemctl is-active --quiet dhcpd; then
  # bullseye, buster(?)
  sudo ip link set "$WLAN_IF" down
  sleep 10
  sudo ip link set "$WLAN_IF" up
  sudo systemctl restart dhcpcd
elif [ -x /usr/bin/nmcli ]; then
  # bookworm
  sudo nmcli device down "$WLAN_IF"
  sudo pkill dhclient
  sleep 10
  sudo nmcli device up "$WLAN_IF"
fi

sleep 30
if ping -i5 -c10 "$PING_TARGET" > /dev/null; then
  exit 0
fi

my_log "connection to $PING_TARGET remains down; restarting networking.service!!"
sudo systemctl stop networking
  sleep 10
sudo systemctl start networking

sleep 30
if ping -i5 -c10 "$PING_TARGET" > /dev/null; then
  exit 0
fi

my_log "connection to $PING_TARGET remains down; will reboot shortly!!!"
sleep 15
if ping -i5 -c10 "$PING_TARGET" > /dev/null; then
  exit 0
fi

sudo reboot now
