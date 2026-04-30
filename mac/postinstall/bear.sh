#!/usr/bin/env bash
set -euo pipefail

defaults write net.shinyfrog.bear NSUserKeyEquivalents '{
    Archive = "@^a";
    Back = "@[";
    Forward = "@]";
}'

ln -sfn "/Applications/Bear.app/Contents/MacOS/bearcli" /usr/local/bin/bearcli
