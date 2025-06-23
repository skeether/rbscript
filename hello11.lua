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

-- Cleanup old GUIs
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
local mainWidth, mainHeight = 500, 300
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

-- Corners & Border
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
title.Size = UDim2.new(1, 0, 0, 48)
title.Position = UDim2.new(0, 18, 0, 8)
title.BackgroundTransparency = 1
title.Text = "BOSS"
title.TextColor3 = Color3.fromRGB(200, 210, 255)
title.TextSize = 30
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local sep1 = Instance.new("Frame", main)
sep1.Size = UDim2.new(1, -36, 0, 1)
sep1.Position = UDim2.new(0, 18, 0, 58)
sep1.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
sep1.BorderSizePixel = 0
sep1.ZIndex = 2

-- Button/Toggle Style
local function createButton(parent, text, position, name)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 180, 0, 48)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BorderColor3 = Color3.fromRGB(50, 50, 58)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(210, 210, 210)
    btn.TextSize = 20
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
local nameespToggle = createButton(main, "NameESP: ON", UDim2.new(0, 24, 0, 78), "NameESPBtn")
nameespToggle.TextColor3 = Color3.fromRGB(200,255,200)

-- SkeletonESP Toggle
local skeletonToggle = createButton(main, "Skeleton: ON", UDim2.new(0, 24, 0, 138), "SkeletonBtn")
skeletonToggle.TextColor3 = Color3.fromRGB(255,200,255)

-- Separator before TP
local sep2 = Instance.new("Frame", main)
sep2.Size = UDim2.new(1, -36, 0, 1)
sep2.Position = UDim2.new(0, 18, 0, 198)
sep2.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
sep2.BorderSizePixel = 0
sep2.ZIndex = 2

-- TP title
local tpTitle = Instance.new("TextLabel", main)
tpTitle.Size = UDim2.new(0, 180, 0, 28)
tpTitle.Position = UDim2.new(0, 24, 0, 208)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "teleport to player:"
tpTitle.TextColor3 = Color3.fromRGB(170, 170, 220)
tpTitle.TextSize = 17
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextXAlignment = Enum.TextXAlignment.Left
tpTitle.ZIndex = 3

-- TP Input
local tpInput = Instance.new("TextBox", main)
tpInput.Size = UDim2.new(0, 220, 0, 38)
tpInput.Position = UDim2.new(0, 210, 0, 208)
tpInput.PlaceholderText = "enter user"
tpInput.Font = Enum.Font.Gotham
tpInput.Text = ""
tpInput.TextSize = 18
tpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
tpInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
tpInput.BorderSizePixel = 0
tpInput.ClearTextOnFocus = false
tpInput.ZIndex = 3
local tpInputCorner = Instance.new("UICorner", tpInput)
tpInputCorner.CornerRadius = UDim.new(0, 10)

-- TP Button
local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(0, 110, 0, 38)
tpBtn.Position = UDim2.new(0, 210, 0, 258)
tpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
tpBtn.Text = "TP"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 20
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.BorderSizePixel = 0
tpBtn.AutoButtonColor = false
tpBtn.ZIndex = 3
local tpBtnCorner = Instance.new("UICorner", tpBtn)
tpBtnCorner.CornerRadius = UDim.new(0, 10)

-- TP Info
local tpInfo = Instance.new("TextLabel", main)
tpInfo.Size = UDim2.new(0, 170, 0, 26)
tpInfo.Position = UDim2.new(0, 330, 0, 258)
tpInfo.BackgroundTransparency = 1
tpInfo.Text = ""
tpInfo.Font = Enum.Font.Gotham
tpInfo.TextSize = 16
tpInfo.TextColor3 = Color3.fromRGB(255, 80, 80)
tpInfo.TextWrapped = true
tpInfo.Visible = false
tpInfo.ZIndex = 3

-- myinf
local info = Instance.new("TextLabel", main)
info.AnchorPoint = Vector2.new(1, 1)
info.Position = UDim2.new(1, -20, 1, -12)
info.Size = UDim2.new(0.5, 0, 0, 15)
info.BackgroundTransparency = 1
info.Text = "by skeether"
info.TextColor3 = Color3.fromRGB(70, 70, 90)
info.TextSize = 12
info.Font = Enum.Font.Gotham
info.TextXAlignment = Enum.TextXAlignment.Right
info.ZIndex = 2

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

-- Button Animations (bugfixed: handles fast switching, only one tween per button!)
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

-- Tracking player add/remove/character add
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

-- Main ESP update loop
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

-- TP Info helpers
local function ShowInfo(msg, color)
    tpInfo.Text = msg
    tpInfo.TextColor3 = color or Color3.fromRGB(255,80,80)
    tpInfo.Visible = true
end
local function HideInfo()
    tpInfo.Visible = false
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
        ShowInfo("tp to "..target.DisplayName.."!", Color3.fromRGB(80, 255, 80))
        task.wait(0.8)
        HideInfo()
    else
        ShowInfo("error: "..(err or "Unknown error"), Color3.fromRGB(255, 80, 80))
        task.wait(1.5)
        HideInfo()
    end
end)

tpInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        tpBtn:Activate()
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
