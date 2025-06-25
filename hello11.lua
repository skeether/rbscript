--[[
    SKEETHER HHHHHIIII
]]

-- Drawing API check
if not Drawing or not pcall(function() return Drawing.new("Text") end) then
    warn("sorry, but u cant inject ur script in this executer")
    return
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- Cleanup old GUIS
for _, v in ipairs(CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name:match("^SkeetherUltimateESP_") then
        v:Destroy()
    end
end

-- Main GUI
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

-- Main Frame
local mainWidth, mainHeight = 400, 220
local main = Instance.new("Frame")
main.Size = UDim2.new(0, mainWidth, 0, mainHeight)
main.Position = UDim2.new(0, 60, 0, 120)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Active = true
main.AnchorPoint = Vector2.new(0, 0)
main.ZIndex = 2
main.Parent = gui
main.Visible = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 18)
local border = Instance.new("UIStroke", main)
border.Color = Color3.fromRGB(30, 30, 36)
border.Thickness = 2.5

-- Dragging logic
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
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 18, 0, 6)
title.BackgroundTransparency = 1
title.Text = "skeether"
title.TextColor3 = Color3.fromRGB(200, 210, 255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local sep1 = Instance.new("Frame", main)
sep1.Size = UDim2.new(1, -36, 0, 1)
sep1.Position = UDim2.new(0, 18, 0, 42)
sep1.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
sep1.BorderSizePixel = 0
sep1.ZIndex = 2

-- Profile
do
    -- Container frame for avatar
    local profFrame = Instance.new("Frame")
    profFrame.Name = "ProfileInfo"
    profFrame.Size = UDim2.new(0, 165, 0, 50)
    profFrame.Position = UDim2.new(0, 170, 0, 54)
    profFrame.BackgroundTransparency = 1
    profFrame.Parent = main
    profFrame.ZIndex = 10

    -- Avatar
    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Name = "Avatar"
    avatarImg.Size = UDim2.new(0, 42, 0, 42)
    avatarImg.Position = UDim2.new(0, 0, 0, 4)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..lp.UserId.."&w=420&h=420"
    avatarImg.Parent = profFrame
    avatarImg.ZIndex = 11

    local avatarCorner = Instance.new("UICorner", avatarImg)
    avatarCorner.CornerRadius = UDim.new(1, 0)

    -- Username (DisplayName)
    local userLabel = Instance.new("TextLabel")
    userLabel.Size = UDim2.new(0, 120, 0, 18)
    userLabel.Position = UDim2.new(0, 48, 0, 5)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = lp.DisplayName
    userLabel.TextColor3 = Color3.fromRGB(200, 230, 255)
    userLabel.Font = Enum.Font.GothamBold
    userLabel.TextSize = 16
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    userLabel.ClipsDescendants = true
    userLabel.ZIndex = 12
    userLabel.Parent = profFrame

    -- @Username
    local unameLabel = Instance.new("TextLabel")
    unameLabel.Size = UDim2.new(0, 120, 0, 13)
    unameLabel.Position = UDim2.new(0, 48, 0, 25)
    unameLabel.BackgroundTransparency = 1
    unameLabel.Text = "@"..lp.Name
    unameLabel.TextColor3 = Color3.fromRGB(155, 155, 180)
    unameLabel.Font = Enum.Font.Gotham
    unameLabel.TextSize = 13
    unameLabel.TextXAlignment = Enum.TextXAlignment.Left
    unameLabel.ClipsDescendants = true
    unameLabel.ZIndex = 12
    unameLabel.Parent = profFrame

    -- UserId label
    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(0, 120, 0, 12)
    idLabel.Position = UDim2.new(0, 48, 0, 38)
    idLabel.BackgroundTransparency = 1
    idLabel.Text = "UserId: "..tostring(lp.UserId)
    idLabel.TextColor3 = Color3.fromRGB(100, 120, 180)
    idLabel.Font = Enum.Font.Gotham
    idLabel.TextSize = 11
    idLabel.TextXAlignment = Enum.TextXAlignment.Left
    idLabel.ClipsDescendants = true
    idLabel.ZIndex = 12
    idLabel.Parent = profFrame
end

-- Button/Toggle Style
local function createButton(parent, text, position, name, size)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0, 120, 0, 34)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BorderColor3 = Color3.fromRGB(50, 50, 58)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(210, 210, 210)
    btn.TextSize = 17
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Name = name
    btn.ZIndex = 3

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 14)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(70, 70, 80)
    btnStroke.Thickness = 1.7

    return btn
end

-- NameESP Toggle
local nameespToggle = createButton(main, "NameESP: ON", UDim2.new(0, 24, 0, 54), "NameESPBtn")
nameespToggle.TextColor3 = Color3.fromRGB(200,255,200)

-- SkeletonESP Toggle
local skeletonToggle = createButton(main, "Skeleton: ON", UDim2.new(0, 24, 0, 96), "SkeletonBtn")
skeletonToggle.TextColor3 = Color3.fromRGB(255,200,255)

-- Separator before TP
local sep2 = Instance.new("Frame", main)
sep2.Size = UDim2.new(1, -36, 0, 1)
sep2.Position = UDim2.new(0, 18, 0, 140)
sep2.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
sep2.BorderSizePixel = 0
sep2.ZIndex = 2

-- TP title
local tpTitle = Instance.new("TextLabel", main)
tpTitle.Size = UDim2.new(0, 120, 0, 20)
tpTitle.Position = UDim2.new(0, 24, 0, 150)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "teleport to player:"
tpTitle.TextColor3 = Color3.fromRGB(170, 170, 220)
tpTitle.TextSize = 13
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextXAlignment = Enum.TextXAlignment.Left
tpTitle.ZIndex = 3

-- TP Input
local tpInput = Instance.new("TextBox", main)
tpInput.Size = UDim2.new(0, 170, 0, 28)
tpInput.Position = UDim2.new(0, 140, 0, 148)
tpInput.PlaceholderText = "enter user"
tpInput.Font = Enum.Font.Gotham
tpInput.Text = ""
tpInput.TextSize = 15
tpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
tpInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
tpInput.BorderSizePixel = 0
tpInput.ClearTextOnFocus = false
tpInput.ZIndex = 3
local tpInputCorner = Instance.new("UICorner", tpInput)
tpInputCorner.CornerRadius = UDim.new(0, 9)

-- TP Button
local tpBtn = createButton(main, "TP", UDim2.new(0, 140, 0, 183), "TPBtn", UDim2.new(0, 80, 0, 28))
tpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
tpBtn.TextSize = 15

-- Annoy Button
local annoyBtn = createButton(main, "annoy", UDim2.new(0, 230, 0, 183), "AnnoyBtn", UDim2.new(0, 80, 0, 28))
annoyBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 100)
annoyBtn.TextSize = 15

-- Notification
local notifyLabel = Instance.new("TextLabel", main)
notifyLabel.Size = UDim2.new(0, mainWidth-30, 0, 22)
notifyLabel.Position = UDim2.new(0, 15, 1, -28)
notifyLabel.BackgroundTransparency = 1
notifyLabel.Text = ""
notifyLabel.Font = Enum.Font.GothamBold
notifyLabel.TextSize = 15
notifyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
notifyLabel.TextXAlignment = Enum.TextXAlignment.Left
notifyLabel.TextYAlignment = Enum.TextYAlignment.Center
notifyLabel.Visible = false
notifyLabel.ZIndex = 5

-- ESP Logic
local nameespEnabled = true
local skeletonEnabled = true
local function updateBtnState(btn, state, labelOn, labelOff, colorOn, colorOff)
    btn.Text = state and labelOn or labelOff
    btn.TextColor3 = state and colorOn or colorOff
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

-- Button Animations
local function ButtonAnimator(btn, base, hover, press)
    local currTween = nil
    local state = "Base"  -- "Base", "Hover", "Press"
    local function safeTween(targetColor, t)
        if currTween then currTween:Cancel() end
        currTween = TweenService:Create(btn, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor})
        currTween:Play()
    end
    btn.MouseEnter:Connect(function()
        if state ~= "Press" then
            state = "Hover"
            safeTween(hover)
        end
    end)
    btn.MouseLeave:Connect(function()
        state = "Base"
        safeTween(base)
    end)
    btn.MouseButton1Down:Connect(function()
        state = "Press"
        safeTween(press, 0.09)
    end)
    btn.MouseButton1Up:Connect(function()
        if UIS:GetMouseLocation().X >= btn.AbsolutePosition.X and UIS:GetMouseLocation().X <= btn.AbsolutePosition.X + btn.AbsoluteSize.X
           and UIS:GetMouseLocation().Y >= btn.AbsolutePosition.Y and UIS:GetMouseLocation().Y <= btn.AbsolutePosition.Y + btn.AbsoluteSize.Y then
            state = "Hover"
            safeTween(hover, 0.09)
        else
            state = "Base"
            safeTween(base, 0.09)
        end
    end)
    -- On reset (in case of disable)
    btn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        if not btn:IsDescendantOf(game) then return end
        -- Forcibly reset color if button state mismatches
        if state == "Base" and btn.BackgroundColor3 ~= base then
            btn.BackgroundColor3 = base
        elseif state == "Hover" and btn.BackgroundColor3 ~= hover then
            btn.BackgroundColor3 = hover
        elseif state == "Press" and btn.BackgroundColor3 ~= press then
            btn.BackgroundColor3 = press
        end
    end)
end

-- Apply animations
ButtonAnimator(nameespToggle, Color3.fromRGB(30, 30, 35), Color3.fromRGB(60, 60, 70), Color3.fromRGB(16, 16, 22))
ButtonAnimator(skeletonToggle, Color3.fromRGB(30, 30, 35), Color3.fromRGB(60, 60, 70), Color3.fromRGB(16, 16, 22))
ButtonAnimator(tpBtn, Color3.fromRGB(60, 60, 100), Color3.fromRGB(110, 110, 180), Color3.fromRGB(40, 40, 80))
ButtonAnimator(annoyBtn, Color3.fromRGB(120, 60, 100), Color3.fromRGB(180, 110, 180), Color3.fromRGB(100, 40, 80))

-- NameESP
_G._drawNames = {}
local function createNameDraw(plr)
    if plr == lp or _G._drawNames[plr] then return end
    local draw = Drawing.new("Text")
    draw.Size = 20
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
        line.Transparency = 0.45
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

-- Tracking player
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

-- Main ESP
RunService.RenderStepped:Connect(function()
    -- NameESP
    for plr, draw in pairs(_G._drawNames) do
        local char = plr.Character
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if nameespEnabled and char and head and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y + 1.1, 0))
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

    -- Skeleton ESP
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
                        line.Transparency = 0.45
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

-- TP logic
local function FindPlayer(query)
    query = string.lower(query:match("^%s*(.-)%s*$") or "")
    if #query < 3 then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == query then return plr end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.DisplayName) == query then return plr end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(plr.DisplayName), query, 1, true) then return plr end
    end
    return nil
end
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

-- Notification
local notifyActive = false
local notifyThread = nil
local function ShowInfo(msg, color, time)
    if notifyThread then
        notifyActive = false
        task.wait(0.01)
    end
    notifyActive = true
    notifyLabel.Text = msg
    notifyLabel.TextColor3 = color or Color3.fromRGB(255,80,80)
    notifyLabel.Visible = true
    notifyThread = coroutine.create(function()
        task.wait(time or 1.2)
        if notifyActive then
            notifyLabel.Visible = false
            notifyActive = false
        end
    end)
    coroutine.resume(notifyThread)
end
local function HideInfo()
    notifyActive = false
    notifyLabel.Visible = false
end

tpBtn.MouseButton1Click:Connect(function()
    HideInfo()
    local query = tpInput.Text or ""
    if query == "" then
        TweenService:Create(tpInput, TweenInfo.new(0.09), {BackgroundColor3 = Color3.fromRGB(120, 40, 40)}):Play()
        ShowInfo("enter nickname!", Color3.fromRGB(255, 80, 80))
        task.wait(1.2)
        TweenService:Create(tpInput, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
        HideInfo()
        return
    end

    local target = FindPlayer(query)
    if not target then
        TweenService:Create(tpInput, TweenInfo.new(0.09), {BackgroundColor3 = Color3.fromRGB(120, 40, 40)}):Play()
        ShowInfo("player is not found", Color3.fromRGB(255, 80, 80))
        task.wait(1.2)
        TweenService:Create(tpInput, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
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
        ShowInfo("tp to "..target.DisplayName.."!", Color3.fromRGB(80, 255, 80), 0.8)
    else
        ShowInfo("error: "..(err or "Unknown error"), Color3.fromRGB(255, 80, 80), 1.5)
    end
end)

tpInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        tpBtn:Activate()
    end
end)

-- Annoy logic variables
local annoyActive = false
local annoyConnection = nil
local annoyTarget = nil

local function AnnoyStart(target)
    annoyTarget = target
    annoyActive = true
    if annoyConnection then annoyConnection:Disconnect() end
    annoyConnection = RunService.RenderStepped:Connect(function()
        if not annoyActive then return end
        if not annoyTarget or not annoyTarget.Character or not annoyTarget.Character:FindFirstChild("HumanoidRootPart") then return end
        if not lp or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
        local myHRP = lp.Character.HumanoidRootPart
        local targetHRP = annoyTarget.Character.HumanoidRootPart
        if (myHRP.Position - targetHRP.Position).Magnitude > 2 then
            myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0))
        end
    end)
end

local function AnnoyStop()
    annoyActive = false
    annoyTarget = nil
    if annoyConnection then
        annoyConnection:Disconnect()
        annoyConnection = nil
    end
end

local function AnnoyButtonSetState(isAnnoying)
    if isAnnoying then
        annoyBtn.Text = "stop annoy"
        annoyBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        annoyBtn.TextColor3 = Color3.fromRGB(20, 40, 20)
    else
        annoyBtn.Text = "annoy"
        annoyBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 100)
        annoyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end
AnnoyButtonSetState(false)

annoyBtn.MouseButton1Click:Connect(function()
    HideInfo()
    if annoyActive then
        AnnoyStop()
        AnnoyButtonSetState(false)
        ShowInfo("annoy stopped!", Color3.fromRGB(80, 255, 80), 0.8)
        return
    end

    local query = tpInput.Text or ""
    if query == "" then
        TweenService:Create(tpInput, TweenInfo.new(0.09), {BackgroundColor3 = Color3.fromRGB(120, 40, 40)}):Play()
        ShowInfo("enter nickname!", Color3.fromRGB(255, 80, 80))
        task.wait(1.2)
        TweenService:Create(tpInput, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
        HideInfo()
        return
    end

    local target = FindPlayer(query)
    if not target then
        TweenService:Create(tpInput, TweenInfo.new(0.09), {BackgroundColor3 = Color3.fromRGB(120, 40, 40)}):Play()
        ShowInfo("player is not found", Color3.fromRGB(255, 80, 80))
        task.wait(1.2)
        TweenService:Create(tpInput, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
        HideInfo()
        return
    end

    if target == lp then
        ShowInfo("bro...", Color3.fromRGB(255, 255, 80))
        task.wait(1.2)
        HideInfo()
        return
    end

    AnnoyStart(target)
    AnnoyButtonSetState(true)
    ShowInfo("anoying "..target.DisplayName.."!", Color3.fromRGB(255, 180, 80), 0.8)
end)

-- Annoy auto-stop if player leaves or dies
Players.PlayerRemoving:Connect(function(plr)
    if annoyActive and annoyTarget == plr then
        AnnoyStop()
        AnnoyButtonSetState(false)
        ShowInfo("annoy stopped: player left", Color3.fromRGB(255, 80, 80), 1)
    end
end)
RunService.RenderStepped:Connect(function()
    if annoyActive and annoyTarget then
        local char = annoyTarget.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health <= 0 then
            AnnoyStop()
            AnnoyButtonSetState(false)
            ShowInfo("annoy stopped: player died", Color3.fromRGB(255, 80, 80), 1)
        end
    end
end)

tpInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and annoyActive then
        AnnoyStop()
        AnnoyButtonSetState(false)
    end
end)

-- Hotkey: show/hide GUI on "N" (toggle)
local guiVisible = true
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.N then
        guiVisible = not guiVisible
        main.Visible = guiVisible
    end
end)

-- Ensure GUI is parented
if not gui.Parent then
    gui.Parent = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui")
end
