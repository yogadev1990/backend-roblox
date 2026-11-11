import json
import pymongo

# 1. Update uploaded_assets_mapping.json
with open('uploaded_assets_mapping.json', 'r', encoding='utf-8') as f:
    mapping = json.load(f)

old_id = mapping['case_017_intraoral']
mapping['case_017_intraoral'] = 'rbxassetid://133716650028360'

with open('uploaded_assets_mapping.json', 'w', encoding='utf-8') as f:
    json.dump(mapping, f, indent=2)
print("Updated uploaded_assets_mapping.json")

# 2. Update dataset.json
with open('dataset.json', 'r', encoding='utf-8') as f:
    dataset = json.load(f)

for c in dataset:
    if c['id'] == 'case_017':
        c['roblox_assets']['intraoral_asset_id'] = 'rbxassetid://133716650028360'
        break

with open('dataset.json', 'w', encoding='utf-8') as f:
    json.dump(dataset, f, indent=2, ensure_ascii=False)
print("Updated dataset.json")

# 3. Update CasePool.luau
with open('CasePool.luau', 'r', encoding='utf-8') as f:
    code = f.read()

code = code.replace(old_id, 'rbxassetid://133716650028360')
with open('CasePool.luau', 'w', encoding='utf-8') as f:
    f.write(code)
print("Updated CasePool.luau")

# 4. Update MongoDB
client = pymongo.MongoClient('mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin')
db = client['test']
res = db.medicalcases.update_one(
    {"id": "case_017"},
    {"$set": {"roblox_assets.intraoral_asset_id": "rbxassetid://133716650028360"}}
)
print("Updated MongoDB:", res.modified_count, "document modified")

