-- 1) Check if loader provided the key
if not _G.MySecretKey then
    error("You did not run the official loader script first.")
end

-- 2) (Optional) Double-check validity again or do a short “phone-home”:
local http = game:GetService("HttpService")
local validateUrl = "https://yourserver.com/validate_key?key=" .. _G.MySecretKey
local response = game:HttpGet(validateUrl)
local decoded = http:JSONDecode(response)

if not decoded.valid then
    error("Invalid or blacklisted key, cannot run script.")
end

-- 3) If we got here, the script can proceed safely:
print("Key is valid. Running main functionality...")
-- ...rest of your code...
