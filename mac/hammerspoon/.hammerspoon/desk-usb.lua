local log = hs.logger.new('desk-usb.lua', 'debug')

function file_exists(name)
   local f=io.open(name, "r")
   if f~=nil then io.close(f) return true else return false end
end

function usbCallback(data)
  local isMainKeyboard = string.find(data["productName"], "Freestyle Edge Keyboard", 0, true)
  local isMainMouse = string.find(data["productName"], "USB Optical Mouse", 0, true) and string.find(data["vendorID"], "7119", 0, true)
  local isLogitechWebcam = string.find(data["productName"], "HD Pro Webcam C920", 0, true)
  local isEyeContactWebcam = string.find(data["productName"], "iContact Camera Pro", 0, true)
  local isWebcam = isLogitechWebcam or isEyeContactWebcam

  if data["eventType"] == "added" then
    log.d("USB connect: productName '" .. data["productName"] .. "'; vendorID '" .. data["vendorID"] .. "'; productID '" .. data["productID"] .. "'")

    if isMainMouse then
      -- wake this machine
      log.d("waking machine via /usr/bin/caffeinate...")
      hs.task.new('/usr/bin/caffeinate', nil, {"-u", "-t", "10"}):start()
    end

    if isWebcam then
      -- start webcam/videoconf support software:
      hs.application.open("com.corsair.ControlCenter")
      hs.application.open("net.rafaelconde.Hand-Mirror")

      if isEyeContactWebcam then
        hs.application.open("com.mbox.iContactControl")
      end
      if isLogitechWebcam then
        logiTuneApp = hs.application.open("com.logitech.logitune", 4, true)
        if logiTuneApp then
          for _, window in pairs(logiTuneApp:visibleWindows()) do
            window:close()
          end
        else
          log.d("LogiTune not up after launch wait timeout; cannot close window automatically")
        end
      end
    end
  elseif data["eventType"] == "removed" then
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
      if isHomeDeskMacStudio and hs.audiodevice.current()["name"] == "Mac Studio Speakers" then
        hs.audiodevice.defaultOutputDevice():setMuted(true)
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
      handMirrorApp = hs.application.get("net.rafaelconde.Hand-Mirror")
      if handMirrorApp then
        handMirrorApp:kill()
      end
      zoomApp = hs.application.get("us.zoom.xos")
      if zoomApp then
        zoomApp:kill()
      end
      elgatoCcApp = hs.application.get("com.corsair.ControlCenter")
      if elgatoCcApp then
        elgatoCcApp:kill()
      end
    end
  end
end

usbWatcher = hs.usb.watcher.new(usbCallback)
usbWatcher:start()
