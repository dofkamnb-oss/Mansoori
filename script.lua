local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "حمدان المنصوري | زايد المزروعي",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "MansooriConfig"
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==================== قائمة زايد ====================
local ZayedTab = Window:MakeTab({
    Name = "زايد المزروعي 👑",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

ZayedTab:AddSlider({
    Name = "السرعة",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
        end
    end    
})

ZayedTab:AddSlider({
    Name = "القفز",
    Min = 50,
    Max = 300,
    Default = 50,
    Increment = 5,
    ValueName = "Jump",
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
        end
    end    
})

local Noclip = false
ZayedTab:AddToggle({
    Name = "اختراق الجدران",
    Default = false,
    Callback = function(v) Noclip = v end    
})

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- ==================== قائمة الطيران ====================
local MainTab = Window:MakeTab({
    Name = "طيران 🚀",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local Flying = false
local FlySpeed = 50
local flyConnection

MainTab:AddToggle({
    Name = "تفعيل الطيران",
    Default = false,
    Callback = function(v)
        Flying = v
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
    end
})

MainTab:AddSlider({
    Name = "سرعة الطيران",
    Min = 10,
    Max = 300,
    Default = 50,
    Increment = 10,
    ValueName = "Speed",
    Callback = function(v) FlySpeed = v end    
})

-- ==================== قائمة القتال ====================
local CombatTab = Window:MakeTab({
    Name = "قتال 🎯",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local AimbotEnabled = false
local FOVVisible = true
local FOVRadius = 150
local Smoothness = 0.1
local WallCheck = false
local TargetPart = "Head"

local FOVCircle = Drawing and Drawing.new("Circle") or nil
if FOVCircle then
    FOVCircle.Visible = FOVVisible
    FOVCircle.Radius = FOVRadius
    FOVCircle.Color = Color3.fromRGB(0, 255, 127)
    FOVCircle.Thickness = 2
    FOVCircle.Filled = false
    FOVCircle.Transparency = 1
end

RunService.RenderStepped:Connect(function()
    if FOVCircle then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
        FOVCircle.Radius = FOVRadius
        FOVCircle.Visible = FOVVisible
    end
end)

CombatTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(v) AimbotEnabled = v end
})

CombatTab:AddBind({
    Name = "زر القفل",
    Default = Enum.KeyCode.E,
    Hold = true,
    Callback = function(v) _G.Aiming = v end    
})

CombatTab:AddSlider({
    Name = "السلاسة",
    Min = 0.05,
    Max = 1,
    Default = 0.1,
    Increment = 0.05,
    ValueName = "Smoothness",
    Callback = function(v) Smoothness = v end
})

CombatTab:AddDropdown({
    Name = "الهدف",
    Default = "Head",
    Options = {"Head", "HumanoidRootPart"},
    Callback = function(v) TargetPart = v end
})

CombatTab:AddToggle({
    Name = "اختراق الجدار بالإيم",
    Default = false,
    Callback = function(v) WallCheck = v end
})

CombatTab:AddToggle({
    Name = "إظهار FOV",
    Default = true,
    Callback = function(v) FOVVisible = v end
})

CombatTab:AddSlider({
    Name = "حجم FOV",
    Min = 30,
    Max = 500,
    Default = 150,
    Increment = 5,
    ValueName = "Size",
    Callback = function(v) FOVRadius = v end
})

local function IsVisible(part)
    if WallCheck then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    return workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), rayParams) == nil
end

local function GetTarget()
    local Closest = nil
    local Dist = FOVRadius
    local MousePos = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local part = p.Character[TargetPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local d = (Vector2.new(pos.X, pos.Y) - MousePos).Magnitude
                if d < Dist and IsVisible(part) then
                    Closest = p
                    Dist = d
                end
            end
        end
    end
    return Closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled and (_G.Aiming or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
        local target = GetTarget()
        if target and target.Character and target.Character:FindFirstChild(TargetPart) then
            local targetPos = target.Character[TargetPart].Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), Smoothness)
        end
    end
end)

-- ==================== ESP ====================
local ESPTab = Window:MakeTab({
    Name = "ESP 👁️",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local ESPEnabled = false
local Highlights = {}

ESPTab:AddToggle({
    Name = "تفعيل ESP",
    Default = false,
    Callback = function(v)
        ESPEnabled = v
        if not ESPEnabled then
            for _, h in pairs(Highlights) do if h then h:Destroy() end end
            Highlights = {}
        end
    end
})

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

OrionLib:Init()
