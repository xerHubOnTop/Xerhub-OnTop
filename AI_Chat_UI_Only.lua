-- AI Chat GUI - UI Only (Loadstring this)
-- This file creates the visual interface only

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- THEME CONFIG - Modern Dark Theme
-- ============================================
local CONFIG = {
    Theme = {
        Background = Color3.fromRGB(15, 15, 20),
        Header = Color3.fromRGB(25, 25, 35),
        BubblePlayer = Color3.fromRGB(88, 101, 242),
        BubbleAI = Color3.fromRGB(35, 35, 48),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 165),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentHover = Color3.fromRGB(120, 130, 255),
        CopyButton = Color3.fromRGB(50, 50, 65),
        CopyButtonHover = Color3.fromRGB(70, 70, 90),
        Error = Color3.fromRGB(237, 66, 69),
        Success = Color3.fromRGB(59, 165, 93),
        Border = Color3.fromRGB(50, 50, 65),
        InputBg = Color3.fromRGB(28, 28, 38),
        Online = Color3.fromRGB(59, 165, 93)
    },
    Mobile = {
        ChatSize = UDim2.new(0, 310, 0, 420),
        ChatPosition = UDim2.new(0.5, -155, 0.5, -210),
        ToggleSize = UDim2.new(0, 54, 0, 54),
        TogglePos = UDim2.new(1, -74, 1, -100),
        FontSize = 13,
        HeaderHeight = 52
    },
    Desktop = {
        ChatSize = UDim2.new(0, 400, 0, 540),
        ChatPosition = UDim2.new(0.5, -200, 0.5, -270),
        ToggleSize = UDim2.new(0, 58, 0, 58),
        TogglePos = UDim2.new(1, -82, 1, -110),
        FontSize = 14,
        HeaderHeight = 56
    },
    Draggable = true,
    AnimSpeed = 0.3
}

-- ============================================
-- GLOBAL TABLE FOR MAIN SCRIPT TO ACCESS
-- ============================================
getgenv().AIChatUI = {
    Elements = {},
    Config = CONFIG,
    Functions = {}
}

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local currentConfig = isMobile and CONFIG.Mobile or CONFIG.Desktop

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or CONFIG.Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.4
    stroke.Parent = parent
    return stroke
end

local function createShadow(parent, offset, transparency, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, offset or 8)
    shadow.Size = size or UDim2.new(1, 32, 1, 32)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    shadow.Parent = parent
    return shadow
end

local function tween(obj, duration, props, easing)
    local info = TweenInfo.new(duration or CONFIG.AnimSpeed, easing or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

AIChatUI.Functions.Tween = tween
AIChatUI.Functions.CreateCorner = createCorner
AIChatUI.Functions.CreateStroke = createStroke

-- ============================================
-- SCREEN GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AIChatGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui
AIChatUI.Elements.ScreenGui = screenGui

-- ============================================
-- TOGGLE BUTTON - Floating Action Button
-- ============================================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = currentConfig.ToggleSize
toggleBtn.Position = currentConfig.TogglePos
toggleBtn.BackgroundColor3 = CONFIG.Theme.Accent
toggleBtn.Text = "AI"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 20
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = screenGui
createCorner(toggleBtn, 18)
createShadow(toggleBtn, 6, 0.55, UDim2.new(1, 36, 1, 36))

-- Pulse effect
local pulse = Instance.new("Frame")
pulse.Name = "Pulse"
pulse.Size = UDim2.new(1, 0, 1, 0)
pulse.BackgroundColor3 = CONFIG.Theme.Accent
pulse.BackgroundTransparency = 0.75
pulse.BorderSizePixel = 0
pulse.ZIndex = -1
pulse.Parent = toggleBtn
createCorner(pulse, 18)

local function runPulse()
    tween(pulse, 2, {Size = UDim2.new(1.6, 0, 1.6, 0), Position = UDim2.new(-0.3, 0, -0.3, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Sine).Completed:Connect(function()
        if not pulse.Parent then return end
        pulse.Size = UDim2.new(1, 0, 1, 0)
        pulse.Position = UDim2.new(0, 0, 0, 0)
        pulse.BackgroundTransparency = 0.75
        runPulse()
    end)
end
runPulse()

toggleBtn.MouseEnter:Connect(function()
    tween(toggleBtn, 0.2, {BackgroundColor3 = CONFIG.Theme.AccentHover, Size = UDim2.new(0, currentConfig.ToggleSize.X.Offset + 5, 0, currentConfig.ToggleSize.Y.Offset + 5)})
end)
toggleBtn.MouseLeave:Connect(function()
    tween(toggleBtn, 0.2, {BackgroundColor3 = CONFIG.Theme.Accent, Size = currentConfig.ToggleSize})
end)

AIChatUI.Elements.ToggleButton = toggleBtn

-- ============================================
-- MAIN CHAT FRAME
-- ============================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "ChatFrame"
mainFrame.Size = currentConfig.ChatSize
mainFrame.Position = currentConfig.ChatPosition
mainFrame.BackgroundColor3 = CONFIG.Theme.Background
mainFrame.BackgroundTransparency = 0.02
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
createCorner(mainFrame, 24)
createStroke(mainFrame, CONFIG.Theme.Border, 1.5)
createShadow(mainFrame, 10, 0.45, UDim2.new(1, 40, 1, 40))

-- Background gradient
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.Theme.Background),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 30))
})
bgGradient.Rotation = 135
bgGradient.Parent = mainFrame

AIChatUI.Elements.MainFrame = mainFrame

-- ============================================
-- HEADER
-- ============================================
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, currentConfig.HeaderHeight)
header.BackgroundColor3 = CONFIG.Theme.Header
header.BackgroundTransparency = 0.05
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 24)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 18)
headerFix.Position = UDim2.new(0, 0, 1, -18)
headerFix.BackgroundColor3 = CONFIG.Theme.Header
headerFix.BackgroundTransparency = 0.05
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Avatar
local avatar = Instance.new("Frame")
avatar.Size = UDim2.new(0, 36, 0, 36)
avatar.Position = UDim2.new(0, 16, 0.5, -18)
avatar.BackgroundColor3 = CONFIG.Theme.Accent
avatar.BorderSizePixel = 0
avatar.Parent = header
createCorner(avatar, 12)

local avatarIcon = Instance.new("TextLabel")
avatarIcon.Size = UDim2.new(1, 0, 1, 0)
avatarIcon.BackgroundTransparency = 1
avatarIcon.Text = "AI"
avatarIcon.TextSize = 16
avatarIcon.Font = Enum.Font.GothamBold
avatarIcon.Parent = avatar

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 130, 1, 0)
title.Position = UDim2.new(0, 60, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AI Assistant"
title.TextColor3 = CONFIG.Theme.TextPrimary
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Status dot
local statusContainer = Instance.new("Frame")
statusContainer.Size = UDim2.new(0, 10, 0, 10)
statusContainer.Position = UDim2.new(0, 192, 0.5, -5)
statusContainer.BackgroundTransparency = 1
statusContainer.Parent = header

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(1, 0, 1, 0)
statusDot.BackgroundColor3 = CONFIG.Theme.Online
statusDot.BorderSizePixel = 0
statusDot.Parent = statusContainer
createCorner(statusDot, 5)

local statusPulse = statusDot:Clone()
statusPulse.Size = UDim2.new(2, 0, 2, 0)
statusPulse.Position = UDim2.new(-0.5, 0, -0.5, 0)
statusPulse.BackgroundTransparency = 0.5
statusPulse.ZIndex = -1
statusPulse.Parent = statusContainer
createCorner(statusPulse, 5)

spawn(function()
    while statusPulse and statusPulse.Parent do
        tween(statusPulse, 1.5, {Size = UDim2.new(2.8, 0, 2.8, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Sine)
        task.wait(1.5)
        if not (statusPulse and statusPulse.Parent) then break end
        statusPulse.Size = UDim2.new(2, 0, 2, 0)
        statusPulse.BackgroundTransparency = 0.5
    end
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 38, 0, 38)
closeBtn.Position = UDim2.new(1, -48, 0.5, -19)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = ""
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
createCorner(closeBtn, 10)

local closeIcon = Instance.new("TextLabel")
closeIcon.Size = UDim2.new(1, 0, 1, 0)
closeIcon.BackgroundTransparency = 1
closeIcon.Text = "X"
closeIcon.TextColor3 = CONFIG.Theme.TextSecondary
closeIcon.TextSize = 16
closeIcon.Font = Enum.Font.GothamBold
closeIcon.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.2, {BackgroundColor3 = CONFIG.Theme.Error, BackgroundTransparency = 0.2})
    closeIcon.TextColor3 = Color3.new(1, 1, 1)
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(45, 45, 55), BackgroundTransparency = 0.3})
    closeIcon.TextColor3 = CONFIG.Theme.TextSecondary
end)

AIChatUI.Elements.Header = header
AIChatUI.Elements.CloseButton = closeBtn

-- ============================================
-- SCROLLING CHAT AREA
-- ============================================
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ChatScroll"
scrollFrame.Size = UDim2.new(1, -24, 1, -(currentConfig.HeaderHeight + 115))
scrollFrame.Position = UDim2.new(0, 12, 0, currentConfig.HeaderHeight + 10)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = CONFIG.Theme.Accent
scrollFrame.ScrollBarImageTransparency = 0.25
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 14)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

local scrollPadding = Instance.new("UIPadding")
scrollPadding.PaddingTop = UDim.new(0, 10)
scrollPadding.PaddingBottom = UDim.new(0, 14)
scrollPadding.Parent = scrollFrame

AIChatUI.Elements.ScrollFrame = scrollFrame
AIChatUI.Elements.Layout = layout

-- ============================================
-- INPUT AREA
-- ============================================
local inputContainer = Instance.new("Frame")
inputContainer.Name = "InputContainer"
inputContainer.Size = UDim2.new(1, -24, 0, 54)
inputContainer.Position = UDim2.new(0, 12, 1, -66)
inputContainer.BackgroundColor3 = CONFIG.Theme.InputBg
inputContainer.BorderSizePixel = 0
inputContainer.Parent = mainFrame
createCorner(inputContainer, 16)
createStroke(inputContainer, CONFIG.Theme.Border, 1)

local inputBox = Instance.new("TextBox")
inputBox.Name = "InputBox"
inputBox.Size = UDim2.new(1, -64, 1, -10)
inputBox.Position = UDim2.new(0, 16, 0, 5)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "Ask me anything..."
inputBox.PlaceholderColor3 = Color3.fromRGB(95, 95, 110)
inputBox.TextColor3 = CONFIG.Theme.TextPrimary
inputBox.TextSize = currentConfig.FontSize
inputBox.Font = Enum.Font.Gotham
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextWrapped = true
inputBox.ClearTextOnFocus = false
inputBox.Parent = inputContainer

AIChatUI.Elements.InputBox = inputBox

-- Send button
local sendBtn = Instance.new("TextButton")
sendBtn.Name = "SendButton"
sendBtn.Size = UDim2.new(0, 42, 0, 42)
sendBtn.Position = UDim2.new(1, -48, 0, 6)
sendBtn.BackgroundColor3 = CONFIG.Theme.Accent
sendBtn.Text = ""
sendBtn.AutoButtonColor = false
sendBtn.Parent = inputContainer
createCorner(sendBtn, 12)

local sendIcon = Instance.new("TextLabel")
sendIcon.Size = UDim2.new(1, 0, 1, 0)
sendIcon.BackgroundTransparency = 1
sendIcon.Text = ">"
sendIcon.TextColor3 = Color3.new(1, 1, 1)
sendIcon.TextSize = 22
sendIcon.Font = Enum.Font.GothamBold
sendIcon.Parent = sendBtn

sendBtn.MouseEnter:Connect(function()
    tween(sendBtn, 0.2, {BackgroundColor3 = CONFIG.Theme.AccentHover, Size = UDim2.new(0, 44, 0, 44), Position = UDim2.new(1, -49, 0, 5)})
end)
sendBtn.MouseLeave:Connect(function()
    tween(sendBtn, 0.2, {BackgroundColor3 = CONFIG.Theme.Accent, Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(1, -48, 0, 6)})
end)

AIChatUI.Elements.SendButton = sendBtn

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================
local notifContainer = Instance.new("Frame")
notifContainer.Name = "NotifContainer"
notifContainer.Size = UDim2.new(0, 170, 0, 40)
notifContainer.Position = UDim2.new(0.5, -85, 0, -50)
notifContainer.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
notifContainer.BackgroundTransparency = 0.05
notifContainer.BorderSizePixel = 0
notifContainer.Visible = false
notifContainer.ZIndex = 100
notifContainer.Parent = mainFrame
createCorner(notifContainer, 12)
createStroke(notifContainer, CONFIG.Theme.Success, 2)

local notifIcon = Instance.new("TextLabel")
notifIcon.Size = UDim2.new(0, 28, 1, 0)
notifIcon.Position = UDim2.new(0, 12, 0, 0)
notifIcon.BackgroundTransparency = 1
notifIcon.Text = "OK"
notifIcon.TextColor3 = CONFIG.Theme.Success
notifIcon.TextSize = 14
notifIcon.Font = Enum.Font.GothamBold
notifIcon.Parent = notifContainer

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1, -44, 1, 0)
notifText.Position = UDim2.new(0, 36, 0, 0)
notifText.BackgroundTransparency = 1
notifText.Text = "Copied to clipboard!"
notifText.TextColor3 = CONFIG.Theme.TextPrimary
notifText.TextSize = 13
notifText.Font = Enum.Font.GothamBold
notifText.TextXAlignment = Enum.TextXAlignment.Left
notifText.Parent = notifContainer

AIChatUI.Elements.NotifContainer = notifContainer

-- ============================================
-- TYPING INDICATOR
-- ============================================
AIChatUI.Elements.TypingIndicator = nil

function AIChatUI.Functions.ShowTyping()
    if AIChatUI.Elements.TypingIndicator then
        AIChatUI.Elements.TypingIndicator:Destroy()
    end

    local typing = Instance.new("Frame")
    typing.Name = "Typing"
    typing.Size = UDim2.new(0, 85, 0, 38)
    typing.Position = UDim2.new(0, 40, 0, 0)
    typing.BackgroundColor3 = CONFIG.Theme.BubbleAI
    typing.BorderSizePixel = 0
    typing.LayoutOrder = #scrollFrame:GetChildren()
    typing.Parent = scrollFrame
    createCorner(typing, 14)

    for i = 1, 3 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 7, 0, 7)
        dot.Position = UDim2.new(0, 14 + (i-1)*18, 0.5, -3.5)
        dot.BackgroundColor3 = CONFIG.Theme.TextSecondary
        dot.BorderSizePixel = 0
        dot.Parent = typing
        createCorner(dot, 3.5)

        spawn(function()
            while typing and typing.Parent do
                tween(dot, 0.5, {BackgroundTransparency = 0.2}, Enum.EasingStyle.Sine)
                task.wait(0.5)
                if not (typing and typing.Parent) then break end
                tween(dot, 0.5, {BackgroundTransparency = 0.8}, Enum.EasingStyle.Sine)
                task.wait(0.5)
            end
        end)
        task.wait(0.18)
    end

    scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.AbsoluteCanvasSize.Y)
    AIChatUI.Elements.TypingIndicator = typing
end

function AIChatUI.Functions.HideTyping()
    if AIChatUI.Elements.TypingIndicator then
        tween(AIChatUI.Elements.TypingIndicator, 0.25, {BackgroundTransparency = 1}).Completed:Wait()
        AIChatUI.Elements.TypingIndicator:Destroy()
        AIChatUI.Elements.TypingIndicator = nil
    end
end

-- ============================================
-- CREATE MESSAGE BUBBLE
-- ============================================
function AIChatUI.Functions.CreateMessage(text, isAI)
    local scroll = AIChatUI.Elements.ScrollFrame

    local bubbleContainer = Instance.new("Frame")
    bubbleContainer.Name = "Message"
    bubbleContainer.Size = UDim2.new(1, -20, 0, 0)
    bubbleContainer.AutomaticSize = Enum.AutomaticSize.Y
    bubbleContainer.BackgroundTransparency = 1
    bubbleContainer.LayoutOrder = #scroll:GetChildren()

    -- AI Avatar
    if isAI then
        local msgAvatar = Instance.new("Frame")
        msgAvatar.Size = UDim2.new(0, 30, 0, 30)
        msgAvatar.Position = UDim2.new(0, 0, 0, 0)
        msgAvatar.BackgroundColor3 = CONFIG.Theme.Accent
        msgAvatar.BorderSizePixel = 0
        msgAvatar.Parent = bubbleContainer
        createCorner(msgAvatar, 10)

        local msgAvatarIcon = Instance.new("TextLabel")
        msgAvatarIcon.Size = UDim2.new(1, 0, 1, 0)
        msgAvatarIcon.BackgroundTransparency = 1
        msgAvatarIcon.Text = "AI"
        msgAvatarIcon.TextSize = 13
        msgAvatarIcon.Font = Enum.Font.GothamBold
        msgAvatarIcon.Parent = msgAvatar
    end

    -- Bubble
    local bubble = Instance.new("Frame")
    bubble.Size = UDim2.new(0, 0, 0, 0)
    bubble.AutomaticSize = Enum.AutomaticSize.XY
    bubble.Position = isAI and UDim2.new(0, 38, 0, 0) or UDim2.new(1, 0, 0, 0)
    bubble.AnchorPoint = isAI and Vector2.new(0, 0) or Vector2.new(1, 0)
    bubble.BackgroundColor3 = isAI and CONFIG.Theme.BubbleAI or CONFIG.Theme.BubblePlayer
    bubble.BorderSizePixel = 0
    bubble.Parent = bubbleContainer
    createCorner(bubble, 16)

    -- Gradient for AI
    if isAI then
        local bubbleGrad = Instance.new("UIGradient")
        bubbleGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, CONFIG.Theme.BubbleAI),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(42, 42, 55))
        })
        bubbleGrad.Rotation = 140
        bubbleGrad.Parent = bubble
    end

    local maxTextWidth = currentConfig.ChatSize.X.Offset - (isAI and 130 or 90)

    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, maxTextWidth, 0, 0)
    textLabel.AutomaticSize = Enum.AutomaticSize.Y
    textLabel.Position = UDim2.new(0, 16, 0, 12)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = CONFIG.Theme.TextPrimary
    textLabel.TextSize = currentConfig.FontSize
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = bubble

    -- Copy button for AI
    if isAI then
        local copyBtn = Instance.new("TextButton")
        copyBtn.Name = "Copy"
        copyBtn.Size = UDim2.new(0, 30, 0, 30)
        copyBtn.Position = UDim2.new(1, -34, 0, 8)
        copyBtn.BackgroundColor3 = CONFIG.Theme.CopyButton
        copyBtn.Text = "CPY"
        copyBtn.TextSize = 10
        copyBtn.AutoButtonColor = false
        copyBtn.Parent = bubble
        createCorner(copyBtn, 8)

        copyBtn.MouseEnter:Connect(function()
            tween(copyBtn, 0.2, {BackgroundColor3 = CONFIG.Theme.CopyButtonHover, Size = UDim2.new(0, 32, 0, 32)})
        end)
        copyBtn.MouseLeave:Connect(function()
            tween(copyBtn, 0.2, {BackgroundColor3 = CONFIG.Theme.CopyButton, Size = UDim2.new(0, 30, 0, 30)})
        end)

        copyBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if setclipboard then setclipboard(text) end
            end)

            local notif = AIChatUI.Elements.NotifContainer
            notif.Visible = true
            notif.Position = UDim2.new(0.5, -85, 0, 14)
            notif.BackgroundTransparency = 0.05
            tween(notif, 0.3, {Position = UDim2.new(0.5, -85, 0, 14)})
            task.wait(2)
            tween(notif, 0.3, {Position = UDim2.new(0.5, -85, 0, -50), BackgroundTransparency = 1}).Completed:Wait()
            notif.Visible = false
        end)
    end

    -- Calculate size
    local textSize = TextService:GetTextSize(
        text, 
        currentConfig.FontSize, 
        Enum.Font.Gotham, 
        Vector2.new(maxTextWidth, 1000)
    )

    local bubbleWidth = math.min(textSize.X + 56, currentConfig.ChatSize.X.Offset - (isAI and 70 or 50))
    local bubbleHeight = textSize.Y + 24

    bubble.Size = UDim2.new(0, bubbleWidth, 0, bubbleHeight)

    -- Entrance animation
    bubbleContainer.Parent = scroll
    bubble.Position = isAI and UDim2.new(0, 22, 0, 0) or UDim2.new(1, 12, 0, 0)
    tween(bubble, 0.4, {Position = isAI and UDim2.new(0, 38, 0, 0) or UDim2.new(1, 0, 0, 0)}, Enum.EasingStyle.Back)

    task.wait(0.05)
    scroll.CanvasPosition = Vector2.new(0, scroll.AbsoluteCanvasSize.Y)

    return bubbleContainer
end

-- ============================================
-- TOGGLE VISIBILITY
-- ============================================
local isOpen = false

function AIChatUI.Functions.ToggleChat()
    isOpen = not isOpen
    mainFrame.Visible = true

    if isOpen then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.BackgroundTransparency = 1
        tween(mainFrame, 0.45, {
            Size = currentConfig.ChatSize,
            Position = currentConfig.ChatPosition,
            BackgroundTransparency = 0.02
        }, Enum.EasingStyle.Back)

        tween(toggleBtn, 0.3, {BackgroundColor3 = CONFIG.Theme.Error, Rotation = 90})
        toggleBtn.Text = "X"
    else
        tween(mainFrame, 0.35, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(
                mainFrame.Position.X.Scale, mainFrame.Position.X.Offset + currentConfig.ChatSize.X.Offset/2, 
                mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + currentConfig.ChatSize.Y.Offset/2
            ),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Quad).Completed:Wait()

        mainFrame.Visible = false
        tween(toggleBtn, 0.3, {BackgroundColor3 = CONFIG.Theme.Accent, Rotation = 0})
        toggleBtn.Text = "AI"
    end
end

toggleBtn.MouseButton1Click:Connect(AIChatUI.Functions.ToggleChat)
closeBtn.MouseButton1Click:Connect(AIChatUI.Functions.ToggleChat)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        AIChatUI.Functions.ToggleChat()
    end
end)

-- ============================================
-- DRAGGABLE SYSTEM
-- ============================================
if CONFIG.Draggable then
    local dragging = false
    local dragStart, startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            tween(mainFrame, 0.2, {BackgroundTransparency = 0})

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    tween(mainFrame, 0.2, {BackgroundTransparency = 0.02})
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

print("AI Chat UI loaded! Now run the main script.")
