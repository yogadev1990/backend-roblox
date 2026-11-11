import json
import os
import glob
import pymongo

with open('uploaded_assets_mapping.json') as f:
    mapping = json.load(f)

with open('dataset.json') as f:
    dataset = json.load(f)

with open('CasePool.luau') as f:
    casepool_text = f.read()

client = pymongo.MongoClient('mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin')
db = client['test']
mongo_docs = {d['id']: d for d in db.medicalcases.find({})}

print("="*60)
print(f"AUDIT LAPORAN LENGKAP ASET GAMBAR & DATABASE ({len(dataset)} KASUS / 72 GAMBAR)")
print("="*60)

issues = []
table_rows = []

for c in dataset:
    cid = c['id']
    kode = c.get('kode_kasus', '')
    kat = c.get('kategori_lesi', '')
    
    # 1. Local files
    rad_file_ready = os.path.exists(f"assets_ready_to_upload/{cid}_radiograf.jpg")
    intra_file_ready = os.path.exists(f"assets_ready_to_upload/{cid}_intraoral.jpg")
    
    # 2. Mapping
    map_rad = mapping.get(f"{cid}_radiograf")
    map_intra = mapping.get(f"{cid}_intraoral")
    
    # 3. Mongo
    m_doc = mongo_docs.get(cid)
    m_rad = m_doc.get('roblox_assets', {}).get('radiograf_asset_id') if m_doc else None
    m_intra = m_doc.get('roblox_assets', {}).get('intraoral_asset_id') if m_doc else None
    
    # 4. Check consistency
    has_issue = False
    reasons = []
    if not rad_file_ready:
        reasons.append("File radiograf tidak ada di assets_ready_to_upload")
        has_issue = True
    if not intra_file_ready:
        reasons.append("File intraoral tidak ada di assets_ready_to_upload")
        has_issue = True
    if not map_rad or map_rad == "rbxassetid://0":
        reasons.append("Asset ID radiograf di mapping KOSONG/0")
        has_issue = True
    if not map_intra or map_intra == "rbxassetid://0":
        reasons.append("Asset ID intraoral di mapping KOSONG/0")
        has_issue = True
    if map_rad != m_rad:
        reasons.append(f"Radiograf Mongo ({m_rad}) != Mapping ({map_rad})")
        has_issue = True
    if map_intra != m_intra:
        reasons.append(f"Intraoral Mongo ({m_intra}) != Mapping ({map_intra})")
        has_issue = True
        
    # Check in CasePool.luau text
    if map_rad and map_rad not in casepool_text:
        reasons.append(f"Radiograf {map_rad} tidak ada di CasePool.luau")
        has_issue = True
    if map_intra and map_intra not in casepool_text:
        reasons.append(f"Intraoral {map_intra} tidak ada di CasePool.luau")
        has_issue = True

    if has_issue:
        issues.append((cid, kode, reasons))
    
    table_rows.append({
        "id": cid,
        "kode": kode,
        "kategori": kat,
        "radiograf_asset": map_rad,
        "intraoral_asset": map_intra,
        "mongo_rad": m_rad,
        "mongo_intra": m_intra,
        "file_rad_ok": rad_file_ready,
        "file_intra_ok": intra_file_ready
    })

print(f"Total Kasus Diperiksa: {len(table_rows)}")
print(f"Total Masalah Ditemukan: {len(issues)}")
if issues:
    for cid, kode, reasons in issues:
        print(f"❌ [{cid} | {kode}]:")
        for r in reasons:
            print(f"     - {r}")
else:
    print("✅ SEMUA 36 KASUS KONSISTEN 100% ANTARA FILE, MAPPING, MONGO, & CasePool.luau LOKAL!")

