# Clean out DerivedData
alias fuck-xcode="rm -rfv ~/Library/Developer/Xcode/DerivedData/ ; while [[ $? -ne 0 ]] ; do rm -rf ~/Library/Developer/Xcode/DerivedData/ ; done"
