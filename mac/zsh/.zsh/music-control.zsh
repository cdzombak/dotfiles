# iTunes control function
function itunes() {
	local opt=$1
	local playlist=$2
	shift
	case "$opt" in
		launch|play|pause|stop|rewind|resume|quit)
			;;
		mute)
			opt="set mute to true"
			;;
		unmute)
			opt="set mute to false"
			;;
		next|previous)
			opt="$opt track"
			;;
		vol)
			opt="set sound volume to $1" #$1 Due to the shift
			;;
		playlist)
		# Inspired by: https://gist.github.com/nakajijapan/ac8b45371064ae98ea7f
if [[ ! -z "$playlist" ]]; then
                    		osascript -e 'tell application "iTunes"' -e "set new_playlist to \"$playlist\" as string" -e "play playlist new_playlist" -e "end tell" 2>/dev/null;
				if [[ $? -eq 0 ]]; then
					opt="play"
				else
					opt="stop"
				fi
                  else
                    opt="set allPlaylists to (get name of every playlist)"
                  fi
                ;;
		playing|status)
			local state=`osascript -e 'tell application "iTunes" to player state as string'`
			if [[ "$state" = "playing" ]]; then
				currenttrack=`osascript -e 'tell application "iTunes" to name of current track as string'`
				currentartist=`osascript -e 'tell application "iTunes" to artist of current track as string'`
				echo -E "Listening to $fg[yellow]$currenttrack$reset_color by $fg[yellow]$currentartist$reset_color";
			else
				echo "iTunes is" $state;
			fi
			return 0
			;;
		shuf|shuff|shuffle)
			# The shuffle property of current playlist can't be changed in iTunes 12,
			# so this workaround uses AppleScript to simulate user input instead.
			# Defaults to toggling when no options are given.
			# The toggle option depends on the shuffle button being visible in the Now playing area.
			# On and off use the menu bar items.
			local state=$1

			if [[ -n "$state" && ! "$state" =~ "^(on|off|toggle)$" ]]
			then
				print "Usage: itunes shuffle [on|off|toggle]. Invalid option."
				return 1
			fi

			case "$state" in
				on|off)
					# Inspired by: http://stackoverflow.com/a/14675583
					osascript 1>/dev/null 2>&1 <<-EOF
					tell application "System Events" to perform action "AXPress" of (menu item "${state}" of menu "Shuffle" of menu item "Shuffle" of menu "Controls" of menu bar item "Controls" of menu bar 1 of application process "iTunes" )
EOF
					return 0
					;;
				toggle|*)
					osascript 1>/dev/null 2>&1 <<-EOF
					tell application "System Events" to perform action "AXPress" of (button 2 of process "iTunes"'s window "iTunes"'s scroll area 1)
EOF
					return 0
					;;
			esac
			;;
		""|"help"|-h|--help)
			echo "Usage: itunes <command>"
			echo "command:"
			echo "\tlaunch|play|pause|stop|rewind|resume|quit"
			echo "\tmute|unmute\t\t\tMute or unmute iTunes"
			echo "\tnext|previous\t\t\tSkip to next or previous song"
			echo "\tshuf|shuffle [on|off|toggle]\tSet shuffled playback. Default: toggle."
			echo "\t\t\t\t\tNote: toggle doesn't support the MiniPlayer."
			echo "\tvol\t\t\t\tSet volume to the given amount, from 0 to 100"
			echo "\tplaying|status\t\t\tShow what song is currently playing in iTunes"
			echo "\tplaylist [name]\t\t\tPlay specific playlist"
			echo "\thelp|-h|--help\t\t\tShow this message and exit"
			return 0
			;;
		*)
			print "Unknown option: $opt"
			return 1
			;;
	esac
	osascript -e "tell application \"iTunes\" to $opt"
}

# Spotify control function
function spotify() {

  showHelp () {
    echo "Usage:";
    echo;
    echo "  $(basename "$0") <command>";
    echo;
    echo "Commands:";
    echo;
    echo "  play                         # Resume playback where Spotify last left off.";
    echo "  play [song name]             # Find a song by name and play it.";
    echo "  play album [album name]      # Find an album by name and play it.";
    echo "  play artist [artist name]    # Find an artist by name and play it.";
    echo "  play list [playlist name]    # Find a playlist by name and play it.";
    echo "  pause                        # Pause Spotify playback.";
    echo "  next                         # Skip to the next song in a playlist.";
    echo "  prev                         # Return to the previous song in a playlist.";
    echo "  pos [time]                   # Jump to time (in secs) in the current song.";
    echo "  quit                         # Stop playback and quit Spotify.";
    echo;
    echo "  vol up                       # Increase the volume by 10%.";
    echo "  vol down                     # Decrease the volume by 10%.";
    echo "  vol [amount]                 # Set the volume to an amount from 0 to 100.";
    echo "  vol show                     # Show the current Spotify volume.";
    echo;
    echo "  status                       # Show the current player status.";
    echo "  share                        # Copy the current song URL to the clipboard."
    echo "  info                         # Show full information about the currently-playing song.";
    echo;
    echo "  toggle shuffle               # Toggle shuffle playback mode.";
    echo "  toggle repeat                # Toggle repeat playback mode.";
  }

  cecho(){
    bold=$(tput bold);
    green=$(tput setaf 2);
    reset=$(tput sgr0);
    echo "$bold$green$1$reset";
  }

  showStatus () {
      state=$(osascript -e 'tell application "Spotify" to player state as string');
      cecho "Spotify is currently $state.";
      if [ "$state" = "playing" ]; then
        artist=$(osascript -e 'tell application "Spotify" to artist of current track as string');
        album=$(osascript -e 'tell application "Spotify" to album of current track as string');
        track=$(osascript -e 'tell application "Spotify" to name of current track as string');
        duration=$(osascript -e 'tell application "Spotify" to duration of current track as string');
        duration=$(echo "scale=2; $duration / 60 / 1000" | bc);
        position=$(osascript -e 'tell application "Spotify" to player position as string' | tr ',' '.');
        position=$(echo "scale=2; $position / 60" | bc | awk '{printf "%0.2f", $0}');

        printf "$reset""Artist: %s\nAlbum: %s\nTrack: %s \nPosition: %s / %s\n" "$artist" "$album" "$track" "$position" "$duration";
      fi
  }



  if [ $# = 0 ]; then
    showHelp;
  else
    if [ "$1" != "quit" ] && [ $1 != "-h" ] && [ $1 != "--help" ] && [ "$(osascript -e 'application "Spotify" is running')" = "false" ]; then
      osascript -e 'tell application "Spotify" to activate'
      sleep 2
    fi
  fi

  while [ $# -gt 0 ]; do
    arg=$1;

    case $arg in
      "play"    )
        if [ $# != 1 ]; then
          # There are additional arguments, so find out how many
          array=( $@ );
          len=${#array[@]};
          SPOTIFY_SEARCH_API="https://api.spotify.com/v1/search"
          SPOTIFY_PLAY_URI="";

          searchAndPlay() {
            type="$1"
            Q="$2"

            echo "Searching ${type}s for: $Q";

            SPOTIFY_PLAY_URI=$( \
              curl -s -G $SPOTIFY_SEARCH_API --data-urlencode "q=$Q" -d "type=$type&limit=1&offset=0" -H "Accept: application/json" \
              | grep -E -o "spotify:$type:[a-zA-Z0-9]+" -m 1
              )
          }

          case $2 in
            "list"  )
              _args=${array[*]:2:$len};
              Q=$_args;

              echo "Searching playlists for: $Q";

              results=$( \
                curl -s -G $SPOTIFY_SEARCH_API --data-urlencode "q=$Q" -d "type=playlist&limit=10&offset=0" -H "Accept: application/json" \
                | grep -E -o "spotify:user:[a-zA-Z0-9_]+:playlist:[a-zA-Z0-9]+" -m 10 \
                )

              count=$( \
                echo "$results" | grep -c "spotify:user" \
                )

              if [ "$count" -gt 0 ]; then
                random=$(( RANDOM % count));

                SPOTIFY_PLAY_URI=$( \
                  echo "$results" | awk -v random="$random" '/spotify:user:[a-zA-Z0-9]+:playlist:[a-zA-Z0-9]+/{i++}i==random{print; exit}' \
                  )
              fi;;

            "album" | "artist" | "track"    )
              _args=${array[*]:2:$len};
              searchAndPlay "$2" "$_args";;

            *   )
              _args=${array[*]:1:$len};
              searchAndPlay track "$_args";;
          esac

          if [ "$SPOTIFY_PLAY_URI" != "" ]; then
            cecho "Playing ($Q Search) -> Spotify URL: $SPOTIFY_PLAY_URI";

            osascript -e "tell application \"Spotify\" to play track \"$SPOTIFY_PLAY_URI\"";

          else
            cecho "No results when searching for $Q";
          fi
        else
          # play is the only param
          cecho "Playing Spotify.";
          osascript -e 'tell application "Spotify" to play';
        fi
        break ;;

      "pause"    )
        state=$(osascript -e 'tell application "Spotify" to player state as string');
        if [ "$state" = "playing" ]; then
          cecho "Pausing Spotify.";
        else
          cecho "Playing Spotify.";
        fi

        osascript -e 'tell application "Spotify" to playpause';
        break ;;

      "quit"    )
        if [ "$(osascript -e 'application "Spotify" is running')" = "false" ]; then
          cecho "Spotify was not running."
        else
          cecho "Closing Spotify.";
          osascript -e 'tell application "Spotify" to quit';
        fi
        break ;;

      "next"    )
        cecho "Going to next track." ;
        osascript -e 'tell application "Spotify" to next track';
        break ;;

      "prev"    )
        cecho "Going to previous track.";
        osascript -e 'tell application "Spotify" to previous track';
        break ;;

      "vol"    )
        vol=$(osascript -e 'tell application "Spotify" to sound volume as integer');
        if [[ "$2" = "show" || "$2" = "" ]]; then
          cecho "Current Spotify volume level is $vol.";
          break ;
        elif [ "$2" = "up" ]; then
          if [ "$vol" -le 90 ]; then
            newvol=$(( vol+10 ));
            cecho "Increasing Spotify volume to $newvol.";
          else
            newvol=100;
            cecho "Spotify volume level is at max.";
          fi
        elif [ "$2" = "down" ]; then
          if [ "$vol" -ge 10 ]; then
            newvol=$(( vol-10 ));
            cecho "Reducing Spotify volume to $newvol.";
          else
            newvol=0;
            cecho "Spotify volume level is at min.";
          fi
        elif [ "$2" -ge 0 ]; then
          newvol=$2;
        fi

        osascript -e "tell application \"Spotify\" to set sound volume to $newvol";
        break ;;

      "toggle"  )
        if [ "$2" = "shuffle" ]; then
          osascript -e 'tell application "Spotify" to set shuffling to not shuffling';
          curr=$(osascript -e 'tell application "Spotify" to shuffling');
          cecho "Spotify shuffling set to $curr";
        elif [ "$2" = "repeat" ]; then
          osascript -e 'tell application "Spotify" to set repeating to not repeating';
          curr=$(osascript -e 'tell application "Spotify" to repeating');
          cecho "Spotify repeating set to $curr";
        fi
        break ;;

      "pos"   )
        cecho "Adjusting Spotify play position."
        osascript -e "tell application \"Spotify\" to set player position to $2";
        break ;;

      "status" )
        showStatus;
        break ;;

      "info" )
        info=$(osascript -e 'tell application "Spotify"
          set tM to round (duration of current track / 60) rounding down
          set tS to duration of current track mod 60
          set pos to player position as text
          set myTime to tM as text & "min " & tS as text & "s"
          set nM to round (player position / 60) rounding down
          set nS to round (player position mod 60) rounding down
          set nowAt to nM as text & "min " & nS as text & "s"
          set info to "" & "\nArtist:         " & artist of current track
          set info to info & "\nTrack:          " & name of current track
          set info to info & "\nAlbum Artist:   " & album artist of current track
          set info to info & "\nAlbum:          " & album of current track
          set info to info & "\nSeconds:        " & duration of current track
          set info to info & "\nSeconds played: " & pos
          set info to info & "\nDuration:       " & mytime
          set info to info & "\nNow at:         " & nowAt
          set info to info & "\nPlayed Count:   " & played count of current track
          set info to info & "\nTrack Number:   " & track number of current track
          set info to info & "\nPopularity:     " & popularity of current track
          set info to info & "\nId:             " & id of current track
          set info to info & "\nSpotify URL:    " & spotify url of current track
          set info to info & "\nArtwork:        " & artwork of current track
          set info to info & "\nPlayer:         " & player state
          set info to info & "\nVolume:         " & sound volume
          set info to info & "\nShuffle:        " & shuffling
          set info to info & "\nRepeating:      " & repeating
          end tell
          return info')
        echo "$info";
        break ;;

    "share"     )
      url=$(osascript -e 'tell application "Spotify" to spotify url of current track');
      remove='spotify:track:'
      url=${url#$remove}
      url="http://open.spotify.com/track/$url"
      echo "$url"
      echo -n "$url" | pbcopy
      break;;

      -h|--help| *)
        showHelp;
        break ;;
    esac
  done
}
