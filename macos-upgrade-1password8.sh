#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping 1Password 8 upgrade"
  exit 2
fi

if [ -e "/Applications/1Password 7.app" ]; then
  brew reinstall --cask 1password  # /Applications/1Password.app
  mas install 1569813296  # "/Applications/1Password for Safari.app"
  brew install --cask 1password-cli  # /usr/local/bin/op

  echo "# 1Password 8 Post-Upgrade Setup" > "$HOME/1Password8.md"
  echo "- [ ] Sign in to accounts: personal; work as needed" >> "$HOME/1Password8.md"
  echo "- [ ] Do not show in menu bar" >> "$HOME/1Password8.md"
  echo "- [ ] Start at login" >> "$HOME/1Password8.md"
  echo "- [ ] No keyboard shortcut for: Show 1Password; Lock 1Password" >> "$HOME/1Password8.md"
  echo "- [ ] Quick Access: Ctrl-Shift-Command-Backslash" >> "$HOME/1Password8.md"
  echo "- [ ] Autofill: Command-Backslash" >> "$HOME/1Password8.md"
  echo "- [ ] Appearance -> Density: Compact" >> "$HOME/1Password8.md"
  echo "- [ ] Security: enable unlock with Apple Watch" >> "$HOME/1Password8.md"
  echo "- [ ] Security: hold Option to toggle revealed fields" >> "$HOME/1Password8.md"
  echo "- [ ] Privacy -> Watchtower: Enable all Watchtower features" >> "$HOME/1Password8.md"
  echo "- [ ] Developer: enable biometric unlock for CLI" >> "$HOME/1Password8.md"
  echo "" >> "$HOME/1Password8.md"
  echo "## 1Password for Safari" >> "$HOME/1Password8.md"
  echo "- [ ] Enable in Safari" >> "$HOME/1Password8.md"
  echo "- [ ] Always allow on every site" >> "$HOME/1Password8.md"
  echo "- [ ] Show in Toolbar (arrange to left: Back/Forward, RSS, 1Password) " >> "$HOME/1Password8.md"
  echo "- [ ] Disable all Safari autofill features but \"Other Forms\"" >> "$HOME/1Password8.md"
  echo "" >> "$HOME/1Password8.md"
  open -a "Marked 2" "$HOME/1Password8.md"
else
  echo "Nothing to do."
fi
