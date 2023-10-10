
function jobs-help() {
    autoload colors
    if [[ "$terminfo[colors]" -gt 8 ]]; then
        colors
    fi
    for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
        eval $COLOR='$fg_no_bold[${(L)COLOR}]'
        eval BOLD_$COLOR='$fg_bold[${(L)COLOR}]'
    done
    eval RESET='$reset_color'

    cat << EOF
Run ${CYAN}command${RESET} in background:
    ${YELLOW}command &${RESET}
Suspend running command:
    ${WHITE}Ctrl${RESET}+${WHITE}Z${RESET}

Return job ${CYAN}1${RESET} to foreground:
    ${YELLOW}fg %1${RESET}
Make job ${CYAN}2${RESET} continue in background:
    ${YELLOW}bg %2${RESET}
Kill job ${CYAN}3${RESET}:
    ${YELLOW}kill %3${RESET}
Suspend job ${CYAN}4${RESET} (equal to ${WHITE}Ctrl${RESET}+${WHITE}Z${RESET}):
    ${YELLOW}kill -TSTP %4${RESET}
Continue job ${CYAN}5${RESET} (equal to ${YELLOW}bg %5${RESET})
    ${YELLOW}kill -CONT %5${RESET}
Disown job ${CYAN}1${RESET} (remove from jobs list, but remains connected to terminal):
    ${YELLOW}disown %1${RESET}

Show jobs list:
    ${YELLOW}jobs${RESET}
Show status of a job:
    ${YELLOW}jobs %4${RESET}
Filtering arguments:
    ${MAGENTA}-r${RESET}  show all running jobs
    ${MAGENTA}-s${RESET}  show all stopped jobs
Additional detail:
    ${MAGENTA}-l${RESET}  show all jobs with process ids
    ${MAGENTA}-p${RESET}  show all jobs with process group ids
    ${MAGENTA}-d${RESET}  show all jobs with the directory they started in ${BLACK}(zsh only)${RESET}

Job control cheatsheet: ${BLUE}https://gist.github.com/CMCDragonkai/6084a504b6a7fee270670fc8f5887eb4${RESET}
${YELLOW}nohup${RESET} vs. ${YELLOW}disown${RESET} vs. ${YELLOW}&${RESET}: ${BLUE}https://unix.stackexchange.com/a/148698${RESET}
EOF

    if [[ $(jobs -l | wc -l) -gt 0 ]]; then
        echo ""
        jobs
    fi
}
