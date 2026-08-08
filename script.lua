-- Roblox Script: Fly, ESP, Head Aimbot, FOV & Health
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("CustomHub") then
    PlayerGui.CustomHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 240)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Control Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- زر لإنشاء القوائم
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSans
    btn.Parent = Frame
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        callback(active)
    end)
end

-- 1. Fly Feature
local flying = false
createButton("Toggle Fly", 45, function(state)
    flying = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "CustomFly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        
        task.spawn(function()
            while flying and char and root.Parent do
                RunService.RenderStepped:Wait()
                local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
                bv.Velocity = move * 50
            end
            if bv then bv:Destroy() end
        end)
    end
end)

-- 2. ESP & Health Display Feature
createButton("Toggle ESP & Health", 85, function(state)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("CustomESP")
            local bgui = p.Character:FindFirstChild("HealthTag")
            
            if state and not hl then
                -- Highlight
                local h = Instance.new("Highlight")
                h.Name = "CustomESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.Parent = p.Character
                
                -- Health Text over head
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "HealthTag"
                    bg.Size = UDim2.new(0, 100, 0, 40)
                    bg.StudsOffset = Vector3.new(0, 2, 0)
                    bg.AlwaysOnTop = true
                    bg.Parent = p.Character
                    
                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(0, 255, 0)
                    txt.TextSize = 14
                    txt.Font = Enum.Font.SourceSansBold
                    txt.Parent = bg
                    
                    task.spawn(function()
                        while p.Character and p.Character:FindFirstChild("Humanoid") do
                            txt.Text = "HP: " .. math.floor(p.Character.Humanoid.Health)
                            task.wait(0.5)
                        end
                    end)
                end
            elseif not state then
                if hl then hl:Destroy() end
                if bgui then bgui:Destroy() end
            end
        end
    end
end)

-- 3. FOV Circle & Head Aimbot Setup
local aimbotEnabled = false
local fovRadius = 120

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Radius = fovRadius
FOVring.Color = Color3.fromRGB(255, 255, 255)
FOVring.Thickness = 1
FOVring.Filled = false
FOVring.Transparency = 1
FOVring.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

createButton("Toggle Aimbot + FOV", 125, function(state)
    aimbotEnabled = state
    FOVring.Visible = state
end)

RunService.RenderStepped:Connect(function()
    FOVring.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    if aimbotEnabled then
        local targetHead, shortestDistance = nil, fovRadius
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local head = p.Character.Head
                    local pos, onScreen = Camera:WorldToScreenPoint(head.Position)
                    
                    if onScreen then
                        local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if magnitude < shortestDistance then
                            shortestDistance = magnitude
                            targetHead = head
                        end
                    end
                end
            end
        end
        
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
end)
