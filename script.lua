-- Matnookh Hub [Elite Blade Ball] 👑
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("مطنوخ | Matnookh Blade Ball Elite 👑", "DarkTheme")

-- التبويب الأول: الصد والقتال
local CombatTab = Window:NewTab("الصد والقتال ⚔️")
local SectionCombat = CombatTab:NewSection("أدوات مطنوخ للسيطرة")

_G.AutoParry = false
_G.AutoTarget = false
_G.ParryDelay = 0.05

SectionCombat:NewToggle("تفعيل الصد التلقائي (Ghost Parry)", "صد تلقائي للكرة باحترافية", function(state)
    _G.AutoParry = state
end)

SectionCombat:NewToggle("تتبع الكرة (Auto Target)", "توجيه الكاميرا نحو الكرة", function(state)
    _G.AutoTarget = state
end)

SectionCombat:NewSlider("توقيت الصد (Delay)", "سرعة الاستجابة بالملي ثانية", 100, 0, function(v)
    _G.ParryDelay = v / 1000
end)

-- التبويب الثاني: كشف الأماكن
local VisualTab = Window:NewTab("كشف الأماكن 👁️")
local SectionVisual = VisualTab:NewSection("أدوات كشف العدو")

_G.ESPEnabled = false
SectionVisual:NewToggle("كشف أماكن اللاعبين (ESP)", "إظهار أساطير الجيم", function(state)
    _G.ESPEnabled = state
end)

-- محرك التشغيل الخلفي (Engine Loop)
game:GetService("RunService").RenderStepped:Connect(function()
    -- محرك الصد التلقائي
    if _G.AutoParry then
        pcall(function()
            local balls = workspace:FindFirstChild("Balls")
            if balls then
                for _, ball in pairs(balls:GetChildren()) do
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local dist = (character.HumanoidRootPart.Position - ball.Position).Magnitude
                        if dist < 20 then
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                            task.wait(_G.ParryDelay or 0.05)
                            game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                        end
                    end
                end
            end
        end)
    end

    -- محرك تتبع الكرة للكاميرا
    if _G.AutoTarget then
        pcall(function()
            local balls = workspace:FindFirstChild("Balls")
            if balls then
                for _, ball in pairs(balls:GetChildren()) do
                    workspace.CurrentCamera.CameraSubject = ball
                end
            end
        end)
    else
        pcall(function()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
            end
        end)
    end
end)

Library:Notify("تم التفعيل", "مرحباً بك يا مطنوخ، السكربت جاهز للسيطرة!", 5)
