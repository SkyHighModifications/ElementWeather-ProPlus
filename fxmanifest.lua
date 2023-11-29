-- FiveM WeatherSync Pro+
-- Version: 1.0.0
-- Made by SkyHigh Modifications

fx_version "cerulean"
game "gta5"
description "FiveM WeatherSync ProPlus"
version "1.0.0"
version_2 "3.2.0"
author "SkyHigh Modifications / @Papa Smurf / "

server_scripts {
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}

shared_script "config.lua"

escrow_ignore {
    "config.lua"
}