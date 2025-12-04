local QBCore = nil
local ESX = nil

local hunger = 100
local thirst = 100
local stress = 0

Citizen.CreateThread(function()
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
    end
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent('esx_status:onTick', function(status)
    for _, v in pairs(status) do
        if v.name == 'hunger' then hunger = v.percent end
        if v.name == 'thirst' then thirst = v.percent end
        if v.name == 'stress' then stress = v.percent end
    end
end)

RegisterNetEvent('hud:client:UpdateStress', function(newStress)
    stress = newStress
end)

Citizen.CreateThread(function()
    SetRadarBigmapEnabled(true, false)
    SetRadarBigmapEnabled(false, false)
    
    Wait(50)
    
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    SetRadarBigmapEnabled(false, false)
    Wait(0)
    
    local defaultAspectRatio = 1920 / 1080
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0
    
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end
    
    RequestStreamedTextureDict("squaremap", false)
    if not HasStreamedTextureDictLoaded("squaremap") then
        Wait(150)
    end
    
    SetMinimapClipType(0)
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")
    
    SetMinimapComponentPosition("minimap", "L", "B", -0.0045 + minimapOffset, 0.002, 0.150, 0.188888)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.03 + minimapOffset, 0.002, 0.266, 0.237)
    
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    
    while true do
        local ped = PlayerPedId()
        local player = PlayerId()
        local health = GetEntityHealth(ped) - 100
        local armor = GetPedArmour(ped)
        local stamina = 100 - GetPlayerSprintStaminaRemaining(player)
        
        if QBCore then
            local playerData = QBCore.Functions.GetPlayerData()
            if playerData.metadata then
                hunger = playerData.metadata['hunger'] or 100
                thirst = playerData.metadata['thirst'] or 100
                stress = playerData.metadata['stress'] or 0
            end
        end
        
        SendNUIMessage({
            action = 'updateStatus',
            health = health,
            armor = armor,
            hunger = hunger,
            thirst = thirst,
            stamina = stamina,
            stress = stress
        })
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local speed = GetEntitySpeed(vehicle) * 3.6
            local fuel = GetVehicleFuelLevel(vehicle)
            local gear = GetVehicleCurrentGear(vehicle)
            local rpm = GetVehicleCurrentRpm(vehicle)
            local coords = GetEntityCoords(ped)
            local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            local streetName = GetStreetNameFromHashKey(streetHash)
            
            DisplayRadar(true)
            
            SendNUIMessage({
                action = 'updateVehicle',
                show = true,
                speed = math.ceil(speed),
                fuel = math.ceil(fuel),
                gear = gear,
                rpm = rpm,
                street = streetName
            })
        else
            DisplayRadar(false)
            
            SendNUIMessage({
                action = 'updateVehicle',
                show = false
            })
        end
        
        Citizen.Wait(200)
    end
end)
