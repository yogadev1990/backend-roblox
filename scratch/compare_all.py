import json
import pymongo
import re

# 1. Read uploaded_assets_mapping.json
with open('uploaded_assets_mapping.json') as f:
    mapping = json.load(f)

# 2. Read dataset.json
with open('dataset.json') as f:
    dataset = json.load(f)

# 3. Read local CasePool.luau
with open('CasePool.luau') as f:
    casepool_local = f.read()

# 4. Read MongoDB
client = pymongo.MongoClient('mongodb://revanda_admin:GantiDenganPasswordSuperKuat123!@127.0.0.1:27017/test?authSource=admin')
db = client['test']
mongo_docs = list(db.medicalcases.find({}))
mongo_map = {}
for d in mongo_docs:
    cid = d.get('id') or d.get('case_id')
    mongo_map[cid] = d.get('roblox_assets', {})

# 5. Extract IDs from CasePool_clean.luau or scratch
with open('C:/Users/Administrator/.gemini/antigravity/brain/95f4b483-5905-4b66-baba-ef68451711ed/.system_generated/steps/1967/output.txt') as f:
    studio_casepool_text = f.read()

studio_cases = {}
for m in re.finditer(r'CasePool\.Cases\["([^"]+)"\]\s*=\s*\{.*?radiograf_asset_id\s*=\s*"([^"]*)".*?intraoral_asset_id\s*=\s*"([^"]*)".*?\}', studio_casepool_text, re.DOTALL):
    cid, rad, intra = m.groups()
    studio_cases[cid] = {'rad': rad, 'intra': intra}

print(f"Total cases extracted from Studio: {len(studio_cases)}")
print(f"Total cases in mapping: {len(mapping)//2}")
print(f"Total cases in Mongo: {len(mongo_map)}")

print("\n--- SAMPLE CASE_001 COMPARISON ---")
print("Mapping case_001:")
print("  rad:", mapping.get('case_001_radiograf'))
print("  intra:", mapping.get('case_001_intraoral'))
print("Studio case_001:")
print("  rad:", studio_cases.get('case_001', {}).get('rad'))
print("  intra:", studio_cases.get('case_001', {}).get('intra'))
print("Mongo case_001:")
print("  rad:", mongo_map.get('case_001', {}).get('radiograf_asset_id'))
print("  intra:", mongo_map.get('case_001', {}).get('intraoral_asset_id'))

print("\n--- CHECKING ALL 36 CASES ---")
all_cids = sorted(list(set([c['id'] for c in dataset])))
for cid in all_cids:
    map_rad = mapping.get(f"{cid}_radiograf")
    map_intra = mapping.get(f"{cid}_intraoral")
    stu = studio_cases.get(cid, {})
    stu_rad = stu.get('rad', 'MISSING')
    stu_intra = stu.get('intra', 'MISSING')
    mon = mongo_map.get(cid, {})
    mon_rad = mon.get('radiograf_asset_id', 'MISSING')
    mon_intra = mon.get('intraoral_asset_id', 'MISSING')
    
    diffs = []
    if map_rad != stu_rad: diffs.append(f"RAD: map({map_rad}) != stu({stu_rad})")
    if map_intra != stu_intra: diffs.append(f"INTRA: map({map_intra}) != stu({stu_intra})")
    if map_rad != mon_rad: diffs.append(f"RAD: map({map_rad}) != mon({mon_rad})")
    if map_intra != mon_intra: diffs.append(f"INTRA: map({map_intra}) != mon({mon_intra})")
    
    if diffs:
        print(f"[{cid}] MISMATCHES: {'; '.join(diffs)}")

