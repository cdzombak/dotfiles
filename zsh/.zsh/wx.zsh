function wx() {
	if [[ $# -eq 0 ]]; then
		curl "https://wttr.in/Chelsea,%20Michigan"
	else
		local msg="$*"
		curl "https://wttr.in/$msg?u"
	fi
}

function wx2() {
    if [[ $# -eq 0 ]]; then
        curl "https://v2.wttr.in/Chelsea,%20Michigan"
    else
        local msg="$*"
        curl "https://v2.wttr.in/$msg?u"
    fi
}

# metar from https://github.com/RyuKojiro/metar
alias metar='metar -d'

function metar.www() {
	if [[ $# -eq 0 ]]; then
		curl "https://tgftp.nws.noaa.gov/data/observations/metar/stations/KARB.TXT"
	else
		local input="$1"
		local station=$( awk '{print toupper($0)}' <<< $input )
		curl "https://tgftp.nws.noaa.gov/data/observations/metar/stations/$station.TXT"
	fi
}
