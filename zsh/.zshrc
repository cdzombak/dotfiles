# .zshrc is for interactive shell configuration. You set options for the interactive shell there with the setopt and unsetopt commands.
# You can also load shell modules, set your history options, change your prompt, set up zle and completion, et cetera.
# You also set any variables that are only used in the interactive shell (e.g. $LS_COLORS).

# color theme and other inspiration from https://gist.github.com/kevin-smets/8568070
# https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized

fpath=(~/.zsh/completions $fpath)
DEFAULT_USER=cdzombak
autoload -U zmv
setopt interactivecomments

export CLICOLOR=true
# generate/sync via https://geoff.greer.fm/lscolors/
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
export LS_COLORS="di=36:ln=35:so=31;1;44:pi=30;1;44:ex=1;31:bd=0;1;44:cd=37;1;44:su=37;1;41:sg=30;1;43:tw=30;1;42:ow=30;1;43"

alias reload!='echo "" && . ~/.zshrc'

source ~/.zsh/lib-rc/urlencode.zsh
source ~/.zsh/lib-rc/git.zsh
source ~/.zsh/lib-rc/short-host.zsh

set -o noclobber

# Set ZSH_CACHE_DIR to the path where cache files should be created
if [[ -z "$ZSH_CACHE_DIR" ]]; then
    ZSH_CACHE_DIR="$HOME/.zsh-cache"
fi

if [ -d "$HOME/.shell-completion-local" ] ; then
    fpath=(~/.shell-completion-local $fpath)
fi

autoload -U compaudit compinit
source ~/.zsh/lib-rc/compfix.zsh
# If completion insecurities exist, warn the user without enabling completions:
if ! compaudit &>/dev/null; then
    # This function resides in the "lib-rc/compfix.zsh" script sourced above.
    handle_completion_insecurities
# Else, enable and cache completions to the desired file:
else
    compinit -d "${ZSH_COMPDUMP}"
fi
source ~/.zsh/completion.zsh

source ~/.zsh/navigation.zsh
source ~/.zsh/title.zsh
source ~/.zsh/key-bindings.zsh
source ~/.zsh/aliases-functions.zsh
source ~/.zsh/grep.zsh
source ~/.zsh/extract.zsh
source ~/.zsh/history.zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
	source ~/.zsh/osx.zsh
fi
source ~/.zsh/music-control.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/pip.zsh
source ~/.zsh/markdown.zsh
source ~/.zsh/fuck-things.zsh
source ~/.zsh/clipboard.zsh
source ~/.zsh/python.zsh
source ~/.zsh/rake.zsh
source ~/.zsh/colored-man-pages.zsh
source ~/.zsh/nmap.zsh
source ~/.zsh/gitignore.zsh
source ~/.zsh/xcode.zsh
source ~/.zsh/golang.zsh
source ~/.zsh/bundler.zsh
source ~/.zsh/docker-func.zsh
source ~/.zsh/json.zsh
source ~/.zsh/hints.zsh
source ~/.zsh/wx.zsh
which fzf > /dev/null 2>&1 && source ~/.zsh/fzf.zsh
which thefuck > /dev/null 2>&1 && eval $(thefuck --alias)

if [ -d "/usr/local/Caskroom/google-cloud-sdk/" ] ; then
	source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
	source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

source ~/.zsh/zsh-notify/notify.plugin.zsh
zstyle ':notify:*' command-complete-timeout 10
zstyle ':notify:*' error-title "Error ❗️"
zstyle ':notify:*' success-title "Completed ✅"

# must be last; see https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
source ~/.zsh/highlight.zsh
