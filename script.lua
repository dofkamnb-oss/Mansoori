-- التأكد من تحميل اللاعب
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- إنشاء واجهة التحكم (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ControlPanelGui"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Roblox Control Panel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- زر سرعة المشي
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.9, 0, 0, 40)
SpeedBox.Position = UDim2.new(0.05, 0, 0.2, 0)
SpeedBox.PlaceholderText = "اكتب سرعة المشي هنا (مثال: 50)"
SpeedBox.Text = ""
SpeedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextSize = 14
SpeedBox.Parent = MainFrame

SpeedBox.FocusLost:Connect(funtion(enterPressed)
    if enterPressed then
        local num = tonumber(SpeedBox.Text)
        if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = num
        end
    end
end)

-- متغيرات الطيران
local flying = false
local flySpeed = 50
local bne, bg

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0.9, 0, 0, 40)
FlyButton.Position = UDim2.new(0.05, 0, 0.4, 0)
FlyButton.Text = "تشغيل/إيقاف الطيران: معطل"
FlyButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 14
FlyButton.Parent = MainFrame

FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        FlyButton.Text = "تشغيل/إيقاف الطيران: مفعل"
        FlyButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        -- كود الطيران البسيط
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            bg = Instance.new("BodyGyro", hrp)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e4, 9e4, 9e4)
            bne = Instance.new("BodyVelocity", hrp)
            bne.Velocity = Vector3.new(0, 0.1, 0)
            bne.maxForce = Vector3.new(9e4, 9e4, 9e4)
        end
    else
        FlyButton.Text = "تشغيل/إيقاف الطيران: معطل"
        FlyButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        if bg then bg:Destroy() end
        if bne then bne:Destroy() end
    end
end)

-- زر الأيم بوت (Aimbot أساسي أقرب لاعب)
local aimbotEnabled = false
local AimbotButton = Instance.new("TextButton")
AimbotButton.Size = UDim2.new(0.9, 0, 0, 40)
AimbotButton.Position = UDim2.new(0.05, 0, 0.6, 0)
AimbotButton.Text = "الأيم بوت: معطل"
AimbotButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.TextSize = 14
AimbotButton.Parent = MainFrame

AimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        AimbotButton.Text = "الأيم بوت: مفعل"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        AimbotButton.Text = "الأيم بوت: معطل"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local nearestTarget = nil
        local shortestDistance = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    nearestTarget = hrp
                end
            end
        end
        if nearestTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, nearestTarget.Position)
        end
    end
end)
