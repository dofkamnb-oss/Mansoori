-- // Mansoori Hub | Safe Edition (No Drawing Errors)
-- // Developer: alain20103

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mansoori Hub | Safe Edition",
   LoadingTitle = "جاري تحميل Mansoori Hub...",
   LoadingSubtitle = "by alain20103",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MansooriConfigs",
      FileName = "SafeConfig"
   },
   KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // الرئيسية والمعلومات
local InfoTab = Window:CreateTab("الرئيسية والمعلومات", 4483345998)

local GlobalStartTime = tick()
local UptimeLabel = InfoTab:CreateParagraph({Title = "وقت التشغيل العام", Content = "جاري الحساب..."})
local PlayerCountLabel = InfoTab:CreateParagraph({Title = "عدد اللاعبين في السيرفر", Content = "جاري الحساب..."})

task.spawn(function()
    while task.wait(1) do
        local elapsed = math.floor(tick() - GlobalStartTime)
        local minutes = math.floor(elapsed / 60)
        local seconds = elapsed % 60
        UptimeLabel:Set({Title = "وقت التشغيل العام", Content = string.format("الوقت المنقضي: %d دقيقة و %d ثانية", minutes, seconds)})
        
        local count = #Players:GetPlayers()
        PlayerCountLabel:Set({Title = "عدد اللاعبين في السيرفر", Content = "اللاعبين المتواجدين حالياً: " .. count})
    end
end)

local AFKStartTime = 0
local AFKActive = false
local AFKTimerLabel = InfoTab:CreateParagraph({Title = "عداد وقت الـ AFK", Content = "وضع AFK معطل حالياً"})

InfoTab:CreateToggle({
   Name = "تفعيل وضع الحماية من الخروج (Anti-AFK)",
   CurrentValue = false,
   Callback = function(Value)
      AFKActive = Value
      if Value then
          AFKStartTime = tick()
          Rayfield:Notify({Title = "Anti-AFK", Content = "تم تفعيل وضع AFK وبدأ احتساب الوقت!", Duration = 3})
      else
          AFKTimerLabel:Set({Title = "عداد وقت الـ AFK", Content = "وضع AFK معطل حالياً"})
      end
      
      local vu = game:GetService("VirtualUser")
      LocalPlayer.Idled:Connect(function()
         if AFKActive then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
         end
      end)
   end,
})

task.spawn(function()
    while task.wait(1) do
        if AFKActive then
            local afkElapsed = math.floor(tick() - AFKStartTime)
            local afkMins = math.floor(afkElapsed / 60)
            local afkSecs = afkElapsed % 60
            AFKTimerLabel:Set({Title = "عداد وقت الـ AFK", Content = string.format("مدة العمل في وضع AFK: %d دقيقة و %d ثانية", afkMins, afkSecs)})
        end
    end
end)

-- // مطور السكربت
local DevTab = Window:CreateTab("مطور السكربت", 7072725342)

DevTab:CreateParagraph({
   Title = "معلومات المطور الرسمي", 
   Content = "تم برمجة وتطوير هذا المنيو بواسطة:\n\nالاسم / اليوزر: alain20103\n\nجميع الحقوق محفوظة لصاحب السكربت."
})

DevTab:CreateButton({
   Name = "نسخ يوزر المطور (alain20103)",
   Callback = function()
      if setclipboard then
         setclipboard("alain20103")
         Rayfield:Notify({Title = "تم النسخ", Content = "تم نسخ يوزر alain20103 إلى الحافظة بنجاح!", Duration = 3})
      end
   end,
})

-- // القتال والأيم بوت
local CombatTab = Window:CreateTab("القتال والأيم بوت", 7072718336)
local AimbotEnabled = false

CombatTab:CreateToggle({
   Name = "تفعيل الإيم بوت (كليك يمين)",
   CurrentValue = false,
   Callback = function(Value)
      AimbotEnabled = Value
   end,
})

local Locking = false
local TargetPlayer = nil

local function GetClosestToCursor()
    local target = nil
    local shortestDist = 200
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    target = p
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled and Locking and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetPlayer.Character.Head.Position)
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 and AimbotEnabled then
        TargetPlayer = GetClosestToCursor()
        if TargetPlayer then Locking = true end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Locking = false
        TargetPlayer = nil
    end
end)

CombatTab:CreateSlider({
   Name = "تكبير الهيت بوكس (Hitbox Expander)",
   Range = {2, 30},
   Increment = 1,
   CurrentValue = 2,
   Callback = function(Value)
      _G.HBSize = Value
      task.spawn(function()
          while task.wait(1) do
              if not _G.HBSize or _G.HBSize <= 2 then break end
              for _, p in pairs(Players:GetPlayers()) do
                  if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                      p.Character.HumanoidRootPart.Size = Vector3.new(_G.HBSize, _G.HBSize, _G.HBSize)
                      p.Character.HumanoidRootPart.Transparency = 0.6
                      p.Character.HumanoidRootPart.CanCollide = false
                  end
              end
          end
      end)
   end,
})

-- // الرؤية والـ ESP
local VisualsTab = Window:CreateTab("الرؤية والـ ESP", 7072727157)

VisualsTab:CreateToggle({
   Name = "تفعيل ESP (Highlight)",
   CurrentValue = false,
   Callback = function(Value)
      _G.EnhancedESP = Value
      task.spawn(function()
          while _G.EnhancedESP do
              task.wait(1)
              for _, p in pairs(Players:GetPlayers()) do
                  if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("MansooriESP") then
                      local hl = Instance.new("Highlight")
                      hl.Name = "MansooriESP"
                      hl.FillColor = Color3.fromRGB(0, 170, 255)
                      hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                      hl.FillTransparency = 0.4
                      hl.Parent = p.Character
                  end
              end
          end
          if not _G.EnhancedESP then
              for _, p in pairs(Players:GetPlayers()) do
                  if p.Character and p.Character:FindFirstChild("MansooriESP") then
                      p.Character.MansooriESP:Destroy()
                  end
              end
          end
      end)
   end,
})

-- // الحركة
local PlayerTab = Window:CreateTab("اللاعب والحركة", 7072719002)

PlayerTab:CreateSlider({
   Name = "سرعة المشي (WalkSpeed)",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "قوة القفز (JumpPower)",
   Range = {50, 300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "قفز لانهائي (Infinite Jump)",
   CurrentValue = false,
   Callback = function(Value)
      _G.InfJump = Value
      UserInputService.JumpRequest:Connect(function()
         if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
            LocalPlayer.Character.Humanoid:ChangeState('Jumping')
         end
      end)
   end,
})

PlayerTab:CreateToggle({
   Name = "المرور عبر الجدران (Noclip)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Noclip = Value
      RunService.Stepped:Connect(function()
         if _G.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
               if v:IsA("BasePart") then
                  v.CanCollide = false
               end
            end
         end
      end)
   end,
})

PlayerTab:CreateToggle({
   Name = "الطيران (Fly)",
   CurrentValue = false,
   Callback = function(Value)
      _G.FlyActive = Value
      local char = LocalPlayer.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      local hrp = char.HumanoidRootPart
      
      if _G.FlyActive then
         local bv = Instance.new("BodyVelocity")
         bv.Name = "MansooriFlyVelocity"
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         bv.Velocity = Vector3.new(0, 0, 0)
         bv.Parent = hrp
         
         task.spawn(function()
             while _G.FlyActive and char and char:FindFirstChild("HumanoidRootPart") do
                 task.wait()
                 local vel = Vector3.new()
                 if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + Camera.CFrame.LookVector end
                 if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - Camera.CFrame.LookVector end
                 if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + Camera.CFrame.RightVector end
                 if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - Camera.CFrame.RightVector end
                 bv.Velocity = vel * 60
             end
             if hrp:FindFirstChild("MansooriFlyVelocity") then
                 hrp.MansooriFlyVelocity:Destroy()
             end
         end)
      else
         if hrp:FindFirstChild("MansooriFlyVelocity") then
             hrp.MansooriFlyVelocity:Destroy()
         end
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "منع السقوط أو الموت في الفراغ (Anti-Void)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AntiVoid = Value
      task.spawn(function()
          while _G.AntiVoid do
              task.wait(0.5)
              if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                  if LocalPlayer.Character.HumanoidRootPart.Position.Y < -50 then
                      LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
                  end
              end
          end
      end)
   end,
})

PlayerTab:CreateButton({
   Name = "إعادة الصحة كاملة (Heal)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
      end
   end,
})

-- // الإعدادات والتحكم
local SettingsTab = Window:CreateTab("الإعدادات والتحكم", 7072727157)

SettingsTab:CreateButton({
   Name = "إخفاء / إظهار المنيو (Hide / Show UI)",
   Callback = function()
      Rayfield:ToggleUI()
   end,
})

SettingsTab:CreateButton({
   Name = "إغلاق السكربت بالكامل",
   Callback = function()
      Rayfield:Destroy()
   end,
})

Rayfield:LoadConfiguration()
