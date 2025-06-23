--[[
    SKEETHER ULTIMATE ESP + TP
    by skeether
    Объединённая, оптимизированная и полностью рабочая версия
    Черно-серый дизайн, продуманная архитектура, продвинутая обработка ошибок
    Функционал: NameESP, SkeletonESP, Телепорт по нику/дисплею
]]

-- check the drawing api
if not Drawing or not pcall(function() return Drawing.new("Text") end) then
    warn("sorry, but u cant inject ur script in this executer")
    return
end

-- services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- clearaaa
for _, v in ipairs(CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name:match("^SkeetherUltimateESP_") then
        v:Destroy()
    end
end

-- main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SkeetherUltimateESP_" .. math.random(1000, 9999)
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
    end
    gui.Parent = CoreGui
end)
if not gui.Parent then
    gui.Parent = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui")
end

-- main frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 370, 0, 240)
main.Position = UDim2.new(0, 60, 0, 140)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 23)
main.BorderSizePixel = 0
main.Active = true
main.AnchorPoint = Vector2.new(0, 0)
main.ZIndex = 2
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 15)
local border = Instance.new("UIStroke", main)
border.Color = Color3.fromRGB(30, 30, 36)
border.Thickness = 2

-- gondon gui
do
    local dragging, dragInput, dragStart, startPos

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 38)
title.Position = UDim2.new(0, 12, 0, 4)
title.BackgroundTransparency = 1
title.Text = "BOSS"
title.TextColor3 = Color3.fromRGB(185, 192, 250)
title.TextSize = 23
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local sep1 = Instance.new("Frame", main)
sep1.Size = UDim2.new(1, -24, 0, 1)
sep1.Position = UDim2.new(0, 12, 0, 44)
sep1.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
sep1.BorderSizePixel = 0
sep1.ZIndex = 2

-- NameESP toggle
local nameespToggle = Instance.new("TextButton", main)
nameespToggle.Size = UDim2.new(0, 140, 0, 36)
nameespToggle.Position = UDim2.new(0, 18, 0, 56)
nameespToggle.BackgroundColor3 = Color3.fromRGB(56, 56, 64)
nameespToggle.BorderColor3 = Color3.fromRGB(64, 64, 74)
nameespToggle.Text = "NameESP: ON"
nameespToggle.TextColor3 = Color3.fromRGB(200,255,200)
nameespToggle.TextSize = 16
nameespToggle.Font = Enum.Font.GothamBold
nameespToggle.AutoButtonColor = false
nameespToggle.Name = "NameESPBtn"
nameespToggle.ZIndex = 3
local nameCorner = Instance.new("UICorner", nameespToggle)
nameCorner.CornerRadius = UDim.new(0, 10)
local nameStroke = Instance.new("UIStroke", nameespToggle)
nameStroke.Color = Color3.fromRGB(80, 80, 90)
nameStroke.Thickness = 1.2

-- SkeletonESP toggle
local skeletonToggle = Instance.new("TextButton", main)
skeletonToggle.Size = UDim2.new(0, 140, 0, 36)
skeletonToggle.Position = UDim2.new(0, 18, 0, 104)
skeletonToggle.BackgroundColor3 = Color3.fromRGB(56, 56, 64)
skeletonToggle.BorderColor3 = Color3.fromRGB(64, 64, 74)
skeletonToggle.Text = "Skeleton: ON"
skeletonToggle.TextColor3 = Color3.fromRGB(255,200,255)
skeletonToggle.TextSize = 16
skeletonToggle.Font = Enum.Font.GothamBold
skeletonToggle.AutoButtonColor = false
skeletonToggle.Name = "SkeletonBtn"
skeletonToggle.ZIndex = 3
local skeletonCorner = Instance.new("UICorner", skeletonToggle)
skeletonCorner.CornerRadius = UDim.new(0, 10)
local skeletonStroke = Instance.new("UIStroke", skeletonToggle)
skeletonStroke.Color = Color3.fromRGB(80, 80, 90)
skeletonStroke.Thickness = 1.2

-- before tp
local sep2 = Instance.new("Frame", main)
sep2.Size = UDim2.new(1, -24, 0, 1)
sep2.Position = UDim2.new(0, 12, 0, 152)
sep2.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
sep2.BorderSizePixel = 0
sep2.ZIndex = 2

-- TP title
local tpTitle = Instance.new("TextLabel", main)
tpTitle.Size = UDim2.new(0, 120, 0, 28)
tpTitle.Position = UDim2.new(0, 18, 0, 162)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "tp to player:"
tpTitle.TextColor3 = Color3.fromRGB(180, 180, 220)
tpTitle.TextSize = 15
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextXAlignment = Enum.TextXAlignment.Left
tpTitle.ZIndex = 3

-- TP Input
local tpInput = Instance.new("TextBox", main)
tpInput.Size = UDim2.new(0, 170, 0, 32)
tpInput.Position = UDim2.new(0, 148, 0, 162)
tpInput.PlaceholderText = "enter user"
tpInput.Font = Enum.Font.Gotham
tpInput.Text = ""
tpInput.TextSize = 17
tpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
tpInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
tpInput.BorderSizePixel = 0
tpInput.ClearTextOnFocus = false
tpInput.ZIndex = 3
local tpInputCorner = Instance.new("UICorner", tpInput)
tpInputCorner.CornerRadius = UDim.new(0, 8)

-- TP Button
local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(0, 110, 0, 32)
tpBtn.Position = UDim2.new(0, 148, 0, 202)
tpBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 240)
tpBtn.Text = "TP"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 18
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.BorderSizePixel = 0
tpBtn.AutoButtonColor = false
tpBtn.ZIndex = 3
local tpBtnCorner = Instance.new("UICorner", tpBtn)
tpBtnCorner.CornerRadius = UDim.new(0, 8)

-- TP Info
local tpInfo = Instance.new("TextLabel", main)
tpInfo.Size = UDim2.new(0, 110, 0, 24)
tpInfo.Position = UDim2.new(0, 266, 0, 202)
tpInfo.BackgroundTransparency = 1
tpInfo.Text = ""
tpInfo.Font = Enum.Font.Gotham
tpInfo.TextSize = 15
tpInfo.TextColor3 = Color3.fromRGB(255, 80, 80)
tpInfo.TextWrapped = true
tpInfo.Visible = false
tpInfo.ZIndex = 3

-- myinf
local info = Instance.new("TextLabel", main)
info.AnchorPoint = Vector2.new(1, 1)
info.Position = UDim2.new(1, -14, 1, -8)
info.Size = UDim2.new(0.5, 0, 0, 15)
info.BackgroundTransparency = 1
info.Text = "by skeether"
info.TextColor3 = Color3.fromRGB(70, 70, 90)
info.TextSize = 11
info.Font = Enum.Font.Gotham
info.TextXAlignment = Enum.TextXAlignment.Right
info.ZIndex = 2

-- ESP
local nameespEnabled = true
local skeletonEnabled = true

local function updateBtnState(btn, state, labelOn, labelOff, textColorOn, textColorOff)
    btn.Text = state and labelOn or labelOff
    btn.TextColor3 = state and textColorOn or textColorOff
end

nameespToggle.MouseButton1Click:Connect(function()
    nameespEnabled = not nameespEnabled
    updateBtnState(nameespToggle, nameespEnabled, "NameESP: ON", "NameESP: OFF",
        Color3.fromRGB(200,255,200), Color3.fromRGB(255,120,120))
    for _,d in pairs(_G._drawNames or {}) do if d then d.Visible = nameespEnabled end end
end)

skeletonToggle.MouseButton1Click:Connect(function()
    skeletonEnabled = not skeletonEnabled
    updateBtnState(skeletonToggle, skeletonEnabled, "Skeleton: ON", "Skeleton: OFF",
        Color3.fromRGB(255,200,255), Color3.fromRGB(255,120,180))
    for _,s in pairs(_G._drawSkeletons or {}) do
        for _,d in pairs(s) do if d then d.Visible = skeletonEnabled end end
    end
end)

-- NameESP
_G._drawNames = {}
local function createNameDraw(plr)
    if plr == lp or _G._drawNames[plr] then return end
    local draw = Drawing.new("Text")
    draw.Size = 17
    draw.Center = true
    draw.Outline = true
    draw.Font = 2
    draw.Text = plr.DisplayName
    draw.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.fromRGB(140,200,255)
    draw.Visible = nameespEnabled
    _G._drawNames[plr] = draw
end
local function removeNameDraw(plr)
    if _G._drawNames[plr] then _G._drawNames[plr]:Remove(); _G._drawNames[plr] = nil end
end

-- Skeleton ESP
_G._drawSkeletons = {}
local skeletonJoints = {
    R15 = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    },
    R6 = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"}, {"Left Arm", "Left Leg"},
        {"Torso", "Right Arm"}, {"Right Arm", "Right Leg"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }
}
local function getCharRigType(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.RigType and hum.RigType == Enum.HumanoidRigType.R15 then
        return "R15"
    end
    return "R6"
end
local function createSkeletonDraw(plr)
    if plr == lp or _G._drawSkeletons[plr] then return end
    local s = {}
    local char = plr.Character
    if not char then _G._drawSkeletons[plr] = s return end
    local rig = getCharRigType(char)
    local joints = skeletonJoints[rig]
    for _, pair in ipairs(joints) do
        local line = Drawing.new("Line")
        line.Color = Color3.fromRGB(255, 110, 255)
        line.Thickness = 3
        line.Transparency = 0.42
        line.Visible = skeletonEnabled
        s[table.concat(pair, "_")] = line
    end
    _G._drawSkeletons[plr] = s
end
local function removeSkeletonDraw(plr)
    if _G._drawSkeletons[plr] then
        for _,d in pairs(_G._drawSkeletons[plr]) do
            if d and d.Remove then d:Remove() end
        end
        _G._drawSkeletons[plr] = nil
    end
end

-- tracking
for _,p in ipairs(Players:GetPlayers()) do createNameDraw(p); createSkeletonDraw(p) end
Players.PlayerAdded:Connect(function(p)
    createNameDraw(p)
    createSkeletonDraw(p)
    p.CharacterAdded:Connect(function(char)
        removeSkeletonDraw(p)
        createSkeletonDraw(p)
    end)
end)
Players.PlayerRemoving:Connect(function(p) removeNameDraw(p); removeSkeletonDraw(p) end)
for _,plr in ipairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function(char)
        removeSkeletonDraw(plr)
        createSkeletonDraw(plr)
    end)
end

-- main ESP
RunService.RenderStepped:Connect(function()
    -- NameESP
    for plr, draw in pairs(_G._drawNames) do
        local char = plr.Character
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if nameespEnabled and char and head and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y + 0.9, 0))
            if onScreen and pos.Z > 0 then
                draw.Position = Vector2.new(math.floor(pos.X + 0.5), math.floor(pos.Y + 0.5))
                draw.Text = plr.DisplayName
                draw.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.fromRGB(140,200,255)
                draw.Visible = true
            else
                draw.Visible = false
            end
        else
            draw.Visible = false
        end
    end

    -- ESP
    for plr, skeleton in pairs(_G._drawSkeletons) do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if skeletonEnabled and char and hum and hum.Health > 0 then
            local rig = getCharRigType(char)
            local joints = skeletonJoints[rig]
            for _, pair in ipairs(joints) do
                local a, b = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
                local line = skeleton[table.concat(pair, "_")]
                if a and b and line then
                    local aPos, aOn = Camera:WorldToViewportPoint(a.Position)
                    local bPos, bOn = Camera:WorldToViewportPoint(b.Position)
                    if aOn and bOn and aPos.Z > 0 and bPos.Z > 0 then
                        line.From = Vector2.new(aPos.X, aPos.Y)
                        line.To = Vector2.new(bPos.X, bPos.Y)
                        line.Color = Color3.fromRGB(255, 110, 255)
                        line.Transparency = 0.42
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                elseif line then
                    line.Visible = false
                end
            end
        else
            for _,line in pairs(skeleton) do line.Visible = false end
        end
    end
end)

-- TP

-- tb
local function TweenButton(button, color, time)
    TweenService:Create(button, TweenInfo.new(time or 0.15), {BackgroundColor3 = color}):Play()
end
tpBtn.MouseEnter:Connect(function()
    TweenButton(tpBtn, Color3.fromRGB(140, 140, 255))
end)
tpBtn.MouseLeave:Connect(function()
    TweenButton(tpBtn, Color3.fromRGB(100, 100, 240))
end)
tpBtn.MouseButton1Down:Connect(function()
    TweenButton(tpBtn, Color3.fromRGB(80, 80, 210), 0.07)
end)
tpBtn.MouseButton1Up:Connect(function()
    TweenButton(tpBtn, Color3.fromRGB(140, 140, 255), 0.07)
end)

-- search
local function FindPlayer(query)
    query = string.lower(query:match("^%s*(.-)%s*$") or "")
    if #query < 3 then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == query then
            return plr
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.DisplayName) == query then
            return plr
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(plr.DisplayName), query, 1, true) then
            return plr
        end
    end
    return nil
end

-- tp to player
local function TeleportTo(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return false, "Target player's character is not ready."
    end
    if not lp or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        return false, "Your character is not ready."
    end
    local hrp = lp.Character.HumanoidRootPart
    local targetPos = target.Character.HumanoidRootPart.Position
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
    return true
end

-- TP Info helpers
local function ShowInfo(msg, color)
    tpInfo.Text = msg
    tpInfo.TextColor3 = color or Color3.fromRGB(255,80,80)
    tpInfo.Visible = true
end
local function HideInfo()
    tpInfo.Visible = false
end

-- TP logic
tpBtn.MouseButton1Click:Connect(function()
    HideInfo()
    local query = tpInput.Text or ""
    if query == "" then
        tpInput.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        ShowInfo("enter nickname!", Color3.fromRGB(255, 80, 80))
        task.wait(1.2)
        tpInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        HideInfo()
        return
    end

    local target = FindPlayer(query)
    if not target then
        tpInput.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        ShowInfo("player is not found", Color3.fromRGB(255, 80, 80))
        task.wait(1.2)
        tpInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        HideInfo()
        return
    end

    if target == lp then
        ShowInfo("bro...", Color3.fromRGB(255, 255, 80))
        task.wait(1.2)
        HideInfo()
        return
    end

    local ok, err = TeleportTo(target)
    if ok then
        ShowInfo("tp to "..target.DisplayName.."!", Color3.fromRGB(80, 255, 80))
        task.wait(0.8)
        HideInfo()
    else
        ShowInfo("Ошибка: "..(err or "Unknown error"), Color3.fromRGB(255, 80, 80))
        task.wait(1.5)
        HideInfo()
    end
end)

-- Enter support
tpInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        tpBtn:Activate()
    end
end)

-- GASHISH
if not gui.Parent then
    gui.Parent = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui")
end