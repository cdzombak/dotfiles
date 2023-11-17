# source the named env config file from ~/env
# or, source the file with the same name as working dir
senv() {
    if [ $# -ne 1 ]; then
        ENVNAME=${PWD##*/}
        source "$HOME/env/$ENVNAME"
    else
        source "$HOME/env/$1"
    fi
}

# import environment variables from .env in the current directory
# https://stackoverflow.com/a/30969768
dotenv() {
    set -o allexport
    source .env
    set +o allexport
    export _RPROMPT_ENV='.env'
}
