-- Get the required services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Reference the local player
local player = Players.LocalPlayer

-- Use RenderStepped to constantly update the WalkSpeed
RunService.RenderStepped:Connect(function()
	-- Grab the player's current character
	local character = player.Character
	
	-- If the character exists, look for the Humanoid and change the speed
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 100
		end
	end
end)
