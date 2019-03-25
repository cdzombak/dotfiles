CYAN='\033[0;36m'
NC='\033[0m'

HINTS=(
    "Use ${CYAN}g_pip[2/3]${NC} to work outside a virtualenv."
    "Use ${CYAN}psgrep${NC} to look for running processes."
    "${CYAN}git-stage-missing${NC} will stage missing files for removal."
    "Use ${CYAN}lsz${NC} to list files in a tar/zip archive."
    "${CYAN}cpv${NC} is a robust cp alternative."
    "${CYAN}clipcopy${NC} and ${CYAN}clippaste${NC} are available."
    "${CYAN}httpserver${NC} serves the current directory on the given port (default 8080)."
    "Use ${CYAN}extract${NC} to extract most archives in the terminal."
    "Hit ${CYAN}ctrl-X ctrl-E${NC} to edit the entered command line in your editor."
    "Use ${CYAN}byword${NC}, ${CYAN}marked${NC}, or ${CYAN}mded${NC} to work with Markdown documents."
    "${CYAN}itunes${NC} and ${CYAN}spotify${NC} are available for music control."
    "Use ${CYAN}mdf${NC} to make a directory and switch to it."
    "Use ${CYAN}pfd${NC} or ${CYAN}pfs${NC} to print the current Finder directory or selection."
    "Use ${CYAN}cdf${NC}, ${CYAN}pushdf${NC}, or ${CYAN}ff${NC} to switch to the current Finder directory."
    "Use ${CYAN}trash${NC} to move something to the trash."
    "macOS: ${CYAN}finder-show/hide-invisibles${NC} will quickly toggle invisible files in Finder."
    "macOS: ${CYAN}dock-bottom/left/right${NC} are available."
    "macOS: ${CYAN}Command+Option+D${NC} toggle Dock hiding."
    "Type ${CYAN}cbp${NC} to preview the clipboard in less."
    "Use ${CYAN}pyclean${NC} to cleanup Python bytecode in the current or given directories."
    "${CYAN}fd${NC} is a user-friendly ${CYAN}find${NC} alternative: https://github.com/sharkdp/fd"
    "${CYAN}ag${NC} is a great code search tool: https://github.com/ggreer/the_silver_searcher"
    "${CYAN}disable/enable-auto-title${NC} are available."
    "${CYAN}rg${NC} is a fast grep/ag alternative: https://github.com/BurntSushi/ripgrep/"
    "Use ${CYAN}shellcheck${NC} to check shell scripts for potential problems."
    "${CYAN}watch-reload-chrome/safari${NC} to refresh your browser when your codebase changes."
    "Syntax is ${CYAN}screen -DR [name]${NC} to open a screen."
    "Use ${CYAN}tldr${NC} for a quick ${CYAN}man${NC} alternative."
    "${CYAN}wx${NC} and ${CYAN}metar${NC} are available for weather checks."
    "Use ${CYAN}!\$${NC} to repeat the last argument of the previous command."
    "${CYAN}hsgrep${NC} will grep through history."
    "Run ${CYAN}hist${NC} to look at the most recent 100 commands in history."
)
echo "\033[0;33m\ue0b0 Hint:${NC} ${HINTS[$(( $RANDOM % ${#HINTS[@]} + 1 ))]}\n"

unset HINTS
unset CYAN
unset NC
