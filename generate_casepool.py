import json

with open('dataset.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

lines = []
lines.append('--[[')
lines.append('    CasePool.luau')
lines.append('    Koleksi 41 Kasus Medis Pre-test (Stratified Pool)')
lines.append('    - abses_periapikal: 19 kasus (case_001 s.d. case_019)')
lines.append('    - granuloma_periapikal: 8 kasus (case_026 s.d. case_033)')
lines.append('    - kista_radikuler: 14 kasus (case_051 s.d. case_064)')
lines.append('--]]')
lines.append('')
lines.append('local CasePool = {}')
lines.append('')
lines.append('CasePool.Cases = {')

for c in data:
    cid = c['id']
    kode = c['kode_kasus']
    kat = c['kategori_lesi']
    diag = c['diagnosis_benar']
    elemen = c.get('elemen_gigi', '')
    vignette = c['vignette_tes'].replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')
    radio = c.get('assets', {}).get('citra_radiograf', '')
    intra = c.get('assets', {}).get('foto_intraoral', '')
    rbx_radio = ''
    rbx_intra = ''
    
    lines.append(f'    ["{cid}"] = {{')
    lines.append(f'        id = "{cid}",')
    lines.append(f'        kode_kasus = "{kode}",')
    lines.append(f'        kategori_lesi = "{kat}",')
    lines.append(f'        diagnosis_benar = "{diag}",')
    lines.append(f'        elemen_gigi = "{elemen}",')
    lines.append(f'        vignette_tes = "{vignette}",')
    lines.append(f'        radiograf_local = "{radio}",')
    lines.append(f'        intraoral_local = "{intra}",')
    lines.append(f'        radiograf_asset_id = "{rbx_radio}",')
    lines.append(f'        intraoral_asset_id = "{rbx_intra}"')
    lines.append('    },')

lines.append('}')
lines.append('')
lines.append('return CasePool')

content = '\n'.join(lines)
with open('CasePool.luau', 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Generated CasePool.luau with {len(data)} cases. File size: {len(content)} bytes.")

