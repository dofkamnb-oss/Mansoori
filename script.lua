local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | Jailbreak Ultimate Hub 👑",
   Icon = 0,
   LoadingTitle = "Mansoori Jailbreak Engine",
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
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- Variables
local NoclipEnabled = false
local FullbrightEnabled = false
local InfiniteJumpEnabled = false
local FlyEnabled = false
local FlySpeed = 50

-- ==================== TAB 1: السرقات والأماكن (Teleports) ====================
local RobTab = Window:CreateTab("السرقات والأماكن 💰", 4483362458)

RobTab:CreateSection("الانتقال السريع لأماكن السرقة")

RobTab:CreateButton({
   Name = "الذهاب إلى البنك (Bank)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1048, 18, 1253)
         Rayfield:Notify({Title = "نجاح", Content = "تم نقلك إلى البنك!", Duration = 3})
      end
   end,
})

RobTab:CreateButton({
   Name = "الذهاب إلى المتحف (Museum)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1065, 115, 1205)
         Rayfield:Notify({Title = "نجاح", Content = "تم نقلك إلى المتحف!", Duration = 3})
      end
   end,
})

RobTab:CreateButton({
   Name = "الذهاب إلى الكازينو (Casino)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1131, 19, 1258)
         Rayfield:Notify({Title = "نجاح", Content = "تم نقلك إلى الكازينو!", Duration = 3})
      end
   end,
})

RobTab:CreateButton({
   Name = "الذهاب إلى محطة الطاقة (Power Plant)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(52, 19, 2195)
         Rayfield:Notify({Title = "نجاح", Content = "تم نقلك إلى محطة الطاقة!", Duration = 3})
      end
   end,
})

RobTab:CreateSection("قواعد الخروج والسجن")

RobTab:CreateButton({
   Name = "الخروج من السجن فوراً (Escape Prison)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1175, 18, -1759)
         Rayfield:Notify({Title = "نجاح", Content = "تم إخراجك خارج السجن بنجاح!", Duration =.3})
      end
   end,
})

-- ==================== TAB 2: الحركة والسرعة (Movement) ====================
local MoveTab = Window:CreateTab("الحركة والسرعة ⚡", 4483362458)

MoveTab:CreateSlider({
   Name = "سرعة الشخصية (WalkSpeed)",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "JB_Speed",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
      end
   end,
})

MoveTab:CreateSlider({
   Name = "قوة القفز (JumpPower)",
   Range = {50, 300},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JB_Jump",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
      end
   end,
})

MoveTab:CreateToggle({
   Name = "اختراق الجدران والسيارات (Noclip)",
   CurrentValue = false,
   Flag = "JB_Noclip",
   Callback = function(Value)
      NoclipEnabled = Value
   end,
})

MoveTab:CreateToggle({
   Name = "القفز اللانهائي في الهواء (Inf Jump)",
   CurrentValue = false,
   Flag = "JB_InfJump",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end,
})

-- ==================== TAB 3: العالم والبيئة (World) ====================
local WorldTab = Window:CreateTab("العالم 🌐", 4483362458)

WorldTab:CreateToggle({
   Name = "إضاءة كاملة وإزالة الظلام (Fullbright)",
   CurrentValue = false,
   Flag = "JB_Fullbright",
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
   Name = "مدى زاوية الرؤية (Camera FOV)",
   Range = {70, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "JB_FOV",
   Callback = function(Value)
      Camera.FieldOfView = Value
   end,
})

-- ==================== LOOPS & SYSTEM LOGIC ====================

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
