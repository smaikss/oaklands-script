local CoreGui = game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "OaklandsKey"
gui.Parent = CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,320,0,190)
frame.Position = UDim2.new(0.5,-160,0.5,-95)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.Text = "🔑 Oaklands Login"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0,280,0,40)
box.Position = UDim2.new(0,20,0,60)
box.PlaceholderText = "Enter key..."
box.Text = ""
box.TextScaled = true

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,25)
status.Position = UDim2.new(0,0,0,105)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.new(1,1,1)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0,280,0,40)
btn.Position = UDim2.new(0,20,0,135)
btn.Text = "LOGIN"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
btn.TextColor3 = Color3.new(1,1,1)

btn.MouseButton1Click:Connect(function()

	local key = box.Text

	status.Text = "Checking..."

	wait(0.7)

	if key == "VLAD123" then
		status.Text = "Success!"
		wait(0.5)
		gui:Destroy()

		loadstring(game:HttpGet("https://raw.githubusercontent.com/smaikss/oaklands-script/main/main.lua"))()

	else
		status.Text = "Invalid key"
	end
end)
