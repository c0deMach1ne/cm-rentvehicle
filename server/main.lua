-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local CanPay = false

QBCore.Functions.CreateCallback('CM-RentVehicle:Server:CheckMoney', function(source, cb, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money['bank'] >= price or Player.PlayerData.money['cash'] >= price then
    	CanPay = true
    end

    cb(CanPay)
end)

RegisterServerEvent('CM-RentVehicle:Server:Pay')
AddEventHandler('CM-RentVehicle:Server:Pay', function(price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if CanPay then
    	if Player.PlayerData.money['bank'] then
	    	Player.Functions.RemoveMoney('bank', price)
	    else
	    	Player.Functions.RemoveMoney('cash', price)
	    end
	end
end)