local log = hs.logger.new('desk-usb.lua', 'debug')

function usbCallback(data)
  local isMainKeyboard = string.find(data["productName"], "Freestyle Edge Keyboard", 0, true)
  local isWebcam = string.find(data["productName"], "HD Pro Webcam C920", 0, true)

  if data["eventType"] == "added" then
    log.d("USB connect: productName '" .. data["productName"] .. "'; vendorID '" .. data["vendorID"] .. "'; productID '" .. data["productID"] .. "'")

    if isMainKeyboard then
      -- wake this machine
      log.d("waking machine via /usr/bin/caffeinate...")
      hs.task.new('/usr/bin/caffeinate', nil, {"-u", "-t", "10"}):start()

      -- workaround Lunar not working sometimes after input switching (macOS 12.2+ bug). per the dev:
      -- "(sometimes) the system responds with an old cached list of screens where the DDC port is not valid anymore"
      log.d("restarting Lunar via hotkey...")
      hs.task.new('/Users/cdzombak/.dotfiles/hammerspoon/support/restart-lunar.sh', nil):start()
    end

    if isWebcam then
      -- start webcam support software:
      hs.application.open("net.rafaelconde.Hand-Mirror")
      logiTuneApp = hs.application.open("com.logitech.logitune", 2, true)
      if logiTuneApp then
        for _, window in pairs(logiTuneApp:visibleWindows()) do
          window:close()
        end
      else
        log.d("LogiTune not up after launch wait timeout; cannot close window automatically")
      end
    end
  elseif data["eventType"] == "removed" then
    log.d("USB disconnect: productName '" .. data["productName"] .. "'; vendorID '" .. data["vendorID"] .. "'; productID '" .. data["productID"] .. "'")

    if isMainKeyboard then
      -- Is this the desktop Mac that runs on my home office desk?
      local isHomeDeskMacStudio = false
      local output, status = hs.execute("hostname")
      if status == false then
        log.d("failed to get hostname: " .. output)
      elseif string.find(output, "curie", 0, true) then
        isHomeDeskMacStudio = true
      end
      log.d("isHomeDeskMacStudio: " .. tostring(isHomeDeskMacStudio))

      -- Is this machine currently connected to my home office desk external monitor?
      local isHomeDeskExternalMonitor = false
      local output, status = hs.execute("/usr/local/bin/lunar get serial")
      if status == false then
        log.d("failed to get monitor serial: " .. output)
      elseif string.find(output, "B5545C3D-AA52-422C-8C50-2D97E231D7F3", 0, true) or string.find(output, "3C82E6B9-5051-42FD-8BA8-3BB83EC50EE8", 0, true) then
        isHomeDeskExternalMonitor = true
      end
      log.d("isHomeDeskExternalMonitor: " .. tostring(isHomeDeskExternalMonitor))

      -- on disconnect from 'Freestyle Edge Keyboard',
      -- if this machine is my personal secondary desktop Mac
      -- mute it:
      if isHomeDeskMacStudio and hs.audiodevice.current()["name"] == "Mac Studio Speakers" then
        hs.audiodevice.defaultOutputDevice():setMuted(true)
      end

      -- on disconnect from 'Freestyle Edge Keyboard',
      -- if home desk external monitor is connected,
      -- switch it to the other input:
      if isHomeDeskExternalMonitor then
        local newInput = "displayport2"
        if isHomeDeskMacStudio then
          newInput = "displayport1"
        end
        local output, status = hs.execute("/usr/local/bin/lunar set input " .. newInput)
        if status == false then
          log.d("failed to set input (" .. newInput .. "): " .. output)
        end
      end
    end

    if isWebcam then
      -- kill webcam support software
      logiTuneApp = hs.application.get("com.logitech.logitune")
      if logiTuneApp then
        logiTuneApp:kill()
      end
      handMirrorApp = hs.application.get("net.rafaelconde.Hand-Mirror")
      if handMirrorApp then
        handMirrorApp:kill()
      end
    end
  end
end

usbWatcher = hs.usb.watcher.new(usbCallback)
usbWatcher:start()
