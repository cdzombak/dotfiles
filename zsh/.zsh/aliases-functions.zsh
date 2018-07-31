# via http://brettterpstra.com/2013/03/14/more-command-line-handiness/
# updated per Lri's comment
alias psgrep="ps -Aco pid,comm | sed 's/^ *//'| sed 's/:/ /'|grep -iE"

# ls
alias ls='ls -Fh'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# du/df
alias du='du -h'
alias duh='du -d 1'
alias df='df -h'

# mkdir/rmdir
alias rd='rmdir'
alias md='mkdir'

# tofrodos is packaged for OSX in homebrew
alias dos2unix='fromdos'
alias unix2dos='todos'

# fuckingg macbooks
alias ggit='git'

# is this a dag????
alias dag='git'

# git - stage missing files for removal
alias git-stage-missing="git status | grep deleted | awk '{print \$3}' | xargs git rm"

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
    rsync -pogbr -hhh --backup-dir=/tmp/rsync -e /dev/null --progress "$@"
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
