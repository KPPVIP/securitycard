ESX = nil
local PlayerData = {}
local currentZone = ''
local LastZone = ''
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local alldeliveries = {}
local randomdelivery = 1
local isTaken = 0
local isDelivered = 0
local car = 0
local copblip
local deliveryblip
local isJammerActive = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

--Add all deliveries to the table
Citizen.CreateThread(function()
    local deliveryids = 1
    for k, v in pairs(Config.Delivery) do
        table.insert(alldeliveries, {
            id = deliveryids,
            posx = v.Pos.x,
            posy = v.Pos.y,
            posz = v.Pos.z,
            payment = v.Payment,
            car = v.Cars,
        })
        deliveryids = deliveryids + 1
    end
end)

function SpawnCar()
    Citizen.Wait(1000)
    TriggerEvent("mhacking:show")
    TriggerEvent("mhacking:start",7,35,mycb)
    ESX.TriggerServerCallback('disc-carthief:isActive', function(isActive, isCooldownActive)
        if isCooldownActive == 1 then
            exports['mythic_notify']:SendAlert('error', "Cooldown aktif!")
        elseif isActive == 0 then
            ESX.TriggerServerCallback('disc-carthief:anycops', function(anycops)
                if anycops >= Config.CopsRequired then

                    --Get a random delivery point
                    randomdelivery = math.random(1, #alldeliveries)

                    --Delete vehicles around the area (not sure if it works)
                    ClearAreaOfVehicles(Config.VehicleSpawnPoint.Pos.x, Config.VehicleSpawnPoint.Pos.y, Config.VehicleSpawnPoint.Pos.z, 10.0, false, false, false, false, false)

                    --Delete old vehicle and remove the old blip (or nothing if there's no old delivery)
                    SetEntityAsNoLongerNeeded(car)
                    DeleteVehicle(car)
                    RemoveBlip(deliveryblip)


                    --Get random car
                    randomcar = math.random(1, #alldeliveries[randomdelivery].car)

                    --Spawn Car
                    local vehiclehash = GetHashKey(alldeliveries[randomdelivery].car[randomcar])
                    RequestModel(vehiclehash)
                    while not HasModelLoaded(vehiclehash) do
                        RequestModel(vehiclehash)
                        Citizen.Wait(100)
                    end
                    car = CreateVehicle(vehiclehash, Config.VehicleSpawnPoint.Pos.x, Config.VehicleSpawnPoint.Pos.y, Config.VehicleSpawnPoint.Pos.z, 0.0, true, false)
                    SetEntityAsMissionEntity(car, true, true)

                    --Teleport player in car
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), car, -1)

                    --Set delivery blip
                    deliveryblip = AddBlipForCoord(alldeliveries[randomdelivery].posx, alldeliveries[randomdelivery].posy, alldeliveries[randomdelivery].posz)
                    SetBlipSprite(deliveryblip, 1)
                    SetBlipDisplay(deliveryblip, 4)
                    SetBlipScale(deliveryblip, 1.0)
                    SetBlipColour(deliveryblip, 5)
                    SetBlipAsShortRange(deliveryblip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Teslimat Noktası")
                    EndTextCommandSetBlipName(deliveryblip)

                    SetBlipRoute(deliveryblip, true)

                    --Register acitivity for server
                    TriggerServerEvent('disc-carthief:registerActivity', 1)

                    --For delivery blip
                    isTaken = 1

                    --For delivery blip
                    isDelivered = 0
                else
                    exports['mythic_notify']:SendAlert('error', "Şehirde yeterli polis yok!")
                end
            end)
        else
            exports['mythic_notify']:SendAlert('error', "Halihazırda bir araba soygunu var!")
        end
    end)
end

function FinishDelivery()
    if (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) and GetEntitySpeed(car) < 3 then

        local EngineDamageFactor = math.max(GetVehicleEngineHealth(car) / 1000, 0.4)
        local BodyDamageFactor = math.max(GetVehicleBodyHealth(car) / 1000, 0.4)

        --Delete Car
        SetEntityAsNoLongerNeeded(car)
        DeleteEntity(car)

        --Remove delivery zone
        RemoveBlip(deliveryblip)
        --Pay the poor fella
        local finalpayment = math.floor(alldeliveries[randomdelivery].payment * EngineDamageFactor * BodyDamageFactor)

        exports['mythic_notify']:SendAlert('success', "Soygunu bitirdiniz, işte ödemeniz!")

        TriggerServerEvent('disc-carthief:pay', finalpayment)

        --Register Activity
        TriggerServerEvent('disc-carthief:registerActivity', 0)

        --For delivery blip
        isTaken = 0

        --For delivery blip
        isDelivered = 1

        --Stop jammer
        isJammerActive = 0

        --Remove Last Cop Blips
        TriggerServerEvent('disc-carthief:stopalertcops')

    else
        exports['mythic_notify']:SendAlert('error', "Sizin için sağlanan arabayı kullanmak zorundasınız ve tam bir mola vermelisiniz.")
    end
end

function AbortDelivery()

    if isTaken == 1 and isDelivered == 0 then

        exports['mythic_notify']:SendAlert('error', "Görev Başarısız!")

        --Delete Car
        SetEntityAsNoLongerNeeded(car)
        DeleteEntity(car)

        --Remove delivery zone
        RemoveBlip(deliveryblip)

        --Register Activity
        TriggerServerEvent('disc-carthief:registerActivity', 0)

        --For delivery blip
        isTaken = 0

        --For delivery blip
        isDelivered = 1

        --Stop jammer
        isJammerActive = 0

        --Remove Last Cop Blips
        TriggerServerEvent('disc-carthief:stopalertcops')
    end
end

RegisterNetEvent('disc-carthief:jammerActive')
AddEventHandler('disc-carthief:jammerActive', function()
    if isTaken == 1 and isDelivered == 0 and (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
        isJammerActive = 1
        exports['mythic_notify']:SendAlert('inform', "Jammer aktif edildi!")
        TriggerServerEvent('disc-carthief:removeJammer')
    end
end)

--Check if player left car
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if isTaken == 1 and isDelivered == 0 and not (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
            exports['mythic_notify']:SendAlert('error', "Arabaya geri dönmek için 1 dakikanız var")
            Wait(50000)
            if isTaken == 1 and isDelivered == 0 and not (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
                exports['mythic_notify']:SendAlert('error', "Arabaya geri dönmek için 10 saniyen var")
                Wait(10000)
                AbortDelivery()
            end
        end
    end
end)

-- Send location
Citizen.CreateThread(function()
    while true do
        if isTaken == 1 and IsPedInAnyVehicle(GetPlayerPed(-1)) and isJammerActive == 0 then
            Citizen.Wait(Config.BlipUpdateTime)
            local coords = GetEntityCoords(GetPlayerPed(-1))
            TriggerServerEvent('disc-carthief:alertcops', coords.x, coords.y, coords.z)
        elseif isJammerActive == 1 then
            TriggerServerEvent('disc-carthief:activatedJammerCops')
            TriggerServerEvent('disc-carthief:stopalertcops')
            Citizen.Wait(5000)
        elseif isTaken == 1 and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            TriggerServerEvent('disc-carthief:stopalertcops')
            Citizen.Wait(Config.BlipUpdateTime)
        elseif isTaken == 0 then
            TriggerServerEvent('disc-carthief:stopalertcops')
            Citizen.Wait(Config.BlipUpdateTime)
        else
            Citizen.Wait(5000)
        end
    end
end)


--Cancel after x minutes to avoid abuse
Citizen.CreateThread(function()
    while true do
        if isTaken == 1 then
            Citizen.Wait(Config.FinishTime * 60 * 1000)
            AbortDelivery()
        else
            Citizen.Wait(5000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isJammerActive == 1 then
            Citizen.Wait(Config.JammerTime * 60 * 1000)
            isJammerActive = 0
        else
            Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent('disc-carthief:removecopblip')
AddEventHandler('disc-carthief:removecopblip', function()
    RemoveBlip(copblip)
end)

RegisterNetEvent('disc-carthief:activatedJammerCops')
AddEventHandler('disc-carthief:activatedJammerCops', function()
    exports['mythic_notify']:SendAlert('error', "Suçlular sinyal bozucusunu etkinleştirdiler! Dikkat!")
end)

RegisterNetEvent('disc-carthief:setcopblip')
AddEventHandler('disc-carthief:setcopblip', function(cx, cy, cz)
    RemoveBlip(copblip)
    copblip = AddBlipForCoord(cx, cy, cz)
    SetBlipSprite(copblip, 161)
    SetBlipScale(copblipy, 2.0)
    SetBlipColour(copblip, 8)
    PulseBlip(copblip)
end)

RegisterNetEvent('disc-carthief:setcopnotification')
AddEventHandler('disc-carthief:setcopnotification', function()
    exports['mythic_notify']:SendAlert('inform', "Galeride soygun başladı.Radarda gösteriliyor!")
end)

AddEventHandler('disc-carthief:hasEnteredMarker', function(zone)
    if LastZone == 'menucarthief' then
        CurrentAction = 'carthief_menu'
        CurrentActionMsg = '~INPUT_CONTEXT~ Arabanın anahtarlarını al!'
        CurrentActionData = { zone = zone }
    elseif LastZone == 'cardelivered' then
        CurrentAction = 'cardelivered_menu'
        CurrentActionMsg = '~INPUT_CONTEXT~ Aracı Bırak!'
        CurrentActionData = { zone = zone }
    end
end)

AddEventHandler('disc-carthief:hasExitedMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local isInMarker = false
        local currentZone = nil

        if (GetDistanceBetweenCoords(coords, Config.Zones.VehicleSpawner.Pos.x, Config.Zones.VehicleSpawner.Pos.y, Config.Zones.VehicleSpawner.Pos.z, true) < 1.5) then
            isInMarker = true
            currentZone = 'menucarthief'
            LastZone = 'menucarthief'
        end

        if isTaken == 1 and (GetDistanceBetweenCoords(coords, alldeliveries[randomdelivery].posx, alldeliveries[randomdelivery].posy, alldeliveries[randomdelivery].posz, true) < 3) then
            isInMarker = true
            currentZone = 'cardelivered'
            LastZone = 'cardelivered'
        end

        if isInMarker and not HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = true
            TriggerEvent('disc-carthief:hasEnteredMarker', currentZone)
        end
        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('disc-carthief:hasExitedMarker', LastZone)
        end
    end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            local player = PlayerId()
            local plyPed = GetPlayerPed(player)
            if IsControlJustReleased(0, 38) then
                if CurrentAction == 'carthief_menu' then
                    ESX.TriggerServerCallback('brky:anahtar', function(data)
                    ESX.TriggerServerCallback('disc-carthief:isActive', function(isActive, isCooldownActive)
                        if isCooldownActive == 1 then
                            exports['mythic_notify']:SendAlert('error', "Cooldown aktif!")
                        elseif isActive == 0 then
                            TriggerServerEvent('brky:removeanahtar')
                    TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, true)
                    exports['np-taskbar']:taskBar(3000, "Anahtarlar aranıyor!")
                    Citizen.Wait(3000)
                    SpawnCar()
                    CurrentAction = nil
                        end
                    end)
                end, "security6")
                elseif CurrentAction == 'cardelivered_menu' then
                    FinishDelivery()
                    CurrentAction = nil
                end
            end
        end
    end
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))

        for k, v in pairs(Config.Zones) do
            if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
            end
        end

    end
end)

-- Display markers for delivery place
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isTaken == 1 and isDelivered == 0 then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            v = alldeliveries[randomdelivery]
            if (GetDistanceBetweenCoords(coords, v.posx, v.posy, v.posz, true) < Config.DrawDistance) then
                DrawMarker(1, v.posx, v.posy, v.posz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 204, 204, 0, 100, false, false, 2, false, false, false, false)
            end
        end
    end
end)


function mycb(success, timeremaining)
	if success then
		--print('Success with '..timeremaining..'s remaining.')
        TriggerEvent('mhacking:hide')
	else
		--print('Failure')
        TriggerEvent('mhacking:hide')
        AbortDelivery()
	end
end

local firstspawn = false

Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_y_airworker")

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        Citizen.Wait(100)
    end

    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end

    if firstspawn == false then
        local npc = CreatePed(6, hash, Config.NPCX, Config.NPCY, Config.NPCZ , 313.0, false, false)
        SetEntityInvincible(npc, true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetPedDiesWhenInjured(npc, false)
        SetPedCanRagdollFromPlayerImpact(npc, false)
        SetPedCanRagdoll(npc, false)
        SetEntityAsMissionEntity(npc, true, true)
        SetEntityDynamic(npc, true)
    end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.45, 0.45)
    SetTextFont(6)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 0, 0, 0, 100)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))

        for k, v in pairs(Config.Tukkan) do
            if (GetDistanceBetweenCoords(coords, Config.TextX, Config.TextY, Config.TextZ, true) < 3) then
                DrawText3Ds(Config.TextX, Config.TextY, Config.TextZ, "[E] Osman")
                if IsControlJustReleased(0, 38) then
                    BrkyBuy()
                end
            end
        end

    end
end)


function BrkyBuy()
    local elements = {
        {label = 'Jammer Satın Al',       value = 'jammerbuy'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jeweler_actions', {
        title    = 'Jammer Satın Al',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'jammerbuy' then
           menu.close()
           veranim()
           exports['np-taskbar']:taskBar(3000, "Etkileşimedesin!")
           veranim()
           TriggerServerEvent("brky:buyjammer")
        end
    end)
end

function veranim() 
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common")do 
        Citizen.Wait(0)
    end;b=CreateObject(GetHashKey('prop_weed_bottle'),0,0,0,true)
    AttachEntityToEntity(b,PlayerPedId(),
    GetPedBoneIndex(PlayerPedId(),57005),0.13,0.02,0.0,-90.0,0,0,1,1,0,1,0,1)
    AttachEntityToEntity(p,l,GetPedBoneIndex(l,57005),0.13,0.02,0.0,-90.0,0,0,1,1,0,1,0,1)
    TaskPlayAnim(GetPlayerPed(-1),"mp_common","givetake1_a",8.0,-8.0,-1,0,0,false,false,false)
    TaskPlayAnim(l,"mp_common","givetake1_a",8.0,-8.0,-1,0,0,false,false,false)
    Wait(1550)
    DeleteEntity(b)
    ClearPedTasks(pid)
    ClearPedTasks(l)
end