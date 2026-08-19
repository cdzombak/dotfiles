#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"
STATUSLINE='{"type":"command","command":"~/.dotfiles/claude_code/statusline.sh"}'

if [ ! -d "$CLAUDE_DIR" ]; then
  echo "$CLAUDE_DIR does not exist; skipping Claude Code statusline install."
  exit 0
fi

if [ ! -e "$SETTINGS" ]; then
  jq -n --argjson sl "$STATUSLINE" '{statusLine: $sl}' > "$SETTINGS"
  echo "Created $SETTINGS with statusLine."
  exit 0
fi

if ! jq -e 'type == "object"' "$SETTINGS" >/dev/null 2>&1; then
  echo "$SETTINGS is not a JSON object; refusing to modify it." >&2
  exit 1
fi

if jq -e --argjson sl "$STATUSLINE" '.statusLine == $sl' "$SETTINGS" >/dev/null; then
  exit 0
fi

TMP=$(mktemp "$CLAUDE_DIR/settings.json.XXXXXX")
jq --argjson sl "$STATUSLINE" '.statusLine = $sl' "$SETTINGS" > "$TMP"
chmod 644 "$TMP"
mv "$TMP" "$SETTINGS"
echo "Set statusLine in $SETTINGS."
