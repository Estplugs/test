-- 1) Ensure the loader script set these variables
if not _G.LoaderVerified then
    error("Please run the loader script, not me directly!")
end
if not _G.UserKey or not _G.UserHWID then
    error("Missing key/HWID. Did you run the correct one-line script?")
end

-- 2) (Optional) Re-check the server if you want a second layer of validation
local httpService = game:GetService("HttpService")
local validationUrl = "http://melo.pylex.xyz:9350/validate_key?key=" 
    .. _G.UserKey .. "&hwid=" .. _G.UserHWID -- Use _G variables from the loader script

local success, response = pcall(function()
    return game:HttpGet(validationUrl)
end)

if not success then
    error("Cannot contact server again: " .. tostring(response))
end

local data = httpService:JSONDecode(response)
if not data.valid then
    error("Key/HWID invalid on second check. Reason: " .. tostring(data.reason))
end

print("Key and HWID are valid. Welcome to the main script!")

-- 3) Put your actual code here
-- Replace the following line with your real script
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
