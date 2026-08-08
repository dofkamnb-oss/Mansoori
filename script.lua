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

-- Variables
local NoclipEnabled = false
local FullbrightEnabled = false
local InfiniteJumpEnabled = false

-- ==================== TAB 1: السرقة والسيارات 💰 ====================
local RobTab = Window:CreateTab("السرقات 💰", 4483362458)

RobTab:CreateButton({
   Name = "الذهاب إلى البنك (Bank Teleport)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1048, 18, 1253)
         Rayfield:Notify({Title = "Teleport", Content = "تم نقلك إلى البنك بنجاح!", Duration = 3})
      end
   end,
})

RobTab:CreateButton({
   Name = "الذهاب إلى المتحف (Museum Teleport)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1065, 115, 1205)
         Rayfield:Notify({Title = "Teleport", Content = "تم نقلك إلى المتحف بنجاح!", Duration = 3})
      end
   end,
})

RobTab:CreateButton({
   Name = "الذهاب إلى محطة النطاق / البنزين",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1625, 20, 723)
         Rayfield:Notify({Title = "Teleport", Content = "تم نقلك إلى موقع السرقة!", Duration = 3})
      end
   end,
})

-- ==================== TAB 2: الحركة والسرعة ⚡ ====================
local MoveTab = Window:CreateTab("الحركة ⚡", 4483362458)

MoveTab:CreateSlider({
   Name = "سرعة الشخصية (WalkSpeed)",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "JailbreakSpeed",
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
   Flag = "JailbreakJump",
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
   Name = "القفز اللانهائي في الهواء",
   CurrentValue = false,
   Flag = "JB_InfJump",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end,
})

-- ==================== TAB 3: العالم 🌐 ====================
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

-- ==================== LOOPS ====================

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
