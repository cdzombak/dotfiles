#!/usr/bin/env bash
set -eu

source ./lib/cecho

if [[ -f "$HOME/SystemSetup.md" ]]; then
  cecho "✔ Setup note exists at $HOME/SystemSetup.md" $green
  exit 0
fi

cat << EOF > "$HOME/SystemSetup.md"
# System Setup tasks
> Started at $(date +"%F %T %Z")

EOF

if [ "$(uname)" == "Darwin" ]; then
  cat << EOF > "$HOME/SystemSetup.md"

- [ ] Set up Solarized Dark profile in Terminal.app as the default
- [x] Run setup scripts (\`make mac\`)

## System Preferences

- [ ] Go through System Preferences, configuring as desired
    - [ ] FileVault on
    - [ ] Pay special attention to Security and Privacy, Energy and related
- [ ] Add current cards to Apple Pay, as desired
- [ ] Sync keyboard shortcuts configuration with current favorite system (screnshots in \`~/Sync/Configs\`)
- [ ] Customize Touch Bar based on screenshot in \`~/Sync/Configs\`

## Dock

- [ ] Organize Dock based on screenshot in \`~/Sync/Configs\`

## Finder.app

- [ ] Configure toolbar based on screenshot in \`~/Sync/Configs\`
- [ ] Configure sidebar based on screenshot in \`~/Sync/Configs\`

## Mail.app

- [ ] Configure main, compose, and viewer window toolbars based on screenshots in \`~/Sync/Configs\`

EOF
fi

cecho "✔ Created setup note at $HOME/SystemSetup.md" $green
