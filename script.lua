local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | زايد المزروعي",
   LoadingTitle = "تحميل...",
   LoadingSubtitle = "",
   ConfigurationSaving = { Enabled = false }
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==================== قائمة زايد ====================
local ZayedTab = Window:CreateTab("زايد المزروعي 👑", 4483362458)

ZayedTab:CreateSlider({
   Name = "السرعة",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
           LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
       end
   end,
})

ZayedTab:CreateSlider({
   Name = "القفز",
   Range = {50, 300},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(v)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
           LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
       end
   end,
})

local Noclip = false
ZayedTab:CreateToggle({
   Name = "اختراق الجدران",
   CurrentValue = false,
   Callback = function(v) Noclip = v end,
})

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- ==================== قائمة الطيران ====================
local MainTab = Window:CreateTab("طيران 🚀", 4483362458)

local Flying = false
local FlySpeed = 50
local flyConnection

MainTab:CreateToggle({
   Name = "تفعيل الطيران",
   CurrentValue = false,
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
   end,
})

MainTab:CreateSlider({
   Name = "سرعة الطيران",
   Range = {10, 300},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(v) FlySpeed = v end,
})

-- ==================== قائمة القتال ====================
local CombatTab = Window:CreateTab("قتال 🎯", 4483362458)

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

CombatTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Callback = function(v) AimbotEnabled = v end,
})

CombatTab:CreateKeybind({
   Name = "زر القفل",
   CurrentKeybind = "E",
   HoldToInteract = true,
   Callback = function(v) _G.Aiming = v end,
})

CombatTab:CreateSlider({
   Name = "السلاسة",
   Range = {0.05, 1},
   Increment = 0.05,
   CurrentValue = 0.1,
   Callback = function(v) Smoothness = v end,
})

CombatTab:CreateDropdown({
   Name = "الهدف",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = "Head",
   Callback = function(v) TargetPart = v end,
})

CombatTab:CreateToggle({
   Name = "اختراق الجدار بالإيم",
   CurrentValue = false,
   Callback = function(v) WallCheck = v end,
})

CombatTab:CreateToggle({
   Name = "إظهار FOV",
   CurrentValue = true,
   Callback = function(v) FOVVisible = v end,
})

CombatTab:CreateSlider({
   Name = "حجم FOV",
   Range = {30, 500},
   Increment = 5,
   CurrentValue = 150,
   Callback = function(v) FOVRadius = v end,
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
local ESPTab = Window:CreateTab("ESP 👁️", 4483362458)

local ESPEnabled = false
local Highlights = {}

ESPTab:CreateToggle({
   Name = "تفعيل ESP",
   CurrentValue = false,
   Callback = function(v)
       ESPEnabled = v
       if not ESPEnabled then
           for _, h in pairs(Highlights) do if h then h:Destroy() end end
           Highlights = {}
       end
   end,
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
