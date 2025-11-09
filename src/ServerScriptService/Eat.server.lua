-- SERVICES
local ProximityPromptService = game:GetService('ProximityPromptService')

-- CONSTANT
local PROXIMITY_ACTION = 'Eat'
local EATING_SOUND_ID = 'rbxassetid://3043029786'

-- MEMBERS
local PlayerModule = require(game.ServerStorage.Modules.PlayerModule)
local PlayerHungerUpdated:RemoteEvent = game.ReplicatedStorage.Network.PlayerHungerUpdated

local function playEatingSound()
    local eatingSound = Instance.new('Sound', game:GetService('Workspace'))
    eatingSound.SoundId = EATING_SOUND_ID
    local random = Random.new()
    local value = random:NextNumber(0.5, 1)

    eatingSound.Pitch = value
    eatingSound.Parent = workspace
    eatingSound:Play()
    
end

-- detect when promp is triggered
local function onPrompTriggered(promptObject:ProximityPrompt, player)
    -- Check if prompt triggered is an Eat action
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end
    
    playEatingSound()

    local foodModel = promptObject.Parent
    local foodValue = foodModel.Food.Value
    
    local currentHunger = PlayerModule.GetHunger(player)
    PlayerModule.SetHunger(player, currentHunger + foodValue)
    PlayerHungerUpdated:FireClient(player, PlayerModule.GetHunger(player))

    foodModel:Destroy()
end

-- Connect prompt events to handling functions
ProximityPromptService.PromptTriggered:Connect(onPrompTriggered)