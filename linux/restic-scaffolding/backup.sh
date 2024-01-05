#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_DIR"
source ./restic-cfg

TMP_DIR=$(mktemp -d 2>/dev/null)
cp ./include-files.txt "$TMP_DIR"
cp ./excludes.txt "$TMP_DIR"

if [ -d "$SCRIPT_DIR"/pre-backup.d ] && [ -n "$(ls -A "$SCRIPT_DIR"/pre-backup.d)" ]; then
  echo "Running $SCRIPT_DIR/pre-backup.d..."
  for f in "$SCRIPT_DIR"/pre-backup.d/*; do
    echo "$f ..."
    bash "$f" "$TMP_DIR"
    echo ""
  done
fi

echo "Starting backup..."
restic backup --files-from "$TMP_DIR"/include-files.txt \
  --exclude-caches --exclude-if-present .restic-exclude \
  --exclude-file="$TMP_DIR"/excludes.txt
echo ""

if [ -d "$SCRIPT_DIR"/backup.d ] && [ -n "$(ls -A "$SCRIPT_DIR"/backup.d)" ]; then
  echo "Running $SCRIPT_DIR/backup.d..."
  for f in "$SCRIPT_DIR"/backup.d/*; do
    echo "$f ..."
    bash "$f"
    echo ""
  done
fi

echo "Running forget and prune..."
restic forget --prune \
  --keep-daily "$(jq .daily ./keep.json)" \
  --keep-weekly "$(jq .weekly ./keep.json)" \
  --keep-monthly "$(jq .monthly ./keep.json)"
echo ""

echo "Running check..."
restic check
echo ""

echo "Backup & checks completed successfully."
