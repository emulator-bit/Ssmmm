-- SKELETON HUB 💀✋️ by ChatGPT

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI setup
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "SkeletonHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 500)
main.Position = UDim2.new(0.1, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "💀✋️ SKELETON HUB"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Button generator
local function createButton(text, yPos)
	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 18
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	return btn
end

-- AUTO FARM
local autoFarmBtn = createButton("Auto Farm 🌱", 60)
local farming = false

autoFarmBtn.MouseButton1Click:Connect(function()
	farming = not farming
	autoFarmBtn.Text = farming and "Auto Farm 🌿 [ON]" or "Auto Farm 🌱"
	while farming do
		task.wait(1)
		local tools = LocalPlayer.Backpack:GetChildren()
		for _, tool in ipairs(tools) do
			if tool:IsA("Tool") then
				tool.Parent = LocalPlayer.Character
				tool:Activate()
			end
		end
	end
end)

-- PLANT ESP
local espBtn = createButton("Plant ESP 🌼 [OFF]", 110)
local espEnabled = false
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "PlantESP"

local function createBillboard(target, nameText)
	local bb = Instance.new("BillboardGui")
	bb.AlwaysOnTop = true
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.StudsOffset = Vector3.new(0, 2, 0)
	bb.Adornee = target
	bb.Parent = espFolder

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.5
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Text = nameText
	label.Parent = bb
end

local function refreshESP()
	if not espEnabled then return end
	espFolder:ClearAllChildren()
	local plantFolder = workspace:FindFirstChild("Plants")
	if not plantFolder then return end

	for _, plant in ipairs(plantFolder:GetChildren()) do
		if plant:IsA("Model") or plant:IsA("Part") then
			local root = plant:FindFirstChild("PrimaryPart") or plant:FindFirstChildWhichIsA("BasePart")
			if root then
				local price = plant:FindFirstChild("Price")
				local weight = plant:FindFirstChild("Weight")
				local priceVal = price and (price.Value or price) or "???"
				local weightVal = weight and (weight.Value or weight) or "???"
				local labelText = string.format("🌼 %s\n💲 %s | ⚖️ %s", plant.Name, tostring(priceVal), tostring(weightVal))
				createBillboard(root, labelText)
			end
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "Plant ESP 🌼 [ON]" or "Plant ESP 🌼 [OFF]"
	if not espEnabled then espFolder:ClearAllChildren() end
end)

task.spawn(function()
	while true do
		if espEnabled then refreshESP() end
		task.wait(5)
	end
end)

-- WALKSPEED
local wsLabel = Instance.new("TextLabel", main)
wsLabel.Size = UDim2.new(1, -20, 0, 30)
wsLabel.Position = UDim2.new(0, 10, 0, 160)
wsLabel.Text = "WalkSpeed"
wsLabel.Font = Enum.Font.Gotham
wsLabel.TextSize = 16
wsLabel.TextColor3 = Color3.new(1, 1, 1)
wsLabel.BackgroundTransparency = 1

local wsInput = Instance.new("TextBox", main)
wsInput.Size = UDim2.new(1, -20, 0, 35)
wsInput.Position = UDim2.new(0, 10, 0, 195)
wsInput.PlaceholderText = "Enter Speed (16-100)"
wsInput.Font = Enum.Font.Gotham
wsInput.TextColor3 = Color3.new(1, 1, 1)
wsInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
wsInput.Text = ""

wsInput.FocusLost:Connect(function()
	local speed = tonumber(wsInput.Text)
	if speed and LocalPlayer.Character then
		LocalPlayer.Character.Humanoid.WalkSpeed = math.clamp(speed, 10, 200)
	end
end)

-- AUTO COLLECT
local collectBtn = createButton("Auto Collect 🌽 [OFF]", 240)
local autoCollecting = false
local maxWeight = 100

local function getBackpackWeight()
	local w = LocalPlayer:FindFirstChild("BackpackWeight") or LocalPlayer:FindFirstChild("Storage") or LocalPlayer.Backpack:FindFirstChild("Weight")
	if w and w:IsA("NumberValue") then return w.Value end
	return 0
end

collectBtn.MouseButton1Click:Connect(function()
	autoCollecting = not autoCollecting
	collectBtn.Text = autoCollecting and "Auto Collect 🌽 [ON]" or "Auto Collect 🌽 [OFF]"

	task.spawn(function()
		while autoCollecting do
			if getBackpackWeight() >= maxWeight then
				autoCollecting = false
				collectBtn.Text = "Auto Collect 🌽 [FULL]"
				break
			end
			local plants = workspace:FindFirstChild("Plants")
			if plants then
				for _, plant in ipairs(plants:GetChildren()) do
					if not autoCollecting then break end
					local root = plant:FindFirstChild("PrimaryPart") or plant:FindFirstChildWhichIsA("BasePart")
					if root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(0, 2, 0)
						task.wait(0.25)
						local prompt = root:FindFirstChildWhichIsA("ProximityPrompt", true)
						if prompt then
							fireproximityprompt(prompt)
							task.wait(0.2)
						end
					end
				end
			end
			task.wait(1)
		end
	end)
end)

-- GUI TOGGLE
local toggleKey = Enum.KeyCode.RightShift
local visible = true

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == toggleKey then
		visible = not visible
		gui.Enabled = visible
	end
end)
