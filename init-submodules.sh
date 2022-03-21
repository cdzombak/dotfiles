#!/usr/bin/env bash
set -euo pipefail

# Fetch all submodules on macOS:
if [ "$(uname)" == "Darwin" ]; then
  git submodule update --init
  exit 0
fi
