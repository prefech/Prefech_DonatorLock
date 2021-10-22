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

for k,v in pairs(Config.Commands['GiveDonatorKeys']) do
	RegisterCommand(v, function(source, args, rawCommand)
		GiveDonatorKeys(source, args, rawCommand)
	end)
end

for k,v in pairs(Config.Commands['RemoveDonatorKeys']) do
	RegisterCommand(v, function(source, args, rawCommand)
		RemoveDonatorKeys(source, args, rawCommand)
	end)
end

for k,v in pairs(Config.Commands['AddDonatorLock']) do
	RegisterCommand(v, function(source, args, rawCommand)
		if IsPlayerAceAllowed(source, Config.AcePerm) then
			addDonatorLock(source, args, rawCommand)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['AccessDenied']} })
		end
	end)
end

for k,v in pairs(Config.Commands['RemoveDonatorLock']) do
	RegisterCommand(v, function(source, args, rawCommand)
		if IsPlayerAceAllowed(source, Config.AcePerm) then
			removeDonatorLock(source, args, rawCommand)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['AccessDenied']} })
		end
	end)
end

for k,v in pairs(Config.Commands['UpdateDonatorLockLimit']) do
	RegisterCommand(v, function(source, args, rawCommand)
		if IsPlayerAceAllowed(source, Config.AcePerm) then
			setDonatorLockLimit(source, args, rawCommand)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['AccessDenied']} })
		end
	end)
end

function GiveDonatorKeys(source, args, rawCommand)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "vehicles.json")
	local loadedFile = json.decode(loadFile)
	local owner = ExtractIdentifiers(source)
	local steamId = ExtractIdentifiers(args[2])
	if loadedFile[args[1]] then
		if loadedFile[args[1]].Owner == owner then
			if tablelength(loadedFile[args[1]].Allowed) < loadedFile[args[1]].Limit then
				if has_value(loadedFile[args[1]].Allowed, steamId) then
					TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['HasAccess']} })
				else
					table.insert(loadedFile[args[1]].Allowed, steamId)
					TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", string.gsub(Config.Messages['KeysGiven'], "{{TargetName}}", GetPlayerName(args[2]))} })	
					if Config.JD_logs['Enabled'] then
						exports.JD_logs:discord("**"..GetPlayerName(source).."** gave keys for a `"..args[1].."` to **"..GetPlayerName(args[2]).."**", source, args[2], Config.JD_logs['Color'], Config.JD_logs['Channel'])
					end
				end
			else
				TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['MaxLimit']} })	
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['NotOwner']} })	
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['NotLocked']} })	
	end
	SaveResourceFile(GetCurrentResourceName(), "vehicles.json", json.encode(loadedFile), -1)
end

function RemoveDonatorKeys(source, args, rawCommand)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "vehicles.json")
	local loadedFile = json.decode(loadFile)
	local owner = ExtractIdentifiers(source)
	local steamId = ExtractIdentifiers(args[2])
	if loadedFile[args[1]] then
		if loadedFile[args[1]].Owner == owner then
			if not has_value(loadedFile[args[1]].Allowed, steamId) then
				TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['HasNoAccess']} })	
			else
				removebyKey(loadedFile[args[1]].Allowed, steamId)
				TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", string.gsub(Config.Messages['KeysTaken'], "{{TargetName}}", GetPlayerName(args[2]))} })
				if Config.JD_logs['Enabled'] then
					exports.JD_logs:discord("**"..GetPlayerName(source).."** removed keys for a `"..args[1].."` from **"..GetPlayerName(args[2]).."**", source, args[2], Config.JD_logs['Color'], Config.JD_logs['Channel'])
				end	
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['NotOwner']} })	
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['NotLocked']} })	
	end
	SaveResourceFile(GetCurrentResourceName(), "vehicles.json", json.encode(loadedFile), -1)
end

function addDonatorLock(source, args, rawCommand)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "vehicles.json")
	local loadedFile = json.decode(loadFile)
	local owner = ExtractIdentifiers(args[2])
	if not loadedFile[args[1]] then
		newCar = {}
		newCar['Owner'] = owner
		newCar['Allowed'] = {}
		newCar['Limit'] = tonumber(args[3])
		loadedFile[args[1]] = newCar
		TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['SuccessLocked']} })
		if Config.JD_logs['Enabled'] then
			exports.JD_logs:discord("**"..GetPlayerName(source).."** added a lock to `"..args[1].."` with a limit of: "..args[3], source, 0, Config.JD_logs['Color'], Config.JD_logs['Channel'])
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['VehicleLocked']} })
	end
	SaveResourceFile(GetCurrentResourceName(), "vehicles.json", json.encode(loadedFile), -1)
end

function removeDonatorLock(source, args, rawCommand)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "vehicles.json")
	local loadedFile = json.decode(loadFile)
	if loadedFile[args[1]] then
		loadedFile[args[1]] = nil
		TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['SuccessUnLocked']} })
		if Config.JD_logs['Enabled'] then
			exports.JD_logs:discord("**"..GetPlayerName(source).."** removed a lock from `"..args[1].."`", source, 0, Config.JD_logs['Color'], Config.JD_logs['Channel'])
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['NotLocked']} })
	end
	SaveResourceFile(GetCurrentResourceName(), "vehicles.json", json.encode(loadedFile), -1)
end

function setDonatorLockLimit(source, args, rawCommand)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "vehicles.json")
	local loadedFile = json.decode(loadFile)
	local owner = ExtractIdentifiers(source)
	if loadedFile[args[1]] then
		updateCar = {}
		updateCar['Owner'] = loadedFile[args[1]].Owner
		updateCar['Allowed'] = loadedFile[args[1]].Allowed
	  	updateCar['Limit'] = tonumber(args[2])
		loadedFile[args[1]] = updateCar
		TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['LimitUpdated']} })
		if Config.JD_logs['Enabled'] then
			exports.JD_logs:discord("**"..GetPlayerName(source).."** updated the limit for `"..args[1].."` to: "..args[2], source, 0, Config.JD_logs['Color'], Config.JD_logs['Channel'])
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"Prefech", Config.Messages['NotLocked']} })
	end
	SaveResourceFile(GetCurrentResourceName(), "vehicles.json", json.encode(loadedFile), -1)
end


RegisterNetEvent("Prefech:checkAccess")
AddEventHandler("Prefech:checkAccess", function(veh)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "vehicles.json")
	local loadedFile = json.decode(loadFile)
	local user = ExtractIdentifiers(source)
	if loadedFile[veh] then
		if has_value(loadedFile[veh].Allowed, user) then
			TriggerClientEvent("Prefech:updateAccess", source, true)
		else
			if loadedFile[veh].Owner == user then
				TriggerClientEvent("Prefech:updateAccess", source, true)
			else
				TriggerClientEvent("Prefech:updateAccess", source, false)
			end
		end
	else
		TriggerClientEvent("Prefech:updateAccess", source, true)
	end
end)


function ExtractIdentifiers(src)
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
           return id
		end
    end
	return nil
end

function has_value (tab, val)
    for i, v in ipairs (tab) do
        if (v == val) then
            return true
        end
    end
    return false
end

function removebyKey(tab, val)
    for i, v in ipairs (tab) do 
        if (v == val) then
          tab[i] = nil
        end
    end
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
  end

-- version check
Citizen.CreateThread(
	function()
		local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
		if vRaw and Config.versionCheck then
			local v = json.decode(vRaw)
			PerformHttpRequest(
				'https://raw.githubusercontent.com/Prefech/Prefech_DonatorLock/master/version.json',
				function(code, res, headers)
					if code == 200 then
						local rv = json.decode(res)
						if rv.version ~= v.version then
							print(
								([[^1-------------------------------------------------------
^1Prefech_DonatorLock
^1UPDATE: %s AVAILABLE
^1CHANGELOG: %s
^1-------------------------------------------------------^0]]):format(
									rv.version,
									rv.changelog
								)
							)
						end
					else
						print('^1Prefech_DonatorLock unable to check version^0')
					end
				end,
				'GET'
			)
		end
	end
)