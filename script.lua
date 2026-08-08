local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | Trace UI - ريفن العسكرية 👑",
   Icon = 0,
   LoadingTitle = "Mansoori Hub | Trace Engine",
   LoadingSubtitle = "by Mansoori",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Drawings Setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 170, 255)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 100
FOVCircle.Radius = 150
FOVCircle.Filled = false
FOVCircle.Visible = false

local SilentFOVCircle = Drawing.new("Circle")
SilentFOVCircle.Color = Color3.fromRGB(255, 50, 50)
SilentFOVCircle.Thickness = 1
SilentFOVCircle.NumSides = 100
SilentFOVCircle.Radius = 90
SilentFOVCircle.Filled = false
SilentFOVCircle.Visible = false

-- Variables
local AimbotEnabled = false
local RequireLOS = true
local PredictionEnabled = false
local StickyAim = true
local ShowFOV = false
local FOVRadius = 150
local ShowSilentFOV = false
local SilentFOVRadius = 90
local TargetPart = "Head"

local ESPEnabled = false
local ESPNames = false
local ESPTracers = false
local Highlights = {}
local ESPTextDrawings = {}
local ESPTracerDrawings = {}

local NoclipEnabled = false
local FullbrightEnabled = false

-- ==================== TAB 1: Aim (التنشين) ====================
local AimTab = Window:CreateTab("Aim 🎯", 4483362458)

AimTab:CreateToggle({
   Name = "Enabled (تفعيل الأيم بوت)",
   CurrentValue = false,
   Flag = "AimEnabled",
   Callback = function(Value)
      AimbotEnabled = Value
   end,
})

AimTab:CreateToggle({
   Name = "Toggle Mode (RMB / زر الماوس الأيمن)",
   CurrentValue = true,
   Flag = "RMBMode",
   Callback = function(Value)
      -- ربط التشغيل بزر الماوس
   end,
})

AimTab:CreateToggle({
   Name = "Require LOS (التحقق من الجدران)",
   CurrentValue = true,
   Flag = "LOSToggle",
   Callback = function(Value)
      RequireLOS = Value
   end,
})

AimTab:CreateToggle({
   Name = "Prediction (توقع حركة العدو)",
   CurrentValue = false,
   Flag = "PredToggle",
   Callback = function(Value)
      PredictionEnabled = Value
   end,
})

AimTab:CreateToggle({
   Name = "Sticky Aim (الالتصاق بالهدف)",
   CurrentValue = true,
   Flag = "StickyToggle",
   Callback = function(Value)
      StickyAim = Value
   end,
})

AimTab:CreateDropdown({
   Name = "Target Part (مكان الإصابة)",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "AimPart",
   Callback = function(Option)
      TargetPart = Option[1]
   end,
})

-- FOV Section in Aim
AimTab:CreateSection("إعدادات الـ FOV")

AimTab:CreateToggle({
   Name = "Show FOV Circle (إظهار دائرة التنشين)",
   CurrentValue = false,
   Flag = "ShowFOVCircle",
   Callback = function(Value)
      ShowFOV = Value
      FOVCircle.Visible = Value
   end,
})

AimTab:CreateSlider({
   Name = "FOV Radius (حجم الدائرة)",
   Range = {50, 400},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 150,
   Flag = "FOVSize",
   Callback = function(Value)
      FOVRadius = Value
      FOVCircle.Radius = Value
   end,
})

AimTab:CreateToggle({
   Name = "Show Silent FOV",
   CurrentValue = false,
   Flag = "ShowSilentFOV",
   Callback = function(Value)
      ShowSilentFOV = Value
      SilentFOVCircle.Visible = Value
   end,
})

AimTab:CreateSlider({
   Name = "Silent FOV Radius",
   Range = {30, 200},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 90,
   Flag = "SilentFOVSize",
   Callback = function(Value)
      SilentFOVRadius = Value
      SilentFOVCircle.Radius = Value
   end,
})

-- ==================== TAB 2: ESP (كشف الأماكن) ====================
local ESPTab = Window:CreateTab("ESP 👁️", 4483362458)

ESPTab:CreateToggle({
   Name = "Enable Highlight (التوهج خلف الجدران)",
   CurrentValue = false,
   Flag = "ESPOn",
   Callback = function(Value)
      ESPEnabled = Value
      if not ESPEnabled then
          for _, h in pairs(Highlights) do if h then h:Destroy() end end
          Highlights = {}
      end
   end,
})

ESPTab:CreateToggle({
   Name = "Show Names & Distance (الأسماء والمسافة)",
   CurrentValue = false,
   Flag = "ESPNameOn",
   Callback = function(Value)
      ESPNames = Value
      if not ESPNames then
          for _, d in pairs(ESPTextDrawings) do if d then d:Remove() end end
          ESPTextDrawings = {}
      end
   end,
})

ESPTab:CreateToggle({
   Name = "Tracers (خطوط التتبع)",
   CurrentValue = false,
   Flag = "ESPTracerOn",
   Callback = function(Value)
      ESPTracers = Value
      if not ESPTracers then
          for _, t in pairs(ESPTracerDrawings) do if t then t:Remove() end end
          ESPTracerDrawings = {}
      end
   end,
})

-- ==================== TAB 3: World (العالم والبيئة) ====================
local WorldTab = Window:CreateTab("World 🌐", 4483362458)

WorldTab:CreateToggle({
   Name = "Fullbright (إضاءة كاملة وإزالة الظلام)",
   CurrentValue = false,
   Flag = "FullbrightOn",
   Callback = function(Value)
      FullbrightEnabled = Value
      if Value then
          game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
          game:GetService("Lighting").Brightness = 2
          game:GetService("Lighting").GlobalShadows = false
      else
          game:GetService("Lighting").Ambient = Color3.fromRGB(128, 128, 128)
          game:GetService("Lighting").Brightness = 1
          game:GetService("Lighting").GlobalShadows = true
      end
   end,
})

WorldTab:CreateSlider({
   Name = "Camera FOV (مدى زاوية الرؤية)",
   Range = {70, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "CamFOV",
   Callback = function(Value)
      Camera.FieldOfView = Value
   end,
})

WorldTab:CreateToggle({
   Name = "Noclip (اختراق الجدران)",
   CurrentValue = false,
   Flag = "NoclipOn",
   Callback = function(Value)
      NoclipEnabled = Value
   end,
})

-- ==================== TAB 4: Config (الإعدادات والإغلاق) ====================
local ConfigTab = Window:CreateTab("Config ⚙️", 4483362458)

ConfigTab:CreateButton({
   Name = "Unload UI (إغلاق السكربت تماماً)",
   Callback = function()
      Rayfield:Destroy()
      FOVCircle:Remove()
      SilentFOVCircle:Remove()
      for _, h in pairs(Highlights) do if h then h:Destroy() end end
      for _, d in pairs(ESPTextDrawings) do if d then d:Remove() end end
      for _, t in pairs(ESPTracerDrawings) do if t then t:Remove() end end
   end,
})

-- ==================== LOOPS ====================

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    
    FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    FOVCircle.Visible = ShowFOV

    SilentFOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    SilentFOVCircle.Visible = ShowSilentFOV

    -- Aimbot Execution Logic
    if AimbotEnabled and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
        local Closest = nil
        local Dist = FOVRadius

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local part = p.Character[TargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if d < Dist then
                        -- Check LOS if required
                        if RequireLOS then
                            local origin = Camera.CFrame.Position
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            local raycastResult = Workspace:Raycast(origin, part.Position - origin, raycastParams)
                            
                            if not raycastResult or raycastResult.Instance:IsDescendantOf(p.Character) then
                                Closest = p
                                Dist = d
                            end
                        else
                            Closest = p
                            Dist = d
                        end
                    end
                end
            end
        end

        if Closest and Closest.Character and Closest.Character:FindFirstChild(TargetPart) then
            local targetPos = Closest.Character[TargetPart].Position
            if PredictionEnabled and Closest.Character:FindFirstChild("HumanoidRootPart") then
                targetPos = targetPos + (Closest.Character.HumanoidRootPart.AssemblyLinearVelocity * 0.1)
            end
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), 0.3)
        end
    end

    -- ESP Highlight
    if ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not Highlights[p] or not Highlights[p].Parent then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(0, 170, 255)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.Parent = p.Character
                    Highlights[p] = h
                end
            end
        end
    end

    -- ESP Names
    if ESPNames then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") then
                local head = p.Character.Head
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if not ESPTextDrawings[p] then
                    local txt = Drawing.new("Text")
                    txt.Size = 14
                    txt.Center = true
                    txt.Outline = true
                    txt.Color = Color3.fromRGB(255, 255, 255)
                    ESPTextDrawings[p] = txt
                end

                local txt = ESPTextDrawings[p]
                if onScreen then
                    local dist = math.floor((head.Position - Camera.CFrame.Position).Magnitude)
                    txt.Text = p.Name .. " [" .. dist .. "m] HP: " .. math.floor(hum.Health)
                    txt.Position = Vector2.new(pos.X, pos.Y - 25)
                    txt.Visible = true
                else
                    txt.Visible = false
                end
            else
                if ESPTextDrawings[p] then ESPTextDrawings[p].Visible = false end
            end
        end
    end

    -- Tracers
    if ESPTracers then
        local viewportSize = Camera.ViewportSize
        local bottomCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y)

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local root = p.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

                if not ESPTracerDrawings[p] then
                    local line = Drawing.new("Line")
                    line.Color = Color3.fromRGB(0, 170, 255)
                    line.Thickness = 1
                    ESPTracerDrawings[p] = line
                end

                local line = ESPTracerDrawings[p]
                if onScreen then
                    line.From = bottomCenter
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                if ESPTracerDrawings[p] then ESPTracerDrawings[p].Visible = false end
            end
        end
    end
end)
