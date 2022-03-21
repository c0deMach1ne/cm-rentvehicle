fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'c0deMach1ne <fivem@c0demach1ne.com>'
description 'CM-RentVehicle'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/tr.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}
