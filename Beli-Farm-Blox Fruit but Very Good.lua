local player = game.Players.LocalPlayer
local chestNames = { "Chest1", "Chest2", "Chest3" }  -- List of chests we are searching for
local teleportDelay = 1  -- Delay before teleporting to the next chest

-- Function to wait for the character to load
local function waitForCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")  -- Ensure HumanoidRootPart exists
    return humanoidRootPart
end

-- Function to check if a name exists in chestNames list
local function isChestName(name)
    for _, chestName in ipairs(chestNames) do
        if name == chestName then
            return true
        end
    end
    return false
end

-- Function to teleport the player to all chests, excluding donation chests
local function teleportToChests()
    local humanoidRootPart = waitForCharacter()  -- Get the HumanoidRootPart
    
    -- Check if "World" exists in the workspace
    local world = workspace:FindFirstChild("World")
    if not world then return end
    
    -- Check if "Chests" folder exists inside "World"
    local chestsFolder = world:FindFirstChild("Chests")
    if not chestsFolder then return end

    -- Loop through all objects inside the "Chests" folder
    for _, chest in ipairs(chestsFolder:GetChildren()) do
        -- Ensure the chest is one of the named chests (Chest1, Chest2, Chest3)
        if isChestName(chest.Name) then
            local chestPosition = nil

            -- Check if the chest is a BasePart (Part) or Model
            if chest:IsA("BasePart") then
                chestPosition = chest.Position
            elseif chest:IsA("Model") and chest.PrimaryPart then
                chestPosition = chest.PrimaryPart.Position  -- Get position from PrimaryPart
            end

            -- Safe teleport with error handling
            if chestPosition then
                pcall(function()
                    humanoidRootPart.CFrame = CFrame.new(chestPosition)  -- Teleport player
                end)

                wait(teleportDelay)  -- Delay before teleporting to the next chest
            end
        end
    end
end

-- Loop to continuously find and teleport to chests
while true do
    teleportToChests()  -- Run the teleport function
    wait(teleportDelay)  -- Wait before checking again (this delay is between full cycles)
end
