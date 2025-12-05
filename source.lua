--====================================================
-- SIMPLE CUSTOM UI LIBRARY (250x280 + ANIMATIONS)
--====================================================

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local UILib = {}
UILib.__index = UILib

-- Tween function
local function tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--====================================================
-- WINDOW
--====================================================
function UILib:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.ResetOnSpawn = false

    local Window = Instance.new("Frame", ScreenGui)
    Window.Size = UDim2.new(0, 250, 0, 280)
    Window.Position = UDim2.new(0.5, -125, 0.5, -140)
    Window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Window.BorderSizePixel = 0
    Window.BackgroundTransparency = 1
    Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 8)

    tween(Window, 0.3, {BackgroundTransparency = 0})

    -- Title bar
    local Top = Instance.new("TextLabel", Window)
    Top.Size = UDim2.new(1, 0, 0, 28)
    Top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Top.Text = title or "Window"
    Top.TextColor3 = Color3.new(1, 1, 1)
    Top.Font = Enum.Font.GothamBold
    Top.TextSize = 14
    Top.BorderSizePixel = 0
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

    local TabsHolder = Instance.new("Frame", Window)
    TabsHolder.Size = UDim2.new(1, 0, 1, -28)
    TabsHolder.Position = UDim2.new(0, 0, 0, 28)
    TabsHolder.BackgroundTransparency = 1

    local WindowData = {
        ScreenGui = ScreenGui,
        Window = Window,
        TabsHolder = TabsHolder,
    }

    setmetatable(WindowData, {
        __index = function(_, key)
            return UILib[key]
        end
    })

    return WindowData
end

--====================================================
-- TAB
--====================================================
function UILib:CreateTab(name)
    local Tab = Instance.new("ScrollingFrame", self.TabsHolder)
    Tab.Size = UDim2.new(1, 0, 1, 0)
    Tab.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tab.ScrollBarThickness = 3
    Tab.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", Tab)
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    local TabData = {Tab = Tab}

    setmetatable(TabData, {
        __index = function(_, key)
            return UILib[key]
        end
    })

    return TabData
end

--====================================================
-- BUTTON
--====================================================
function UILib:CreateButton(text, callback)
    local Btn = Instance.new("TextButton", self.Tab)
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        tween(Btn, 0.1, {BackgroundColor3 = Color3.fromRGB(60,60,60)})
        task.wait(0.1)
        tween(Btn, 0.1, {BackgroundColor3 = Color3.fromRGB(45,45,45)})
        callback()
    end)
end

--====================================================
-- TOGGLE
--====================================================
function UILib:CreateToggle(text, default, callback)
    local Toggle = Instance.new("TextButton", self.Tab)
    Toggle.Size = UDim2.new(1, -10, 0, 30)
    Toggle.Text = text
    Toggle.Font = Enum.Font.GothamBold
    Toggle.TextSize = 14
    Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.BorderSizePixel = 0
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

    local state = default

    local function update()
        if state then
            tween(Toggle, 0.2, {BackgroundColor3 = Color3.fromRGB(0,170,0)})
        else
            tween(Toggle, 0.2, {BackgroundColor3 = Color3.fromRGB(45,45,45)})
        end
    end

    update()

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        update()
        callback(state)
    end)
end

--====================================================
-- SLIDER
--====================================================
function UILib:CreateSlider(text, min, max, default, callback)
    local Holder = Instance.new("Frame", self.Tab)
    Holder.Size = UDim2.new(1, -10, 0, 40)
    Holder.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Holder)
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13

    local Slider = Instance.new("Frame", Holder)
    Slider.Size = UDim2.new(1, 0, 0, 20)
    Slider.Position = UDim2.new(0,0,0,18)
    Slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Instance.new("UICorner", Slider).CornerRadius = UDim.new(0,6)

    local Fill = Instance.new("Frame", Slider)
    Fill.Size = UDim2.new(default/max, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0,6)

    local dragging = false

    Slider.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((i.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(rel, 0, 1, 0)

            local val = math.floor(min + (max - min) * rel)
            callback(val)
        end
    end)
end

--====================================================
-- KEYBIND
--====================================================
function UILib:CreateKeybind(text, defaultKey, callback)
    local KeyButton = Instance.new("TextButton", self.Tab)
    KeyButton.Size = UDim2.new(1, -10, 0, 30)
    KeyButton.Text = text.." ["..defaultKey.Name.."]"
    KeyButton.Font = Enum.Font.GothamBold
    KeyButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
    KeyButton.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", KeyButton).CornerRadius = UDim.new(0,6)

    local key = defaultKey
    local waiting = false

    KeyButton.MouseButton1Click:Connect(function()
        waiting = true
        KeyButton.Text = text.." [Press key]"
    end)

    UIS.InputBegan:Connect(function(i)
        if waiting and i.KeyCode ~= Enum.KeyCode.Unknown then
            key = i.KeyCode
            waiting = false
            KeyButton.Text = text.." ["..key.Name.."]"
            callback(key)
        elseif i.KeyCode == key then
            callback(key)
        end
    end)
end

--====================================================
-- TEXTBOX
--====================================================
function UILib:CreateTextbox(text, placeholder, callback)
    local Box = Instance.new("TextBox", self.Tab)
    Box.Size = UDim2.new(1, -10, 0, 30)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 14
    Box.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0,6)

    Box.FocusLost:Connect(function()
        callback(Box.Text)
    end)
end

--====================================================
-- DROPDOWN
--====================================================
function UILib:CreateDropdown(text, list, callback)
    local Button = Instance.new("TextButton", self.Tab)
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.Text = text
    Button.Font = Enum.Font.GothamBold
    Button.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Button.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0,6)

    local open = false
    local OptionsFrame = Instance.new("Frame", self.Tab)
    OptionsFrame.Size = UDim2.new(1, -10, 0, #list * 25)
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
    OptionsFrame.Visible = false
    Instance.new("UICorner", OptionsFrame).CornerRadius = UDim.new(0,6)

    local Layout = Instance.new("UIListLayout", OptionsFrame)

    for _, v in ipairs(list) do
        local Opt = Instance.new("TextButton", OptionsFrame)
        Opt.Size = UDim2.new(1, -4, 0, 25)
        Opt.Text = v
        Opt.Font = Enum.Font.Gotham
        Opt.TextSize = 13
        Opt.BackgroundColor3 = Color3.fromRGB(40,40,40)
        Opt.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", Opt).CornerRadius = UDim.new(0,4)

        Opt.MouseButton1Click:Connect(function()
            Button.Text = text..": "..v
            callback(v)
            OptionsFrame.Visible = false
            open = false
        end)
    end

    Button.MouseButton1Click:Connect(function()
        open = not open
        OptionsFrame.Visible = open
    end)
end

--====================================================
-- NOTIFICATION
--====================================================
function UILib:Notify(msg, time)
    local Note = Instance.new("TextLabel", game.CoreGui)
    Note.Size = UDim2.new(0, 200, 0, 40)
    Note.Position = UDim2.new(1, -210, 1, -100)
    Note.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Note.BackgroundTransparency = 0.3
    Note.Text = msg
    Note.Font = Enum.Font.GothamBold
    Note.TextColor3 = Color3.new(1,1,1)
    Note.TextSize = 14
    Instance.new("UICorner", Note).CornerRadius = UDim.new(0,6)

    tween(Note, 0.3, {Position = UDim2.new(1, -210, 1, -150)})

    task.wait(time or 3)

    tween(Note, 0.3, {Position = UDim2.new(1, 20, 1, -150)})
    task.wait(0.3)
    Note:Destroy()
end

return UILib
