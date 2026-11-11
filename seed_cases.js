require('dotenv').config();
const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');

const MONGO_URI = process.env.MONGO_URI;

if (!MONGO_URI) {
  console.error("❌ MONGO_URI tidak ditemukan di file .env!");
  process.exit(1);
}

// Skema Kasus Medis Standar Baru
const MedicalCaseSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true }, // e.g. "case_001"
  kode_kasus: { type: String, required: true },       // e.g. "ABS-01"
  kategori_lesi: { type: String, required: true },    // "abses_periapikal" | "granuloma_periapikal" | "kista_radikuler"
  diagnosis_benar: { type: String, required: true },  // e.g. "Abses Periapikal"
  elemen_gigi: String,
  tingkat_kesulitan: { type: String, default: "standar" },
  profil_pasien: Object,
  vignette_tes: { type: String, required: true },
  anamnesis_ai: Object,
  pemeriksaan_objektif: Object,
  parameter_radiografis: Object,
  opsi_diagnosis: [String],
  umpan_balik_formatif: Object,
  assets: Object,
  metadata_sumber: Object,
  roblox_assets: {
    radiograf_asset_id: { type: String, default: "" },
    intraoral_asset_id: { type: String, default: "" }
  }
}, { timestamps: true });

const MedicalCase = mongoose.model('MedicalCase', MedicalCaseSchema);

async function seedDatabase() {
  try {
    console.log("⏳ Menghubungkan ke MongoDB...");
    await mongoose.connect(MONGO_URI);
    console.log("✅ Terhubung ke MongoDB.");

    const datasetPath = path.join(__dirname, 'dataset.json');
    if (!fs.existsSync(datasetPath)) {
      throw new Error(`File ${datasetPath} tidak ditemukan!`);
    }

    const rawData = fs.readFileSync(datasetPath, 'utf-8');
    const cases = JSON.parse(rawData);

    console.log(`📦 Membaca ${cases.length} kasus dari dataset.json...`);

    // Hapus koleksi lama agar bersih dan terstandarisasi
    console.log("🗑️ Membersihkan data kasus lama...");
    await MedicalCase.deleteMany({});

    // Masukkan data baru
    console.log("🚀 Menyimpan 41 kasus baru ke database...");
    const result = await MedicalCase.insertMany(cases);

    // Hitung ringkasan kategori
    const summary = {};
    for (const item of result) {
      summary[item.kategori_lesi] = (summary[item.kategori_lesi] || 0) + 1;
    }

    console.log("==================================================");
    console.log(`✅ BERHASIL SEEDING: Total ${result.length} kasus berhasil disimpan!`);
    console.log("📊 Rincian Kategori:");
    for (const [kategori, count] of Object.entries(summary)) {
      console.log(`   - ${kategori}: ${count} kasus`);
    }
    console.log("==================================================");

  } catch (err) {
    console.error("❌ Gagal seeding database:", err);
  } finally {
    await mongoose.disconnect();
    console.log("👋 Koneksi MongoDB ditutup.");
  }
}

seedDatabase();

