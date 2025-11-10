-- Script com DataStore (ServerScriptService)
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local GamepassDataStore = DataStoreService:GetDataStore("GamepassData")

local function LoadPlayerData(player)
	local success, data = pcall(function()
		return GamepassDataStore:GetAsync("Player_" .. player.UserId)
	end)
	
	local gamepasses = data or {
		TripleEgg = false,
		AutoEgg = false
		-- Adicione outros gamepasses aqui
	}
	
	-- Criar estrutura de pastas
	local dataFolder = Instance.new("Folder")
	dataFolder.Name = "Data"
	dataFolder.Parent = player
	
	local gamepassesFolder = Instance.new("Folder")
	gamepassesFolder.Name = "Gamepasses"
	gamepassesFolder.Parent = dataFolder
	
	-- Criar BoolValues baseado nos dados
	for gamepassName, owned in pairs(gamepasses) do
		local boolValue = Instance.new("BoolValue")
		boolValue.Name = gamepassName
		boolValue.Value = owned
		boolValue.Parent = gamepassesFolder
	end
	
	return gamepasses
end

local function SavePlayerData(player)
	if not player:FindFirstChild("Data") then return end
	
	local gamepasses = {}
	for _, gamepass in pairs(player.Data.Gamepasses:GetChildren()) do
		if gamepass:IsA("BoolValue") then
			gamepasses[gamepass.Name] = gamepass.Value
		end
	end
	
	pcall(function()
		GamepassDataStore:SetAsync("Player_" .. player.UserId, gamepasses)
	end)
end

-- Setup quando jogador entrar
Players.PlayerAdded:Connect(function(player)
	LoadPlayerData(player)
end)

-- Salvar quando jogador sair
Players.PlayerRemoving:Connect(function(player)
	SavePlayerData(player)
end)