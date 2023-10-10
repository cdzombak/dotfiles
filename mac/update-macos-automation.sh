#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macos-automation update because not on macOS"
  exit 2
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TARGET_DIR="$SCRIPT_DIR/../macos-automation"

if [ ! -d "$TARGET_DIR" ]; then
  git clone https://github.com/cdzombak/macos-automation.git "$TARGET_DIR"
else
  pushd "$TARGET_DIR" >/dev/null
  if [[ $(git status --porcelain) ]]; then
    cecho "[!] skipping update due to dirty working tree:" $yellow
    git status
  else
    git pull --rebase
    "$TARGET_DIR"/script/restore-resources.sh
  fi
  popd >/dev/null
fi
