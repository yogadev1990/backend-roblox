"""
db_manager.py - Utilitas Manajemen Database MongoDB Lokal Dental Simulator via Python
Penggunaan:
    python db_manager.py stats                   -> Lihat ringkasan database & jumlah kasus
    python db_manager.py list [kategori]         -> Tampilkan daftar kasus
    python db_manager.py set-asset <id> <rad> [intra] -> Pasang Roblox Asset ID ke kasus
    python db_manager.py telemetry [userId]      -> Lihat log telemetri peserta
    python db_manager.py export-csv              -> Ekspor hasil telemetri ke CSV
"""

import sys
import json
import csv
import pymongo

MONGO_URI = 'mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin'

def get_db():
    client = pymongo.MongoClient(MONGO_URI, serverSelectionTimeoutMS=3000)
    return client['test']

def print_stats():
    db = get_db()
    print("==================================================")
    print("📊 STATISTIK MONGODB LOKAL (test)")
    print("==================================================")
    print("Koleksi yang tersedia:", db.list_collection_names())
    print(f"Total 'medicalcases': {db['medicalcases'].count_documents({})}")
    print(f"Total 'pretesttelemetries': {db['pretesttelemetries'].count_documents({})}")
    print(f"Total 'pretestsessions': {db['pretestsessions'].count_documents({})}")
    print(f"Total 'users': {db['users'].count_documents({})}")
    print(f"Total 'items': {db['items'].count_documents({})}")

    summary = {}
    for doc in db['medicalcases'].find():
        kat = doc.get('kategori_lesi', 'unknown')
        summary[kat] = summary.get(kat, 0) + 1

    print("\nRincian Kategori Kasus:")
    for kat, count in summary.items():
        print(f"  • {kat}: {count} kasus")
    print("==================================================")

def list_cases(kategori=None):
    db = get_db()
    query = {"kategori_lesi": kategori} if kategori else {}
    cases = list(db['medicalcases'].find(query).sort("id", 1))
    print(f"Ditemukan {len(cases)} kasus:")
    for c in cases:
        rad = c.get('roblox_assets', {}).get('radiograf_asset_id') or '-'
        intra = c.get('roblox_assets', {}).get('intraoral_asset_id') or '-'
        print(f"[{c['id']}] {c['kode_kasus']} | {c['kategori_lesi']} | Diag: {c['diagnosis_benar']} | RadAsset: {rad}")

def add_whitelist(roblox_id, added_by="Admin"):
    db = get_db()
    db['whitelists'].update_one(
        {"robloxId": str(roblox_id)},
        {"$set": {"robloxId": str(roblox_id), "addedBy": added_by}},
        upsert=True
    )
    print(f"✅ Roblox ID {roblox_id} berhasil ditambahkan ke whitelist.")

def list_whitelist():
    db = get_db()
    items = list(db['whitelists'].find())
    print(f"Daftar Whitelist ({len(items)} akun):")
    for item in items:
        print(f"• RobloxId: {item.get('robloxId')} (Ditambahkan oleh: {item.get('addedBy')})")

def set_asset(case_id, rad_asset, intra_asset=""):
    db = get_db()
    res = db['medicalcases'].update_one(
        {"id": case_id},
        {"$set": {
            "roblox_assets.radiograf_asset_id": rad_asset,
            "roblox_assets.intraoral_asset_id": intra_asset
        }}
    )
    if res.matched_count > 0:
        print(f"✅ Berhasil update asset untuk {case_id}: Radiograf={rad_asset}, Intraoral={intra_asset}")
    else:
        print(f"❌ Kasus {case_id} tidak ditemukan.")

def view_telemetry(user_id=None):
    db = get_db()
    query = {"playerUserId": int(user_id)} if user_id else {}
    logs = list(db['pretesttelemetries'].find(query).sort("timestamp", -1))
    print(f"Ditemukan {len(logs)} log telemetri:")
    for item in logs:
        print(f"• User: {item.get('robloxUsername')} ({item.get('playerUserId')}) | Soal #{item.get('nomorUrut')} ({item.get('kodeKasus')}) | Jawab: {item.get('jawabanPemain')} | Kunci: {item.get('kunciJawaban')} | Tepat: {item.get('isCorrect')} | Waktu: {item.get('durasiDetik')}s")

def export_csv(filename="hasil_telemetri.csv"):
    db = get_db()
    logs = list(db['pretesttelemetries'].find().sort("timestamp", 1))
    if not logs:
        print("Belum ada log telemetri untuk diekspor.")
        return

    fields = ["playerUserId", "robloxUsername", "sessionId", "nomorUrut", "caseId", "kodeKasus", "kategori", "jawabanPemain", "kunciJawaban", "isCorrect", "durasiDetik", "timestamp"]
    with open(filename, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction='ignore')
        writer.writeheader()
        writer.writerows(logs)
    print(f"✅ Berhasil ekspor {len(logs)} log ke {filename}")

if __name__ == '__main__':
    args = sys.argv[1:]
    if not args or args[0] == 'stats':
        print_stats()
    elif args[0] == 'list':
        kat = args[1] if len(args) > 1 else None
        list_cases(kat)
    elif args[0] == 'whitelist':
        if len(args) > 1:
            add_whitelist(args[1])
        else:
            list_whitelist()
    elif args[0] == 'set-asset':
        if len(args) < 3:
            print("Usage: python db_manager.py set-asset <case_id> <radiograf_asset_id> [intraoral_asset_id]")
        else:
            intra = args[3] if len(args) > 3 else ""
            set_asset(args[1], args[2], intra)
    elif args[0] == 'telemetry':
        uid = args[1] if len(args) > 1 else None
        view_telemetry(uid)
    elif args[0] == 'export-csv':
        fname = args[1] if len(args) > 1 else "hasil_telemetri.csv"
        export_csv(fname)
    else:
        print(__doc__)
