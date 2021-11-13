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

for k,v in pairs(Config.Commands['GiveDonatorKeys']) do
	TriggerEvent('chat:addSuggestion', v, 'Give someone access to your donator vehicle.', {
        { name="UserID", help="The Id of the player you want to give access." }
    })
end

for k,v in pairs(Config.Commands['RemoveDonatorKeys']) do
	TriggerEvent('chat:addSuggestion', v, 'Remove someone access from your donator vehicle.', {
        { name="UserID", help="The Id of the player you want to remove access for." }
    })
end

for k,v in pairs(Config.Commands['AddDonatorLock']) do
	TriggerEvent('chat:addSuggestion', v, 'Add a donator lock to a vehicle.', {
        { name="Vehicle", help="Spawn code for the vehicle" },
        { name="Owner", help="The id of the owner of the vehicle." },
        { name="Limit", help="How many people they can give access to the vehicle" }
    })
end

for k,v in pairs(Config.Commands['RemoveDonatorLock']) do
	TriggerEvent('chat:addSuggestion', v, 'Remove a donator lock from a vehicle.', {
        { name="Vehicle", help="Spawn code for the vehicle" }
    })
end

for k,v in pairs(Config.Commands['UpdateDonatorLockLimit']) do
	TriggerEvent('chat:addSuggestion', v, 'Update vehicle access limit.', {
        { name="Vehicle", help="Spawn code for the vehicle" },
        { name="Limit", help="How many people they can give access to the vehicle" }
    })
end

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