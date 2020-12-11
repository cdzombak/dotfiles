# via http://brettterpstra.com/2013/03/14/more-command-line-handiness/
# updated per Lri's comment
alias psgrep="ps -Aco pid,comm | sed 's/^ *//'| sed 's/:/ /'|grep -iE"

# grab the nth column of space-separated lines
alias _1="cut -d\" \" -f1"
alias _2="cut -d\" \" -f2"
alias _3="cut -d\" \" -f3"
alias _4="cut -d\" \" -f4"
alias _5="cut -d\" \" -f5"

# json
alias jsonpp='jq .'

# ls
alias ls='ls -Fh'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# du/df (nb. dust also exists)
alias du='du -h'
alias duh='du -h -d 1'
alias df='df -h'

# mkdir/rmdir
alias rd='rmdir'
alias rdf='rm -rf'
alias md='mkdir'

# tofrodos is packaged for OSX in homebrew
alias dos2unix='fromdos'
alias unix2dos='todos'

# fuckingg macbooks
alias ggit='git'

# Sublime
alias subl='subl -n' # always open a new window when working from CLI
alias subl.='subl -n .' # I can't type

alias cpwd='pwd|tr -d "\n"|clipcopy'

# wake PC "edison" via SSH into curie-srv
alias wol-edison="ssh -t curie-remote \"/usr/local/bin/wakeonlan -i 192.168.1.255 -p 7 70:85:c2:22:b5:0b\""

# ssh with multiplexing (relies on ControlPath & etc set in ~/.ssh/config)
alias ssh-mux='ssh -o "ControlMaster=auto"'

# ssc: ssh to the given host and open a screen
function ssc {
    old_auto_title=$DISABLE_AUTO_TITLE
    title "$1"
    ssh -t "$1" bash -c "screen -DR"
    export DISABLE_AUTO_TITLE=$old_auto_title
}
compdef ssc=ssh

function start-torrent {
    ssh pi@torrentpi -o ProxyCommand="ssh curie-remote -W %h:%p" "transmission-remote -a \"$1\""
}

#function pihole-whitelist {
#    ssh pidns -o ProxyCommand="ssh curie-remote -W %h:%p" "sudo pihole -w \"$1\""
#}
#function pihole-disable {
#    ssh pidns -o ProxyCommand="ssh curie-remote -W %h:%p" "sudo pihole disable \"$1\""
#}
#function pihole-enable {
#    ssh pidns -o ProxyCommand="ssh curie-remote -W %h:%p" "sudo pihole enable"
#}

# find external IP. pass -4 or -6 to specify v4/v6 address.
alias myip='curl -s -w "\n" https://ip.dzdz.cz'

alias joke='curl --silent https://icanhazdadjoke.com  | cowsay'

# get attention
ding() {
    setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
    afplay /System/Library/Sounds/Glass.aiff &
    (sleep 0.5 ; afplay /System/Library/Sounds/Glass.aiff) &
    (sleep 1 ; afplay /System/Library/Sounds/Glass.aiff) &
    terminal-notifier -title "🔔" -message "ding" -ignoreDnD
}

# remove newline at EOF of the given file, in place
alias remove-newline-eof="perl -pi -e 'chomp if eof'"

# source the named env config file from ~/env
# or, source the file with the same name as working dir
senv() {
    if [ $# -ne 1 ]; then
        ENVNAME=${PWD##*/}
        source "$HOME/env/$ENVNAME"
    else
        source "$HOME/env/$1"
    fi
}

# download YouTube video -> local Plex server
plex-ytdl() {
    ssh -t curie-remote "~/youtube-dl-wrapper.sh \"$1\""
}

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

# better cp based on rsync:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/cp/cp.plugin.zsh
cpv() {
    rsync -brlptgoD --executability -hhh --backup-dir=/tmp/cpv_rsync -e /dev/null --progress "$@"
}
compdef _files cpv

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

function coauth() {
    if [[ $# -eq 0 ]]; then
        local result=$(git log | grep -i "co-authored-by:" | head -n 1 | xargs echo)
        if [[ -z "$result" ]]; then
            echo "[!] No previous Co-authored-by line found."
            return 1
        fi
        echo "$result" | clipcopy
        echo "[copied] $result"
    else
        local msg="$*"
        local result=$(git log | grep -i "co-authored-by:" | grep -i "$msg" | head -n 1 | xargs echo)
        if [[ -z "$result" ]]; then
            result=$(git log | grep -i "author:" | grep -i "$msg" | head -n 1 | xargs echo | sed 's/Author:/Co-authored-by:/')
        fi
        if [[ -z "$result" ]]; then
            echo "[!] No previous Author or Co-authored-by line found containing '$msg'."
            return 1
        fi
        echo "$result" | clipcopy
        echo "[copied] $result"
    fi
}

# Kubernetes:
alias kubectl="k8s-ctx-show; kubectl"
. ~/.kubectl_aliases
alias kprod="kubectl --namespace production"
alias kst="kubectl --namespace staging"
alias kl='kubectl logs -f'
alias kgpa='kubectl get pods --all-namespaces -owide'

# wait for the minimum required to avoid iTerm "session ended very soon" then exit
function delayed_exit() {
    NOW=$(date +%s)
    DELTA=$(($NOW-$SESSION_OPENED_TS))
    INTERVAL=3
    if (( $DELTA < $INTERVAL )); then
        sleep $(($INTERVAL-$DELTA))
    fi
    exit
}
alias xx="delayed_exit"
alias qq="delayed_exit"

# helpers for https://github.com/cdzombak/hosts-timer
function use-facebook() {
    if [ $# -eq 0 ]; then
        echo "Usage: use-facebook DURATION"
        echo "   eg. use-facebook 5m"
        return 1
    fi
    sudo hosts-timer -time "$1" facebook.com
    osascript <<'END'
tell application "Safari"
    quit
end tell
delay 1
tell application "Safari" to activate
-- not needed due to my Safari setting to always restore tabs:
-- tell application "System Events"
--     tell process "Safari"
--         click menu item "Reopen All Windows From Last Session" of menu "History" of menu bar 1
--     end tell
-- end tell
END
}

function use-twitter() {
    if [ $# -eq 0 ]; then
        echo "Usage: use-twitter DURATION"
        echo "   eg. use-twitter 5m"
        return 1
    fi
    sudo hosts-timer -time "$1" twitter.com
    osascript <<'END'
tell application "Safari"
    quit
end tell
delay 1
tell application "Safari" to activate
-- not needed due to my Safari setting to always restore tabs:
-- tell application "System Events"
--     tell process "Safari"
--         click menu item "Reopen All Windows From Last Session" of menu "History" of menu bar 1
--     end tell
-- end tell
END
}
