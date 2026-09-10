-- WCC Cheater - Feature Drawer UI
-- UI-only refactor of the supplied Main(3).lua.
-- The feature switches below only manage local UI state; game automation,
-- teleportation, combat abuse, and anti-detection code are intentionally
-- not wired into this version.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then
    return
end

local playerGui = player:WaitForChild("PlayerGui")

local OLD_NAMES = {
    "WCC Cheater",
    "WCCCheater",
    "WCC Nigga",
    "Instant EGG",
}

for _, name in ipairs(OLD_NAMES) do
    local old = playerGui:FindFirstChild(name)
    if old then
        old:Destroy()
    end
end

-- ============================================================================
-- STATE
-- ============================================================================

local state = {
    Fullbright = false,
    ["Bat / Slap Aura"] = false,
    ["Auto Sell"] = false,
    ["Player Movement"] = false,
    ["Area Teleport"] = false,
    ["Plot Teleport"] = false,
    ["Player Teleport"] = false,
    ["Auto Hatch"] = false,
    ["Auto Plant"] = false,
    ["Auto Steal"] = false,
}

local featureOrder = {
    "Fullbright",
    "Bat / Slap Aura",
    "Auto Sell",
    "Player Movement",
    "Area Teleport",
    "Plot Teleport",
    "Player Teleport",
    "Auto Hatch",
    "Auto Plant",
    "Auto Steal",
}

local featureIcons = {
    ["Fullbright"] = "☀",
    ["Bat / Slap Aura"] = "⚔",
    ["Auto Sell"] = "$",
    ["Player Movement"] = "⌁",
    ["Area Teleport"] = "⌖",
    ["Plot Teleport"] = "□",
    ["Player Teleport"] = "♙",
    ["Auto Hatch"] = "◉",
    ["Auto Plant"] = "✿",
    ["Auto Steal"] = "★",
}

-- ============================================================================
-- HELPERS
-- ============================================================================

local function new(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props or {}) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local function addCorner(parent, radius)
    return new("UICorner", {
        CornerRadius = UDim.new(0, radius),
    }, parent)
end

local function addStroke(parent, transparency)
    return new("UIStroke", {
        Thickness = 1,
        Transparency = transparency or 0.5,
        Color = Color3.fromRGB(110, 115, 130),
    }, parent)
end

local function tween(obj, duration, props)
    local ok, result = pcall(function()
        return TweenService:Create(
            obj,
            TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            props
        )
    end)
    if ok and result then
        result:Play()
    end
end

-- ============================================================================
-- ROOT GUI
-- ============================================================================

local gui = new("ScreenGui", {
    Name = "WCC Cheater",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999999999,
}, playerGui)

-- Soft backdrop
local backdrop = new("Frame", {
    Name = "Backdrop",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(8, 10, 14),
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
}, gui)

-- ============================================================================
-- MAIN WINDOW
-- ============================================================================

local window = new("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(700, 430),
    BackgroundColor3 = Color3.fromRGB(20, 22, 29),
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, gui)
addCorner(window, 18)
addStroke(window, 0.3)

-- Header
local header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = Color3.fromRGB(27, 30, 39),
    BorderSizePixel = 0,
}, window)
addCorner(header, 18)

new("Frame", {
    Name = "HeaderMask",
    Position = UDim2.new(0, 0, 1, -18),
    Size = UDim2.new(1, 0, 0, 18),
    BackgroundColor3 = header.BackgroundColor3,
    BorderSizePixel = 0,
}, header)

local title = new("TextLabel", {
    Name = "Title",
    Position = UDim2.fromOffset(18, 0),
    Size = UDim2.new(0, 300, 1, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamSemibold,
    Text = "WCC Cheater",
    TextColor3 = Color3.fromRGB(245, 247, 252),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local subtitle = new("TextLabel", {
    Name = "Subtitle",
    Position = UDim2.fromOffset(18, 26),
    Size = UDim2.new(0, 360, 0, 18),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Feature drawer",
    TextColor3 = Color3.fromRGB(145, 150, 162),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local minimize = new("TextButton", {
    Name = "Minimize",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = Color3.fromRGB(42, 45, 56),
    AutoButtonColor = false,
    Font = Enum.Font.GothamMedium,
    Text = "−",
    TextColor3 = Color3.fromRGB(235, 238, 245),
    TextSize = 20,
}, header)
addCorner(minimize, 9)

-- ============================================================================
-- BODY / DRAWER
-- ============================================================================

local body = new("Frame", {
    Name = "Body",
    Position = UDim2.fromOffset(0, 52),
    Size = UDim2.new(1, 0, 1, -52),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
}, window)

local rail = new("Frame", {
    Name = "Rail",
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.new(0, 54, 1, -20),
    BackgroundColor3 = Color3.fromRGB(27, 30, 39),
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, body)
addCorner(rail, 14)
addStroke(rail, 0.6)

local drawer = new("Frame", {
    Name = "Drawer",
    Position = UDim2.fromOffset(74, 10),
    Size = UDim2.new(0, 205, 1, -20),
    BackgroundColor3 = Color3.fromRGB(27, 30, 39),
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, body)
addCorner(drawer, 14)
addStroke(drawer, 0.6)

local content = new("Frame", {
    Name = "Content",
    Position = UDim2.fromOffset(291, 10),
    Size = UDim2.new(1, -301, 1, -20),
    BackgroundColor3 = Color3.fromRGB(24, 27, 35),
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, body)
addCorner(content, 14)
addStroke(content, 0.6)

-- Drawer title
new("TextLabel", {
    Name = "DrawerTitle",
    Position = UDim2.fromOffset(16, 14),
    Size = UDim2.new(1, -32, 0, 28),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamSemibold,
    Text = "Features",
    TextColor3 = Color3.fromRGB(242, 244, 249),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
}, drawer)

local drawerScroll = new("ScrollingFrame", {
    Name = "FeatureList",
    Position = UDim2.fromOffset(8, 52),
    Size = UDim2.new(1, -16, 1, -60),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageTransparency = 0.5,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(),
}, drawer)

new("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, drawerScroll)

-- Rail menu toggle
local railMenu = new("TextButton", {
    Name = "Menu",
    Position = UDim2.fromOffset(7, 10),
    Size = UDim2.fromOffset(40, 40),
    BackgroundColor3 = Color3.fromRGB(37, 40, 50),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Font = Enum.Font.GothamMedium,
    Text = "☰",
    TextColor3 = Color3.fromRGB(235, 239, 246),
    TextSize = 18,
}, rail)
addCorner(railMenu, 10)

local railHint = new("TextLabel", {
    Name = "Hint",
    Position = UDim2.fromOffset(0, 58),
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "MENU",
    TextColor3 = Color3.fromRGB(115, 120, 133),
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Center,
}, rail)

-- ============================================================================
-- CONTENT HEADER
-- ============================================================================

local contentTitle = new("TextLabel", {
    Name = "ContentTitle",
    Position = UDim2.fromOffset(20, 18),
    Size = UDim2.new(1, -40, 0, 28),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamSemibold,
    Text = "Fullbright",
    TextColor3 = Color3.fromRGB(243, 245, 250),
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
}, content)

local contentDescription = new("TextLabel", {
    Name = "ContentDescription",
    Position = UDim2.fromOffset(20, 47),
    Size = UDim2.new(1, -40, 0, 44),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Local toggle state for the selected feature.",
    TextColor3 = Color3.fromRGB(150, 155, 168),
    TextSize = 11,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
}, content)

local divider = new("Frame", {
    Name = "Divider",
    Position = UDim2.fromOffset(20, 98),
    Size = UDim2.new(1, -40, 0, 1),
    BackgroundColor3 = Color3.fromRGB(48, 52, 64),
    BorderSizePixel = 0,
}, content)

local featureCard = new("Frame", {
    Name = "FeatureCard",
    Position = UDim2.fromOffset(20, 118),
    Size = UDim2.new(1, -40, 0, 82),
    BackgroundColor3 = Color3.fromRGB(29, 32, 42),
    BorderSizePixel = 0,
}, content)
addCorner(featureCard, 14)
addStroke(featureCard, 0.75)

local featureCardIcon = new("TextLabel", {
    Name = "Icon",
    Position = UDim2.fromOffset(16, 14),
    Size = UDim2.fromOffset(46, 46),
    BackgroundColor3 = Color3.fromRGB(37, 40, 51),
    Font = Enum.Font.GothamMedium,
    Text = "☀",
    TextColor3 = Color3.fromRGB(239, 242, 248),
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
}, featureCard)
addCorner(featureCardIcon, 12)

local featureCardName = new("TextLabel", {
    Name = "Name",
    Position = UDim2.fromOffset(76, 13),
    Size = UDim2.new(1, -190, 0, 24),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamMedium,
    Text = "Fullbright",
    TextColor3 = Color3.fromRGB(238, 241, 247),
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
}, featureCard)

local featureStateText = new("TextLabel", {
    Name = "StateText",
    Position = UDim2.fromOffset(76, 39),
    Size = UDim2.new(1, -190, 0, 20),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "OFF",
    TextColor3 = Color3.fromRGB(128, 133, 146),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, featureCard)

local featureToggle = new("TextButton", {
    Name = "Toggle",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -16, 0.5, 0),
    Size = UDim2.fromOffset(54, 30),
    BackgroundColor3 = Color3.fromRGB(46, 49, 60),
    AutoButtonColor = false,
    Text = "",
}, featureCard)
addCorner(featureToggle, 15)

local toggleKnob = new("Frame", {
    Name = "Knob",
    Position = UDim2.fromOffset(4, 4),
    Size = UDim2.fromOffset(22, 22),
    BackgroundColor3 = Color3.fromRGB(220, 223, 230),
    BorderSizePixel = 0,
}, featureToggle)
addCorner(toggleKnob, 11)

local notice = new("TextLabel", {
    Name = "Notice",
    Position = UDim2.fromOffset(20, 218),
    Size = UDim2.new(1, -40, 0, 70),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Select a feature from the drawer to change its local UI state.",
    TextColor3 = Color3.fromRGB(133, 138, 151),
    TextSize = 11,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
}, content)

-- ============================================================================
-- FEATURE BUTTONS
-- ============================================================================

local selectedFeature = featureOrder[1]
local drawerButtons = {}

local function setFeatureVisual(name, enabled, button, active)
    if active then
        button.BackgroundColor3 = Color3.fromRGB(54, 58, 72)
        button.TextColor3 = Color3.fromRGB(245, 247, 252)
    else
        button.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
        button.TextColor3 = Color3.fromRGB(196, 200, 209)
    end

    local stateDot = button:FindFirstChild("State")
    if stateDot then
        stateDot.BackgroundColor3 = enabled
            and Color3.fromRGB(70, 190, 120)
            or Color3.fromRGB(80, 84, 96)
    end
end

local function updateMainToggle(enabled)
    if enabled then
        featureToggle.BackgroundColor3 = Color3.fromRGB(52, 110, 84)
        tween(toggleKnob, 0.14, {
            Position = UDim2.fromOffset(28, 4),
            BackgroundColor3 = Color3.fromRGB(245, 248, 252),
        })
        featureStateText.Text = "ON"
        featureStateText.TextColor3 = Color3.fromRGB(102, 202, 145)
    else
        featureToggle.BackgroundColor3 = Color3.fromRGB(46, 49, 60)
        tween(toggleKnob, 0.14, {
            Position = UDim2.fromOffset(4, 4),
            BackgroundColor3 = Color3.fromRGB(220, 223, 230),
        })
        featureStateText.Text = "OFF"
        featureStateText.TextColor3 = Color3.fromRGB(128, 133, 146)
    end
end

local descriptions = {
    ["Fullbright"] = "Visual feature entry.",
    ["Bat / Slap Aura"] = "Combat feature entry.",
    ["Auto Sell"] = "Sales feature entry.",
    ["Player Movement"] = "Movement feature entry.",
    ["Area Teleport"] = "Travel feature entry.",
    ["Plot Teleport"] = "Plot travel feature entry.",
    ["Player Teleport"] = "Player travel feature entry.",
    ["Auto Hatch"] = "Egg hatching feature entry.",
    ["Auto Plant"] = "Egg planting feature entry.",
    ["Auto Steal"] = "Egg stealing feature entry.",
}

local function selectFeature(name)
    selectedFeature = name
    contentTitle.Text = name
    contentDescription.Text = descriptions[name] or "Feature entry."
    featureCardName.Text = name
    featureCardIcon.Text = featureIcons[name] or "•"
    notice.Text = "Selected: " .. name .. "\nToggle state is stored locally by this UI."
    updateMainToggle(state[name])

    for featureName, button in pairs(drawerButtons) do
        setFeatureVisual(
            featureName,
            state[featureName] == true,
            button,
            featureName == selectedFeature
        )
    end
end

for index, name in ipairs(featureOrder) do
    local button = new("TextButton", {
        Name = name:gsub("%W", ""),
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(35, 38, 48),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.Gotham,
        Text = "",
        LayoutOrder = index,
    }, drawerScroll)
    addCorner(button, 10)

    local icon = new("TextLabel", {
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.fromOffset(24, 38),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = featureIcons[name] or "•",
        TextColor3 = Color3.fromRGB(197, 201, 210),
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, button)

    new("TextLabel", {
        Position = UDim2.fromOffset(42, 0),
        Size = UDim2.new(1, -72, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Color3.fromRGB(210, 213, 221),
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, button)

    local stateDot = new("Frame", {
        Name = "State",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -9, 0.5, 0),
        Size = UDim2.fromOffset(7, 7),
        BackgroundColor3 = Color3.fromRGB(80, 84, 96),
        BorderSizePixel = 0,
    }, button)
    addCorner(stateDot, 4)

    drawerButtons[name] = button

    button.MouseEnter:Connect(function()
        if selectedFeature ~= name then
            tween(button, 0.1, {
                BackgroundColor3 = Color3.fromRGB(42, 45, 56),
            })
        end
    end)

    button.MouseLeave:Connect(function()
        setFeatureVisual(
            name,
            state[name] == true,
            button,
            selectedFeature == name
        )
    end)

    button.MouseButton1Click:Connect(function()
        selectFeature(name)
    end)
end

selectFeature(selectedFeature)

-- ============================================================================
-- TOGGLE HANDLING
-- ============================================================================

local function setFeatureState(name, enabled)
    state[name] = enabled == true
    if name == selectedFeature then
        updateMainToggle(state[name])
    end

    local button = drawerButtons[name]
    if button then
        setFeatureVisual(name, state[name], button, name == selectedFeature)
    end
end

featureToggle.MouseButton1Click:Connect(function()
    setFeatureState(selectedFeature, not state[selectedFeature])
end)

-- ============================================================================
-- DRAWER OPEN/CLOSE
-- ============================================================================

local drawerOpen = true
local openDrawerSize = UDim2.fromOffset(205, body.AbsoluteSize.Y - 20)
local closedDrawerSize = UDim2.fromOffset(0, body.AbsoluteSize.Y - 20)

local function setDrawer(open)
    drawerOpen = open
    railMenu.Text = open and "☰" or "›"

    if open then
        tween(drawer, 0.2, {Size = openDrawerSize})
        tween(content, 0.2, {
            Position = UDim2.fromOffset(291, 10),
            Size = UDim2.new(1, -301, 1, -20),
        })
    else
        tween(drawer, 0.2, {Size = closedDrawerSize})
        tween(content, 0.2, {
            Position = UDim2.fromOffset(74, 10),
            Size = UDim2.new(1, -84, 1, -20),
        })
    end
end

railMenu.MouseButton1Click:Connect(function()
    setDrawer(not drawerOpen)
end)

-- Recalculate sizes whenever the body changes.
body:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    local h = math.max(body.AbsoluteSize.Y - 20, 0)
    openDrawerSize = UDim2.fromOffset(205, h)
    closedDrawerSize = UDim2.fromOffset(0, h)
    if drawerOpen then
        drawer.Size = openDrawerSize
    end
end)

-- ============================================================================
-- DRAGGING
-- ============================================================================

local dragging = false
local dragInput
local dragStart
local startPosition

local function updateDrag(input)
    local delta = input.Position - dragStart
    window.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = window.Position
        dragInput = input

        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

-- ============================================================================
-- MINIMIZE / RESTORE
-- ============================================================================

local minimized = false
local normalSize = window.Size

minimize.MouseEnter:Connect(function()
    tween(minimize, 0.1, {
        BackgroundColor3 = Color3.fromRGB(58, 61, 74),
    })
end)

minimize.MouseLeave:Connect(function()
    tween(minimize, 0.1, {
        BackgroundColor3 = Color3.fromRGB(42, 45, 56),
    })
end)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        minimize.Text = "+"
        body.Visible = false
        tween(window, 0.2, {
            Size = UDim2.fromOffset(normalSize.X.Offset, 52),
        })
    else
        minimize.Text = "−"
        body.Visible = true
        tween(window, 0.2, {
            Size = normalSize,
        })
    end
end)

-- ============================================================================
-- KEYBIND
-- ============================================================================

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- Public UI state handle.
_G.WCCCheaterUI = {
    Gui = gui,
    Window = window,
    State = state,
    SelectFeature = selectFeature,
    SetFeatureState = setFeatureState,
    ToggleDrawer = function()
        setDrawer(not drawerOpen)
    end,
}

print("[WCC Cheater] UI loaded.")
