local PlayerInventoryUpdated:RemoteEvent = game.ReplicatedStorage.Network.PlayerInventoryUpdated

-- SERVICES
local Players = game:GetService('Players')

--- CONSTANTS


-- MEMBERS
local PlayerGui = Players.LocalPlayer:WaitForChild('PlayerGui')
local hud:ScreenGui = PlayerGui:WaitForChild('HUD')
local leftBar:Frame = hud:WaitForChild('LeftBar')
local inventoryUi:Frame = leftBar:WaitForChild('Inventory')
local InventoryButton:ImageButton = inventoryUi:WaitForChild('Button')

local inventoryWindow:Frame = hud:WaitForChild('Inventory')
local inventoryWindowOriginalPosition = inventoryWindow.Position.X.Scale
inventoryWindow.Position = UDim2.fromScale(-1, inventoryWindow.Position.Y.Scale)

local stoneNumberLabel:TextLabel = inventoryWindow.Stone.Number
local WoodNumberLabel:TextLabel = inventoryWindow.Wood.Number
local CopperNumberLabel:TextLabel = inventoryWindow.Copper.Number

inventoryUi.MouseEnter:Connect(function()
   -- print('Mouse Enter')
    --inventoryWindow.Visible = true
end)

inventoryUi.MouseLeave:Connect(function()
   -- print('Mouse Leave')
       -- inventoryWindow.Visible = false
end)

InventoryButton.MouseButton1Click:Connect(function()

     inventoryWindow.Visible = not inventoryWindow.Visible

    if inventoryWindow.Visible then
        inventoryWindow:TweenPosition(UDim2.fromScale(inventoryWindowOriginalPosition, inventoryWindow.Position.Y.Scale), Enum.EasingDirection.Out, Enum.EasingStyle.Quint)
    else
        inventoryWindow.Position = UDim2.fromScale(-1, inventoryWindow.Position.Y.Scale)
    end
end)

PlayerInventoryUpdated.OnClientEvent:Connect(function(Inventory: table)
    stoneNumberLabel.Text = Inventory.Stone and Inventory.Stone or 0
    WoodNumberLabel.Text = Inventory.Wood and Inventory.Wood or 0
    CopperNumberLabel.Text = Inventory.Copper and Inventory.Copper or 0
end)