# Since .zshenv is always sourced, it often contains exported variables that should be available to other programs.
# For example, $PATH, $EDITOR, and $PAGER are often set in .zshenv.
# Also, you can set $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.

export PATH="/usr/local/MacGPG2/bin:/usr/local/sbin:/usr/local/bin:$PATH"
export MANPATH="/usr/local/git/man:/usr/local/man:$MANPATH"

# Golang:
export GOPATH="$HOME/code/go"
export GOROOT=/usr/local/opt/go/libexec
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

# Rust:
export PATH="$HOME/.cargo/bin:$PATH"

# cloudsqlproxy:
export PATH="$HOME/opt/cloudsql:$PATH"

# allow installing in ~/opt:
# export LD_LIBRARY_PATH="$HOME/opt/lib/:$LD_LIBRARY_PATH"
export PATH="$HOME/opt/sbin:$HOME/opt/bin:$PATH"
export MANPATH="$HOME/opt/share/man:$MANPATH"

export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

source ~/.zsh/fn-default.zsh

env_default PAGER 'less'
env_default LESS '-R'
export EDITOR='nano -w'

if [ -f /Users/cdzombak/code/censys/cub/bin/cub ]; then
	eval "$(/Users/cdzombak/code/censys/cub/bin/cub init -)"
fi
if [ -f /Users/cdzombak/.censys-env ]; then
	source /Users/cdzombak/.censys-env
fi
