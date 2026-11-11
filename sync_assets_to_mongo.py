import sys
import json
import pymongo

MONGO_URI = 'mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin'

def sync_mapping(mapping_data):
    db = pymongo.MongoClient(MONGO_URI)['test']
    updated_count = 0

    for name, rbx_id in mapping_data.items():
        # name format: case_001_radiograf or case_001_intraoral
        parts = name.split('_')
        if len(parts) >= 3:
            case_id = f"{parts[0]}_{parts[1]}"
            tipe = parts[2].lower()

            field = "roblox_assets.radiograf_asset_id" if "radio" in tipe else "roblox_assets.intraoral_asset_id"
            res = db['medicalcases'].update_one(
                {"id": case_id},
                {"$set": {field: rbx_id}}
            )
            if res.matched_count > 0:
                updated_count += 1

    print(f"✅ Berhasil menyinkronkan {updated_count} aset ke MongoDB lokal!")

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Penggunaan: python sync_assets_to_mongo.py <mapping.json>")
        sys.exit(1)

    with open(sys.argv[1], 'r', encoding='utf-8') as f:
        data = json.load(f)
    sync_mapping(data)

