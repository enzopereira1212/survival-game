-- Script: GamepassSetup (ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Criar/Atualizar pasta Gamepasses
local GamepassesFolder = ReplicatedStorage:FindFirstChild("Gamepasses")
if not GamepassesFolder then
    GamepassesFolder = Instance.new("Folder")
    GamepassesFolder.Name = "Gamepasses"
    GamepassesFolder.Parent = ReplicatedStorage
end

-- REMOVER GAMEPASSES ANTIGAS
for _, oldGamepass in GamepassesFolder:GetChildren() do
    oldGamepass:Destroy()
end

-- CRIAR NOVAS GAMEPASSES
local newGamepasses = {
    DoubleResources = 1578102656,  -- SUBSTITUA pelo ID real da sua gamepass 2x Resources
    BonusResources = 1577795328    -- SUBSTITUA pelo ID real da sua gamepass Bonus Resources
}

for gamepassName, gamepassId in pairs(newGamepasses) do
    local gamepass = Instance.new("IntValue")
    gamepass.Name = gamepassName
    gamepass.Value = gamepassId
    gamepass.Parent = GamepassesFolder
    print("✅ Gamepass criada: " .. gamepassName .. " (ID: " .. gamepassId .. ")")
end

print("🎮 Gamepasses atualizadas! Reinicie o jogo para ver as mudanças.")