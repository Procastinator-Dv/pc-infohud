print("^1pc-businessmenudisplay by Procastinator V.1.0^7")

local Framework = nil
local PlayerData = {}

Citizen.CreateThread(function()
    -- Wait for the framework to be initialized
    while Framework == nil do
        if GetResourceState('qb-core') == 'started' then
            Framework = 'qb-core'
            QBCore = exports['qb-core']:GetCoreObject()
            PlayerData = QBCore.Functions.GetPlayerData()
        elseif GetResourceState('es_extended') == 'started' then
            Framework = 'esx'
            ESX = exports['es_extended']:getSharedObject()
            while ESX.GetPlayerData().job == nil do
                Citizen.Wait(10)
            end
            PlayerData = ESX.GetPlayerData()
        end
        Citizen.Wait(100)
    end
end)

-- Unload and Load events
if Framework == 'qb-core' then
    RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
        PlayerData = {}
    end)

    RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
    AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
        PlayerData = QBCore.Functions.GetPlayerData()
        sendHUD()
    end)
elseif Framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
        sendHUD()
    end)

    RegisterNetEvent('esx:onPlayerLogout')
    AddEventHandler('esx:onPlayerLogout', function()
        PlayerData = {}
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        PlayerData.job = job
    end)
end

-- Pause menu HUD hide/show
Citizen.CreateThread(function()
    local wasPauseMenuActive = false
    while true do
        Citizen.Wait(500)
        local isPauseMenuActive = IsPauseMenuActive()
        if isPauseMenuActive and not wasPauseMenuActive then
            SendNUIMessage({ action = "hideHUD" })
            wasPauseMenuActive = true
        elseif not isPauseMenuActive and wasPauseMenuActive then
            SendNUIMessage({ action = "showHUD" })
            wasPauseMenuActive = false
        end
    end
end)

-- Function to send HUD data to NUI
function sendHUD()
    if not PlayerData or not PlayerData.job then return end

    local cash = Framework == 'qb-core' and PlayerData.money['cash'] or PlayerData.accounts and getAccount('money') or 0
    local bank = Framework == 'qb-core' and PlayerData.money['bank'] or PlayerData.accounts and getAccount('bank') or 0
    local job = PlayerData.job.label
    local job_grade = PlayerData.job.grade_name or (PlayerData.job.grade and PlayerData.job.grade.name)

    SendNUIMessage({
        action = "playerLoggedIn",
        wallet = " " .. cash,
        bank = " " .. bank,
        id = " " .. GetPlayerServerId(PlayerId()),
        job = " " .. job,
        job_grade = job_grade or "",
    })
end

-- Helper for ESX accounts
function getAccount(name)
    for _, acc in pairs(PlayerData.accounts or {}) do
        if acc.name == name then
            return acc.money or 0
        end
    end
    return 0
end

-- Continuous updates
Citizen.CreateThread(function()
    while true do 
        Wait(1000)
        if Framework == 'qb-core' and LocalPlayer.state.isLoggedIn then
            PlayerData = QBCore.Functions.GetPlayerData()
            sendHUD()
        elseif Framework == 'esx' and ESX then
            PlayerData = ESX.GetPlayerData()
            sendHUD()
        end
    end
end)
