import json
import os

with open('dataset.json', 'r', encoding='utf-8') as f:
    dataset = json.load(f)

with open('uploaded_assets_mapping.json', 'r', encoding='utf-8') as f:
    mapping = json.load(f)

print(f"Menggabungkan {len(mapping)} asset ID ke {len(dataset)} kasus...")

# Update dataset
for c in dataset:
    cid = c['id']
    rad_key = f"{cid}_radiograf"
    intra_key = f"{cid}_intraoral"
    
    rad_asset = mapping.get(rad_key, "")
    intra_asset = mapping.get(intra_key, "")
    
    c['roblox_assets'] = {
        'radiograf_asset_id': rad_asset,
        'intraoral_asset_id': intra_asset
    }

with open('dataset.json', 'w', encoding='utf-8') as f:
    json.dump(dataset, f, indent=2, ensure_ascii=False)

print("✅ dataset.json berhasil diperbarui dengan Asset IDs!")

# Generate CasePool.luau
luau_lines = []
luau_lines.append("--[[")
luau_lines.append("    CasePool.luau")
luau_lines.append("    Koleksi 36 Kasus Medis Pre-test (Stratified Pool)")
luau_lines.append("    - abses_periapikal: 17 kasus")
luau_lines.append("    - granuloma_periapikal: 7 kasus")
luau_lines.append("    - kista_radikuler: 12 kasus")
luau_lines.append("--]]")
luau_lines.append("")
luau_lines.append("local CasePool = {}")
luau_lines.append("")
luau_lines.append("CasePool.Cases = {")

for c in dataset:
    cid = c['id']
    kode = c.get('kode_kasus', '')
    kat = c.get('kategori_lesi', '')
    diag = c.get('diagnosis_benar', '')
    gigi = c.get('elemen_gigi', '')
    vig = c.get('vignette_tes', '').replace('"', '\\"').replace('\n', ' ')
    rad_asset = c['roblox_assets']['radiograf_asset_id']
    intra_asset = c['roblox_assets']['intraoral_asset_id']
    
    luau_lines.append(f'    ["{cid}"] = {{')
    luau_lines.append(f'        id = "{cid}",')
    luau_lines.append(f'        kode_kasus = "{kode}",')
    luau_lines.append(f'        kategori_lesi = "{kat}",')
    luau_lines.append(f'        diagnosis_benar = "{diag}",')
    luau_lines.append(f'        elemen_gigi = "{gigi}",')
    luau_lines.append(f'        vignette_tes = "{vig}",')
    luau_lines.append(f'        radiograf_asset_id = "{rad_asset}",')
    luau_lines.append(f'        intraoral_asset_id = "{intra_asset}"')
    luau_lines.append('    },')

luau_lines.append("}")
luau_lines.append("")

helper_code = '''
-- Helper: Fisher-Yates Shuffle
local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

-- Stratified Random Sampling: 3 Abses, 3 Granuloma, 3 Kista
function CasePool.GetRandomPreTestCases(excludedIds)
    excludedIds = excludedIds or {}
    local excludedMap = {}
    for _, id in ipairs(excludedIds) do
        excludedMap[id] = true
    end

    local poolAbses = {}
    local poolGranuloma = {}
    local poolKista = {}

    for _, caseData in pairs(CasePool.Cases) do
        if not excludedMap[caseData.id] then
            if caseData.kategori_lesi == "abses_periapikal" then
                table.insert(poolAbses, caseData)
            elseif caseData.kategori_lesi == "granuloma_periapikal" then
                table.insert(poolGranuloma, caseData)
            elseif caseData.kategori_lesi == "kista_radikuler" then
                table.insert(poolKista, caseData)
            end
        end
    end

    shuffle(poolAbses)
    shuffle(poolGranuloma)
    shuffle(poolKista)

    local selected = {}
    for i = 1, math.min(3, #poolAbses) do
        table.insert(selected, poolAbses[i])
    end
    for i = 1, math.min(3, #poolGranuloma) do
        table.insert(selected, poolGranuloma[i])
    end
    for i = 1, math.min(3, #poolKista) do
        table.insert(selected, poolKista[i])
    end

    -- Acak urutan ke-9 soal agar kategori penyakit tidak berurutan
    shuffle(selected)
    return selected
end

return CasePool
'''
luau_lines.append(helper_code)

with open('CasePool.luau', 'w', encoding='utf-8') as f:
    f.write('\n'.join(luau_lines))

print("✅ CasePool.luau berhasil diperbarui dengan 36 kasus dan 72 Asset ID!")
