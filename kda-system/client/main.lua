local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local currentKills = 0
local currentDeaths = 0

CreateThread(function()
    while not QBCore do
        Wait(100)
    end
    
    PlayerData = QBCore.Functions.GetPlayerData()
    
    while not PlayerData.citizenid do
        PlayerData = QBCore.Functions.GetPlayerData()
        Wait(100)
    end
    
    QBCore.Functions.TriggerCallback('kda:getStats', function(stats)
        if stats then
            currentKills = stats.kills
            currentDeaths = stats.deaths
            updateKDAUI(currentKills, currentDeaths)
        end
    end)
end)

function updateKDAUI(kills, deaths)
    SendNUIMessage({
        type = 'updateStats',
        kills = kills,
        deaths = deaths
    })
end

RegisterNetEvent('kda:receiveStats', function(kills, deaths)
    currentKills = kills
    currentDeaths = deaths
    updateKDAUI(kills, deaths)
end)

RegisterNetEvent('kda:updateStats', function(citizenid, kills, deaths)
    if PlayerData.citizenid == citizenid then
        currentKills = kills
        currentDeaths = deaths
        updateKDAUI(kills, deaths)
    end
end)

CreateThread(function()
    local isDead = false
    
    while true do
        Wait(500)
        local playerPed = PlayerPedId()
        
        if IsEntityDead(playerPed) and not isDead then
            isDead = true
            TriggerServerEvent('kda:playerDied')
        elseif not IsEntityDead(playerPed) and isDead then
            isDead = false
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        
        if IsPedShooting(playerPed) then
            local coords = GetEntityCoords(playerPed)
            local radius = 50.0
            
            local deadPlayers = GetActivePlayers()
            for _, playerId in pairs(deadPlayers) do
                if playerId ~= PlayerId() then
                    local targetPed = GetPlayerPed(playerId)
                    
                    if IsPedAPlayer(targetPed) and IsEntityDead(targetPed) then
                        local targetCoords = GetEntityCoords(targetPed)
                        local distance = #(coords - targetCoords)
                        
                        if distance <= radius then
                            local timeSinceDeath = GetGameTimer() - GetPlayerLastDamageBone(targetPed)
                            if timeSinceDeath < 5000 then
                                if targetPed ~= playerPed then
                                    TriggerServerEvent('kda:playerKilled')
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

exports('GetCurrentKDA', function()
    return {
        kills = currentKills,
        deaths = currentDeaths
    }
end) 