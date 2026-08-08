-- سكربت روبلوكس متكامل (طيران، رادار، ايم بوت)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- إنشاء واجهة المستخدم (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HubGui"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 250)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "Control Panel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- دالة مساعدة لإنشاء الأزرار
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
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
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        callback(active)
    end)
end

-- 1. تفعيل الطيران (Fly)
local flying = false
local flySpeed = 50
createButton("تشغيل / إيقاف الطيران", 55, function(state)
    flying = state
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart
    
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = rootPart
        
        task.spawn(function()
            while flying do
                RunService.RenderStepped:Wait()
                local moveDir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                bv.Velocity = moveDir * flySpeed
            end
            if rootPart:FindFirstChild("FlyVelocity") then
                rootPart.FlyVelocity:Destroy()
            end
        end)
    end
end)

-- 2. تفعيل الرادار / التجسس (ESP)
createButton("تشغيل / إيقاف الرادار (ESP)", 105, function(state)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("Highlight")
            if state and not highlight then
                local h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.Parent = player.Character
            elseif not state and highlight then
                highlight:Destroy()
            end
        end
    end
end)

-- 3. تفعيل الايم بوت (Aimbot مبسط)
local aimbotEnabled = false
createButton("تشغيل / إيقاف الايم بوت", 155, function(state)
    aimbotEnabled = state
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = nil
        local shortestDistance = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local pos, onScreen = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if magnitude < shortestDistance then
                            shortestDistance = magnitude
                            target = player.Character.HumanoidRootPart
                        end
                    end
                end
            end
        end
        
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)
