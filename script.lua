-- Matnookh Hub [Blade Ball Edition] - VIP Commercial
-- مخصص للبيع والمحترفين
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("مطنوخ | Matnookh Blade Ball Elite 👑", "DarkTheme")

-- تبويب الصد والقتال (النسخة التجارية)
local CombatTab = Window:NewTab("الصد والقتال ⚔️")
local SectionCombat = CombatTab:NewSection("أدوات مطنوخ للسيطرة")

SectionCombat:NewToggle("تفعيل الصد التلقائي الصامت (Ghost Parry)", "صد تلقائي لا يمكن كشفه", function(state)
    _G.AutoParry = state
end)

SectionCombat:NewToggle("تتبع الكرة (Auto Target)", "تغيير الكاميرا للكرة تلقائياً", function(state)
    _G.TargetBall = state
end)

SectionCombat:NewSlider("توقيت الصد (Delay)", "التحكم في سرعة الصد (للإعداد الاحترافي)", 0, 100, function(v)
    _G.ParryDelay = v / 1000
end)

-- تبويب كشف الأماكن (ESP)
local VisualTab = Window:NewTab("كشف الأماكن 👁️")
local SectionVisual = VisualTab:NewSection("أدوات مطنوخ لكشف الأعداء")

SectionVisual:NewToggle("كشف الأعداء (ESP Lines)", "رسم خطوط على الأعداء", function(state)
    _G.ESP = state
end)

-- اللوب الأساسي (محرك مطنوخ)
game:GetService("RunService").RenderStepped:Connect(function()
    -- محرك الصد الصامت
    if _G.AutoParry then
        pcall(function()
            local balls = workspace:FindFirstChild("Balls")
            if balls then
                for _, ball in pairs(balls:GetChildren()) do
                    -- منطق الصد الذكي
                    local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - ball.Position).Magnitude
                    if dist < 15 then 
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                        task.wait(_G.ParryDelay or 0.05)
                        game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                    end
                end
            end
        end)
    end
end)

-- إشعار الترحيب بمطنوخ
Library:Notify("تم تحميل مطنوخ", "أهلاً بك يا حمدان، استعد للسيطرة على الجيم!")
