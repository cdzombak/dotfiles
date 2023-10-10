#!/usr/bin/env bash
set -euo pipefail

# via https://stackoverflow.com/a/66723000
function screenIsLocked { [ "$(/usr/libexec/PlistBuddy -c "print :IOConsoleUsers:0:CGSSessionScreenIsLocked" /dev/stdin 2>/dev/null <<< "$(ioreg -n Root -d1 -a)")" = "true" ] && return 0 || return 1; }
function screenIsUnlocked { [ "$(/usr/libexec/PlistBuddy -c "print :IOConsoleUsers:0:CGSSessionScreenIsLocked" /dev/stdin 2>/dev/null <<< "$(ioreg -n Root -d1 -a)")" != "true" ] && return 0 || return 1; }

while screenIsLocked
do
   sleep 1
done

sleep 1

osascript -e 'tell application "Lunar" to quit'
while pgrep Lunar >/dev/null
do
   sleep 1
done
open -a Lunar
