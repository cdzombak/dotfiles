# from https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/golang

## completion
compctl -g "*.go" gofmt # standard go tools
compctl -g "*.go" gccgo # gccgo

# gc
for p in 5 6 8; do
  compctl -g "*.${p}" ${p}l
  compctl -g "*.go" ${p}g
done
unset p
