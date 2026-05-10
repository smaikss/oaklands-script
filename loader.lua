local CoreGui = game:GetService("CoreGui")

-- Твоє посилання з Render
local RENDER_API = "https://my-keys-api.onrender.com/check?key="

-- Очищення старого GUI перед запуском
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
    setclipboard("https://discord.gg/yourlink") -- Сюди свою посилку на дс
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
        -- Спеціальний параметр nocache, щоб сервер не видавав старий результат
        return game:HttpGet(RENDER_API .. key .. "&nocache=" .. math.random(1,99999))
    end)

    if not ok then
        -- Якщо Render "спить", HttpGet видасть помилку. Просимо юзера почекати.
        status.Text = "Server waking up... wait 20s"
        warn("Render connection error: "..tostring(result))
        return
    end

    local response = tostring(result):gsub("%s+", ""):upper()
    print("Server Response: [" .. response .. "]") -- Вивід у консоль F9

    if response == "VALID" then
        status.Text = "✅ Success!"
        wait(0.7)
        gui:Destroy()
        -- Твій основний скрипт
        loadstring(game:HttpGet("https://raw.githubusercontent.com/smaikss/oaklands-script/main/main.lua"))()
    elseif response == "EXPIRED" then
        status.Text = "❌ Key expired"
    else
        status.Text = "❌ Invalid key"
    end
end)
