local log = hs.logger.new('desk-usb.lua', 'debug')

function usbCallback(data)
  local isDesktopMouse = string.find(data["productName"], "USB Optical Mouse", 0, true) and string.find(data["vendorID"], "7119", 0, true)
  local isCaldigitTS4 = string.find(data["productName"], "TS4 USB3.2 Gen2 HUB", 0, true)
  local isLogitechWebcam = string.find(data["productName"], "HD Pro Webcam C920", 0, true)

  local isHomeDeskMacStudio = false
  local isWorkMBP = false
  local hostOutput, hostStatus = hs.execute("hostname")
  if hostStatus == false then
    log.d("failed to get hostname: " .. hostOutput)
  elseif string.find(hostOutput, "curie", 0, true) then
    isHomeDeskMacStudio = true
  elseif string.find(hostOutput, "yorick", 0, true) then
    isWorkMBP = true
  end

  if data["eventType"] == "removed" then
    log.d("USB disconnect: productName '" .. data["productName"] .. "'; vendorID '" .. data["vendorID"] .. "'; productID '" .. data["productID"] .. "'")

    -- on disconnect from 'USB Optical Mouse',
    if isDesktopMouse then
      -- if this machine is my personal desktop Mac and it's using the onboard speakers,
      if isHomeDeskMacStudio then
        local isMacStudioSpeakers = hs.audiodevice.current()["name"] == "Mac Studio Speakers"
        local isMonitorSpeakers = hs.audiodevice.current()["name"] == "Studio Display Speakers"
        if isMacStudioSpeakers or isMonitorSpeakers then
          -- mute it:
          hs.audiodevice.defaultOutputDevice():setMuted(true)
        end
      end
    end

    -- on disconnect from Caldigit TS4,
    if isCaldigitTS4 then
      -- if this is my work MacBook Pro,
      if isWorkMBP then
        -- enable BetterDisplay XDR brightness scaling:
        hs.execute [["/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay" "set" "--UUID=37D8832A-2D66-02CA-B9F7-8F30A301B230" "--nativeBrightnessUpscaling=off"]]
        -- enable WiFi:
        hs.wifi.setPower(true)
      end
    end

    -- on disconnect from my webcam,
    -- kill webcam/videoconf support software
    if isLogitechWebcam then
      logiTuneApp = hs.application.get("com.logitech.logitune")
      if logiTuneApp then
        logiTuneApp:kill()
      end
      if isHomeDeskMacStudio then
        zoomApp = hs.application.get("us.zoom.xos")
        if zoomApp then
          zoomApp:kill()
        end
      end
    end
  end

  if data["eventType"] == "added" then
    log.d("USB connect: productName '" .. data["productName"] .. "'; vendorID '" .. data["vendorID"] .. "'; productID '" .. data["productID"] .. "'")

    -- on disconnect from Caldigit TS4,
    if isCaldigitTS4 then
      -- if this is my work MacBook Pro,
      if isWorkMBP then
        -- disable BetterDisplay XDR brightness scaling:
        hs.execute [["/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay" "set" "--UUID=37D8832A-2D66-02CA-B9F7-8F30A301B230" "--nativeBrightnessUpscaling=off"]]
        -- disable WiFi:
        hs.wifi.setPower(false)
      end
    end
  end
end

usbWatcher = hs.usb.watcher.new(usbCallback)
usbWatcher:start()
