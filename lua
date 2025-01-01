------------------------------------------------------
-- loader.lua (hosted on your server or GitHub Raw)
------------------------------------------------------

-- 1) Read the user’s key from the environment (the line they typed)
local userEnv = getfenv(0)
local userKey = userEnv.script_key
if not userKey or userKey == "" then
    error("No script_key provided! Example usage: script_key=\"MY_KEY\"; loadstring(...)()")
end

-- 2) Save the key in _G so the main script can see it
_G.UserKey = userKey
_G.LoaderVerified = true

-- 3) Validate the key with your Flask/Ngrok server
local HttpService = game:GetService("HttpService")
local validationUrl = "https://7112-2601-647-6511-8721-b00d-58ff-435a-9a4a.ngrok-free.app/validate_key?key=" .. userKey

local success, response = pcall(function()
    return game:HttpGet(validationUrl)
end)

if not success then
    error("Failed to contact validation server: " .. tostring(response))
end

-- 4) Parse the JSON response (e.g., { "valid": true, "reason": "All checks passed" })
local data
success, data = pcall(function()
    return HttpService:JSONDecode(response)
end)
if not success or type(data) ~= "table" then
    error("Invalid JSON from server: " .. tostring(response))
end

-- 5) If the key is invalid, stop
if not data.valid then
    error("Key is invalid or blacklisted. Reason: " .. tostring(data.reason))
end

-- 6) Key is valid, so now fetch the main script
--    Host your main script somewhere else (private or not easily guessable).
local mainScriptUrl = "https://raw.githubusercontent.com/Estplugs/Sumiguess/refs/heads/main/Idontknow!"  -- or GitHub raw link

local success2, mainCode = pcall(function()
    return game:HttpGet(mainScriptUrl)
end)
if not success2 then
    error("Failed to download main script: " .. tostring(mainCode))
end

-- 7) Execute the main script
local func, loadErr = loadstring(mainCode)
if not func then
    error("Error loading main script: " .. tostring(loadErr))
end

func()
