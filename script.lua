-- // ==========================================
-- // ADVANCED FLICK SCRIPT - UI & STABLE AIMBOT
-- // ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- إعدادات السكربت والتحكم
local Config = {
    AimbotEnabled = true,
    TargetPart = "Head", -- الهدف: Head أو HumanoidRootPart
    Smoothness = 0.15,   -- ثبات وقوة التصويب (كلما قل زادت سرعة الثبات)
    FOVSize = 130,       -- حجم دائرة الـ FOV
    Prediction = true,   -- التنبؤ بحركة الأعداء المتحركة
    
    ESPEnabled = true,
    VisibleColor = Color3.fromRGB(0, 255, 0),    -- أخضر (مرئي)
    HiddenColor = Color3.fromRGB(255, 0, 0),     -- أحمر (خلف الجدار)
    
    AutoFireEnabled = false,
    CPS = 5 -- 5 نقرات في الثانية
}

-- تنظيف الواجهة القديمة إن وجدت
if CoreGui:FindFirstChild("FlickMenuGUI") then
    CoreGui.FlickMenuGUI:Destroy()
end

-- // ==========================================
-- // 1. إنشاء قائمة التحكم (UI Menu)
-- // ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlickMenuGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 310)
MainFrame.Active = true
MainFrame.Draggable = true -- يمكنك تحريك القائمة في الشاشة

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "⚡ FLICK CONTROL MENU ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

local function createButton(name, posY, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.Size = UDim2.new(0, 215, 0, 35)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Text = name .. ": " .. (defaultState and "ON" or "OFF")
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

createButton("Aimbot", 55, Config.AimbotEnabled, function(v) Config.AimbotEnabled = v end)
createButton("ESP Chams", 100, Config.ESPEnabled, function(v) Config.ESPEnabled = v end)
createButton("Auto Fire (5 CPS)", 145, Config.AutoFireEnabled, function(v) Config.AutoFireEnabled = v end)
createButton("Movement Prediction", 190, Config.Prediction, function(v) Config.Prediction = v end)

local infoLabel = Instance.new("TextLabel")
infoLabel.Parent = MainFrame
infoLabel.BackgroundTransparency = 1
infoLabel.Position = UDim2.new(0, 10, 0, 240)
infoLabel.Size = UDim2.new(0, 220, 0, 60)
infoLabel.Font = Enum.Font.SourceSans
infoLabel.Text = "Hold Right Click (RMB) for Aimbot.\nPress [Insert] to Hide/Show Menu."
infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
infoLabel.TextSize = 13
infoLabel.TextWrapped = true

-- إخفاء وإظهار القائمة بزر Insert
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- // ==========================================
-- // 2. دائرة الـ FOV المرئية والذكية
-- // ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Radius = Config.FOVSize
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Config.FOVSize
    FOVCircle.Visible = Config.AimbotEnabled
end)

-- // ==========================================
-- // 3. نظام Aimbot قوي وثابت جداً
-- // ==========================================
local function getClosestTarget()
    local closestTarget = nil
    local shortestDistance = Config.FOVSize

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPart = player.Character:FindFirstChild(Config.TargetPart) or player.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude

                if onScreen and distance < shortestDistance then
                    -- فحص الحواجز والجدران لضمان الدقة الثابتة
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local rayResult = Workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams)

                    if not rayResult then
                        shortestDistance = distance
                        closestTarget = targetPart
                    end
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    if Config.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestTarget()
        if target then
            local targetPos = target.Position
            if Config.Prediction and target.Parent:FindFirstChild("HumanoidRootPart") then
                local hrp = target.Parent.HumanoidRootPart
                targetPos = targetPos + (hrp.AssemblyLinearVelocity * 0.035)
            end
            -- تثبيت الكاميرا بنعومة وثبات عالي نحو الهدف
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), Config.Smoothness)
        end
    end
end)

-- // ==========================================
-- // 4. نظام ESP وتلوين دقيق (أخضر مرئي / أحمر خلف الجدار)
-- // ==========================================
local highlights = {}

local function setupESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = CoreGui
    
    highlights[player] = highlight

    RunService.RenderStepped:Connect(function()
        if not Config.ESPEnabled or not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
            highlight.Enabled = false
            return
        end

        highlight.Enabled = true
        local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
        
        if targetPart then
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = Workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams)

            if rayResult then
                highlight.FillColor = Config.HiddenColor   -- أحمر (خلف الجدار)
                highlight.OutlineColor = Config.HiddenColor
            else
                highlight.FillColor = Config.VisibleColor  -- أخضر (مرئي بوضوح)
                highlight.OutlineColor = Config.VisibleColor
            end
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    setupESP(p)
end
Players.PlayerAdded:Connect(setupESP)

-- // ==========================================
-- // 5. نظام Auto Fire (5 CPS) الدقيق
-- // ==========================================
task.spawn(function()
    while true do
        if Config.AutoFireEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            pcall(function()
                mouse1click()
            end)
            task.wait(1 / Config.CPS)
        else
            task.wait(0.1)
        end
    end
end)
