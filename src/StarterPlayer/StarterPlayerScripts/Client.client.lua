--// Services
local MarketPlaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

--// Loading
local Player = Players.LocalPlayer
local UI = Player.PlayerGui:WaitForChild("HUD")
local Frames = UI:FindFirstChild("Frames")
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

print("=== INICIANDO SISTEMA SHOP/CODES ===")

-- REMOVER O LocalScript CONFLITANTE do botão Redeem
local codesFrame = Frames:FindFirstChild("Codes")
if codesFrame then
    local redeemButton = codesFrame:FindFirstChild("Redeem")
    if redeemButton then
        local conflictScript = redeemButton:FindFirstChild("LocalScript")
        if conflictScript then
            conflictScript:Destroy()
            print("✅ LocalScript conflitante removido do Redeem")
        end
    end
end

-- INICIAR COM FRAMES FECHADOS
local shopFrame = Frames:FindFirstChild("Shop")
local codesFrame = Frames:FindFirstChild("Codes")

if shopFrame then
    shopFrame.Visible = false
    shopFrame.Active = false
    print("✅ Shop Frame configurado (inicia fechado)")
end

if codesFrame then
    codesFrame.Visible = false
    codesFrame.Active = false
    print("✅ Codes Frame configurado (inicia fechado)")
end

-- PRÉ-CARREGAR SOM DE CLICK
local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://421058925"
ClickSound.Volume = 0.5
ClickSound.Parent = SoundService
ClickSound:Play()
ClickSound:Stop()

-- VARIÁVEIS PARA CONTROLE DE TOGGLE
local currentOpenFrame = nil

-- FUNÇÃO PARA FECHAR TODOS OS FRAMES
local function CloseAllFrames()
    if shopFrame then
        shopFrame.Visible = false
        shopFrame.Active = false
    end
    if codesFrame then
        codesFrame.Visible = false
        codesFrame.Active = false
    end
    currentOpenFrame = nil
end

-- FUNÇÃO TOGGLE - ABRIR/FECHAR NO MESMO BOTÃO
local function ToggleFrame(frame, frameName)
    if currentOpenFrame == frame then
        -- Se já está aberto, fecha
        frame.Visible = false
        frame.Active = false
        currentOpenFrame = nil
        print("❌ " .. frameName .. " fechado")
    else
        -- Se está fechado, fecha outros e abre este
        CloseAllFrames()
        frame.Visible = true
        frame.Active = true
        currentOpenFrame = frame
        print("🛍️ " .. frameName .. " aberto")
    end
end

-- SISTEMA DE ANIMAÇÕES MAIS SUAVES
local function SetupSideButtonAnimation(buttonFrame)
    if not buttonFrame or not buttonFrame:IsA("Frame") then 
        return 
    end
    
    local originalSize = buttonFrame.Size
    local originalPosition = buttonFrame.Position
    
    -- Encontrar a parte clicável dentro do frame
    local clickPart = buttonFrame:FindFirstChild("Click")
    if not clickPart then
        return
    end
    
    -- ANIMAÇÃO DE HOVER - MAIS SUAVE COM Quad
    clickPart.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(buttonFrame, tweenInfo, {
            Size = UDim2.new(originalSize.X.Scale * 1.08, originalSize.X.Offset, originalSize.Y.Scale * 1.08, originalSize.Y.Offset),
            Position = UDim2.new(
                originalPosition.X.Scale - (originalSize.X.Scale * 0.04), 
                originalPosition.X.Offset,
                originalPosition.Y.Scale - (originalSize.Y.Scale * 0.04), 
                originalPosition.Y.Offset
            )
        })
        tween:Play()
    end)
    
    clickPart.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(buttonFrame, tweenInfo, {
            Size = originalSize,
            Position = originalPosition
        })
        tween:Play()
    end)
    
    -- ANIMAÇÃO DE CLIQUE MAIS SUAVE
    clickPart.MouseButton1Down:Connect(function()
        local tweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(buttonFrame, tweenInfo, {
            Size = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset, originalSize.Y.Scale * 0.95, originalSize.Y.Offset),
            Position = UDim2.new(
                originalPosition.X.Scale + (originalSize.X.Scale * 0.025), 
                originalPosition.X.Offset,
                originalPosition.Y.Scale + (originalSize.Y.Scale * 0.025), 
                originalPosition.Y.Offset
            )
        })
        tween:Play()
    end)
    
    clickPart.MouseButton1Up:Connect(function()
        local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(buttonFrame, tweenInfo, {
            Size = UDim2.new(originalSize.X.Scale * 1.08, originalSize.X.Offset, originalSize.Y.Scale * 1.08, originalSize.Y.Offset),
            Position = UDim2.new(
                originalPosition.X.Scale - (originalSize.X.Scale * 0.04), 
                originalPosition.X.Offset,
                originalPosition.Y.Scale - (originalSize.Y.Scale * 0.04), 
                originalPosition.Y.Offset
            )
        })
        tween:Play()
    end)
end

-- SISTEMA DE ÁUDIO
local function PlayAudio(soundName)
    if soundName == "Click" then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://421058925"
        sound.Volume = 0.5
        sound.Parent = workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, sound.TimeLength)
    end
end

-- CONFIGURAR BOTÕES LATERAIS DA HUD
local function SetupHUDButtons()
    print("🔍 Configurando botões laterais da HUD...")
    
    -- Encontrar os botões Shop e Codes
    local rightSide = UI:FindFirstChild("RightSide")
    if rightSide then
        local buttons = rightSide:FindFirstChild("Buttons")
        if buttons then
            -- Botão Shop - COM TOGGLE
            local shopButtonFrame = buttons:FindFirstChild("Shop")
            if shopButtonFrame then
                SetupSideButtonAnimation(shopButtonFrame)
                
                local shopClick = shopButtonFrame:FindFirstChild("Click")
                if shopClick then
                    shopClick.MouseButton1Click:Connect(function()
                        if shopFrame then
                            ToggleFrame(shopFrame, "Shop")
                        end
                        PlayAudio("Click")
                    end)
                    print("✅ Botão Shop configurado com toggle")
                end
            end
            
            -- Botão Codes - COM TOGGLE
            local codesButtonFrame = buttons:FindFirstChild("Codes")
            if codesButtonFrame then
                SetupSideButtonAnimation(codesButtonFrame)
                
                local codesClick = codesButtonFrame:FindFirstChild("Click")
                if codesClick then
                    codesClick.MouseButton1Click:Connect(function()
                        if codesFrame then
                            ToggleFrame(codesFrame, "Codes")
                        end
                        PlayAudio("Click")
                    end)
                    print("✅ Botão Codes configurado com toggle")
                end
            end
        end
    end
    
    -- Configurar botões Close (fecham tudo)
    local function SetupCloseButton(closeButton)
        if closeButton then
            local closeClick = closeButton:FindFirstChild("Click") or closeButton
            local originalSize = closeClick.Size
            
            closeClick.MouseEnter:Connect(function()
                local tween = TweenService:Create(closeClick, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(originalSize.X.Scale * 1.15, originalSize.X.Offset, originalSize.Y.Scale * 1.15, originalSize.Y.Offset)
                })
                tween:Play()
            end)
            
            closeClick.MouseLeave:Connect(function()
                local tween = TweenService:Create(closeClick, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                    Size = originalSize
                })
                tween:Play()
            end)
            
            closeClick.MouseButton1Click:Connect(function()
                CloseAllFrames()
                PlayAudio("Click")
                print("❌ Todos os frames fechados")
            end)
        end
    end
    
    if shopFrame then
        local closeButton = shopFrame:FindFirstChild("Close")
        SetupCloseButton(closeButton)
    end
    
    if codesFrame then
        local closeButton = codesFrame:FindFirstChild("Close")
        SetupCloseButton(closeButton)
    end
end

-- Configurar botões da HUD
SetupHUDButtons()

--// Shop
if shopFrame then
    local gamepassesHolder = shopFrame:FindFirstChild("Gamepasses")
    
    if gamepassesHolder and ReplicatedStorage:FindFirstChild("Gamepasses") then
        print("📦 Gamepasses no ReplicatedStorage: " .. #ReplicatedStorage.Gamepasses:GetChildren())
        
        -- CONFIGURAÇÃO PERSONALIZADA DAS GAMEPASSES
        local GamepassConfigs = {
            DoubleResources = {
                DisplayName = "2x Resources Boost",
                Description = "Ganha 2x mais recursos ao minerar!",
                Icon = "rbxassetid://104741425006264"
            },
            BonusResources = {
                DisplayName = "Resource Bonus", 
                Description = "Receba 50% mais recursos em todas as compras!",
                Icon = "rbxassetid://13257742485"
            }
        }
        
        -- LIMPAR GAMEPASSES EXISTENTES ANTES DE ADICIONAR NOVOS
        for _, existingGamepass in gamepassesHolder:GetChildren() do
            if existingGamepass:IsA("Frame") then
                existingGamepass:Destroy()
            end
        end
        
        for _, Gamepass in ReplicatedStorage.Gamepasses:GetChildren() do
            print("🔄 Processando gamepass: " .. Gamepass.Name)
            
            local template = script:FindFirstChild("GamepassTemplate")
            if not template then
                warn("❌ GamepassTemplate não encontrado no script")
                break
            end
            
            local NewGamepass = template:Clone()
            NewGamepass.Name = Gamepass.Name

            local GamepassInfo
            local Success, Error = pcall(function()
                GamepassInfo = MarketPlaceService:GetProductInfo(Gamepass.Value, Enum.InfoType.GamePass)
            end)

            if Error then 
                warn("❌ Error loading gamepass data: " .. Error) 
                NewGamepass:Destroy() 
                continue 
            end

            print("✅ Gamepass carregado: " .. GamepassInfo.Name)

            -- Configurar visual do gamepass COM CONFIGURAÇÃO PERSONALIZADA
            local innerPart = NewGamepass:FindFirstChild("InnerPart")
            if innerPart then
                local imageLabel = innerPart:FindFirstChild("ImageLabel")
                local description = innerPart:FindFirstChild("Description")
                local gpName = innerPart:FindFirstChild("GPName")
                local price = innerPart:FindFirstChild("Price")
                local button = innerPart:FindFirstChild("Button")
                
                -- ⚡ APENAS AJUSTES MINIMOS E PROPORCIONAIS
                if imageLabel then
                    -- Manter tamanho original ou aumentar MUITO POUCO
                    imageLabel.Size = UDim2.new(0, 65, 0, 65)  -- +5px apenas
                end
                
                if gpName then
                    gpName.TextSize = 15  -- +1 ponto apenas
                end
                
                if description then
                    description.TextSize = 12  -- +1 ponto apenas
                    description.TextWrapped = true
                end
                
                if price then
                    price.TextSize = 13  -- +1 ponto apenas
                end
                
                -- NÃO MEXER NO TAMANHO DO BOTÃO nem posições!
                
                -- USAR CONFIGURAÇÃO PERSONALIZADA SE EXISTIR
                local config = GamepassConfigs[Gamepass.Name]
                if config then
                    print("🎨 Usando configuração personalizada para: " .. Gamepass.Name)
                    if imageLabel then 
                        imageLabel.Image = config.Icon
                    end
                    if description then 
                        description.Text = config.Description
                    end
                    if gpName then 
                        gpName.Text = config.DisplayName
                    end
                else
                    -- Fallback para info da Roblox
                    print("🎨 Usando info padrão da Roblox para: " .. Gamepass.Name)
                    if imageLabel then 
                        imageLabel.Image = "rbxassetid://" .. tostring(GamepassInfo.IconImageAssetId or 666669321) 
                    end
                    if description then 
                        description.Text = GamepassInfo.Description 
                    end
                    if gpName then 
                        gpName.Text = GamepassInfo.Name 
                    end
                end
                
                -- Configurar preço
                if price then 
                    price.Text = "\u{E002}" .. tostring(GamepassInfo.PriceInRobux or 100) 
                end
                
                -- Configurar botão COM ANIMAÇÃO SIMPLES
                if button then
                    local originalSize = button.Size
                    
                    -- Animação de hover simples
                    button.MouseEnter:Connect(function()
                        local tween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(originalSize.X.Scale * 1.05, originalSize.X.Offset, originalSize.Y.Scale * 1.05, originalSize.Y.Offset)
                        })
                        tween:Play()
                    end)
                    
                    button.MouseLeave:Connect(function()
                        local tween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                            Size = originalSize
                        })
                        tween:Play()
                    end)
                    
                    button.MouseButton1Click:Connect(function()
                        print("🎮 CLIQUE NO GAMEPASS: " .. (config and config.DisplayName or GamepassInfo.Name))
                        PlayAudio("Click")
                        
                        -- Abrir janela de compra
                        MarketPlaceService:PromptGamePassPurchase(Player, Gamepass.Value)
                    end)
                end
            end

            NewGamepass.Parent = gamepassesHolder
            print("✅ Gamepass adicionado à UI: " .. Gamepass.Name)
        end
    else
        if not gamepassesHolder then
            warn("❌ Gamepasses holder não encontrado no Shop")
        end
        if not ReplicatedStorage:FindFirstChild("Gamepasses") then
            warn("❌ Gamepasses não encontrado no ReplicatedStorage")
        end
    end
end

--// Codes
if codesFrame then
    local redeemButton = codesFrame:FindFirstChild("Redeem")
    
    if redeemButton then
        local originalSize = redeemButton.Size
        
        redeemButton.MouseEnter:Connect(function()
            local tween = TweenService:Create(redeemButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = UDim2.new(originalSize.X.Scale * 1.08, originalSize.X.Offset, originalSize.Y.Scale * 1.08, originalSize.Y.Offset)
            })
            tween:Play()
        end)
        
        redeemButton.MouseLeave:Connect(function()
            local tween = TweenService:Create(redeemButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = originalSize
            })
            tween:Play()
        end)
        
        redeemButton.MouseButton1Click:Connect(function()
            PlayAudio("Click")
            
            if not Remotes:FindFirstChild("RedeemCode") then
                local newRemote = Instance.new("RemoteEvent")
                newRemote.Name = "RedeemCode"
                newRemote.Parent = Remotes
            end
            
            Remotes.RedeemCode:FireServer()
        end)
    end
end

print("🎉 SISTEMA CONFIGURADO!")
print("✨ Botões com toggle - clique para abrir/fechar")
print("🎯 Animações mais suaves com Quad")
print("🔊 Áudio instantâneo")