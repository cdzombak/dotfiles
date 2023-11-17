#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# n.b. This is not a package because, while it provides a solid and reasonably
#      flexible foundation, it is expected that customizations will be needed
#      on different machines (e.g. to support multiple restic destinations with
#      different configurations)

sudo mkdir /etc/restic-backup
sudo chmod 0755 /etc/restic-backup
sudo mkdir /etc/restic-backup/backup.d
sudo chmod 0755 /etc/restic-backup/backup.d
sudo mkdir /etc/restic-backup/pre-backup.d
sudo chmod 0755 /etc/restic-backup/pre-backup.d
sudo cp "$SCRIPT_DIR"/backup.sh /etc/restic-backup
sudo chmod 0755 /etc/restic-backup/backup.sh
sudo cp "$SCRIPT_DIR"/excludes.txt /etc/restic-backup
sudo cp "$SCRIPT_DIR"/include-files.txt /etc/restic-backup
sudo cp "$SCRIPT_DIR"/keep.json /etc/restic-backup
sudo chmod 0644 /etc/restic-backup/*.json
sudo chmod 0644 /etc/restic-backup/*.txt
sudo cp "$SCRIPT_DIR"/restic-cfg /etc/restic-backup
sudo chmod 0755 /etc/restic-backup
sudo chown -R root:root /etc/restic-backup

sudo cp "$SCRIPT_DIR"/restic-backup.crontab /etc/cron.d/restic-backup
sudo chown root:root /etc/cron.d/restic-backup
sudo chmod 0644 /etc/cron.d/restic-backup

sudo mkdir /var/log/restic-backup
sudo chmod 0755 /var/log/restic-backup
