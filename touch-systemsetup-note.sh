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
- [ ] Run \`mouse-tracking\` script as appropriate

## System Preferences

- [ ] Walk through System Preferences, configuring as desired (see details below)

### Pay special attention to Security and Privacy, Energy, and related

- [ ] Turn FileVault on
- [ ] Enable Firewall
- [ ] Allow unlocking machine with Apple Watch
- [ ] 5 minutes to screen saver; 5 second delay before locking screen
- [ ] 2 minutes to screen off when on battery
- [ ] Review other Energy settings as desired
- [ ] Name Touch ID finger & add the other index finger

### Apple Pay

- [ ] Add current cards to Apple Pay, as desired
- [ ] Set address correctly

### Extensions

- [ ] Configure share/action extensions as desired

### iCloud & Internet Accounts

- [ ] Enable iCloud, except Contacts & maybe Mail
    - [ ] Enable "Optimize Mac Storage" for iCloud Drive & Photos, as desired
- [ ] Sign into personal & work Google accounts; enable Mail/Contacts/Calendars only

### Keyboard + Touch Bar

- [ ] Touch Bar Shows: Expanded Control Strip
- [ ] Fn key shows: F1, F2, …
- [ ] Customize Touch Bar based on screenshot in \`~/Sync/Configs\`
- [ ] Reassign Caps Lock to Ctrl
- [ ] Turn off "correct spelling automatically," "capitalize words automatically," "add period with double-space"
- [ ] Sync keyboard shortcuts configuration with current favorite system (screenshots in \`~/Sync/Configs\`)
    - [ ] Customize available services as desired
- [ ] Enable Dictation + Enhanced Dictation
    - [ ] Set shortcut: right Command key twice

### Sharing

- [ ] Enable Remote Access (SSH)

### Software Update

- [ ] Enable all options except auto-install macOS updates

### Siri

- [ ] Disable Siri, if necessary

## Dock

- [ ] Organize Dock based on screenshots in \`~/Sync/Configs\`

## Finder

- [ ] Configure toolbar based on screenshot in \`~/Sync/Configs\`
- [ ] Configure sidebar based on screenshot in \`~/Sync/Configs\`

## Mail

- [ ] Configure main, compose, and viewer window toolbars based on screenshots in \`~/Sync/Configs\`
- [ ] Set message fonts
- [ ] Disable new message sound
- [ ] Disable loading remote content in messages
- [ ] Notifications: badges & notification center only; no sound

## Messages

- [ ] Sign into iCloud & enable Messages in iCloud
- [ ] Disable notifications for messages from unknown contacts
- [ ] Set Do Not Disturb for active group threads
- [ ] Enable iPhone sending SMS to this Mac
- [ ] Notifications: never show notification preview

## Notification Center

- [ ] Configure based on screenshot in \`~/Sync/Configs\`

## Safari

- [ ] Walk through Preferences, configuring as desired
- [ ] Enable Develop menu
- [ ] Configure toolbar based on screenshot in \`~/Sync/Configs\`
EOF
fi

cecho "✔ Created setup note at $HOME/SystemSetup.md" $green
