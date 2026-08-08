local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | زايد المزروعي 👑",
   Icon = 0,
   LoadingTitle = "Mansoori Hub",
   LoadingSubtitle = "by Mansoori",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- Tab 1: اللاعب والسرعة
local MainTab = Window:CreateTab("الرئيسية ⚡", 4483362458)

MainTab:CreateSlider({
   Name = "السرعة (WalkSpeed)",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
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
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
      end
   end,
})

local NoclipEnabled = false
MainTab:CreateToggle({
   Name = "اختراق الجدران (Noclip)",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      NoclipEnabled = Value
   end,
})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, p in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

local Flying = false
local FlySpeed = 50
local flyConnection

MainTab:CreateToggle({
   Name = "الطيران (Fly)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      Flying = Value
      local LocalPlayer = game.Players.LocalPlayer
      local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
      local root = char:FindFirstChild("HumanoidRootPart")
      local hum = char:FindFirstChildOfClass("Humanoid")

      if Flying then
          if hum then hum.PlatformStand = true end
          if flyConnection then flyConnection:Disconnect() end
          flyConnection = game:GetService("RunService").RenderStepped:Connect(function(delta)
              if not Flying or not char or not root then
                  if flyConnection then flyConnection:Disconnect() end
                  if hum then hum.PlatformStand = false end
                  return
              end

              local moveDir = Vector3.zero
              local Camera = workspace.CurrentCamera
              local UserInputService = game:GetService("UserInputService")
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

-- Tab 2: القتال والـ ESP
local CombatTab = Window:CreateTab("القتال 🎯", 4483362458)

local AimbotEnabled = false
CombatTab:CreateToggle({
   Name = "Aimbot (اضغط E أو زر الماوس الأيمن)",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      AimbotEnabled = Value
   end,
})

game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotEnabled then
        local UserInputService = game:GetService("UserInputService")
        if UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local LocalPlayer = game.Players.LocalPlayer
            local Camera = workspace.CurrentCamera
            local Closest = nil
            local Dist = 300
            local MousePos = UserInputService:GetMouseLocation()

            for _, p in pairs(game.Players:GetPlayers()) do
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

            if Closest and Closest.Character and Closest.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Closest.Character.Head.Position)
            end
        end
    end
end)

local ESPEnabled = false
local Highlights = {}
CombatTab:CreateToggle({
   Name = "كشف اللاعبين (ESP)",
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

game:GetService("RunService").RenderStepped:Connect(function()
    if ESPEnabled then
        local LocalPlayer = game.Players.LocalPlayer
        for _, p in pairs(game.Players:GetPlayers()) do
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
