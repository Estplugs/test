--------------------------------------------
-- loader.lua (Obfuscated, hosted on your server or GitHub)
--------------------------------------------

-- 1) Read the user’s key from environment
local userEnv = getfenv(0)
local userKey = userEnv.script_key
if not userKey then
    error("No key provided! Set script_key=\"...\" before loadstring.")
end

-- 2) Contact your Flask server to validate the key
local http = game:GetService("HttpService")
local validateUrl = "https://7112-2601-647-6511-8721-b00d-58ff-435a-9a4a.ngrok-free.app/validate_key?key=" .. userKey
local success, response = pcall(function()
    return game:HttpGet(validateUrl)
end)
if not success then
    error("Could not contact validation server: " .. tostring(response))
end

-- 3) Parse JSON. If invalid, stop.
local data
success, data = pcall(function() return http:JSONDecode(response) end)
if not success or type(data) ~= "table" then
    error("Invalid JSON from server: " .. tostring(response))
end

if not data.valid then
    error("Key is invalid or blacklisted. Reason: " .. tostring(data.reason))
end

-- 4) Mark that the loader ran successfully
_G.LoaderVerified = true
_G.UserKey = userKey  -- (If you want the main script to re-check it)

-- 5) Get the main script from a PROTECTED URL or dynamic endpoint
--    e.g., your server might return the script only after verifying the key
local mainScriptUrl = "https://YOUR-SERVER.com/get_main_script?temp_token=" .. data.temp_token 
  -- or if you prefer a direct link but not publicly listed

local success2, mainCode = pcall(function()
    return game:HttpGet(mainScriptUrl)
end)
if not success2 then
    error("Failed to download main script: " .. tostring(mainCode))
end

-- 6) Execute the main script
local func, loadErr = loadstring(mainCode)
if not func then
    error("Error loading main script: " .. tostring(loadErr))
end

func()
