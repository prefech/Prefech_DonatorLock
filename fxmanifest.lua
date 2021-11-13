--[[
    #####################################################################
    #                _____           __          _                      #
    #               |  __ \         / _|        | |                     #
    #               | |__) | __ ___| |_ ___  ___| |__                   #
    #               |  ___/ '__/ _ \  _/ _ \/ __| '_ \                  #
    #               | |   | | |  __/ ||  __/ (__| | | |                 #
    #               |_|   |_|  \___|_| \___|\___|_| |_|                 #
    #                                                                   #
    #            Prefech_DonatorLock By Prefech 28-09-2021              #
    #                         www.prefech.com                           #
    #                                                                   #
    #####################################################################
]]


author 'Prefech'
description 'Prefech_DonatorLock'
version '1.0.2'

-- Config
shared_script 'config/config.lua'

-- Client Scripts
client_scripts {
    'client/main.lua'
}

-- Server Scripts
server_scripts {
    'server/main.lua'
}

game 'gta5'
fx_version 'cerulean'