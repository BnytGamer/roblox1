-- Silent Aim and ESP for Big Paintball 2 with ESP naming feature (educational purposes only)

local function getClosestPlayer()
    local closestDistance = math.huge
    local closestPlayer = nil
    local localPlayer = game.Players.LocalPlayer
    local mouse = localPlayer:GetMouse()

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local target = player.Character.HumanoidRootPart
            local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(target.Position)
            if onScreen then
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

local function aimAt(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local camera = workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
    end
end

local function createESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character

        local nameBillboard = Instance.new("BillboardGui")
        nameBillboard.Size = UDim2.new(0, 100, 0, 50)
        nameBillboard.StudsOffset = Vector3.new(0, 3, 0)
        nameBillboard.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
        nameBillboard.AlwaysOnTop = true

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextScaled = true
        nameLabel.Parent = nameBillboard

        nameBillboard.Parent = player.Character
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    local closestPlayer = getClosestPlayer()
    if closestPlayer then
        aimAt(closestPlayer)
    end
end)

for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        createESP(player)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function()
            createESP(player)
        end)
    end
end)
