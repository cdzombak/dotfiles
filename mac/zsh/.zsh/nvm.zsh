
if [ -e "$(brew --prefix)/opt/nvm" ] ; then
    export NVM_DIR="$HOME/.nvm"

    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # loads nvm
    [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # loads nvm bash_completion
fi
