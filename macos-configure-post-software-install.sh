#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source ./lib/cecho
source ./lib/sw_install # includes setupnote function

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
fi
# shellcheck disable=SC2088
setupnote "~/.netrc" "- [ ] Set dropbox.dzombak.com credentials"

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

echo "Avenue ..."
if [ -e "/Applications/Avenue.app" ]; then
  duti -s com.vincent-neo.Avenue public.gpx viewer
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
  osascript -e "tell application \"Bartender 4\" to quit"
  defaults write com.surteesstudios.Bartender "ReduceMenuItemSpacing" '1'
  defaults write com.surteesstudios.Bartender "ReduceUpdateCheckFrequencyWhenOnBattery" '1'
  defaults write com.surteesstudios.Bartender "BartenderBarOnlyOnNotchScreens" '1'
  defaults write com.surteesstudios.Bartender "Gaps-RequireAltOrRightClickToShowGapPopup" '1'
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

echo "Cardhop ..."
if [ -e "/Applications/Cardhop.app" ]; then
  osascript -e "tell application \"Cardhop\" to quit"
  defaults write "com.flexibits.cardhop.mac" "HideInMenubar" '1'
  defaults write "com.flexibits.cardhop.mac" "AlwaysShowAccountInGroupSummary" '1'
  defaults write "com.flexibits.cardhop.mac" "DefaultAccountExternalIDLocal" '"account:85A75CA9-6381-4B10-B066-C52CFEA5280F"'
  defaults write "com.flexibits.cardhop.mac" "DefaultAccountExternalID" '"account:85A75CA9-6381-4B10-B066-C52CFEA5280F"'
  defaults write "com.flexibits.cardhop.mac" "OpenMapsIn" 'google'
  defaults write "com.flexibits.cardhop.mac" "HotKeyEmpty" '1'
else
  echo "(Not installed.)"
fi

echo "Choosy ..."
if [ -e "/Applications/Choosy.app" ]; then
  set +e
  # On Big Sur, this _sometimes_ fails if Safari is running
  osascript -e "tell application \"Choosy\" to quit"
  set -e
  defaults write com.choosyosx.Choosy generalMode 0
  defaults write com.choosyosx.Choosy launchAtLogin -bool true
  defaults write com.choosyosx.Choosy runningMode 3
  defaults write com.choosyosx.Choosy displayBrowserNames 0
  set +e
  open -a Choosy
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
  setupnote "CloudMounter" \
    "- [ ] Add Personal Google Drive (as desired)\n- [ ] Add Personal Dropbox (as desired)\n- [ ] Add personal Wasabi account (as desired)"
  set +e
  open -a "CloudMounter"
  set -e
else
  echo "(Not installed.)"
fi

echo "CodeRunner (Setapp)..."
if [ -e "/Applications/Setapp/CodeRunner.app" ]; then
  osascript -e "tell application \"CodeRunner\" to quit"
  defaults write com.krill.CodeRunner-setapp ColorTheme -string "Solarized (light)"
  defaults write com.krill.CodeRunner-setapp DefaultTabModeSoftTabs 1
  if ! grep -c "CodeRunner" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## CodeRunner" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Set font to Meslo LG M 14pt" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Remove the million default file type associations" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Configure as desired" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
else
  echo "(Not installed.)"
fi

echo "CodeRunner (Standard)..."
if [ -e "/Applications/CodeRunner.app" ]; then
  osascript -e "tell application \"CodeRunner\" to quit"
  defaults write com.krill.CodeRunner ColorTheme -string "Solarized (light)"
  defaults write com.krill.CodeRunner DefaultTabModeSoftTabs 1
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

echo "Due ..."
if [ -e "/Applications/Due.app" ]; then
  osascript -e "tell application \"Due\" to quit"
  # shellcheck disable=SC2016
  defaults write com.phocusllp.duemac prefIntDefaultSnoozeInterval -int 600
  defaults write com.phocusllp.duemac prefIntApplicationRunningMode -int 1
  defaults write com.phocusllp.duemac prefIntDefaultContentSizeCategory -int 0
  defaults write com.phocusllp.duemac prefIntWeekStarts -int 1
  defaults write com.phocusllp.duemac prefStringDue2ThemeName -string "Change with System"
  defaults write com.phocusllp.duemac prefStringLastAutoDarkThemeName -string "Obsidian";
  defaults write com.phocusllp.duemac prefStringLastAutoLightThemeName -string "Calcite";
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
  set +e
  killall 85C27NK92C.com.flexibits.fantastical2.mac.helper
  # shellcheck disable=SC2016
  defaults write 85C27NK92C.com.flexibits.fantastical2.mac.helper NSUserKeyEquivalents '{
    "Refresh All" = "@r";
    Reminders = "@^$r";
  }'
  killall 85C27NK92C.com.flexibits.fantastical2.mac.helper
  set -e
else
  echo "(Not installed.)"
fi

echo "FastScripts..."
if [ -e "/Applications/FastScripts.app" ]; then
  osascript -e "tell application \"FastScripts\" to quit"
  defaults write com.red-sweater.fastscripts3 ShellScriptEditorIdentifier "com.sublimetext.4"
  # update via:
  # defaults read com.red-sweater.fastscripts3 ScriptKeyboardShortcuts | sed 's/[^0-9a-f]*//g'
  defaults write com.red-sweater.fastscripts3 ScriptKeyboardShortcuts -data \
    "e2925be062706c6973743030d4010203040506070000000000000a97"
  set +e
  open -a FastScripts
  set -e
else
  echo "(Not installed.)"
fi

echo "Forecast Bar ..."
if [ -e "/Applications/Setapp/Forecast Bar.app" ]; then
  setupnote "Forecast Bar" \
    "- [ ] Set shift-ctrl-x global shortcut\n- [ ] Select monochrome menu bar icons\n- [ ] Configure as desired"
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

echo "Glyphfinder ..."
if [ -e "/Applications/Setapp/Glyphfinder.app" ]; then
  setupnote "Glyphfinder.app" "- [ ] Set shortcut Ctrl+Shift+G"
  set +e
  open -a "Glyphfinder"
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

echo "Grids ..."
if [ -e "/Applications/Setapp/Grids.app" ]; then
  osascript -e "tell application \"Grids\" to quit"
  defaults write "com.thinktimecreations.Grids" "Application.DoNotShowLoginWarning" '1'
  setupnote "Grids" \
    "- [ ] Disable menu bar icon\n- [ ] Disable most or all notifications\n- [ ] Set spacing to \`16\`\n- [ ] Set picture size to \`4\`\n- [ ] Do not show stories or ads\n- [ ] Sign in"
else
  echo "(Not installed.)"
fi

echo "Hand Mirror ..."
if [ -e "/Applications/Hand Mirror.app" ]; then
  osascript -e "tell application \"Hand Mirror\" to quit"
  defaults write "net.rafaelconde.Hand-Mirror" "selectedUIIcon" "Menu_Aperture"
  defaults write "net.rafaelconde.Hand-Mirror" "selectedPopoverSize" 'Medium'
  defaults write "net.rafaelconde.Hand-Mirror" "dismissPreference" '1'
  defaults write "net.rafaelconde.Hand-Mirror" "smartWindowPreference" '0'
  defaults write "net.rafaelconde.Hand-Mirror" "windowMaskPreference" '0'
  defaults write "net.rafaelconde.Hand-Mirror" "selectedMirroringPreference" '1'
  set +e
  open -a "Hand Mirror"
  set -e
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
  setupnote "HazeOver" \
    "- [ ] Hide in Bartender\n- [ ] Start at Login"
  set +e
  open -a "HazeOver"
  set -e
else
  echo "(Not installed.)"
fi

echo "Hex Fiend ..."
if [ -e "/Applications/Hex Fiend.app" ]; then
  osascript -e "tell application \"Hex Fiend\" to quit"
  defaults write com.ridiculousfish.HexFiend DefaultEditMode 2
else
  echo "(Not installed.)"
fi

echo "Ivory ..."
if [ -e "/Applications/Ivory.app" ]; then
  osascript -e "tell application \"Ivory\" to quit"
  defaults write com.tapbots.Ivory fontSize 16
else
  echo "(Not installed.)"
fi

echo "JSON Editor ..."
if [ -e "/Applications/JSON Editor.app" ]; then
  osascript -e "tell application \"JSON Editor\" to quit"
  defaults write com.vladbadea.jsoneditor PLEPlistOutlineViewFontName "MesloLGM-Regular"
  defaults write com.vladbadea.jsoneditor PLEPlistOutlineViewFontSize 13
else
  echo "(Not installed.)"
fi

echo "KeyCastr..."
if [ -e "/Applications/KeyCastr.app" ]; then
  osascript -e "tell application \"KeyCastr\" to quit"
  defaults write "io.github.keycastr" "default.fontSize" '"61.50496794871795"'
  defaults write "io.github.keycastr" "default.commandKeysOnly" '1'
  defaults write "io.github.keycastr" "selectedVisualizer" 'Default'
  defaults write "io.github.keycastr" "default.fadeDelay" '"1.646634615384615"'
fi

echo "Keysmith ..."
if [ -e "/Applications/Setapp/Keysmith.app" ]; then
  osascript -e "tell application \"Keysmith\" to quit"
  defaults write "app.keysmith.Keysmith-setapp" "shouldEnableEnhancedAXModeInBrowsers" '1'
  if ! grep -c "Keysmith.app" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## Keysmith.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Change quick launcher shortcut to Ctrl+Option+Command+Space, to avoid Finder search conflict" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Enable sync via Syncthing" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Hide in Bartender" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
  set +e
  open -a "Keysmith"
  set -e
else
  echo "(Not installed.)"
fi

echo "LaunchControl ..."
if [ -e "/Applications/LaunchControl.app" ]; then
  osascript -e "tell application \"LaunchControl\" to quit"
  defaults write "com.soma-zone.LaunchControl" "restoreSessionUponStart" '1'
  defaults write "com.soma-zone.LaunchControl" "changeLabelWhenRename" '1'
  defaults write "com.soma-zone.LaunchControl" "fileEditor" '"/Applications/Sublime Text.app"'
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

echo "Lunar..."
if [ -e "/Applications/Lunar.app" ]; then
  osascript -e "tell application \"Lunar\" to quit"
  defaults write fyi.lunar.Lunar syncPollingSeconds 1
  defaults write fyi.lunar.Lunar smoothTransition 1
  defaults write fyi.lunar.Lunar hotkeys '(
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":2816,\"keyCode\":37,\"identifier\":\"lunar\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4096,\"keyCode\":25,\"identifier\":\"orientation90\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4096,\"keyCode\":26,\"identifier\":\"orientation270\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4096,\"keyCode\":28,\"identifier\":\"orientation180\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4096,\"keyCode\":29,\"identifier\":\"orientation0\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4352,\"keyCode\":18,\"identifier\":\"percent25\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4352,\"keyCode\":19,\"identifier\":\"percent50\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4352,\"keyCode\":20,\"identifier\":\"percent75\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4352,\"keyCode\":21,\"identifier\":\"percent100\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4352,\"keyCode\":22,\"identifier\":\"blackOut\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4352,\"keyCode\":23,\"identifier\":\"faceLight\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4352,\"keyCode\":29,\"identifier\":\"percent0\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":4864,\"keyCode\":22,\"identifier\":\"blackOutNoMirroring\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":6400,\"keyCode\":22,\"identifier\":\"blackOutPowerOff\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":6400,\"keyCode\":37,\"identifier\":\"toggle\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":6912,\"keyCode\":22,\"identifier\":\"blackOutOthers\"}",
    "{\"allowsHold\":false,\"enabled\":false,\"modifiers\":8388864,\"keyCode\":109,\"identifier\":\"muteAudio\"}",
    "{\"allowsHold\":false,\"enabled\":true,\"modifiers\":6400,\"keyCode\":37,\"identifier\":\"restart\"}",
    "{\"allowsHold\":true,\"enabled\":false,\"modifiers\":8388864,\"keyCode\":103,\"identifier\":\"volumeDown\"}",
    "{\"allowsHold\":true,\"enabled\":false,\"modifiers\":8388864,\"keyCode\":111,\"identifier\":\"volumeUp\"}",
    "{\"allowsHold\":true,\"enabled\":false,\"modifiers\":8388864,\"keyCode\":120,\"identifier\":\"brightnessUp\"}",
    "{\"allowsHold\":true,\"enabled\":false,\"modifiers\":8388864,\"keyCode\":122,\"identifier\":\"brightnessDown\"}",
    "{\"allowsHold\":true,\"enabled\":false,\"modifiers\":8389376,\"keyCode\":120,\"identifier\":\"contrastUp\"}",
    "{\"allowsHold\":true,\"enabled\":false,\"modifiers\":8389376,\"keyCode\":122,\"identifier\":\"contrastDown\"}",
    "{\"allowsHold\":true,\"enabled\":true,\"modifiers\":8390912,\"keyCode\":103,\"identifier\":\"preciseVolumeDown\"}",
    "{\"allowsHold\":true,\"enabled\":true,\"modifiers\":8390912,\"keyCode\":111,\"identifier\":\"preciseVolumeUp\"}",
    "{\"allowsHold\":true,\"enabled\":true,\"modifiers\":8390912,\"keyCode\":120,\"identifier\":\"preciseBrightnessUp\"}",
    "{\"allowsHold\":true,\"enabled\":true,\"modifiers\":8390912,\"keyCode\":122,\"identifier\":\"preciseBrightnessDown\"}",
    "{\"allowsHold\":true,\"enabled\":true,\"modifiers\":8391424,\"keyCode\":120,\"identifier\":\"preciseContrastUp\"}",
    "{\"allowsHold\":true,\"enabled\":true,\"modifiers\":8391424,\"keyCode\":122,\"identifier\":\"preciseContrastDown\"}"
  )'
  defaults write fyi.lunar.Lunar SUAutomaticallyUpdate 1
  set +e
  open -a "Lunar"
  set -e
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
else
  echo "(Not installed.)"
fi

echo "Mimestream ..."
if [ -e "/Applications/Mimestream.app" ]; then
  osascript -e "tell application \"Mimestream\" to quit"
  defaults write com.mimestream.Mimestream TextSizeAdjustment 2
  defaults write com.mimestream.Mimestream HideBadgeForSpam 1
  defaults write com.mimestream.Mimestream PlaySounds none
  defaults write com.mimestream.Mimestream DeleteKeyAction 'trash'
else
  echo "(Not installed.)"
fi

echo "Mission Control Plus ..."
if [ -e "/Applications/Setapp/Mission Control Plus.app" ]; then
  if ! grep -c "Mission Control Plus.app" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## Mission Control Plus.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Disable complex keyboard shortcuts" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Hide in menu bar" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
  set +e
  open -a "Mission Control Plus"
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

echo "Ohtipi ..."
if [ -e "/Applications/Setapp/Ohtipi.app" ]; then
  passetupnote "Ohtipi" \
    "- [ ] Grant Full Disk Access\n- [ ] Open at login\n- [ ] Hide in Bartender"
else
  echo "(Not installed.)"
fi

echo "OmniOutliner..."
if [ -e "/Applications/OmniOutliner.app" ]; then
  osascript -e "tell application \"OmniOutliner\" to quit"
  defaults write com.omnigroup.OmniOutliner5 OOReturnShouldCreateNewRow 0
  defaults write com.omnigroup.OmniOutliner5 OOTabShouldNavigateCells 1
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

echo "Pastebot..."
if [ -e "/Applications/Pastebot.app" ]; then
  osascript -e "tell application \"Pastebot\" to quit"
  defaults write com.tapbots.Pastebot2Mac AlwaysPastePlainText -bool true
  defaults write com.tapbots.Pastebot2Mac SoundsEnabled -bool false
  defaults write com.tapbots.Pastebot2Mac UIVisibilityState 2
  defaults write com.tapbots.Pastebot2Mac "StartSequentialPasteHotKeyCleared" '1'
  defaults write com.tapbots.Pastebot2Mac "PasteAndDequeueHotKeyCleared" '1'
  defaults write com.tapbots.Pastebot2Mac "MaxNumberClipboardEntries" '500'
  set +e
  open -a "Pastebot"
  set -e
else
  echo "(Not installed.)"
fi

echo "Paw..."
if [ -e "/Applications/Paw.app" ]; then
  osascript -e "tell application \"Paw\" to quit"
  defaults write com.luckymarmot.Paw SUAutomaticallyUpdate 1
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

echo "RAW Power..."
if [ -e "/Applications/RAW Power.app" ]; then
  osascript -e "tell application \"RAW Power\" to quit"
  defaults write com.gentlemencoders.RAWPower "Save Edits Automatically" 1
  defaults write com.gentlemencoders.RAWPower "Use Current Directory for Export" 1
  defaults write 6MR872QP3J.RAWPower.sharedDefaults viewerBrightness 0.9
  defaults write 6MR872QP3J.RAWPower.sharedDefaults interfaceBrightness 0.9
else
  echo "(Not installed.)"
fi

echo "Reeder..."
if [ -e "/Applications/Reeder.app" ]; then
  osascript -e "tell application \"Reeder\" to quit"
  defaults write com.reederapp.5.macOS "app.appearance" 10
  defaults write com.reederapp.5.macOS "app.appearance.opaque" '1'
  defaults write com.reederapp.5.macOS "app.content-size-category" '3'
  defaults write com.reederapp.5.macOS "app.default-browser" -string "com.apple.Safari"
  defaults write com.reederapp.5.macOS "app.filter" 2
  defaults write com.reederapp.5.macOS "app.grayscale-favicons" -bool true
  defaults write com.reederapp.5.macOS "app.icon-badge" 0
  defaults write com.reederapp.5.macOS "app.layout" 3
  defaults write com.reederapp.5.macOS "app.state.controller" -string "streams"
  defaults write com.reederapp.5.macOS "app.state.stream.type" 0
  defaults write com.reederapp.5.macOS "app.state.stream.user" -string "Feedbin/chris@chrisdzombak.net"
  defaults write com.reederapp.5.macOS "app.state.user" -string "Feedbin/chris@chrisdzombak.net"
  defaults write com.reederapp.5.macOS "article.font-size" 17
  defaults write com.reederapp.5.macOS "article.increase-contrast" -bool true
  defaults write com.reederapp.5.macOS "article.max.width" '40'
  defaults write com.reederapp.5.macOS "bionic.toolbar" -bool false
  defaults write com.reederapp.5.macOS "browser.open-links-in-background" -bool true
  defaults write com.reederapp.5.macOS "browser.open-links-in-default-browser" -bool true
  defaults write com.reederapp.5.macOS "corekit.animator.configuration" 2
  defaults write com.reederapp.5.macOS "subscriptions-hide-allitems-count" -bool false
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

echo "Screens ..."
if [ -e "/Applications/Setapp/Screens.app" ]; then
  osascript -e "tell application \"Screens\" to quit"
  defaults write "com.edovia.screens.mac-setapp" "showInMenuBar" '0'
  defaults write "com.edovia.screens.mac-setapp" "CollapseDiscoveredViewKey" '1'
  defaults write "com.edovia.screens.mac-setapp" "useSharedClipboardMac" '1'
  if ! grep -c "Screens.app" "$HOME/SystemSetup.md" >/dev/null; then
    echo "## Screens.app" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Sign into Connect" >> "$HOME/SystemSetup.md"
    echo -e "- [ ] Enable iCloud sync" >> "$HOME/SystemSetup.md"
    echo "" >> "$HOME/SystemSetup.md"
  fi
else
  echo "(Not installed.)"
fi

echo "Setapp..."
if [ -e "/Applications/Setapp.app" ]; then
  osascript -e "tell application \"Setapp\" to quit"
  defaults write com.setapp.DesktopClient EnableLauncher -bool false
  defaults write com.setapp.DesktopClient KeepTeasers -bool false
  defaults write com.setapp.DesktopClient ShouldLoadFinderSyncExtensionOnLaunch -bool false
  defaults write "com.setapp.DesktopClient" "shouldBlockPushBanner" '1'
  set +e
  open -a "Setapp"
  set -e
else
  echo "(Not installed.)"
fi

echo "SQLPro Studio ..."
if [ -e "/Applications/Setapp/SQLPro Studio.app" ]; then
  set +e
  osascript -e "tell application \"SQLPro Studio\" to quit"
  set -e
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-DisableSampleConnections" '1'
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-QueryMenuKeyEquivalentMask" '1048576'
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-QueryMenuKeyEquivalent" '"\U21a9"'
  defaults write "com.hankinsoft.sqlpro-studio-setapp" "ApplicationPreference-CommentUncommentShortcutKeyEquivalent" '/'
else
  echo "(Not installed.)"
fi

echo "Tembo ..."
if [ -e "/Applications/Tembo.app" ]; then
  osascript -e "tell application \"Tembo\" to quit"
  set +e
  defaults write com.houdah.Tembo3 enableTemboHelper 1
  defaults write com.houdah.Tembo3 quitOnCloseOfLastWindow 1
  set -e
else
  echo "(Not installed.)"
fi

echo "TextBuddy ..."
if [ -e "/Applications/TextBuddy.app" ]; then
  osascript -e "tell application \"TextBuddy\" to quit"
  set +e
  defaults delete "com.clickontyler.TextBuddy" "userSyncEnabled"
  defaults delete "com.clickontyler.TextBuddy" "showOnActivate"
  defaults write "com.clickontyler.TextBuddy" "numberLinesFromZero" '0'
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

echo "Vitals..."
if [ -e "/Applications/Vitals.app" ]; then
  osascript -e "tell application \"Vitals\" to quit"
  defaults write "com.hmarr.Vitals" "networkStatsEnabled" '1'
  open -a "Vitals"
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
  # Show how long it takes to build your project:
  defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
  # Enable faster build times by leveraging multi-core CPU:
  defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks $(sysctl -n hw.ncpu)
  defaults write com.apple.dt.Xcode IDEFileExtensionDisplayMode 1
  defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar 1
  defaults write com.apple.dt.Xcode DVTTextOverscrollAmount "0.5"
else
  echo "(Not installed.)"
fi

echo "Zoom..."
if [ -e "/Applications/zoom.us.app" ]; then
  osascript -e "tell application \"zoom.us\" to quit"
  defaults write us.zoom.xos BounceApplicationSetting 2
  # shellcheck disable=SC2016
  defaults write us.zoom.xos NSUserKeyEquivalents '{
    "Stop Video" = "@$^a";
    "Start Video" = "@$^a";
  }'
else
  echo "(Not installed.)"
fi

./macos-finder-sidebar.sh
./macos-home-applications.sh

echo ""
cecho "--- Homebrew / Zsh / usr/local (permissions fixes) ---" $white
echo ""

echo -e "This fix will use ${magenta}sudo${_reset}; enter your password to authenticate if prompted."
# Authenticate upfront and run a keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -v -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

WHOAMI="$(whoami)"
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

# Lunar installs its CLI tool here; location can't be customized
sudo chown -R "$(whoami):staff" /usr/local/bin
sudo chmod 755 /usr/local/bin

pushd "$HOME/.zsh" >/dev/null
find . -type f ! -path "./zsh-syntax-highlighting/*" ! -path "./zsh-syntax-highlighting" -exec chmod 600 {} \;
find . -type d ! -path "./zsh-syntax-highlighting/*" ! -path "./zsh-syntax-highlighting" -exec chmod 700 {} \;
popd >/dev/null
