require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const { GoogleGenerativeAI } = require("@google/generative-ai");
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 4321;

app.use(bodyParser.json({ limit: '10mb' }));

// Setup Gemini AI (Pure 100% Gemini 2.5 Flash via v1beta)
const geminiApiKey = process.env.API_GEMINI || process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(geminiApiKey);
const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" }, { apiVersion: "v1beta" });

// ==========================================================
// 1. KONEKSI DATABASE
// ==========================================================
mongoose.connect(process.env.MONGO_URI)
    .then(() => console.log('✅ MongoDB Connected (Siap Tempur!)'))
    .catch(err => console.log('❌ DB Error:', err));

// ==========================================================
// 2. SCHEMAS (STRUKTUR DATA STANDAR BARU)
// ==========================================================

// A. MASTER DATA: ITEM (Kamus Alat & Barang)
const ItemSchema = new mongoose.Schema({
    itemId: { type: String, required: true, unique: true },
    displayName: String,
    description: String,
    icon: String,
    category: { type: String, default: "General" },
    price: { type: Number, default: 0 },
    isBuyable: { type: Boolean, default: true },
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

// D. MEDICAL CASE (STANDAR BARU DATASET 41 KASUS)
const MedicalCaseSchema = new mongoose.Schema({
    id: { type: String, required: true, unique: true }, // e.g. "case_001"
    kode_kasus: { type: String, required: true, index: true }, // "ABS-01"
    kategori_lesi: { type: String, required: true, index: true }, // "abses_periapikal" | "granuloma_periapikal" | "kista_radikuler"
    diagnosis_benar: { type: String, required: true }, // "Abses Periapikal"
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

// E. PRE-TEST TELEMETRI & LOG WAKTU ITEM
const PretestTelemetrySchema = new mongoose.Schema({
    playerUserId: { type: Number, required: true, index: true },
    robloxUsername: String,
    sessionId: String,
    caseId: { type: String, required: true },
    kodeKasus: String,
    kategori: String,
    jawabanPemain: String,
    kunciJawaban: String,
    isCorrect: Boolean,
    durasiDetik: Number,
    nomorUrut: Number,
    timestamp: { type: Date, default: Date.now }
});

// E2. POST-TEST TELEMETRI & LOG WAKTU ITEM
const PosttestTelemetrySchema = new mongoose.Schema({
    playerUserId: { type: Number, required: true, index: true },
    robloxUsername: String,
    sessionId: String,
    caseId: { type: String, required: true },
    kodeKasus: String,
    kategori: String,
    jawabanPemain: String,
    kunciJawaban: String,
    isCorrect: Boolean,
    durasiDetik: Number,
    nomorUrut: Number,
    timestamp: { type: Date, default: Date.now }
});

// F. PRE-TEST / POST-TEST SESSION TRACKER (EXCLUSION LIST)
const PretestSessionSchema = new mongoose.Schema({
    playerUserId: { type: Number, required: true, unique: true },
    robloxUsername: String,
    usedPretestCaseIds: [String],
    usedPosttestCaseIds: [String],
    lastUpdated: { type: Date, default: Date.now }
});

// G. USER DATA
const UserSchema = new mongoose.Schema({
    userId: { type: String, required: true, unique: true },
    username: String,
    robloxId: { type: String, default: null },
    robloxUsername: String,
    xp: { type: Number, default: 0 },
    level: { type: Number, default: 1 },
    gold: { type: Number, default: 1000 },
    inventory: [{
        itemId: String,
        obtainedAt: { type: Date, default: Date.now }
    }],
    achievements: [{ achieveId: String, progress: Number, completed: Boolean }],
    currentSession: {
        patientProfile: Object,
        startTime: Date
    },
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
const PretestTelemetry = mongoose.model('PretestTelemetry', PretestTelemetrySchema);
const PosttestTelemetry = mongoose.model('PosttestTelemetry', PosttestTelemetrySchema);
const PretestSession = mongoose.model('PretestSession', PretestSessionSchema);

// H. OSCE SIMULATION LOG & BLOCK RANDOMIZATION TRACKER
const OSCELogSchema = new mongoose.Schema({
    playerUserId: { type: Number, required: true, index: true },
    robloxUsername: String,
    caseNumber: Number,
    blockIndex: Number,
    category: String,
    caseId: String,
    kodeKasus: String,
    elemenGigi: String,
    diagnosisTebakan: String,
    diagnosisBenar: String,
    isDiagnosisCorrect: Boolean,
    rencanaPerawatan: String,
    grade: String,
    goldEarned: Number,
    xpEarned: Number,
    durasiDetik: Number,
    timestamp: { type: Date, default: Date.now }
});

const OSCESessionSchema = new mongoose.Schema({
    playerUserId: { type: Number, required: true, unique: true },
    robloxUsername: String,
    currentBlockCategories: [String],
    usedCaseIds: [String],
    caseCount: { type: Number, default: 0 },
    activeCase: Object,
    activePatient: Object,
    caseStartTime: Date,
    lastUpdated: { type: Date, default: Date.now }
});

const OSCELog = mongoose.model('OSCELog', OSCELogSchema);
const OSCESession = mongoose.model('OSCESession', OSCESessionSchema);

// ==========================================================
// 3. LOGIC HELPER: SAMPLING & RANDOMIZER ENGINE
// ==========================================================

const NAMES = {
    Male: ["Budi", "Agus", "Slamet", "Joko", "Rudi", "Eko", "Bambang", "Fajar", "Dedi", "Hendra"],
    Female: ["Siti", "Sri", "Lestari", "Wati", "Rina", "Ani", "Dewi", "Putri", "Ratna", "Indah"]
};

// Fisher-Yates Shuffle
function shuffleArray(array) {
    const arr = [...array];
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
}

// Sampling Without Replacement
function sampleWithoutReplacement(array, count) {
    const shuffled = shuffleArray(array);
    return shuffled.slice(0, Math.min(count, shuffled.length));
}

// Generator Stratified Pre-Test 9 Soal (3 Abses, 3 Granuloma, 3 Kista)
async function generateStratifiedPretest(playerUserId, robloxUsername) {
    // 1. Ambil riwayat kasus yang sudah pernah diambil user
    const existingSession = await PretestSession.findOne({ playerUserId });
    const usedIds = existingSession?.usedPretestCaseIds || [];

    // 2. Query pool per kategori (exclude ID yang sudah dipakai jika memungkinkan)
    let [absesCases, granuCases, kistaCases] = await Promise.all([
        MedicalCase.find({ kategori_lesi: 'abses_periapikal', id: { $nin: usedIds } }),
        MedicalCase.find({ kategori_lesi: 'granuloma_periapikal', id: { $nin: usedIds } }),
        MedicalCase.find({ kategori_lesi: 'kista_radikuler', id: { $nin: usedIds } })
    ]);

    // Fallback jika kuota kasus non-used kurang dari 3
    if (absesCases.length < 3) absesCases = await MedicalCase.find({ kategori_lesi: 'abses_periapikal' });
    if (granuCases.length < 3) granuCases = await MedicalCase.find({ kategori_lesi: 'granuloma_periapikal' });
    if (kistaCases.length < 3) kistaCases = await MedicalCase.find({ kategori_lesi: 'kista_radikuler' });

    // 3. Tarik acak 3 kasus per kategori tanpa pengembalian
    const selectedAbses = sampleWithoutReplacement(absesCases, 3);
    const selectedGranu = sampleWithoutReplacement(granuCases, 3);
    const selectedKista = sampleWithoutReplacement(kistaCases, 3);

    // 4. Gabungkan 9 soal lalu kocok ulang (shuffle) agar urutan kategori acak
    const combined9 = shuffleArray([...selectedAbses, ...selectedGranu, ...selectedKista]);

    // 5. Simpan/tandai ID kasus yang terpilih agar tidak muncul di Post-test
    const selectedIds = combined9.map(c => c.id);
    await PretestSession.findOneAndUpdate(
        { playerUserId },
        {
            $set: {
                robloxUsername: robloxUsername || "Player",
                usedPretestCaseIds: selectedIds,
                lastUpdated: new Date()
            }
        },
        { upsert: true, new: true }
    );

    return combined9;
}

async function generatePatientProfile(medicalCase) {
    let gender = medicalCase?.profil_pasien?.jenis_kelamin || 'Male';
    const age = medicalCase?.profil_pasien?.usia || 25;
    const name = medicalCase?.profil_pasien?.nama_samaran || (gender === 'Female' ? 'Siti' : 'Budi');

    const visualPreset = await NpcPreset.aggregate([
        { $match: { gender: gender } },
        { $sample: { size: 1 } }
    ]);

    return {
        name,
        age,
        gender,
        isPregnant: false,
        visual: visualPreset[0] || null
    };
}

// AUTH MIDDLEWARE
const API_SECRET = process.env.API_SECRET;
const checkAuth = (req, res, next) => {
    const authHeader = req.headers['authorization'] || req.headers['x-api-key'];
    if (authHeader !== API_SECRET) return res.status(403).json({ error: "Access Denied" });
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

// --- [B] PRE-TEST STRATIFIED RANDOM SAMPLING & TELEMETRI ---

// 1. Memulai Sesi Pre-Test (Ambil 9 Kasus Stratified)
app.post('/api/pretest/start-session', checkAuth, async (req, res) => {
    try {
        const { playerUserId, robloxUsername } = req.body;
        if (!playerUserId) return res.status(400).json({ error: "playerUserId diperlukan" });

        const cases9 = await generateStratifiedPretest(Number(playerUserId), robloxUsername);

        // Bentuk payload yang dikirim ke Roblox
        const formattedCases = cases9.map((c, index) => ({
            id: c.id,
            nomorUrut: index + 1,
            kode_kasus: c.kode_kasus,
            kategori_lesi: c.kategori_lesi,
            elemen_gigi: c.elemen_gigi,
            diagnosis_benar: c.diagnosis_benar, // disimpan di server lua / verifikasi
            vignette_tes: c.vignette_tes,
            opsi_diagnosis: c.opsi_diagnosis || ["Abses Periapikal", "Granuloma Periapikal", "Kista Radikuler"],
            assets: c.assets,
            roblox_assets: c.roblox_assets || { radiograf_asset_id: "", intraoral_asset_id: "" }
        }));

        res.json({
            success: true,
            totalSoal: formattedCases.length,
            cases: formattedCases
        });
    } catch (err) {
        console.error("❌ Error start-pretest:", err);
        res.status(500).json({ error: err.message });
    }
});

// 2. Telemetri Respon Waktu Sisi Klien per Butir Soal
app.post('/api/pretest/telemetry', checkAuth, async (req, res) => {
    try {
        const {
            playerUserId,
            robloxUsername,
            sessionId,
            caseId,
            kodeKasus,
            kategori,
            jawabanPemain,
            kunciJawaban,
            isCorrect,
            durasiDetik,
            timestamp,
            nomorUrut
        } = req.body;

        const record = await PretestTelemetry.create({
            playerUserId: Number(playerUserId),
            robloxUsername: robloxUsername || "",
            sessionId: sessionId || "PRETEST_SESSION",
            caseId,
            kodeKasus,
            kategori,
            jawabanPemain,
            kunciJawaban,
            isCorrect: (isCorrect !== undefined) ? isCorrect : (jawabanPemain === kunciJawaban),
            durasiDetik: Number(durasiDetik),
            nomorUrut: Number(nomorUrut) || 1,
            timestamp: timestamp ? new Date(timestamp * 1000) : new Date()
        });

        console.log(`⏱️ [TELEMETRI PRE-TEST] User ${playerUserId} | Soal #${nomorUrut} (${kodeKasus}) | Waktu: ${durasiDetik}s | Tepat: ${record.isCorrect}`);

        res.json({ success: true, logId: record._id });
    } catch (err) {
        console.error("❌ Error simpan telemetri:", err);
        res.status(500).json({ error: err.message });
    }
});

// 3. Ambil Rekap Telemetri Player
app.get('/api/pretest/telemetry/:playerUserId', checkAuth, async (req, res) => {
    try {
        const logs = await PretestTelemetry.find({ playerUserId: Number(req.params.playerUserId) }).sort({ nomorUrut: 1 });
        res.json({ success: true, count: logs.length, logs });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// --- [B2] POST-TEST TELEMETRI & LOG WAKTU ITEM ---
app.post('/api/posttest/telemetry', checkAuth, async (req, res) => {
    try {
        const {
            playerUserId,
            robloxUsername,
            sessionId,
            caseId,
            kodeKasus,
            kategori,
            jawabanPemain,
            kunciJawaban,
            isCorrect,
            durasiDetik,
            timestamp,
            nomorUrut
        } = req.body;

        const record = await PosttestTelemetry.create({
            playerUserId: Number(playerUserId),
            robloxUsername: robloxUsername || "",
            sessionId: sessionId || "POSTTEST_SESSION",
            caseId,
            kodeKasus,
            kategori,
            jawabanPemain,
            kunciJawaban,
            isCorrect: (isCorrect !== undefined) ? isCorrect : (jawabanPemain === kunciJawaban),
            durasiDetik: Number(durasiDetik),
            nomorUrut: Number(nomorUrut) || 1,
            timestamp: timestamp ? new Date(timestamp * 1000) : new Date()
        });

        console.log(`🎯 [TELEMETRI POST-TEST] User ${playerUserId} | Soal #${nomorUrut} (${kodeKasus}) | Waktu: ${durasiDetik}s | Tepat: ${record.isCorrect}`);

        res.json({ success: true, logId: record._id });
    } catch (err) {
        console.error("❌ Error simpan telemetri posttest:", err);
        res.status(500).json({ error: err.message });
    }
});

// Ambil Rekap Telemetri Posttest Player
app.get('/api/posttest/telemetry/:playerUserId', checkAuth, async (req, res) => {
    try {
        const logs = await PosttestTelemetry.find({ playerUserId: Number(req.params.playerUserId) }).sort({ nomorUrut: 1 });
        res.json({ success: true, count: logs.length, logs });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Analisis Komparasi Pre-test vs Post-test (Effect Size & Gain)
app.get('/api/evaluation/compare/:playerUserId', checkAuth, async (req, res) => {
    try {
        const pId = Number(req.params.playerUserId);
        const preLogs = await PretestTelemetry.find({ playerUserId: pId }).sort({ nomorUrut: 1 });
        const postLogs = await PosttestTelemetry.find({ playerUserId: pId }).sort({ nomorUrut: 1 });

        const calcMetrics = (logs) => {
            if (!logs || logs.length === 0) return { count: 0, correct: 0, accuracyPct: 0, avgLatency: 0 };
            const correct = logs.filter(l => l.isCorrect).length;
            const totalTime = logs.reduce((acc, curr) => acc + (curr.durasiDetik || 0), 0);
            return {
                count: logs.length,
                correct,
                accuracyPct: Math.round((correct / logs.length) * 1000) / 10,
                avgLatency: Math.round((totalTime / logs.length) * 100) / 100
            };
        };

        const preMetrics = calcMetrics(preLogs);
        const postMetrics = calcMetrics(postLogs);

        const deltaAccuracy = postMetrics.accuracyPct - preMetrics.accuracyPct;
        const deltaLatency = Math.round((postMetrics.avgLatency - preMetrics.avgLatency) * 100) / 100;

        res.json({
            success: true,
            playerUserId: pId,
            pretest: { metrics: preMetrics, details: preLogs },
            posttest: { metrics: postMetrics, details: postLogs },
            comparison: {
                accuracyGainPct: deltaAccuracy,
                latencyDifferenceSec: deltaLatency,
                isAccuracyImproved: deltaAccuracy > 0,
                isFaster: deltaLatency < 0
            }
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// --- [C] OSCE SIMULATION LOOP (PERMUTED BLOCK RANDOMIZATION 3 KATEGORI) ---
app.get('/api/osce/next-case/:playerUserId', checkAuth, async (req, res) => {
    try {
        const playerUserId = Number(req.params.playerUserId);
        const robloxUsername = req.query.username || "Dokter";

        let session = await OSCESession.findOne({ playerUserId });
        if (!session) {
            session = new OSCESession({
                playerUserId,
                robloxUsername,
                currentBlockCategories: [],
                usedCaseIds: [],
                caseCount: 0
            });
        }

        // 1. Permuted Block: Jika kategori blok saat ini habis, acak urutan baru dari 3 kategori
        if (!session.currentBlockCategories || session.currentBlockCategories.length === 0) {
            const allCategories = ['abses_periapikal', 'granuloma_periapikal', 'kista_radikuler'];
            // Kocok acak urutan ke-3 kategori (Permuted Block)
            session.currentBlockCategories = shuffleArray(allCategories);
        }

        // 2. Ambil kategori berikutnya dari blok
        const targetCategory = session.currentBlockCategories.shift();

        // 3. Ambil kasus dari kategori tersebut (hindari kasus yang sudah pernah muncul)
        let candidates = await MedicalCase.find({
            kategori_lesi: targetCategory,
            id: { $nin: session.usedCaseIds }
        });

        // Jika semua kasus di kategori ini sudah pernah dipakai, reset filter kasus khusus kategori ini
        if (candidates.length === 0) {
            candidates = await MedicalCase.find({ kategori_lesi: targetCategory });
        }

        const selectedCase = candidates[Math.floor(Math.random() * candidates.length)];
        const patientProfile = await generatePatientProfile(selectedCase);

        session.caseCount += 1;
        session.usedCaseIds.push(selectedCase.id);
        session.activeCase = selectedCase;
        session.activePatient = patientProfile;
        session.caseStartTime = new Date();
        session.lastUpdated = new Date();
        await session.save();

        const blockNumber = Math.ceil(session.caseCount / 3);
        const positionInBlock = ((session.caseCount - 1) % 3) + 1;

        console.log(`🩺 [OSCE CASE] User ${playerUserId} | Kasus #${session.caseCount} (Blok ${blockNumber}, Urutan ${positionInBlock}/3) | Kategori: ${targetCategory} | Kasus: ${selectedCase.kode_kasus}`);

        res.json({
            success: true,
            caseNumber: session.caseCount,
            blockNumber,
            positionInBlock,
            category: targetCategory,
            caseData: {
                id: selectedCase.id,
                kodeKasus: selectedCase.kode_kasus,
                kategori: selectedCase.kategori_lesi,
                diagnosisBenar: selectedCase.diagnosis_benar,
                elemenGigi: selectedCase.elemen_gigi,
                skenarioAI: selectedCase.vignette_tes || selectedCase.anamnesis_ai?.keluhan_utama,
                systemPromptAI: selectedCase.anamnesis_ai?.system_prompt,
                assets: {
                    radiograf: selectedCase.roblox_assets?.radiograf_asset_id || "",
                    intraoral: selectedCase.roblox_assets?.intraoral_asset_id || ""
                },
                fisik: {
                    sonde: selectedCase.pemeriksaan_objektif?.sonde || "Negatif (-)",
                    perkusi: selectedCase.pemeriksaan_objektif?.perkusi || "Negatif (-)",
                    palpasi: selectedCase.pemeriksaan_objektif?.palpasi || "Negatif (-)",
                    thermal: selectedCase.pemeriksaan_objektif?.termal || selectedCase.pemeriksaan_objektif?.thermal || "Negatif (-)",
                    mobilitas: selectedCase.pemeriksaan_objektif?.mobilitas || "Fisiologis (Normal)"
                },
                pemeriksaanFisik: {
                    sonde: selectedCase.pemeriksaan_objektif?.sonde || "Negatif (-)",
                    perkusi: selectedCase.pemeriksaan_objektif?.perkusi || "Negatif (-)",
                    palpasi: selectedCase.pemeriksaan_objektif?.palpasi || "Negatif (-)",
                    thermal: selectedCase.pemeriksaan_objektif?.termal || selectedCase.pemeriksaan_objektif?.thermal || "Negatif (-)",
                    mobilitas: selectedCase.pemeriksaan_objektif?.mobilitas || "Fisiologis (Normal)"
                },
                alatWajib: ["Sonde", "Perkusi", "Thermal", "Palpasi"],
                planningBenar: ["Perawatan Saluran Akar", "PSA", "Insisi Drainase", "Enukleasi Kista", "Kuretase", "Ekstraksi", "Restorasi"],
                rewards: { xp: 100, gold: 50 },
                namaPenyakit: selectedCase.diagnosis_benar,
                rawCase: selectedCase
            },
            patient: patientProfile
        });
    } catch (err) {
        console.error("❌ Error next-osce-case:", err);
        res.status(500).json({ error: err.message });
    }
});

// Ambil Status Kasus Aktif
app.get('/api/osce/active-case/:playerUserId', checkAuth, async (req, res) => {
    try {
        const playerUserId = Number(req.params.playerUserId);
        const session = await OSCESession.findOne({ playerUserId });
        if (!session || !session.activeCase) {
            return res.json({ hasActiveCase: false });
        }
        res.json({
            hasActiveCase: true,
            caseNumber: session.caseCount,
            caseData: session.activeCase,
            patient: session.activePatient
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Validasi Jawaban OSCE (Diagnosis & Treatment Planning)
app.post('/api/osce/check-answer', checkAuth, async (req, res) => {
    try {
        const { playerUserId, robloxUsername, tipe, jawaban, durasiDetik } = req.body;
        const pId = Number(playerUserId);

        const session = await OSCESession.findOne({ playerUserId: pId });
        if (!session || !session.activeCase) {
            return res.status(400).json({ status: false, msg: "Tidak ada sesi kasus aktif." });
        }

        const activeCase = session.activeCase;
        const diagnosisBenar = activeCase.diagnosis_benar || "Unknown";
        const jawabanStr = String(jawaban || "").trim().toLowerCase();

        if (tipe === "Diagnosis") {
            // Evaluasi Diagnosis
            const kunciStr = diagnosisBenar.toLowerCase();
            let isCorrect = false;

            if (kunciStr.includes("abses") && jawabanStr.includes("abses")) isCorrect = true;
            else if (kunciStr.includes("granuloma") && jawabanStr.includes("granuloma")) isCorrect = true;
            else if (kunciStr.includes("kista") && (jawabanStr.includes("kista") || jawabanStr.includes("radikuler"))) isCorrect = true;
            else if (jawabanStr === kunciStr) isCorrect = true;

            const blockIndex = Math.ceil((session.caseCount || 1) / 3);

            if (isCorrect) {
                await OSCELog.create({
                    playerUserId: pId,
                    robloxUsername: robloxUsername || session.robloxUsername || "Dokter",
                    caseNumber: session.caseCount,
                    blockIndex,
                    category: activeCase.kategori_lesi,
                    caseId: activeCase.id,
                    kodeKasus: activeCase.kode_kasus,
                    elemenGigi: activeCase.elemen_gigi,
                    diagnosisTebakan: jawabanStr,
                    diagnosisBenar: diagnosisBenar,
                    isDiagnosisCorrect: true,
                    grade: "A",
                    goldEarned: 100,
                    xpEarned: 200,
                    durasiDetik: Number(durasiDetik) || 0
                });
                if (pId) {
                    await User.findOneAndUpdate({ userId: String(pId) }, { $inc: { gold: 100, xp: 200 } });
                }

                const totalSolved = await OSCELog.countDocuments({ playerUserId: pId, isDiagnosisCorrect: true });
                const totalAttempts = await OSCELog.countDocuments({ playerUserId: pId });
                const persentase = totalAttempts > 0 ? Math.round((totalSolved / totalAttempts) * 100) : 100;

                return res.json({
                    status: true,
                    isFinal: true,
                    lockTablet: true,
                    msg: `✅ Diagnosis TEPAT: ${diagnosisBenar}`,
                    data: {
                        grade: "A",
                        totalSolved,
                        totalAttempts,
                        persentase,
                        note: `Diagnosa tepat: ${diagnosisBenar}. Lesi periapikal teridentifikasi dengan tepat.`,
                        caseNumber: session.caseCount,
                        blockNumber: blockIndex,
                        kategori: activeCase.kategori_lesi
                    }
                });
            } else {
                // PETUNJUK EDUKATIF FORMATIF (CLUE) SESUAI KASUS AKTIF
                const kunciLower = diagnosisBenar.toLowerCase();
                let clueText = "";
                if (kunciLower.includes("abses")) {
                    clueText = "Perhatikan batas lesi radiolusen periapikal pada rontgen: batasnya DIFUS / TIDAK JELAS (ill-defined). Pada klinis sering disertai nyeri berdenyut atau pembengkakan supuratif.";
                } else if (kunciLower.includes("granuloma")) {
                    clueText = "Perhatikan batas lesi radiolusen periapikal pada rontgen: batasnya JELAS (well-defined) namun NON-KORTIKASI (tidak memiliki garis tepi putih sklerotik). Seringkali asimtomatik.";
                } else if (kunciLower.includes("kista")) {
                    clueText = "Perhatikan batas lesi radiolusen periapikal pada rontgen: lesi berukuran besar, berbatas SANGAT JELAS dan dilingkari garis putih KORTIKASI/SKLEROTIK tipis (corticated/sclerotic rim).";
                }

                return res.json({
                    status: false,
                    isFinal: false,
                    lockTablet: false,
                    msg: `❌ Diagnosis Belum Tepat!\n\n💡 CLUE KLINIS & RADIOGRAFIS:\n${clueText}\n\nSilakan periksa kembali gambaran foto rontgen & klinis di kursi periksa, lalu pilih ulang diagnosis Anda.`
                });
            }
        } else if (tipe === "Plan") {
            // Evaluasi Rencana Perawatan (Plan) & Rapor Akhir
            let grade = "B";
            let gold = 50;
            let xp = 100;
            let note = "Rencana perawatan telah diterima. Perhatikan asepsis dan tahapan restorasi akhir.";

            // Kata kunci rencana endodontik / bedah yang relevan
            const goodKeywords = ["akar", "psa", "rct", "drainase", "insisi", "enukleasi", "trepanasi", "ekstirpasi", "obturas", "restoras"];
            const hasGoodKeyword = goodKeywords.some(kw => jawabanStr.includes(kw));

            if (hasGoodKeyword) {
                grade = "A";
                gold = 100;
                xp = 200;
                note = "Sangat Baik! Rencana perawatan komprehensif dan sesuai indikasi klinis kasus.";
            }

            // Catat log ke OSCELog
            const blockIndex = Math.ceil((session.caseCount || 1) / 3);
            await OSCELog.create({
                playerUserId: pId,
                robloxUsername: robloxUsername || session.robloxUsername || "Dokter",
                caseNumber: session.caseCount,
                blockIndex,
                category: activeCase.kategori_lesi,
                caseId: activeCase.id,
                kodeKasus: activeCase.kode_kasus,
                elemenGigi: activeCase.elemen_gigi,
                diagnosisTebakan: jawabanStr,
                diagnosisBenar: diagnosisBenar,
                isDiagnosisCorrect: true,
                rencanaPerawatan: String(jawaban),
                grade,
                goldEarned: gold,
                xpEarned: xp,
                durasiDetik: Number(durasiDetik) || 0
            });

            // Beri reward gold & xp ke User jika ada
            if (pId) {
                await User.findOneAndUpdate({ userId: String(pId) }, { $inc: { gold, xp } });
            }

            return res.json({
                status: true,
                isFinal: true,
                msg: "✅ Rencana perawatan berhasil disubmit!",
                data: {
                    grade,
                    gold,
                    xp,
                    note,
                    caseNumber: session.caseCount,
                    kategori: activeCase.kategori_lesi
                }
            });
        }

        res.status(400).json({ status: false, msg: "Tipe evaluasi tidak dikenal." });
    } catch (err) {
        console.error("❌ Error check-answer:", err);
        res.status(500).json({ status: false, msg: err.message });
    }
});

// --- [D] AI CHAT (GEMINI) ---
app.post('/api/chat-ai', checkAuth, async (req, res) => {
    const { robloxId, pesan, konteksPenyakit, patientProfile } = req.body;

    try {
        if (robloxId) {
            await User.findOneAndUpdate({ robloxId }, {
                $push: {
                    chatHistory: {
                        $each: [{ source: 'roblox', role: 'user', parts: [{ text: pesan }], timestamp: new Date() }],
                        $slice: -20
                    }
                }
            });
        }

        const namaPasien = patientProfile?.name || "Pasien";
        const umurPasien = patientProfile?.age || "25";
        const genderPasien = patientProfile?.gender || "Male";

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
        `;

        const result = await model.generateContent(systemPrompt + "\nDokter bertanya: " + pesan);
        let responseAI = result.response.text().trim();

        // Enforce tag kelengkapan jika AI tidak menyertakan tag
        const pLower = (pesan || "").toLowerCase();
        if ((pLower.includes("nama") || pLower.includes("siapa")) && !responseAI.includes("[NAMA:")) {
            responseAI += ` [NAMA:${namaPasien}]`;
        }
        if ((pLower.includes("umur") || pLower.includes("usia") || pLower.includes("tahun")) && !responseAI.includes("[UMUR:")) {
            responseAI += ` [UMUR:${umurPasien}]`;
        }
        if ((pLower.includes("keluhan") || pLower.includes("sakit") || pLower.includes("rasa") || pLower.includes("ngilu")) && !responseAI.includes("[KELUHAN:")) {
            const klh = patientProfile?.keluhan_utama || "Nyeri berdenyut pada gigi";
            responseAI += ` [KELUHAN:${klh}]`;
        }

        console.log(`🤖 [GEMINI AI 2.5 FLASH] Response: ${responseAI}`);

        if (robloxId) {
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

    } catch (error) {
        console.warn("⚠️ Chat-AI fallback triggered:", error.message);
        const fallbackName = patientProfile?.name || "Pasien";
        const fallbackAge = patientProfile?.age || "25";
        const pLower = (pesan || "").toLowerCase();

        let reply = "";
        let tags = "";

        if (pLower.includes("nama") || pLower.includes("siapa")) {
            reply = `Nama saya ${fallbackName}, dok.`;
            tags += `[NAMA:${fallbackName}]`;
        }
        if (pLower.includes("umur") || pLower.includes("usia") || pLower.includes("tahun")) {
            reply += (reply ? " " : "") + `Umur saya sekarang ${fallbackAge} tahun.`;
            tags += `[UMUR:${fallbackAge}]`;
        }
        if (pLower.includes("keluhan") || pLower.includes("sakit") || pLower.includes("kenapa") || pLower.includes("rasa") || pLower.includes("ngilu") || pLower.includes("bengkak")) {
            reply += (reply ? " " : "") + `Gigi saya terasa berdenyut nyeri dan sangat sakit dok.`;
            tags += `[KELUHAN:Nyeri berdenyut dan sakit saat tersentuh]`;
        }
        if (pLower.includes("mana") || pLower.includes("lokasi") || pLower.includes("bagian")) {
            reply += (reply ? " " : "") + `Di bagian gigi yang belakang ini dok, terasa berdenyut.`;
            tags += `[LOKASI:Gigi posterior / geraham]`;
        }
        if (pLower.includes("lama") || pLower.includes("kapan") || pLower.includes("durasi") || pLower.includes("hari") || pLower.includes("minggu")) {
            reply += (reply ? " " : "") + `Sudah sekitar 4 hari yang lalu dok, makin lama makin terasa nyeri.`;
            tags += `[DURASI:Kurang lebih 4 hari terakhir]`;
        }
        if (pLower.includes("riwayat") || pLower.includes("pernah") || pLower.includes("sebelumnya") || pLower.includes("tambal") || pLower.includes("obat")) {
            reply += (reply ? " " : "") + `Dulu gigi ini sempat berlubang dan ditambal, tapi beberapa hari ini kumat lagi.`;
            tags += `[RIWAYAT:Pernah ditambal, kambuh nyeri]`;
        }

        if (!reply) {
            reply = `Iya dok, saya merasa gigi saya tidak nyaman dan ngilu sekali rasanya...`;
            tags = `[NAMA:${fallbackName}][UMUR:${fallbackAge}][KELUHAN:Nyeri dan tidak nyaman pada gigi]`;
        }

        res.json({ jawaban: `${reply} ${tags}`.trim() });
    }
});

// --- [E] SHOP & ECONOMY ---
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

// --- [F] SEEDING ENDPOINT (MIGRASI 41 KASUS) ---
app.post('/api/admin/seed-cases', checkAuth, async (req, res) => {
    try {
        const datasetPath = path.join(__dirname, 'dataset.json');
        if (!fs.existsSync(datasetPath)) {
            return res.status(404).json({ error: "dataset.json tidak ditemukan" });
        }
        const rawData = fs.readFileSync(datasetPath, 'utf-8');
        const cases = JSON.parse(rawData);

        await MedicalCase.deleteMany({});
        const inserted = await MedicalCase.insertMany(cases);

        const summary = {};
        for (const item of inserted) {
            summary[item.kategori_lesi] = (summary[item.kategori_lesi] || 0) + 1;
        }

        res.json({
            success: true,
            total: inserted.length,
            summary,
            message: "Database kasus medis berhasil dirombak dan diisi 41 kasus baru!"
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// SCRIPT EXPORTER FOR STUDIO SYNC
app.get('/api/admin/case-pool-script', (req, res) => {
    try {
        const content = fs.readFileSync('C:/Users/Administrator/.gemini/antigravity/brain/95f4b483-5905-4b66-baba-ef68451711ed/.system_generated/steps/1072/output.txt', 'utf8');
        res.setHeader('Content-Type', 'text/plain');
        res.send(content);
    } catch (e) {
        res.status(500).send(e.message);
    }
});

// START SERVER
app.listen(PORT, () => console.log(`🚀 Server Dental Simulator LIVE on port ${PORT}`));
