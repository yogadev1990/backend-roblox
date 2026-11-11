import os
import shutil
import json
import csv

DEST_DIR = 'assets_ready_to_upload'
os.makedirs(DEST_DIR, exist_ok=True)

with open('dataset.json', 'r', encoding='utf-8') as f:
    cases = json.load(f)

case_map = {c['id']: c for c in cases}

categories = [
    ('abses_periapikal', 'assets/abses_periapikal'),
    ('granuloma_periapikal', 'assets/granuloma_periapikal'),
    ('kista_radikuler', 'assets/kista_radikuler')
]

copied_files = []
index_data = []

for kat_name, folder in categories:
    if not os.path.exists(folder):
        continue
    for fname in os.listdir(folder):
        if fname.lower().endswith('.jpg') or fname.lower().endswith('.png'):
            src = os.path.join(folder, fname)
            dst = os.path.join(DEST_DIR, fname)
            shutil.copy2(src, dst)
            copied_files.append(fname)

            # Ekstrak metadata
            # Format nama: case_001_radiograf.jpg
            parts = fname.split('_')
            case_id = f"{parts[0]}_{parts[1]}"
            tipe = parts[2].replace('.jpg', '').replace('.png', '')
            c_info = case_map.get(case_id, {})
            size_kb = round(os.path.getsize(src) / 1024, 1)

            index_data.append({
                'filename': fname,
                'case_id': case_id,
                'kode_kasus': c_info.get('kode_kasus', 'N/A'),
                'kategori': kat_name,
                'tipe_gambar': tipe,
                'ukuran_kb': size_kb
            })

# Simpan CSV Index
index_csv = os.path.join(DEST_DIR, 'daftar_gambar.csv')
with open(index_csv, 'w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['filename', 'case_id', 'kode_kasus', 'kategori', 'tipe_gambar', 'ukuran_kb'])
    writer.writeheader()
    writer.writerows(index_data)

print(f"✅ Berhasil menyalin {len(copied_files)} gambar ke folder '{DEST_DIR}/'.")
print(f"📄 Index CSV dibuat di '{index_csv}'.")

