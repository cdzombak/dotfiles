-- hs.hotkey.bind({'ctrl', 'shift'}, 'o', function()
--   hs.osascript.applescript([[
--   	try--   		tell application "OmniFocus" to activate the default document
--   		tell application "System Events"
--   			tell process "OmniFocus"
--   				click menu item "Quick Open…" of menu "File" of menu bar item "File" of menu bar 1
--   			end tell -- OmniFocus
--   		end tell -- System Events
--   	on error e number n
--   		display dialog "Error " & n & ": " & e
--   	end try
--   ]])
-- end)

hs.hotkey.bind({'ctrl', 'shift'}, 'o', function()
  hs.osascript.applescript([[
  	try
  		tell application id "com.culturedcode.ThingsMac" to activate
      tell application "System Events"
	      tell process "Things"
          click menu item "New Things Window" of menu "File" of menu bar item "File" of menu bar 1
          click menu item "Quick Find…" of menu "Edit" of menu bar item "Edit" of menu bar 1
        end tell -- Things
      end tell -- System Events
  	on error e number n
  		display dialog "Error " & n & ": " & e
  	end try
  ]])
end)
