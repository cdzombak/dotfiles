
alias staged='git diff --staged'

watch-run() {
    if [ $# -eq 0 ]
    then
        echo "Usage: watch-run COMMAND"
        echo "Watch the current filesystem tree for changes; run COMMAND when changes are detected."
        echo ""
        echo "Examples:"
        echo "    TEST_CONFIG='xyz' watch-run pytest"
        echo "    watch-run make test"
        return 1
    fi
    ag -l | entr $*
}

# Starts a webserver from the current directory.
#
# via https://github.com/andrewsardone/dotfiles/blob/master/zsh/.zfunctions/server
# via https://gist.github.com/1525217
#
# @param [optional, Integer] bind port number, default 8080.
function httpserver() {
    local port="${1:-8080}"
    open "http://localhost:${port}/" && python -m SimpleHTTPServer "$port"
}

function dates() {
    echo "
Format/result                   |       Command           |          Output
--------------------------------+-------------------------+----------------------------
YYYY-MM-DD_hh:mm:ss             | date +%F_%T             | $(date +%F_%T)
YYYYMMDD_hhmmss                 | date +%Y%m%d_%H%M%S     | $(date +%Y%m%d_%H%M%S)
YYYYMMDD_hhmmss (UTC version)   | date -u +%Y%m%d_%H%M%SZ | $(date -u +%Y%m%d_%H%M%SZ)
YYYYMMDD_hhmmss (with local TZ) | date +%Y%m%d_%H%M%S%Z   | $(date +%Y%m%d_%H%M%S%Z)
YYYYMMSShhmmss                  | date +%Y%m%d%H%M%S      | $(date +%Y%m%d%H%M%S)
YYYYMMSShhmmssnnnnnnnnn         | date +%Y%m%d%H%M%S%N    | $(date +%Y%m%d%H%M%S%N)
YYMMDD_hhmmss                   | date +%y%m%d_%H%M%S     | $(date +%y%m%d_%H%M%S)
Seconds since UNIX epoch:       | date +%s                | $(date +%s)
Nanoseconds only:               | gdate +%N               | $(gdate +%N)
Nanoseconds since UNIX epoch:   | gdate +%s%N             | $(gdate +%s%N)
ISO8601 UTC timestamp           | date -u +%FT%TZ         | $(date -u +%FT%TZ)
ISO8601 UTC timestamp + ms      | date -u +%FT%T.%3NZ     | $(date -u +%FT%T.%3NZ)
ISO8601 Local TZ timestamp      | date +%FT%T%Z           | $(date +%FT%T%Z)
YYYY-MM-DD (Short day)          | date +%F\(%a\)          | $(date +%F\(%a\))
YYYY-MM-DD (Long day)           | date +%F\(%A\)          | $(date +%F\(%A\))
"
}
