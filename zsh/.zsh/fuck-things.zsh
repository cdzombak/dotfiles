# Clean out DerivedData
alias fuck-xcode="rm -rfv ~/Library/Developer/Xcode/DerivedData/ ; while [[ $? -ne 0 ]] ; do rm -rf ~/Library/Developer/Xcode/DerivedData/ ; done"

# https://pinboard.in/u:cdzombak/t:mail.app
# V4 is for macOS Sierra
# V5 is for macOS High Sierra
alias fuck-mail="rm -rfv ~/Library/Mail/V5/MailData/Envelope\ Index*"
