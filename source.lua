--[[
    Advanced Roblox UI Library
    Includes:
    - Tabs
    - Buttons
    - Toggles
    - Sliders
    - Keybinds
    - Notifications
    Size: 280x250
]]

local UILib = {}
UILib.__index = UILib

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- MAIN WINDOW
function UILib:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 280, 0, 250) -- width fixed(0, 280, 0, 250)
    Main.Position = UDim2.new(0.5, -140, 0.5, -125)
    Main.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- darker background
    Main.BorderSizePixel = 0
    Main.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Main.BorderMode = Enum.BorderMode.Outline
    Main.BorderSizePixel = 1 -- outline thickness
    Main.SizeConstraint = Enum.SizeConstraint.RelativeXX
    Main.Parent = ScreenGui

    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TitleBar.Text = title
    TitleBar.TextColor3 = Color3.new(1, 1, 1)
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextSize = 14
    TitleBar.Parent = Main

    -- DRAGGING
    local dragging = false
    local dragStart, startPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(0, 80, 1, -30)
    TabHolder.Position = UDim2.new(0, 0, 0, 30)
    TabHolder.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabHolder.Parent = Main

    local PageHolder = Instance.new("Frame")
    PageHolder.Size = UDim2.new(1, -80, 1, -30)
    PageHolder.Position = UDim2.new(0, 80, 0, 30)
    PageHolder.BackgroundTransparency = 1
    PageHolder.Parent = Main

    local Window = {Tabs = {}, Main = Main, PageHolder = PageHolder, TabHolder = TabHolder}
    setmetatable(Window, UILib)

    return Window
end

-- TABS
function UILib:CreateTab(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 28)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Text = name
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.Parent = self.TabHolder

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = self.PageHolder

    Button.MouseButton1Click:Connect(function()
        for _, tab in ipairs(self.PageHolder:GetChildren()) do tab.Visible = false end
        Page.Visible = true
    end)

    local Tab = {Page = Page}
    setmetatable(Tab, UILib)
    table.insert(self.Tabs, Tab)

    return Tab
end

-- BUTTON
function UILib:CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 30)
    Btn.Position = UDim2.new(0, 10, 0, (#self.Page:GetChildren()) * 35)
    Btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.Parent = self.Page

    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- TOGGLE
function UILib:CreateToggle(text, default, callback)
    local Val = default or false

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 30)
    Btn.Position = UDim2.new(0, 10, 0, (#self.Page:GetChildren()) * 35)
    Btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Text = text .. " (" .. tostring(Val) .. ")"
    Btn.Parent = self.Page

    Btn.MouseButton1Click:Connect(function()
        Val = not Val
        Btn.Text = text .. " (" .. tostring(Val) .. ")"
        if callback then callback(Val) end
    end)
end

-- SLIDER
function UILib:CreateSlider(text, min, max, default, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, (#self.Page:GetChildren()) * 35)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.Parent = self.Page

    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -20, 0, 8)
    SliderBack.Position = UDim2.new(0, 10, 0, (#self.Page:GetChildren() * 32))
    SliderBack.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    SliderBack.Parent = self.Page

    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Slider.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Slider.Parent = SliderBack

    local dragging = false

    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            Slider.Size = UDim2.new(rel, 0, 1, 0)
            local value = math.floor(min + (max - min) * rel)
            Label.Text = text .. ": " .. value
            if callback then callback(value) end
        end
    end)
end

-- KEYBIND
function UILib:CreateKeybind(text, defaultKey, callback)
    local currentKey = defaultKey

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 30)
    Btn.Position = UDim2.new(0, 10, 0, (#self.Page:GetChildren()) * 35)
    Btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Text = text .. " [" .. currentKey.Name .. "]"
    Btn.Parent = self.Page

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "Press any key..."

        local conn; conn = UserInputService.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = inp.KeyCode
                Btn.Text = text .. " [" .. currentKey.Name .. "]"
                if callback then callback(currentKey) end
                conn:Disconnect()
            end
        end)
    end)

    UserInputService.InputBegan:Connect(function(inp)
        if inp.KeyCode == currentKey then
            if callback then callback(currentKey) end
        end
    end)
end

-- NOTIFICATION
function UILib:Notify(text, time)
    time = time or 2

    local Msg = Instance.new("TextLabel")
    Msg.Size = UDim2.new(0, 200, 0, 40)
    Msg.Position = UDim2.new(0.5, -100, 0, -50)
    Msg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Msg.TextColor3 = Color3.new(1, 1, 1)
    Msg.Text = text
    Msg.Font = Enum.Font.GothamBold
    Msg.TextSize = 14
    Msg.Parent = PlayerGui

    task.spawn(function()
        task.wait(time)
        Msg:Destroy()
    end)
end

return UILib
