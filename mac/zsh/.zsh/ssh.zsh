# ssh with multiplexing (relies on ControlPath & etc set in ~/.ssh/config)
alias ssh-mux='ssh -o "ControlMaster=auto"'

alias hosts-list='{ grep "^#\?Host " ~/.ssh/config | grep -v -- "kvm.dzhome$" | grep -v "bitbucket" | grep -v "Host gh" | grep -v "github" | grep -v "Host \*" | sed "s/^Host //" | sed "s/^#Host /!/" | sed "s/ .*\.tailnet-003a.ts.net//g" | sed "s/ .*\.dzhome//g" ; }'
alias hosts-list-md='{ grep "^#\?Host " ~/.ssh/config | grep -v -- "kvm.dzhome$" | grep -v "bitbucket" | grep -v "Host gh" | grep -v "github" | grep -v "Host \*" | sed "s/^Host /- [ ] /" | sed "s/^#Host /- [ ] !/" | sed "s/ .*\.tailnet-003a.ts.net//g" | sed "s/ .*\.dzhome//g" ; }'

# ssc: ssh to the given host and open a screen
function ssc {
    old_auto_title=$DISABLE_AUTO_TITLE
    title "$1"
    ssh -t "$1" "screen -DR"
    export DISABLE_AUTO_TITLE=$old_auto_title
}
compdef ssc=ssh

function rm-known-host() {
    if [ -z "$1" ]; then
        echo "usage: rm-known-host LINE_NUMBER"
        return 1
    fi
    re='^[0-9]+$'
    if ! [[ "$1" =~ $re ]] ; then
        echo "usage: rm-known-host LINE_NUMBER"
        return 1
    fi
    gsed -i "$1d" "$HOME/.ssh/known_hosts"
}
