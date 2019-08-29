#!/usr/bin/env bash
set -eu

if [[ -f "$HOME/SystemSetup.md" ]]; then
  echo "✔ Setup note exists at $HOME/SystemSetup.md"
  exit 0
fi

cat << EOF > "$HOME/SystemSetup.md"
# System Setup tasks
> Started at $(date +"%F %T %Z")

EOF

echo "✔ Created setup note at $HOME/SystemSetup.md"
