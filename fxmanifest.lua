fx_version "cerulean"

game "gta5"

lua54 "yes"

author "@andrew051211"

client_scripts({
	"cl-resource.lua",
})

shared_script({
	"cfg/config.lua"
})

server_scripts({
	"@vrp/lib/utils.lua",
	"sv-resource.lua",
	"shared/server.lua"
})

ui_page "web/index.html"

ui_page_preload "yes"

files({
	"web/**/*",
})
