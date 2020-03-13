typora() {
  if (( $# == 0 )); then
    echo "Usage: typora <file>"
    echo "Touch + Open in Typora"
  else
    touch "$1"
    open -a "Typora" "$1"
  fi
}

# byword() {
#   if (( $# == 0 )); then
#     echo "Usage: byword <file>"
#     echo "Touch + Open in Byword"
#   else
#     touch "$1"
#     open -a "Byword" "$1"
#   fi
# }

marked() {
  if (( $# == 0 )); then
    echo "Usage: marked <file>"
    echo "Open in Marked 2"
  else
    open -a "Marked 2" "$1"
  fi
}

mded() {
  if (( $# == 0 )); then
    echo "Usage: mded <file>"
    echo "Touch + Open in Typora"
  else
    touch "$1"
    open -a "Typora" "$1"
  fi
}

# mded() {
#   if (( $# == 0 )); then
#     echo "Usage: mded <file>"
#     echo "Touch + Open in Byword + Marked 2"
#   else
#     touch "$1"
#     open -a "Byword" "$1"
#     # subl --new-window "$1"
#     open -a "Marked 2" "$1"
#   fi
# }
