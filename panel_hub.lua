local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Control_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- PANEL PRINCIPAL
local panel = Instance.new("Frame")
panel.Name = "ControlPanel"
panel.Size = UDim2.new(0, 400, 0, 300)
panel.Position = UDim2.new(0, 20, 0, 20)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.BorderSizePixel = 0
panel.Visible = true
panel.Parent = screenGui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

-- SIDEBAR VERTICAL
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
sidebar.Parent = panel

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

-- TAB CONTAINER
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -100, 1, 0)
tabContainer.Position = UDim2.new(0, 100, 0, 0)
tabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabContainer.Parent = panel

Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(0, 8)

-- CONTENIDO DE TABS
local tabs = {}

local function createTab(name, text, order)
	local button = Instance.new("TextButton")
	button.Name = name .. "Button"
	button.Size = UDim2.new(1, -10, 0, 40)
	button.Position = UDim2.new(0, 5, 0, 10 + (order - 1) * 45)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.Text = text
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Parent = sidebar
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

	local frame = Instance.new("Frame")
	frame.Name = name .. "Frame"
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = order == 1
	frame.Parent = tabContainer

	tabs[name] = frame

	button.MouseButton1Click:Connect(function()
		for _, tab in pairs(tabs) do
			tab.Visible = false
		end
		frame.Visible = true
	end)
end

-- Crear tabs de ejemplo
createTab("Main", "Principal", 1)
createTab("Config", "Configuración", 2)
createTab("About", "Acerca de", 3)

-- BOTÓN MINIMIZAR
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = panel
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

-- BOTÓN FLOTANTE
local floatingBtn = Instance.new("TextButton")
floatingBtn.Name = "FloatingOpenButton"
floatingBtn.Size = UDim2.new(0, 50, 0, 50)
floatingBtn.Position = UDim2.new(0, 20, 0.5, -25)
floatingBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
floatingBtn.Text = "⚙️"
floatingBtn.TextColor3 = Color3.new(1, 1, 1)
floatingBtn.Font = Enum.Font.Gotham
floatingBtn.TextSize = 24
floatingBtn.Visible = false
floatingBtn.Parent = screenGui
Instance.new("UICorner", floatingBtn).CornerRadius = UDim.new(1, 0)

-- DRAG para el botón flotante
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	floatingBtn.Position = UDim2.new(
		0, startPos.X.Offset + delta.X,
		0, startPos.Y.Offset + delta.Y
	)
end

floatingBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = floatingBtn.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

floatingBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- FUNCIONALIDAD
minimizeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(panel, TweenInfo.new(0.3), {Position = UDim2.new(0, -450, 0, 20)}):Play()
	task.wait(0.3)
	panel.Visible = false
	floatingBtn.Visible = true
end)

floatingBtn.MouseButton1Click:Connect(function()
	panel.Visible = true
	TweenService:Create(panel, TweenInfo.new(0.3), {Position = UDim2.new(0, 20, 0, 20)}):Play()
	floatingBtn.Visible = false
end)
