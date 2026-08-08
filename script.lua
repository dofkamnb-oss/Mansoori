-- +1 Speed Keyboard Escape Script - Mansoori Hub
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- تحميل واجهة Rayfield الفخمة
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | Keyboard Escape Pro 👑",
   LoadingTitle = "جاري تحميل ماب الكيبورد والحلويات...",
   LoadingSubtitle = "by Mansoori",
   Theme = "Default",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local Tab = Window:CreateTab("السرعة والهروب ⚡", 4483362458)

local SpeedEnabled = false
local CustomSpeedValue = 1000

Tab:CreateToggle({
   Name = "تفعيل زيادة السرعة الخارقة (Auto Speed)",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      SpeedEnabled = Value
   end,
})

Tab:CreateSlider({
   Name = "قوة السرعة (WalkSpeed)",
   Range = {50, 10000},
   Increment = 50,
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

-- اللوب لتطبيق السرعة والقفز
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

Rayfield:Notify({Title = "مرحباً يا حمدان 👑", Content = "تم تفعيل سكربت ماب الكيبورد بنجاح!", Duration = 5})
