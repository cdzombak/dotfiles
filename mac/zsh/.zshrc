# .zshrc is for interactive shell configuration. You set options for the interactive shell there with the setopt and unsetopt commands.
# You can also load shell modules, set your history options, change your prompt, set up zle and completion, et cetera.
# You also set any variables that are only used in the interactive shell (e.g. $LS_COLORS).

# color theme and other inspiration from https://gist.github.com/kevin-smets/8568070
# https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized

source ~/.zsh/completion.zsh
fpath=(~/.zsh/completions $fpath)
if [ -d "$HOME/.local/shell-completion" ] ; then
    fpath=(~/.local/shell-completion $fpath)
fi
if type brew &>/dev/null; then
    fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
    if [ -x "/opt/homebrew/bin/assume" ]; then
        alias assume="source assume"
    fi
fi
if [ -d "$HOME/.granted/zsh_autocomplete/assume" ]; then
    fpath=("$HOME/.granted/zsh_autocomplete/assume/" $fpath)
fi
if [ -d "$HOME/.granted/zsh_autocomplete/granted" ]; then
    fpath=("$HOME/.granted/zsh_autocomplete/granted/" $fpath)
fi
if [ -d "/opt/homebrew/Caskroom/google-cloud-sdk/" ] ; then
    source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi
[ -d "$HOME/.bun" ] && source "$HOME/.bun/_bun" # https://bun.com completions
autoload -Uz compinit
compinit

setopt interactivecomments
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
    setopt noclobber
fi

export CLICOLOR=true
# generate/sync via https://geoff.greer.fm/lscolors/
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
export LS_COLORS="di=36:ln=35:so=31;1;44:pi=30;1;44:ex=1;31:bd=0;1;44:cd=37;1;44:su=37;1;41:sg=30;1;43:tw=30;1;42:ow=30;1;43"
export WINDOWSTACK2_ERRCOLOR="1;30"

source ~/.zsh/lib-rc/urlencode.zsh
source ~/.zsh/lib-rc/git.zsh
source ~/.zsh/lib-rc/short-host.zsh

if [[ "$OSTYPE" == "darwin"* ]]; then
    source ~/.zsh/macos.zsh
    source ~/.zsh/xcode.zsh
fi

alias reload!='echo "" && . ~/.zshrc'

if [ -x /Users/cdzombak/.claude/local/claude ]; then
    alias claude="/Users/cdzombak/.claude/local/claude"
fi

source ~/.zsh/bundler.zsh
source ~/.zsh/clipboard.zsh
source ~/.zsh/colored-man-pages.zsh
source ~/.zsh/devtools.zsh
source ~/.zsh/dirmerge.zsh
command -v docker >/dev/null 2>&1 && source ~/.zsh/docker-func.zsh
source ~/.zsh/envtools.zsh
source ~/.zsh/extract.zsh
command -v fzf >/dev/null 2>&1 && source ~/.zsh/fzf.zsh
source ~/.zsh/gitignore.zsh
source ~/.zsh/golang.zsh
source ~/.zsh/grep.zsh
source ~/.zsh/history.zsh
source ~/.zsh/jobs-help.zsh
source ~/.zsh/key-bindings.zsh
command -v kubectl >/dev/null 2>&1 && source ~/.zsh/k8s.zsh
source ~/.zsh/markdown.zsh
source ~/.zsh/marks.zsh
source ~/.zsh/misc.zsh
source ~/.zsh/navigation.zsh
DEFAULT_USER=cdzombak # used in ~/.zsh/prompt.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/python.zsh
command -v rake >/dev/null 2>&1 && source ~/.zsh/rake.zsh
source ~/.zsh/ssh.zsh
source ~/.zsh/title.zsh
source ~/.zsh/wx.zsh
autoload -U zmv # https://blog.smittytone.net/2021/04/03/how-to-use-zmv-z-shell-super-smart-file-renamer/

[ -f ~/.local.zsh ] && source ~/.local.zsh

# must be last; see https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
source ~/.zsh/highlight.zsh
