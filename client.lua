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

local function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}

    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * (math.abs(safezone - 1.0) * 10)))
    Minimap.bottom_y = 1.0 - 0.025 
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

Citizen.CreateThread(function()
    local minimap = RequestStreamedTextureDict('squaremap', false)
    SetMinimapClipType(0)
    AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', 'squaremap', 'radarmasksm')
    
    SetMinimapComponentPosition('minimap', 'L', 'B', 0.0, 0.0, 0.175, 0.25)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0, 0.0, 0.175, 0.25)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.0, 0.0, 0.175, 0.25)

    while true do
        local ped = PlayerPedId()
        local player = PlayerId()
        local health = GetEntityHealth(ped) - 100
        local armor = GetPedArmour(ped)
        local stamina = 100 - GetPlayerSprintStaminaRemaining(player)
        
        if QBCore then
            local playerData = QBCore.Functions.GetPlayerData()
            if playerData.metadata then
                hunger = playerData.metadata['hunger']
                thirst = playerData.metadata['thirst']
                stress = playerData.metadata['stress']
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
