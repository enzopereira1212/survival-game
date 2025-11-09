-- SERVICES
local ProximityPromptService = game:GetService("ProximityPromptService")

-- CONSTANT
local PROXIMITY_ACTION = "Mining"
local PICKAXE_SOUND_ID = 'rbxassetid://7650226201'
-- MEMBERS
local PlayerModule = require(game.ServerStorage.Modules.PlayerModule)
local PlayerInventoryUpdated: RemoteEvent = game.ReplicatedStorage.Network.PlayerInventoryUpdated
local animation = Instance.new('Animation')
animation.AnimationId = 'rbxassetid://94668946861149'



local isPressing = false

local function playPickaxeSound()
    local pickaxeSound = Instance.new('Sound', game:GetService('Workspace'))
    pickaxeSound.SoundId = PICKAXE_SOUND_ID
    local random = Random.new()
    local value = random:NextNumber(0.9, 1)

    pickaxeSound.Pitch = value
    pickaxeSound.Parent = workspace
    pickaxeSound:Play()
    
end

-- detect when promp is triggered
local function onPrompTriggered(promptObject: ProximityPrompt, player)
	-- Check if prompt triggered is an Eat action
	if promptObject.Name ~= PROXIMITY_ACTION then
		return
	end

	local miningModel = promptObject.Parent
    local miningValue = miningModel:FindFirstChildWhichIsA('NumberValue')

    PlayerModule.AddToInventory(player, miningValue.Name, miningValue.value)
    PlayerInventoryUpdated:FireClient(player, PlayerModule.GetInventory(player))
    
    miningModel:Destroy()
end

-- Detect when prompt hold begins
local function onPrompHoldBegan(promptObject, player)
	-- Check if prompt triggered is an Eat action
	if promptObject.Name ~= PROXIMITY_ACTION then
		return
	end
    
    isPressing = true

    local character = player.character
    local humanoid = character.Humanoid

    local humanoidAnimator:Animator = humanoid.Animator
    local animationTrack:AnimationTrack = humanoidAnimator:LoadAnimation(animation)

    while isPressing do
        animationTrack:Play()
        playPickaxeSound()
        wait(1)
    end

end

-- Detect when prompt hold ends
local function onPrompHoldEnded(promptObject, player)
    -- Check if prompt triggered is an Eat action
	if promptObject.Name ~= PROXIMITY_ACTION then
		return
	end
    isPressing = false
end

-- Connect prompt events to handling functions
ProximityPromptService.PromptTriggered:Connect(onPrompTriggered)
ProximityPromptService.PromptButtonHoldBegan:Connect(onPrompHoldBegan)
ProximityPromptService.PromptButtonHoldEnded:Connect(onPrompHoldEnded)