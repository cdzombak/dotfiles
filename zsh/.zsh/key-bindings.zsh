# bind keys for standard OS X navigation in iTerm:
# ⌘-Delete, ⌘-DeleteFwd, ⌥-Delete, ⌥-DeleteFwd, ⌘-Left, ⌘-Right, ⌥-Left, ⌥-Right, ⌘Z, ⌘⇧Z
# changes hex 0x15 to delete everything to the left of the cursor, rather than the whole line
bindkey "^U" backward-kill-line
# adds redo
bindkey "^X^_" redo
# from https://stackoverflow.com/a/29403520 , in combination with iTerm-specific settings.

# remainder from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/key-bindings.zsh :

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# start typing + [Up-Arrow] - fuzzy find history forward
# if [[ "${terminfo[kcuu1]}" != "" ]]; then
#   autoload -U up-line-or-beginning-search
#   zle -N up-line-or-beginning-search
#   bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
# fi

# start typing + [Down-Arrow] - fuzzy find history backward
# if [[ "${terminfo[kcud1]}" != "" ]]; then
#   autoload -U down-line-or-beginning-search
#   zle -N down-line-or-beginning-search
#   bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
# fi

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi

# Edit the current command line in $EDITOR: ctrl-X ctrl-E
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
