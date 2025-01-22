-- Silent Aim for Arsenal with GUI (educational purposes only)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

local silentAimEnabled = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 180, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Silent Aim: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = frame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 180, 0, 30)
minimizeButton.Position = UDim2.new(0, 10, 0, 70)
minimizeButton.Text = "Minimize"
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Parent = frame

local minimized = false

-- Toggle Silent Aim
toggleButton.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    toggleButton.Text = "Silent Aim: " .. (silentAimEnabled and "ON" or "OFF")
end)

-- Minimize/Expand Menu
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame.Size = UDim2.new(0, 200, 0, 50)
        minimizeButton.Text = "Expand"
    else
        frame.Size = UDim2.new(0, 200, 0, 150)
        minimizeButton.Text = "Minimize"
    end
end)

-- Silent Aim Logic
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

local function shootAt(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local gun = localPlayer.Backpack:FindFirstChildOfClass("Tool") or localPlayer.Character:FindFirstChildOfClass("Tool")
        if gun and gun:FindFirstChild("FireEvent") then
            gun.FireEvent:FireServer({
                HitPart = target.Character.HumanoidRootPart,
                HitPosition = target.Character.HumanoidRootPart.Position,
                RayObject = Ray.new(localPlayer.Character.HumanoidRootPart.Position, Vector3.new(0, 0, 0)),
                Distance = 0,
                CFrame = CFrame.new(localPlayer.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position),
                Hit = target.Character.HumanoidRootPart
            })
        end
    end
end

RunService.RenderStepped:Connect(function()
    if silentAimEnabled then
        local closestPlayer = getClosestPlayer()
        if closestPlayer then
            shootAt(closestPlayer)
        end
    end
end)
