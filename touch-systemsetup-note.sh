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

- [x] Run setup scripts (\`make mac\`)
- [ ] Set up Solarized Dark profile in Terminal.app as the default
    - [ ] Reset font to Meslo LG M for Powerline after initial install
- [ ] Rename "Macintosh HD"
- [ ] Add network interface(s) to Pi-Hole Adblocking group

## System Preferences

- [ ] Walk through System Preferences, configuring as desired (see details below)

Consider running \`plistwatch\` while configuring, to capture additional scriptable configuration.

### Pay special attention to Security & Privacy, Energy, and related

- [ ] Enable FileVault
- [ ] Enable Firewall
- [ ] Allow unlocking machine with Apple Watch
- [ ] Allow apps downloaded from: App Store and identified developers
- [ ] 5 minutes to screen saver; 5 second delay before locking screen
- [ ] 2 minutes to screen off when on battery; 10 minutes on AC
- [ ] Review other Energy settings as desired
    - [ ] Enable optimizing video streaming while on battery
- [ ] Name Touch ID finger & add the other index finger
- [ ] Find My Mac & Find My Network

### Apple ID & iCloud

- [ ] Enable iCloud, except Contacts & Mail
    - [ ] Enable "Optimize Mac Storage" for iCloud Drive & Photos, as desired
    - [ ] Enable Desktop & Documents folders, as desired
- [ ] Enable Touch ID for purchases

### Apple Pay

- [ ] Add current cards to Apple Pay, as desired
- [ ] Set address correctly
- [ ] Set default card

### Bluetooth

- [ ] Pair AirPods Pro
- [ ] AirPods Pro: **Set to reconnect to this Mac only when last connected**

### Desktop & Screen Saver

- [ ] Customize as desired
- [ ] Install Aqueux desktops package

### Extensions

- [ ] Configure share/action extensions as desired

### Internet Accounts

- [ ] Sign into personal & work Google accounts; enable Mail/Contacts/Calendars only

### Keyboard

- [ ] Reassign Caps Lock to Ctrl
- [ ] Turn off "correct spelling automatically," "capitalize words automatically," "add period with double-space"
- [ ] Sync keyboard shortcuts configuration with current favorite system (screenshots in \`~/Sync/Configs\`)
    - [ ] Customize available services as desired
- [ ] Enable Dictation + Enhanced Dictation
    - [ ] Set shortcut: right Command key twice (unless keyboard has dictation key on F5)

### Network

- [ ] Add home VPN config
    - [ ] Enable 'Send All Traffic Over VPN'
- [ ] Show VPN status in menu bar; hide in Bartender Bar

### Notifications

- [ ] Disable entirely for Books, Calendars, Games, Home, Mail, Music, Reminders
- [ ] Adjust other preferences as desired

### Printers & Scanners

- [ ] Install home printer

### Sharing (as desired)

- [ ] Enable Remote Login (SSH/SFTP)

### Siri

- [ ] Disable Ask Siri

### Software Update

- [ ] Enable all options except auto-install major macOS updates

### Sound

- [ ] Alerts play through selected sound output device
- [ ] Set alert volume to ~75%

### Spotlight

- [ ] Exclude \`~/code\`, \`~/3p_code\`, \`~/go\` and any other high-churn directories

### Users & Groups

- [ ] Disable guest access
- [ ] Audit login items
- [ ] Set account photo

## Dock

- [ ] Organize Dock based on screenshots in \`~/Sync/Configs\` (or current favorite system)

## Finder

- [ ] Configure toolbar based on screenshot in \`~/Sync/Configs\` (or current favorite system)
- [ ] Configure sidebar based on screenshot in \`~/Sync/Configs\` (or current favorite system)

## Mail

- [ ] Configure main, compose, and viewer window toolbars based on screenshots in \`~/Sync/Configs\` (or current favorite system)
- [ ] Check messages automatically
- [ ] Set message fonts
- [ ] Notifications: badges & notification center only; no sound
- [ ] Arrange sidebar; set Favorites

## Messages

- [ ] Sign into iCloud & enable Messages in iCloud
- [ ] Disable notifications for messages from unknown contacts
- [ ] Set Do Not Disturb for active group threads
- [ ] Enable iPhone sending SMS to this Mac
- [ ] Notifications: show previews only when unlocked
- [ ] Increase font size

## Notification Center

- [ ] Configure based on screenshot in \`~/Sync/Configs\` (or current favorite system)

## Safari

- [ ] Walk through Preferences, configuring as desired
    - [ ] Enable Develop menu
    - [ ] Disable AutoFill (in favor of [1Password 7.7+](https://blog.1password.com/big-sur-1password-7-7/))
- [ ] Configure toolbar based on screenshot in \`~/Sync/Configs\` (or current favorite system)
- [ ] Set homepage for new windows: \`https://start.dzdz.cz/\`
- [ ] New tabs open with start page

## Desk Setup

- [ ] Pair with Bluetooth keyboard
    - [ ] Change Caps Lock to Control in Keyboard preferences
- [ ] Run \`mouse-tracking\` script as appropriate (eg. \`mouse-tracking home\`)
- [ ] Display setup
    - [ ] Change display resolution as needed
    - [ ] Change display arrangement as needed
    - [ ] Confirm 5k/60Hz resolution via System Information app
- [ ] Pair with Sony ANC Headphones as desired

## SSH

- [ ] Verify base Git config is installed
- [ ] Clone: \`git clone https://github.com/cdzombak/sshconfig.git .ssh\`
- [ ] \`./.ssh/fix_permissions.sh\`
- [ ] Enable config templates as needed (see: Secretive or yubikey-agent setup)

## Shortcuts.app

- [ ] Add items to Menu Bar as desired
- [ ] Arrange Menu Bar icon next to FastScripts

## Stickies.app

- [ ] Set default note as floating on top & slightly larger font size

EOF
fi  # Darwin

cecho "✔ Setup note lives at $HOME/SystemSetup.md" $green
