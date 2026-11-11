import json
import pymongo

with open('uploaded_assets_mapping.json') as f:
    mapping = json.load(f)

client = pymongo.MongoClient('mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin')
db = client['test']
mongo_docs = {d['id']: d.get('roblox_assets', {}) for d in db.medicalcases.find({})}

# Generate luau script to verify all 36 in Studio
luau_check_code = """
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
"""

with open('scratch/verify_studio.luau', 'w') as f:
    f.write(luau_check_code)

print("Mapping count:", len(mapping))
print("Mongo count:", len(mongo_docs))

# Check mapping vs mongo
mismatches = []
for k, v in mapping.items():
    # k is case_XXX_radiograf or case_XXX_intraoral
    parts = k.split('_')
    cid = f"{parts[0]}_{parts[1]}"
    atype = parts[2]
    
    m_asset = mongo_docs.get(cid, {}).get(f"{atype}_asset_id")
    if m_asset != v:
        mismatches.append(f"{k}: mapping={v} != mongo={m_asset}")

print(f"Total Mismatches Mapping vs MongoDB: {len(mismatches)}")
if mismatches:
    for m in mismatches[:10]:
        print(" ", m)
else:
    print("✅ Mapping and MongoDB are 100% in sync!")

