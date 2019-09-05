# via http://brettterpstra.com/2013/03/14/more-command-line-handiness/
# updated per Lri's comment
alias psgrep="ps -Aco pid,comm | sed 's/^ *//'| sed 's/:/ /'|grep -iE"

# grab the nth column of space-separated lines
alias _1="cut -d\" \" -f1"
alias _2="cut -d\" \" -f2"
alias _3="cut -d\" \" -f3"
alias _4="cut -d\" \" -f4"
alias _5="cut -d\" \" -f5"

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
alias md='mkdir'

# tofrodos is packaged for OSX in homebrew
alias dos2unix='fromdos'
alias unix2dos='todos'

# fuckingg macbooks
alias ggit='git'

# Sublime
alias subl='subl -n' # always open a new window when working from CLI
alias subl.='subl -n .' # I can't type

# git - stage missing files for removal
alias git-stage-missing="git status | grep deleted | awk '{print \$3}' | xargs git rm"

# wake PC via SSH into curie-srv at home
alias wol-edison="ssh -t curie-remote \"/usr/local/bin/wakeonlan -i 192.168.1.255 -p 7 70:85:c2:22:b5:0b\""

# one-off run feedbin archiver (https://github.com/cdzombak/feedbin-auto-archiver)
alias archive-feedbin="ssh -t burr \"/home/cdzombak/scripts/feedbin-auto-archiver/venv/bin/python3 /home/cdzombak/scripts/feedbin-auto-archiver/feedbin_archiver.py --rules-file /home/cdzombak/Dropbox/feedbin-archiver-rules.json --dry-run false --ignore-rules-validation true\""

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
youtube-plex-dl() {
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

_whois_champ() {
    if (( $# == 1 )) && [[ "$1" == "champ" ]]; then
        echo "% WWE WHOIS server"
        echo "% for more information on Champ, visit https://www.youtube.com/watch?v=cFz9ssTTuAM"
        echo "% This query returned 1 object"
        echo ""
        echo "THAT QUESTION WILL BE ANSWERED THIS SUNDAY SUNDAY SUNDAY AT THE WWE SUPERSLAAAAAAAM WHEN JOHN CENA DEFENDS HIS TITLE!"
    else
        whois $*
    fi
}

alias whois=_whois_champ

# ls archives (inspired by `extract`)
# via http://brettterpstra.com/2013/03/14/more-command-line-handiness/
lsz() {
    if [ $# -ne 1 ]
    then
        echo "lsz filename.[tar,tgz,gz,zip,etc]"
        return 1
    fi
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2|*.tar.gz|*.tar|*.tbz2|*.tgz) tar tvf $1;;
            *.zip)  unzip -l $1;;
            *)      echo "'$1' unrecognized." ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
compdef _files lsz

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
        local result=$(git log | grep -i "co-authored-by" | head -n 1 | xargs echo)
        echo "$result" | clipcopy
        echo "[copied] $result"
    else
        local msg="$*"
        local result=$(git log | grep -i "co-authored-by" | grep -i "$msg" | head -n 1 | xargs echo)
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
