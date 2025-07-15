#!/usr/bin/env bash
set -euo pipefail

defaults write net.shinyfrog.bear NSUserKeyEquivalents '{
    Archive = "^$a";
    Back = "@^\U2190";
    Forward = "@^\U2192";
}'
