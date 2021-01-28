CYAN='\033[0;36m'
NC='\033[0m'

HINTS=(
    "Use ${CYAN}g_pip${NC} to work outside a virtualenv."
    "Use ${CYAN}psgrep${NC} to look for running processes."
    "${CYAN}git-stage-missing${NC} will stage missing files for removal."
    "Use ${CYAN}lsz${NC} to list files in a tar/zip archive."
    "Use ${CYAN}cpwd${NC} to copy the path to the current working directory."
    "${CYAN}cpv${NC} is a robust cp alternative."
    "${CYAN}clipcopy${NC} and ${CYAN}clippaste${NC} are available."
    "${CYAN}httpserver${NC} serves the current directory on the given port (default 8080)."
    "Use ${CYAN}extract${NC} to extract most archives in the terminal."
    "Hit ${CYAN}ctrl-X ctrl-E${NC} to edit the entered command line in your editor."
    "Use ${CYAN}typora${NC}, ${CYAN}marked${NC}, ${CYAN}mded${NC}, or ${CYAN}mdcat${NC} to work with Markdown documents."
    "Use ${CYAN}mdf${NC} to make a directory and switch to it."
    "Use ${CYAN}pfd${NC} or ${CYAN}pfs${NC} to print the current Finder directory or selection."
    "Use ${CYAN}cdf${NC}, ${CYAN}pushdf${NC}, or ${CYAN}ff${NC} to switch to the current Finder directory."
    "Type ${CYAN}cbp${NC} to preview the clipboard in ${CYAN}less${NC}."
    "Use ${CYAN}pyclean${NC} to cleanup Python bytecode in the current or given directories."
    "Use ${CYAN}hsgrep${NC} to grep through shell history."
    "${CYAN}fd${NC} is a user-friendly ${CYAN}find${NC} alternative: ${CYAN}https://github.com/sharkdp/fd${NC}"
    "${CYAN}ag${NC} is a great code search tool: ${CYAN}https://github.com/ggreer/the_silver_searcher${NC}"
    "${CYAN}disable/enable-auto-title${NC} are available."
    "Use ${CYAN}shellcheck${NC} to check shell scripts for potential problems."
    "${CYAN}watch-reload-chrome/safari${NC} to refresh your browser when your codebase changes."
    "${CYAN}watch-run <command>${NC} to run ${CYAN}<command>${NC} when the current filesystem tree changes."
    "Syntax is ${CYAN}screen -DR [name]${NC} to open a screen."
    "Run ${CYAN}ssc${NC} instead of ${CYAN}ssh${NC} to SSH into a machine & open a screen."
    "${CYAN}wx${NC} and ${CYAN}metar${NC} are available for weather checks."
    "Use ${CYAN}!\$${NC} to repeat the last argument of the previous command."
    "Use ${CYAN}gi <language/platform>${NC} to fetch a gitignore template from ${CYAN}https://www.gitignore.io${NC}"
    "${CYAN}hsgrep${NC} will grep through history."
    "Run ${CYAN}hist${NC} to look at the most recent 100 commands in history."
    "${CYAN}_1${NC}, ${CYAN}_2${NC}, ... will grab the ${CYAN}n${NC}th column in a space separated line."
    "Run ${CYAN}ssc user@hostname${NC} to ssh to a host and open a screen there."
    "${CYAN}marks${NC} to list marks; ${CYAN}jump${NC} to jump to one; and ${CYAN}[un]mark${NC} to manage marks."
)

if [[ "$OSTYPE" == "darwin"* ]]; then
    HINTS=(
        "${HINTS[@]}"
        "${CYAN}Shift-Command-.${NC} will quickly toggle invisible files in Finder."
        "${CYAN}Command-Option-D${NC} will toggle Dock hiding."
        "${CYAN}itunes${NC} and ${CYAN}spotify${NC} are available for music control."
        "Use ${CYAN}trash${NC} to move something to the trash."
        "${CYAN}xc${NC} will open the Xcode workspace or project for the current directory."
        "${CYAN}pfs${NC} will list the current Finder selection."
        "${CYAN}finder [path]${NC} will open the given path or the current directory in Finder."
        "Use ${CYAN}pfd${NC} to print the current Finder directory.\n        ${CYAN}ff${NC}, ${CYAN}cdf${NC}, ${CYAN}pushdf${NC} to change to it."
        "Use ${CYAN}hide${NC} and ${CYAN}unhide${NC} to hide files/directories in Finder."
    )
fi

if [[ -z "$PIPENV_ACTIVE" ]] && [[ -z "$SSH_CLIENT" ]] && [[ -z "$SSH_TTY" ]]; then
    echo "\033[0;33m\ue0b0 Hint:${NC} ${HINTS[$(( $RANDOM % ${#HINTS[@]} + 1 ))]}\n"
fi

unset HINTS
unset CYAN
unset NC
