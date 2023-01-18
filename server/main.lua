local QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent("serrulata:server:money", function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = (math.random(Config.MinMoney, Config.MaxMoney))
    Player.Functions.AddMoney("cash", (amount))
end)