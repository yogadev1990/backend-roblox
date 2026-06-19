# Dokumentasi Backend (`server.js`)

File `server.js` merupakan file utama untuk backend **Roblox Dental Simulator**. Server ini dibangun menggunakan **Node.js** dan **Express.js**, terhubung dengan database **MongoDB** (melalui Mongoose), serta mengintegrasikan **Google Gemini AI** untuk fitur percakapan AI dinamis dengan pasien (NPC).

---

## 1. Teknologi & Dependencies

- **express**: Framework backend Node.js untuk mengatur routing dan API.
- **mongoose**: ODM (Object Data Modeling) untuk MongoDB.
- **dotenv**: Mengelola environment variables (seperti PORT, MONGO_URI, API_SECRET).
- **body-parser**: Parsing request body berformat JSON.
- **@google/generative-ai**: Menggunakan model Gemini (`gemini-2.5-flash`) untuk menghasilkan respon chat AI (pasien poli gigi).

---

## 2. Struktur Database (Mongoose Schemas)

Terdapat 6 schema utama yang merepresentasikan struktur data di MongoDB:

### A. Master Data
1. **ItemSchema (`Item`)**: Berisi daftar kamus alat & barang di dalam game (misal: alat cabut, sonde). Field: `itemId`, `displayName`, `description`, `icon`, `category`, `price`, dll.
2. **AchievementSchema (`Achievement`)**: Data pencapaian pemain (misi). Field: `achieveId`, `title`, `description`, `targetCount`, `rewardGold`, `rewardXP`.
3. **NpcPresetSchema (`NpcPreset`)**: Tampilan visual NPC pasien di Roblox. Field: `presetId`, `gender`, `shirtId`, `pantsId`, `faceId`, `hairId`, `accessoryId`.
4. **MedicalCaseSchema (`MedicalCase`)**: Soal ujian/skenario klinis pasien. Termasuk di dalamnya tingkat kesulitan, data demografi (umur, gender), hasil pemeriksaan fisik, aset gambar (intraoral, radiograf), dan OSCE checklist untuk penilaian.

### B. User Data & Security
5. **UserSchema (`User`)**: Menyimpan data pemain (Roblox User). Field: `userId`, `robloxId`, `username`, `robloxUsername`, `xp`, `level`, `gold`, `inventory`, `achievements`, dan `chatHistory` (untuk memori AI).
6. **WhitelistSchema (`Whitelist`)**: Daftar `robloxId` yang diizinkan untuk login jika user baru dan belum terdaftar secara bebas.

---

## 3. Fungsi Helper (Randomizer Engine)

### `generatePatientProfile(medicalCase)`
Fungsi ini digunakan untuk merakit profil pasien baru secara acak berdasarkan constraint (batasan) dari `MedicalCase` yang sedang dijalankan.
- Mengacak **Gender** (jika `Any`).
- Mengacak **Umur** (sesuai `minAge` dan `maxAge`).
- Memilih **Nama Pasien** acak dari list konstanta `NAMES` sesuai gender.
- Mengambil **Tampilan (Visual Preset)** secara acak dari database berdasarkan gender.

---

## 4. Keamanan (Auth Middleware)

Semua endpoint dilindungi oleh middleware `checkAuth`. Klien (Roblox) wajib mengirimkan header `authorization` yang nilainya sama dengan `API_SECRET` dari file `.env`. Jika tidak cocok, akan dikembalikan status `403 Access Denied`.

---

## 5. API Routes (Endpoints)

### A. Login & Data Load
- **`GET /api/roblox-login/:robloxId`**
  - **Fungsi**: Memproses login player dari Roblox.
  - **Respons**: Mengembalikan data user (`username`, `gold`, `xp`) dan `inventory` yang sudah digabungkan (merge) dengan detail item dari Master Data `Item`. Jika user tidak ada, akan dicek apakah masuk di `Whitelist`.

### B. Gameplay Loop (Random Case)
- **`GET /api/medical-case/start-session`**
  - **Fungsi**: Memulai sesi kasus baru. Backend akan memilih satu `MedicalCase` secara acak dari database, kemudian men-generate profil pasien menggunakan `generatePatientProfile`.
  - **Respons**: Mengembalikan data `caseData` (detail medis/soal) dan `patient` (profil & visual pasien).

### C. Fitur Chat AI (Gemini)
- **`POST /api/chat-ai`**
  - **Fungsi**: Menerima pesan chat dari player (Dokter Gigi) kepada NPC (Pasien).
  - **Body**: `{ robloxId, pesan, konteksPenyakit, patientProfile }`
  - **Proses**:
    1. Menyimpan pesan user ke `chatHistory` (max 20 pesan terakhir).
    2. Merakit *System Prompt* dinamis dengan instruksi roleplay ketat agar Gemini bertingkah laku seperti pasien awam dengan keluhan medis tertentu.
    3. Gemini merespons dengan tambahan tag informasi otomatis (cth: `[NAMA:Budi]`, `[KELUHAN:Ngilu]`).
    4. Jawaban dari AI dikembalikan dan disimpan juga ke `chatHistory`.

### D. Ekonomi & Toko (Shop)
- **`GET /api/shop/items`**
  - **Fungsi**: Mengambil semua item yang bisa dibeli (`isBuyable: true`).
- **`POST /api/buy-item`**
  - **Fungsi**: Membeli item. Mengecek apakah Gold cukup dan item belum dimiliki. Jika berhasil, Gold dikurangi dan item dimasukkan ke inventory.
- **`POST /api/update-progress`**
  - **Fungsi**: Mengupdate Gold dan XP user setelah menyelesaikan misi/kasus.

### E. Admin / Input Data (Seeding)
Endpoint untuk memasukkan data master via tools seperti Postman (Membutuhkan `API_SECRET`):
- `POST /api/items` - Tambah Master Item.
- `POST /api/medical-case` - Tambah Kasus Medis.
- `POST /api/achievements` - Tambah Achievement.
- `POST /api/npc-presets` - Tambah Preset Visual NPC.
- `POST /api/whitelist` - Mendaftarkan `robloxId` ke whitelist.

---

## 6. Menjalankan Server
```bash
# Instalasi dependencies (jika belum)
npm install

# Menjalankan server (default port 4321)
npm start
# atau
node server.js
```
*Server akan mencetak ke console jika berhasil terkoneksi dengan MongoDB dan berjalan dengan sukses.*
