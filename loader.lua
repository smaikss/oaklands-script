local CoreGui = game:GetService("CoreGui")

-- =====================================================================
-- ЗАХИЩЕНІ НАЛАШТУВАННЯ (Усе зашифровано в байти 👍)
-- =====================================================================
local DISCORD_LINK = "https://discord.gg/JdTdKv5mdb"

-- 1. Твоє точне посилання на Render API в байтах (БЕЗ ПОМИЛОК)
local RENDER_BYTES = {104,116,116,112,115,58,47,47,109,121,45,107,101,121,115,45,97,112,105,46,111,110,114,101,110,100,101,114,46,99,111,109,47,99,104,101,99,107,63,107,101,121,61}

-- 2. Твоє точне посилання на чит GitHub в байтах
local SCRIPT_BYTES = {104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,115,109,97,105,107,115,115,47,111,97,107,108,97,110,100,115,45,115,99,114,105,112,116,47,109,97,105,110,47,109,97,105,110,46,108,117,97}
-- =====================================================================

-- Функція дешифрування посилань у пам'яті експлоїта
local function decodeBytes(bytesTable)
    local chars = {}
    for _, b in ipairs(bytesTable) do
        table.insert(chars, string.char(b))
    end
    return table.concat(chars)
end

-- Очищення старого GUI, якщо він залишився
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
frame.Size = UDim2.new(0, 320, 0, 210)
frame.Position = UDim2.new(0.5, -160, 0.5, -105)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.Text = "🔑 Oaklands Login"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.BorderSizePixel = 0

local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -38, 0, 2)
close.Text = "X"
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.BorderSizePixel = 0

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local box = Instance.new("TextBox")
box.Parent = frame
box.Size = UDim2.new(0, 280, 0, 40)
box.Position = UDim2.new(0, 20, 0, 60)
box.PlaceholderText = "Enter key..."
box.Text = ""
box.TextScaled = true
box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
box.TextColor3 = Color3.new(1, 1, 1)
box.BorderSizePixel = 0

local status = Instance.new("TextLabel")
status.Parent = frame
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0, 108)
status.BackgroundTransparency = 1
status.Text = ""
status.TextScaled = true
status.TextColor3 = Color3.new(1, 1, 1)

local btn = Instance.new("TextButton")
btn.Parent = frame
btn.Size = UDim2.new(0, 280, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 140)
btn.Text = "LOGIN"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.BorderSizePixel = 0

local keyBtn = Instance.new("TextButton")
keyBtn.Parent = frame
keyBtn.Size = UDim2.new(0, 280, 0, 25)
keyBtn.Position = UDim2.new(0, 20, 0, 183)
keyBtn.Text = "Get Key (Discord)"
keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
keyBtn.TextColor3 = Color3.new(1, 1, 1)
keyBtn.BorderSizePixel = 0

keyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_LINK)
        status.Text = "Discord link copied!"
    else
        status.Text = "Discord: " .. DISCORD_LINK
    end
end)

-- Кнопка логіну
btn.MouseButton1Click:Connect(function()
    local key = box.Text

    if key == "" then
        status.Text = "Enter key"
        return
    end

    status.Text = "Checking..."

    -- Збираємо лінк API докупи прямо в пам'яті
    local apiUrl = decodeBytes(RENDER_BYTES)

    local ok, result = pcall(function()
        return game:HttpGet(apiUrl .. key .. "&nocache=" .. math.random(1, 99999))
    end)

    if not ok then
        status.Text = "Server waking up... wait 30s"
        warn("Render wake-up required: " .. tostring(result))
        return
    end

    local response = tostring(result):gsub("%s+", ""):upper()

    if response == "VALID" then
        status.Text = "✅ Success!"
        task.wait(0.5)
        gui:Destroy()
        
        -- Збираємо лінк на GitHub скрипт прямо в пам'яті
        local scriptUrl = decodeBytes(SCRIPT_BYTES)
        
        local scriptOk, scriptContent = pcall(function()
            return game:HttpGet(scriptUrl)
        end)
        
        if scriptOk then
            assert(loadstring(scriptContent))()
        else
            warn("Error loading main script from protected URL")
        end
    elseif response == "EXPIRED" then
        status.Text = "❌ Key expired"
    else
        status.Text = "❌ Invalid key"
    end
end)
