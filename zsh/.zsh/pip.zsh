alias pip="noglob pip" # allows square brackets for pip command invocation
alias pip2="noglob pip2"
alias pip3="noglob pip3"

g_pip(){
   PIP_REQUIRE_VIRTUALENV="0" pip "$@"
}

g_pip2(){
   PIP_REQUIRE_VIRTUALENV="0" pip2 "$@"
}

g_pip3(){
   PIP_REQUIRE_VIRTUALENV="0" pip3 "$@"
}
