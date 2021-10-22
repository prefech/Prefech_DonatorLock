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

status = true
RegisterNetEvent("Prefech:updateAccess")
AddEventHandler("Prefech:updateAccess", function(_status)
	status = _status
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    local veh = nil
    local iPed = GetPlayerPed(-1)
    Citizen.Wait(0)
    if IsPedInAnyVehicle(iPed, false) then
        veh = GetVehiclePedIsUsing(iPed)
        VehHash = GetEntityModel(veh)
    end
    
    if DoesEntityExist(veh) then
        if GetPedInVehicleSeat(veh, -1) == iPed then
            TriggerServerEvent("Prefech:checkAccess", GetDisplayNameFromVehicleModel(VehHash):lower())
            Citizen.Wait(500)
            if not status then
                ClearPedTasksImmediately(iPed)
                SetEntityAsMissionEntity(veh, true, true)                
                ShowInfo(Config.Messages['NoPermission'])
                if Config.JD_logs['Enabled'] then
                    exports.JD_logs:discord(GetPlayerName("**"..GetPlayerServerId(PlayerId())).."** tried to get into a `"..GetDisplayNameFromVehicleModel(VehHash).."` but got kicked out!", GetPlayerServerId(PlayerId()), 0, Config.JD_logs['Color'], Config.JD_logs['Channel'])
                end
            end
        end        
    end
   end
end)

function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, false)
end