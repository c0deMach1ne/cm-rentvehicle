Config = Config or {}

Config.Vehicles = {
    { model = 'asea', price = 100 },
    { model = 'asterope', price = 500 },
}

Config.Motorcycles = {
    { model = 'faggio2', price = 150 },
    { model = 'faggio3', price = 250 },
}

Config.SpawnRadius = 120

Config.ShowBlip = true

Config.BlipLocations = {
	{
        coords = vector3(-242.71, -987.66, 29.29),
        sprite = 227,
        display = 4,
        scale = 0.8,
        color = 6,
        shortRange = true,
        text = 'Rent a Vehicle'
    }
}

-- Ped Listesi
-- Pedler için: https://docs.fivem.net/docs/game-references/ped-models/
Config.PedList = {
	{
		model = 's_m_y_valet_01',
		coords = vector3(-242.71, -987.66, 29.29),               
		heading = 248.33,
		gender = 'male',
        scenario = 'WORLD_HUMAN_COP_IDLES'
	},
}

-- True olarak ayarlanırsa Pedler Z yönünde -1 değer düşürülerek spawn olurlar.
Config.MinusOne = true