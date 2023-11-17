# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/rake/rake.plugin.zsh

alias rake='noglob rake'                    # allows square brackts for rake task invocation
alias 'bin/rake'='noglob bin/rake'          # support use of binstub
alias brake='noglob bundle exec rake'       # execute the bundled rake gem
alias srake='noglob sudo rake'              # noglob must come before sudo
alias sbrake='noglob sudo bundle exec rake' # altogether now ...
