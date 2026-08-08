local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | Keyboard Escape Hub 👑",
   Icon = 0,
   LoadingTitle = "Mansoori Speed Engine",
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

-- Variables
local AutoFarmSpeed = false
local AutoRebirth = false
local WalkSpeedValue = 500

-- ==================== TAB 1: الزراعة والسرعة (Auto Farm) ====================
local FarmTab = Window:CreateTab("السرعة والتجميع ⚡", 4483362458)

FarmTab:CreateToggle({
   Name = "تفعيل زيادة السرعة التلقائية (Auto Speed)",
   CurrentValue = false,
   Flag = "KB_AutoSpeed",
   Callback = function(Value)
      AutoFarmSpeed = Value
   end,
})

FarmTab:CreateSlider({
   Name = "قوة السرعة اليدوية (WalkSpeed)",
   Range = {16, 5000},
   Increment = 50,
   Suffix = "Speed",
   CurrentValue = 100,
   Flag = "KB_CustomSpeed",
   Callback = function(Value)
      WalkSpeedValue = Value
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
      end
   end,
})

FarmTab:CreateToggle({
   Name = "القفز اللانهائي (Infinite Jump)",
   CurrentValue = false,
   Flag = "KB_InfJump",
   Callback = function(Value)
      _G.InfJump = Value
   end,
})

-- ==================== TAB 2: العالم والمساعدة (World) ====================
local WorldTab = Window:CreateTab("المساعدة والعالم 🌐", 4483362458)

WorldTab:CreateToggle({
   Name = "إضاءة كاملة وإزالة الظلام (Fullbright)",
   CurrentValue = false,
   Flag = "KB_Fullbright",
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

WorldTab:CreateButton({
   Name = "إغلاق السكربت (Unload)",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- ==================== LOOPS ====================

RunService.RenderStepped:Connect(function()
    -- Auto Speed Loop
    if AutoFarmSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = WalkSpeedValue
    end
end)

-- Inf Jump Logic
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
