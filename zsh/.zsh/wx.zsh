function wx() {
	if [[ $# -eq 0 ]]; then
		curl "wttr.in/Ann+Arbor,+Michigan"
	else 
		local msg="$*"
		curl "wttr.in/$msg?u"
	fi
}

# metar from https://github.com/RyuKojiro/metar
alias metar='metar -d'
