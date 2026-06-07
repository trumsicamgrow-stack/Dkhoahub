-- [[ DK SIGMA - MENU SOURCE ]] --
-- [[ Created by: dkhoa ]] --

local DkSigma = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local TopBarCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ContentScroll = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Feature Toggle States
_G.AutoFarm = false
_G.AutoClick = false

-- Initialize GUI (Protected from deletion upon changing Seas)
DkSigma.Name = "DkSigma_Menu"
DkSigma.Parent = game.CoreGui
DkSigma.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = DkSigma
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TopBar.Size = UDim2.new(1, 0, 0, 35)

TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Dk Sigma | Made by dkhoa"
Title.TextColor3 = Color3.fromRGB(255, 45, 45)
Title.TextSize = 14.000
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1.000
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14.000
CloseBtn.MouseButton1Click:Connect(function() DkSigma:Destroy() end)

ContentScroll.Name = "ContentScroll"
ContentScroll.Parent = MainFrame
ContentScroll.Active = true
ContentScroll.BackgroundTransparency = 1.000
ContentScroll.Position = UDim2.new(0, 10, 0, 45)
ContentScroll.Size = UDim2.new(1, -20, 1, -55)
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
ContentScroll.ScrollBarThickness = 4

UIListLayout.Parent = ContentScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- [[ TOGGLE BUTTON CREATOR FUNCTION ]] --
local function CreateToggle(text, global_var, callback)
    local ToggleBtn = Instance.new("TextButton")
    local ToggleCorner = Instance.new("UICorner")
    
    ToggleBtn.Name = text .. "_Toggle"
    ToggleBtn.Parent = ContentScroll
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
    ToggleBtn.Font = Enum.Font.GothamSemibold
    ToggleBtn.Text = text .. " : OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    ToggleBtn.TextSize = 12.000
    
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleBtn
    
    ToggleBtn.MouseButton1Click:Connect(function()
        _G[global_var] = not _G[global_var]
        if _G[global_var] then
            ToggleBtn.Text = text .. " : ON"
            ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            ToggleBtn.Text = text .. " : OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        callback(_G[global_var])
    end)
end

-- [[ FEATURE 1: AUTO CLICK ]] --
CreateToggle("Auto Click (Fast Attack)", "AutoClick", function(state)
    spawn(function()
        while _G.AutoClick do
            local VirtualUser = game:GetService('VirtualUser')
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(851, 529))
            task.wait(0.1)
        end
    end)
end)

-- [[ FEATURE 2: AUTO BRING & FARM MONSTERS ]] --
local function GetMonster()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            return v
        end
    end
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            return v
        end
    end
    return nil
end

CreateToggle("Auto Farm Nearest Monster", "AutoFarm", function(state)
    spawn(function()
        while _G.AutoFarm do
            local enemy = GetMonster()
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                -- Bring monsters together and disable collision
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == enemy.Name and v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                        v.HumanoidRootPart.CanCollide = false
                    end
                end
                
                -- Teleport player slightly above the monster to avoid damage
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                end
                
                -- Trigger weapon attacks
                local VirtualUser = game:GetService('VirtualUser')
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(851, 529))
            end
            task.wait()
        end
    end)
end)

-- [[ ANTI-AFK DISCONNECT ]] --
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
