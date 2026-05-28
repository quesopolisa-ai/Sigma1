print("[Auto-Walk] Script initialized! Walking loop active.")

local player = game.Players.LocalPlayer

-- Define your movement positions
local position1 = Vector3.new(-502, 49, -631)
local position2 = Vector3.new(193, 25, -344)

-- Define the EXACT name of your tool
local toolNameToEquip = "Weight" 

-- Debounce flag to make sure your custom script only runs ONCE per arrival
local hasExecutedAtPos2 = false

-- ========================================================
-- PLACE YOUR SCRIPT INSIDE THIS FUNCTION
-- ========================================================
local function executeYourScript()
	print("[Auto-Walk] Arrived at Position 2! Running custom code...")
	
	-- 👇 PASTE YOUR CUSTOM SCRIPT BELOW THIS LINE 👇
	
    -- RemoteEvent
    game:GetService("ReplicatedStorage").Level200AscensionEvent:FireServer()

	-- 👆 PASTE YOUR CUSTOM SCRIPT ABOVE THIS LINE 👆
end
-- ========================================================

-- Helper function to calculate distance ignoring height (Y-axis)
local function getFlatDistance(pos1, pos2)
	local v1 = Vector2.new(pos1.X, pos1.Z)
	local v2 = Vector2.new(pos2.X, pos2.Z)
	return (v1 - v2).Magnitude
end

-- 1. Auto-equip tool when respawning
player.CharacterAdded:Connect(function(newCharacter)
	print("[Auto-Walk] Character reset detected. Waiting for tool...")
	task.wait(0.75)  -- Wait to ensure backpack fully loads
	
	local tool = player.Backpack:FindFirstChild(toolNameToEquip)
	if tool then
		newCharacter:WaitForChild("Humanoid"):EquipTool(tool)
		print("[Auto-Walk] Tool successfully equipped!")
	else
		print("[Auto-Walk] Error: Tool '" .. toolNameToEquip .. "' not found in Backpack.")
	end
end)

-- 2. Main Walking Loop
while task.wait(0) do
	local character = player.Character
	
	if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
		local humanoid = character.Humanoid
		local rootPart = character.HumanoidRootPart
		
		if humanoid.Health > 0 then
			-- Calculate 2D flat distance (ignores height issues)
			local distanceToPos1 = getFlatDistance(position1, rootPart.Position)
			local distanceToPos2 = getFlatDistance(position2, rootPart.Position)

			-- Compare distances and walk to the closer one
			if distanceToPos1 < distanceToPos2 then
                -- Heading to Position 1
                if distanceToPos1 <= 5 then
                    -- STOP WALKING: Tell humanoid to stay exactly where it is
                    humanoid:MoveTo(rootPart.Position)
                else
                    humanoid:MoveTo(position1)
                end
                
				hasExecutedAtPos2 = false -- Reset the lock since we moved away to Position 1
			else
                -- Heading to Position 2
                if distanceToPos2 <= 10 then
                    -- STOP WALKING: Tell humanoid to stay exactly where it is
                    humanoid:MoveTo(rootPart.Position)

					if not hasExecutedAtPos2 then
						hasExecutedAtPos2 = true -- Lock it so it doesn't run continuously
						executeYourScript()
					end
				else
                    -- Not there yet, keep walking
                    humanoid:MoveTo(position2)
					-- Reset the lock if you get pushed away or leave the spot
					hasExecutedAtPos2 = false
				end
			end
		end
	end
end
