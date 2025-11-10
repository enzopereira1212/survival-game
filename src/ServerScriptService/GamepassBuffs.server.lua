-- Script para aplicar os buffs das gamepasses (ServerScriptService)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GamepassBuffs = {}

-- CONFIGURAÇÃO DOS BUFFS
GamepassBuffs.DoubleResources = {
    Type = "ResourceMultiplier",
    ApplyBuff = function(player)
        -- Aqui você aplica o multiplicador de recursos
        local playerData = player:FindFirstChild("Data")
        if playerData then
            -- Exemplo: dobrar recursos minerados
            print("🎯 2x Resources aplicado para: " .. player.Name)
            -- Sua lógica de multiplicação de recursos aqui
        end
    end,
    RemoveBuff = function(player)
        print("❌ 2x Resources removido de: " .. player.Name)
        -- Remover o multiplicador
    end
}

GamepassBuffs.BonusResources = {
    Type = "PurchaseBonus", 
    ApplyBuff = function(player)
        -- 50% mais recursos em compras
        print("🎯 +50% Bonus Resources aplicado para: " .. player.Name)
        -- Sua lógica de bônus em compras aqui
    end,
    RemoveBuff = function(player)
        print("❌ Bonus Resources removido de: " .. player.Name)
    end
}

-- VERIFICAR E APLICAR BUFFS QUANDO JOGADOR ENTRA
Players.PlayerAdded:Connect(function(player)
    -- Esperar dados carregarem
    player:WaitForChild("Data")
    
    local gamepassesFolder = player.Data:FindFirstChild("Gamepasses")
    if gamepassesFolder then
        for _, gamepass in pairs(gamepassesFolder:GetChildren()) do
            if gamepass:IsA("BoolValue") and gamepass.Value == true then
                local buff = GamepassBuffs[gamepass.Name]
                if buff then
                    buff.ApplyBuff(player)
                end
            end
        end
    end
end)

-- MONITORAR COMPRAS DE GAMEPASS
local function OnGamepassPurchased(player, gamepassName)
    local buff = GamepassBuffs[gamepassName]
    if buff then
        buff.ApplyBuff(player)
        print("🎁 Buff aplicado: " .. gamepassName .. " para " .. player.Name)
    end
end

-- Conectar com seu sistema de compras
-- Exemplo: Remotes.GamepassPurchased.OnServerEvent:Connect(OnGamepassPurchased)

print("✅ Sistema de buffs de gamepass carregado!")