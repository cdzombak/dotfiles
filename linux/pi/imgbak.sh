#!/usr/bin/env bash
set -euo pipefail

#
# nb. if you get "mount(2) system call failed: No route to host" you need to install cifs-utils
# sudo apt-get install cifs-utils
#

HOSTNAME="$(hostname -s)"

mkdir -p /mnt/smb-pi-images
if ! mount | grep -c "smb-pi-images" >/dev/null ; then
  mount -t cifs -o username=pibackup,password="$SMBPASS" //jetstream.dzhome/pi-images /mnt/smb-pi-images
fi

if [ -f /mnt/smb-pi-images/"$HOSTNAME".img ]; then
  /mnt/smb-pi-images/image-utils/image-backup /mnt/smb-pi-images/"$HOSTNAME".img
else
  /mnt/smb-pi-images/image-utils/image-backup -i /mnt/smb-pi-images/"$HOSTNAME".img
fi

umount -t cifs /mnt/smb-pi-images
