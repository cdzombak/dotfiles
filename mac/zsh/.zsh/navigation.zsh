function smart_ls {
  pwd
  if [[ `ls $* | wc -l` -lt 16 ]]; then
    ls -lFh $*
  else
    ls -Fh $*
  fi
}
alias sl=smart_ls

# navigation
function smart_pushd {
  pushd $1 && clear && smart_ls
}
alias f=smart_pushd

function smart_popd {
  popd && clear && smart_ls
}
alias d=smart_popd

alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

alias pu='pushd'
alias po='popd'

function h {
    f "$HOME/$1"
}

function mdf {
    md "$1"
    f "$1"
}
