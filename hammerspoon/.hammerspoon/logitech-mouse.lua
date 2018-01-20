local log = hs.logger.new('logitech-mouse.lua', 'debug')

-- Revised 2018-01-15: now using https://github.com/archagon/sensible-side-buttons
-- for side buttons, since Hammerspoon mouse seems to conflict with IntelliJ.

-- 26 is otherMouseUp; see https://github.com/Hammerspoon/hammerspoon/issues/1385
-- mouseBackForwardHandler = hs.eventtap.new({ 26 }, function(e)
--   if e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber) == 3 then
--     -- log.d("back mouse button pressed")
--     keyUpDown({'cmd'}, '[')
--     return true
--   end
--
--   if e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber) == 4 then
--     -- log.d("forward mouse button pressed")
--     keyUpDown({'cmd'}, ']')
--     return true
--   end
--
--   return false
-- end):start()

hs.hotkey.bind({'ctrl', 'alt'}, 'tab', function()
  -- log.d("app switch button pressed")
  keyUpDown({'cmd'}, '`')
  -- keyUpDown({'cmd'}, 'tab')
  return false
end)
