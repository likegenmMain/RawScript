local function hasGethui()
    local success, result = pcall(function()
        return gethui()
    end)
    return success and result ~= nil
end

if not hasGethui() then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/likegenmMain/RawScript/refs/heads/main/Script2.lua"))()
    return
end

local function getExecutorName()
    local success, name = pcall(function()
        return tostring(identifyexecutor())
    end)
    return success and name or "Unknown"
end

local function checkUNC()
    if UNC and type(UNC) == "table" and UNC.percent then
        return UNC.percent
    end
    if sUNC and type(sUNC) == "table" and sUNC.percent then
        return sUNC.percent
    end
    
    local functions = {
        "getgc", "getgenv", "getrenv", "hookfunction", "hookmetamethod",
        "newcclosure", "getrawmetatable", "setrawmetatable", "getnamecallmethod",
        "isreadonly", "setreadonly", "getconstants", "getinfo",
        "getloadedmodules", "getsenv", "getmenv",
        "firetouchinterest", "firesignal", "fireclickdetector", "fireproximityprompt",
        "setclipboard", "gethui", "getinstances", "getnilinstances",
        "getscripts", "getrunningscripts"
    }
    
    local found = 0
    for _, func in ipairs(functions) do
        pcall(function()
            if _G[func] or getfenv()[func] then
                found = found + 1
            end
        end)
    end
    
    return math.floor((found / #functions) * 100)
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local currentGameId = game.GameId
local executorName = getExecutorName()
local httprequest = request or http_request or (http and http.request)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Likegenm Loader"
screenGui.Parent = gethui()

local isLoaded = false

local function playNotificationSound(isSuccess)
    local sound = Instance.new("Sound")
    sound.Parent = screenGui
    sound.Volume = 1.0
    if isSuccess then
        sound.SoundId = "rbxassetid://9120388700"
    else
        sound.SoundId = "rbxassetid://2760979672"
    end
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local function openDiscordInvite()
    local invite = "likegenm"
    local success, result = pcall(function()
        return HttpService:JSONDecode(httprequest({
            Url = "https://ptb.discord.com/api/invites/" .. invite,
            Method = "GET"
        }).Body)
    end)

    if success and result then
        httprequest({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Origin"] = "https://discord.com"
            },
            Body = HttpService:JSONEncode({
                cmd = "INVITE_BROWSER",
                args = {
                    code = result.code
                },
                nonce = HttpService:GenerateGUID(false)
            })
        })
    else
        pcall(function() syn_io_open("https://discord.gg/" .. invite) end)
        pcall(function() setclipboard("https://discord.gg/" .. invite) end)
    end
end

local function getExecutorColor(name)
    local lower = name:lower()
    if lower:find("wave") then return Color3.fromRGB(0, 191, 255)
    elseif lower:find("ronix") then return Color3.fromRGB(255, 69, 0)
    elseif lower:find("solara") then return Color3.fromRGB(255, 215, 0)
    elseif lower:find("xeno") then return Color3.fromRGB(255, 20, 147)
    elseif lower:find("nihon") then return Color3.fromRGB(138, 43, 226)
    elseif lower:find("codex") then return Color3.fromRGB(0, 255, 255)
    elseif lower:find("delta") then return Color3.fromRGB(255, 128, 0)
    elseif lower:find("arceus") then return Color3.fromRGB(255, 0, 0)
    else return Color3.fromRGB(255, 255, 255) end
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 300)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
})
gradient.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
topBar.BorderSizePixel = 0
topBar.ZIndex = 11
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local topTitle = Instance.new("TextLabel")
topTitle.Size = UDim2.new(1, 0, 1, 0)
topTitle.BackgroundTransparency = 1
topTitle.Text = "  Likegenm Scripts"
topTitle.Font = Enum.Font.GothamBlack
topTitle.TextSize = 22
topTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
topTitle.TextXAlignment = Enum.TextXAlignment.Left
topTitle.ZIndex = 12
topTitle.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 65)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Initializing"
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 36
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.ZIndex = 11
titleLabel.Parent = mainFrame

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, 0, 0, 25)
subtitleLabel.Position = UDim2.new(0, 0, 0, 110)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Preparing your experience..."
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 16
subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
subtitleLabel.ZIndex = 11
subtitleLabel.Parent = mainFrame

local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(0, 100, 0, 3)
accentLine.Position = UDim2.new(0.5, -50, 0, 140)
accentLine.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 11
accentLine.Parent = mainFrame

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(1, 0)
accentCorner.Parent = accentLine

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 155)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Checking environment..."
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextColor3 = Color3.fromRGB(120, 120, 150)
statusLabel.ZIndex = 11
statusLabel.Parent = mainFrame

local executorLabel = Instance.new("TextLabel")
executorLabel.Size = UDim2.new(1, 0, 0, 20)
executorLabel.Position = UDim2.new(0, 0, 0, 175)
executorLabel.BackgroundTransparency = 1
executorLabel.Text = "Executor: " .. executorName
executorLabel.Font = Enum.Font.Gotham
executorLabel.TextSize = 13
executorLabel.TextColor3 = getExecutorColor(executorName)
executorLabel.ZIndex = 11
executorLabel.Parent = mainFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 400, 0, 6)
progressBar.Position = UDim2.new(0.5, -200, 0, 205)
progressBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
progressBar.BorderSizePixel = 0
progressBar.ZIndex = 11
progressBar.Parent = mainFrame

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(1, 0)
progressCorner.Parent = progressBar

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 12
progressFill.Parent = progressBar

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = progressFill

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(0, 60, 0, 20)
percentLabel.Position = UDim2.new(0.5, -30, 0, 218)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextSize = 14
percentLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
percentLabel.ZIndex = 11
percentLabel.Parent = mainFrame

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(1, 0, 0, 15)
versionLabel.Position = UDim2.new(0, 0, 0, 270)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v1.0 | discord.gg/likegenm"
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 11
versionLabel.TextColor3 = Color3.fromRGB(80, 80, 100)
versionLabel.ZIndex = 11
versionLabel.Parent = mainFrame

local particles = {}
for i = 1, 20 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, 2, 0, 2)
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BackgroundTransparency = 0.7
    particle.BorderSizePixel = 0
    particle.ZIndex = 11
    particle.Parent = mainFrame
    particles[i] = {obj = particle, speed = math.random(10, 30) / 10, offset = math.random(0, 100) / 10}
end

local function updateProgress(percent, text, statusText)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
    percentLabel.Text = math.floor(percent * 100) .. "%"
    if text then titleLabel.Text = text end
    if statusText then statusLabel.Text = statusText end
end

local hue = 0
RunService.RenderStepped:Connect(function()
    if isLoaded then return end
    hue = (hue + 0.005) % 1
    local color = Color3.fromHSV(hue, 1, 1)
    accentLine.BackgroundColor3 = color
    progressFill.BackgroundColor3 = color
    
    for _, data in ipairs(particles) do
        local newY = data.obj.Position.Y.Scale - (0.002 * data.speed)
        if newY < 0 then newY = 1 end
        data.obj.Position = UDim2.new(data.obj.Position.X.Scale, 0, newY, 0)
        data.obj.BackgroundTransparency = 0.7 + math.sin(tick() * data.speed + data.offset) * 0.2
    end
end)

local function fadeOutAndDestroy()
    isLoaded = true
    
    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(topBar, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(subtitleLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(statusLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(executorLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(percentLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(versionLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(progressBar, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(progressFill, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(accentLine, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(topTitle, tweenInfo, {TextTransparency = 1}):Play()
    
    task.wait(1.5)
    pcall(function()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
    end)
end

local function checkGame()
    updateProgress(0.05, "Checking environment", "Verifying executor...")
    task.wait(0.4)
    
    local uncPercent = checkUNC()
    executorLabel.Text = executorName .. " | UNC: " .. uncPercent .. "%"
    
    if uncPercent < 70 then
        statusLabel.Text = "Limited mode - some features disabled"
    elseif uncPercent < 80 then
        statusLabel.Text = "Standard mode - ready to use"
    else
        statusLabel.Text = "Optimal mode - all features enabled"
    end
    
    updateProgress(0.15, "Checking environment", statusLabel.Text)
    task.wait(0.5)
    
    updateProgress(0.25, "Verifying game", "Game ID: " .. tostring(currentGameId))
    task.wait(0.5)
    
    local gameScripts = {
        [3808081382] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/TSB.lua", "The Strongest Battlegrounds"},
        [3109731140] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/Intruder.lua", "Intruder"},
        [66654135] = {"https://raw.githubusercontent.com/Likegenm/Real-Scripts/refs/heads/main/MM2.lua", "Murder Mystery 2"},
        [99402433] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/Speedrun.lua", "Speedrun 12"},
        [6699967032] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/Fields.lua", "The Field"},
        [6280758286] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/ArmyRP.lua", "Army Roleplay"},
        [1489026993] = {"https://raw.githubusercontent.com/Likegenm/Real-Scripts/refs/heads/main/SK.lua", "Survive the Killer"},
        [4777817887] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/BladeBall.lua", "Blade Ball"},
        [1116949753] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/Isle.lua", "The Isle"},
        [7633926880] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/BloxStrikelua", "BloxStrike"},
        [9363735110] = {"https://raw.githubusercontent.com/Likegenm/Real-Scripts/refs/heads/main/ETFB.lua", "Escape Tsunami for Brainrots"},
        [8581084604] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/Murino.lua", "Murino"},
        [7429689898] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/TIAP2.lua", "Troll is a pinning 2"},
        [210851291] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/BBFT.lua", "BBFT"},
        [1430007363] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/Granny.lua", "Granny: Multiplayer"},
        [2251388500] = {"https://raw.githubusercontent.com/likegenmMain/Scripts/refs/heads/main/Twisted.lua", "Twisted"},
        [2619619496] = {"https://raw.githubusercontent.com/likegenmMain/Raw/refs/heads/main/bedwars.lua", "Bedwars"}
    }

    if gameScripts[currentGameId] then
        updateProgress(0.5, "Game found", gameScripts[currentGameId][2])
        task.wait(0.5)
        
        updateProgress(0.7, "Loading script", "Downloading from repository...")
        task.wait(0.5)
        
        local success, errorMsg = pcall(function()
            loadstring(game:HttpGet(gameScripts[currentGameId][1], true))()
        end)

        if success then
            updateProgress(1, "Ready", "Script loaded successfully!")
            playNotificationSound(true)
        else
            updateProgress(1, "Error", "Failed to load script")
            playNotificationSound(false)
        end
    else
        updateProgress(1, "Not supported", "This game is not supported yet")
        playNotificationSound(false)
    end

    fadeOutAndDestroy()
    task.wait(1)
    openDiscordInvite()
end

coroutine.wrap(checkGame)()
