import os
import time
from PIL import Image

ASSETS_DIR = "assets_ready_to_upload"

def process_intraoral(img_path):
    im = Image.open(img_path).convert('RGB')
    hsv = im.convert('HSV')
    h_data = bytearray(hsv.getchannel('H').tobytes())
    s_data = bytearray(hsv.getchannel('S').tobytes())
    v_data = bytearray(hsv.getchannel('V').tobytes())
    
    total = len(h_data)
    for i in range(total):
        h = h_data[i]
        s = s_data[i]
        
        # Red / Magenta / Deep Pink / Erythema range
        # Pillow HSV H: 0..255 (0..30 is 0-42 deg; 224..255 is 315-360 deg)
        if (h <= 30 or h >= 224) and s > 25:
            # Shift hue towards brownish orange / povidone-iodine antiseptic
            if h >= 224:
                h_data[i] = int(25 + (255 - h) * 0.3)
            else:
                h_data[i] = min(48, h + 24)
            
            # Desaturate by 55%
            new_s = int(s * 0.45)
            # Clamp max saturation so blood cannot look vivid
            s_data[i] = min(75, new_s)
            
    new_h = Image.frombytes('L', im.size, bytes(h_data))
    new_s = Image.frombytes('L', im.size, bytes(s_data))
    new_v = Image.frombytes('L', im.size, bytes(v_data))
    
    result = Image.merge('HSV', (new_h, new_s, new_v)).convert('RGB')
    result.save(img_path, format='JPEG', quality=95)

def process_radiograf(img_path):
    # Ensure radiographs are strictly clean grayscale (no color tints)
    im = Image.open(img_path).convert('L').convert('RGB')
    im.save(img_path, format='JPEG', quality=95)

def main():
    if not os.path.exists(ASSETS_DIR):
        print(f"Error: {ASSETS_DIR} not found.")
        return
        
    files = sorted(os.listdir(ASSETS_DIR))
    intra_files = [f for f in files if 'intraoral' in f and f.endswith('.jpg')]
    radio_files = [f for f in files if 'radiograf' in f and f.endswith('.jpg')]
    
    print(f"🎨 Memulai Mass Edit / Color Grading:")
    print(f"   • {len(intra_files)} foto intraoral (desaturasi merah 55% + pergeseran hue ke amber/povidone-iodine)")
    print(f"   • {len(radio_files)} foto radiograf (standardisasi grayscale murni)")
    
    t0 = time.time()
    for idx, f in enumerate(intra_files, 1):
        fp = os.path.join(ASSETS_DIR, f)
        process_intraoral(fp)
        if idx % 10 == 0 or idx == len(intra_files):
            print(f"   [Intraoral {idx}/{len(intra_files)}] diproses...")
            
    for idx, f in enumerate(radio_files, 1):
        fp = os.path.join(ASSETS_DIR, f)
        process_radiograf(fp)
        if idx % 10 == 0 or idx == len(radio_files):
            print(f"   [Radiograf {idx}/{len(radio_files)}] diproses...")
            
    elapsed = time.time() - t0
    print(f"✅ Selesai memproses seluruh {len(intra_files) + len(radio_files)} gambar dalam {elapsed:.2f} detik!")

if __name__ == '__main__':
    main()

