-- Instant EGG - Best Value Scanner
-- Rebuilt from the working minimal UI structure.
-- This version keeps the original Window/Minimize behavior and adds
-- a self-contained best-value egg scanner inside the existing Body.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
if not player then
    return
end

local playerGui = player:WaitForChild("PlayerGui")

-- Remove an older copy if it exists.
local old = playerGui:FindFirstChild("InstantEgg)
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "InstantEGG"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999999
gui.Parent = playerGui

-- Main Window
local window = Instance.new("Frame")
window.Name = "Window"
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.5)
window.Size = UDim2.fromOffset(420, 250)
window.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
window.BackgroundTransparency = 0.04
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = window

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Transparency = 0.35
stroke.Color = Color3.fromRGB(110, 115, 135)
stroke.Parent = window

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
header.BorderSizePixel = 0
header.Parent = window

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local headerMask = Instance.new("Frame")
headerMask.Name = "HeaderMask"
headerMask.Position = UDim2.new(0, 0, 1, -14)
headerMask.Size = UDim2.new(1, 0, 0, 14)
headerMask.BackgroundColor3 = header.BackgroundColor3
headerMask.BorderSizePixel = 0
headerMask.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 0)
title.Size = UDim2.new(1, -66, 1, 0)
title.Font = Enum.Font.GothamMedium
title.Text = "WCC Nigga"
title.TextColor3 = Color3.fromRGB(245, 246, 250)
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize button only
local minimize = Instance.new("TextButton")
minimize.Name = "Minimize"
minimize.AnchorPoint = Vector2.new(1, 0.5)
minimize.Position = UDim2.new(1, -10, 0.5, 0)
minimize.Size = UDim2.fromOffset(28, 28)
minimize.BackgroundColor3 = Color3.fromRGB(42, 44, 56)
minimize.AutoButtonColor = false
minimize.Text = "−"
minimize.TextColor3 = Color3.fromRGB(235, 237, 242)
minimize.TextSize = 20
minimize.Font = Enum.Font.GothamMedium
minimize.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimize

-- Body
local body = Instance.new("Frame")
body.Name = "Body"
body.Position = UDim2.fromOffset(0, 44)
body.Size = UDim2.new(1, 0, 1, -44)
body.BackgroundTransparency = 1
body.BorderSizePixel = 0
body.Parent = window

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 14)
padding.PaddingRight = UDim.new(0, 14)
padding.Parent = body

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = body

local function makeLabel(name, text, height, size)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = UDim2.new(1, 0, 0, height)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225, 227, 234)
    label.TextSize = size or 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.LayoutOrder = 1
    label.Parent = body
    return label
end

local status = makeLabel("Status", "Status: OFF", 24, 13)
status.TextColor3 = Color3.fromRGB(180, 183, 192)

local target = makeLabel("Target", "Target: None", 24, 14)
target.LayoutOrder = 2

local details = makeLabel("Details", "Rarity: —   Score: —   Area: —", 24, 12)
details.LayoutOrder = 3
details.TextColor3 = Color3.fromRGB(190, 193, 203)

local toggle = Instance.new("TextButton")
toggle.Name = "BestEggToggle"
toggle.Size = UDim2.new(1, 0, 0, 40)
toggle.BackgroundColor3 = Color3.fromRGB(42, 44, 56)
toggle.BorderSizePixel = 0
toggle.AutoButtonColor = false
toggle.Font = Enum.Font.GothamMedium
toggle.Text = "Best Egg Scanner: OFF"
toggle.TextColor3 = Color3.fromRGB(240, 241, 246)
toggle.TextSize = 13
toggle.LayoutOrder = 4
toggle.Parent = body

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggle

local scan = Instance.new("TextButton")
scan.Name = "ScanNow"
scan.Size = UDim2.new(1, 0, 0, 36)
scan.BackgroundColor3 = Color3.fromRGB(34, 36, 47)
scan.BorderSizePixel = 0
scan.AutoButtonColor = false
scan.Font = Enum.Font.Gotham
scan.Text = "Scan Best Egg Now"
scan.TextColor3 = Color3.fromRGB(220, 222, 230)
scan.TextSize = 12
scan.LayoutOrder = 5
scan.Parent = body

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 10)
scanCorner.Parent = scan

local hint = makeLabel("Hint", "Provider: _G.GetEggSnapshot()", 20, 10)
hint.LayoutOrder = 6
hint.TextColor3 = Color3.fromRGB(135, 138, 148)

-- Dragging (same behavior as the working UI)
local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = window.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
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
        local delta = input.Position - dragStart
        window.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

-- Minimize / restore
local minimized = false
local normalSize = window.Size

minimize.MouseEnter:Connect(function()
    TweenService:Create(
        minimize,
        TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(58, 60, 74)}
    ):Play()
end)

minimize.MouseLeave:Connect(function()
    TweenService:Create(
        minimize,
        TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(42, 44, 56)}
    ):Play()
end)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        minimize.Text = "+"
        body.Visible = false

        TweenService:Create(
            window,
            TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = UDim2.fromOffset(normalSize.X.Offset, 44)}
        ):Play()
    else
        minimize.Text = "−"
        body.Visible = true

        TweenService:Create(
            window,
            TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = normalSize}
        ):Play()
    end
end)

-- ==============================================================================
-- CLIENT AC NEUTRALIZER & UGI CONSTANT WIPER (Layer 1 + Layer 2)
-- ==============================================================================
local function bypassClientDetections()
    if typeof(filtergc) ~= "function" or typeof(debug) ~= "table" or typeof(debug.getupvalues) ~= "function" then
        return false, "no filtergc"
    end
    local ok, fn = pcall(function()
        return filtergc("function", {
            Constants = { "gmatch", "GetFullName" },
        }, true)
    end)
    if not ok or type(fn) ~= "function" then
        return false, "filter miss"
    end
    local setMeta = (typeof(setrawmetatable) == "function" and setrawmetatable)
        or (typeof(setmetatable) == "function" and setmetatable)
    if not setMeta then
        return false, "no setmeta"
    end
    local blocked = 0
    local okUv, ups = pcall(debug.getupvalues, fn)
    if not okUv or type(ups) ~= "table" then
        return false, "no upvalues"
    end
    for _, tbl in pairs(ups) do
        if typeof(tbl) == "table" then
            local okSet = pcall(setMeta, tbl, {
                __newindex = function() end,
            })
            if okSet then
                blocked = blocked + 1
            end
        end
    end
    return blocked > 0, blocked
end

pcall(bypassClientDetections)

-- Runtime AC Detection Table Freezer (Neutralizes violation storage)
pcall(function()
    local getgc = getgc or (debug and debug.getgc)
    local setmeta = setrawmetatable or setmetatable
    local getmeta = getrawmetatable or getmetatable

    if getgc and setmeta then
        for _, obj in ipairs(getgc(true)) do
            if typeof(obj) == "table" and not (getmeta and getmeta(obj)) then
                local mainrun = false
                for _, v in pairs(obj) do
                    if v == obj then
                        mainrun = true
                        break
                    end
                end
                if mainrun then
                    for _, v in pairs(obj) do
                        if typeof(v) == "number" and v >= 1 and v <= 3 and obj[v] == nil then
                            pcall(setmeta, obj, { __newindex = function() end })
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- UGI Constant Wiper (neutralizes ReplicatedFirst.UGI watchdog)
pcall(function()
    local getconstants = getconstants or (debug and debug.getconstants)
    local setconstant = setconstant or (debug and debug.setconstant)
    local islclosure = islclosure or function(Function)
        return not pcall(setfenv, getfenv(Function))
    end

    if getgc and getconstants and setconstant then
        for _, Function in ipairs(getgc(true)) do
            if typeof(Function) == "function" and islclosure(Function) then
                local ok, Source = pcall(debug.info, Function, "s")
                if ok and type(Source) == "string" and Source:find("ReplicatedFirst", 1, true) and Source:find("UGI", 1, true) then
                    local okC, Constants = pcall(getconstants, Function)
                    if okC and type(Constants) == "table" then
                        for Index, Constant in next, Constants do
                            if type(Constant) == "string" and Constant == "Humanoid" then
                                pcall(setconstant, Function, Index, "")
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Secondary Layer: X-14 Stack Scrubber & Token Neutralizer
pcall(function()
    local getconstants = getconstants or (debug and debug.getconstants)
    local islclosure = islclosure or function(fn) return not pcall(setfenv, getfenv(fn)) end
    local HookFn = hookfunction or replaceclosure or hookfunc
    if getgc and getconstants and HookFn and debug and debug.getstack and debug.setstack then
        for _, fn in ipairs(getgc(true)) do
            if typeof(fn) == "function" and islclosure(fn) then
                local ok, consts = pcall(getconstants, fn)
                if ok and type(consts) == "table" and table.find(consts, "X-14") then
                    local cb = nil
                    cb = HookFn(fn, function(...)
                        local stack = debug.getstack(1)
                        if type(stack) == "table" then
                            for idx, val in pairs(stack) do
                                if val == "X-14" then
                                    pcall(debug.setstack, 1, idx, nil)
                                end
                            end
                        end
                        if cb then return cb(...) end
                    end)
                end
            end
        end
    end
end)

-- Layer 3: Anti-Tamper State Table Sanitizer (19-upvalue detection neutralization)
pcall(function()
    local getgc = getgc or (debug and debug.getgc)
    local islclosure = islclosure or function(v) return not pcall(setfenv, getfenv(v)) end
    local getupvalues = getupvalues or (debug and debug.getupvalues)
    local getupvalue = getupvalue or (debug and debug.getupvalue)
    local setupvalue = setupvalue or (debug and debug.setupvalue)
    local clonefunction = clonefunction or function(f) return function(...) return f(...) end end

    if getgc and getupvalues and getupvalue and setupvalue then
        for _, v in ipairs(getgc(true)) do
            if typeof(v) == "function" and islclosure(v) then
                local ok, upvs = pcall(getupvalues, v)
                if ok and upvs and #upvs == 19 then
                    local ok2, u2 = pcall(getupvalue, v, 2)
                    if ok2 and typeof(u2) == "function" then
                        local old = clonefunction(u2)
                        pcall(setupvalue, v, 2, function(a, b)
                            if b and typeof(b) == "table" then
                                pcall(setmetatable, b, {})
                            end
                            return old(a, b)
                        end)
                    end
                end
            end
        end
    end
end)
-- -----------------------------------------------------------------------------
-- Best-value egg scanner
-- Uses the game's exposed client EggState snapshot when available.
-- -----------------------------------------------------------------------------

local EggState
local RarityData
local AssetsData
local AreasData

local function safeRequire(parent, name)
    local obj = parent and parent:FindFirstChild(name)
    if not obj then
        return nil
    end
    local ok, result = pcall(require, obj)
    return ok and result or nil
end

pcall(function()
    local client = ReplicatedStorage:FindFirstChild("Client")
    local data = ReplicatedStorage:FindFirstChild("Data")
    EggState = safeRequire(client, "EggState")
    RarityData = safeRequire(data, "Rarity")
    AssetsData = safeRequire(data, "Assets")
    AreasData = safeRequire(data, "Areas")
end)

local RARITY_SCORE = {
    Titan = 1100, Divine = 1000, Transcendent = 1000, Superior = 1000,
    Eternal = 900, Limited = 900, Secret = 800, Exotic = 800,
    Cosmic = 700, Exclusive = 700, Admin = 700, Mythic = 600,
    Mythical = 600, Prismatic = 600, Rainbow = 600, ["Squishy God"] = 600,
    BrainrotGod = 600, Legendary = 500, Epic = 400, Rare = 300,
    SuperRare = 200, Celestial = 200, Uncommon = 200, Basic = 100, Common = 100,
}

local function resolveRarity(record)
    if type(record) ~= "table" then
        return "Common", 100
    end

    if record.Rarity ~= nil then
        local r = record.Rarity
        local name = type(r) == "table" and (r.DisplayName or r._id or r.Name) or tostring(r)
        name = tostring(name or "Common")
        local score = RARITY_SCORE[name]
            or (type(r) == "table" and tonumber(r.RarityNumber) and tonumber(r.RarityNumber) * 100)
            or 100
        return name, score
    end

    local category = record.AssetCategory or record.Category or record.Name
    if category and AssetsData then
        local directory = AssetsData.Directory or AssetsData
        local info = directory and directory[category]
        if info and info.Rarity then
            local r = info.Rarity
            local name = type(r) == "table" and (r.DisplayName or r._id or r.Name) or tostring(r)
            name = tostring(name or "Common")
            local score = RARITY_SCORE[name]
                or (type(r) == "table" and tonumber(r.RarityNumber) and tonumber(r.RarityNumber) * 100)
                or 100
            return name, score
        end
    end

    local areas = AreasData and (AreasData.Directory or AreasData)
    local areaInfo = areas and record.AreaId and areas[record.AreaId]
    local rarity = areaInfo and areaInfo.Rarity
    local rarityId = type(rarity) == "table" and (rarity._id or rarity.DisplayName or rarity.Name)
        or (type(rarity) == "string" and rarity)
        or "Common"

    local rarities = RarityData and (RarityData.Rarities or RarityData)
    local rarityInfo = rarities and rarities[rarityId]
    local displayName = (type(rarityInfo) == "table" and (rarityInfo.DisplayName or rarityInfo._id))
        or (type(rarity) == "table" and rarity.DisplayName)
        or rarityId
        or "Common"

    local score = RARITY_SCORE[displayName] or RARITY_SCORE[rarityId]
        or (type(rarity) == "table" and tonumber(rarity.RarityNumber) and tonumber(rarity.RarityNumber) * 100)
        or 100

    return tostring(displayName), score
end

local function isBig(record)
    if type(record) ~= "table" then return false end
    return (tonumber(record.AssetScale) or 1) >= 1.35
        or (tonumber(record.NestScale) or 1) >= 1.0
end

local function calculateScore(record)
    local rarityName, score = resolveRarity(record)
    local mutations = type(record.Mutations) == "table" and record.Mutations or {}

    for _, mutation in ipairs(mutations) do
        if mutation == "Rainbow" then
            score += 35
        elseif mutation == "Gold" or mutation == "Golden" then
            score += 20
        elseif mutation == "Silver" then
            score += 10
        end
    end

    local parasite = record.HasParasite == true
        or record.BaseMutation == "Parasite"
        or record.BaseMutation == "Monstrous"

    if not parasite then
        for _, mutation in ipairs(mutations) do
            if mutation == "Parasite" or mutation == "Monstrous" then
                parasite = true
                break
            end
        end
    end

    if parasite then
        score += 800
    end

    if isBig(record) then
        score += 600
    end

    return rarityName, score
end

local function getSnapshot()
    if EggState and type(EggState.ReadFieldEggs) == "function" then
        local ok, snapshot = pcall(EggState.ReadFieldEggs)
        if ok and type(snapshot) == "table" and type(snapshot.Records) == "table" then
            return snapshot.Records
        end
    end

    local provider = rawget(_G, "GetEggSnapshot")
    if type(provider) == "function" then
        local ok, snapshot = pcall(provider)
        if ok and type(snapshot) == "table" then
            return snapshot.Records or snapshot
        end
    end

    return nil, "EggState.ReadFieldEggs unavailable"
end

local function findBestEgg()
    local records, err = getSnapshot()
    if type(records) ~= "table" then
        return nil, err or "No egg snapshot"
    end

    local best
    for _, record in ipairs(records) do
        if type(record) == "table"
            and record.State == "Slot"
            and record.BoundsCFrame then

            local rarityName, score = calculateScore(record)
            local candidate = {
                record = record,
                uid = record.Uid,
                name = tostring(record.AssetCategory or record.Name or record.Uid or "Unknown Egg"),
                rarity = rarityName,
                score = score,
                area = tostring(record.AreaId or record.Area or "Unknown"),
            }

            if not best or candidate.score > best.score then
                best = candidate
            end
        end
    end

    if not best then
        return nil, "No available field eggs found"
    end

    return best
end

local scannerEnabled = false
local scanThread

local function renderBest()
    local best, err = findBestEgg()
    if not best then
        target.Text = "Target: None"
        details.Text = "Rarity: —   Score: —   Area: —"
        status.Text = "Status: " .. tostring(err or "No target")
        return false
    end

    target.Text = "Target: " .. best.name
    details.Text = string.format("Rarity: %s   Score: %d   Area: %s", best.rarity, best.score, best.area)
    status.Text = "Status: ON • Best value found"
    return true
end

local function stopScanner()
    scannerEnabled = false
    toggle.Text = "Best Egg Scanner: OFF"
    toggle.BackgroundColor3 = Color3.fromRGB(42, 44, 56)
    status.Text = "Status: OFF"
    scanThread = nil
end

local function startScanner()
    if scannerEnabled then return end
    scannerEnabled = true
    toggle.Text = "Best Egg Scanner: ON"
    toggle.BackgroundColor3 = Color3.fromRGB(55, 78, 62)
    renderBest()

    scanThread = task.spawn(function()
        while scannerEnabled and gui.Parent do
            renderBest()
            task.wait(1)
        end
    end)
end

toggle.MouseButton1Click:Connect(function()
    if scannerEnabled then stopScanner() else startScanner() end
end)

scan.MouseButton1Click:Connect(function()
    renderBest()
end)

_G.InstantEGGBestValue = {
    FindBest = findBestEgg,
    Scan = renderBest,
    Enable = startScanner,
    Disable = stopScanner,
}
