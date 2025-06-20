fx_version 'cerulean'
game 'gta5'

author 'NSX Development'
description 'KDA System - Kill/Death for QB-Core'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/config.js'
}

dependencies {
    'qb-core',
    'oxmysql'
} 