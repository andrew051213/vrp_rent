local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

vRPclient = Tunnel.getInterface("vRP", "vRPRent")

local Config = load(LoadResourceFile(GetCurrentResourceName(), 'cfg/config.lua'))()

AddEventHandler("onResourceStart", function (res)
    if (res == GetCurrentResourceName()) then        
        Wait(100)

        TriggerClientEvent('vrp-rent:cfg', -1, Config)
    end
end)

RegisterServerEvent('vrp-rent:config', function ()
    local player = source

    if not player then
        return
    end

    TriggerClientEvent('vrp-rent:cfg', player, Config)
end)

RegisterServerEvent('vrp-rent:buyCar', function (data)
    local player = source

    local user_id = vRP['getUserId']{player}

    local vehicle, price, paymentMethod = data['vehicle'], data['price'], data['paymentMethod']

    if paymentMethod == "cash" then
        if tryPayment(user_id, price) then
            TriggerClientEvent('vrp-rent:spawnCar', player, data)
        else
            vRPclient.notify(player, {"Nu ai $".. price .." cash pentru a plati"})
        end
    elseif paymentMethod == "bank" then
        if tryBankPayment(user_id, price) then
            TriggerClientEvent('vrp-rent:spawnCar', player, data)
        else
            vRPclient.notify(player, {"Nu ai $".. price .." in banca pentru a plati"})
        end
    end
end)