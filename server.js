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
const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

// ==========================================================
// 1. KONEKSI DATABASE
// ==========================================================
mongoose.connect(process.env.MONGO_URI) 
  .then(() => console.log('✅ MongoDB Connected (Siap Tempur!)'))
  .catch(err => console.log('❌ DB Error:', err));

// ==========================================================
// 2. SCHEMAS (STRUKTUR DATA)
// ==========================================================

// A. MASTER DATA: ITEM (Kamus Alat & Barang)
const ItemSchema = new mongoose.Schema({
    itemId: { type: String, required: true, unique: true }, // e.g., "Sonde Half"
    displayName: String,    // "Sonde Half (Standard)"
    description: String,    // "Alat diagnostik utama..."
    icon: String,           // "rbxassetid://..."
    category: { type: String, default: "General" }, 
    price: { type: Number, default: 0 },
    isBuyable: { type: Boolean, default: true }, // Muncul di Shop?
    rarity: { type: String, default: "Common" }
});

// B. MASTER DATA: ACHIEVEMENT (Pencapaian)
const AchievementSchema = new mongoose.Schema({
    achieveId: { type: String, unique: true }, 
    title: String,        
    description: String,  
    targetCount: Number,  
    rewardGold: Number,   
    rewardXP: Number      
});

// C. MASTER DATA: NPC PRESET (Tampilan Visual Pasien)
const NpcPresetSchema = new mongoose.Schema({
    presetId: String,       // "Casual_Male_1"
    gender: String,         // "Male" / "Female"
    shirtId: String,        // Roblox Asset ID
    pantsId: String,
    faceId: String,
    hairId: String,
    accessoryId: String     
});

// D. MEDICAL CASE (Soal Ujian & Skenario)
const MedicalCaseSchema = new mongoose.Schema({
    caseId: { type: String, unique: true }, 
    namaPenyakit: String, 
    kategori: { type: String, default: "General Dentistry" }, 
    tingkatKesulitan: { type: String, enum: ['Easy', 'Medium', 'Hard'], default: 'Easy' },
    
    // Constraint Demografi (Agar Randomizer tidak ngawur)
    demographics: {
        gender: { type: String, enum: ['Male', 'Female', 'Any'], default: 'Any' },
        minAge: { type: Number, default: 17 },
        maxAge: { type: Number, default: 60 },
        isPregnant: { type: Boolean, default: false }
    },

    // Aset & Skenario
    skenarioAI: String, 
    assets: {
        intraoral: String,   
        radiograf: String    
    },
    
    // Hasil Pemeriksaan Fisik (Apa yang muncul saat diklik)
    pemeriksaanFisik: {
        sonde: { type: String, default: "Normal" },    
        perkusi: { type: String, default: "Negatif (-)" },  
        palpasi: { type: String, default: "Negatif (-)" },  
        thermal: { type: String, default: "Normal" },  
        mobilitas: { type: String, default: "Grade 0" } 
    },

    // --- OSCE CHECKLIST (Sistem Penilaian) ---
    anamnesisChecklist: [String], // ["lokasi", "durasi"]
    pemeriksaanChecklist: [String], // ["sonde", "thermal"]
    kontraIndikasi: [String], // ["pencabutan"] (Hal yang dilarang)
    
    diagnosisBenar: String,       
    diagnosisMirip: [String],     
    planningBenar: [String],      
    alatWajib: [String], // Syarat alat di Tray

    rewards: {
        xp: { type: Number, default: 50 },
        gold: { type: Number, default: 100 }
    }
});

// E. USER DATA
const UserSchema = new mongoose.Schema({
    userId: { type: String, required: true, unique: true }, 
    username: String,
    robloxId: { type: String, default: null }, 
    robloxUsername: String,
    xp: { type: Number, default: 0 },
    level: { type: Number, default: 1 },
    gold: { type: Number, default: 1000 },
    
    // Inventory hanya simpan ID, detail ambil dari Master Item
    inventory: [{ 
        itemId: String, 
        obtainedAt: { type: Date, default: Date.now } 
    }],
    
    // Progress Achievement
    achievements: [{ achieveId: String, progress: Number, completed: Boolean }],
    
    // Session Data Sementara (Untuk Profil Pasien saat ini)
    currentSession: {
        patientProfile: Object, // {name: "Budi", age: 25...}
        startTime: Date
    },

    // Chat History (Auto-Pruning via $slice)
    chatHistory: [{ source: String, role: String, parts: [{ text: String }], timestamp: Date }]
});

const WhitelistSchema = new mongoose.Schema({
    robloxId: { type: String, required: true, unique: true },
    addedBy: String
});

// REGISTER MODELS
const User = mongoose.model('User', UserSchema);
const Item = mongoose.model('Item', ItemSchema);
const Achievement = mongoose.model('Achievement', AchievementSchema);
const NpcPreset = mongoose.model('NpcPreset', NpcPresetSchema);
const MedicalCase = mongoose.model('MedicalCase', MedicalCaseSchema);
const Whitelist = mongoose.model('Whitelist', WhitelistSchema);

// ==========================================================
// 3. LOGIC HELPER (RANDOMIZER ENGINE)
// ==========================================================

const NAMES = {
    Male: ["Budi", "Agus", "Slamet", "Joko", "Rudi", "Eko", "Bambang", "Fajar", "Dedi", "Hendra"],
    Female: ["Siti", "Sri", "Lestari", "Wati", "Rina", "Ani", "Dewi", "Putri", "Ratna", "Indah"]
};

async function generatePatientProfile(medicalCase) {
    // 1. Tentukan Gender berdasarkan Constraint Kasus
    let gender = medicalCase.demographics.gender;
    if (gender === 'Any') {
        gender = Math.random() < 0.5 ? 'Male' : 'Female';
    }

    // 2. Tentukan Umur (Random di range)
    const min = medicalCase.demographics.minAge;
    const max = medicalCase.demographics.maxAge;
    const age = Math.floor(Math.random() * (max - min + 1)) + min;

    // 3. Tentukan Nama
    const nameList = NAMES[gender];
    const name = nameList[Math.floor(Math.random() * nameList.length)];

    // 4. Cari Visual NPC yang cocok dari DB
    const visualPreset = await NpcPreset.aggregate([
        { $match: { gender: gender } },
        { $sample: { size: 1 } } 
    ]);

    return {
        name,
        age,
        gender,
        isPregnant: medicalCase.demographics.isPregnant,
        visual: visualPreset[0] || null // Data buat Roblox (ShirtID dll)
    };
}

// AUTH MIDDLEWARE
const API_SECRET = process.env.API_SECRET;
const checkAuth = (req, res, next) => {
    if (req.headers['authorization'] !== API_SECRET) return res.status(403).json({ error: "Access Denied" });
    next();
};

// ==========================================================
// 4. API ROUTES (ENDPOINTS)
// ==========================================================

// --- [A] LOGIN & DATA LOAD ---
app.get('/api/roblox-login/:robloxId', checkAuth, async (req, res) => {
    try {
        const user = await User.findOne({ robloxId: req.params.robloxId });
        
        if (user) {
            // MERGE: Inventory User + Master Data Item
            const allItems = await Item.find({});
            const itemMap = {};
            allItems.forEach(i => itemMap[i.itemId] = i);

            const enrichedInventory = user.inventory.map(inv => {
                const detail = itemMap[inv.itemId];
                return {
                    itemId: inv.itemId,
                    itemName: detail ? detail.displayName : inv.itemId,
                    icon: detail ? detail.icon : "rbxassetid://0",
                    description: detail ? detail.description : "",
                    category: detail ? detail.category : ""
                };
            });

            res.json({ 
                authorized: true, 
                username: user.username, 
                gold: user.gold, 
                xp: user.xp, 
                inventory: enrichedInventory 
            });
        } else {
            const wl = await Whitelist.findOne({ robloxId: req.params.robloxId });
            res.json({ authorized: !!wl, username: wl ? "Guest" : null, inventory: [] });
        }
    } catch (err) { res.status(500).json({ error: "Server Error" }); }
});

// --- [B] GAMEPLAY LOOP (RANDOM CASE) ---
app.get('/api/medical-case/start-session', checkAuth, async (req, res) => {
    try {
        // 1. Ambil User (dari header auth/robloxId nanti, disini kita simplifikasi ambil dr body/query kalau ada, atau random)
        // (Di production, kirim robloxId di body request)
        
        // 1. Ambil Kasus Acak
        const count = await MedicalCase.countDocuments();
        if (count === 0) return res.json({ error: "Belum ada kasus di DB" });
        
        const random = Math.floor(Math.random() * count);
        const selectedCase = await MedicalCase.findOne().skip(random);

        // 2. Generate Profil Pasien (Logic Randomizer)
        const patientProfile = await generatePatientProfile(selectedCase);

        // 3. Simpan Profil ke User Session (Opsional, jika ada robloxId di request body)
        // await User.findOneAndUpdate(...) 

        res.json({
            caseData: selectedCase,
            patient: patientProfile
        });

    } catch (err) { res.status(500).json({ error: err.message }); }
});

// --- [C] AI CHAT (WITH PROMPT ENGINEERING & AUTO DELETE) ---
app.post('/api/chat-ai', checkAuth, async (req, res) => {
    const { robloxId, pesan, konteksPenyakit, patientProfile } = req.body; 
    // patientProfile dikirim balik oleh Roblox, atau ambil dari session DB

    try {
        // 1. Log User Chat (Simpan max 20 pesan terakhir)
        if(robloxId) {
            await User.findOneAndUpdate({ robloxId }, {
                $push: { 
                    chatHistory: {
                        $each: [{ source: 'roblox', role: 'user', parts: [{ text: pesan }], timestamp: new Date() }],
                        $slice: -20 
                    }
                }
            });
        }

        // 2. Rakit Prompt Dinamis
const namaPasien = patientProfile?.name || "Pasien";
        const umurPasien = patientProfile?.age || "25";
        const genderPasien = patientProfile?.gender || "Male"; // Tambahkan gender biar AI sadar

        // [FIX PROMPT] LEBIH TEGAS & TERSTRUKTUR
        const systemPrompt = `
        ROLEPLAY INSTRUCTION:
        Kamu adalah pasien poli gigi bernama ${namaPasien} (${genderPasien}, ${umurPasien} tahun).
        Kamu sedang berbicara dengan Dokter Gigi (User).
        
        KONDISI MEDIS KAMU:
        "${konteksPenyakit}"
        
        ATURAN PENTING:
        1. Jawablah secara natural, pendek (max 2 kalimat), dan seperti orang awam yang sedang sakit.
        2. JANGAN gunakan istilah medis canggih (kecuali kamu diceritakan sebagai dokter).
        3. [WAJIB] Jika jawabanmu mengandung informasi tentang:
           - Nama -> Tambahkan tag [NAMA:${namaPasien}] di akhir.
           - Umur -> Tambahkan tag [UMUR:${umurPasien}] di akhir.
           - Keluhan Utama/Rasa Sakit -> Tambahkan tag [KELUHAN:...] di akhir.
           - Lokasi Gigi -> Tambahkan tag [LOKASI:...] di akhir.
           - Durasi Sakit -> Tambahkan tag [DURASI:...] di akhir.
           - Pemicu Sakit -> Tambahkan tag [RIWAYAT:...] di akhir.
        
        CONTOH:
        Dokter: "Namanya siapa?"
        Kamu: "Saya Budi dok. [NAMA:Budi]"
        
        Dokter: "Apa yang dirasa?"
        Kamu: "Gigi bawah kanan saya nyut-nyutan banget kalau kena air es. [KELUHAN:Gigi ngilu][LOKASI:Rahang Bawah Kanan][RIWAYAT:Sakit kena dingin]"
        `;

        const result = await model.generateContent(systemPrompt + "\nDokter bertanya: " + pesan);
        const responseAI = result.response.text();

        // 3. Log AI Chat (Simpan max 20 pesan terakhir)
        if(robloxId) {
            await User.findOneAndUpdate({ robloxId }, {
                $push: { 
                    chatHistory: {
                        $each: [{ source: 'roblox', role: 'model', parts: [{ text: responseAI }], timestamp: new Date() }],
                        $slice: -20 
                    }
                }
            });
        }
        
        res.json({ jawaban: responseAI });

    } catch (error) { res.status(500).json({ jawaban: "Maaf dok... (Sakit banget/Server Error)" }); }
});

// --- [D] SHOP & ECONOMY ---
app.get('/api/shop/items', checkAuth, async (req, res) => {
    try {
        const items = await Item.find({ isBuyable: true });
        res.json(items);
    } catch (err) { res.status(500).json({ error: "Error Shop" }); }
});

app.post('/api/buy-item', checkAuth, async (req, res) => {
    const { robloxId, itemId } = req.body;
    try {
        const user = await User.findOne({ robloxId });
        const item = await Item.findOne({ itemId });

        if (!user || !item) return res.json({ success: false, msg: "Data not found" });
        if (user.gold < item.price) return res.json({ success: false, msg: "Gold kurang" });
        if (user.inventory.some(i => i.itemId === itemId)) return res.json({ success: false, msg: "Sudah punya" });

        user.gold -= item.price;
        user.inventory.push({ itemId });
        await user.save();

        res.json({ success: true, newGold: user.gold, itemDetails: item });
    } catch (err) { res.status(500).json({ success: false, msg: "Error Transaksi" }); }
});

app.post('/api/update-progress', checkAuth, async (req, res) => {
    const { robloxId, goldGained, xpGained } = req.body;
    await User.findOneAndUpdate({ robloxId }, { $inc: { gold: goldGained, xp: xpGained } });
    res.json({ success: true });
});

// --- [E] ADMIN & SEEDING (INPUT DATA VIA POSTMAN) ---
app.post('/api/items', checkAuth, async (req, res) => {
    await Item.create(req.body); res.json({ msg: "Item Saved" });
});
app.post('/api/medical-case', checkAuth, async (req, res) => {
    await MedicalCase.create(req.body); res.json({ msg: "Case Saved" });
});
app.post('/api/achievements', checkAuth, async (req, res) => {
    await Achievement.create(req.body); res.json({ msg: "Achievement Saved" });
});
app.post('/api/npc-presets', checkAuth, async (req, res) => {
    await NpcPreset.create(req.body); res.json({ msg: "NPC Preset Saved" });
});
app.post('/api/whitelist', checkAuth, async (req, res) => {
    await Whitelist.create(req.body); res.json({ msg: "Whitelisted" });
});

// START SERVER
app.listen(PORT, () => console.log(`🚀 Server Dental Simulator LIVE on port ${PORT}`));