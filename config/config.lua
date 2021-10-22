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

Config = {}

--[[ Ace permission needed for using the staff commands ]]
Config.AdminPerm = "jd.staff"

-- [[ Below you can add the commands you want to use ]]
Config.Commands = {
    ['GiveDonatorKeys'] = {'gdk', 'givedonatorkeys'},
    ['RemoveDonatorKeys'] = {'rdk', 'removedonatorkeys'},
    ['AddDonatorLock'] = {'adl', 'adddonatorlock'},
    ['RemoveDonatorLock'] = {'rdl', 'removedonatorlock'},
    ['UpdateDonatorLockLimit'] = {'sdll', 'setdonatorlocklimit'},
}

--[[ Below you can edit the messages ]]
Config.Messages = {
    --[[ Error Messages ]]
    ['HasAccess'] = "User already has access.",
    ['HasNoAccess'] = "User doesn't have access.",
    ['MaxLimit'] = "You have reached the limit of allowed players for this vehicle.",
    ['NotOwner'] = "You do not own this vehicle.",
    ['NotLocked'] = "Vehicle is not locked.",
    ['VehicleLocked'] = "Vehicle is already locked",

    -- [[ Success Messages: ]]
    ['KeysGiven'] = "You have given the keys to: {{TargetName}}",
    ['KeysTaken'] = "You have taken the keys from: {{TargetName}}",
    ['SuccessLocked'] = "You have locked the vehicle.",
    ['SuccessUnLocked'] = "You have unlocked the vehicle.",
    ['LimitUpdated'] = "You have updated the access limit.",

    --[[ Permission Denied for Staff Commands ]]
    ['AccessDenied'] = "You are not allowed to use this command",

    --[[ Kick out of the vehicle notification ]]
    ['NoPermission'] = "You ~r~don't ~w~have permission to use this vehicle.",
}


--[[ This is optional for when you want logs: https://github.com/Prefech/JD_logs ]]
Config.JD_logs = {
    ['Enabled'] = false,
    ['Channel'] = "DonatorLock",
    ['Color'] = ""
}

--[[ Debug shizzel ]]
Config.versionCheck = "1.0.0"