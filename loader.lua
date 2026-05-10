local CoreGui = game:GetService("CoreGui")

-- Видаляємо стару GUI, якщо вона є
pcall(function()
	if CoreGui:FindFirstChild("OaklandsKey") then
		CoreGui.OaklandsKey:Destroy()
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "OaklandsKey"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,320,0,210)
frame.Position = UDim2.new(0.5,-160,0.5,-105)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.Text = "🔑 Oaklands Login"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.BorderSizePixel = 0

local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0,35,0,35)
close.Position = UDim2.new(1,-38,0,2)
close.Text = "X"
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(170,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.BorderSizePixel = 0

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local box = Instance.new("TextBox")
box.Parent = frame
box.Size = UDim2.new(0,280,0,40)
box.Position = UDim2.new(0,20,0,60)
box.PlaceholderText = "Enter key..."
box.Text = ""
box.TextScaled = true
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
box.TextColor3 = Color3.new(1,1,1)
box.BorderSizePixel = 0

local status = Instance.new("TextLabel")
status.Parent = frame
status.Size = UDim2.new(1,0,0,25)
status.Position = UDim2.new(0,0,0,108)
status.BackgroundTransparency = 1
status.Text = ""
status.TextScaled = true
status.TextColor3 = Color3.new(1,1,1)

local btn = Instance.new("TextButton")
btn.Parent = frame
btn.Size = UDim2.new(0,280,0,40)
btn.Position = UDim2.new(0,20,0,140)
btn.Text = "LOGIN"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
btn.TextColor3 = Color3.new(1,1,1)
btn.BorderSizePixel = 0

local keyBtn = Instance.new("TextButton")
keyBtn.Parent = frame
keyBtn.Size = UDim2.new(0,280,0,25)
keyBtn.Position = UDim2.new(0,20,0,183)
keyBtn.Text = "Get Key"
keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
keyBtn.TextColor3 = Color3.new(1,1,1)
keyBtn.BorderSizePixel = 0

keyBtn.MouseButton1Click:Connect(function()
	setclipboard("https://scriptland.rf.gd")
	status.Text = "Link copied"
end)

btn.MouseButton1Click:Connect(function()
	local key = box.Text

	if key == "" then
		status.Text = "Enter key"
		return
	end

	status.Text = "Checking..."

	local ok, result = pcall(function()
		-- Додаємо випадкове число, щоб уникнути кешування результату
		return game:HttpGet("https://scriptland.rf.gd/check.php?key="..key.."&cb="..math.random(1,9999))
	end)

	if not ok then
		status.Text = "Server offline"
		warn("Error fetching key: "..tostring(result))
		return
	end

	-- Обробка результату
	local rawResponse = tostring(result)
	local cleanResult = rawResponse:gsub("%s+", ""):upper()
	
	-- Для дебагу: виведемо в консоль (F9), що саме прийшло від сайту
	print("Server Response: [" .. rawResponse .. "]")

	if string.find(cleanResult, "VALID") then
		status.Text = "✅ Success!"
		wait(0.7)
		gui:Destroy()
		
		-- Завантаження твого основного скрипта
		loadstring(game:HttpGet("https://raw.githubusercontent.com/smaikss/oaklands-script/main/main.lua"))()
	elseif string.find(cleanResult, "EXPIRED") then
		status.Text = "❌ Key expired"
	else
		status.Text = "❌ Invalid key"
	end
end)
