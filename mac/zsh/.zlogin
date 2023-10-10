# .zlogin is sourced on the start of a login shell.
# .zlogin is sourced after .zshrc.

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP # don't kill background tasks when exiting shell
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
