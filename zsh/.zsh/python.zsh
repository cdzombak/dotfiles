# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/python/python.plugin.zsh

# Remove python compiled byte-code in either current directory or in a
# list of specified directories
function pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
}

# Grep among .py files
alias pygrep='grep -r --include="*.py"'

alias pip="noglob pip" # allows square brackets for pip command invocation
g_pip(){
   PIP_REQUIRE_VIRTUALENV="0" pip "$@"
}

#alias pip3="noglob pip3"
#g_pip3(){
#   PIP_REQUIRE_VIRTUALENV="0" pip3 "$@"
#}
