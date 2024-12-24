-- Protected GitHub-hosted script

local HttpService = game:GetService("HttpService")

-- Check if the required validation variables are present
if not script_key or not validated then
    game.Players.LocalPlayer:Kick("Unauthorized access: Please execute the loader script with a valid key.")
    return
end

-- Define your validation server endpoint
local serverEndpoint = "https://e5f7-2601-647-6512-1bd7-65e8-985-974a-faa2.ngrok-free.app/validate_key"

-- HWID detection (optional, depending on your setup)
local userHWID = "NO_HWID_FUNCTION"
if gethwid then
    userHWID = gethwid()
end

-- Build the validation URL
local validateUrl = string.format("%s?key=%s&hwid=%s", serverEndpoint, script_key, userHWID)

-- Validate the key dynamically with the server
local success, response = pcall(function()
    return http.request({
        Url = validateUrl,
        Method = "GET"
    })
end)

-- Handle no response or failure from the server
if not success or not response then
    game.Players.LocalPlayer:Kick("Whitelist check failed: No response from the server.")
    return
end

-- Handle invalid response codes
if response.StatusCode ~= 200 then
    game.Players.LocalPlayer:Kick("Whitelist check failed: " .. (response.Body or "Unknown error"))
    return
end

-- Decode server response
local data
local decodeSuccess, decodeError = pcall(function()
    data = HttpService:JSONDecode(response.Body)
end)

-- Handle decoding errors or invalid responses
if not decodeSuccess or not data.valid then
    game.Players.LocalPlayer:Kick("Whitelist check failed: " .. (data.reason or decodeError))
    return
end

-- If the script reaches this point, the key is valid and authorized
print("The script is running correctly! Key is valid.")
