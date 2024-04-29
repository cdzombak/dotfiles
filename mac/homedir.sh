#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIB_DIR="$SCRIPT_DIR/../lib"
# shellcheck disable=SC1091
source "$LIB_DIR"/cecho

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS homedir setup because not on macOS"
  exit 2
fi

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/dotfiles"
mkdir -p "$HOME/.local/shell-completion"
mkdir -p "$HOME/Applications"
mkdir -p "$HOME/Library/LaunchAgents"
mkdir -p "$HOME/opt/bin"
mkdir -p "$HOME/opt/lib"
mkdir -p "$HOME/opt/sbin"
mkdir -p "$HOME/opt/share/man"
mkdir -p "$HOME/tmp"
mkdir -p "$HOME/Library/LaunchAgents"

if [ -d "$HOME/.shell-completion-local" ]; then
  if find "$HOME/.shell-completion-local" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    cp -R "$HOME/.shell-completion-local/"* "$HOME/.local/shell-completion"
  fi
  trash "$HOME/.shell-completion-local"
fi

if [ ! -d "$HOME/code" ] && [ ! -e "$HOME/.config/dotfiles/no-home-code-dir" ] ; then
  echo ""
  echo "Create ~/code and ~/3p_code? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mkdir -p "$HOME/3p_code"
    mkdir -p "$HOME/code"
  else
    touch "$HOME/.config/dotfiles/no-home-code-dir"
  fi
fi

if [ ! -d "$HOME/opt/docker" ] && [ ! -e "$HOME/.config/dotfiles/no-home-opt-docker-dir" ]; then
  echo ""
  echo "Create ~/opt/docker? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mkdir -p "$HOME/opt/docker/data"
    mkdir -p "$HOME/opt/docker/compose"
    if [ ! -e "$HOME/opt/docker/compose/.git" ]; then
      pushd "$HOME/opt/docker/compose" >/dev/null
      git init
      popd >/dev/null
    fi
  else
    echo "Won't ask again next time this script is run."
    touch "$HOME/.config/dotfiles/no-home-opt-docker-dir"
  fi
fi

if [ ! -d "$HOME/go" ] && [ ! -e "$HOME/.config/dotfiles/no-home-go-dir" ] ; then
  echo ""
  echo "Create ~/go/bin and ~/go/src? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mkdir -p "$HOME/go/bin"
    mkdir -p "$HOME/go/src"
  else
    touch "$HOME/.config/dotfiles/no-home-go-dir"
  fi
fi

# Integrate iCloud Drive & Syncthing into ~ via symlinks:
# even if Syncthing isn't setup yet, create broken links to ~/Sync; they'll work later

if [ ! -L "$HOME/Dropbox" ]; then
  ln -s "$HOME/Sync" "$HOME/Dropbox"
fi
if [ -L "$HOME/Dropbox" ]; then
  chflags -h hidden "$HOME/Dropbox"
fi

if [ ! -L "$HOME/env" ] && [ ! -e "$HOME/.config/dotfiles/no-home-env-dir" ]; then
  echo ""
  echo "Create ~/env (synced via Syncthing)? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    ln -s "$HOME/Sync/env" "$HOME/env"
  else
    touch "$HOME/.config/dotfiles/no-home-env-dir"
  fi
fi
if [ -e "$HOME/env" ]; then
  chflags -h hidden "$HOME/env"
fi

if [ -e "$HOME/Sync/globalstignore" ]; then
  chflags -h hidden "$HOME/Sync/globalstignore"
fi

if [ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]; then

  if [ ! -L "$HOME/iCloud Drive" ]; then
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/iCloud Drive"
  fi

  if [ ! -L "$HOME/Applications/macOS Utilities" ]; then
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Software/macOS Utilities" "$HOME/Applications/macOS Utilities"
  fi

  if [ ! -L "$HOME/Applications/macOS Security Tools" ]; then
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Software/macOS Security Tools" "$HOME/Applications/macOS Security Tools"
  fi

  if [ ! -L "$HOME/Downloads/iCloud" ]; then
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Downloads" "$HOME/Downloads/iCloud"
  fi

  if [ ! -L "$HOME/Pictures/iCloud" ]; then
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Pictures" "$HOME/Pictures/iCloud"
  fi

  if [ ! -L "$HOME/tmp/iCloud" ]; then
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Temp" "$HOME/tmp/iCloud"
  fi

  if [ -L "$HOME/Books and Articles" ] ; then
    rm "$HOME/Books and Articles"
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Cloud Library" "$HOME/Cloud Library"
  fi

  if [ ! -L "$HOME/Cloud Library" ] && [ ! -e "$HOME/.config/dotfiles/no-home-booksandarticles-dir" ] ; then
    echo ""
    echo "Create link to iCloud Drive/Cloud Library in home directory? (y/N)"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Cloud Library" "$HOME/Cloud Library"
    else
      touch "$HOME/.config/dotfiles/no-home-booksandarticles-dir"
    fi
  fi

  if { [ ! -L "$HOME/Desktop/iCloud" ] || [ ! -L "$HOME/Documents/iCloud" ] ;} && [ ! -e "$HOME/.config/dotfiles/no-home-icloud-links" ]; then
    echo "Create links from Desktop/Documents to iCloud Drive? (y/N)"
    echo "(eg. ~/Documents/iCloud, etc.)"
    cecho "nb. Answer NO if this system will use Documents/Desktop iCloud sync." $white
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Desktop" "$HOME/Desktop/iCloud"
      ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents" "$HOME/Documents/iCloud"
    else
      touch "$HOME/.config/dotfiles/no-home-icloud-links"
    fi
  fi

fi

# Misc. cleanup:

if [ -e "$HOME/Pictures/Photo Booth Library" ]; then
  chflags -h hidden "$HOME/Pictures/Photo Booth Library"
fi

if [ -e "$HOME/Creative Cloud Files" ]; then
  chflags -h hidden "$HOME/Creative Cloud Files"
fi

if [ ! -L "$HOME/.config/ForkLift" ] && [ -d "$HOME/Library/Application Support/ForkLift" ]; then
  ln -s "$HOME/Library/Application Support/ForkLift" "$HOME/.config/ForkLift"
fi

chflags -h nohidden "$HOME/Public"
chflags -h hidden "$HOME/Public/Drop Box"

if [ -d "$HOME/Sites" ]; then
  chflags -h hidden "$HOME/Sites"
fi

echo "Hide ~/Movies entirely? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  chflags -h hidden "$HOME/Movies"
else
  echo "Hide ~/Movies/TV (autogenerated by macOS)? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mkdir -p "$HOME/Movies/TV"
    chflags -h hidden "$HOME/Movies/TV"
  fi
fi

echo "Hide ~/Music entirely? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  chflags -h hidden "$HOME/Music"
else
  echo "Hide Logic files in ~/Music (~/Music/Audio Music Apps, ~/Music/Logic)? (y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if [ ! -e "$HOME/Music/(Logic files hidden).txt" ]; then
      # shellcheck disable=SC2088
      echo -e "~/Music/Audio Music Apps, ~/Music/Logic were hidden by $0.\n\nUnhide then via \`unhide\` command as desired.\n" > "$HOME/Music/(Logic files hidden).txt"
    fi
    mkdir -p "$HOME/Music/Audio Music Apps"
    chflags -h hidden "$HOME/Music/Audio Music Apps"
    mkdir -p "$HOME/Music/Logic"
    chflags -h hidden "$HOME/Music/Logic"
  fi
fi
