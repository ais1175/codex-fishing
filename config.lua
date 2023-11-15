Config = {}

Config.DebugMode = true  -- Set to true to enable debug messages, false to disable
Config.useOxNoty = true
Config.FishingLocations = {
    { coords = vector3(28.11, 852.58, 197.73), name = "Lake" },
    { coords = vector3(2000.0, 3000.0, 0.0), name = "Sea" },
    -- Add more fishing locations as needed
}

Config.SellNpcCoords = vector4(36.85, 861.17, 197.73, 310.09)

Config.WaterTypes = {
    Lake = {
        FishTypes = {
            { name = "Bass", price = 10 },
            { name = "Trout", price = 8 },
            -- Add more lake fish types as needed
        },
    },
    Sea = {
        FishTypes = {
            { name = "Salmon", price = 15 },
            { name = "Catfish", price = 12 },
            -- Add more sea fish types as needed
        },
    },
}
