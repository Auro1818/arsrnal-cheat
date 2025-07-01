-- ANTI-BAN
local mt = getrawmetatable(game)
setreadonly(mt, false)
local __namecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(method) == "Kick" or tostring(self) == "Kick" then
        return warn("[ANTI-BAN] Kick blocked.")
    end
    return __namecall(self, unpack(args))
end)

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
hookfunction(lp.Kick, function()
    return warn("[ANTI-BAN] Player:Kick blocked.")
end)

-- CONFIG
local aimPart = "Head"
local espEnabled = true
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ESP Function
local function createESP(player)
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if not player.Character:FindFirstChild("ESPBox") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "ESPBox"
            box.Size = Vector3.new(4, 6, 2)
            box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Color3 = Color3.fromRGB(255, 0, 0)
            box.Transparency = 0.5
            box.Parent = player.Character
        end
    end
end

-- ESP Auto Update
if espEnabled then
    for _, player in pairs(Players:GetPlayers()) do
        createESP(player)
    end
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1)
            createESP(player)
        end)
    end)
end

-- SILENT AIM TO HEAD (Fire toward Head, not camera)
local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mouse = LocalPlayer:GetMouse()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local pos = player.Character.Head.Position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(pos)
            if onScreen then
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

-- Override Raycast for Silent Aim
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if tostring(method) == "FindPartOnRayWithIgnoreList" and self == workspace then
        local target = getClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            local headPos = target.Character[aimPart].Position
            local origin = workspace.CurrentCamera.CFrame.Position
            local direction = (headPos - origin).Unit * 500
            args[1] = Ray.new(origin, direction)
            return oldNamecall(self, unpack(args))
        end
    end

    return oldNamecall(self, unpack(args))
end)
