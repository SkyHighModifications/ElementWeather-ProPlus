-- FiveM WeatherSync Pro+
-- Version: 1.0.0
-- Made by SkyHigh Modifications

    -- Function to log update status
    local function LogUpdateStatus(_type, message)
        -- Define color codes for success and error messages
        local color = _type == 'success' and '^2' or '^1'
        local resourceName = GetCurrentResourceName()
        local formattedMessage = string.format("[%sUPDATE^7] ^3%s^7: %s%s^7", color, resourceName, color, message)
        print(formattedMessage)
    end


-- Function to check if a player has the beta role on Discord
local function hasBetaRole(player)
    local playerId = tonumber(player)
    local discordId = GetPlayerIdentifier(playerId, 0)  -- Assuming Discord identifier is at index 0

    if discordId then
        local endpoint = string.format('https://discord.com/api/guilds/%s/members/%s', '1078229032820277248', discordId)

        PerformHttpRequest(endpoint, function(err, data, headers)
            if not err then
                local memberData = json.decode(data)

                if memberData.roles and table.contains(memberData.roles, '1110319833968562357') then
                    return true  -- The player has the beta role
                end
            end
        end, 'GET', '', { ['Authorization'] = 'Bot ' .. '1078895756368420945' })
    end

    return false  -- Default to false if any errors occur
end

    -- Trigger update check on resource start
    AddEventHandler('onResourceStart', function(resource)
        -- Check if the current resource is the one being started
        if GetCurrentResourceName() == resource then
            -- Make an HTTP request to check for updates
            local versionCheckUrl = 'https://raw.githubusercontent.com/SkyHighModifications/FiveM-WeatherSync-ProPlus/master/version/stable.txt'
            PerformHttpRequest(versionCheckUrl, function(err, text, headers)
                local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
                if not text then
                    LogUpdateStatus('error', 'Update check encountered an issue.')
                    return
                end

                LogUpdateStatus('success', string.format("Currently Installed Version: %s", currentVersion))
                LogUpdateStatus('success', string.format("Latest Stable Version: %s", text))

                -- Compare versions and notify the user
                if text:gsub("%s+", "") == currentVersion:gsub("%s+", "") then
                    LogUpdateStatus('success', "Congratulations, you have the most up-to-date version.")
                else
                    LogUpdateStatus('error', string.format("Your current version is out-of-date. Please upgrade to version %s.", text))

                    -- Check if the player has the beta role before proceeding with beta version check
                    local player = source
                    if hasBetaRole(player) then
                        -- Beta Version Check
                        local betaVersionCheckUrl = 'https://raw.githubusercontent.com/SkyHighModifications/FiveM-WeatherSync-ProPlus/version/beta.txt'
                        PerformHttpRequest(betaVersionCheckUrl, function(err, betaText, betaHeaders)
                            if betaText then
                                local betaVersion = betaText:gsub("%s+", "")
                                LogUpdateStatus('success', string.format("Latest Beta Version: %s", betaVersion))
                                -- Compare beta version and notify the user
                                if betaVersion ~= currentVersion:gsub("%s+", "") then
                                    LogUpdateStatus('info', "A beta version is available. Consider upgrading for new features and improvements.")
                                end
                            else
                                LogUpdateStatus('error', 'Beta version check encountered an issue.')
                            end
                        end)
                    end
                end
            end)
        end
    end)


