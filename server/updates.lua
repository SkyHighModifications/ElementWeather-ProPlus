-- FiveM WeatherSync Pro+
-- Version: 1.0.0
-- Made by SkyHigh Modifications

    -- Function to log update status
    local function LogUpdateStatus(_type, message)
        -- Define color codes for success and error messages
        local color = _type == 'success' and '^2' or '^1'
        local formattedMessage = string.format("[%sUPDATE^7] ^3%s^7: %s%s^7", color, GetCurrentResourceName(), color, message)
        print(formattedMessage)
    end
if Config.ScriptUpdates then
    -- Trigger update check on resource start
    AddEventHandler('onResourceStart', function(resource)
        -- Check if the current resource is the one being started
        if GetCurrentResourceName() == resource then
            -- Make an HTTP request to check for updates
            PerformHttpRequest('https://raw.githubusercontent.com/SkyHighModifications/FiveM-WeatherSync-ProPlus/main/version.txt', function(err, text, headers)
                local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
                if not text then
                    LogUpdateStatus('error', 'Update check encountered an issue.')
                    return
                end
                LogUpdateStatus('success', string.format("Currently Installed Version: ^6%s^7", currentVersion))
                LogUpdateStatus('success', string.format("Version in Sync: ^6%s^7", text))

                -- Compare versions and notify the user
                if text:gsub("%s+", "") == currentVersion:gsub("%s+", "") then
                    LogUpdateStatus('success', "Congratulations, you have the most up-to-date version.")
                else
                    LogUpdateStatus('error', string.format("Your current version is out-of-date. Please upgrade to version ^4%s^7.", text))
                end
            end)
        end
    end)
end
