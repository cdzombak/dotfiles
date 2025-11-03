#!/usr/bin/env bash
set -euo pipefail

defaults write net.shinyfrog.bear NSUserKeyEquivalents '{
    Archive = "@^a";
    Back = "@[";
    Forward = "@]";
}'
