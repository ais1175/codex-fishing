local caughtFish = {}
local fishingBlips = {}
local sellNpcBlip = nil
local sellNpcHelpText = "Press [E] to sell your fish."

local isFishing = false
local hasPressedKey = false
local fishingTimer = 0
local isFishingAnimationPlaying = false
local fishingFinished = false
local hasStartedFishingNotification = false
local hasSellFishNotification = false

local hasEnteredFishingZone = false
local hasEnteredSellZone = false

function CreateFishingBlip(location)
    local blip = AddBlipForCoord(location.coords)

    SetBlipSprite(blip, 356)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 69)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Fishing Spot")
    EndTextCommandSetBlipName(blip)

    return blip
end

function CreateSellNpcBlip(coords)
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, 311)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 69)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sell Fish")
    EndTextCommandSetBlipName(blip)

    return blip
end

function CreateSellNpc(coords)
    RequestModel("a_m_m_hillbilly_01")
    while not HasModelLoaded("a_m_m_hillbilly_01") do
        Wait(500)
    end

    local ped = CreatePed(4, "a_m_m_hillbilly_01", coords.x, coords.y, coords.z - 1.0, coords.w, false, true)

    SetEntityInvincible(ped, true)
    SetEntityHasGravity(ped, true)
    SetEntityCanBeDamaged(ped, false)
    SetEntityCollision(ped, true, true)

    FreezeEntityPosition(ped, true)
end

function CreateBlips()
    for _, location in pairs(Config.FishingLocations) do
        local blip = CreateFishingBlip(location)
        table.insert(fishingBlips, blip)
    end

    sellNpcBlip = CreateSellNpcBlip(Config.SellNpcCoords)
    CreateSellNpc(Config.SellNpcCoords)
end

Citizen.CreateThread(function()
    CreateBlips()

    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for _, location in pairs(Config.FishingLocations) do
            local distance = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - location.coords)

            if distance < 2.0 and not hasEnteredFishingZone then
                DisplayNotification("Press [E] to start fishing.")

                if distance < 1.5 and IsControlJustReleased(0, 38) and not hasPressedKey then
                    if not hasStartedFishingNotification then
                        StartFishing(location.name)
                        DisplayNotification("You started fishing at " .. location.name)
                        hasStartedFishingNotification = true
                        hasEnteredFishingZone = true
                        hasSellFishNotification = false
                        hasEnteredSellZone = false
                    end
                    hasPressedKey = true
                end
            end
        end

        if not IsControlPressed(0, 38) then
            hasPressedKey = false
        end

        local sellNpcDistance = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - vector3(Config.SellNpcCoords.x, Config.SellNpcCoords.y, Config.SellNpcCoords.z))

        if sellNpcDistance < 2.0 and not hasEnteredSellZone then
            DisplayNotification(sellNpcHelpText)

            if sellNpcDistance < 1.0 and IsControlJustReleased(0, 38) and not isFishing then
                if not hasSellFishNotification then
                    SellFish()
                    hasSellFishNotification = true
                    hasEnteredSellZone = true
                    hasStartedFishingNotification = false
                    hasEnteredFishingZone = false
                end
            end
        end

        if isFishing then
            local currentTime = GetGameTimer()

            if currentTime >= fishingTimer then
                isFishing = false
                TriggerServerEvent('fish:stopFishing')
                DisplayNotification("You finished fishing.")
                CheckForFishCatch()
                TriggerEvent('fish:stopFishingAnimation')
                fishingFinished = true
            else
                DrawFishingPoleAnimation()
            end
        end
    end
end)

RegisterNetEvent('fish:catchFish')
AddEventHandler('fish:catchFish', function(fish)
    table.insert(caughtFish, fish)
    if not isFishing then
        DisplayNotification("Fishing has finished. You caught " .. fish.count .. " " .. fish.type .. "!")
    else
        DisplayNotification("You caught " .. fish.count .. " " .. fish.type .. "!")
    end
end)

RegisterNetEvent('fish:sellSuccess')
AddEventHandler('fish:sellSuccess', function(earnedMoney)
    DisplayNotification("You sold your fish for $" .. earnedMoney .. "!")
    caughtFish = {}
end)

RegisterNetEvent('fish:fishingStarted')
AddEventHandler('fish:fishingStarted', function()
    isFishing = true
end)

function StartFishing(location)
    if not isFishing then
        isFishing = true
        TriggerServerEvent('fish:startFishing', location)
        fishingTimer = GetGameTimer() + 5000
        fishingFinished = false
    else
        DisplayNotification("You are already fishing.")
    end
end

function SellFish()
    if #caughtFish > 0 and fishingFinished then
        TriggerServerEvent('fish:sellFish')
    else
        DisplayNotification("You have no fish to sell.")
    end
end

function DisplayNotification(message)
    lib.showTextUI(message, {
        icon = 'fa-solid fa-map-marker-alt',
        position = 'left-center',
    })

    Citizen.CreateThread(function()
        Citizen.Wait(5000)
        lib.hideTextUI()
    end)
end

function DrawFishingPoleAnimation()
    if not isFishingAnimationPlaying then
        isFishingAnimationPlaying = true
		TriggerEvent('codex-sound:PlayOnOne', 'fishing', 10.0)
        TriggerServerEvent('codex-sound:server:PlayWithinDistance', 0.5, 'fishing', 10.0)
        RequestAnimDict('mini@tennis')
        RequestAnimDict('amb@world_human_stand_fishing@idle_a')

        while not HasAnimDictLoaded('mini@tennis') or not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') do
            Wait(500)
        end
        TriggerEvent('codex-sound:PlayOnOne', 'fishing', 10.0)
        TriggerServerEvent('codex-sound:server:PlayWithinDistance', 0.5, 'fishing', 10.0)
        TaskPlayAnim(PlayerPedId(), 'mini@tennis', 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
        Wait(3000)
        TaskPlayAnim(PlayerPedId(), 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)

        isFishingAnimationPlaying = false
    end
end

function CheckForFishCatch()
    if math.random() < 0.05 then
        local randomFishType = GetRandomFishType()
        local randomFishCount = math.random(1, 5)
        local randomSellPrice = GetFishSellPrice(randomFishType)

        TriggerServerEvent('fish:catchFish', randomFishType, randomFishCount, randomSellPrice)
        DisplayNotification("You caught a " .. randomFishType .. "!")
    end
end

RegisterNetEvent('fish:stopFishingAnimation')
AddEventHandler('fish:stopFishingAnimation', function()
    StopAnimTask(PlayerPedId(), 'mini@tennis', 'forehand_ts_md_far', 1.0)
    StopAnimTask(PlayerPedId(), 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0)
end)
