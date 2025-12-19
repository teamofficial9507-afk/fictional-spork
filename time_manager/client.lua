local QBCore = exports['qb-core']:GetCoreObject()

-- Hourly tick notifications
RegisterNetEvent("time_manager:hourChanged", function(hour)
    QBCore.Functions.Notify("The clock just struck " .. hour .. ":00", "info")

    -- Shops auto-close/open
    if hour == 22 then
        TriggerEvent("shops:closeAll")
    elseif hour == 6 then
        TriggerEvent("shops:openAll")
    end

    -- Banks auto-close/open
    if hour == 17 then
        TriggerEvent("banks:closeAll")
    elseif hour == 9 then
        TriggerEvent("banks:openAll")
    end
end)

-- Daily tick
RegisterNetEvent("time_manager:dayChanged", function(day, month)
    QBCore.Functions.Notify("A new day has begun: " .. day .. "/" .. month, "success")
end)

-- Holiday triggers
RegisterNetEvent("time_manager:holiday", function(event)
    if event == "Halloween" then
        QBCore.Functions.Notify("?? Happy Halloween! Special events are live!", "success")
        TriggerEvent("holiday:halloween")
    elseif event == "Christmas" then
        QBCore.Functions.Notify("?? Merry Christmas! Enjoy festive bonuses!", "success")
        TriggerEvent("holiday:christmas")
    elseif event == "NewYear" then
        QBCore.Functions.Notify("?? Happy New Year! Fireworks tonight!", "success")
        TriggerEvent("holiday:newyear")
    end
end)

-- Setup qb-target zones
Citizen.CreateThread(function()
    -- ATMs (always open)
    for _, model in pairs(Config.ATMModels) do
        exports['qb-target']:AddTargetModel(model, {
            options = {
                {
                    type = "client",
                    event = "atm:openMenu",
                    icon = "fas fa-credit-card",
                    label = "Use ATM",
                }
            },
            distance = 2.0
        })
    end

    -- Bank counters (restricted by hours)
    for _, model in pairs(Config.BankPeds) do
        exports['qb-target']:AddTargetModel(model, {
            options = {
                {
                    type = "client",
                    event = "bank:openMenu",
                    icon = "fas fa-university",
                    label = "Talk to Banker",
                    canInteract = function(entity)
                        return exports["time_manager"]:IsBusinessOpen("bank")
                    end
                }
            },
            distance = 2.0
        })
    end
end)

-- Example ATM menu
RegisterNetEvent("atm:openMenu", function()
    QBCore.Functions.Notify("ATM accessed. You can withdraw/deposit cash.", "success")
    -- Hook into your banking UI here
end)

-- Example Bank menu
RegisterNetEvent("bank:openMenu", function()
    QBCore.Functions.Notify("Bank services available during open hours.", "success")
    -- Hook into your banking UI here
end)

-- Visual cues: lock/unlock doors
RegisterNetEvent("shops:closeAll", function()
    for _, door in pairs(Config.ShopDoors) do
        DoorSystemSetDoorState(door.hash, 1, false, false) -- locked
        QBCore.Functions.Notify("Shops are now closed.", "error")
    end
end)

RegisterNetEvent("shops:openAll", function()
    for _, door in pairs(Config.ShopDoors) do
        DoorSystemSetDoorState(door.hash, 0, false, false) -- unlocked
        QBCore.Functions.Notify("Shops are now open.", "success")
    end
end)

RegisterNetEvent("banks:closeAll", function()
    for _, door in pairs(Config.BankDoors) do
        DoorSystemSetDoorState(door.hash, 1, false, false) -- locked
        QBCore.Functions.Notify("Banks are now closed.", "error")
    end
end)

RegisterNetEvent("banks:openAll", function()
    for _, door in pairs(Config.BankDoors) do
        DoorSystemSetDoorState(door.hash, 0, false, false) -- unlocked
        QBCore.Functions.Notify("Banks are now open.", "success")
    end
end)
