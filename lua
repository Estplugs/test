------------------------------------------------------
-- main.lua
-- This is your actual “main code” on GitHub
------------------------------------------------------

-- 1) Check if loader provided a key
if not _G.MySecretKey then
    error("No valid key found. Run the loader first!")
end

-- 2) (Optional) Re-check the key with your Flask server
local http = game:GetService("HttpService")
local validationUrl = "https://4061-2601-647-6511-8721-b00d-58ff-435a-9a4a.ngrok-free.app/validate_key?key=" .. _G.MySecretKey

local success, response = pcall(function()
    return game:HttpGet(validationUrl)
end)
if not success then
    error("Can't contact validation server: " .. tostring(response))
end

-- 3) Decode the JSON response
local decoded
success, decoded = pcall(function()
    return http:JSONDecode(response)  -- The server returns JSON like {"valid": true, "reason": "..."}
end)
if not success or type(decoded) ~= "table" then
    error("Could not parse JSON from validation server.")
end

-- 4) Check if it's valid
if not decoded.valid then
    error("Key is not valid. Reason: " .. tostring(decoded.reason))
end

-- 5) If valid, proceed with the rest of your code
print("Key is valid, continuing main script code...")

-- Put your real code/logic here
