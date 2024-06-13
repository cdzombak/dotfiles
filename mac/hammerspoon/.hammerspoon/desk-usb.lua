local log = hs.logger.new('desk-usb.lua', 'debug')

function usbCallback(data)
  local isMainKeyboard = string.find(data["productName"], "Freestyle Edge Keyboard", 0, true)
  local isMainMouse = string.find(data["productName"], "USB Optical Mouse", 0, true) and string.find(data["vendorID"], "7119", 0, true)
  local isLogitechWebcam = string.find(data["productName"], "HD Pro Webcam C920", 0, true)
  local isEyeContactWebcam = string.find(data["productName"], "iContact Camera Pro", 0, true)
  local isWebcam = isLogitechWebcam or isEyeContactWebcam

  if data["eventType"] == "removed" then
    log.d("USB disconnect: productName '" .. data["productName"] .. "'; vendorID '" .. data["vendorID"] .. "'; productID '" .. data["productID"] .. "'")

    if isMainMouse then
      -- Is this the desktop Mac that runs on my home office desk?
      local isHomeDeskMacStudio = false
      local output, status = hs.execute("hostname")
      if status == false then
        log.d("failed to get hostname: " .. output)
      elseif string.find(output, "curie", 0, true) then
        isHomeDeskMacStudio = true
      end
      -- log.d("isHomeDeskMacStudio: " .. tostring(isHomeDeskMacStudio))

      -- on disconnect from 'USB Optical Mouse',
      -- if this machine is my personal desktop Mac and it's using the onboard speakers,
      -- mute it:
      if isHomeDeskMacStudio then
        local isMacStudioSpeakers = hs.audiodevice.current()["name"] == "Mac Studio Speakers"
        local isMonitorSpeakers = hs.audiodevice.current()["name"] == "Studio Display Speakers"
        if isMacStudioSpeakers or isMonitorSpeakers then
          hs.audiodevice.defaultOutputDevice():setMuted(true)
        end
      end
    end

    -- on disconnect from my webcam,
    -- kill webcam/videoconf support software
    if isWebcam then
      if isLogitechWebcam then
        logiTuneApp = hs.application.get("com.logitech.logitune")
        if logiTuneApp then
          logiTuneApp:kill()
        end
      end
      if isEyeContactWebcam then
        eyeContactControlApp = hs.application.get("com.mbox.iContactControl")
        if eyeContactControlApp then
          eyeContactControlApp:kill()
        end
      end
      if isHomeDeskMacStudio then
        zoomApp = hs.application.get("us.zoom.xos")
        if zoomApp then
          zoomApp:kill()
        end
      end
    end
  end
end

usbWatcher = hs.usb.watcher.new(usbCallback)
usbWatcher:start()
