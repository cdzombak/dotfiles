#!/bin/bash
set -euo pipefail

TS_IP=$(dig @100.100.100.100 +noall +answer +short -x  "$(tailscale ip -1)" | sed 's/.$//')
RESULT=$(tailscale cert --cert-file=/opt/tailscale/cert/cert.pem --key-file=/opt/tailscale/cert/key.pem "$TS_IP")
if [[ "$RESULT" == *"cert unchanged"* ]]; then
  echo "Cert is unchanged; skipping followup tasks."
  exit 0
fi

/opt/tailscale/cert/on-renew.sh
