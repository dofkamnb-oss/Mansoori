local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | Keyboard Escape Pro 👑",
   Icon = 0,
   LoadingTitle = "Keyboard Escape Engine",
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

-- Variables
local AutoSpeed = false
local InfiniteSpeedValue = 10000
local AutoWinEnabled = false

-- ==================== TAB 1: الفوز والسرعة (Auto Farm) ====================
local MainTab = Window:CreateTab("السرعة الفورية ⚡", 4483362458)

MainTab:CreateToggle({
   Name = "تفعيل السرعة اللانهائية (Infinite Speed)",
   CurrentValue = false,
   Flag = "KB_InfSpeed",
   Callback = function(Value)
      AutoSpeed = Value
   end,
})

MainTab:CreateSlider({
   Name = "قوة السرعة الخارقة",
   Range = {100, 50000},
   Increment = 500,
   Suffix = "Speed",
   CurrentValue = 5000,
   Flag = "KB_SpdVal",
   Callback = function(Value)
      InfiniteSpeedValue = Value
   end,
})

MainTab:CreateToggle({
   Name = "القفز اللانهائي (Inf Jump)",
   CurrentValue = false,
   Flag = "KB_Jump",
   Callback = function(Value)
      _G.InfJump = Value
   end,
})

-- ==================== TAB 2: التليبرورت ونهاية الماب (Teleports) ====================
local TeleportTab = Window:CreateTab("تخطّي المراحل 🏁", 4483362458)

TeleportTab:CreateButton({
   Name = "الانتقال إلى نهاية المرحلة الحالية (Teleport to End)",
   Callback = function()
      -- محاولة البحث عن نهاية الماب أو البوابات ونقل اللاعب لها
      pcall(function()
         for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("end") or obj.Name:lower():find("finish") or obj.Name:lower():find("win") then
               if obj:IsA("BasePart") then
                  LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                  break
               end
            end
         end
      end)
   end,
})

TeleportTab:CreateToggle({
   Name = "تثبيت السرعة والتخطي التلقائي",
   CurrentValue = false,
   Flag = "AutoWin",
   Callback = function(Value)
      AutoWinEnabled = Value
   end,
})

-- ==================== LOOPS ====================

RunService.RenderStepped:Connect(function()
    if AutoSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = InfiniteSpeedValue
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
