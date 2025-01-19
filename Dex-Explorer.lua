--Dex Explorer
print("[DEBUG] Starting script execution...")

local success, err = pcall(function()
    print("[DEBUG] Fetching remote script...")

    -- Fetch the script content
    local scriptContent = game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt")

    if scriptContent and scriptContent ~= "" then
        print("[DEBUG] Script fetched successfully! Length:", #scriptContent)
    else
        print("[ERROR] Failed to fetch script or script is empty!")
        return
    end

    print("[DEBUG] Executing script...")
    loadstring(scriptContent)()
    print("[DEBUG] Script executed successfully!")
end)

if not success then
    print("[ERROR] Script execution failed:", err)
end
