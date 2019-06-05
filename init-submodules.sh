#!/usr/bin/env bash
set -eux

# Fetch all submodules on macOS:
if [ "$(uname)" == "Darwin" ]; then
  git submodule update --init
  exit 0
fi

# Fetch bare minimum required submodules for Linux:
git submodule update --init -- nano/.nano
