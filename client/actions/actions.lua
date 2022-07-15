local canDoAnyAction = false

local isBillingEnabled = false
local canRob = false
local canHandcuff = false
local canLockpickCars = false
local canWashVehicles = false
local canRepairVehicles = false
local canImpoundVehicles = false
local canCheckIdentity = false
local canCheckVehicleOwner = false


local function checkAllowedActions(cb)
    ESX.TriggerServerCallback('wcuk_job_creator:checkAllowedActions', function(data)
        for action, enabled in pairs(data) do
            if(enabled) then
                canDoAnyAction = true
                break
            end
        end

        isBillingEnabled = data.enableBilling
        canRob = data.canRob
        canHandcuff = data.canHandcuff
        canLockpickCars = data.canLockpickCars
        canWashVehicles = data.canWashVehicles
        canRepairVehicles = data.canRepairVehicles
        canImpoundVehicles = data.canImpoundVehicles
        canCheckIdentity = data.canCheckIdentity
        canCheckVehicleOwner = data.canCheckVehicleOwner

        if(cb) then
            cb(data)
        end
    end)
end

function getClosestPlayerId(maxDistance)
    maxDistance = maxDistance or 2.0

    local closestPlayerId, closestDistance = ESX.Game.GetClosestPlayer()

    if(closestPlayerId ~= -1 and closestDistance and closestDistance < maxDistance) then
        return closestPlayerId
    else
        return false
    end
end

function getClosestPed(maxDistance)
    maxDistance = maxDistance or 2.0

    local closestPlayer, closestDistance = ESX.Game.GetClosestPed()

    if(closestPlayer ~= -1 and closestDistance and closestDistance < maxDistance) then
        return closestPlayer
    else
        return false
    end
end

local function openActionsMenu()
    if(canDoAnyAction and (config.canUseActionsMenuWhileOffDuty or isOnDuty)) then
        local elements = {}

        if(isBillingEnabled) then
            table.insert(elements, {label = getLocalizedText('actions_billing'), value = "billing"})
        end

        if(canRob) then
            table.insert(elements, {label = getLocalizedText('actions_search'), value = "search"})
        end

        if(canHandcuff) then
            table.insert(elements, {label = getLocalizedText('actions_put_handcuffs'), value = "handcuff"})
            table.insert(elements, {label = getLocalizedText('actions_start_dragging'), value = "drag"})
            table.insert(elements, {label = getLocalizedText('actions_put_in_car'), value = "putincar"})
            table.insert(elements, {label = getLocalizedText('actions_take_from_car'), value = "takefromcar"})
        end

        if(canLockpickCars) then
            table.insert(elements, {label = getLocalizedText('actions_lockpick_car'), value = "lockpickcar"})
        end

        if(canWashVehicles) then
            table.insert(elements, {label = getLocalizedText('actions:wash_vehicle'), value = "washvehicle"})
        end
        
        if(canRepairVehicles) then
            table.insert(elements, {label = getLocalizedText('actions:repair_vehicle'), value = "repairvehicle"})
        end

        if(canImpoundVehicles) then
            table.insert(elements, {label = getLocalizedText('actions:impound_vehicle'), value = "impoundvehicle"})
        end

        if(canCheckIdentity) then
            table.insert(elements, {label = getLocalizedText('actions:check_identity'), value = "checkidentity"})
        end

        if(canCheckVehicleOwner) then
            table.insert(elements, {label = getLocalizedText('actions:check_vehicle_owner'), value = "checkvehicleowner"})
        end

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions_menu', {
            title = getLocalizedText('actions_menu'),
            align = 'bottom-right',
            elements = elements
        }, 
        function(data, menu) 
            local action = data.current.value

            if(action == "billing") then
                TriggerEvent('wcuk_job_creator:actions:createBilling')
            elseif(action == "search") then
                TriggerEvent('wcuk_job_creator:actions:search')
            elseif(action == "handcuff") then
                TriggerEvent('wcuk_job_creator:actions:handcuff')
            elseif(action == "drag") then
                TriggerEvent('wcuk_job_creator:actions:drag')
            elseif(action == "putincar") then
                TriggerEvent('wcuk_job_creator:actions:putInCar')
            elseif(action == "takefromcar") then
                TriggerEvent('wcuk_job_creator:actions:takeFromCar')
            elseif(action == "lockpickcar") then
                TriggerEvent('wcuk_job_creator:actions:lockpickCar')
            elseif(action == "washvehicle") then
                TriggerEvent('wcuk_job_creator:actions:washVehicle')
            elseif(action == "repairvehicle") then
                TriggerEvent('wcuk_job_creator:actions:repairVehicle')
            elseif(action == "impoundvehicle") then
                TriggerEvent('wcuk_job_creator:actions:impoundVehicle')
            elseif(action == "checkidentity") then
                TriggerEvent('wcuk_job_creator:actions:checkIdentity')
            elseif(action == "checkvehicleowner") then
                TriggerEvent('wcuk_job_creator:actions:checkVehicleOwner')
            end
        end,
        function(data, menu)
            menu.close()
        end
        )
    end
end

RegisterCommand('_jobcreator_openactionsmenu', openActionsMenu, false)
RegisterNetEvent('wcuk_job_creator:openActionsMenu', openActionsMenu)

Citizen.CreateThread(function() 
    Citizen.Wait(2000)

    local message = getLocalizedText('open_actions_menu') or "Open actions menu"

    RegisterKeyMapping('_jobcreator_openactionsmenu', message, 'keyboard', "f6")
end)

-- Reload allowed actions
RegisterNetEvent('esx:playerLoaded', function() 
    checkAllowedActions()
end)

RegisterNetEvent('esx:setJob', function() 
    checkAllowedActions()
end)

RegisterNetEvent('wcuk_job_creator:esx:ready', checkAllowedActions)

-- To refresh manually the allowed actions
RegisterNetEvent('wcuk_job_creator:checkAllowedActions', checkAllowedActions)

-- Retrieve player allowed actions from anywhere
RegisterNetEvent('wcuk_job_creator:getAllowedActions', checkAllowedActions)