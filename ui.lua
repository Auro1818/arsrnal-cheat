local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", CG)
ScreenGui.Name = "ArsenalCheatUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 160, 0, 150)
Frame.Position = UDim2.new(0, 40, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.2
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Text = "⚙️ Arsenal Cheat Menu"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- Toggle Helper
local function createToggle(label, key, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Text = label .. " [ON]"
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.BorderSizePixel = 0

	getgenv().CFG = getgenv().CFG or {}
	getgenv().CFG[key] = true

	btn.MouseButton1Click:Connect(function()
		getgenv().CFG[key] = not getgenv().CFG[key]
		btn.Text = label .. (getgenv().CFG[key] and " [ON]" or " [OFF]")
		callback(getgenv().CFG[key])
	end)
end

-- Tạo các nút toggle
createToggle("ESP", "ESP", function(v) end)
createToggle("SilentAim", "SilentAim", function(v) end)
createToggle("WallBang", "WallBang", function(v) end)

-- Nút ẩn/hiện UI
local toggleBtn = Instance.new("TextButton", ScreenGui)
toggleBtn.Text = "☰"
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 0, 0.5, -20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.ZIndex = 5

toggleBtn.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

-- Cũng cho phép dùng RightShift để bật/tắt (PC support)
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightShift then
		Frame.Visible = not Frame.Visible
	end
end)
