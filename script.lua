local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "حمدان المنصوري | Jailbreak Ultimate Auto-Rob",
    SubTitle = "by Mansoori",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "السرقة التلقائية 💰", Icon = "scroll" }),
    Movement = Window:AddTab({ Title = "الطيران والحركة 🚀", Icon = "rocket" }),
    Settings = Window:AddTab({ Title = "الإعدادات ⚙️", Icon = "settings" })
}

-- تبويب السرقة التلقائية
Tabs.Main:AddParagraph({
    Title = "نظام السرقات الذكي",
    Content = "قم بتفعيل السرقة وسيقوم السكربت بالتحرك والتفاعل مع الأماكن تلقائياً."
})

Tabs.Main:AddButton({
    Title = "تفعيل Auto-Rob (سرقة البنك والمتحف تلقائياً)",
    Description = "يبدأ بتنفيذ مسار السرقات بنفسه",
    Callback = function()
        Fluent:Notify({ Title = "الحالة", Content = "جاري تفعيل نظام السرقة التلقائية...", Duration = 3 })
        -- محرك السرقة التلقائية المباشر
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/eduxg/Jailbreak-AutoRob/main/main.lua"))()
        end)
    end
})

Tabs.Main:AddButton({
    Title = "الخروج التلقائي من السجن (Auto Escape)",
    Callback = function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1175, 18, -1759)
            Fluent:Notify({ Title = "نجاح", Content = "تم إخراجك من السجن!", Duration = 2 })
        end
    end
})

-- تبويب الحركة والطيران
Tabs.Movement:AddButton({
    Title = "تفعيل الطيران الاحترافي (Fly V2)",
    Description = "يسمح لك بالطيران بحرية ودون أخطاء",
    Callback = function()
        Fluent:Notify({ Title = "الطيران", Content = "تم تفعيل محرك الطيران (استخدم مفاتيح WASD للتحرك)", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/corupted/fly/main/fly.lua"))()
        end)
    end
})

Tabs.Movement:AddSlider("SpeedSlider", {
    Title = "سرعة الشخصية",
    Description = "زيادة السرعة يدوياً",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end
})

-- تبويب الإعدادات
Tabs.Settings:AddButton({
    Title = "إغلاق السكربت بالكامل (Unload)",
    Callback = function()
        Window:Destroy()
    end
})

Fluent:Notify({
    Title = "تم تحميل السكربت بنجاح! 👑",
    Content = "مرحباً بك يا حمدان، السكربت جاهز للسيطرة على ماب جليبريك.",
    Duration = 5
})
