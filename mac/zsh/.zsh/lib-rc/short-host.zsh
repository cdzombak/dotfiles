function short_hostname() {
    if [[ "$OSTYPE" = darwin* ]]; then
      # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
      echo $(scutil --get ComputerName 2>/dev/null) || ${HOST/.*/}
    else
      echo ${HOST/.*/}
    fi
}

SHORT_HOST=$(short_hostname)
