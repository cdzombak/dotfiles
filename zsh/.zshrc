# .zshrc is for interactive shell configuration. You set options for the interactive shell there with the setopt and unsetopt commands.
# You can also load shell modules, set your history options, change your prompt, set up zle and completion, et cetera.
# You also set any variables that are only used in the interactive shell (e.g. $LS_COLORS).

# color theme and other inspiration from https://gist.github.com/kevin-smets/8568070
# https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized

fpath=(~/.zsh/completions $fpath)
if [ -d "$HOME/.local/shell-completion" ] ; then
    fpath=(~/.local/shell-completion $fpath)
fi

if [ -x "$(brew --prefix)/bin/assume" ]; then
    alias assume="source assume"
    if [ -d "$HOME/.granted/zsh_autocomplete/assume" ]; then
        fpath=("$HOME/.granted/zsh_autocomplete/assume/" $fpath)
    fi
    if [ -d "$HOME/.granted/zsh_autocomplete/granted" ]; then
        fpath=("$HOME/.granted/zsh_autocomplete/granted/" $fpath)
    fi
fi

DEFAULT_USER=cdzombak
autoload -U zmv
setopt interactivecomments

export CLICOLOR=true
# generate/sync via https://geoff.greer.fm/lscolors/
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
export LS_COLORS="di=36:ln=35:so=31;1;44:pi=30;1;44:ex=1;31:bd=0;1;44:cd=37;1;44:su=37;1;41:sg=30;1;43:tw=30;1;42:ow=30;1;43"
export WINDOWSTACK2_ERRCOLOR="1;30"

export SESSION_OPENED_TS=$(date +%s)

alias reload!='echo "" && . ~/.zshrc'

# redo prioritizing homebrew in PATH here, same as .zshenv,
# since something in macOS is resetting it between there and now:
if [ -d /opt/homebrew/bin ]; then
    export PATH="/opt/homebrew/bin:$PATH"
    export MANPATH="/opt/homebrew/share/man:$MANPATH"
fi

source ~/.zsh/lib-rc/urlencode.zsh
source ~/.zsh/lib-rc/git.zsh
source ~/.zsh/lib-rc/short-host.zsh

set -o noclobber

# Set ZSH_CACHE_DIR to the path where cache files should be created
if [[ -z "$ZSH_CACHE_DIR" ]]; then
    ZSH_CACHE_DIR="$HOME/.zsh-cache"
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
source ~/.zsh/completion.zsh
autoload -Uz compinit
compinit

source ~/.zsh/navigation.zsh
source ~/.zsh/title.zsh
source ~/.zsh/key-bindings.zsh
source ~/.zsh/aliases-functions.zsh
source ~/.zsh/grep.zsh
source ~/.zsh/extract.zsh
source ~/.zsh/history.zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
    source ~/.zsh/osx.zsh
    source ~/.zsh/xcode.zsh
fi
source ~/.zsh/music-control.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/jobs-help.zsh
source ~/.zsh/markdown.zsh
source ~/.zsh/fuck-things.zsh
source ~/.zsh/clipboard.zsh
source ~/.zsh/python.zsh
source ~/.zsh/rake.zsh
source ~/.zsh/colored-man-pages.zsh
source ~/.zsh/gitignore.zsh
source ~/.zsh/golang.zsh
source ~/.zsh/bundler.zsh
source ~/.zsh/marks.zsh
command -v docker >/dev/null 2>&1 && source ~/.zsh/docker-func.zsh
source ~/.zsh/wx.zsh
command -v fzf >/dev/null 2>&1 && source ~/.zsh/fzf.zsh
if [ -d "$(brew --prefix)/Caskroom/google-cloud-sdk/" ] ; then
    source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi
source ~/.zsh/pyenv.zsh
source ~/.zsh/nvm.zsh
if [ -f ~/.local.zsh ]; then
    source ~/.local.zsh
fi

source ~/.zsh/zsh-notify/notify.plugin.zsh
zstyle ':notify:*' command-complete-timeout 10
zstyle ':notify:*' error-title "Error ❗️"
zstyle ':notify:*' success-title "Completed ✅"
zstyle ':notify:*' enable-on-ssh yes

# must be last; see https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
source ~/.zsh/highlight.zsh
