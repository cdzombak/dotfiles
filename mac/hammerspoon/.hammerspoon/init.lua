-- Use Control+Alt+` to reload Hammerspoon config
hs.hotkey.bind({'ctrl', 'alt'}, '`', nil, function()
  hs.notify.new({title='Hammerspoon', informativeText='Reloading 💭'}):send()
  hs.reload()
end)

keyUpDown = function(modifiers, key)
  hs.eventtap.keyStroke(modifiers, key, 0)
end

-- Subscribe to the necessary events on the given window filter such that the
-- given hotkey is enabled for windows that match the window filter and disabled
-- for windows that don't match the window filter.
--
-- windowFilter - An hs.window.filter object describing the windows for which
--                the hotkey should be enabled.
-- hotkey       - The hs.hotkey object to enable/disable.
--
-- Returns nothing.
enableHotkeyForWindowsMatchingFilter = function(windowFilter, hotkey)
  windowFilter:subscribe(hs.window.filter.windowFocused, function()
    hotkey:enable()
  end)

  windowFilter:subscribe(hs.window.filter.windowUnfocused, function()
    hotkey:disable()
  end)
end

hs.application.enableSpotlightForNameSearches(true)

-- require('control-escape')
require('desk-usb')
require('delete-words')
require('markdown')
require('windows')
require('nano-shortcuts')

hs.notify.new({title='Hammerspoon', informativeText='Ready ✅ (ctrl-alt-` to reload)'}):send()
