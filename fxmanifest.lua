fx_version 'cerulean'
game 'gta5'
lua54 "yes"
client_script 'client.lua'
server_script 'server.lua'

shared_script {
    'config.lua',
    '@ND_Core/shared/import.lua',
	'@ox_lib/init.lua'
}
