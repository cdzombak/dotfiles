#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ "$(uname)" == "Darwin" ]; then
  echo "Skipping bash-server setup because on macOS"
  exit 2
fi

mkdir -p opt/bin
mkdir -p opt/sbin
mkdir -p opt/lib
mkdir -p tmp
