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

- [ ] Walk through System Preferences, configuring everything as desired
- [ ] Pay special attention to Security and Privacy, Energy and related
    - [ ] Turn FileVault on
    - [ ] 5 minutes to screen saver, 5 second delay before locking screen
    - [ ] 2 minutes to screen off when on battery
- [ ] Sync keyboard shortcuts configuration with current favorite system (screnshots in \`~/Sync/Configs\`)
- [ ] Customize Touch Bar based on screenshot in \`~/Sync/Configs\`
- [ ] Configure share/action extensions as desired

## Apple Pay

- [ ] Add current cards to Apple Pay, as desired
- [ ] Set address correctly

## Dock

- [ ] Organize Dock based on screenshot in \`~/Sync/Configs\`

## Finder

- [ ] Configure toolbar based on screenshot in \`~/Sync/Configs\`
- [ ] Configure sidebar based on screenshot in \`~/Sync/Configs\`

## Mail

- [ ] Configure main, compose, and viewer window toolbars based on screenshots in \`~/Sync/Configs\`

EOF
fi

cecho "✔ Created setup note at $HOME/SystemSetup.md" $green
