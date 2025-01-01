------------------------------------------------------
-- main.lua (Hosted on GitHub)
------------------------------------------------------

-- 1) Ensure the loader provided a key in _G
if not _G.MySecretKey then
    error("No key found. Please run the loader script first!")
end

-- 2) Contact your Flask server to validate the key
local HttpService = game:GetService("HttpService")
local validationUrl = "https://4061-2601-647-6511-8721-b00d-58ff-435a-9a4a.ngrok-free.app/validate_key?key=" .. _G.MySecretKey

local success, response = pcall(function()
    return game:HttpGet(validationUrl)
end)

if not success then
    -- If we can't connect, or the server is down, 'response' will be the error message
    error("Failed to contact server: " .. tostring(response))
end

-- 3) Decode the JSON your Flask server returns
--    (It should look like { "valid": true, "reason": "All checks passed" } or similar)
local decoded
success, decoded = pcall(function()
    return HttpService:JSONDecode(response)
end)

if not success or type(decoded) ~= "table" then
    error("Server returned invalid JSON: " .. tostring(response))
end

-- 4) Check if the key is valid
if not decoded.valid then
    error("Key is invalid or blacklisted. Reason: " .. tostring(decoded.reason))
end

-- 5) If we get here, the key is valid. Proceed with your real code:
print("Key is valid. Proceeding with main script code...")

-- Example: put anything you want here
print("Hello! The script is working!")
