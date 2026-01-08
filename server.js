require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const { GoogleGenerativeAI } = require("@google/generative-ai");

const app = express();
const PORT = process.env.PORT || 4321;

app.use(bodyParser.json());

// Setup Gemini AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-pro" });

// ==========================================================
// KONEKSI DATABASE
// ==========================================================
mongoose.connect(process.env.MONGO_URI) 
  .then(() => console.log('✅ MongoDB Connected (Docker Internal)'))
  .catch(err => console.log('❌ DB Error:', err));

// ==========================================================
// SCHEMAS & MODELS
// ==========================================================

const UserSchema = new mongoose.Schema({
    userId: { type: String, required: true, unique: true }, // Discord ID
    username: String,
    robloxId: { type: String, default: null }, 
    robloxUsername: String,
    xp: { type: Number, default: 0 },
    level: { type: Number, default: 1 },
    gold: { type: Number, default: 1000 },
    inventory: [{ itemId: String, itemName: String, obtainedAt: { type: Date, default: Date.now } }],
    chatHistory: [{ source: String, role: String, parts: [{ text: String }], timestamp: Date }]
});

const WhitelistSchema = new mongoose.Schema({
    robloxId: { type: String, required: true, unique: true },
    addedBy: String,
    date: { type: Date, default: Date.now }
});

// ✅ SCHEMA BARU: MEDICAL CASE (Mendukung Aset Gambar)
const MedicalCaseSchema = new mongoose.Schema({
    // --- IDENTITAS KASUS ---
    caseId: { type: String, unique: true }, 
    namaPenyakit: String, 
    tingkatKesulitan: { type: String, enum: ['Easy', 'Medium', 'Hard'], default: 'Easy' },
    
    // [BARU] Kategori Penyakit (Untuk label di map/rekam medis)
    kategori: { type: String, default: "General Dentistry" }, // Contoh: "Konservasi Gigi", "Bedah Mulut"
    
    // [BARU] Skor Rewards (XP & Gold yang didapat jika lulus)
    rewards: {
        xp: { type: Number, default: 50 },
        gold: { type: Number, default: 100 }
    },

    // --- LOGIKA GAMEPLAY ---
    // [BARU] Alat Wajib (Array ID alat di Roblox)
    // User GA BISA periksa kalau gak punya alat ini di inventory
    alatWajib: [String], // Contoh: ["kaca_mulut", "sonde_half"]

    // --- AI & ASET ---
    skenarioAI: String, 
    assets: {
        intraoral: String,
        radiograf: String,
        wajahPasien: String
    },
    pemeriksaanFisik: {
        sonde: String,    
        perkusi: String,  
        palpasi: String,  
        thermal: String,  
        mobilitas: String 
    },
    kunciDiagnosa: [String], 
    rencanaPerawatan: String 
});

const User = mongoose.model('User', UserSchema);
const Whitelist = mongoose.model('Whitelist', WhitelistSchema);
const MedicalCase = mongoose.model('MedicalCase', MedicalCaseSchema);

// Auth Middleware
const API_SECRET = process.env.API_SECRET;
const checkAuth = (req, res, next) => {
    if (req.headers['authorization'] !== API_SECRET) return res.status(403).json({ error: "Access Denied" });
    next();
};

// ==========================================================
// ROUTES (API ENDPOINTS)
// ==========================================================

// 1. ROBLOX LOGIN
app.get('/api/roblox-login/:robloxId', checkAuth, async (req, res) => {
    const { robloxId } = req.params;
    const user = await User.findOne({ robloxId: robloxId });
    
    if (user) {
        res.json({ authorized: true, username: user.username, gold: user.gold, xp: user.xp, inventory: user.inventory });
    } else {
        const manualWhitelist = await Whitelist.findOne({ robloxId: robloxId });
        if (manualWhitelist) {
             res.json({ authorized: true, username: "Guest", gold: 0, xp: 0, inventory: [] });
        } else {
             res.json({ authorized: false });
        }
    }
});

// 2. CHAT AI (DENGAN PROMPT ENGINEERING UNTUK TABLET)
app.post('/api/chat-ai', checkAuth, async (req, res) => {
    const { robloxId, pesan, konteksPenyakit } = req.body;
    try {
        // Log Chat User
        if(robloxId) {
            await User.findOneAndUpdate({ robloxId }, {
                $push: { chatHistory: { source: 'roblox', role: 'user', parts: [{ text: pesan }] } }
            });
        }

        // 🔥 LOGIKA BARU: Prompt Engineering
        // Ini memaksa AI menyisipkan tag [KELUHAN:...] agar Tablet Roblox bisa membacanya
        const systemPrompt = `
        Berperanlah sebagai pasien gigi bernama Budiono (Umur 25 tahun).
        Kondisi Medis/Skenario: ${konteksPenyakit || "Sakit gigi umum"}.

        INSTRUKSI KHUSUS (WAJIB DIPATUHI):
        1. Jawablah dengan natural, sopan, tapi terlihat kesakitan.
        2. SISIPKAN "HIDDEN TAGS" di dalam kalimatmu agar Tablet Dokter bisa mencatatnya.
        3. Jangan sebutkan tag jika informasinya belum ditanyakan/relevan.

        FORMAT TAG YANG TERSEDIA:
        - [NAMA:Budiono] -> Jika tanya nama.
        - [UMUR:25] -> Jika tanya umur.
        - [KELUHAN:...] -> Isi dengan keluhan utamamu.
        - [LOKASI:...] -> Lokasi sakit.
        - [DURASI:...] -> Lama sakit.
        - [RIWAYAT:...] -> Riwayat penyakit.

        CONTOH:
        Dokter: "Halo, ada keluhan apa?"
        Kamu: "Aduh dok, sakit banget ini [KELUHAN:Gigi geraham bawah nyut-nyutan] kalau kena air dingin."
        `;

        const result = await model.generateContent(systemPrompt + "\nDokter bertanya: " + pesan);
        const responseAI = result.response.text();

        // Log Chat AI
        if(robloxId) {
            await User.findOneAndUpdate({ robloxId }, {
                $push: { chatHistory: { source: 'roblox', role: 'model', parts: [{ text: responseAI }] } }
            });
        }
        
        res.json({ jawaban: responseAI });
    } catch (error) {
        console.error("AI Error:", error);
        res.status(500).json({ jawaban: "Aduh dok... (Maaf, saya pusing/server error)" });
    }
});

// 3. GET RANDOM CASE (UNTUK START GAME ROBLOX)
app.get('/api/medical-case/random', checkAuth, async (req, res) => {
    try {
        const count = await MedicalCase.countDocuments();
        if (count === 0) return res.json({ namaPenyakit: "Default Case", skenarioAI: "Sakit gigi biasa", assets: {} });

        const random = Math.floor(Math.random() * count);
        const result = await MedicalCase.findOne().skip(random);
        
        res.json(result); // Kirim seluruh data (termasuk aset & hasil tes fisik)
    } catch (err) {
        res.status(500).json({ error: "Gagal ambil kasus" });
    }
});

// 4. ADD NEW CASE (UNTUK KAMU INPUT DATA BARU VIA POSTMAN/DISCORD)
app.post('/api/medical-case', checkAuth, async (req, res) => {
    try {
        await MedicalCase.create(req.body);
        res.json({ msg: "Kasus berhasil disimpan ke Database!" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 5. UPDATE PROGRESS & WHITELIST
app.post('/api/update-progress', checkAuth, async (req, res) => {
    const { robloxId, goldGained, xpGained } = req.body;
    await User.findOneAndUpdate({ robloxId }, { $inc: { gold: goldGained, xp: xpGained } });
    res.json({ success: true });
});

app.post('/api/whitelist', checkAuth, async (req, res) => {
    const { robloxId, discordAdmin } = req.body;
    try {
        await Whitelist.create({ robloxId, addedBy: discordAdmin });
        res.json({ success: true });
    } catch (err) { res.json({ success: false }); }
});

app.listen(PORT, () => console.log(`🚀 Server Dental Sim jalan di port ${PORT}`));