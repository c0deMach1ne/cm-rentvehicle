-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local Active = false
local Vehicle = nil
local Ped = nil
local Spam = true

CreateThread(function()
    while true do
        Wait(200)
        if Active then
            local PlayerLocation = GetEntityCoords(PlayerPedId())
            local VehicleLocation = GetEntityCoords(Vehicle)
            local PedLocation = GetEntityCoords(Ped)

            local PlayerDistVehicle = Vdist(PlayerLocation.x, PlayerLocation.y, PlayerLocation.z, VehicleLocation.x, VehicleLocation.y, VehicleLocation.z)
            local PlayerDistPed = Vdist(PlayerLocation.x, PlayerLocation.y, PlayerLocation.z, PedLocation,x, PedLocation.y, PedLocation.z)

            if PlayerDistVehicle <= 15 then
                if Active then
                    TaskGoToCoordAnyMeans(Ped, PlayerLocation.x, PlayerLocation.y, PlayerLocation.z, 1.0, 0, 0, 786603, 0xbf800000)
                end

                if PlayerDistPed <= 1.5 then
                    Active = false
                    ClearPedTasksImmediately(Ped)
                    GiveKey()
                end
            end
        end
    end
end)

-- Events
RegisterNetEvent('CM-RentVehicle:Client:SpawnVehicle', function(data)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        if Spam then
            QBCore.Functions.TriggerCallback('CM-RentVehicle:Server:CheckMoney', function(canPay)
                if canPay and Spam then
                    TriggerServerEvent('CM-RentVehicle:Server:Pay', data.price)
                    SpawnVehicle(data.modelName, GetEntityCoords(PlayerPedId()))
                elseif not canPay then
                    QBCore.Functions.Notify(Lang:t('error.pay'), 'error')
                end
            end, data.price)
        else
            QBCore.Functions.Notify(Lang:t('error.spam'), 'error')
        end
    else
        QBCore.Functions.Notify(Lang:t('error.process'), 'error')
    end
end)

-- Functions
function SpawnVehicle(modelName, x, y, z)
    Spam = false
    local timer = 2000

    local VehicleHashKey = GetHashKey(modelName)
    local PedModelName = 's_m_y_valet_01'
    local SpawnRadius = Config.SpawnRadius
    local PlayerLocation = GetEntityCoords(PlayerPedId())

    RequestModel(VehicleHashKey)
    while not HasModelLoaded(VehicleHashKey) do
        Wait(10)
    end

    RequestModel(PedModelName)
	while not HasModelLoaded(PedModelName) do
		Wait(10)
	end

	local Found, SpawnPosition, SpawnHeading = GetClosestVehicleNodeWithHeading(PlayerLocation.x + math.random(-SpawnRadius, SpawnRadius), PlayerLocation.y + math.random(-SpawnRadius, SpawnRadius), PlayerLocation.z, 0, 3, 0)

    if not DoesEntityExist(VehicleHashKey) then
		local CreatedVehicle = CreateVehicle(VehicleHashKey, SpawnPosition, SpawnHeading, true, false)
		ClearAreaOfVehicles(GetEntityCoords(CreatedVehicle), 5000, false, false, false, false, false);
		SetVehicleOnGroundProperly(CreatedVehicle)
		local RandomPlate = 'CMR' .. math.random(100, 999)
		SetVehicleNumberPlateText(CreatedVehicle, RandomPlate)
		SetEntityAsMissionEntity(CreatedVehicle, true, true)
		SetVehicleEngineOn(CreatedVehicle, true, true, false)

		local CreatedVehiclePed = CreatePedInsideVehicle(CreatedVehicle, 26, GetHashKey(PedModelName), -1, true, false)

		Wait(timer)
        QBCore.Functions.Notify(Lang:t('info.vehicle_road', { plate = RandomPlate}), 'primary')

		local Blip = AddBlipForEntity(CreatedVehicle)
		SetBlipSprite(Blip, 620)
		SetBlipColour(Blip, 5)
		SetBlipAsShortRange(Blip, false)
		BeginTextCommandSetBlipName("STRING")
      	AddTextComponentString("Rent Vehicle - " .. RandomPlate)
		EndTextCommandSetBlipName(Blip)

		PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
		Wait(timer)
		TaskVehicleDriveToCoord(CreatedVehiclePed, CreatedVehicle, PlayerLocation.x, PlayerLocation.y, PlayerLocation.z, 20.0, 0, GetEntityModel(Vehicle), 524863, 2.0)
		
		Vehicle = CreatedVehicle
		Ped = CreatedVehiclePed
		Active = true
	end
end

local timer = 500
function GiveKey()
    DoScreenFadeOut(250)
    Wait(timer)
    RemovePedElegantly(Ped)
    
    TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(Vehicle))
    QBCore.Functions.Notify(Lang:t('success.givekey'), 'success')

    DeletePed(Ped)
    Wait(timer)
	DoScreenFadeIn(250)

    QBCore.Functions.Notify(Lang:t('success.rent_completed'), 'success')
    Spam = true
end
