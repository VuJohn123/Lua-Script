-- Beli Farm (Updated with Recursive Search)
local player = game.Players.LocalPlayer
local chestNames = "Chest"
local teleportDelay = 1  -- Delay in seconds before teleporting to the next chest

-- Function to wait for the character to load
local function waitForCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")  
    return humanoidRootPart
end

-- Recursive function to search all objects in folders and subfolders
local function searchAllChildren(parent)
    for _, object in ipairs(parent:GetChildren()) do
        if (table.find(chestNames, object.Name) or (object:IsA("Model") and table.find(chestNames, object.Name))) and object.Name ~= "Donation" then
            if object:IsA("BasePart") then
                return object.Position
            elseif object:IsA("Model") and object.PrimaryPart then
                return object.PrimaryPart.Position
            end
        elseif object:IsA("Model") or object:IsA("Folder") then
            local chestPosition = searchAllChildren(object)
            if chestPosition then
                return chestPosition
            end
        end
    end
    return nil
end

-- Function to teleport the player to all chests, excluding donation chests
local function teleportToChests()
    local humanoidRootPart = waitForCharacter()
    local chestPosition = searchAllChildren(workspace)

    if chestPosition then
        humanoidRootPart.CFrame = CFrame.new(chestPosition)
    end
end

-- Loop to continuously find and teleport to chests
while true do
    teleportToChests()
    wait(teleportDelay)
end
