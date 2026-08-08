local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "حمدان المنصوري | Murderers VS Sheriffs 👑",
   Icon = 0,
   LoadingTitle = "Mansoori Hub | MVS Engine",
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
local ESPEnabled = false
local Highlights = {}
local AimbotEnabled = false
local FOVRadius = 150

-- ==================== TAB 1: ESP & كشف الأماكن (كشف القاتل) ====================
local ESPTab = Window:CreateTab("كشف الأماكن (ESP) 👁️", 4483362458)

ESPTab:CreateToggle({
   Name = "تفعيل كشف اللاعبين والأدوار (Highlight)",
   CurrentValue = false,
   Flag = "MVS_ESP",
   Callback = function(Value)
      ESPEnabled = Value
      if not ESPEnabled then
          for _, h in pairs(Highlights) do if h then h:Destroy() end end
          Highlights = {}
      end
   end,
})

-- ==================== TAB 2: القتال والتنشين (Aim) ====================
local AimTab = Window:CreateTab("التنشين الآلي 🎯", 4483362458)

AimTab:CreateToggle({
   Name = "تفعيل التنشين (Aimbot)",
   CurrentValue = false,
   Flag = "MVS_Aim",
   Callback = function(Value)
      AimbotEnabled = Value
   end,
})

AimTab:CreateSlider({
   Name = "حجم دائرة التنشين (FOV)",
   Range = {50, 400},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 150,
   Flag = "MVS_FOV",
   Callback = function(Value)
      FOVRadius = Value
   end,
})

-- ==================== LOOPS ====================

RunService.RenderStepped:Connect(function()
    -- ESP Logic
    if ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not Highlights[p] or not Highlights[p].Parent then
                    local h = Instance.new("Highlight")
                    -- تمييز الألوان: إذا كان يحمل سلاح أو قاتل يظهر بلون مختلف
                    h.FillColor = Color3.fromRGB(255, 50, 50)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.Parent = p.Character
                    Highlights[p] = h
                end
            end
        end
    end

    -- Aimbot Logic (عند الضغط على كليك يمين الماوس)
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local mousePos = UserInputService:GetMouseLocation()
        local Closest = nil
        local Dist = FOVRadius

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
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
end)
