-- Jailbreak Auto-Rob & Movement Engine
-- تأكد من استخدام محقن يدعم الوظائف المتقدمة
loadstring(game:HttpGet("https://raw.githubusercontent.com/wawsdas/jailbreak/main/loader.lua"))()

-- إذا لم يعمل هذا الرابط، استخدم هذا السكربت المباشر للمميزات:
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Mansoori JB Engine | Auto-Rob",
    SubTitle = "by Hamdan",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto-Rob (سرقة تلقائية)", Icon = "scroll" }),
    Movement = Window:AddTab({ Title = "Movement (طيران)", Icon = "rocket" })
}

Tabs.Main:AddButton({
    Title = "تفعيل السرقة التلقائية (Auto Rob All)",
    Callback = function()
        -- هذا الكود يقوم بتفعيل نظام السرقة التلقائي المدمج
        local VirtualInputManager = game:GetService("VirtualInputManager")
        Fluent:Notify({Title = "System", Content = "جاري تفعيل نظام السرقة التلقائي.. يرجى الانتظار", Duration = 3})
        -- يتم استدعاء وظيفة السرقة من ملف الماب الأساسي
        loadstring(game:HttpGet("https://raw.githubusercontent.com/eduxg/Jailbreak-AutoRob/main/main.lua"))()
    end
})

Tabs.Movement:AddButton({
    Title = "تفعيل الطيران الاحترافي (Fly)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/corupted/fly/main/fly.lua"))()
    end
})
