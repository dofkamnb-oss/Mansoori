-- Mansoori Script - Native UI
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local parentGui = (gethui and gethui()) or CoreGui
if parentGui:FindFirstChild("MansooriUI") then
    parentGui.MansooriUI:Destroy()
end

local MansooriUI = Instance.new("ScreenGui")
MansooriUI.Name = "MansooriUI"
MansooriUI.ResetOnSpawn = false
MansooriUI.Parent = parentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 320)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = MansooriUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "  حمدان المنصوري | زايد المزروعي 👑"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Container
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- 1. Speed
local speed = 16
CreateButton("⚡ السرعة (الحالية: " .. speed .. ")", function(btn)
    speed = speed == 16 and 100 or (speed == 100 and 200 or 16)
    btn.Text = "⚡ السرعة (الحالية: " .. speed .. ")"
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
    end
end)

-- 2. Noclip
local Noclip = false
CreateButton("🧱 اختراق الجدران: معطل 🔴", function(btn)
    Noclip = not Noclip
    btn.Text = "🧱 اختراق الجدران: " .. (Noclip and "مفعل 🟢" or "معطل 🔴")
end)

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- 3. Fly
local Flying = false
local FlySpeed = 50
local flyConnection

CreateButton("🚀 الطيران: معطل 🔴", function(btn)
    Flying = not Flying
    btn.Text = "🚀 الطيران: " .. (Flying and "مفعل 🟢" or "معطل 🔴")
    
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if Flying then
        if hum then hum.PlatformStand = true end
        if flyConnection then flyConnection:Disconnect() end
        flyConnection = RunService.RenderStepped:Connect(function(delta)
            if not Flying or not char or not root then
                if flyConnection then flyConnection:Disconnect() end
                if hum then hum.PlatformStand = false end
                return
            end

            local moveDir = Vector3.zero
            local camCFrame = Camera.CFrame

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end

            root.CFrame = root.CFrame + (moveDir * FlySpeed * delta * 3)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        if hum then hum.PlatformStand = false end
    end
end)

-- 4. Aimbot
local AimbotEnabled = false
CreateButton("🎯 Aimbot (زر E أو الماوس الأيمن): معطل 🔴", function(btn)
    AimbotEnabled = not AimbotEnabled
    btn.Text = "🎯 Aimbot: " .. (AimbotEnabled and "مفعل 🟢" or "معطل 🔴")
end)

local function GetTarget()
    local Closest = nil
    local Dist = 300
    local MousePos = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local part = p.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local d = (Vector2.new(pos.X, pos.Y) - MousePos).Magnitude
                if d < Dist then
                    Closest = p
                    Dist = d
                end
            end
        end
    end
    return Closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled and (UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
        local target = GetTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- 5. ESP
local ESPEnabled = false
local Highlights = {}
CreateButton("👁️ ESP (كشف اللاعبين): معطل 🔴", function(btn)
    ESPEnabled = not ESPEnabled
    btn.Text = "👁️ ESP: " .. (ESPEnabled and "مفعل 🟢" or "معطل 🔴")
    if not ESPEnabled then
        for _, h in pairs(Highlights) do if h then h:Destroy() end end
        Highlights = {}
    end
end)

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not Highlights[p] or not Highlights[p].Parent then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.Parent = p.Character
                    Highlights[p] = h
                end
            end
        end
    end
end)
