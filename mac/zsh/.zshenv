# Since .zshenv is always sourced, it often contains exported variables that should be available to other programs.
# For example, $PATH, $EDITOR, and $PAGER are often set in .zshenv.
# Also, you can set $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.

if [ -x /usr/libexec/path_helper ]; then
    eval "$(/usr/libexec/path_helper -s)"
fi
if [ -d /opt/homebrew/bin ]; then
    export PATH="/opt/homebrew/bin:$PATH"
    export MANPATH="/opt/homebrew/share/man:$MANPATH"
fi

# Android (ugh)
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
fi

# Golang:
export GOROOT=$(brew --prefix)/opt/go/libexec
export PATH="$GOROOT/bin:$PATH"
if [ -d "$HOME/go" ]; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# Rust:
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Fastlane (brew install --cask fastlane):
if [ -d "$HOME/.fastlane/bin" ]; then
    export PATH="$PATH:$HOME/.fastlane/bin"
fi

if [ -d "$(brew --prefix)/Caskroom/google-cloud-sdk/" ] ; then
    source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
fi

# allow installing in ~/opt:
export PATH="$HOME/opt/sbin:$HOME/opt/bin:$PATH"
export MANPATH="$HOME/opt/share/man:$MANPATH"

if [ -d "$HOME/.asdf" ] ; then
    PATH="$HOME/.asdf/shims:$PATH"
fi

if [ -e "$HOME/.local.bin/env" ]; then
    . "$HOME/.local/bin/env"
fi

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
