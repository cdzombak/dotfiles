alias diskspace='diskspace -H'

# Find bundle ID for an app, via http://brettterpstra.com/2012/07/31/overthinking-it-fast-bundle-id-retrieval-for-mac-apps/
bid() {
  local shortname location

  # combine all args as regex
  # (and remove ".app" from the end if it exists due to autocomplete)
  shortname=$(echo "${@%%.app}"|sed 's/ /.*/g')
  # if the file is a full match in apps folder, roll with it
  if [ -d "/Applications/$shortname.app" ]; then
    location="/Applications/$shortname.app"
  else # otherwise, start searching
    location=$(mdfind -onlyin /Applications -onlyin ~/Applications -onlyin /Developer/Applications 'kMDItemKind==Application'|awk -F '/' -v re="$shortname" 'tolower($NF) ~ re {print $0}'|head -n1)
  fi
  # No results? Die.
  [[ -z $location || $location = "" ]] && echo "$1 not found, I quit" && return
  # Otherwise, find the bundleid using spotlight metadata
  bundleid=$(mdls -name kMDItemCFBundleIdentifier -r "$location")
  # return the result or an error message
  [[ -z $bundleid || $bundleid = "" ]] && echo "Error getting bundle ID for \"$@\"" || echo "$location: $bundleid"
}

# hide/unhide files in Finder:
hide() {
    chflags -h hidden "$@"
}
compdef _files hide
unhide() {
    chflags -h nohidden "$@"
}
compdef _files unhide

# remove quarantine xattr, recursively:
alias unquar='xattr -r -d com.apple.quarantine'

# get attention
ding() {
    setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
    afplay /System/Library/Sounds/Glass.aiff &
    (sleep 0.5 ; afplay /System/Library/Sounds/Glass.aiff) &
    (sleep 1 ; afplay /System/Library/Sounds/Glass.aiff) &
    terminal-notifier -title "🔔" -message "ding" -ignoreDnD
}

function uti-info() {
    if [ -z "$1" ]; then
        echo "usage: uti-info FILE"
        return 1
    fi
    mdls "$1" | grep "kMDItemContentType "
}

# https://raw.github.com/robbyrussell/oh-my-zsh/master/plugins/osx/osx.plugin.zsh

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

# Remove .DS_Store files recursively in a directory, default .
function rmdsstore() {
  find "${@:-.}" -type f -name .DS_Store -delete
}
