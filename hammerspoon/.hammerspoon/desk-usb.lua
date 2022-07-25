local log = hs.logger.new('desk-usb.lua', 'debug')

function usbCallback(data)
    if data["eventType"] == "added" then
        log.d("USB connect: productName '" .. data["productName"] .. "'; vendorID '" .. data["vendorID"] .. "'; productID '" .. data["productID"] .. "'")
    elseif data["eventType"] == "removed" then
        log.d("USB disconnect: productName '" .. data["productName"] .. "'; vendorID '" .. data["vendorID"] .. "'; productID '" .. data["productID"] .. "'")

        if string.find(data["productName"], "Freestyle Edge Keyboard", 0, true) then
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
            if isHomeDeskMacStudio then
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
    end
end

usbWatcher = hs.usb.watcher.new(usbCallback)
usbWatcher:start()
