local holdingup = false
local store = ""
local blipRobbery = nil
local vetrineRotte = 0 

local vetrine = {
	{x = 147.085, y = -1048.612, z = 29.346, heading = 70.326, isOpen = false},--
	{x = -626.735, y = -238.545, z = 38.057, heading = 214.907, isOpen = false},--
	{x = -625.697, y = -237.877, z = 38.057, heading = 217.311, isOpen = false},--
	{x = -626.825, y = -235.347, z = 38.057, heading = 33.745, isOpen = false},--
	{x = -625.77, y = -234.563, z = 38.057, heading = 33.572, isOpen = false},--
	{x = -627.957, y = -233.918, z = 38.057, heading = 215.214, isOpen = false},--
	{x = -626.971, y = -233.134, z = 38.057, heading = 215.532, isOpen = false},--
	{x = -624.433, y = -231.161, z = 38.057, heading = 305.159, isOpen = false},--
	{x = -623.045, y = -232.969, z = 38.057, heading = 303.496, isOpen = false},--
	{x = -620.265, y = -234.502, z = 38.057, heading = 217.504, isOpen = false},--
	{x = -619.225, y = -233.677, z = 38.057, heading = 213.35, isOpen = false},--
	{x = -620.025, y = -233.354, z = 38.057, heading = 34.18, isOpen = false},--
	{x = -617.487, y = -230.605, z = 38.057, heading = 309.177, isOpen = false},--
	{x = -618.304, y = -229.481, z = 38.057, heading = 304.243, isOpen = false},--
	{x = -619.741, y = -230.32, z = 38.057, heading = 124.283, isOpen = false},--
	{x = -619.686, y = -227.753, z = 38.057, heading = 305.245, isOpen = false},--
	{x = -620.481, y = -226.59, z = 38.057, heading = 304.677, isOpen = false},--
	{x = -621.098, y = -228.495, z = 38.057, heading = 127.046, isOpen = false},--
	{x = -623.855, y = -227.051, z = 38.057, heading = 38.605, isOpen = false},--
	{x = -624.977, y = -227.884, z = 38.057, heading = 48.847, isOpen = false},--
	{x = -624.056, y = -228.228, z = 38.057, heading = 216.443, isOpen = false},--
}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function DrawText3D(x,y,z,text,size)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35,0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    --DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 100)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("mt:missiontext")
AddEventHandler("mt:missiontext", function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end)

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

isLockpicking = false
bonuscracked = false
close = false
hacked = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if mainclose and not cracked then
			DrawText3D(-631.418, -237.585, 38.076, "Kilitli", 0.5)
		end
		if close and not bonuscracked then
			-- DrawText3D(-628.58, -229.71, 38.05, "Kilitli", 0.5)	
		end
		if closetohack and not cracked then
			DrawText3D(-623.35, -216.22, 53.94, "[H] Kap??y?? A??", 0.5)
			if IsControlJustPressed(0, 74) then
				ESX.TriggerServerCallback('zentih-vangelico:checkItem', function(data)
					if data then
						loadAnimDict( "mini@repair" ) 
						TaskPlayAnim( PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
						finish = exports['Reload_Skillbar']:taskBar(8000, math.random(10,25))
						TriggerServerEvent('zentih:removekart')
						exports['np-taskbar']:taskBar(1200,"Kap?? A????l??yor",false,true)
						if true then
							
							exports['mythic_notify']:SendAlert('success', 'Kap?? a????ld??')
							TriggerServerEvent('zentih-doorlock:vangelico', true)
						else
							exports['mythic_notify']:SendAlert('error', 'Beceremedin')
						end
						ClearPedTasksImmediately(PlayerPedId())
					else
						exports['mythic_notify']:SendAlert('error', 'San??r??m bunun i??in kart laz??m...')
					end
				end, "secure4")
			end
		end
		if close and not bonuscracked then
			--x = -628.388, y = -229.423, z = 38.057
			DrawText3D(-628.388,-229.423,38.057, "[H] Kap??y?? A??", 0.4)
			if IsControlJustPressed(0, 74) then
				ESX.TriggerServerCallback('zentih-vangelico:checkItem', function(data)
					if data then
						TriggerEvent('zentih-lockpickanim')
						finish = exports['Reload_Skillbar']:taskBar(8000, math.random(10,25))
						exports['np-taskbar']:taskBar(12000,"Kap?? A????l??yor",false,true)
						if true then
							
							exports['mythic_notify']:SendAlert('success', 'Kap?? a????ld??')
							TriggerServerEvent('zentih-doorlock:bonus', true)
						else
							exports['mythic_notify']:SendAlert('error', 'Beceremedin')
						end
						isLockpicking = false
						
					else
						exports['mythic_notify']:SendAlert('error', 'San??r??m bunun i??in maymuncuk laz??m...')
					end
				end, "lockpick")
			end
			
		end
		if closetoinsidehack and not hacked then
			--x = -631.459, y = -230.196, z = 38.057
			DrawText3D(-631.587,-230.236,38.057, "[E] Sisteme S??z", 0.5)
			if IsControlJustPressed(0, 46) then
				ESX.TriggerServerCallback('zentih-vangelico:checkItem', function(data)
					if data then
						-- loadAnimDict( "mini@repair" ) 
						-- TaskPlayAnim( PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
						--finish = exports['Reload_Skillbar2']:taskBar(8000, math.random(10,25))
						
						if true then
							startHack()
							TriggerServerEvent('zentih:removeusb')
							--exports['mythic_notify']:SendAlert('success', 'Kap?? a????ld??')
							TriggerServerEvent('zentih-doorlock:hacked', true)
						else
							exports['mythic_notify']:SendAlert('error', 'Beceremedin')
						end
						ClearPedTasksImmediately(PlayerPedId())
					else
						exports['mythic_notify']:SendAlert('error', 'San??r??m bunun i??in usb laz??m...')
					end
				end, "cokeburn")
			end
		end
	end
end)

Citizen.CreateThread(function()
	while asked do
		Citizen.Wait(200000)
		asked = false
	end
end)

RegisterNetEvent('zentih-lockpickanim')
AddEventHandler('zentih-lockpickanim', function()
	isLockpicking = true
	loadAnimDict('veh@break_in@0h@p_m_one@')
	while isLockpicking do
	if not IsEntityPlayingAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3) then
	TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 1, 0.0, 0, 0, 0)
	Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
	end
	Citizen.Wait(1)
	end
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('zentih-doorlock:vangelico')
AddEventHandler('zentih-doorlock:vangelico', function(state)
	cracked = state
end)

RegisterNetEvent('zentih-doorlock:bonus')
AddEventHandler('zentih-doorlock:bonus', function(state)
	bonuscracked = state
end)
RegisterNetEvent('zentih-doorlock:hacked')
AddEventHandler('zentih-doorlock:hacked', function(state)
	hacked = state
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if not cracked then
			local PlayerPos = GetEntityCoords(PlayerPedId())
			local distance = GetDistanceBetweenCoords(PlayerPos, -628.38, -230.01, 38.05, false)
			local hackdist = GetDistanceBetweenCoords(PlayerPos, -623.35, -216.22, 53.54, true)
			local maindist = GetDistanceBetweenCoords(PlayerPos, -631.418, -237.585, 38.076, true)
			local closetoinside = GetDistanceBetweenCoords(PlayerPos, -631.587, -230.236, 38.057, true)

			if hackdist < 2.5 then
				closetohack = true
			else
				closetohack = false
			end
			if distance < 2.5 then
				close = true
			else
				close=false
			end
			if maindist < 2.5 then
				mainclose = true
			else
				mainclose = false
			end
			if closetoinside < 2.5 then
				closetoinsidehack = true
			else
				closetoinsidehack = false
			end
			
			v1 = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('p_jewel_door_r1'), 0, 0, 0)
			v2 = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('p_jewel_door_l'), 0, 0, 0)

			-- SetEntityHeading(v1, 90-145.9)
			-- SetEntityHeading(v2, 90-145.9)
			FreezeEntityPosition(v1, true)
			FreezeEntityPosition(v2, true)
			Citizen.Wait(1000)
		else
			--x = -631.587, y = -230.236, z = 38.057
			local PlayerPos = GetEntityCoords(PlayerPedId())
			local distance = GetDistanceBetweenCoords(PlayerPos, -628.38, -230.01, 38.05, false)
			local hackdist = GetDistanceBetweenCoords(PlayerPos, -623.35, -216.22, 53.54, true)
			local maindist = GetDistanceBetweenCoords(PlayerPos, -631.418, -237.585, 38.076, true)
			local closetoinside = GetDistanceBetweenCoords(PlayerPos, -631.587, -230.236, 38.057, true)
			if hackdist < 2.5 then
				closetohack = true
			else
				closetohack = false
			end
			if distance < 2.5 then
				close = true
			else
				close=false
			end
			if maindist < 2.5 then
				mainclose = true
			else
				mainclose = false
			end
			if closetoinside < 2.5 then
				closetoinsidehack = true
			else
				closetoinsidehack = false
			end
			v1 = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('p_jewel_door_r1'), 0, 0, 0)
			v2 = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('p_jewel_door_l'), 0, 0, 0)

			FreezeEntityPosition(v1, false)
			FreezeEntityPosition(v2, false)

		end

		if not bonuscracked then
			local PlayerPos = GetEntityCoords(PlayerPedId())
			
			a1 = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('v_ilev_j2_door'), 0, 0, 0)
			FreezeEntityPosition(a1, true)

			-- SetEntityHeading(v1, 90-145.9)
			-- SetEntityHeading(v2, 90-145.9)
			Citizen.Wait(1000)
		else
			local PlayerPos = GetEntityCoords(PlayerPedId())
			a1 = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('v_ilev_j2_door'), 0, 0, 0)
			
			FreezeEntityPosition(a1, false)
		end

	end

end)

--			v1 = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('v_ilev_j2_door'), 0, 0, 0)


RegisterNetEvent('esx_vangelico_robbery:currentlyrobbing')
AddEventHandler('esx_vangelico_robbery:currentlyrobbing', function(robb)
	holdingup = true
	store = robb
end)

RegisterNetEvent('esx_vangelico_robbery:killblip')
AddEventHandler('esx_vangelico_robbery:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_vangelico_robbery:setblip')
AddEventHandler('esx_vangelico_robbery:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
end)

RegisterNetEvent('esx_vangelico_robbery:toofarlocal')
AddEventHandler('esx_vangelico_robbery:toofarlocal', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	incircle = false
end)


RegisterNetEvent('esx_vangelico_robbery:robberycomplete')
AddEventHandler('esx_vangelico_robbery:robberycomplete', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_complete'))
	store = ""
	incircle = false
end)

Citizen.CreateThread(function()
	for k,v in pairs(Stores)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 439)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('shop_robbery'))
		EndTextCommandSetBlipName(blip)
	end
end)

animazione = false
incircle = false
soundid = GetSoundId()

function drawTxt(x, y, scale, text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.64, 0.64)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
    DrawText(0.155, 0.935)
end

local borsa = nil

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
	  TriggerEvent('skinchanger:getSkin', function(skin)
		borsa = skin['bags_1']
	  end)
	  Citizen.Wait(1000)
	end
end)

function startAnim()
	Citizen.CreateThread(function()
	  RequestAnimDict("mp_prison_break")
	  while not HasAnimDictLoaded("mp_prison_break") do
		Citizen.Wait(0)
	  end
		TaskPlayAnim(GetPlayerPed(-1), "mp_prison_break", "hack_loop" ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function startHack()
	startAnim()
	block = Config.Block
	hacktime = Config.Time
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",block,hacktime,hackProgress)
end

function hackProgress(success, timeremaining)
	TriggerEvent('mhacking:hide')
	Citizen.Wait(500)
	ClearPedTasks(PlayerPedId())
	if success then
		local random = math.random(100)
			if random <= Config.PoliceNotify then
				TriggerServerEvent('zentih-hacknotify')
			end
		exports['mythic_notify']:SendAlert('error', 'Hack i??lemi ba??ar??yla ger??ekle??ti paran??n banka hesab??na ge??mesi biraz zaman alabilir!')
		Citizen.Wait(math.random(20000,40000))
		exports['mythic_notify']:SendAlert('success', Config.HackPrice.. '$ hesab??na ge??ti!')
	  	TriggerServerEvent('zentih-vangelico:addBank', Config.HackPrice)

	else
  
	  exports['mythic_notify']:SendAlert('error', 'Ba??aramad??n!')
	  TriggerServerEvent('zentih-hacknotify')
	end
	Citizen.Wait(1000)

end

RegisterNetEvent('zentih:asked')
AddEventHandler('zentih:asked', function()
	asked = false
end)

asked = false
Citizen.CreateThread(function()
      
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		-- for k,v in pairs(Stores)do
		-- 	local pos2 = v.position

		-- 	if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
		-- 		if not holdingup then
		-- 			DrawMarker(20, v.position.x, v.position.y, v.position.z+0.2, 0, 0, 0, 0, 0, 0, 0.75, 0.75, 0.375, 255, 128, 128, 200, 0, 1, 0, 0)

		-- 			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
		-- 				if (incircle == false) then
		-- 					DisplayHelpText('[E] ile soygunu ba??lat')
		-- 				end
		-- 				incircle = true
		-- 				if IsControlJustPressed(0, 46) then
		-- 					if Config.NeedBag then
		-- 					    if borsa == 40 or borsa == 41 or borsa == 44 or borsa == 45 then
		-- 					        ESX.TriggerServerCallback('esx_vangelico_robbery:conteggio', function(CopsConnected)
		-- 						        if CopsConnected >= Config.RequiredCopsRob then
		-- 					                TriggerServerEvent('esx_vangelico_robbery:rob', k)
		-- 							        PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", pos2.x, pos2.y, pos2.z)
		-- 						        else
		-- 							        exports['mythic_notify']:SendAlert('error', _U('min_two_police') .. Config.RequiredCopsRob .. _U('min_two_police2'))
		-- 						        end
		-- 					        end)		
		-- 				        else
		-- 					        exports['mythic_notify']:SendAlert('error', _U('need_bag'))
		-- 						end
		-- 					else
		-- 						ESX.TriggerServerCallback('esx_vangelico_robbery:conteggio', function(CopsConnected)
		-- 							if CopsConnected >= Config.RequiredCopsRob then
		-- 								TriggerServerEvent('esx_vangelico_robbery:rob', k)
		-- 								PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", pos2.x, pos2.y, pos2.z)
		-- 							else
		-- 								exports['mythic_notify']:SendAlert('error', _U('min_two_police') .. Config.RequiredCopsRob .. _U('min_two_police2'))
		-- 							end
		-- 						end)	
		-- 					end	
        --                 end
		-- 			elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
		-- 				incircle = false
		-- 			end		
		-- 		end
		-- 	end
		-- end

		if true then
			--drawTxt(0.3, 1.4, 0.45, _U('smash_case') .. ' :~r~ ' .. vetrineRotte .. '/' .. Config.MaxWindows, 185, 185, 185, 255)
			for k,v in pairs(Stores)do
				pos2 = v.position
				--local pos2 = Stores[store].position
			

				for i,v in pairs(vetrine) do 
					-- if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 10.0) and not v.isOpen and Config.EnableMarker then 
					-- 	--DrawText3D(v.x, v.y, v.z, "[E]", 0.5)
					-- 	--DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 0, 255, 0, 200, 1, 1, 0, 0)
					-- end
					if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 0.5) and not v.isOpen then 
						DrawText3D(v.x, v.y, v.z, '[E] ', 0.5)
						if IsControlJustPressed(0, 38) then
							ESX.TriggerServerCallback('esx_vangelico_robbery:conteggio', function(CopsConnected)
								if CopsConnected >= Config.RequiredCopsRob then
									if not asked then
										TriggerServerEvent('esx_vangelico_robbery:rob', k)
										asked = true
									end
									if holdingup then
										PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", pos2.x, pos2.y, pos2.z)
										animazione = true
										SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z-0.95)
										SetEntityHeading(GetPlayerPed(-1), v.heading)
										v.isOpen = true 
										TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 7.5, 'robberyglassbreak', 0.5)
										--PlaySoundFromCoord(-1, "Glass_Smash", v.x, v.y, v.z, "", 0, 0, 0)
										if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
										RequestNamedPtfxAsset("scr_jewelheist")
										end
										while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
										Citizen.Wait(0)
										end
										SetPtfxAssetNextCall("scr_jewelheist")
										StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", v.x, v.y, v.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
										loadAnimDict( "missheist_jewel" ) 
										TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
										exports['np-taskbar']:taskBar(3000,"Toplan??yor",false,true)
										--TriggerEvent("mt:missiontext", _U('collectinprogress'), 3000)
										--DisplayHelpText(_U('collectinprogress'))
										--DrawSubtitleTimed(5000, 1)
										--Citizen.Wait(5000)
										ClearPedTasksImmediately(GetPlayerPed(-1))
										TriggerServerEvent('esx_vangelico_robbery:gioielli')
										PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
										vetrineRotte = vetrineRotte+1
										animazione = false

										if vetrineRotte == Config.MaxWindows then 
											for i,v in pairs(vetrine) do 
												v.isOpen = false
												vetrineRotte = 0
											end
											TriggerServerEvent('esx_vangelico_robbery:endrob', store)
											ESX.ShowNotification(_U('lester'))
											holdingup = false
											StopSound(soundid)
										end
									end
								else
									exports['mythic_notify']:SendAlert('error', _U('min_two_police') .. Config.RequiredCopsRob .. _U('min_two_police2'))
								end
							end)
						end
					end	
				end
			end
			if holdingup then
				if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -622.566, -230.183, 38.057, true) > 11.5 ) then
					TriggerServerEvent('esx_vangelico_robbery:toofar', store)
					holdingup = false
					for i,v in pairs(vetrine) do 
						v.isOpen = false
						vetrineRotte = 0
					end
					StopSound(soundid)
				end
			end

		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
      
	while true do
		Wait(1)
		if animazione == true then
			if not IsEntityPlayingAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 3) then
				TaskPlayAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 8.0, 8.0, -1, 17, 1, false, false, false)
			end
		end
	end
end)

RegisterNetEvent("lester:createBlip")
AddEventHandler("lester:createBlip", function(type, x, y, z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	if(type == 77)then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Lester")
		EndTextCommandSetBlipName(blip)
	end
end)

blip = false

Citizen.CreateThread(function()
	TriggerEvent('lester:createBlip', 77, 706.669, -966.898, 30.413)
	while true do
	
		Citizen.Wait(1)
	
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 706.669, -966.898, 30.413, true) <= 10 and not blip then
				DrawMarker(20, 706.669, -966.898, 30.413, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 100, 102, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, 706.669, -966.898, 30.413, true) < 1.0 then
					DisplayHelpText(_U('press_to_sell'))
					if IsControlJustReleased(1, 51) then
						blip = true
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity >= Config.MaxJewelsSell then
								ESX.TriggerServerCallback('esx_vangelico_robbery:conteggio', function(CopsConnected)
									if CopsConnected >= Config.RequiredCopsSell then
										FreezeEntityPosition(playerPed, true)
										TriggerEvent('mt:missiontext', _U('goldsell'), 10000)
										Wait(10000)
										FreezeEntityPosition(playerPed, false)
										TriggerServerEvent('lester:vendita')
										blip = false
									else
										blip = false
										exports['mythic_notify']:SendAlert('error', _U('copsforsell') .. Config.RequiredCopsSell .. _U('copsforsell2'))
									end
								end)
							else
								blip = false
								exports['mythic_notify']:SendAlert('error', _U('notenoughgold'))
							end
						end, 'jewels')
					end
				end
			end
	end
end)

