# 5M-CodeX Fishing Script

This script enables players to enjoy a realistic fishing experience in your FiveM server.

## Features

- **Fishing Spots**: Various fishing locations are marked on the map with blips for players to discover and explore.
- **Sell Fish**: Earn money by selling the fish you catch to a designated NPC.
- **Fishing Animation**: Immerse players in a lifelike fishing animation complete with sound effects.
- **Informative Notifications**: Helpful notifications guide players through the fishing process.

## Getting Started

### Prerequisites

- [codex-sounds](https://github.com/5M-CodeX/codex-sounds/): For Reel/fish sounds.
- [ox_lib](https://github.com/overextended/ox_lib): A Lua library for FiveM development.
- [ND_Core](github.com/ND-Framework/ND_Core): A core resource for FiveM servers.

### Installation

1. Add the script to your FiveM server resources.
2. Ensure dependencies (`ox_lib` and `ND_Core`) are installed.
3. Start your FiveM server.

## Usage

1. **Fishing:**
   - Approach fishing spots marked on the map.
   - Press `[E]` to start fishing.
   - Enjoy the fishing animation and sounds.

2. **Selling Fish:**
   - Locate the designated NPC (marked on the map) for selling fish.
   - Approach the NPC.
   - Press `[E]` to sell your caught fish and earn money.

## Sounds

Sound effects have been added for catching fish and reeling in the fishing pole.

## Config.lua
This document provides details on configuring the `Config.lua` file for the Fishing Script.

- Configuration Parameters

 - Debug Mode (Config.DebugMode): Set this to `true` to enable debug messages, or `false` to disable. Debug messages can be helpful for troubleshooting.

 - Fishing Locations (Config.FishingLocations): Define the coordinates and names of fishing spots in the `Config.FishingLocations` table. Each entry should have the `coords` (vector3) and `name` fields.

 - Sell NPC Coordinates (Config.SellNpcCoords): Adjust the coordinates and heading of the sell NPC using `Config.SellNpcCoords` (vector4). The last value is the heading.



```lua
Config = {}

Config.DebugMode = true  -- Set to true to enable debug messages, false to disable
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
```
