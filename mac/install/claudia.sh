#!/usr/bin/env bash
set -euo pipefail
trap 'echo "exit $? at line $LINENO from: $BASH_COMMAND"' ERR

TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'remotehelperapp-work')
pushd "$TMP_DIR"

git clone https://github.com/getAsterisk/claudia.git
cd claudia
bun install
bun run tauri build

cp -R src-tauri/target/release/claudia "$HOME"/Applications/

popd
