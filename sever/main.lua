ESX = nil

format = string.format

local function setupESX()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end

RegistterNetEvent('wcuk_job_creator:refresh_esx_jobs')
AddEventHandler('wcuk_job_creator:refresh_esx_jobs' , function() 
    if(isAllowed(source)) then
        TriggerEvent('esx:refreshJobs')
    end
end)

RegisterNetEvent('wcuk_job_creator:esx:ready' , function() 
    getAllMarkers()

	registerSocieties()

	-- Retrieves all data from external tables
	getAllArmoryData()
	getAllGaragesData()
	getAllShopsData()
	getAllWardrobesData()
end)

RegisterCommand("jobcreator", function(playerId)
	if(isAllowed(playerId)) then
		TriggerClientEvent('wcuk_job_creator:openMenu', playerId)
	else 
		local identifier = GetPlayerIdentifiers(playerId)

		local steamId = nil
		local rockstarLicense = nil
	
		for k, identifier in pairs(identifier) do
			if string.sub(identifier, 1, string.len("steam:")) == "steam:" then
				steamId = identifier
			elseif string.sub(identifier, 1, string.len("license:")) == "license:" then
				rockstarLicense = identifier
			end
		end
		TriggerClientEvent('wcuk_job_creator:notAllowed', playerid, config.acePermission, steamId, rockstarLicense)
	end
end, false)