local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | زايد المزروعي 👑",
   Icon = 0,
   LoadingTitle = "Mansoori Hub V3 Ultimate",
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
local TeleportService = game:GetService("TeleportService")
local Camera = Workspace.CurrentCamera

-- Drawing Setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 100
FOVCircle.Radius = 150
FOVCircle.Filled = false
FOVCircle.Visible = false

local CrosshairH = Drawing.new("Line")
local CrosshairV = Drawing.new("Line")
CrosshairH.Color = Color3.fromRGB(255, 0, 0)
CrosshairV.Color = Color3.fromRGB(255, 0, 0)
CrosshairH.Thickness = 1.5
CrosshairV.Thickness = 1.5
CrosshairH.Visible = false
CrosshairV.Visible = false

-- Minimap Radar Setup
local RadarBackground = Drawing.new("Circle")
RadarBackground.Radius = 60
RadarBackground.Thickness = 2
RadarBackground.Color = Color3.fromRGB(30, 30, 30)
RadarBackground.Filled = true
RadarBackground.Visible = false
RadarBackground.Position = Vector2.new(100, 200)

local RadarCenter = Drawing.new("Circle")
RadarCenter.Radius = 3
RadarCenter.Color = Color3.fromRGB(0, 255, 0)
RadarCenter.Filled = true
RadarCenter.Visible = false
RadarCenter.Position = RadarBackground.Position

local RadarDots = {}

-- Variables
local AimbotEnabled = false
local SilentAimEnabled = false
local ShowFOV = false
local FOVRadius = 150
local Smoothness = 0.2
local TargetPart = "Head"
local HitboxEnabled = false
local HitboxSize = 5
local ShowCrosshair = false
local ShowRadar = false

local ESPEnabled = false
local ESPNamesEnabled = false
local ESPTracersEnabled = false
local Highlights = {}
local ESPTextDrawings = {}
local ESPTracerDrawings = {}

local NoclipEnabled = false
local Flying = false
local FlySpeed = 50
local flyConnection
local InfJumpEnabled = false
local SpinBotEnabled = false
local SpinSpeed = 20

-- ==================== TAB 1: الرئيسية ⚡ ====================
local MainTab = Window:CreateTab("الرئيسية ⚡", 4483362458)

MainTab:CreateSlider({
   Name = "السرعة (WalkSpeed)",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
      end
   end,
})

MainTab:CreateSlider({
   Name = "قوة القفز (JumpPower)",
   Range = {50, 300},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
      end
   end,
})

MainTab:CreateSlider({
   Name = "سرعة الطيران (Fly Speed)",
   Range = {10, 300},
   Increment = 5,
   Suffix = "Fly Speed",
   CurrentValue = 50,
   Flag = "FlySpeedSlider",
   Callback = function(Value)
      FlySpeed = Value
   end,
})

MainTab:CreateToggle({
   Name = "الطيران (Fly)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      Flying = Value
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

MainTab:CreateToggle({
   Name = "اختراق الجدران (Noclip)",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      NoclipEnabled = Value
   end,
})

MainTab:CreateToggle({
   Name = "القفز اللانهائي (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
      InfJumpEnabled = Value
   end,
})

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

MainTab:CreateButton({
   Name = "تفعيل حماية الخمول (Anti-AFK)",
   Callback = function()
      local VirtualUser = game:GetService("VirtualUser")
      LocalPlayer.Idled:Connect(function()
          VirtualUser:CaptureController()
          VirtualUser:ClickButton2(Vector2.new())
      end)
      Rayfield:Notify({Title = "Anti-AFK", Content = "تم تفعيل حماية الطرد التلقائي!", Duration = 3})
   end,
})

-- ==================== TAB 2: القتال 🎯 ====================
local CombatTab = Window:CreateTab("القتال 🎯", 4483362458)

CombatTab:CreateToggle({
   Name = "تفعيل Aimbot العادي",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      AimbotEnabled = Value
   end,
})

CombatTab:CreateToggle({
   Name = "تفعيل Silent Aim (التنشين الخفي)",
   CurrentValue = false,
   Flag = "SilentAimToggle",
   Callback = function(Value)
      SilentAimEnabled = Value
   end,
})

CombatTab:CreateToggle({
   Name = "إظهار دائرة FOV",
   CurrentValue = false,
   Flag = "FOVToggle",
   Callback = function(Value)
      ShowFOV = Value
      FOVCircle.Visible = Value
   end,
})

CombatTab:CreateSlider({
   Name = "حجم دائرة الـ FOV",
   Range = {50, 500},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 150,
   Flag = "FOVSlider",
   Callback = function(Value)
      FOVRadius = Value
      FOVCircle.Radius = Value
   end,
})

CombatTab:CreateSlider({
   Name = "نعومة التنشين (Smoothness)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "Smooth",
   CurrentValue = 2,
   Flag = "SmoothSlider",
   Callback = function(Value)
      Smoothness = Value / 10
   end,
})

CombatTab:CreateDropdown({
   Name = "مكان التنشين (Target Part)",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "PartDropdown",
   Callback = function(Option)
      TargetPart = Option[1]
   end,
})

CombatTab:CreateToggle({
   Name = "تكبير رؤوس الأعداء (Hitbox Extender)",
   CurrentValue = false,
   Flag = "HitboxToggle",
   Callback = function(Value)
      HitboxEnabled = Value
   end,
})

CombatTab:CreateSlider({
   Name = "حجم تكبير الرأس",
   Range = {2, 20},
   Increment = 1,
   Suffix = "Size",
   CurrentValue = 5,
   Flag = "HitboxSizeSlider",
   Callback = function(Value)
      HitboxSize = Value
   end,
})

CombatTab:CreateToggle({
   Name = "إظهار نيشان تصويب مخصص (Crosshair)",
   CurrentValue = false,
   Flag = "CrosshairToggle",
   Callback = function(Value)
      ShowCrosshair = Value
      CrosshairH.Visible = Value
      CrosshairV.Visible = Value
   end,
})

-- ==================== TAB 3: كشف الأماكن 👁️ ====================
local ESPTab = Window:CreateTab("كشف الأماكن 👁️", 4483362458)

ESPTab:CreateToggle({
   Name = "كشف التوهج (Highlight ESP)",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      ESPEnabled = Value
      if not ESPEnabled then
          for _, h in pairs(Highlights) do if h then h:Destroy() end end
          Highlights = {}
      end
   end,
})

ESPTab:CreateToggle({
   Name = "إظهار أسماء اللاعبين والمسافة والصحة",
   CurrentValue = false,
   Flag = "ESPNamesToggle",
   Callback = function(Value)
      ESPNamesEnabled = Value
      if not ESPNamesEnabled then
          for _, d in pairs(ESPTextDrawings) do if d then d:Remove() end end
          ESPTextDrawings = {}
      end
   end,
})

ESPTab:CreateToggle({
   Name = "خطوط التتبع (Tracers)",
   CurrentValue = false,
   Flag = "ESPTracersToggle",
   Callback = function(Value)
      ESPTracersEnabled = Value
      if not ESPTracersEnabled then
          for _, t in pairs(ESPTracerDrawings) do if t then t:Remove() end end
          ESPTracerDrawings = {}
      end
   end,
})

ESPTab:CreateToggle({
   Name = "تفعيل الرادار المصغر (Minimap Radar)",
   CurrentValue = false,
   Flag = "RadarToggle",
   Callback = function(Value)
      ShowRadar = Value
      RadarBackground.Visible = Value
      RadarCenter.Visible = Value
      if not ShowRadar then
          for _, dot in pairs(RadarDots) do if dot then dot.Visible = false end end
      end
   end,
})

-- ==================== TAB 4: سكربتات الألعاب 🎮 ====================
local GamesTab = Window:CreateTab("الألعاب 🎮", 4483362458)

GamesTab:CreateButton({
   Name = "تشغيل سكربت Blox Fruits الشامل",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/main/Source.lua"))()
   end,
})

GamesTab:CreateButton({
   Name = "تشغيل سكربت Arsenal الاحترافي",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Quenty/NevermoreEngine/main/loader.lua"))()
   end,
})

GamesTab:CreateButton({
   Name = "تشغيل سكربت Da Hood الخارق",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/SpaceHubPortal/SpaceHub/main/main"))()
   end,
})

GamesTab:CreateButton({
   Name = "تشغيل سكربت Brookhaven VVIP",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/IceManeMane/IceHub/main/Brookhaven"))()
   end,
})

-- ==================== TAB 5: العالم 🌐 ====================
local WorldTab = Window:CreateTab("العالم 🌐", 4483362458)

WorldTab:CreateToggle({
   Name = "إضاءة كاملة (Fullbright)",
   CurrentValue = false,
   Flag = "FullbrightToggle",
   Callback = function(Value)
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
   Name = "مدى رؤية الكاميرا (Camera FOV)",
   Range = {70, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "CameraFOVSlider",
   Callback = function(Value)
      Camera.FieldOfView = Value
   end,
})

WorldTab:CreateButton({
   Name = "تسريع اللعبة وتقليل اللاج (FPS Booster)",
   Callback = function()
      for _, v in pairs(Workspace:GetDescendants()) do
          if v:IsA("BasePart") then
              v.Material = Enum.Material.SmoothPlastic
          elseif v:IsA("Decal") or v:IsA("Texture") then
              v:Destroy()
          end
      end
      Rayfield:Notify({Title = "FPS Booster", Content = "تم تقليل الجرافيكس وتحسين الأداء!", Duration = 3})
   end,
})

-- ==================== TAB 6: أدوات ومرح 🛠️ ====================
local MiscTab = Window:CreateTab("أدوات ومرح 🛠️", 4483362458)

MiscTab:CreateButton({
   Name = "إعطاء أداة الانتقال (Click TP Tool)",
   Callback = function()
      local tpTool = Instance.new("Tool")
      tpTool.Name = "Click Teleport"
      tpTool.RequiresHandle = false
      tpTool.Activated:Connect(function()
          local mouse = LocalPlayer:GetMouse()
          if mouse and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
              LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
          end
      end)
      tpTool.Parent = LocalPlayer.Backpack
      Rayfield:Notify({Title = "Click TP", Content = "تمت إضافة الأداة إلى الحقيبة!", Duration = 3})
   end,
})

MiscTab:CreateButton({
   Name = "الانتقال إلى سيرفر آخر (Server Hop)",
   Callback = function()
      TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end,
})

MiscTab:CreateToggle({
   Name = "التدوير السريع (SpinBot)",
   CurrentValue = false,
   Flag = "SpinBotToggle",
   Callback = function(Value)
      SpinBotEnabled = Value
   end,
})

MiscTab:CreateSlider({
   Name = "سرعة التدوير",
   Range = {10, 100},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 20,
   Flag = "SpinSpeedSlider",
   Callback = function(Value)
      SpinSpeed = Value
   end,
})

-- ==================== RENDER LOOPS ====================

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    if SpinBotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
    end
end)

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    
    FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    FOVCircle.Visible = ShowFOV

    if ShowCrosshair then
        local viewportSize = Camera.ViewportSize
        local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
        CrosshairH.From = Vector2.new(center.X - 10, center.Y)
        CrosshairH.To = Vector2.new(center.X + 10, center.Y)
        CrosshairV.From = Vector2.new(center.X, center.Y - 10)
        CrosshairV.To = Vector2.new(center.X, center.Y + 10)
    end

    if HitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                p.Character.Head.Transparency = 0.5
                p.Character.Head.CanCollide = false
            end
        end
    end

    -- Aimbot & Silent Aim Loop
    if AimbotEnabled or SilentAimEnabled then
        local Closest = nil
        local Dist = FOVRadius

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local part = p.Character[TargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if d < Dist then
                        Closest = p
                        Dist = d
                    end
                end
            end
        end

        if Closest and Closest.Character and Closest.Character:FindFirstChild(TargetPart) then
            local targetPos = Closest.Character[TargetPart].Position
            if AimbotEnabled and (UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), Smoothness)
            end
        end
    end

    -- Radar Loop
    if ShowRadar and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = LocalPlayer.Character.HumanoidRootPart
        local radarPos = RadarBackground.Position

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = p.Character.HumanoidRootPart
                local relPos = targetRoot.Position - myRoot.Position
                local dist = Vector2.new(relPos.X, relPos.Z).Magnitude

                if not RadarDots[p] then
                    local dot = Drawing.new("Circle")
                    dot.Radius = 3
                    dot.Color = Color3.fromRGB(255, 0, 0)
                    dot.Filled = true
                    RadarDots[p] = dot
                end

                local dot = RadarDots[p]
                if dist <= 300 then
                    local angle = math.atan2(relPos.Z, relPos.X)
                    local scaledDist = (dist / 300) * 55
                    dot.Position = radarPos + Vector2.new(math.cos(angle) * scaledDist, math.sin(angle) * scaledDist)
                    dot.Visible = true
                else
                    dot.Visible = false
                end
            else
                if RadarDots[p] then RadarDots[p].Visible = false end
            end
        end
    end

    -- Highlight ESP Loop
    if ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not Highlights[p] or not Highlights[p].Parent then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(255, 50, 50)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.Parent = p.Character
                    Highlights[p] = h
                end
            end
        end
    end

    -- ESP Names Loop
    if ESPNamesEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") then
                local head = p.Character.Head
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if not ESPTextDrawings[p] then
                    local txt = Drawing.new("Text")
                    txt.Size = 16
                    txt.Center = true
                    txt.Outline = true
                    txt.Color = Color3.fromRGB(255, 255, 255)
                    ESPTextDrawings[p] = txt
                end

                local txt = ESPTextDrawings[p]
                if onScreen then
                    local dist = math.floor((head.Position - Camera.CFrame.Position).Magnitude)
                    txt.Text = p.Name .. " | " .. dist .. "m | HP: " .. math.floor(hum.Health)
                    txt.Position = Vector2.new(pos.X, pos.Y - 30)
                    txt.Visible = true
                else
                    txt.Visible = false
                end
            else
                if ESPTextDrawings[p] then ESPTextDrawings[p].Visible = false end
            end
        end
    end

    -- Tracers Loop
    if ESPTracersEnabled then
        local viewportSize = Camera.ViewportSize
        local bottomCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y)

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local root = p.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

                if not ESPTracerDrawings[p] then
                    local line = Drawing.new("Line")
                    line.Color = Color3.fromRGB(0, 255, 255)
                    line.Thickness = 1.5
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
