#!/usr/bin/env bash
set -euo pipefail

TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'hosts-timer')
git clone "https://github.com/cdzombak/hosts-timer.git" "$TMP_DIR"
pushd "$TMP_DIR"
if [ -w /usr/local ]; then make install; else sudo make install; fi
popd
echo "cdzombak ALL=NOPASSWD: /usr/local/bin/hosts-timer" | sudo tee -a /etc/sudoers.d/cdzombak-hosts-timer > /dev/null
sudo chown root:wheel /etc/sudoers.d/cdzombak-hosts-timer
sudo chmod 440 /etc/sudoers.d/cdzombak-hosts-timer
# disable HN by default:
sudo hosts-timer -install news.ycombinator.com
sudo hosts-timer -install hckrnews.com
