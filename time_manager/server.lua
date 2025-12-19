local QBCore = exports['qb-core']:GetCoreObject()

-- Export: check if business is open
exports("IsBusinessOpen", function(name)
    local hour = tonumber(os.date("%H"))
    local cfg = Config.BusinessHours[name]
    if not cfg then return false end

    -- Handle overnight (e.g. club open 20:00–03:00)
    if cfg.open > cfg.close then
        return (hour >= cfg.open or hour < cfg.close)
    else
        return (hour >= cfg.open and hour < cfg.close)
    end
end)

-- Export: get current shift (day/night)
exports("GetCurrentShift", function()
    local hour = tonumber(os.date("%H"))
    if hour >= 6 and hour < 18 then
        return "day"
    else
        return "night"
    end
end)

-- Hourly tick event
Citizen.CreateThread(function()
    local lastHour = tonumber(os.date("%H"))
    while true do
        Citizen.Wait(60000) -- check every minute
        local hour = tonumber(os.date("%H"))
        if hour ~= lastHour then
            lastHour = hour
            TriggerEvent("time_manager:hourChanged", hour)
        end
    end
end)

-- Daily tick event + holiday check
Citizen.CreateThread(function()
    local lastDay = tonumber(os.date("%d"))
    while true do
        Citizen.Wait(60000) -- check every minute
        local day = tonumber(os.date("%d"))
        if day ~= lastDay then
            lastDay = day
            local month = tonumber(os.date("%m"))
            TriggerEvent("time_manager:dayChanged", day, month)

            -- Holiday check
            for _, holiday in pairs(Config.Holidays) do
                if holiday.day == day and holiday.month == month then
                    TriggerEvent("time_manager:holiday", holiday.event)
                end
            end
        end
    end
end)
