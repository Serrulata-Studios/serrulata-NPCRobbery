local QBCore = exports['qb-core']:GetCoreObject()

local cooldown = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if IsControlJustPressed(0, 38) or NetworkIsPlayerTalking(PlayerId(-1)) then
            local aiming, Ped = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))

            if aiming then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                  PlayerJob = PlayerData.job
                    if PlayerData.job.name ~= "police" then
                        local playerPed = GetPlayerPed(-1)
                        local pCoords = GetEntityCoords(playerPed, true)
                        local tCoords = GetEntityCoords(Ped, true)

                        if DoesEntityExist(Ped) and IsPedHuman(Ped) then
                            if cooldown then
                                QBCore.Functions.Notify("They seem to have no Money")
                            elseif IsPedDeadOrDying(Ped, true) then
                                QBCore.Functions.Notify("You trying to rob a dead person? Where is your morals")
                            elseif GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) >= Config.RobDistance then
                                QBCore.Functions.Notify("You are to far away, they are not scared enough")
                            else
                                rob(Ped)
                            end
                        end               
                    else 
                    end
                end)
            end
        end
    end
end)

function rob(Ped)
    cooldown = true
    CreateThread(function()
        local dict = 'random@mugging3'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end
        DispatchCalled()
        TaskStandStill(Ped, 9000)
        FreezeEntityPosition(Ped, true)
        TaskHandsUp(Ped , 9000, -1)
        TaskPlayAnim(Ped, dict, 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)
        TaskStandStill(Ped, 9000)
        QBCore.Functions.Progressbar("Robbing", "Empty your pockets!", 9000, false, true, {
            disableMovement = false,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = false,
        }, {
        }, {}, {}, function() -- Done
        end)
        TaskPlayAnim(Ped, 'amb@world_human_bum_standing@depressed@idle_a', 'idle_a', 8.0, -8, .01, 10, 0, 0, 0, 0)
        Wait(9000)
        FreezeEntityPosition(Ped, false)
        TriggerServerEvent('serrulata:server:money', amount)
    end)
    if Config.Cooldown then
        Wait(math.random(Config.Min, Config.Max) * 1000)
    end
    cooldown = false
end

function DispatchCalled()
    if Config.Dispatch == 'cd_dispatch' then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'}, 
            coords = data.coords,
            title = '10-15 - Mugging',
            message = 'A '..data.sex..' robbing a citizen at '..data.street, 
            flash = 0,
            unique_id = tostring(math.random(0000000,9999999)),
            blip = {
                sprite = 156, 
                scale = 1.2, 
                colour = 1,
                flashes = false, 
                text = '911 - Mugging In Progress',
                time = (5*60*1000),
                sound = 1,
            }
        })
    elseif Config.Dispatch == 'ps-dispatch' then
        exports["ps-dispatch"]:CustomAlert({
            coords = vector3(0.0, 0.0, 0.0),
            message = "911 - Mugging In Progress",
            dispatchCode = "10-15 Mugging",
            description = "Mugging In Progress",
            gender = true,
            radius = 0,
            sprite = 156,
            color = 1,
            scale = 1.2,
            length = 3,
        })
    end
end
