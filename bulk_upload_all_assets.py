import os
import sys
import json
import time
import urllib.request
import urllib.error
import pymongo

sys.stdout.reconfigure(line_buffering=True)

API_KEY = "KHKOEvpfOUO//i9kYj1cPzLSv29+Y6Zwe60M0T3EY01LGfRfZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaGRXUWlPaUpTYjJKc2IzaEpiblJsY201aGJDSXNJbWx6Y3lJNklrTnNiM1ZrUVhWMGFHVnVkR2xqWVhScGIyNVRaWEoyYVdObElpd2lZbUZ6WlVGd2FVdGxlU0k2SWt0SVMwOUZkbkJtVDFWUEx5OXBPV3RaYWpGalVIcE1VM1l5T1N0Wk5scDNaVFl3VFRCVU0wVlpNREZNUjJaU1ppSXNJbTkzYm1WeVNXUWlPaUk1T0RnMk1EazJORFUzSWl3aVpYaHdJam94TnprME16WTVOVFkwTENKcFlYUWlPakUzT1RRek5qVTVOalFzSW01aVppSTZNVGM1TkRNMk5UazJOSDAuSlRWWGdKM0lTclBZTkN4V0ZJTmlWZWtEbENhdmJlLVZ5ZElqTDRadVhvdjJReHFHMDJpMHBZNjBuM1pNYTB6Vk51Nl8tX1VhVk54M01BWjdNRkdibGY1eTRuRF9oZHgtN1MtZnFkb3dKeGF2aThiWE5YWUNmeWp3VFRzcWpNNzlvNmxnclR6T3JITDdSNGFmWmZMZUliXzhHOWZDYXVWZXpKb25tZVRCSVBxMGpWVWNQcWRHV2ZVTUlHS0RXbUVKaTBReUhDUW5lSjhvRXZFd3RYMzFOZl9RLWFabFB3RHdJYk12Z29xNmNmN3lMZV9WUVdoenVqcUQwWFc4WjBORmNqOFBnVjZNVWxUeG8xOFFicGFwTmNPOU9GRmFCZDFxZU0yWFB6VzluLW8wNU9KTkRwY3ZqWTZ1dGhpOW5Lci1Na0E0Q1ZuZUxrS2NuOEc4cFlYTEx3"
CREATOR_USER_ID = "9886096457"
ASSETS_DIR = "assets_ready_to_upload"
MONGO_URI = "mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin"

# Muat mapping yang sudah ada jika proses sebelumnya terhenti
PROGRESS_FILE = "uploaded_assets_mapping.json"
mapping = {}
if os.path.exists(PROGRESS_FILE):
    try:
        with open(PROGRESS_FILE, 'r', encoding='utf-8') as f:
            mapping = json.load(f)
    except Exception:
        mapping = {}

def upload_single_file(file_path, display_name):
    url = "https://apis.roblox.com/assets/v1/assets"
    boundary = f"----Boundary{int(time.time()*1000)}"

    metadata = {
        "assetType": "Image",
        "displayName": display_name[:50],
        "description": f"OSCE Clinical Pre-test: {display_name}",
        "creationContext": {
            "creator": {
                "userId": CREATOR_USER_ID
            }
        }
    }

    body = bytearray()
    # 1. request metadata
    body.extend(f'--{boundary}\r\n'.encode('utf-8'))
    body.extend(b'Content-Disposition: form-data; name="request"\r\n')
    body.extend(b'Content-Type: application/json\r\n\r\n')
    body.extend(json.dumps(metadata).encode('utf-8'))
    body.extend(b'\r\n')

    # 2. fileContent
    fname = os.path.basename(file_path)
    body.extend(f'--{boundary}\r\n'.encode('utf-8'))
    body.extend(f'Content-Disposition: form-data; name="fileContent"; filename="{fname}"\r\n'.encode('utf-8'))
    body.extend(b'Content-Type: image/jpeg\r\n\r\n')
    with open(file_path, 'rb') as f:
        body.extend(f.read())
    body.extend(b'\r\n')
    body.extend(f'--{boundary}--\r\n'.encode('utf-8'))

    req = urllib.request.Request(url, data=body, method='POST')
    req.add_header('x-api-key', API_KEY)
    req.add_header('Content-Type', f'multipart/form-data; boundary={boundary}')

    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            op_path = data.get('path')
            if not op_path:
                return data.get('response', {}).get('assetId')
            
            # Polling Operation
            op_url = f"https://apis.roblox.com/assets/v1/{op_path}"
            for _ in range(25): # Max ~35 detik polling
                time.sleep(1.5)
                op_req = urllib.request.Request(op_url)
                op_req.add_header('x-api-key', API_KEY)
                with urllib.request.urlopen(op_req) as op_resp:
                    op_data = json.loads(op_resp.read().decode('utf-8'))
                    if op_data.get('done'):
                        err = op_data.get('error')
                        if err:
                            print(f"   ❌ Moderation / Error: {err.get('message')}")
                            return None
                        asset_id = op_data.get('response', {}).get('assetId')
                        return asset_id
            print(f"   ⚠️ Polling timed out for {display_name}")
            return None
    except urllib.error.HTTPError as e:
        err_body = e.read().decode('utf-8')
        print(f"   ❌ HTTP {e.code}: {err_body}")
        if e.code == 429:
            print("   ⏳ Rate limited, jeda 15 detik...")
            time.sleep(15)
        return None
    except Exception as e:
        print(f"   ❌ Network error: {e}")
        return None

def main():
    files = sorted([f for f in os.listdir(ASSETS_DIR) if f.endswith('.jpg')])
    total = len(files)
    print(f"🚀 Memulai bulk upload {total} gambar kasus ke Roblox Open Cloud...")

    # Koneksi MongoDB Lokal
    db = pymongo.MongoClient(MONGO_URI)['test']

    success_count = 0
    already_count = 0

    for idx, fname in enumerate(files, 1):
        display_name = os.path.splitext(fname)[0]
        fpath = os.path.join(ASSETS_DIR, fname)

        # Cek apakah sudah pernah di-upload sebelumnya
        if display_name in mapping and mapping[display_name]:
            already_count += 1
            print(f"[{idx}/{total}] ⏩ {display_name} sudah ada: {mapping[display_name]}")
            continue

        print(f"[{idx}/{total}] ⬆️ Uploading {display_name}...")
        asset_id = upload_single_file(fpath, display_name)

        if asset_id:
            rbx_id = f"rbxassetid://{asset_id}"
            mapping[display_name] = rbx_id
            success_count += 1
            print(f"   ✅ Berhasil! Asset ID: {rbx_id}")

            # Simpan progress ke JSON
            with open(PROGRESS_FILE, 'w', encoding='utf-8') as f:
                json.dump(mapping, f, indent=2)

            # Update langsung ke MongoDB Lokal
            parts = display_name.split('_')
            case_id = f"{parts[0]}_{parts[1]}"
            tipe = parts[2].lower()
            field = "roblox_assets.radiograf_asset_id" if "radio" in tipe else "roblox_assets.intraoral_asset_id"
            db['medicalcases'].update_one({"id": case_id}, {"$set": {field: rbx_id}})

        # Beri jeda 1 detik agar ramah rate-limit
        time.sleep(1.0)

    print("\n=======================================================")
    print(f"🎉 SELESAI BULK UPLOAD!")
    print(f"Total Berhasil: {success_count} baru, {already_count} sebelumnya.")
    print(f"Tersimpan di: '{PROGRESS_FILE}' dan MongoDB lokal.")
    print("=======================================================")

if __name__ == '__main__':
    main()

