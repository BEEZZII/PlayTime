fx_version 'cerulean'
game 'gta5'
author 'BEZZI'
description 'Simple PlayTime script with discord messages'

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}
