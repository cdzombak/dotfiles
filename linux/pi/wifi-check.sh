#!/usr/bin/env bash
set -uo pipefail

PROGNAME="$(basename $0)"
function my_log() {
  >&2 echo "$1"
  systemd-cat -t "$PROGNAME" echo "$1"
  wall "$1"
}

PING_TARGET="${PING_TAGRET:-192.168.1.1}"
WLAN_IF="${WLAN_IF:-wlan0}"

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

my_log "connection to $PING_TARGET appears down; restarting $WLAN_IF and dhcpd!"
sudo ip link set "$WLAN_IF" down
sleep 10
sudo ip link set "$WLAN_IF" up
sudo systemctl restart dhcpcd

sleep 30
if ping -i5 -c10 "$PING_TARGET" > /dev/null; then
  exit 0
fi

my_log "connection to $PING_TARGET remains down; restarting networking!!"
sudo systemctl restart networking

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
