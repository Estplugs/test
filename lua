local httpService = game:GetService("HttpService")

-- 1) Grab the user's 'script_key' from the environment
local env = getfenv(0)
local userKey = env.script_key
if not userKey or userKey == "" then
    error("No script_key provided! Usage:\nscript_key=\"YOUR_KEY\"; loadstring(game:HttpGet(\"URL\"))()")
end

-- 2) Retrieve the HWID
local userHWID = nil
if gethwid then
    userHWID = gethwid() -- Check if 'gethwid()' is supported
else
    error("Could not obtain HWID from exploit. Is gethwid() supported?")
end

if not userHWID or userHWID == "" then
    error("HWID is empty or invalid.")
end

-- 3) Store them in _G so the main script can see them
_G.UserKey = userKey
_G.UserHWID = userHWID
_G.LoaderVerified = true

-- 4) Build the validation URL
local validationUrl = "https://e6b3-2601-647-6511-c2da-b08a-b672-bdf4-f9d7.ngrok-free.app/validate_key?key=" 
    .. userKey .. "&hwid=" .. userHWID

-- 5) Validate via HTTP GET
local success, response = pcall(function()
    return game:HttpGet(validationUrl)
end)

if not success then
    error("Failed to contact validation server: " .. tostring(response))
end

local data
success, data = pcall(function()
    return httpService:JSONDecode(response)
end)
if not success or type(data) ~= "table" then
    error("Server returned invalid JSON: " .. tostring(response))
end

if not data.valid then
    error("Invalid key / blacklisted / HWID mismatch. Reason: " .. tostring(data.reason))
end

-- 6) If valid, download the MAIN script
local mainScriptUrl = "https://raw.githubusercontent.com/Estplugs/Sumiguess/refs/heads/main/Idontknow!"
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
