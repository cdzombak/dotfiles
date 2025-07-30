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

# remove newline at EOF of the given file, in place
alias remove-newline-eof="perl -pi -e 'chomp if eof'"

# Sublime
alias subl='subl -n' # always open a new window when working from CLI
alias subl.='subl -n .' # I can't type

# easy access to the Tailscale CLI
[ -e '/Applications/Tailscale.app' ] && alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'

# copy working directory to clipboard
alias cpwd='pwd|tr -d "\n"|clipcopy'

# find external IP. pass -4 or -6 to specify v4/v6 address.
alias myip='curl -s -w "\n" https://ip.dzdz.cz'

# download YouTube video -> local Plex server
plex-ytdl() {
    ssh -t curie "/Users/cdzombak/code/youtube-dl-wrapper.sh \"$1\""
}

# better cp based on rsync:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/cp/cp.plugin.zsh
cpv() {
    rsync -pogbr -hhh --backup-dir="/tmp/rsync-${USERNAME}" -e /dev/null --progress "$@"
}
compdef _files cpv

# wait for the minimum required to avoid iTerm "session ended very soon" then exit
function delayed_exit() {
    NOW=$(date +%s)
    DELTA=$(($NOW-$SESSION_OPENED_TS))
    INTERVAL=4
    if (( $DELTA < $INTERVAL )); then
        sleep $(($INTERVAL-$DELTA))
    fi
    exit
}
alias qq="delayed_exit"

alias llm-js="env OLLAMA_HOST=https://jetstream.tailnet-003a.ts.net:7777 llm"
alias llm-wb="env OLLAMA_HOST=http://wilbur.tailnet-003a.ts.net:11434 llm"
