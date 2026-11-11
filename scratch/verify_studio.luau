
local rep = game:GetService("ReplicatedStorage")
local folder = rep:FindFirstChild("PreTestSystem")
local CasePool = folder and require(folder.CasePool) or require(rep.CasePool)

local missingOrMismatch = {}
local totalCases = 0
for id, c in pairs(CasePool.Cases) do
    totalCases = totalCases + 1
    if not c.radiograf_asset_id or c.radiograf_asset_id == "" or c.radiograf_asset_id == "rbxassetid://0" then
        table.insert(missingOrMismatch, id .. " Missing radiograf")
    end
    if not c.intraoral_asset_id or c.intraoral_asset_id == "" or c.intraoral_asset_id == "rbxassetid://0" then
        table.insert(missingOrMismatch, id .. " Missing intraoral")
    end
end

return string.format("Total: %d | Issues: %d (%s)", totalCases, #missingOrMismatch, table.concat(missingOrMismatch, ", "))
