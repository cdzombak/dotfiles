# .zprofile is sourced directly before .zshrc (instead of directly after it, as .zlogin is).
#
# According to the zsh documentation, ".zprofile is meant as an alternative to `.zlogin' for ksh fans;
# the two are not intended to be used together, although this could certainly be done if desired."

export WORKON_HOME=$HOME/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

source ~/.zsh/virtualenvwrapper.zsh
