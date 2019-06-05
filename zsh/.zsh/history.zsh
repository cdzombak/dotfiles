# Show history
case $HIST_STAMPS in
    "mm/dd/yyyy") alias history='fc -fl 1' ;;
    "dd.mm.yyyy") alias history='fc -El 1' ;;
    "yyyy-mm-dd") alias history='fc -il 1' ;;
    *) alias history='fc -l 1' ;;
esac

# grep history
function hsgrep {
    history | grep $* -i
}

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY  # adds history
setopt EXTENDED_HISTORY  # add timestamps to history
setopt INC_APPEND_HISTORY  # adds history incrementally
setopt hist_expire_dups_first
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt hist_ignore_space  # ignore commands beginning with a space
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions

alias hist='history | tail -n 100; echo "\033[0;36mOnly last 100. For full, type: \033[0;33mhistory\033[0;36m. Grep via: \033[0;33mhsgrep\033[0;36m."; echo "To run entry N: \033[0;33m!N\033[0;36m.\033[0m"'
