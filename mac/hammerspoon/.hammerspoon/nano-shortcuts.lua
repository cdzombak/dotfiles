
hs.urlevent.bind("nano_markmode", function()
  hs.eventtap.event.newKeyEvent(53, true):post()
  hs.eventtap.event.newKeyEvent('a', true):post()
  hs.eventtap.event.newKeyEvent('a', false):post()
  hs.eventtap.event.newKeyEvent(53, false):post()
end)

hs.urlevent.bind("nano_comment", function()
  hs.eventtap.event.newKeyEvent(53, true):post()
  hs.eventtap.event.newKeyEvent('3', true):post()
  hs.eventtap.event.newKeyEvent('3', false):post()
  hs.eventtap.event.newKeyEvent(53, false):post()
end)
