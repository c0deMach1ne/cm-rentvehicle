Citizen.CreateThread(function()
    if Config.ShowBlip then
        for key, value in ipairs(Config.BlipLocations) do
            Blip = AddBlipForCoord(value.coords)
            SetBlipSprite(Blip, value.sprite)
            SetBlipDisplay(Blip, value.display)
            SetBlipScale(Blip, value.scale)
            SetBlipColour(Blip, value.color)
            SetBlipAsShortRange(Blip, value.shortRange)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(value.text)
            EndTextCommandSetBlipName(Blip)
        end
    end
end)
