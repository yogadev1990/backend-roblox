local rep = game:GetService("ReplicatedStorage")
local folder = rep:WaitForChild("PreTestSystem")
local mod = folder:WaitForChild("CasePool")

local chunk2 = [==[

CasePool.Cases["case_027"] = {
    id = "case_027", kode_kasus = "GRN-02", kategori_lesi = "granuloma_periapikal", diagnosis_benar = "Granuloma Periapikal", elemen_gigi = "21",
    vignette_tes = "Seorang wanita berusia 61 tahun datang ke klinik gigi dengan keluhan pembengkakan tanpa nyeri di area gigi insisivus sentral kiri atas (elemen 21). Pemeriksaan klinis menunjukkan pembengkakan yang tidak fluktuatif. Tes termal pada gigi 21 menunjukkan hasil negatif, sedangkan tes perkusi dan palpasi menunjukkan respon negatif atau sedikit nyeri. Radiograf periapikal menunjukkan lesi radiolusen berbatas jelas non-kortikasi di area periapikal gigi 21.",
    radiograf_asset_id = "rbxassetid://106352061687610", intraoral_asset_id = "rbxassetid://101620691270027"
}
CasePool.Cases["case_028"] = {
    id = "case_028", kode_kasus = "GRN-03", kategori_lesi = "granuloma_periapikal", diagnosis_benar = "Granuloma Periapikal", elemen_gigi = "12",
    vignette_tes = "Seorang pasien perempuan berusia 63 tahun datang dengan keluhan kehilangan gigi 12 dan berencana untuk pemasangan implan. Pada pemeriksaan radiografis pra-implan, ditemukan adanya lesi periapikal residual pada area gigi 12 yang hilang. Pasien tidak merasakan nyeri atau gejala akut lainnya pada area tersebut. Hasil pemeriksaan histopatologi setelah enukleasi lesi mengkonfirmasi diagnosis lesi periapikal kronis berbatas tegas non-kortikasi.",
    radiograf_asset_id = "rbxassetid://75895380325737", intraoral_asset_id = "rbxassetid://97456097386398"
}
CasePool.Cases["case_029"] = {
    id = "case_029", kode_kasus = "GRN-04", kategori_lesi = "granuloma_periapikal", diagnosis_benar = "Granuloma Periapikal", elemen_gigi = "11",
    vignette_tes = "Ny. Ratna, seorang perempuan berusia 35 tahun, datang dengan keluhan nyeri tumpul persisten dan gusi bengkak pada gigi depan atas (elemen 11) yang sudah pernah dirawat saluran akar. Pemeriksaan objektif menunjukkan gingiva bengkak pada area anterior maksila, gigi 11 non-vital, sedikit sensitif terhadap perkusi, dan palpasi apeks sedikit nyeri. Radiograf periapikal menunjukkan lesi radiolusen besar pada area periapikal gigi 11, 12, dan 21 dengan batas tepi yang jelas namun tidak berkorteks.",
    radiograf_asset_id = "rbxassetid://117486195300038", intraoral_asset_id = "rbxassetid://101153104256542"
}
CasePool.Cases["case_030"] = {
    id = "case_030", kode_kasus = "GRN-05", kategori_lesi = "granuloma_periapikal", diagnosis_benar = "Granuloma Periapikal", elemen_gigi = "12",
    vignette_tes = "Pasien perempuan, 25 tahun, datang dengan keluhan adanya benjolan/fistula di gusi depan atas dan perubahan warna gigi setelah riwayat trauma olahraga di masa lalu. Pemeriksaan klinis menunjukkan diskolorasi pada gigi 11 dan 21, serta adanya stoma fistula di area apikal antara gigi 11 dan 12. Gigi 12 memiliki riwayat perawatan saluran akar. Tes termal pada gigi 11 dan 12 kemungkinan negatif. Perkusi dan palpasi pada area periapikal gigi 12 dan 11 mungkin menunjukkan sedikit nyeri atau adanya fistula. Radiograf periapikal menunjukkan lesi radiolusen periapikal pada gigi 12 dengan riwayat perawatan saluran akar.",
    radiograf_asset_id = "rbxassetid://134964331330556", intraoral_asset_id = "rbxassetid://120833670520620"
}
CasePool.Cases["case_031"] = {
    id = "case_031", kode_kasus = "GRN-06", kategori_lesi = "granuloma_periapikal", diagnosis_benar = "Granuloma Periapikal", elemen_gigi = "11",
    vignette_tes = "Seorang pasien laki-laki berusia 18 tahun datang untuk pemeriksaan rutin setelah mengalami trauma avulsi pada gigi depan atas (elemen 11) delapan tahun yang lalu. Pasien mengeluhkan perubahan warna pada gigi tersebut. Pemeriksaan klinis menunjukkan gigi 11 non-vital dengan kalsifikasi saluran akar. Pemeriksaan radiograf periapikal menunjukkan adanya lesi radiolusen berbatas jelas non-kortikasi di area periapikal gigi 11.",
    radiograf_asset_id = "rbxassetid://133542141950115", intraoral_asset_id = "rbxassetid://75525317439972"
}
CasePool.Cases["case_032"] = {
    id = "case_032", kode_kasus = "GRN-07", kategori_lesi = "granuloma_periapikal", diagnosis_benar = "Granuloma Periapikal", elemen_gigi = "21",
    vignette_tes = "Seorang pasien perempuan berusia 13 tahun dirujuk ke bagian endodontik setelah penanganan darurat awal akibat trauma gigi. Pasien mengeluhkan gigi depan atas kiri (elemen 21) terasa tidak nyaman dan telah didiagnosis dengan periodontitis apikal persisten. Pemeriksaan klinis menunjukkan gigi 21 non-vital, tidak ada respon terhadap tes termal, dan perkusi/palpasi mungkin sedikit sensitif atau negatif. Radiograf periapikal menunjukkan lesi radiolusen berbatas relatif jelas di area periapikal gigi 21.",
    radiograf_asset_id = "rbxassetid://82178002619122", intraoral_asset_id = "rbxassetid://75521977945535"
}
CasePool.Cases["case_051"] = {
    id = "case_051", kode_kasus = "KIS-01", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "21",
    vignette_tes = "Seorang pasien laki-laki berusia 24 tahun datang dengan keluhan gigi depan atas (11, 12, 21, 22) patah akibat riwayat trauma kecelakaan lalu lintas. Pemeriksaan klinis menunjukkan fraktur Ellis kelas IV pada gigi 11, 12, 21, dan 22. Meskipun telah dilakukan perawatan saluran akar non-bedah, terdapat eksudasi persisten dari gigi 21 dan 22. Radiograf periapikal menunjukkan lesi radiolusen periapikal yang luas pada regio anterior maksila.",
    radiograf_asset_id = "rbxassetid://117841164033085", intraoral_asset_id = "rbxassetid://86873210853056"
}
CasePool.Cases["case_052"] = {
    id = "case_052", kode_kasus = "KIS-02", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "36",
    vignette_tes = "Seorang anak perempuan berusia 6 tahun datang dengan keluhan utama pembengkakan pada rahang atas kanan belakang. Pemeriksaan klinis menunjukkan pembengkakan difus di area gigi 55. Gigi 55 menunjukkan respon negatif terhadap tes termal dan perkusi ringan positif. Palpasi di area tersebut positif. Radiograf periapikal menunjukkan lesi radiolusen unilokuler berbatas jelas dengan kortikasi di sekitar apeks gigi 55 dan 16.",
    radiograf_asset_id = "rbxassetid://135505395500548", intraoral_asset_id = "rbxassetid://96737564171596"
}
CasePool.Cases["case_053"] = {
    id = "case_053", kode_kasus = "KIS-03", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "36",
    vignette_tes = "Seorang pasien perempuan berusia 45 tahun datang dengan keluhan nyeri persisten pada gigi geraham bawah kiri (elemen 36) yang sebelumnya telah dirawat saluran akar dan direstorasi dengan mahkota metal-keramik. Pemeriksaan klinis menunjukkan gigi non-vital dan sedikit sensitif terhadap perkusi dan palpasi. Radiograf periapikal dan CBCT menunjukkan adanya lesi radiolusen berbatas jelas dan berkortikasi di area periapikal gigi 36, berukuran besar dan berdekatan dengan nervus alveolaris inferior.",
    radiograf_asset_id = "rbxassetid://87293436716989", intraoral_asset_id = "rbxassetid://119162176035781"
}
CasePool.Cases["case_054"] = {
    id = "case_054", kode_kasus = "KIS-04", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "22",
    vignette_tes = "Seorang anak perempuan berusia 10 tahun datang dengan keluhan utama pembengkakan berulang pada area gigi insisivus lateral kiri rahang atas (elemen 22). Pemeriksaan klinis menunjukkan gigi 22 mengalami malformasi dengan mobilitas derajat II dan pembengkakan gingiva yang berfluktuasi. Tes termal menunjukkan respon negatif, mengindikasikan nekrosis pulpa. Radiograf periapikal menunjukkan lesi radiolusen besar di periapikal gigi 22 dengan apeks yang belum matur dan gambaran dens invaginatus.",
    radiograf_asset_id = "rbxassetid://113879106040796", intraoral_asset_id = "rbxassetid://97735275727677"
}
CasePool.Cases["case_055"] = {
    id = "case_055", kode_kasus = "KIS-05", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "26",
    vignette_tes = "Seorang pasien perempuan berusia 20 tahun datang dengan keluhan nyeri dan ketidaknyamanan jangka panjang pada gigi 26 (geraham pertama rahang atas kiri) saat mengunyah. Pemeriksaan klinis menunjukkan adanya restorasi sementara pada gigi tersebut, nyeri saat perkusi, namun tidak ada pembengkakan gingiva. Riwayat perawatan saluran akar menunjukkan adanya instrumen patah yang keluar dari apeks akar mesiobukal. Radiograf periapikal dan CBCT mengkonfirmasi adanya instrumen nikel-titanium yang patah dan keluar dari apeks akar ke daerah periapikal berdekatan dengan dasar sinus maksila, disertai area radiolusen periapikal.",
    radiograf_asset_id = "rbxassetid://120572001880402", intraoral_asset_id = "rbxassetid://109328008288732"
}
CasePool.Cases["case_056"] = {
    id = "case_056", kode_kasus = "KIS-06", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "11",
    vignette_tes = "Tn. Surya, seorang laki-laki berusia 49 tahun, datang dengan keluhan utama pembengkakan tanpa rasa sakit di daerah anterior rahang atas. Pemeriksaan klinis menunjukkan gigi 11 berubah warna dan terdapat pembengkakan lunak, tidak nyeri tekan, serta berfluktuasi di regio anterior maksila. Tes termal pada gigi 11 menunjukkan hasil negatif. Pemeriksaan radiografis periapikal mengungkapkan adanya lesi radiolusen di daerah periapikal gigi 11.",
    radiograf_asset_id = "rbxassetid://106067295155557", intraoral_asset_id = "rbxassetid://129327611725863"
}
CasePool.Cases["case_057"] = {
    id = "case_057", kode_kasus = "KIS-07", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "11",
    vignette_tes = "Seorang pasien laki-laki berusia 35 tahun datang dengan keluhan nyeri pada gigi depan rahang atas dan sedikit pembengkakan di area tersebut. Pemeriksaan klinis menunjukkan diskolorasi pada mahkota gigi 11 dan sedikit edema pada mukosa bukal. Tes termal pada gigi 11 kemungkinan negatif, menunjukkan pulpa non-vital. Perkusi dan palpasi mungkin menunjukkan respon positif ringan hingga sedang. Radiograf periapikal menunjukkan lesi radiolusen berbatas jelas di area periapikal gigi 11.",
    radiograf_asset_id = "rbxassetid://84567243309231", intraoral_asset_id = "rbxassetid://110139171514720"
}
CasePool.Cases["case_058"] = {
    id = "case_058", kode_kasus = "KIS-08", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "11",
    vignette_tes = "Seorang pasien perempuan berusia 16 tahun datang dengan keluhan utama pembengkakan pada sisi kanan wajah, disertai nanah dan nyeri pada mukosa labial di area gigi seri kanan atas (elemen 11). Pemeriksaan objektif menunjukkan pembengkakan intraoral dengan fluktuasi dan pus. Gigi 11 menunjukkan respon negatif terhadap tes termal dan positif terhadap perkusi serta palpasi. Gambaran radiografik menunjukkan lesi radiolusen besar, berbatas jelas, meluas dari periapikal gigi 11 hingga gigi 13.",
    radiograf_asset_id = "rbxassetid://110220565197091", intraoral_asset_id = "rbxassetid://104753185410212"
}
CasePool.Cases["case_059"] = {
    id = "case_059", kode_kasus = "KIS-09", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "22",
    vignette_tes = "Seorang anak perempuan berusia 9 tahun datang dengan keluhan gigi depan atas kiri (elemen 22) berubah warna dan terdapat pembengkakan pada gusi di area tersebut. Pemeriksaan klinis menunjukkan adanya pit palatal yang dalam dan diskolorasi pada gigi 22. Tes termal menunjukkan respon negatif, perkusi negatif, dan palpasi negatif. Radiograf periapikal menunjukkan lesi radiolusen berbatas jelas dengan kortikasi di area periapikal gigi 22.",
    radiograf_asset_id = "rbxassetid://87829678971362", intraoral_asset_id = "rbxassetid://122122916084045"
}
CasePool.Cases["case_061"] = {
    id = "case_061", kode_kasus = "KIS-11", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "12",
    vignette_tes = "Seorang pasien laki-laki berusia 28 tahun datang dengan keluhan utama keluar nanah dan pembengkakan yang hilang timbul pada area gigi 12 rahang atas kanan, setelah riwayat trauma gigi. Pemeriksaan objektif menunjukkan gigi 12 non-vital pada tes termal, palpasi positif dengan pembengkakan, dan perkusi negatif. Radiograf periapikal menunjukkan lesi radiolusen besar, berbatas jelas dengan kortikasi tipis pada area periapikal gigi 12.",
    radiograf_asset_id = "rbxassetid://83146813967274", intraoral_asset_id = "rbxassetid://86492467951443"
}
CasePool.Cases["case_062"] = {
    id = "case_062", kode_kasus = "KIS-12", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "11",
    vignette_tes = "Ny. Siti, 38 tahun, datang dengan keluhan pembengkakan pada gusi depan atas yang disertai rasa tidak nyaman ringan. Gigi elemen 11 dan 21 menunjukkan non-vitalitas pada tes termal. Perkusi dan palpasi pada area apikal gigi 11 dan 21 menunjukkan sedikit sensitivitas. Radiograf periapikal menunjukkan lesi radiolusen unilokuler besar dengan batas tepi sklerotik yang jelas pada regio periapikal gigi 11 dan 21.",
    radiograf_asset_id = "rbxassetid://77596822766865", intraoral_asset_id = "rbxassetid://131602489641231"
}
CasePool.Cases["case_063"] = {
    id = "case_063", kode_kasus = "KIS-13", kategori_lesi = "kista_radikuler", diagnosis_benar = "Kista Radikuler", elemen_gigi = "11",
    vignette_tes = "Seorang pasien perempuan berusia 32 tahun datang dengan keluhan utama nyeri dan keluar nanah di area gigi depan kanan atas sejak 2 bulan yang lalu. Pemeriksaan klinis menunjukkan adanya pembengkakan dan keluarnya nanah di regio anterior rahang atas. Tes termal pada gigi 11 dan 12 kemungkinan negatif, dan perkusi serta palpasi mungkin positif. Gambaran radiograf periapikal menunjukkan lesi radiolusen periapikal yang berbatas jelas pada gigi 11 dan 12.",
    radiograf_asset_id = "rbxassetid://136231560101471", intraoral_asset_id = "rbxassetid://78640232395964"
}

local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function CasePool.GetRandomPreTestCases(excludedIds)
    excludedIds = excludedIds or {}
    local excludedMap = {}
    for _, id in ipairs(excludedIds) do
        excludedMap[id] = true
    end

    local poolAbses = {}
    local poolGranuloma = {}
    local poolKista = {}

    for _, caseData in pairs(CasePool.Cases) do
        if not excludedMap[caseData.id] then
            if caseData.kategori_lesi == "abses_periapikal" then
                table.insert(poolAbses, caseData)
            elseif caseData.kategori_lesi == "granuloma_periapikal" then
                table.insert(poolGranuloma, caseData)
            elseif caseData.kategori_lesi == "kista_radikuler" then
                table.insert(poolKista, caseData)
            end
        end
    end

    shuffle(poolAbses)
    shuffle(poolGranuloma)
    shuffle(poolKista)

    local selected = {}
    for i = 1, math.min(3, #poolAbses) do table.insert(selected, poolAbses[i]) end
    for i = 1, math.min(3, #poolGranuloma) do table.insert(selected, poolGranuloma[i]) end
    for i = 1, math.min(3, #poolKista) do table.insert(selected, poolKista[i]) end

    shuffle(selected)
    return selected
end

-- Alias untuk kompatibilitas
CasePool.GenerateStratifiedPretest = CasePool.GetRandomPreTestCases

return CasePool
]==]

mod.Source = mod.Source .. chunk2
return "Chunk 2 injected. Total CasePool.Source: " .. tostring(#mod.Source) .. " bytes"
