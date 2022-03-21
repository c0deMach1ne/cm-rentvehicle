-- Variables
local QBCore = exports['qb-core']:GetCoreObject()

local peds = {}
local genderNum = 0

CreateThread(function()
	exports['qb-target']:AddBoxZone("rentvehicle", vector3(-242.69, -987.67, 29.29), 1, 1, {
		name = "rentvehicle",
		heading = 340,
		debugPoly = false,
		minZ = 28.29,
		maxZ = 30.29,
	}, {
		options = {
			{
				type = 'client',
				event = 'CM-RentVehicle:Client:VehiclesMenu',
				icon = 'fas fa-sign-in-alt',
				label = 'Araç Kirala',
				targeticon = 'fa fa-comment-dots',
			},
			{
				type = 'client',
				event = 'CM-RentVehicle:Client:MotorcyclesMenu',
				icon = 'fas fa-sign-in-alt',
				label = 'Motor Kirala',
				targeticon = 'fa fa-comment-dots',
			}
		},
		distance = 2.0
	})
end)

RegisterNetEvent('CM-RentVehicle:Client:VehiclesMenu', function()
    local VehiclesMenu = {
        {
            header = "Araçlar",
            isMenuHeader = true,
        },
    }
        for _, v in pairs(Config.Vehicles) do
            VehiclesMenu[#VehiclesMenu + 1] = {
                header = 'Model Adı: ' .. v.model,
                txt = 'Fiyat: ' .. v.price,
                params = {
                    event = "CM-RentVehicle:Client:SpawnVehicle",
                    args = {
                        modelName = v.model,
						price = v.price
                    }
                }
            }
        end

        VehiclesMenu[#VehiclesMenu + 1] = {
            header = "Çıkış Yap",
        }
        exports['qb-menu']:openMenu(VehiclesMenu)
end)

RegisterNetEvent('CM-RentVehicle:Client:MotorcyclesMenu', function()
    local MotorcyclesMenu = {
        {
            header = "Araçlar",
            isMenuHeader = true,
        },
    }
        for _, v in pairs(Config.Motorcycles) do
            MotorcyclesMenu[#MotorcyclesMenu + 1] = {
                header = 'Model Adı: ' .. v.model,
                txt = 'Fiyat: ' .. v.price,
                params = {
                    event = "CM-RentVehicle:Client:SpawnVehicle",
                    args = {
                        modelName = v.model,
						price = v.price
                    }
                }
            }
        end

        MotorcyclesMenu[#MotorcyclesMenu + 1] = {
            header = "Çıkış Yap",
        }
        exports['qb-menu']:openMenu(MotorcyclesMenu)
end)

CreateThread(function()
	while true do
		Wait(500)
		for k = 1, #Config.PedList, 1 do
			v = Config.PedList[k]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - v.coords)

			if dist < 50.0 and not peds[k] then
				local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
				peds[k] = {ped = ped}
			end

			if dist >= 50.0 and peds[k] then
				for i = 255, 0, -51 do
					Wait(50)
					SetEntityAlpha(peds[k].ped, i, false)
				end
				DeletePed(peds[k].ped)
				peds[k] = nil
			end
		end
	end
end)

RequestTheModel = function(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end

nearPed = function(model, coords, heading, gender, animDict, animName, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Wait(1)
	end

	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		print("Cinsiyet belirtilmedi. Yapılandırmanızı kontrol edin.")
	end	

	if Config.MinusOne then 
		local x, y, z = table.unpack(coords)
		ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
	else
		ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
	end

	SetEntityAlpha(ped, 0, false)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)

	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end

	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) 
	end

	for i = 0, 255, 51 do
		Wait(50)
		SetEntityAlpha(ped, i, false)
	end

	return ped
end