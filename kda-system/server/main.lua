local QBCore = exports['qb-core']:GetCoreObject()

local function GetPlayerKDA(citizenid)
    local result = MySQL.query.await('SELECT * FROM kda_stats WHERE citizenid = ?', {citizenid})
    if result and result[1] then
        return result[1]
    else
        MySQL.insert('INSERT INTO kda_stats (citizenid, kills, deaths, kda_ratio) VALUES (?, 0, 0, 0.00)', {citizenid})
        return {
            citizenid = citizenid,
            kills = 0,
            deaths = 0,
            kda_ratio = 0.00
        }
    end
end

local function UpdatePlayerKDA(citizenid, kills, deaths)
    local kda_ratio = 0.00
    if deaths > 0 then
        kda_ratio = kills / deaths
    elseif kills > 0 then
        kda_ratio = kills
    end
    
    MySQL.update('UPDATE kda_stats SET kills = ?, deaths = ?, kda_ratio = ? WHERE citizenid = ?', {
        kills, deaths, kda_ratio, citizenid
    })
    
    return kda_ratio
end

local function AddKill(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local playerPed = GetPlayerPed(source)
    if not playerPed or IsEntityDead(playerPed) then
        return
    end
    
    local citizenid = Player.PlayerData.citizenid
    local stats = GetPlayerKDA(citizenid)
    
    stats.kills = stats.kills + 1
    local newKDA = UpdatePlayerKDA(citizenid, stats.kills, stats.deaths)
    
    TriggerClientEvent('kda:updateStats', -1, citizenid, stats.kills, stats.deaths)
end

local function AddDeath(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    local stats = GetPlayerKDA(citizenid)
    
    stats.deaths = stats.deaths + 1
    local newKDA = UpdatePlayerKDA(citizenid, stats.kills, stats.deaths)
    
    TriggerClientEvent('kda:updateStats', -1, citizenid, stats.kills, stats.deaths)
end

QBCore.Functions.CreateCallback('kda:getStats', function(source, cb, targetId)
    local Player = QBCore.Functions.GetPlayer(targetId or source)
    if not Player then 
        cb(nil)
        return
    end
    
    local citizenid = Player.PlayerData.citizenid
    local stats = GetPlayerKDA(citizenid)
    cb(stats)
end)

RegisterNetEvent('kda:playerDied', function()
    AddDeath(source)
end)

RegisterNetEvent('kda:playerKilled', function()
    AddKill(source)
end)

RegisterNetEvent('QBCore:Server:PlayerLoaded', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    local stats = GetPlayerKDA(citizenid)
    
    TriggerClientEvent('kda:receiveStats', source, stats.kills, stats.deaths)
end)

exports('GetPlayerKDA', GetPlayerKDA)
exports('AddKill', AddKill)
exports('AddDeath', AddDeath)
exports('UpdatePlayerKDA', UpdatePlayerKDA) 