fx_version 'cerulean'
game 'gta5'

author 'TuNombre'
description 'Sistema de cárcel para QBCore'
version '1.0.0'

-- Asegúrate de que qb-core sea una dependencia
dependencies {
    'qb-core'
}

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

ui_page 'ui/html/index.html'

files {
    'ui/html/index.html',
    'ui/html/style.css',
    'ui/html/script.js'
}