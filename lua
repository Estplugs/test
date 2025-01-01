------------------------------------------------------
-- main.lua (hosted on GitHub)
------------------------------------------------------

-- 1) Check if the loader provided a key
if not _G.MySecretKey then
    error("No valid key found. Please run the loader script first.")
end

-- 2) Contact your Flask server to validate the key
local http = game:GetService("HttpService")
local validationUrl = "https://4061-2601-647-6511-8721-b00d-58ff-435a-9a4a.ngrok-free.app/validate_key?key=" .. _G.MySecretKey

local success, response = pcall(function()
    return game:HttpGet(validationUrl)
end)
if not success then
    error("Can't contact validation server: " .. tostring(response))
end

-- 3) Decode the JSON from the validation endpoint
local decoded
success, decoded = pcall(function()
    return http:JSONDecode(response) -- The Flask server returns JSON (e.g. {"valid":true,"reason":"All checks passed"})
end)
if not success or type(decoded) ~= "table" then
    error("Could not parse JSON from validation server. Response was: " .. tostring(response))
end

-- 4) Check if it's valid
if not decoded.valid then
    error("Key is not valid. Reason: " .. tostring(decoded.reason))
end

-- 5) If valid, proceed with your real code
print("Key is valid! Running main code...")

-- Put the rest of your script logic below:
-- e.g.:
print("Hello! This is the main script after validation.")
