print("^1pc-businessmenudisplay by Procastinator V.1.0^7")

QBCore = exports["qb-core"]:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
    PlayerData = {}
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    PlayerData = QBCore.Functions.GetPlayerData()

    -- Once the player is loaded, show the HUD
    SendNUIMessage({
        action = "playerLoggedIn",
    })

    -- Send player data to the NUI
    SendNUIMessage({
        wallet = " " .. PlayerData.money['cash'],
        bank = " " .. PlayerData.money['bank'],
        id = " " .. GetPlayerServerId(PlayerId()),
        job = " " .. PlayerData.job.label,
    })
end)

Citizen.CreateThread(function()
    local wasPauseMenuActive = false

    while true do
        Citizen.Wait(500) -- Check every 500ms
        local isPauseMenuActive = IsPauseMenuActive()

        if isPauseMenuActive and not wasPauseMenuActive then
            SendNUIMessage({ action = "hideHUD" }) -- Hide the HUD
            wasPauseMenuActive = true
        elseif not isPauseMenuActive and wasPauseMenuActive then
            SendNUIMessage({ action = "showHUD" }) -- Show the HUD
            wasPauseMenuActive = false
        end
    end
end)

local ped, pid, Player, playerId

Citizen.CreateThread(function()
    while true do 
        Wait(500)
        if LocalPlayer.state.isLoggedIn then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                ped = PlayerPedId()
                pid = GetPlayerServerId(PlayerId())
                Player = QBCore.Functions.GetPlayerData()
                playerId = PlayerId()

                -- Send updated player data to NUI
                SendNUIMessage({
                    wallet = " " .. Player.money['cash'],
                    bank = " " .. Player.money['bank'],
                    id = " " .. GetPlayerServerId(playerId),
                    job = PlayerData["job"].label,
                    job_grade = PlayerData["job"].grade.name,
                })
            end)
        end
        Wait(500)
    end
end)
