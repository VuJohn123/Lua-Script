local player = game.Players.LocalPlayer
local chestNames = {"SilverChest", "GoldChest", "DiamondChest"}  -- Names of chests we are searching for
local teleportDelay = 1  -- Delay in seconds before teleporting to the next chest
local searchDelay = 1  -- Delay in seconds between each full search cycle (to reduce lag)

-- Function to wait for the character to load
local function waitForCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")  -- Ensure HumanoidRootPart exists
    return humanoidRootPart
end

-- Recursive function to search specific parts and models (optimized)
local function searchChildren(parent)
    for _, object in ipairs(parent:GetChildren()) do

        -- Check if it's a chest (one of the names) and not a donation chest
        if (table.find(chestNames, object.Name) or (object:IsA("Model") and table.find(chestNames, object.Name))) and object.Name ~= "Donation" then
            -- If it's a part or model with a PrimaryPart, return its position
            if object:IsA("BasePart") or (object:IsA("Model") and object.PrimaryPart) then
                local chestPosition = object:IsA("BasePart") and object.Position or object.PrimaryPart.Position
                return chestPosition  -- Return the position of the first found chest
            end
        end
        
        -- If the object is a folder or model, continue searching recursively
        if object:IsA("Model") or object:IsA("Folder") then
            local chestPosition = searchChildren(object)  -- Recursively search in subfolders
            if chestPosition then
                return chestPosition  -- Return position if chest is found in a subfolder
            end
        end
    end
    return nil  -- Return nil if no chest is found in the current folder
end

-- Function to teleport the player to all chests
local function teleportToChests()
    local humanoidRootPart = waitForCharacter()  -- Get the HumanoidRootPart

    -- Search for chests in the entire workspace and subfolders
    local chestPosition = searchChildren(workspace)

    if chestPosition then
        humanoidRootPart.CFrame = CFrame.new(chestPosition)
    end
end

-- Optimized infinite loop
while true do
    teleportToChests()  -- Run the teleport function once
end
