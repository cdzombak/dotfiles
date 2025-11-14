if [ -d /opt/homebrew/bin ]; then
    export PATH="/opt/homebrew/bin:$PATH"
    export MANPATH="/opt/homebrew/share/man:$MANPATH"
fi

# Android (ugh)
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
fi

# Fastlane (brew install --cask fastlane):
if [ -d "$HOME/.fastlane/bin" ]; then
    export PATH="$PATH:$HOME/.fastlane/bin"
fi

if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Google Cloud:
if [ -d "$(brew --prefix)/Caskroom/google-cloud-sdk/" ] ; then
    source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
fi

# Golang:
export GOROOT=$(brew --prefix)/opt/go/libexec
export PATH="$GOROOT/bin:$PATH"
if [ -d "$HOME/go" ]; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# Rust:
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# UTM (VM app):
if [ -x /Applications/UTM.app/Contents/MacOS/utmctl ]; then
    export PATH="/Applications/UTM.app/Contents/MacOS:$PATH"
fi

# Claude Code:
if [ -x /Users/cdzombak/.claude/local/claude ]; then
    export PATH="/Users/cdzombak/.claude/local:$PATH"
fi

# allow installing in ~/opt:
export PATH="$HOME/opt/sbin:$HOME/opt/bin:$PATH"
export MANPATH="$HOME/opt/share/man:$MANPATH"

# ~/.local/bin
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# asdf-vm:
if [ -d "$HOME/.asdf" ] ; then
    PATH="$HOME/.asdf/shims:$PATH"
fi

# Orbstack (VM app):
[ -f ~/.orbstack/shell/init.zsh ] && source ~/.orbstack/shell/init.zsh 2>/dev/null
