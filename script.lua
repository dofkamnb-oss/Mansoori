-- Keyboard Escape Pro Script - Mansoori Hub
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | Keyboard Escape 👑",
   LoadingTitle = "ماب الكيبورد والسرعة",
   LoadingSubtitle = "by Mansoori",
   Theme = "Default",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local Tab = Window:CreateTab("التحكم بالسرعة ⚡", 4483362458)

local SpeedEnabled = false
local CustomSpeedValue = 1000

Tab:CreateToggle({
   Name = "تفعيل السرعة الخارقة (Auto Speed)",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      SpeedEnabled = Value
   end,
})

Tab:CreateSlider({
   Name = "قوة السرعة (WalkSpeed)",
   Range = {50, 50000},
   Increment = 100,
   Suffix = "Speed",
   CurrentValue = 1000,
   Flag = "SpeedSlider",
   Callback = function(Value)
      CustomSpeedValue = Value
   end,
})

Tab:CreateToggle({
   Name = "القفز اللانهائي (Inf Jump)",
   CurrentValue = false,
   Flag = "JumpToggle",
   Callback = function(Value)
      _G.InfJump = Value
   end,
})

Tab:CreateButton({
   Name = "تخطي ونقل إلى نهاية الماب (Teleport to End)",
   Callback = function()
      pcall(function()
         for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():find("end") or v.Name:lower():find("win") or v.Name:lower():find("finish") then
               if v:IsA("BasePart") then
                  LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 5, 0)
                  Rayfield:Notify({Title = "تم بنجاح", Content = "تم نقلك لنهاية المرحلة!", Duration = 3})
                  break
               end
            end
         end
      end)
   end,
})

RunService.RenderStepped:Connect(function()
   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
      LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = CustomSpeedValue
   end
end)

UserInputService.JumpRequest:Connect(function()
   if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
      LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

Rayfield:Notify({Title = "مرحباً يا حمدان 👑", Content = "تم تحميل سكربت الكيبورد بنجاح!", Duration = 5})
