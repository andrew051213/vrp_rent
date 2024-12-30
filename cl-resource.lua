local rent = {}

local pedId = 0

local Config

rent['Config'] = RegisterNetEvent('vrp-rent:cfg', function (d)
    Config = d['Config']
end)

rent['nuiFocus'] = function (toggle)
    SetNuiFocus(toggle, toggle)
end

rent['build'] = function ()
    if Config and Config['Rent'] then
        SendNUIMessage({
            act = "interface",
            event = "build",
            config = Config['Rent']
        })

        rent['nuiFocus'](true)
    end
end

rent['rentCar'] = function (data)
    if not data then
        return
    end

    TriggerServerEvent('vrp-rent:buyCar', data)
end

rent['hexToRgb'] = function (hex)
    hex = hex:gsub("#", "")

    local rgb = {}

    for i = 1, 6, 2 do
        table['insert'](rgb, tonumber(hex:sub(i, i + 1), 16))
    end

    return rgb
end

rent['spawnCar'] = RegisterNetEvent('vrp-rent:spawnCar', function (data)    
    local ped = PlayerPedId()

    local vehicle = data['vehicle']
    local color = data['color']

    local x, y, z = Config['Npc']['vehicleSpawnPoint'].x, Config['Npc']['vehicleSpawnPoint'].y, Config['Npc']['vehicleSpawnPoint'].z

    if not x or not y or not z then
        return
    end

    RequestModel(vehicle)

    while not HasModelLoaded(vehicle) do
        Wait(0)
    end

    local vehicle = CreateVehicle(GetHashKey(vehicle), x, y, z, GetEntityHeading(ped), true, false)

    SetVehicleOnGroundProperly(vehicle)
    SetVehicleFuelLevel(vehicle, 100.0)
    SetVehicleFixed(vehicle)
    SetPedIntoVehicle(ped, vehicle, -1)

    local rgb = rent['hexToRgb'](color)
    if rgb then
        SetVehicleCustomPrimaryColour(vehicle, rgb[1], rgb[2], rgb[3])
        SetVehicleCustomSecondaryColour(vehicle, rgb[1], rgb[2], rgb[3])
    end
end)

rent['spawnNpc'] = function ()
    while not Config do
        Wait(500)
    end

    local model = 's_m_y_cop_01'
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(0)
    end

    RequestAnimDict("mini@strip_club@idles@bouncer@base")
    while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
    end

    local ped = CreatePed(1, GetHashKey(model), Config['Npc']['spawnLocation'].x, Config['Npc']['spawnLocation'].y, Config['Npc']['spawnLocation'].z - 1.0, Config['Npc']['heading'] + .0, false, false)

    pedId = ped
    
    SetPedAsNoLongerNeeded(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetPedCanRagdoll(ped, false)
    SetPedConfigFlag(ped, 33, true)
    SetPedConfigFlag(ped, 208, true)
    SetPedConfigFlag(ped, 209, true) 
    SetPedConfigFlag(ped, 330, true)

    TaskPlayAnim(ped, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, false, false, false)

    CreateThread(function()
        while true do
            Wait(500)

            if not IsEntityPlayingAnim(ped, "mini@strip_club@idles@bouncer@base", "base", 3) then
                TaskPlayAnim(ped, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, false, false, false)

                SetEntityHeading(ped, Config['Npc']['heading'] + .0)
            end
        end
    end)

    return ped
end

Citizen['CreateThread'](function ()
    local pedId = nil
    
    local configTimer = 0

    while true do
        local sleep = 500

        if not Config then
            configTimer = configTimer + 1

            if configTimer >= 4 then
                TriggerServerEvent('vrp-rent:config')

                configTimer = 0
            end
        else
            configTimer = 0

            if not pedId then
                pedId = rent['spawnNpc']()
            end
        end

        if Config and Config['Npc'] and pedId then
            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(pedId)) < 2 then
                if IsControlJustPressed(0, 38) then
                    rent['build']()
                end
    
                sleep = 0
            end
        end

        Citizen.Wait(sleep)
    end
end)

RegisterNUICallback("nuiFocus", function (data, cb)
    rent['nuiFocus'](data)

    cb('ok')
end)

RegisterNUICallback("rentCar", function (data, cb)
    rent['rentCar'](data)

    cb('ok')
end)

AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() then
        if DoesEntityExist(pedId) then
            DeleteEntity(pedId)
        end
    end
end)