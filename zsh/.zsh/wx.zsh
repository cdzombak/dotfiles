function wx() {
	if [[ $# -eq 0 ]]; then
		curl "https://wttr.in/Ann+Arbor,+Michigan"
	else 
		local msg="$*"
		curl "https://wttr.in/$msg?u"
	fi
}

# metar from https://github.com/RyuKojiro/metar
alias metar='metar -d'

function wwwmetar() {
	if [[ $# -eq 0 ]]; then
		curl "http://tgftp.nws.noaa.gov/data/observations/metar/stations/KARB.TXT"
	else
		local input="$1"
		local station=$( awk '{print toupper($0)}' <<< $input )
		curl "http://tgftp.nws.noaa.gov/data/observations/metar/stations/$station.TXT"
	fi
}
