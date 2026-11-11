local rep = game:GetService("ReplicatedStorage")
local folder = rep:WaitForChild("PreTestSystem")
local mod = folder:FindFirstChild("CasePool")
if not mod then
    mod = Instance.new("ModuleScript")
    mod.Name = "CasePool"
    mod.Parent = folder
end

local header = [==[
local CasePool = {}
CasePool.Cases = {}

]==]

local chunk1 = [==[
CasePool.Cases["case_001"] = {
    id = "case_001", kode_kasus = "ABS-01", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "37",
    vignette_tes = "Seorang pasien laki-laki berusia 30 tahun datang dengan keluhan nyeri berdenyut hebat dan pembengkakan pada gigi geraham bawah kiri (elemen 37). Gigi tersebut memiliki riwayat perawatan saluran akar dan restorasi yang rusak. Pemeriksaan klinis: gigi non-vital, perkusi positif (+), palpasi mukosa periapikal positif (+) disertai pembengkakan bukal. Pemeriksaan radiograf periapikal menunjukkan lesi radiolusen periapikal yang besar pada gigi 37 disertai defek resorpsi servikal distal.",
    radiograf_asset_id = "rbxassetid://88918818371598", intraoral_asset_id = "rbxassetid://78781037357430"
}
CasePool.Cases["case_002"] = {
    id = "case_002", kode_kasus = "ABS-02", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "11",
    vignette_tes = "Seorang pria berusia 39 tahun datang dengan keluhan benjolan nyeri di dalam lubang hidung kanan. Keluhan ini muncul setelah gigi seri sentral kanan atas (elemen 11) mengalami trauma akibat jatuh dari tangga. Pemeriksaan klinis menunjukkan gigi 11 diskolorasi dan non-vital. Pemeriksaan radiografis periapikal menunjukkan adanya lesi radiolusen periapikal pada gigi 11.",
    radiograf_asset_id = "rbxassetid://138227411018232", intraoral_asset_id = "rbxassetid://114448091376708"
}
CasePool.Cases["case_003"] = {
    id = "case_003", kode_kasus = "ABS-03", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "47",
    vignette_tes = "Seorang pasien laki-laki berusia 32 tahun datang dengan keluhan gigi geraham kanan bawah (elemen 47) berlubang besar dan adanya benjolan di gusi yang kadang mengeluarkan nanah. Pemeriksaan klinis menunjukkan kerusakan mahkota yang luas pada gigi 47 dan adanya saluran sinus. Gigi tersebut didiagnosis sebagai gigi yang sebelumnya telah dirawat namun mengalami pembengkakan supuratif apikal kronis. Pada radiograf periapikal, terlihat gambaran radiolusen di area periapikal gigi 47.",
    radiograf_asset_id = "rbxassetid://88957532026542", intraoral_asset_id = "rbxassetid://115289528859694"
}
CasePool.Cases["case_004"] = {
    id = "case_004", kode_kasus = "ABS-04", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "11",
    vignette_tes = "Seorang pasien perempuan berusia 17 tahun datang dengan keluhan nyeri spontan dan gigi goyang pada gigi depan atas kanan (elemen 11) yang disertai pembengkakan lokal. Pemeriksaan klinis menunjukkan gigi 11 mengalami ekstrusi dan mobilitas tinggi. Tes termal menunjukkan gigi non-vital, dan tes perkusi serta palpasi positif. Gambaran radiograf periapikal menunjukkan lesi radiolusen difus di area periapikal gigi 11 dengan rarefaksi tulang.",
    radiograf_asset_id = "rbxassetid://100101304653264", intraoral_asset_id = "rbxassetid://85114368868281"
}
CasePool.Cases["case_006"] = {
    id = "case_006", kode_kasus = "ABS-06", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "45",
    vignette_tes = "An. Budi, seorang anak laki-laki berusia 10 tahun, datang dengan keluhan utama bengkak pada gusi di sekitar gigi premolar kedua rahang bawah kanan (45). Pemeriksaan objektif menunjukkan adanya pembengkakan supuratif fluktuatif bukal yang besar. Gigi 45 tidak merespon tes termal dingin, positif terhadap perkusi dan palpasi dengan fluktuasi. Gambaran radiograf periapikal menunjukkan lesi radiolusen periapikal yang besar dengan batas difus dan apeks yang belum menutup sempurna (immature root).",
    radiograf_asset_id = "rbxassetid://117599169953213", intraoral_asset_id = "rbxassetid://122485559467424"
}
CasePool.Cases["case_007"] = {
    id = "case_007", kode_kasus = "ABS-07", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "34",
    vignette_tes = "Tn. Rahmat, seorang pria berusia 28 tahun, datang dengan keluhan nyeri hebat dan keluar nanah dari gusi pada gigi geraham kecil bawah kiri (elemen 34). Pemeriksaan intraoral menunjukkan adanya saluran fistula pada mukosa lingual apikal gigi 34. Gigi 34 memiliki anomali dens evaginatus dengan keausan oklusal yang signifikan. Tes perkusi menunjukkan respon positif yang tajam, dan palpasi pada area apikal terasa nyeri. Hasil radiografi periapikal menunjukkan adanya area radiolusen periapikal yang difus pada gigi 34.",
    radiograf_asset_id = "rbxassetid://104164803544863", intraoral_asset_id = "rbxassetid://112292893202453"
}
CasePool.Cases["case_008"] = {
    id = "case_008", kode_kasus = "ABS-08", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "12",
    vignette_tes = "Seorang pasien perempuan, Ny. Siti, berusia 28 tahun, datang dengan keluhan utama gusi bengkak dan keluar nanah pada gigi depan atas kanan (elemen 12). Pemeriksaan objektif menunjukkan gigi 12 memiliki bentuk atipikal, dengan edema pada mukosa gingiva di sekitarnya dan adanya fistula. Tes vitalitas dan perkusi menunjukkan hasil negatif (-), sedangkan tes palpasi pada area periapikal gigi 12 positif (+). Gambaran radiografis periapikal menunjukkan lesi radiolusen difus pada area periapikal gigi 12.",
    radiograf_asset_id = "rbxassetid://111905706241796", intraoral_asset_id = "rbxassetid://124641932529931"
}
CasePool.Cases["case_009"] = {
    id = "case_009", kode_kasus = "ABS-09", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "45",
    vignette_tes = "An. Dodi, seorang anak laki-laki berusia 12 tahun, datang dengan keluhan nyeri hebat dan pembengkakan pada area gigi geraham kecil bawah kanan (elemen 45). Gigi tersebut memiliki riwayat anomali dens evaginatus. Pemeriksaan objektif menunjukkan gigi non-vital, perkusi positif, dan palpasi positif dengan nyeri tekan pada mukosa bukal. Radiograf periapikal menunjukkan lesi radiolusen difus yang luas pada area periapikal gigi 45 dengan kehilangan tulang alveolar yang signifikan.",
    radiograf_asset_id = "rbxassetid://82507149104714", intraoral_asset_id = "rbxassetid://82674892797287"
}
CasePool.Cases["case_010"] = {
    id = "case_010", kode_kasus = "ABS-10", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "21",
    vignette_tes = "An. Ratna, seorang anak perempuan berusia 8 tahun, datang dengan keluhan nyeri dan bengkak pada gigi depan atas (elemen 21). Pasien memiliki riwayat trauma luksasi intrusif pada gigi susu anterior kiri atas (61) saat berusia 2 tahun, yang kemudian diekstraksi. Gigi permanen penggantinya (21) mengalami erupsi sebagian dan kemudian pada usia 8 tahun 8 bulan, gigi tersebut mengalami pembengkakan mukosa periapikal fluktuatif. Pemeriksaan objektif menunjukkan gigi 21 non-vital, perkusi positif, dan palpasi positif pada area apikal. Radiograf periapikal menunjukkan lesi radiolusen difus di area periapikal gigi 21.",
    radiograf_asset_id = "rbxassetid://112018979148008", intraoral_asset_id = "rbxassetid://74936744474699"
}
CasePool.Cases["case_011"] = {
    id = "case_011", kode_kasus = "ABS-11", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "11",
    vignette_tes = "Seorang pria berusia 36 tahun datang dengan keluhan adanya saluran fistula pada gusi di sekitar gigi 11. Pasien memiliki riwayat trauma pada gigi 11 saat usia 10 tahun. Gigi 11 menunjukkan perkembangan akar yang belum sempurna (apeks terbuka) dan pembengkakan mukosa periapikal fluktuatif kronis yang asimtomatik. Pemeriksaan klinis menunjukkan adanya saluran fistula pada gingiva apikal gigi 11. Tes termal menunjukkan gigi non-vital. Radiografi periapikal menunjukkan lesi periapikal radiolusen dengan batas difus dan apeks terbuka pada gigi 11.",
    radiograf_asset_id = "rbxassetid://117109886077403", intraoral_asset_id = "rbxassetid://136910771253127"
}
CasePool.Cases["case_012"] = {
    id = "case_012", kode_kasus = "ABS-12", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "21",
    vignette_tes = "Seorang anak laki-laki berusia 7 tahun datang dengan keluhan bengkak dan nyeri pada gigi depan atas (21) yang muncul sekitar 15 hari setelah mengalami kecelakaan sepeda yang menyebabkan trauma langsung pada mulut dan luksasi ekstrusi gigi 11 dan 21. Pada pemeriksaan klinis, gigi 21 menunjukkan gingiva edematous, mobilitas derajat 3, dan nyeri saat perkusi. Tes termal menunjukkan respon negatif. Palpasi di area apikal gigi 21 terasa nyeri dan terdapat pembengkakan intraoral. Pemeriksaan radiografis periapikal menunjukkan pelebaran ligamen periodontal di sekitar gigi 21 dan pembentukan akar yang belum sempurna.",
    radiograf_asset_id = "rbxassetid://125121751838353", intraoral_asset_id = "rbxassetid://82804649457801"
}
CasePool.Cases["case_013"] = {
    id = "case_013", kode_kasus = "ABS-13", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "25",
    vignette_tes = "Tn. Agung, 35 tahun, datang dengan keluhan nyeri dan pembengkakan pada gusi di sekitar gigi 25, disertai keluarnya nanah. Pemeriksaan klinis menunjukkan pembengkakan supuratif submukosa dengan fistula dan gigi 25 dengan perawatan pasca-endodontik yang tidak adekuat serta karies sekunder. Gigi 25 non-vital, positif perkusi dan palpasi dengan fluktuasi. Radiograf periapikal menunjukkan gambaran radiolusen difus pada area periapikal gigi 25.",
    radiograf_asset_id = "rbxassetid://128284545189554", intraoral_asset_id = "rbxassetid://74820312011966"
}
CasePool.Cases["case_014"] = {
    id = "case_014", kode_kasus = "ABS-14", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "11",
    vignette_tes = "An. Dodi, seorang anak laki-laki berusia 9 tahun, datang dengan keluhan gigi depan atas (elemen 11) bengkak dan terkadang keluar nanah. Gigi tersebut memiliki riwayat trauma pada gigi sulung sebelumnya. Pemeriksaan objektif menunjukkan adanya saluran fistula pada gingiva bukal di area apeks gigi 11 dan gigi non-vital. Radiograf periapikal menunjukkan lesi radiolusen difus di area periapikal gigi 11 yang belum matur, mengindikasikan patosis periapikal terkait dens invaginatus Tipe IIIa.",
    radiograf_asset_id = "rbxassetid://78944506872517", intraoral_asset_id = "rbxassetid://121125822955911"
}
CasePool.Cases["case_015"] = {
    id = "case_015", kode_kasus = "ABS-15", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "36",
    vignette_tes = "Seorang anak laki-laki berusia 3 tahun datang dengan keluhan nyeri dan pembengkakan hebat pada regio gigi depan atas kiri. Pemeriksaan klinis menunjukkan adanya gigi triple (fusi) yang melibatkan insisivus sentral dan lateral sulung kiri, serta gigi supernumerary. Tes vitalitas menunjukkan gigi non-vital. Pada pemeriksaan radiograf periapikal, terlihat lesi radiolusen difus pada periapikal elemen gigi 61, serta gambaran fusi gigi dengan akar, kamar pulpa, dan saluran akar yang terpisah.",
    radiograf_asset_id = "rbxassetid://107493769470221", intraoral_asset_id = "rbxassetid://126161320840458"
}
CasePool.Cases["case_017"] = {
    id = "case_017", kode_kasus = "ABS-17", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "11",
    vignette_tes = "Seorang pasien laki-laki berusia 19 tahun datang dengan keluhan gigi depan atas (elemen 11) patah dan bengkak. Pasien memiliki riwayat trauma pada gigi tersebut. Pemeriksaan klinis menunjukkan fraktur koronal kompleks dan kebersihan mulut yang buruk. Tes termal menunjukkan respon negatif, sedangkan perkusi dan palpasi positif nyeri. Radiograf periapikal menunjukkan apeks terbuka, dinding akar tipis, ruang saluran akar yang lebar, dan area radiolusen difus pada regio periapikal gigi 11, mengindikasikan adanya infeksi periradikuler dan pembengkakan mukosa periapikal fluktuatif.",
    radiograf_asset_id = "rbxassetid://116736787082201", intraoral_asset_id = "rbxassetid://79850108078564"
}
CasePool.Cases["case_018"] = {
    id = "case_018", kode_kasus = "ABS-18", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "32",
    vignette_tes = "An. Dodi, seorang remaja laki-laki berusia 14 tahun, datang dengan keluhan utama pembengkakan berulang di bawah dagu dan luka dengan drainase nanah di area submental kanan. Pemeriksaan klinis menunjukkan gigi 32 (insisivus lateral kiri bawah) non-vital dengan adanya talon cusp. Tes perkusi positif dan palpasi menunjukkan adanya fluktuasi di area submental. Radiografi periapikal menunjukkan lesi radiolusen difus di periapikal gigi 32, mengindikasikan pembengkakan mukosa periapikal fluktuatif kronis.",
    radiograf_asset_id = "rbxassetid://129703443951940", intraoral_asset_id = "rbxassetid://75912204801128"
}
CasePool.Cases["case_019"] = {
    id = "case_019", kode_kasus = "ABS-19", kategori_lesi = "abses_periapikal", diagnosis_benar = "Abses Periapikal", elemen_gigi = "36",
    vignette_tes = "Seorang anak perempuan berusia 7 tahun datang dengan keluhan gigi geraham bawah kanan (elemen 85) berlubang dan disertai adanya benjolan serta saluran keluar nanah baik di dalam maupun di luar mulut yang tidak kunjung sembuh. Pemeriksaan objektif menunjukkan karies besar pada gigi 85, tes termal negatif, perkusi dan palpasi positif ringan di area furkasi. Radiograf periapikal menunjukkan lesi radiolusen difus di area furkasi gigi 85, dengan gutta-percha yang dimasukkan ke saluran sinus mencapai area furkasi.",
    radiograf_asset_id = "rbxassetid://107313953192960", intraoral_asset_id = "rbxassetid://107389385175794"
}
CasePool.Cases["case_026"] = {
    id = "case_026", kode_kasus = "GRN-01", kategori_lesi = "granuloma_periapikal", diagnosis_benar = "Granuloma Periapikal", elemen_gigi = "14",
    vignette_tes = "Ny. Ratna, seorang perempuan berusia 40 tahun, datang dengan keluhan gigi geraham kecil atas kanan (elemen 14) yang sudah pernah dirawat saluran akar terasa tidak nyaman dan kadang nyeri ringan saat mengunyah. Pemeriksaan objektif menunjukkan gigi non-vital, perkusi dan palpasi negatif atau sedikit sensitif. Gambaran radiografik menunjukkan lesi radiolusen periapikal berbatas jelas non-kortikasi pada apeks gigi 14.",
    radiograf_asset_id = "rbxassetid://98573401347417", intraoral_asset_id = "rbxassetid://138848911656646"
}
]==]

mod.Source = header .. chunk1
return "Chunk 1 injected (" .. tostring(#mod.Source) .. " bytes)"
