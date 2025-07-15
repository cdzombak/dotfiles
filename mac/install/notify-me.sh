#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/opt/bin/notify-me" ]; then
rm "$HOME/opt/bin/notify-me"
fi
if [ -e "$HOME/.netrc" ] && ! grep -c "dropbox.dzombak.com login cdzombak password PUT_" "$HOME/.netrc" >/dev/null; then
curl -f -s --netrc --output "$HOME/opt/bin/notify-me" https://dropbox.dzombak.com/_auth/notify-me
else
curl -f -u cdzombak --output "$HOME/opt/bin/notify-me" https://dropbox.dzombak.com/_auth/notify-me
fi
chmod 755 "$HOME/opt/bin/notify-me"
