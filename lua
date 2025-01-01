------------------------------------------------------
-- main.lua
------------------------------------------------------

-- Make sure the loader set the key
if not _G.MySecretKey then
    error("No valid key found. Run the loader first!")
end

-- Optional: Re-check with your Flask server
local http = game:GetService("HttpService")
local validationUrl = "https://4061-2601-647-6511-8721-b00d-58ff-435a-9a4a.ngrok-free.app/validate_key?key=" .. _G.MySecretKey

local success, response = pcall(function()
    return game:HttpGet(validationUrl)
end)
if not success then
    error("Can't contact validation server: " .. tostring(response))
end

-- Now decode the JSON *from the server*, not your script
local decoded
success, decoded = pcall(function()
    return http:JSONDecode(response)  -- The server returns JSON
end)
if not success or not decoded or type(decoded) ~= "table" then
    error("Could not parse JSON from validation server.")
end

-- Check if valid
if not decoded.valid then
    error("Key is not valid. Reason: " .. tostring(decoded.reason))
end

-- If we got here, it's valid. Continue:
print("Key is valid, continuing main script code...")
