-- // ==========================================
-- // 1. Da Hood Place Verification & Anti-Cheat / Metamethods
-- // ==========================================
if (game.PlaceId ~= 2788229376) then
    return
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local MainEvent = ReplicatedStorage:WaitForChild("MainEvent", 5)

-- حماية الـ MainEvent (Da Hood Anti-Cheat Bypass)
local Flags = {
    "CHECKER_1",
    "TeleportDetect",
    "OneMoreTime",
    "CHECKER",
    "MouseUpdatedPos"
}

local mt = getrawmetatable(game)
local backupnamecall = mt.__namecall
local backupnewindex = mt.__newindex
local backupindex = mt.__index 
setreadonly(mt, false)

mt.__namecall = newcclosure(function(...)
    local args = {...}
    local self = args[1]
    local method = getnamecallmethod()

    if (method == "FireServer" and self == MainEvent and table.find(Flags, args[2])) then
        return nil
    end

    if (not checkcaller() and getfenv(2).crash) then
        local fenv = getfenv(2)
        fenv.crash = function() end
        setfenv(2, fenv)
    end

    return backupnamecall(...)
end)

mt.__newindex = newcclosure(function(t, k, v)
    if (not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower")) then
        return
    end
    return backupnewindex(t, k, v)
end)


-- // ==========================================
-- // 2. Valiant ENV & Weapon Combat Mods
-- // ==========================================
pcall(function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/ValiantENV.lua"))()
end)

local Backpack = LocalPlayer.Backpack
local changeVals = {
    BulletSpread = 0,
    MaxSpread = 0,
    ChargeRate = math.huge,
    MaxDistance = math.huge,
    RecoilMin = 0,
    RecoilMax = 0,
    TotalRecoilMax = 0,
    GravityFactor = 0.01,
    ShotCooldown = 0,
    FireMode = "Automatic"
}
local autoReload = true
local WeaponsSystem = ReplicatedStorage:FindFirstChild("WeaponsSystem")
local Network = WeaponsSystem and WeaponsSystem:FindFirstChild("Network")
local WeaponReloadRequest = Network and Network:FindFirstChild("WeaponReloadRequest")
local WeaponHit = Network and Network:FindFirstChild("WeaponHit")

local function equipTool(targetTool)
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if Backpack:FindFirstChild(targetTool) and humanoid then
        humanoid:EquipTool(Backpack[targetTool])
        return true
    elseif char and char:FindFirstChild(targetTool) then
        return true
    end
    return false
end

local function getWeapon(Player, targetWeapon)
    if targetWeapon then
        repeat task.wait() until equipTool("AWM")
    end
    local char = Player.Character
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") then
                if targetWeapon and v.Name == targetWeapon then
                    return v
                elseif not targetWeapon then
                    return v 
                end
            end
        end
    end
end

local function killAll()
    repeat task.wait() until getWeapon(LocalPlayer, "AWM")
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and not v.Character:FindFirstChild("ForceField") then
            local head = v.Character:FindFirstChild("Head")
            local humanoidRootPart = v.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = v.Character:FindFirstChildOfClass("Humanoid")
            if head and humanoidRootPart and humanoid and WeaponHit then
                local Arg1 = getWeapon(LocalPlayer, "AWM")
                local Arg2 = {
                    ["p"] = head.Position,
                    ["pid"] = 1,
                    ["part"] = humanoidRootPart,
                    ["d"] = 0.1,
                    ["maxDist"] = 0.06,
                    ["h"] = humanoid,
                    ["m"] = Enum.Material.Plastic,
                    ["sid"] = 1,
                    ["t"] = 0.006,
                    ["n"] = head.Position,
                }
                WeaponHit:FireServer(Arg1, Arg2)
            end
        end
    end
end

local function doGunMods()
    repeat task.wait() until getWeapon(LocalPlayer)
    for _, Obj in pairs(getgc(true)) do
        if type(Obj) == "table" then
            for i, v in pairs(changeVals) do
                if rawget(Obj, i) then
                    rawset(Obj, i, v)
                end
            end
        end
    end
end


-- // ==========================================
-- // 3. Silent Aim & ESP Modules
-- // ==========================================
local AimHacks = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/Experimental%20Silent%20Aim%20Module.lua"))()
AimHacks["TeamCheck"] = false

mt.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" then
        local remoteName = tostring(args[1])
        if remoteName == "MainEvent" then
            if args[2] == "TeleportDetect" or args[2] == 'TeleportDetect' or args[2] == 'CHECKER' or args[2] == 'OneMoreTime' then
                return nil
            end
            if args[2] == "MouseUpdatedPos" and typeof(args[3]) == "Vector3" and AimHacks.checkSilentAim() then
                local targetChar = AimHacks["Selected"] and AimHacks["Selected"].Character
                if targetChar and targetChar:FindFirstChild("Head") then
                    return targetChar.Head.Position
                end
            end
        end
    end
    return backupnamecall(...)
end)

mt.__index = newcclosure(function(t, k)
    local Mouse = LocalPlayer:GetMouse()
    if t == Mouse and (k == "Target" or k == "Hit") and AimHacks.checkSilentAim() then
        local targetChar = AimHacks["Selected"] and AimHacks["Selected"].Character
        if targetChar and targetChar:FindFirstChild("Head") then
            local CPlayer = targetChar.Head
            return (k == "Target" and CPlayer or CPlayer.Position)
        end
    end
    return backupindex(t, k)
end)

loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/ESP/Player%20ESP.lua"))()


-- // ==========================================
-- // 4. Da Hood Protections, Teleports & Collectors
-- // ==========================================
getgenv().BypassFlyDaHood = false

local function removeRagdolls()
    local Character = LocalPlayer.Character
    if Character and Character:FindFirstChild("RagdollConstraints") then
        for _, v in pairs(Character.RagdollConstraints:GetChildren()) do
            v.Enabled = false
        end
    end
end

local function protections()
    local Character = LocalPlayer.Character
    if not Character then return end
    local Humanoid = Character:WaitForChild("Humanoid", 5)
    if not Humanoid then return end

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

    for _, v in pairs(Character:GetDescendants()) do
        if v:IsA("Accessory") or (v:IsA("Decal") and v.Name == 'face') then
            v:Destroy()
        elseif v:IsA("MeshPart") then
            v.Color = Color3.fromRGB(255, 255, 255)
        end
    end

    removeRagdolls()
    local bodyEffects = Character:FindFirstChild("BodyEffects")
    if bodyEffects and bodyEffects:FindFirstChild("Movement") then
        bodyEffects.Movement.DescendantAdded:Connect(function(descendant)
            task.wait()
            descendant:Destroy()
        end)
    end
end

local function Teleport(_CFrame, Status)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end
    if Status then
        for i = 0, 1, 0.1 do
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:lerp(_CFrame, i)
            task.wait()
        end
    else
        HumanoidRootPart.CFrame = _CFrame
    end
end

-- Anti Fly Bypass Loop
coroutine.wrap(function()
    while task.wait(0.1) do
        if getgenv().BypassFlyDaHood then
            for _, v in ipairs(getgc()) do 
                if type(v) == "function" then
                    local info = debug.getinfo(v)
                    if info and info.name == 'crash' then
                        pcall(function()
                            getfenv(v).script:Destroy()
                        end)
                    end
                end
            end
        end
    end
end)()

UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
    if not gameProcessedEvent then
        if inputObject.KeyCode == Enum.KeyCode.F7 then
            getgenv().BypassFlyDaHood = not getgenv().BypassFlyDaHood
            print("Bypass TP Status: "..(getgenv().BypassFlyDaHood and "Enabled" or "Disabled"))
        elseif inputObject.KeyCode == Enum.KeyCode.F1 then
            killAll()
        elseif inputObject.KeyCode == Enum.KeyCode.F2 then
            autoReload = not autoReload
        elseif inputObject.KeyCode == Enum.KeyCode.F3 then
            AimHacks["SilentAimEnabled"] = not AimHacks["SilentAimEnabled"]
        elseif inputObject.KeyCode == Enum.KeyCode.F4 then
            if PlayerESP then PlayerESP["Enabled"] = not PlayerESP["Enabled"] end
        end
    end
end)


-- // ==========================================
-- // 5. Aim Tracer / Beam System
-- // ==========================================
local Terrain = Workspace.Terrain
local Colours = {
    At = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(1, 0, 0)),
    Away = ColorSequence.new(Color3.new(0, 1, 0), Color3.new(0, 1, 0))
}

local function IsBeamHit(Beam, MousePos)
    local Character = LocalPlayer.Character
    local Attachment = Beam.Attachment1
    if not Attachment then return end

    local Origin = Beam.Attachment0.WorldPosition
    local Direction = MousePos - Origin

    local raycastParms = RaycastParams.new()
    raycastParms.FilterDescendantsInstances = {Character, Workspace.CurrentCamera}
    local RaycastResult = Workspace:Raycast(Origin, Direction * 2, raycastParms)
    
    if (not RaycastResult) then
        Beam.Color = Colours.Away
        Attachment.WorldPosition = MousePos
        return
    end

    if (Character) then
        Beam.Color = RaycastResult.Instance:IsDescendantOf(Character) and Colours.At or Colours.Away
    end

    Attachment.WorldPosition = RaycastResult.Position
end

local function CreateBeam(Character)
    local head = Character:WaitForChild("Head", 5)
    local attachment0 = head and head:WaitForChild("FaceCenterAttachment", 5)
    if not attachment0 then return end

    local Beam = Instance.new("Beam", Character)
    Beam.Attachment0 = attachment0
    local gunScript = Character:FindFirstChild("GunScript", true)
    Beam.Enabled = gunScript ~= nil
    Beam.Width0 = 0.1
    Beam.Width1 = 0.1

    return Beam
end

local function OnCharacter(Character)
    if (not Character) then return end

    local bodyEffects = Character:WaitForChild("BodyEffects", 5)
    local MousePos = bodyEffects and bodyEffects:WaitForChild("MousePos", 5)
    if not MousePos then return end

    local Beam = CreateBeam(Character)
    if not Beam then return end

    local Attachment = Instance.new("Attachment", Terrain)
    Beam.Attachment1 = Attachment

    IsBeamHit(Beam, MousePos.Value)
    MousePos.Changed:Connect(function()
        IsBeamHit(Beam, MousePos.Value)
    end)
end

local function OnPlayer(Player)
    if Player.Character then
        OnCharacter(Player.Character)
    end
    Player.CharacterAdded:Connect(OnCharacter)
end

for _, v in ipairs(Players:GetPlayers()) do
    OnPlayer(v)
end
Players.PlayerAdded:Connect(OnPlayer)


-- // ==========================================
-- // 6. Final Initialization & Handlers
-- // ==========================================
coroutine.wrap(function()
    while task.wait() do
        if autoReload and getWeapon(LocalPlayer) then
            local Weapon = getWeapon(LocalPlayer)
            if WeaponReloadRequest and Weapon then
                WeaponReloadRequest:FireServer(Weapon)
            end
        end
    end
end)()

setreadonly(mt, true)
pcall(protections)
pcall(doGunMods)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    pcall(protections)
    pcall(doGunMods)
end)
