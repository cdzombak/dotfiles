#!/usr/bin/env bash
set -euo pipefail

cd /etc/restic-backup
source ./restic-cfg

TMP_DIR=$(mktemp -d 2>/dev/null)
cp ./include-files.txt "$TMP_DIR"
cp ./excludes.txt "$TMP_DIR"

if [ -d /etc/restic-backup/pre-backup.d ] && [ -n "$(ls -A /etc/restic-backup/pre-backup.d)" ]; then
  echo "Running /etc/restic-backup/pre-backup.d..."
  for f in /etc/restic-backup/pre-backup.d/*; do
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

if [ -d /etc/restic-backup/backup.d ] && [ -n "$(ls -A /etc/restic-backup/backup.d)" ]; then
  echo "Running /etc/restic-backup/backup.d..."
  for f in /etc/restic-backup/backup.d/*; do
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
