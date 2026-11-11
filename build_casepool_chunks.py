import json

with open('dataset.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

def get_cat_json(cat_name):
    items = []
    for c in data:
        if c['kategori_lesi'] == cat_name:
            items.append({
                'id': c['id'],
                'kode_kasus': c['kode_kasus'],
                'kategori_lesi': c['kategori_lesi'],
                'diagnosis_benar': c['diagnosis_benar'],
                'elemen_gigi': c.get('elemen_gigi', ''),
                'vignette_tes': c['vignette_tes'],
                'radiograf_asset_id': '',
                'intraoral_asset_id': ''
            })
    return json.dumps(items, ensure_ascii=False)

abses_json = get_cat_json('abses_periapikal')
granu_json = get_cat_json('granuloma_periapikal')
kista_json = get_cat_json('kista_radikuler')

with open('chunk_abses.json', 'w', encoding='utf-8') as f:
    f.write(abses_json)

with open('chunk_granu.json', 'w', encoding='utf-8') as f:
    f.write(granu_json)

with open('chunk_kista.json', 'w', encoding='utf-8') as f:
    f.write(kista_json)

print("Generated chunk JSON files.")

