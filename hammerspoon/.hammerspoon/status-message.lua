local drawing = require 'hs.drawing'
local geometry = require 'hs.geometry'
local hsscreen = require 'hs.screen'
local styledtext = require 'hs.styledtext'

local statusmessage = {}
statusmessage.new = function(messageText)
  local buildParts = function(messageText)
    local backgrounds = {}
    local texts = {}
    local screens = hsscreen.allScreens()

    for idx, screen in ipairs(screens)
    do
      local frame = screen:frame()

      local styledTextAttributes = {
        font = { name = 'Helvetica Neue', size = 48 },
        color = { white = 1.0, alpha = 1.0 },
      }
      local styledText = styledtext.new(messageText, styledTextAttributes)
      local styledTextSize = drawing.getTextDrawingSize(styledText)
      local textRect = {
        x = frame.x + frame.w - styledTextSize.w - 40,
        y = frame.y + frame.h - styledTextSize.h - 23,
        w = styledTextSize.w + 40,
        h = styledTextSize.h + 40,
      }
      local text = drawing.text(textRect, styledText):setAlpha(0.7)

      local background = drawing.rectangle(
        {
          x = frame.x + frame.w - styledTextSize.w - 50,
          y = frame.y + frame.h - styledTextSize.h - 23 - 3,
          w = styledTextSize.w + 20,
          h = styledTextSize.h + 6
        }
      )
      background:setRoundedRectRadii(10, 10)
      background:setFillColor({ red = 0, green = 0, blue = 0, alpha=0.8 })

      backgrounds[idx] = background
      texts[idx] = text
    end
    return backgrounds, texts
  end

  return {
    _buildParts = buildParts,
    show = function(self)
      self:hide()

      self.backgrounds, self.texts = self._buildParts(messageText)
      for idx, bg in ipairs(self.backgrounds) do bg:show() end
      for idx, text in ipairs(self.texts) do text:show() end
    end,
    hide = function(self)
      if self.backgrounds then
        for idx, bg in ipairs(self.backgrounds) do bg:delete() end
        self.backgrounds = nil
      end
      if self.texts then
        for idx, text in ipairs(self.texts) do text:delete() end
        self.texts = nil
      end
    end,
    notify = function(self, seconds)
      local seconds = seconds or 2
      self:show()
      hs.timer.delayed.new(seconds, function() self:hide() end):start()
    end
  }
end

return statusmessage
