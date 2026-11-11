import pymongo
import json

MONGO_URI = 'mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin'
client = pymongo.MongoClient(MONGO_URI)
db = client['test']

total = db.medicalcases.count_documents({})
print(f"Total Dokumen di koleksi medicalcases: {total}")

with open('uploaded_assets_mapping.json', 'r', encoding='utf-8') as f:
    mapping = json.load(f)

matched = 0
for case in db.medicalcases.find({}):
    cid = case.get('id')
    roblox_assets = case.get('roblox_assets', {})
    rad = roblox_assets.get('radiograf_asset_id')
    intra = roblox_assets.get('intraoral_asset_id')
    
    expected_rad = mapping.get(f"{cid}_radiograf")
    expected_intra = mapping.get(f"{cid}_intraoral")
    
    if rad == expected_rad and intra == expected_intra:
        matched += 1
    else:
        print(f"Mismatch pada {cid}: rad={rad} vs {expected_rad}, intra={intra} vs {expected_intra}")

print(f"✅ Dokumen yang 100% cocok dengan uploaded_assets_mapping.json: {matched} / {total}")

