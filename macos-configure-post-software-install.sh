#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source ./lib/cecho

if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping macOS configuration because not on macOS"
  exit 2
fi

cecho "----                            ----" $white
cecho "---- Post-Install Configuration ----" $white
cecho "----                            ----" $white
echo ""

if [ ! -f "$HOME/.netrc" ]; then
  cecho "Git authentication configuration..." $white
  cp ./.netrc.template "$HOME/.netrc"
  chmod 600 "$HOME/.netrc"
  # shellcheck disable=SC2129
  echo "## \`~/.netrc\`" >> "$HOME/SystemSetup.md"
  echo "" >> "$HOME/SystemSetup.md"
  echo -e "- [ ] Set GitHub token ([create one here](https://github.com/settings/tokens))\n- [ ] Set Bitbucket username (as needed)\n- [ ] Set Bitbucket token (as needed) ([create one here](https://bitbucket.org/account/settings/app-passwords/))\n- [ ] Set dropbox.dzombak.com credentials" >> "$HOME/SystemSetup.md"
  echo "" >> "$HOME/SystemSetup.md"
  echo ""
fi

if [ -d /opt/homebrew ]; then
  cecho "Set path for macOS .apps to include /usr/local and /opt/homebrew..." $white
  sudo launchctl config user path "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/Applications/Sublime Text.app/Contents/SharedSupport/bin:/usr/local/sbin:/opt/homebrew/sbin:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/usr/local/opt/go/libexec/bin"
else
  cecho "Set path for macOS .apps to include /usr/local..." $white
  sudo launchctl config user path "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/Applications/Sublime Text.app/Contents/SharedSupport/bin:/usr/local/sbin:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/usr/local/opt/go/libexec/bin"
fi
echo ""

# Further configuration ...
# - for applications installed as part of the software install script
# - using tools installed as part of the software install script

cecho "--- Application Configuration ---" $white
echo "If these don't apply, open the affected app, quit it, and re-run this script. As a last resort, try rebooting, and run this script again."
echo ""

echo "1Password ..."
if [ -e "/Applications/1Password 7.app" ]; then
  set +e
  osascript -e "tell application \"1Password 7\" to quit"
  set -e
  defaults write com.agilebits.onepassword7 compromisedPasswordServiceV2 1
  defaults write com.agilebits.onepassword7 ShowStatusItem -bool false
  defaults write com.agilebits.onepassword7 watchtowerMakeHTTPSAlwaysAskForConsent 0
else
  echo "(Not installed.)"
fi

echo "AirBuddy ..."
if [ -e "/Applications/AirBuddy.app" ]; then
  osascript -e "tell application \"AirBuddy\" to quit"
  defaults write codes.rambo.AirBuddy SUAutomaticallyUpdate -bool true
  defaults write codes.rambo.AirBuddy SUEnableAutomaticChecks -bool true
  set +e
  open -a "AirBuddy"
  set -e
else
  echo "(Not installed.)"
fi

echo "Bartender 3 ..."
if [ -e "/Applications/Bartender 3.app" ]; then
  osascript -e "tell application \"Bartender 3\" to quit"
  defaults write com.surteesstudios.Bartender ReduceUpdateCheckFrequencyWhenOnBattery -bool true
  set +e
  open -a "Bartender 3"
  set -e
else
  echo "(Not installed.)"
fi

echo "Bartender 4 ..."
if [ -e "/Applications/Bartender 4.app" ]; then
  cecho "TODO(cdzombak): This configuration block may need to change if I move to Setapp's Bartender 4 due to licensing." $white
  osascript -e "tell application \"Bartender 4\" to quit"
  defaults write "com.surteesstudios.Bartender" "ReduceMenuItemSpacing" '1'
  defaults write "com.surteesstudios.Bartender" "ReduceUpdateCheckFrequencyWhenOnBattery" '1'
  set +e
  open -a "Bartender 4"
  set -e
else
  echo "(Not installed.)"
fi

echo "Bear ..."
if [ -e /Applications/Bear.app ]; then
  osascript -e "tell application \"Bear\" to quit"
  defaults write net.shinyfrog.bear SFAppIconMatchesTheme -bool true
  defaults write net.shinyfrog.bear SFEditorFontSize 17
  defaults write net.shinyfrog.bear SFEditorLineWidthMultiplier 50
  # shellcheck disable=SC2016
  defaults write net.shinyfrog.bear NSUserKeyEquivalents '{
    Archive = "^$a";
    Back = "@^\U2190";
    Forward = "@^\U2192";
  }'
  set +e
  open -a Bear
  set -e
else
  echo "(Not installed.)"
fi

echo "Black Ink ..."
if [ -e "/Applications/Black Ink.app" ]; then
  osascript -e "tell application \"Black Ink\" to quit"
  defaults write com.red-sweater.blackink2 SkipToNext -bool false
else
  echo "(Not installed.)"
fi

echo "Choosy ..."
if [ -e "/Applications/Choosy.app" ]; then
  osascript -e "tell application \"Choosy\" to quit"
  defaults write com.choosyosx.Choosy generalMode 0
  defaults write com.choosyosx.Choosy launchAtLogin -bool true
  defaults write com.choosyosx.Choosy runningMode 3
  set +e
  open -a Choosy
  set -e
else
  echo "(Not installed.)"
fi

echo "CommandQ ..."
if [ -e /Applications/CommandQ.app ]; then
  osascript -e "tell application \"CommandQ\" to quit"
  defaults write com.commandqapp.CommandQ delay -float 1.805555555555556
  defaults write com.commandqapp.CommandQ launchOnBoot -bool true
  set +e
  open -a CommandQ
  set -e
else
  echo "(Not installed.)"
fi

echo "Day One ..."
if [ -e "/Applications/Day One.app" ]; then
  osascript -e "tell application \"Day One\" to quit"
  # shellcheck disable=SC2016
  defaults write com.bloombuilt.dayone-mac NSUserKeyEquivalents '{
    "Main Window" = "@0";
  }'
else
  echo "(Not installed.)"
fi

echo "Due ..."
if [ -e "/Applications/Due.app" ]; then
  osascript -e "tell application \"Due\" to quit"
  # shellcheck disable=SC2016
  defaults write com.phocusllp.duemac prefIntApplicationRunningMode -int 1
  defaults write com.phocusllp.duemac prefIntDefaultContentSizeCategory -int 0
  defaults write com.phocusllp.duemac prefIntWeekStarts -int 1
  defaults write com.phocusllp.duemac prefStringDue2ThemeName -string "Change with System"
  defaults write com.phocusllp.duemac prefStringLastAutoDarkThemeName -string "Slate Dark";
  defaults write com.phocusllp.duemac prefStringLastAutoLightThemeName -string "Vanilla Lilac";
  set +e
  open -a Due
  set -e
else
  echo "(Not installed.)"
fi

echo "Fantastical..."
if [ -e "/Applications/Fantastical.app" ]; then
  osascript -e "tell application \"Fantastical\" to quit"
  # shellcheck disable=SC2016
  defaults write com.flexibits.fantastical2.mac NSUserKeyEquivalents '{
    "Refresh All" = "@r";
    Reminders = "@^$r";
  }'
else
  echo "(Not installed.)"
fi

echo "FastScripts..."
if [ -e "/Applications/FastScripts.app" ]; then
  osascript -e "tell application \"FastScripts\" to quit"
  defaults write com.red-sweater.fastscripts ShellScriptEditorIdentifier "com.sublimetext.3"
  # update via:
  # defaults read com.red-sweater.fastscripts ScriptKeyboardShortcuts | sed 's/[^0-9a-f]*//g'
  defaults write com.red-sweater.fastscripts ScriptKeyboardShortcuts -data \
    "62706c6973743030d40102030405066061582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0af1015070811121820242f3238393d4145494d515255585c55246e756c6cd3090a0b0c0e10574e532e6b6579735a4e532e6f626a656374735624636c617373a10d8002a10f800380135f101044656661756c74486f744b6579536574d313140b150d17522431522430800480028014d3090a0b191c10a21a1b80058007a21d1e8008800f8013d313140b212223111200101f8006d325262728292d5a24636c6173736e616d655824636c61737365735b24636c61737368696e74735d5253486f744b6579436f6d626fa32a2b2c5d5253486f744b6579436f6d626f5f10135253436f6e7461696e61626c654f626a656374584e534f626a656374a12e5b486f744b6579436f6d626fd313140b213023101d8006d333340b3536375f10196b50657273697374656e74546172676574426f6f6b6d61726b5f101d6b50657273697374656e7454617267657452656c617469766550617468800a8009800e5f102b7e2f4c6962726172792f536372697074732f517569636b2046696e6420696e205468696e67732e73637074d23a0b3b3c5f10166b426f6f6b6d61726b436f64696e67446174614b6579800b800dd23e0b3f40574e532e646174614f1103c0626f6f6bc003000000000410300000000000000000000000000000000000000000000000000000000000000000000000bc02000005000000010100005573657273000000080000000101000063647a6f6d62616b07000000010100004c69627261727900070000000101000053637269707473001900000001010000517569636b2046696e6420696e205468696e67732e7363707400000014000000010600000400000014000000240000003400000044000000080000000403000075d5090000000000080000000403000073890f0000000000080000000403000074890f00000000000800000004030000f9a85f00000000000800000004030000a65705030000000014000000010600008400000094000000a4000000b4000000c4000000080000000004000041c1f5b9ff1d0ab7180000000102000001000000000000000f000000000000000000000000000000080000000403000003000000000000000400000003030000f5010000080000000109000066696c653a2f2f2f0c000000010100004d6163696e746f736820484408000000040300000050065e3a000000080000000004000041c07657ba5ff15c240000000101000039394545363836392d324430302d344342322d414138442d32343139333934343141324218000000010200008100000001000000ef13000001000000000000000000000001000000010100002f0000000000000001050000d300000001020000633038663164333061316639666364646231653662393632326238656565643161626661373431383b30303b30303030303030303b30303030303030303b30303030303030303b303030303030303030303030303032303b636f6d2e6170706c652e6170702d73616e64626f782e726561642d77726974653b30313b30313030303030343b303030303030303030333035353761363b30313b2f75736572732f63647a6f6d62616b2f6c6962726172792f736372697074732f717569636b2066696e6420696e207468696e67732e736370740000cc000000feffffff01000000000000001000000004100000680000000000000005100000d40000000000000010100000000100000000000040100000f00000000000000002200000cc01000000000000052000003c01000000000000102000004c0100000000000011200000800100000000000012200000600100000000000013200000700100000000000020200000ac0100000000000030200000d80100000000000001c00000200100000000000011c00000140000000000000012c00000300100000000000080f00000e001000000000000800cd2252642435d4e534d757461626c6544617461a342442c564e5344617461d2252646475a5253426f6f6b6d61726ba2482c5a5253426f6f6b6d61726bd225264a4b5f101450657273697374656e7454726565546172676574a24c2c5f101450657273697374656e7454726565546172676574d333340b4e4f3780118010800e5f10247e2f4c6962726172792f536372697074732f546f67676c65205468696e67732e73637074d23a0b533c8012800dd23e0b56404f1103b0626f6f6bb003000000000410300000000000000000000000000000000000000000000000000000000000000000000000ac02000005000000010100005573657273000000080000000101000063647a6f6d62616b07000000010100004c69627261727900070000000101000053637269707473001200000001010000546f67676c65205468696e67732e73637074000014000000010600000400000014000000240000003400000044000000080000000403000075d5090000000000080000000403000073890f0000000000080000000403000074890f00000000000800000004030000f9a85f00000000000800000004030000af5205030000000014000000010600007c0000008c0000009c000000ac000000bc000000080000000004000041c1f5b94e9e8161180000000102000001000000000000000f000000000000000000000000000000080000000403000003000000000000000400000003030000f5010000080000000109000066696c653a2f2f2f0c000000010100004d6163696e746f736820484408000000040300000050065e3a000000080000000004000041c07657ba5ff15c240000000101000039394545363836392d324430302d344342322d414138442d32343139333934343141324218000000010200008100000001000000ef13000001000000000000000000000001000000010100002f0000000000000001050000cc00000001020000623639643331316339653038646235333036353930303361633038373030643535333561333432663b30303b30303030303030303b30303030303030303b30303030303030303b303030303030303030303030303032303b636f6d2e6170706c652e6170702d73616e64626f782e726561642d77726974653b30313b30313030303030343b303030303030303030333035353261663b30313b2f75736572732f63647a6f6d62616b2f6c6962726172792f736372697074732f746f67676c65207468696e67732e7363707400cc000000feffffff01000000000000001000000004100000600000000000000005100000cc0000000000000010100000f80000000000000040100000e80000000000000002200000c40100000000000005200000340100000000000010200000440100000000000011200000780100000000000012200000580100000000000013200000680100000000000020200000a40100000000000030200000d00100000000000001c00000180100000000000011c00000140000000000000012c00000280100000000000080f00000d801000000000000800cd22526595a5f10134e534d757461626c6544696374696f6e617279a3595b2c5c4e5344696374696f6e617279d225265d5e5f1013486f744b6579507265666572656e6365536574a25f2c5f1013486f744b6579507265666572656e63655365745f100f4e534b657965644172636869766572d1626354726f6f74800100080011001a0023002d00320037004f0055005c0064006f00760078007a007c007e00800093009a009d00a000a200a400a600ad00b000b200b400b700b900bb00bd00c400c700c900cb00d200dd00e600f2010001040112012801310133013f01460148014a0151016d018d018f0191019301c101c601df01e101e301e801f005b405b605bb05c905cd05d405d905e405e705f205f7060e06110628062f063106330635065c066106630665066a0a1e0a200a250a3b0a3f0a4c0a510a670a6a0a800a920a950a9a0000000000000201000000000000006400000000000000000000000000000a9c"
  set +e
  open -a FastScripts
  set -e
else
  echo "(Not installed.)"
fi

echo "Fork..."
if [ -e "/Applications/Fork.app" ]; then
  osascript -e "tell application \"Fork\" to quit"
  if [ -e "$HOME/code" ]; then
    defaults write com.DanPristupov.Fork defaultSourceFolder "$HOME/code"
  else
    defaults write com.DanPristupov.Fork defaultSourceFolder "$HOME"
  fi
  defaults write com.DanPristupov.Fork diffFontName "MesloLGM-Regular"
  defaults write com.DanPristupov.Fork diffFontSize 11
  defaults write com.DanPristupov.Fork diffFontSize 13
  defaults write com.DanPristupov.Fork SUAutomaticallyUpdate 1
  if ! grep -c "Fork.app" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## Fork.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Set Git instance" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Set Terminal tool (iTerm2)" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Set Diff & Merge tools (Kaleidoscope)" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
else
  echo "(Not installed.)"
fi

echo "Front and Center..."
if [ -e "/Applications/Front and Center.app" ]; then
  osascript -e "tell application \"Front and Center\" to quit"
  defaults write co.hypercritical.Front-and-Center defaultBehavior 2
  defaults write co.hypercritical.Front-and-Center hideOnLaunch -bool true
  defaults write co.hypercritical.Front-and-Center launchOnLogin -bool true
  defaults write co.hypercritical.Front-and-Center showDockIcon -bool false
  defaults write co.hypercritical.Front-and-Center showMenuBarIcon -bool true
  defaults write co.hypercritical.Front-and-Center triggerType 1
  set +e
  open -a "Front and Center"
  set -e
else
  echo "(Not installed.)"
fi

echo "Google Chrome..."
if [ -e "/Applications/Google Chrome.app" ]; then
  # Potentially too destructive...
  # osascript -e "tell application \"Google Chrome\" to quit"

  # echo ""
  # echo "Using the system-native print preview dialog in Chrome"
  # defaults write com.google.Chrome DisablePrintPreview -bool true
  # defaults write com.google.Chrome.canary DisablePrintPreview -bool true

  echo "  Disable annoying Chrome swipe-to-navigate gesture"
  defaults write com.google.Chrome.plist AppleEnableSwipeNavigateWithScrolls -bool FALSE
else
  echo "(Not installed.)"
fi

echo "Living Earth..."
if [ -e "/Applications/Living Earth Desktop.app" ]; then
  osascript -e "tell application \"Living Earth Desktop\" to quit"
  defaults write com.radiantlabs.LivingEarthHDDesktop applicationStyle 0
  defaults write com.radiantlabs.LivingEarthHDDesktop hotKey 0
  defaults write com.radiantlabs.LivingEarthHDDesktop screenSaverHotKey 0
  set +e
  open -a "Living Earth Desktop"
  set -e
else
  echo "(Not installed.)"
fi

echo "NepTunes..."
if [ -e /Applications/NepTunes.app ]; then
  osascript -e "tell application \"NepTunes\" to quit"
  defaults write pl.micropixels.NepTunes ShowCover -bool false
  defaults write pl.micropixels.NepTunes integrationWithiTunes -bool false
  defaults write pl.micropixels.NepTunes launchAtLogin -bool true
  defaults write pl.micropixels.NepTunes loveTrackOniTunes -bool true
  set +e
  open -a "NepTunes"
  set -e
else
  echo "(Not installed.)"
fi

echo "Pastebot..."
if [ -e "/Applications/Pastebot.app" ]; then
  osascript -e "tell application \"Pastebot\" to quit"
  defaults write com.tapbots.Pastebot2Mac AlwaysPastePlainText -bool true
  defaults write com.tapbots.Pastebot2Mac SoundsEnabled -bool false
  defaults write com.tapbots.Pastebot2Mac UIVisibilityState 2
  defaults write com.tapbots.Pastebot2Mac "StartSequentialPasteHotKeyCleared" '1'
  defaults write com.tapbots.Pastebot2Mac "PasteAndDequeueHotKeyCleared" '1'
  set +e
  open -a "Pastebot"
  set -e
else
  echo "(Not installed.)"
fi

echo "RadarScope..."
if [ -e "/Applications/RadarScope.app" ]; then
  osascript -e "tell application \"RadarScope\" to quit"
  defaults write com.basevelocity.mac.RadarScope dataProvider -string "wdt"
  defaults write com.basevelocity.mac.RadarScope lightningProvider -string "wdtp"
  defaults write com.basevelocity.mac.RadarScope showCities -bool false
  defaults write com.basevelocity.mac.RadarScope showDiscussions -bool true
  defaults write com.basevelocity.mac.RadarScope showLightning -bool true
  defaults write com.basevelocity.mac.RadarScope showResearchRadars -bool true
  defaults write com.basevelocity.mac.RadarScope showStormTracks -bool true
  defaults write com.basevelocity.mac.RadarScope showTDWRs -bool true
  defaults write com.basevelocity.mac.RadarScope showWatches -bool true
  defaults write com.basevelocity.mac.RadarScope warningProvider -string "wdt"
else
  echo "(Not installed.)"
fi

echo "Reeder..."
if [ -e "/Applications/Reeder.app" ]; then
  osascript -e "tell application \"Reeder\" to quit"
  defaults write com.reederapp.macOS "app.appearance" 10
  defaults write com.reederapp.macOS "app.content-size-category" 3
  defaults write com.reederapp.macOS "app.default-browser" -string "com.apple.Safari"
  defaults write com.reederapp.macOS "app.filter" 2
  defaults write com.reederapp.macOS "app.grayscale-favicons" -bool true
  defaults write com.reederapp.macOS "app.layout" 0
  defaults write com.reederapp.macOS "app.state.controller" -string "streams"
  defaults write com.reederapp.macOS "app.state.stream.type" 0
  defaults write com.reederapp.macOS "app.state.stream.user" -string "Feedbin/chris@chrisdzombak.net"
  defaults write com.reederapp.macOS "app.state.user" -string "Feedbin/chris@chrisdzombak.net"
  defaults write com.reederapp.macOS "article.font-size" 17
  defaults write com.reederapp.macOS "article.increase-contrast" -bool true
  defaults write com.reederapp.macOS "bionic.toolbar" -bool false
  defaults write com.reederapp.macOS "browser.open-links-in-background" -bool true
  defaults write com.reederapp.macOS "browser.open-links-in-default-browser" -bool true
  defaults write com.reederapp.macOS "corekit.animator.configuration" 2
  defaults write com.reederapp.macOS "subscriptions-hide-allitems-count" -bool false
else
  echo "(Not installed.)"
fi

echo "Rocket..."
if [ -e "/Applications/Rocket.app" ]; then
  osascript -e "tell application \"Rocket\" to quit"
  defaults write net.matthewpalmer.Rocket SUAutomaticallyUpdate -bool true
  defaults write net.matthewpalmer.Rocket launch-at-login -bool true
  defaults write net.matthewpalmer.Rocket rocket-updater-use-beta -bool true
  defaults write net.matthewpalmer.Rocket "preferred-skin-tone" 2
  defaults write net.matthewpalmer.Rocket deactivated-apps '(
      Slack,
      HipChat,
      Xcode,
      Terminal,
      iTerm2,
      "Sublime Text",
      "Sublime Text 2",
      "IntelliJ IDEA",
      "jetbrains-toolbox-launcher",
      Dash,
      studio,
      Bear,
      goland,
      Fork,
      VirtualBox,
      WebStorm,
      pycharm
  )'
  defaults write net.matthewpalmer.Rocket "deactivated-website-patterns" '(
      "github.com",
      "trello.com",
      "slack.com",
      "pinboard.in",
      "a2mi.social",
      "app.logz.io",
      "mail.google.com",
      "console.aws.amazon.com",
      "bitbucket.org"
  )'
  set +e
  open -a Rocket
  set -e
else
  echo "(Not installed.)"
fi

echo "Things ..."
if [ -e "/Applications/Things3.app" ]; then
  osascript -e "tell application \"Things3\" to quit"
  # shellcheck disable=SC2016
  defaults write com.culturedcode.ThingsMac NSUserKeyEquivalents '{
    "New Repeating To-Do" = "@$r";
  }'
  defaults write com.culturedcode.ThingsMac CCDockCountType 1
  defaults write com.culturedcode.ThingsMac UriSchemeEnabled -bool true
  set +e
  open -a "Things3"
  set -e
else
  echo "(Not installed.)"
fi

echo "Tweetbot ..."
if [ -e "/Applications/Tweetbot.app" ]; then
  osascript -e "tell application \"Tweetbot\" to quit"
  # https://twitter.com/dancounsell/status/667011332894535682
  defaults write com.tapbots.TweetbotMac OpenURLsDirectly YES
else
  echo "(Not installed.)"
fi

echo "Typora..."
if [ -e "/Applications/Typora.app" ]; then
  osascript -e "tell application \"Typora\" to quit"
  defaults write abnerworks.Typora "auto_expand_block" 0
  defaults write abnerworks.Typora "copy_markdown_by_default" 1
  defaults write abnerworks.Typora "enable_inline_math" 1
  defaults write abnerworks.Typora prettyIndent 0
  defaults write abnerworks.Typora quitAfterWindowClose 1
  defaults write abnerworks.Typora "strict_mode" 1
  defaults write abnerworks.Typora theme "Github"
  defaults write abnerworks.Typora "use_seamless_window" 1
else
  echo "(Not installed.)"
fi

echo "Xcode ..."
if [ -e /Applications/Xcode.app ]; then
  osascript -e "tell application \"Xcode\" to quit"

  # shellcheck disable=SC2016
  defaults write com.apple.dt.Xcode NSUserKeyEquivalents '{
      "Jump to Generated Interface" = "@^$i";
      "Print…" = "@~^$p";
  }'

  # See http://merowing.info/2015/12/little-things-that-can-make-your-life-easier-in-2016/

  echo "  Show how long it takes to build your project"
  defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
  echo "  Enable faster build times by leveraging multi-core CPU"
  defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks $(sysctl -n hw.ncpu)
else
  echo "(Not installed.)"
fi

echo ""
cecho "--- Setapp ---" $white
echo ""

echo "Setapp..."
if [ -e "/Applications/Setapp.app" ]; then
  osascript -e "tell application \"Setapp\" to quit"
  defaults write com.setapp.DesktopClient EnableLauncher -bool false
  defaults write com.setapp.DesktopClient KeepTeasers -bool false
  defaults write com.setapp.DesktopClient ShouldLoadFinderSyncExtensionOnLaunch -bool false
  set +e
  open -a "Setapp"
  set -e
else
  echo "(Not installed.)"
fi

echo "CloudMounter ..."
if [ -e "/Applications/Setapp/CloudMounter.app" ]; then
  osascript -e "tell application \"CloudMounter\" to quit"
  defaults write com.eltima.cloudmounter-setapp auto-launch -bool true
  defaults write com.eltima.cloudmounter-setapp auto-mount -bool true
  defaults write com.eltima.cloudmounter-setapp SkipWelcomeEncrypt -bool true
  if ! grep -c "CloudMounter" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## CloudMounter" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Add Personal Google Drive" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Add Work Google Drive (as desired)" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Add Personal Dropbox" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Add Goliath ~ (local)" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Add Wasabi" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
  set +e
  open -a "CloudMounter"
  set -e
else
  echo "(Not installed.)"
fi

echo "Forecast Bar ..."
if [ -e "/Applications/Setapp/Forecast Bar.app" ]; then
  if ! grep -c "Forecast Bar" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## Forecast Bar" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Set shift-ctrl-x global shortcut" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Configure as desired" >> "$HOME/SystemSetup.md" # doesn't use UserDefaults :(
    echo "" >> "$HOME/SystemSetup.md"
  fi
else
  echo "(Not installed.)"
fi

echo "HazeOver ..."
if [ -e "/Applications/Setapp/HazeOver.app" ]; then
  osascript -e "tell application \"HazeOver\" to quit"
  defaults write com.pointum.hazeover-setapp Animation -float "0.05"
  defaults write com.pointum.hazeover-setapp AskSecondaryDisplay -bool false
  defaults write com.pointum.hazeover-setapp Enabled -bool true
  defaults write com.pointum.hazeover-setapp IndependentScreens -bool true
  defaults write com.pointum.hazeover-setapp Intensity -float "5.167723137178133"
  defaults write com.pointum.hazeover-setapp MultiFocus -bool true
  if ! grep -c "HazeOver" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## HazeOver" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Hide in Bartender" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Configure as desired" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
  set +e
  open -a "HazeOver"
  set -e
else
  echo "(Not installed.)"
fi

echo "Path Finder ..."
if [ -e "/Applications/Setapp/Path Finder.app" ]; then
  osascript -e "tell application \"Path Finder\" to quit"
  defaults write com.cocoatech.PathFinder-setapp disableWarnOnQuit -bool true
  defaults write com.cocoatech.PathFinder-setapp globalAppsMenuEnabled -bool false
  defaults write com.cocoatech.PathFinder-setapp kNTDiffToolPath "/usr/local/bin/ksdiff"
  defaults write com.cocoatech.PathFinder-setapp kOpenTextEditDocumentsInTextEditor -bool false
  defaults write com.cocoatech.PathFinder-setapp kTerminalApplicationPath "/Applications/iTerm.app"
  defaults write com.cocoatech.PathFinder-setapp textEditorApplicationPath "/Applications/Sublime Text.app"
else
  echo "(Not installed.)"
fi

echo "SQLPro Studio ..."
if [ -e "/Applications/Setapp/SQLPro Studio.app" ]; then
  osascript -e "tell application \"SQLPro Studio\" to quit"
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-DisableSampleConnections" '1'
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-QueryMenuKeyEquivalentMask" '1048576'
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-QueryMenuKeyEquivalent" '"\U21a9"'
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-CommentUncommentShortcutKeyEquivalent" '/'
else
  echo "(Not installed.)"
fi

echo "ToothFairy ..."
if [ -e "/Applications/Setapp/ToothFairy.app" ]; then
  osascript -e "tell application \"ToothFairy\" to quit"
  defaults write com.c-command.toothfairy-setapp hideDockIcon -bool true
  defaults write com.c-command.toothfairy-setapp launchAtLogin -bool true
  cecho "Configure otherwise as desired; add AirPods to menu bar." $white
  set +e
  open -a "ToothFairy"
  set -e
else
  echo "(Not installed.)"
fi

echo "Trickster ..."
if [ -e "/Applications/Setapp/Trickster.app" ]; then
  osascript -e "tell application \"Trickster\" to quit"
  defaults write com.apparentsoft.trickster-setapp Anchor -bool true
  defaults write com.apparentsoft.trickster-setapp Attached -bool true
  defaults write com.apparentsoft.trickster-setapp DetachEnabled -bool false
  defaults write com.apparentsoft.trickster-setapp FavoritesVisible -bool true
  defaults write com.apparentsoft.trickster-setapp "Fade out" -bool false
  if ! grep -c "Trickster" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## Trickster" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Set ctrl-shift-Y global show/hide shortcut" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Configure file tracking based on screenshot in \`~/Sync/Configs\`" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
  set +e
  open -a "Trickster"
  set -e
else
  echo "(Not installed.)"
fi

echo ""
cecho "--- Setapp _or_ Standard Installed ---" $white
echo ""

echo "CodeRunner (Setapp)..."
if [ -e "/Applications/Setapp/CodeRunner.app" ]; then
  osascript -e "tell application \"CodeRunner\" to quit"
  defaults write com.krill.CodeRunner-setapp ColorTheme -string "Solarized (light)"
  defaults write com.krill.CodeRunner-setapp DefaultTabModeSoftTabs 1
  cecho "Configure otherwise as desired; recommend Meslo LG M 14pt." $white
else
  echo "(Not installed.)"
fi

echo "CodeRunner (Standard)..."
if [ -e "/Applications/CodeRunner.app" ]; then
  osascript -e "tell application \"CodeRunner\" to quit"
  defaults write com.krill.CodeRunner ColorTheme -string "Solarized (light)"
  defaults write com.krill.CodeRunner DefaultTabModeSoftTabs 1
  cecho "Configure otherwise as desired; recommend Meslo LG M 14pt." $white
else
  echo "(Not installed.)"
fi

echo "Marked (Setapp)..."
if [ -e "/Applications/Setapp/Marked 2.app" ]; then
  osascript -e "tell application \"Marked 2\" to quit"
  defaults write com.brettterpstra.marked2-setapp WebKitDeveloperExtras -bool true
  defaults write com.brettterpstra.marked2-setapp convertGithubCheckboxes -bool true
  defaults write com.brettterpstra.marked2-setapp defaultProcessor -string "Discount (GFM)"
  defaults write com.brettterpstra.marked2-setapp defaultSyntaxStyle -string "GitHub"
  defaults write com.brettterpstra.marked2-setapp externalEditor -string "Typora"
  defaults write com.brettterpstra.marked2-setapp externalImageEditor -string "Pixelmator"
  defaults write com.brettterpstra.marked2-setapp includeMathJax -bool true
  defaults write com.brettterpstra.marked2-setapp isMultiMarkdownDefault -bool false
  defaults write com.brettterpstra.marked2-setapp syntaxHighlight -bool true
else
  echo "(Not installed.)"
fi

echo "Marked (Standard)..."
if [ -e "/Applications/Marked 2.app" ]; then
  osascript -e "tell application \"Marked 2\" to quit"
  defaults write com.brettterpstra.marked2 WebKitDeveloperExtras -bool true
  defaults write com.brettterpstra.marked2 convertGithubCheckboxes -bool true
  defaults write com.brettterpstra.marked2 defaultProcessor -string "Discount (GFM)"
  defaults write com.brettterpstra.marked2 defaultSyntaxStyle -string "GitHub"
  defaults write com.brettterpstra.marked2 externalEditor -string "Typora"
  defaults write com.brettterpstra.marked2 externalImageEditor -string "Pixelmator"
  defaults write com.brettterpstra.marked2 includeMathJax -bool true
  defaults write com.brettterpstra.marked2 isMultiMarkdownDefault -bool false
  defaults write com.brettterpstra.marked2 syntaxHighlight -bool true
  cecho "Configure otherwise as desired; in particular, license and add custom CSS files." $white
else
  echo "(Not installed.)"
fi

echo ""
cecho "--- Finder Sidebar ---" $white
echo ""

WHOAMI="$(whoami)"

EXPECTED_SIDEBAR_CONTENT=(
  # formatted as output of `mysides list`
  # excluding AirDrop.
  "Applications -> file:///Applications/"
  "$WHOAMI -> file:///Users/$WHOAMI/"
  "Desktop -> file:///Users/$WHOAMI/Desktop/"
  "Documents -> file:///Users/$WHOAMI/Documents/"
  "Downloads -> file:///Users/$WHOAMI/Downloads/"
  "Sync -> file:///Users/$WHOAMI/Sync/"
  "tmp -> file:///Users/$WHOAMI/tmp/"
)

# remove anything that shouldn't be there...
mysides list | while read -r LINE; do
  # only looking at file:// URLs; don't mess with " -> nwnode://domain-AirDrop"
  if ! echo "$LINE" | grep -c "file://" >/dev/null; then continue; fi

  NAME="$(echo "$LINE" | awk 'BEGIN {FS=" -> "} {print $1}')"
  URI="$(echo "$LINE" | awk 'BEGIN {FS=" -> "} {print $2}')"
  FOUND=false
  # if EXPECTED_SIDEBAR_CONTENT contains this line, continue to the next line:
  for i in "${EXPECTED_SIDEBAR_CONTENT[@]}"; do
    if [ "$i" == "$LINE" ] ; then FOUND=true; fi
  done
  if $FOUND; then
    cecho "✔ Found $NAME in Finder sidebar as expected." $green
    continue
  fi

  # otherwise, we don't want this one:
  cecho "Removing unwanted Finder sidebar item $NAME ($URI)..." $yellow
  mysides remove "$NAME"
done

for i in "${EXPECTED_SIDEBAR_CONTENT[@]}"; do
  if ! mysides list | grep -c "$i" >/dev/null; then
    # this line is missing from sidebar; add it
    NAME="$(echo "$i" | awk 'BEGIN {FS=" -> "} {print $1}')"
    URI="$(echo "$i" | awk 'BEGIN {FS=" -> "} {print $2}')"
    cecho "Adding Finder sidebar item $NAME ($URI)..." $cyan
    mysides add "$NAME" "$URI"
  fi
done

echo ""
cecho "--- Homebrew / Zsh ---" $white
echo ""

echo -e "This fix will use ${magenta}sudo${_reset}; enter your password to authenticate if prompted."
# Ask for the administrator password upfront and run a keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ -d /usr/local/share/zsh ]; then
  sudo chown "$WHOAMI":staff /usr/local/share/zsh
  sudo chown "$WHOAMI":staff /usr/local/share/zsh/site-functions
  sudo chmod -R 755 /usr/local/share/zsh
fi

if [ -d /opt/homebrew/share/zsh ]; then
  sudo chown "$WHOAMI":staff /opt/homebrew/share/zsh
  sudo chown "$WHOAMI":staff /opt/homebrew/share/zsh/site-functions
  sudo chmod -R 755 /opt/homebrew/share/zsh
fi

pushd "$HOME/.zsh"
find . -type f ! -path "./zsh-syntax-highlighting/*" ! -path "./zsh-syntax-highlighting" -exec chmod 600 {} \;
find . -type d ! -path "./zsh-syntax-highlighting/*" ! -path "./zsh-syntax-highlighting" -exec chmod 700 {} \;
popd
