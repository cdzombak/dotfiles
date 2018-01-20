# https://raw.github.com/robbyrussell/oh-my-zsh/master/plugins/osx/osx.plugin.zsh

# add Sublime Text to env:
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export EDITOR='subl -w'

function pfd() {
  osascript 2>/dev/null <<EOF
    tell application "Finder"
      return POSIX path of (target of window 1 as alias)
    end tell
EOF
}

function pfs() {
  osascript 2>/dev/null <<EOF
    set output to ""
    tell application "Finder" to set the_selection to selection
    set item_count to count the_selection
    repeat with item_index from 1 to count the_selection
      if item_index is less than item_count then set the_delimiter to "\n"
      if item_index is item_count then set the_delimiter to ""
      set output to output & ((item item_index of the_selection as alias)'s POSIX path) & the_delimiter
    end repeat
EOF
}

function cdf() {
  cd "$(pfd)"
}

function pushdf() {
  pushd "$(pfd)"
}

function ff() {
  smart_pushd "$(pfd)"
}

function quick-look() {
  (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}

alias ql="quick-look"

function man-preview() {
  man -t "$@" | open -f -a Preview
}
compdef _man man-preview

function vncviewer() {
  open vnc://$@
}

function trash() {
  local trash_dir="${HOME}/.Trash"
  local temp_ifs=$IFS
  IFS=$'\n'
  for item in "$@"; do
    if [[ -e "$item" ]]; then
      item_name="$(basename $item)"
      if [[ -e "${trash_dir}/${item_name}" ]]; then
        mv -f "$item" "${trash_dir}/${item_name} $(date "+%H-%M-%S")"
      else
        mv -f "$item" "${trash_dir}/"
      fi
    fi
  done
  IFS=$temp_ifs
}

# Show/hide hidden files in the Finder
alias finder-show-invisibles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias finder-hide-invisibles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Move the Dock
alias dock-bottom="defaults write com.apple.Dock orientation -string bottom && killall Dock"
alias dock-left="defaults write com.apple.Dock orientation -string left && killall Dock"
alias dock-right="defaults write com.apple.Dock orientation -string right && killall Dock"

# preview the clipboard contents in less
alias cbp="pbpaste|less"

alias watch-reload-chrome="ag -l | entr reload-browser \"Google Chrome\""
alias watch-reload-safari="ag -l | entr reload-browser Safari"
