-- references/credits:
-- https://github.com/jasoncodes/dotfiles/blob/ac9f3ac/hammerspoon/control_escape.lua
-- https://github.com/jasonrudolph/ControlEscape.spoon/blob/main/init.lua
-- https://gist.github.com/arbelt/b91e1f38a0880afb316dd5b5732759f1
-- https://gist.github.com/zcmarine/f65182fe26b029900792fa0b59f09d7f

sendEscape = false
lastModifiers = {}

-- If `control` is held for this long, don't send `escape`
CANCEL_DELAY_SECONDS = 0.150
controlKeyTimer = hs.timer.delayed.new(CANCEL_DELAY_SECONDS, function()
  sendEscape = false
end)

-- Create an eventtap to run each time the modifier keys change (i.e., each
-- time a key like control, shift, option, or command is pressed or released)
controlTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged},
  function(event)
    local newModifiers = event:getFlags()
    -- If this change to the modifier keys does not invole a *change* to the
    -- up/down state of the `control` key (i.e., it was up before and it's
    -- still up, or it was down before and it's still down), then don't take
    -- any action.
    if lastModifiers['ctrl'] == newModifiers['ctrl'] then
      return false
    end

    -- If the `control` key has changed to the down state, then start the
    -- timer. If the `control` key changes to the up state before the timer
    -- expires, then send `escape`.
    if not lastModifiers['ctrl'] then
      lastModifiers = newModifiers
      sendEscape = true
      controlKeyTimer:start()
    else
      lastModifiers = newModifiers
      controlKeyTimer:stop()
      if sendEscape then
        sendEscape = false
        return true, {
          -- note: emulating these keypresses is much faster than using hs.eventtap.keyStroke
          -- credit: https://gist.github.com/arbelt/b91e1f38a0880afb316dd5b5732759f1?permalink_comment_id=1980777#gistcomment-1980777
          hs.eventtap.event.newKeyEvent({}, 'escape', true),
          hs.eventtap.event.newKeyEvent({}, 'escape', false),
        }
      end
    end
    return false
  end
)

-- Create an eventtap to run each time a normal key (i.e., a non-modifier key)
-- enters the down state. We only want to send `escape` if `control` is
-- pressed and released in isolation. If `control` is pressed in combination
-- with any other key, we don't want to send `escape`.
keyDownEventTap = hs.eventtap.new({hs.eventtap.event.types.keyDown},
  function(event)
    sendEscape = false
    return false
  end
)

controlTap:start()
keyDownEventTap:start()
