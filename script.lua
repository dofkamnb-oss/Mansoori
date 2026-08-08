-- // ==========================================
-- // ADVANCED FLICK SCRIPT - KEYLESS & OPEN SOURCE
-- // ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- إعدادات السكربت والتحكم
local Config = {
    AimbotEnabled = true,
    TargetPart = "Head", -- Head أو Torso
    Smoothness = 0.2,
    FOVSize = 120,
    MaxDistance = 1000,
    Prediction = true,
    
    ESPEnabled = true,
    VisibleColor = Color3.fromRGB(0, 255, 0),    -- أخضر (مرئي)
    HiddenColor = Color3.fromRGB(255, 0, 0),     -- أحمر (خلف الجدار)
    
    AutoFireEnabled = true,
    CPS = 5, -- 5 نقرات في الثانية
    
    FPSBoost = false,
    Fullbright = false
}

-- // ==========================================
-- // 1. دائرة الـ FOV المرئية
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
-- // 2. نظام الـ Aimbot الذكي مع التنبؤ
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
                    -- التحقق من عدم وجود جدران (Smart Targeting)
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local rayResult = Workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams)

                    if not rayResult then -- مرئي تماماً بدون عوائق
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
                -- تعويض حركة الهدف (Movement Prediction)
                local hrp = target.Parent.HumanoidRootPart
                targetPos = targetPos + (hrp.AssemblyLinearVelocity * 0.05)
            end
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), Config.Smoothness)
        end
    end
end)

-- // ==========================================
-- // 3. نظام الـ ESP والتلوين خلف الجدران (Chams)
-- // ==========================================
local highlights = {}

local function setupESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = Workspace
    
    highlights[player] = highlight

    RunService.RenderStepped:Connect(function()
        if not Config.ESPEnabled or not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
            highlight.Enabled = false
            return
        end

        highlight.Enabled = true
        
        -- التحقق هل هو خلف الجدار أم مرئي لتغيير اللون
        local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = Workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams)

            if rayResult then
                highlight.FillColor = Config.HiddenColor -- أحمر (خلف الجدار)
                highlight.OutlineColor = Config.HiddenColor
            else
                highlight.FillColor = Config.VisibleColor -- أخضر (مرئي)
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
-- // 4. نظام الـ Auto Fire (5 CPS)
-- // ==========================================
task.spawn(function()
    while true do
        if Config.AutoFireEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            mouse1click()
            task.wait(1 / Config.CPS) -- يحافظ على معدل 5 نقرات في الثانية بدقة
        else
            task.wait(0.1)
        end
    end
end)

-- // ==========================================
-- // 5. أدوات المساعدة (FPS Boost & Fullbright)
-- // ==========================================
RunService.RenderStepped:Connect(function()
    if Config.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    end
end)

print("Flick Script Loaded Successfully! Enjoy.")
