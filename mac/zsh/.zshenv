# Since .zshenv is always sourced, it often contains exported variables that should be available to other programs.
# For example, $EDITOR and $PAGER are often set in .zshenv.
# Also, you can set $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.

# Note that on macOS, the system invokes path_helper after zshenv, so PATH should be set in zprofile which
# runs after path_helper.

export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

export PIP_RESPECT_VIRTUALENV=true
export PIP_REQUIRE_VIRTUALENV="1"

source ~/.zsh/fn-default.zsh
env_default PAGER 'less'
env_default LESS '-R'

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ ! -f "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ]; then
    export EDITOR='nano -w' # if we're in an SSH session or Sublime is missing
else
    export EDITOR='subl -w -n' # sublime; wait; new window
fi

if [[ -z "$ZSH_CACHE_DIR" ]]; then
    ZSH_CACHE_DIR="$HOME/.zsh-cache"
fi
