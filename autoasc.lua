local fileName = "AutoRejoinSigma.lua"

-- The main script block that will be saved to your device
local coreScriptContent = [====[
-- Wait until the game is completely loaded so the executor doesn't crash
if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(3) -- Safety buffer to stabilize after loading

local queue_on_teleport = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)

-- ==========================================
-- 1. QUEUE FOR THE NEXT REJOIN
-- ==========================================
if queue_on_teleport then
    pcall(function()
        queue_on_teleport([[
            repeat task.wait() until game:IsLoaded()
            task.wait(3)
            if isfile and readfile and isfile("AutoRejoinSigma.lua") then
                loadstring(readfile("AutoRejoinSigma.lua"))()
            end
        ]])
    end)
end

-- ==========================================
-- 2. EXECUTE YOUR 3 EXTERNAL SCRIPTS
-- ==========================================
task.spawn(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/quesopolisa-ai/Sigma1/refs/heads/main/Hack.lua"))() end)
end)

task.spawn(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/quesopolisa-ai/Sigma1/refs/heads/main/Hack2.lua"))() end)
end)

task.spawn(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/quesopolisa-ai/Sigma1/refs/heads/main/Hack3.lua"))() end)
end)

-- ==========================================
-- 3. CRASH-PROOF POLLING REJOIN LOGIC
-- ==========================================
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Fallback: If the specific server is full/locked, join a new server
if TeleportService then
    TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
        pcall(function()
            task.wait(2)
            TeleportService:Teleport(game.PlaceId, player)
        end)
    end)
end

-- Independent monitoring thread
task.spawn(function()
    while task.wait(2) do
        local detectedKick = false
        
        pcall(function()
            local robloxPromptGui = CoreGui:FindFirstChild("RobloxPromptGui")
            if robloxPromptGui then
                local promptOverlay = robloxPromptGui:FindFirstChild("promptOverlay")
                -- FIX: We must check if the GUI is actually VISIBLE, not just loaded
                if promptOverlay and promptOverlay.Visible then
                    local errorPrompt = promptOverlay:FindFirstChild("ErrorPrompt")
                    if errorPrompt and errorPrompt.Visible then
                        detectedKick = true
                    end
                end
            end
        end)

        if detectedKick then
            task.wait(3) -- Let the client settle after the disconnect overlay appears
            
            pcall(function()
                -- Prioritize rejoining the exact same server instance
                if game.JobId ~= "" then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
                else
                    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                end
            end)
            
            break -- Stop the loop once a teleport is initiated
        end
    end
end)
]====]

-- ==========================================
-- INITIALIZATION ENGINE (RUNS FIRST TIME)
-- ==========================================
local function InitializeSystem()
    -- Save the file locally so it can be read seamlessly every single hop
    if writefile then
        pcall(function()
            writefile(fileName, coreScriptContent)
        end)
    end
    
    -- Run it immediately for this session
    loadstring(coreScriptContent)()
end

InitializeSystem()
