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
// ⚠️ PERUBAHAN PENTING UNTUK DOCKER:
// Hostname ganti jadi 'mongo' (sesuai nama service di docker-compose)
// ==========================================================
mongoose.connect(process.env.MONGO_URI) 
  .then(() => console.log('✅ MongoDB Connected (Docker Internal)'))
  .catch(err => console.log('❌ DB Error:', err));

// --- SCHEMA & MODEL (Sama kayak sebelumnya) ---
const UserSchema = new mongoose.Schema({
    userId: { type: String, required: true, unique: true },
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

const MedicalCaseSchema = new mongoose.Schema({
    namaPenyakit: String,
    gejala: String,
    solusi: String
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

// ================= ROUTES =================

// 1. ENDPOINT DISCORD: Connect Akun
// (Bot Discord nembak kesini buat nyari user berdasarkan ID Roblox)
// Kamu bisa pakai endpoint custom atau langsung update DB dari Bot Discord kalau botnya jalan di server yang sama.
// Tapi karena Bot Discord kamu jalan terpisah (mungkin), kita siapin API buat update User.

app.post('/api/whitelist', checkAuth, async (req, res) => {
    // Endpoint legacy whitelist (kalau mau manual tanpa discord connect)
    const { robloxId, discordAdmin } = req.body;
    try {
        await Whitelist.create({ robloxId, addedBy: discordAdmin });
        res.json({ success: true });
    } catch (err) { res.json({ success: false }); }
});

// 2. ENDPOINT ROBLOX: Login / Cek Whitelist
app.get('/api/roblox-login/:robloxId', checkAuth, async (req, res) => {
    const { robloxId } = req.params;
    
    // Cari di tabel User (yang connect dari Discord)
    const user = await User.findOne({ robloxId: robloxId });
    
    if (user) {
        res.json({ 
            authorized: true, 
            username: user.username, 
            gold: user.gold, 
            xp: user.xp,
            inventory: user.inventory 
        });
    } else {
        // Cek whitelist manual (backup)
        const manualWhitelist = await Whitelist.findOne({ robloxId: robloxId });
        if (manualWhitelist) {
             res.json({ authorized: true, username: "Guest", gold: 0, xp: 0, inventory: [] });
        } else {
             res.json({ authorized: false });
        }
    }
});

// 3. ENDPOINT ROBLOX: Chat AI
app.post('/api/chat-ai', checkAuth, async (req, res) => {
    const { robloxId, pesan, konteksPenyakit } = req.body;
    try {
        // Simpan Chat User ke DB
        if(robloxId) {
             await User.findOneAndUpdate({ robloxId }, {
                 $push: { chatHistory: { source: 'roblox', role: 'user', parts: [{ text: pesan }] } }
             });
        }

        const systemPrompt = `Kamu pasien gigi bernama Budiono. Penyakitmu: ${konteksPenyakit}. Jawab singkat dan lucu.`;
        const result = await model.generateContent(systemPrompt + "\nUser: " + pesan);
        const responseAI = result.response.text();

        // Simpan Chat AI ke DB
        if(robloxId) {
             await User.findOneAndUpdate({ robloxId }, {
                 $push: { chatHistory: { source: 'roblox', role: 'model', parts: [{ text: responseAI }] } }
             });
        }
        
        res.json({ jawaban: responseAI });
    } catch (error) {
        res.status(500).json({ jawaban: "..." });
    }
});

// 4. ENDPOINT UPDATE PROGRESS (Roblox lapor hasil praktikum)
app.post('/api/update-progress', checkAuth, async (req, res) => {
    const { robloxId, goldGained, xpGained } = req.body;
    await User.findOneAndUpdate({ robloxId }, { $inc: { gold: goldGained, xp: xpGained } });
    res.json({ success: true });
});

app.listen(PORT, () => console.log(`🚀 Server jalan di port ${PORT}`));