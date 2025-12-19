Config = {}

-- Business hours (24h format)
Config.BusinessHours = {
    ["shop"] = {open = 6, close = 22},   -- Shops: 6 AM to 10 PM
    ["bank"] = {open = 9, close = 17},   -- Banks: 9 AM to 5 PM
    ["club"] = {open = 20, close = 3},   -- Clubs: 8 PM to 3 AM
    ["atm"]  = {open = 0, close = 24},   -- ATMs: always open
}

-- Holiday triggers (month/day)
Config.Holidays = {
    {month = 10, day = 31, event = "Halloween"},
    {month = 12, day = 25, event = "Christmas"},
    {month = 1,  day = 1,  event = "NewYear"},
}

-- ATM models
Config.ATMModels = {
    `prop_atm_01`,
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`
}

-- Bank ped models (for counters)
Config.BankPeds = {
    `s_m_m_banker_01`
}

-- Door hashes for shops/banks (add your own)
Config.ShopDoors = {
    {coords = vector3(373.875, 325.896, 103.566), hash = 1956494919}, -- Example shop door
}

Config.BankDoors = {
    {coords = vector3(149.0, -1040.0, 29.0), hash = -1184592117}, -- Example bank door
}
