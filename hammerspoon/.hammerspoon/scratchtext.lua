hs.hotkey.bind({'ctrl', 'shift'}, 'r', function()
  hs.osascript.applescript([[
    activate application "Sublime Text"
    tell application "System Events"
        tell process "Sublime Text"
            tell menu bar 1
                tell menu bar item "File"
                    tell menu "File"
                        click menu item "New Window"
                    end tell
                end tell
            end tell
        end tell
    end tell
   ]])
end)
