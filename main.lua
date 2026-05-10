
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local targetTreePos = nil
local autoTreeTeleport = false
local clickTeleportPlayer = true
local freecamActive = false
local freecamPart = nil

-- ==================== СПИСОК КООРДИНАТ ====================
local savedTeleports = {
    {Name = "❄️ Snow Tree", Position = Vector3.new(-7422.5, 1188.6, -3564.2)},
    {Name = "💰 Sell Tree", Position = Vector3.new(-54.8, 35.9, -74.4)},
    {Name = "⬛ Black Zone", Position = Vector3.new(2387.3, -1867.4, 1324.9)}
}

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Oaklands_Ultimate_V6"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 460, 0, 520)
Frame.Position = UDim2.new(0.5, -230, 0.5, -260)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local dragging, dragStart, startPos
Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundColor3 = Color3.fromRGB(15,15,15)
Title.Text = "🌲 Oaklands Helper V6"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Parent = Frame

local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(1,0,0,40)
TabButtons.Position = UDim2.new(0,0,0,50)
TabButtons.BackgroundTransparency = 1
TabButtons.Parent = Frame

local function CreateTabBtn(text, pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.33,-5,1,0)
	btn.Position = UDim2.new(pos,0,0,0)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = TabButtons
	return btn
end

local FarmTabBtn = CreateTabBtn("Farm",0)
local TeleportTabBtn = CreateTabBtn("Teleport",0.33)
local SettingsTabBtn = CreateTabBtn("Settings",0.66)

local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Size = UDim2.new(1,-20,1,-110)
Scrolling.Position = UDim2.new(0,10,0,100)
Scrolling.BackgroundTransparency = 1
Scrolling.ScrollBarThickness = 6
Scrolling.Parent = Frame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0,8)
UIList.Parent = Scrolling

local function ClearScroll()
	for _,v in pairs(Scrolling:GetChildren()) do
		if v:IsA("GuiObject") and v.Name ~= "UIListLayout" then
			v:Destroy()
		end
	end
end

-- ==================== FREECAM ====================
local function ToggleFreecam()
	freecamActive = not freecamActive

	if freecamActive then
		local camPos = Camera.CFrame

		freecamPart = Instance.new("Part")
		freecamPart.Size = Vector3.new(1,1,1)
		freecamPart.Transparency = 1
		freecamPart.CanCollide = false
		freecamPart.Anchored = true
		freecamPart.CFrame = camPos
		freecamPart.Parent = Workspace

		Camera.CameraSubject = freecamPart
	else
		if freecamPart then
			freecamPart:Destroy()
			freecamPart = nil
		end

		if LocalPlayer.Character then
			Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
		end
	end
end

RunService.RenderStepped:Connect(function()
	if freecamActive and freecamPart then
		local speed = 2.5
		local moveDir = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir += Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir -= Vector3.new(0,1,0) end

		freecamPart.CFrame += moveDir * speed
	end
end)

-- ==================== TABS ====================
local function ShowFarm()
	ClearScroll()

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Size = UDim2.new(1,0,0,60)
	ToggleBtn.BackgroundColor3 = autoTreeTeleport and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
	ToggleBtn.Text = autoTreeTeleport and "🟢 Телепорт Дерев: ON" or "🔴 Телепорт Дерев: OFF"
	ToggleBtn.TextColor3 = Color3.new(1,1,1)
	ToggleBtn.Parent = Scrolling

	ToggleBtn.MouseButton1Click:Connect(function()
		autoTreeTeleport = not autoTreeTeleport
		ShowFarm()
	end)

	local SaveBtn = Instance.new("TextButton")
	SaveBtn.Size = UDim2.new(1,0,0,50)
	SaveBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
	SaveBtn.Text = "🎯 Зберегти точку продажу"
	SaveBtn.TextColor3 = Color3.new(1,1,1)
	SaveBtn.Parent = Scrolling

	SaveBtn.MouseButton1Click:Connect(function()
		if freecamActive then
			targetTreePos = Camera.CFrame.Position
		elseif LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
			targetTreePos = LocalPlayer.Character.PrimaryPart.Position
		end
	end)
end

local function ShowTeleports()
	ClearScroll()

	local AddBtn = Instance.new("TextButton")
	AddBtn.Size = UDim2.new(1,0,0,50)
	AddBtn.BackgroundColor3 = Color3.fromRGB(0,180,100)
	AddBtn.Text = "➕ Зберегти поточне місце"
	AddBtn.TextColor3 = Color3.new(1,1,1)
	AddBtn.Parent = Scrolling

	AddBtn.MouseButton1Click:Connect(function()
		local pos

		if freecamActive then
			pos = Camera.CFrame.Position
		elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			pos = LocalPlayer.Character.HumanoidRootPart.Position
		end

		if pos then
			table.insert(savedTeleports,{
				Name = "📍 Точка "..(#savedTeleports + 1),
				Position = pos
			})

			ShowTeleports()
		end
	end)

	for _,loc in ipairs(savedTeleports) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,0,0,45)
		btn.BackgroundColor3 = Color3.fromRGB(45,45,50)
		btn.Text = "🚀 "..loc.Name
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Parent = Scrolling

		btn.MouseButton1Click:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(loc.Position + Vector3.new(0,5,0))
			end
		end)
	end
end

local function ShowSettings()
	ClearScroll()

	local FBtn = Instance.new("TextButton")
	FBtn.Size = UDim2.new(1,0,0,60)
	FBtn.BackgroundColor3 = clickTeleportPlayer and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
	FBtn.Text = clickTeleportPlayer and "🟢 TP на F: ON" or "🔴 TP на F: OFF"
	FBtn.TextColor3 = Color3.new(1,1,1)
	FBtn.Parent = Scrolling

	FBtn.MouseButton1Click:Connect(function()
		clickTeleportPlayer = not clickTeleportPlayer
		ShowSettings()
	end)

	local CamBtn = Instance.new("TextButton")
	CamBtn.Size = UDim2.new(1,0,0,60)
	CamBtn.BackgroundColor3 = freecamActive and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
	CamBtn.Text = freecamActive and "🎥 Freecam ON" or "🎥 Freecam OFF"
	CamBtn.TextColor3 = Color3.new(1,1,1)
	CamBtn.Parent = Scrolling

	CamBtn.MouseButton1Click:Connect(function()
		ToggleFreecam()
		ShowSettings()
	end)
end

-- ==================== TELEPORT TREE FIXED ====================
local function TeleportTree(part, finalPos)
	if not part or not part:IsA("BasePart") then return end

	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	pcall(function()
		part.CFrame = hrp.CFrame * CFrame.new(0,0,-7)
		task.wait(0.15)

		local start = tick()
		while tick() - start < 0.8 do
			part.AssemblyLinearVelocity = Vector3.zero
			part.AssemblyAngularVelocity = Vector3.zero
			part.CFrame = CFrame.new(finalPos + Vector3.new(0,12,0))
			RunService.Heartbeat:Wait()
		end
	end)
end

-- ==================== INPUT ====================
UserInputService.InputBegan:Connect(function(input,gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.F and clickTeleportPlayer then
		local mouse = LocalPlayer:GetMouse()

		if mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
		end
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 and autoTreeTeleport then

		local finalPos = targetTreePos

		if not finalPos then
			for _,loc in pairs(savedTeleports) do
				if loc.Name:find("Sell") or loc.Name:find("Black") then
					finalPos = loc.Position
					break
				end
			end
		end

		local mouse = LocalPlayer:GetMouse()

		if mouse.Target and finalPos then
			local model = mouse.Target:FindFirstAncestorOfClass("Model") or mouse.Target.Parent

			if model then
				local part =
					model.PrimaryPart or
					model:FindFirstChild("Trunk") or
					model:FindFirstChild("Wood") or
					mouse.Target

				TeleportTree(part, finalPos)
			end
		end
	end
end)

FarmTabBtn.MouseButton1Click:Connect(ShowFarm)
TeleportTabBtn.MouseButton1Click:Connect(ShowTeleports)
SettingsTabBtn.MouseButton1Click:Connect(ShowSettings)

ShowFarm()
