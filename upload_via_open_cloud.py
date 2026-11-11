"""
upload_via_open_cloud.py - Otomasi Upload Bulk 80 Gambar Kasus ke Roblox via Open Cloud API

Cara Penggunaan:
1. Buat API Key di https://create.roblox.com/dashboard/credentials
   - Permissions: 'Asset System' -> 'Write'
   - Scopes: Universe ID Anda (137992089874828)
2. Jalankan:
   python upload_via_open_cloud.py --api-key "RBX-XXXXX..." [--creator-id "9886096457"]
"""

import os
import sys
import json
import time
import urllib.request
import urllib.error
import pymongo

MONGO_URI = 'mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin'
ASSETS_DIR = 'assets_ready_to_upload'

def upload_asset_open_cloud(file_path, display_name, api_key, creator_id, creator_type="User"):
    url = "https://apis.roblox.com/assets/v1/assets"
    
    metadata = {
        "assetType": "Decal",
        "displayName": display_name[:50],
        "description": f"Clinical dental pre-test case image: {display_name}",
        "creationContext": {
            "creator": {
                f"{creator_type.lower()}Id": str(creator_id)
            }
        }
    }

    boundary = '----RobloxBoundary' + str(int(time.time()))
    body = bytearray()
    
    # Part 1: Request Metadata
    body.extend(f'--{boundary}\r\n'.encode('utf-8'))
    body.extend(b'Content-Disposition: form-data; name="request"\r\n')
    body.extend(b'Content-Type: application/json\r\n\r\n')
    body.extend(json.dumps(metadata).encode('utf-8'))
    body.extend(b'\r\n')

    # Part 2: File content
    filename = os.path.basename(file_path)
    body.extend(f'--{boundary}\r\n'.encode('utf-8'))
    body.extend(f'Content-Disposition: form-data; name="fileContent"; filename="{filename}"\r\n'.encode('utf-8'))
    body.extend(b'Content-Type: image/jpeg\r\n\r\n')
    with open(file_path, 'rb') as f:
        body.extend(f.read())
    body.extend(b'\r\n')
    body.extend(f'--{boundary}--\r\n'.encode('utf-8'))

    req = urllib.request.Request(url, data=body, method='POST')
    req.add_header('x-api-key', api_key)
    req.add_header('Content-Type', f'multipart/form-data; boundary={boundary}')

    try:
        with urllib.request.urlopen(req) as response:
            res_json = json.loads(response.read().decode('utf-8'))
            operation_id = res_json.get('path')
            # Check operation status or direct assetId
            return res_json
    except urllib.error.HTTPError as e:
        error_msg = e.read().decode('utf-8')
        print(f"❌ Gagal upload {filename}: HTTP {e.code} - {error_msg}")
        return None

def main():
    if len(sys.argv) < 2:
        print("Penggunaan: python upload_via_open_cloud.py <ROBLOX_OPEN_CLOUD_API_KEY> [CREATOR_ID]")
        sys.exit(1)

    api_key = sys.argv[1]
    creator_id = sys.argv[2] if len(sys.argv) > 2 else "9886096457"

    files = [f for f in os.listdir(ASSETS_DIR) if f.endswith('.jpg')]
    print(f"🚀 Memulai upload {len(files)} gambar ke Roblox Open Cloud...")

    db = pymongo.MongoClient(MONGO_URI)['test']
    mapping_results = {}

    for idx, fname in enumerate(sorted(files), 1):
        fpath = os.path.join(ASSETS_DIR, fname)
        display_name = os.path.splitext(fname)[0]
        print(f"[{idx}/{len(files)}] Uploading {display_name}...")

        res = upload_asset_open_cloud(fpath, display_name, api_key, creator_id)
        if res:
            asset_id = res.get('assetId')
            if asset_id:
                rbx_id = f"rbxassetid://{asset_id}"
                mapping_results[display_name] = rbx_id
                print(f"   ✅ Asset ID: {rbx_id}")

                # Update langsung ke MongoDB
                parts = display_name.split('_')
                case_id = f"{parts[0]}_{parts[1]}"
                tipe = parts[2]
                field = "roblox_assets.radiograf_asset_id" if tipe == "radiograf" else "roblox_assets.intraoral_asset_id"
                db['medicalcases'].update_one({"id": case_id}, {"$set": {field: rbx_id}})
        time.sleep(0.5)

    with open('uploaded_assets_mapping.json', 'w', encoding='utf-8') as f:
        json.dump(mapping_results, f, indent=2)
    print("🎉 Selesai! Mapping tersimpan di 'uploaded_assets_mapping.json'.")

if __name__ == '__main__':
    main()

