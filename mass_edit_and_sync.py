import os
import json
import shutil
from PIL import Image

ASSETS_SRC = 'assets'
ASSETS_DST = 'assets_ready_to_upload'

def main():
    with open('dataset.json', 'r', encoding='utf-8') as f:
        dataset = json.load(f)

    # 1. Filter dataset according to actual disk files
    retained = []
    excluded = []
    for c in dataset:
        cid = c['id']
        cat = c['kategori_lesi']
        rad = os.path.join(ASSETS_SRC, cat, f"{cid}_radiograf.jpg")
        intra = os.path.join(ASSETS_SRC, cat, f"{cid}_intraoral.jpg")
        if os.path.exists(rad) and os.path.exists(intra):
            retained.append(c)
        else:
            excluded.append((cid, c.get('kode_kasus', ''), cat))

    print(f"📊 Audit Terkini:")
    print(f"   • Dikecualikan ({len(excluded)} kasus): {excluded}")
    print(f"   • Kasus Aktif ({len(retained)} kasus):")
    cat_counts = {}
    for c in retained:
        cat = c['kategori_lesi']
        cat_counts[cat] = cat_counts.get(cat, 0) + 1
    for k, v in cat_counts.items():
        print(f"     - {k}: {v} kasus")

    with open('dataset.json', 'w', encoding='utf-8') as f:
        json.dump(retained, f, indent=2, ensure_ascii=False)

    # 2. Reset folder upload
    if os.path.exists(ASSETS_DST):
        shutil.rmtree(ASSETS_DST)
    os.makedirs(ASSETS_DST, exist_ok=True)

    # 3. Fungsi Color Grading & Desaturasi Merah
    def process_intraoral(src_path, dst_path):
        im = Image.open(src_path).convert('RGB')
        hsv = im.convert('HSV')
        h_data = bytearray(hsv.getchannel('H').tobytes())
        s_data = bytearray(hsv.getchannel('S').tobytes())
        v_data = bytearray(hsv.getchannel('V').tobytes())
        
        total = len(h_data)
        for i in range(total):
            h = h_data[i]
            s = s_data[i]
            
            # Deteksi rentang warna merah darah / eritema / mukosa pink pekat
            # H 0..40 (~0-56 deg) dan H 210..255 (~296-360 deg)
            if (h <= 40 or h >= 210) and s > 15:
                # Geser Hue ke arah oranye kecokelatan / antiseptik povidone-iodine (H 30..54)
                if h >= 210:
                    h_data[i] = int(30 + (255 - h) * 0.35)
                else:
                    h_data[i] = min(54, max(30, h + 28))
                
                # Turunkan saturasi merah sebesar 60%
                new_s = int(s * 0.40)
                # Kunci saturasi maksimal di angka 50 agar tidak memicu deteksi darah Roblox
                s_data[i] = min(50, new_s)
                
        new_h = Image.frombytes('L', im.size, bytes(h_data))
        new_s = Image.frombytes('L', im.size, bytes(s_data))
        new_v = Image.frombytes('L', im.size, bytes(v_data))
        
        result = Image.merge('HSV', (new_h, new_s, new_v)).convert('RGB')
        result.save(dst_path, format='JPEG', quality=95)

    def process_radiograf(src_path, dst_path):
        # Grayscale murni untuk radiograf
        im = Image.open(src_path).convert('L').convert('RGB')
        im.save(dst_path, format='JPEG', quality=95)

    print(f"\n🎨 Memproses {len(retained) * 2} file gambar:")
    for c in retained:
        cid = c['id']
        cat = c['kategori_lesi']
        process_intraoral(os.path.join(ASSETS_SRC, cat, f"{cid}_intraoral.jpg"), os.path.join(ASSETS_DST, f"{cid}_intraoral.jpg"))
        process_radiograf(os.path.join(ASSETS_SRC, cat, f"{cid}_radiograf.jpg"), os.path.join(ASSETS_DST, f"{cid}_radiograf.jpg"))

    print(f"✅ Seluruh {len(retained) * 2} gambar berhasil diproses dan disimpan di {ASSETS_DST}/")

if __name__ == '__main__':
    main()
