# shellcheck shell=bash

export EDITOR=nano
export LD_LIBRARY_PATH=$HOME/opt/lib/:$LD_LIBRARY_PATH
export MANPATH=$HOME/opt/share/man:$MANPATH

if [ -d "$HOME/go" ]; then
    export GOPATH=$HOME/go
    export PATH=$HOME/opt/sbin:$HOME/opt/bin:$HOME/go/bin:/usr/local/go/bin:$PATH
elif [ -d "/usr/local/go/bin" ]; then
    export PATH=$HOME/opt/sbin:$HOME/opt/bin:/usr/local/go/bin:$PATH
else
    export PATH=$HOME/opt/sbin:$HOME/opt/bin:$PATH
fi

source ~/.bashrc
