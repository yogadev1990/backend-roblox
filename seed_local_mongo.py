import json
import pymongo
from datetime import datetime, timezone

MONGO_URI = 'mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin'

def main():
    print("⏳ Menghubungkan ke MongoDB Lokal (port 27017)...")
    client = pymongo.MongoClient(MONGO_URI, serverSelectionTimeoutMS=5000)
    db = client['test']
    
    # 1. Baca dataset.json
    print("📂 Membaca dataset.json...")
    with open('dataset.json', 'r', encoding='utf-8') as f:
        cases = json.load(f)
    print(f"📦 Ditemukan {len(cases)} kasus dalam dataset.json.")

    # 2. Drop koleksi medicalcases lama agar indeks usang (seperti caseId_1) terhapus bersih
    print("🗑️ Menghapus koleksi medicalcases lama beserta indeks usang...")
    db['medicalcases'].drop()

    # 3. Siapkan data dengan kompatibilitas ganda (id & caseId)
    now = datetime.now(timezone.utc)
    for c in cases:
        c['caseId'] = c['id'] # Kompatibilitas dengan endpoint lama jika ada
        c['createdAt'] = now
        c['updatedAt'] = now
        if 'roblox_assets' not in c:
            c['roblox_assets'] = {
                'radiograf_asset_id': '',
                'intraoral_asset_id': ''
            }

    print("🚀 Mengimpor 41 kasus baru ke koleksi 'medicalcases'...")
    res = db['medicalcases'].insert_many(cases)
    print(f"✅ Berhasil mengimpor {len(res.inserted_ids)} kasus.")

    # 4. Buat Indeks Baru yang Diperlukan
    print("⚡ Membuat indeks pencarian baru...")
    db['medicalcases'].create_index([("id", pymongo.ASCENDING)], unique=True)
    db['medicalcases'].create_index([("caseId", pymongo.ASCENDING)], unique=True)
    db['medicalcases'].create_index([("kode_kasus", pymongo.ASCENDING)])
    db['medicalcases'].create_index([("kategori_lesi", pymongo.ASCENDING)])

    db['pretesttelemetries'].create_index([("playerUserId", pymongo.ASCENDING)])
    db['pretesttelemetries'].create_index([("timestamp", pymongo.DESCENDING)])
    db['pretestsessions'].create_index([("playerUserId", pymongo.ASCENDING)], unique=True)

    # 5. Verifikasi dan rekap data
    summary = {}
    for doc in db['medicalcases'].find():
        kat = doc.get('kategori_lesi', 'unknown')
        summary[kat] = summary.get(kat, 0) + 1

    print("\n=======================================================")
    print("🎉 STATUS DATABASE MONGODB LOKAL: SUKSES DIROMBAK!")
    print(f"Total Dokumen di 'medicalcases': {db['medicalcases'].count_documents({})}")
    print("📊 Rincian Kategori:")
    for kat, count in summary.items():
        print(f"  • {kat}: {count} kasus")
    print("=======================================================")

if __name__ == '__main__':
    main()
