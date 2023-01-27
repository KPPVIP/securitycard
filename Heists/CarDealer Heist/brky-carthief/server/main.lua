ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local activity = 0
local activitySource = 0
local isCooldownActive = 0

RegisterServerEvent('disc-carthief:pay')
AddEventHandler('disc-carthief:pay', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addMoney(Config.Price)
    isCooldownActive = 1
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isCooldownActive == 1 then
            Citizen.Wait(Config.CooldownTime * 60 * 1000)
            isCooldownActive = 0
        end
    end
end)

ESX.RegisterServerCallback('disc-carthief:anycops', function(source, cb)
    local anycops = 0
    local playerList = GetPlayers()
    for i = 1, #playerList, 1 do
        local _source = playerList[i]
        local xPlayer = ESX.GetPlayerFromId(_source)
        local playerjob = xPlayer.job.name
        if playerjob == 'police' then
            anycops = anycops + 1
        end
    end
    cb(anycops)
end)

ESX.RegisterServerCallback('disc-carthief:isActive', function(source, cb)
    cb(activity, isCooldownActive)
end)

ESX.RegisterUsableItem('jammer', function(source)
    TriggerClientEvent('disc-carthief:jammerActive', source)
end)

RegisterServerEvent('disc-carthief:registerActivity')
AddEventHandler('disc-carthief:registerActivity', function(value)
    activity = value
    if value == 1 then
        activitySource = source
        --Send notification to cops
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
                TriggerClientEvent('disc-carthief:setcopnotification', xPlayers[i])
            end
        end
    else
        activitySource = 0
        isCooldownActive = 1
    end
end)

RegisterServerEvent('disc-carthief:alertcops')
AddEventHandler('disc-carthief:alertcops', function(cx, cy, cz)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('disc-carthief:setcopblip', xPlayers[i], cx, cy, cz)
        end
    end
end)

RegisterServerEvent('disc-carthief:activatedJammerCops')
AddEventHandler('disc-carthief:activatedJammerCops', function(cx, cy, cz)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('disc-carthief:activatedJammerCops', xPlayers[i], cx, cy, cz)
        end
    end
end)

RegisterServerEvent('disc-carthief:removeJammer')
AddEventHandler('disc-carthief:removeJammer', function()
    local player = ESX.GetPlayerFromId(source)
    player.removeInventoryItem('jammer', 1)
end)


RegisterServerEvent('disc-carthief:stopalertcops')
AddEventHandler('disc-carthief:stopalertcops', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('disc-carthief:removecopblip', xPlayers[i])
        end
    end
end)

AddEventHandler('playerDropped', function()
    local _source = source
    if _source == activitySource then
        --Remove blip for all cops
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
                TriggerClientEvent('disc-carthief:removecopblip', xPlayers[i])
            end
        end
        --Set activity to 0
        activity = 0
        activitySource = 0
        isCooldownActive = 1
    end
end)


ESX.RegisterServerCallback('brky:anahtar', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	itemcount = xPlayer.getInventoryItem(item).count
	if itemcount > 0 then
		cb(true)
	else
        activity = 0
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Anahatarın Yok!'})
	end
end)

RegisterServerEvent('brky:removeanahtar')
AddEventHandler('brky:removeanahtar', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('security6', 1)
end)

RegisterNetEvent("brky:buyjammer")
AddEventHandler("brky:buyjammer", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem('cash').count >= Config.JammerPrice then
        xPlayer.removeMoney(Config.JammerPrice)
        xPlayer.addInventoryItem('jammer', 1)
    else TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Yeterli paran yok!'})
    end
end)