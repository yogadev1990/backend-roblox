--[[
    CasePool.luau
    Koleksi 36 Kasus Medis Pre-test (Stratified Pool)
    - abses_periapikal: 17 kasus
    - granuloma_periapikal: 7 kasus
    - kista_radikuler: 12 kasus
--]]

local CasePool = {}

CasePool.Cases = {
    ["case_001"] = {
        id = "case_001",
        kode_kasus = "ABS-01",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "37",
        vignette_tes = "Seorang pasien laki-laki berusia 30 tahun datang dengan keluhan nyeri berdenyut hebat dan pembengkakan pada gigi geraham bawah kiri (elemen 37). Gigi tersebut memiliki riwayat perawatan saluran akar dan restorasi yang rusak. Pemeriksaan klinis: gigi non-vital, perkusi positif (+), palpasi mukosa periapikal positif (+) disertai pembengkakan bukal. Pemeriksaan radiograf periapikal menunjukkan lesi radiolusen periapikal yang besar pada gigi 37 disertai defek resorpsi servikal distal.",
        radiograf_asset_id = "rbxassetid://85858131255866",
        intraoral_asset_id = "rbxassetid://94466958278111"
    },
    ["case_002"] = {
        id = "case_002",
        kode_kasus = "ABS-02",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "11",
        vignette_tes = "Seorang pria berusia 39 tahun datang dengan keluhan benjolan nyeri di dalam lubang hidung kanan. Keluhan ini muncul setelah gigi seri sentral kanan atas (elemen 11) mengalami trauma akibat jatuh dari tangga. Pemeriksaan klinis menunjukkan gigi 11 diskolorasi dan non-vital. Pemeriksaan radiografis periapikal menunjukkan adanya lesi radiolusen periapikal pada gigi 11.",
        radiograf_asset_id = "rbxassetid://135057284021853",
        intraoral_asset_id = "rbxassetid://126348013434214"
    },
    ["case_003"] = {
        id = "case_003",
        kode_kasus = "ABS-03",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "47",
        vignette_tes = "Seorang pasien laki-laki berusia 32 tahun datang dengan keluhan gigi geraham kanan bawah (elemen 47) berlubang besar dan adanya benjolan di gusi yang kadang mengeluarkan nanah. Pemeriksaan klinis menunjukkan kerusakan mahkota yang luas pada gigi 47 dan adanya saluran sinus. Gigi tersebut didiagnosis sebagai gigi yang sebelumnya telah dirawat namun mengalami pembengkakan supuratif apikal kronis. Pada radiograf periapikal, terlihat gambaran radiolusen di area periapikal gigi 47.",
        radiograf_asset_id = "rbxassetid://96732875214330",
        intraoral_asset_id = "rbxassetid://127523373221619"
    },
    ["case_004"] = {
        id = "case_004",
        kode_kasus = "ABS-04",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "11",
        vignette_tes = "Seorang pasien perempuan berusia 17 tahun datang dengan keluhan nyeri spontan dan gigi goyang pada gigi depan atas kanan (elemen 11) yang disertai pembengkakan lokal. Pemeriksaan klinis menunjukkan gigi 11 mengalami ekstrusi dan mobilitas tinggi. Tes termal menunjukkan gigi non-vital, dan tes perkusi serta palpasi positif. Gambaran radiograf periapikal menunjukkan lesi radiolusen difus di area periapikal gigi 11 dengan rarefaksi tulang.",
        radiograf_asset_id = "rbxassetid://130288632657658",
        intraoral_asset_id = "rbxassetid://101616938467564"
    },
    ["case_006"] = {
        id = "case_006",
        kode_kasus = "ABS-06",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "45",
        vignette_tes = "An. Budi, seorang anak laki-laki berusia 10 tahun, datang dengan keluhan utama bengkak pada gusi di sekitar gigi premolar kedua rahang bawah kanan (45). Pemeriksaan objektif menunjukkan adanya pembengkakan supuratif fluktuatif bukal yang besar. Gigi 45 tidak merespon tes termal dingin, positif terhadap perkusi dan palpasi dengan fluktuasi. Gambaran radiograf periapikal menunjukkan lesi radiolusen periapikal yang besar dengan batas difus dan apeks yang belum menutup sempurna (immature root).",
        radiograf_asset_id = "rbxassetid://102656081760100",
        intraoral_asset_id = "rbxassetid://139917128670062"
    },
    ["case_007"] = {
        id = "case_007",
        kode_kasus = "ABS-07",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "34",
        vignette_tes = "Tn. Rahmat, seorang pria berusia 28 tahun, datang dengan keluhan nyeri hebat dan keluar nanah dari gusi pada gigi geraham kecil bawah kiri (elemen 34). Pemeriksaan intraoral menunjukkan adanya saluran fistula pada mukosa lingual apikal gigi 34. Gigi 34 memiliki anomali dens evaginatus dengan keausan oklusal yang signifikan. Tes perkusi menunjukkan respon positif yang tajam, dan palpasi pada area apikal terasa nyeri. Hasil radiografi periapikal menunjukkan adanya area radiolusen periapikal yang difus pada gigi 34.",
        radiograf_asset_id = "rbxassetid://132417498729651",
        intraoral_asset_id = "rbxassetid://70734816557673"
    },
    ["case_008"] = {
        id = "case_008",
        kode_kasus = "ABS-08",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "12",
        vignette_tes = "Seorang pasien perempuan, Ny. Siti, berusia 28 tahun, datang dengan keluhan utama gusi bengkak dan keluar nanah pada gigi depan atas kanan (elemen 12). Pemeriksaan objektif menunjukkan gigi 12 memiliki bentuk atipikal, dengan edema pada mukosa gingiva di sekitarnya dan adanya fistula. Tes vitalitas dan perkusi menunjukkan hasil negatif (-), sedangkan tes palpasi pada area periapikal gigi 12 positif (+). Gambaran radiografis periapikal menunjukkan lesi radiolusen difus pada area periapikal gigi 12.",
        radiograf_asset_id = "rbxassetid://88692363963479",
        intraoral_asset_id = "rbxassetid://126326191381950"
    },
    ["case_009"] = {
        id = "case_009",
        kode_kasus = "ABS-09",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "45",
        vignette_tes = "An. Dodi, seorang anak laki-laki berusia 12 tahun, datang dengan keluhan nyeri hebat dan pembengkakan pada area gigi geraham kecil bawah kanan (elemen 45). Gigi tersebut memiliki riwayat anomali dens evaginatus. Pemeriksaan objektif menunjukkan gigi non-vital, perkusi positif, dan palpasi positif dengan nyeri tekan pada mukosa bukal. Radiograf periapikal menunjukkan lesi radiolusen difus yang luas pada area periapikal gigi 45 dengan kehilangan tulang alveolar yang signifikan.",
        radiograf_asset_id = "rbxassetid://115251149301357",
        intraoral_asset_id = "rbxassetid://74250854003398"
    },
    ["case_010"] = {
        id = "case_010",
        kode_kasus = "ABS-10",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "21",
        vignette_tes = "An. Ratna, seorang anak perempuan berusia 8 tahun, datang dengan keluhan nyeri dan bengkak pada gigi depan atas (elemen 21). Pasien memiliki riwayat trauma luksasi intrusif pada gigi susu anterior kiri atas (61) saat berusia 2 tahun, yang kemudian diekstraksi. Gigi permanen penggantinya (21) mengalami erupsi sebagian dan kemudian pada usia 8 tahun 8 bulan, gigi tersebut mengalami pembengkakan mukosa periapikal fluktuatif. Pemeriksaan objektif menunjukkan gigi 21 non-vital, perkusi positif, dan palpasi positif pada area apikal. Radiograf periapikal menunjukkan lesi radiolusen difus di area periapikal gigi 21.",
        radiograf_asset_id = "rbxassetid://135833165041988",
        intraoral_asset_id = "rbxassetid://83074773588009"
    },
    ["case_011"] = {
        id = "case_011",
        kode_kasus = "ABS-11",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "11",
        vignette_tes = "Seorang pria berusia 36 tahun datang dengan keluhan adanya saluran fistula pada gusi di sekitar gigi 11. Pasien memiliki riwayat trauma pada gigi 11 saat usia 10 tahun. Gigi 11 menunjukkan perkembangan akar yang belum sempurna (apeks terbuka) dan pembengkakan mukosa periapikal fluktuatif kronis yang asimtomatik. Pemeriksaan klinis menunjukkan adanya saluran fistula pada gingiva apikal gigi 11. Tes termal menunjukkan gigi non-vital. Radiografi periapikal menunjukkan lesi periapikal radiolusen dengan batas difus dan apeks terbuka pada gigi 11.",
        radiograf_asset_id = "rbxassetid://109870501265076",
        intraoral_asset_id = "rbxassetid://78530498041728"
    },
    ["case_012"] = {
        id = "case_012",
        kode_kasus = "ABS-12",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "21",
        vignette_tes = "Seorang anak laki-laki berusia 7 tahun datang dengan keluhan bengkak dan nyeri pada gigi depan atas (21) yang muncul sekitar 15 hari setelah mengalami kecelakaan sepeda yang menyebabkan trauma langsung pada mulut dan luksasi ekstrusi gigi 11 dan 21. Pada pemeriksaan klinis, gigi 21 menunjukkan gingiva edematous, mobilitas derajat 3, dan nyeri saat perkusi. Tes termal menunjukkan respon negatif. Palpasi di area apikal gigi 21 terasa nyeri dan terdapat pembengkakan intraoral. Pemeriksaan radiografis periapikal menunjukkan pelebaran ligamen periodontal di sekitar gigi 21 dan pembentukan akar yang belum sempurna.",
        radiograf_asset_id = "rbxassetid://92252273225613",
        intraoral_asset_id = "rbxassetid://138519414346271"
    },
    ["case_013"] = {
        id = "case_013",
        kode_kasus = "ABS-13",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "25",
        vignette_tes = "Tn. Agung, 35 tahun, datang dengan keluhan nyeri dan pembengkakan pada gusi di sekitar gigi 25, disertai keluarnya nanah. Pemeriksaan klinis menunjukkan pembengkakan supuratif submukosa dengan fistula dan gigi 25 dengan perawatan pasca-endodontik yang tidak adekuat serta karies sekunder. Gigi 25 non-vital, positif perkusi dan palpasi dengan fluktuasi. Radiograf periapikal menunjukkan gambaran radiolusen difus pada area periapikal gigi 25.",
        radiograf_asset_id = "rbxassetid://135757099438660",
        intraoral_asset_id = "rbxassetid://119063680303409"
    },
    ["case_014"] = {
        id = "case_014",
        kode_kasus = "ABS-14",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "11",
        vignette_tes = "An. Dodi, seorang anak laki-laki berusia 9 tahun, datang dengan keluhan gigi depan atas (elemen 11) bengkak dan terkadang keluar nanah. Gigi tersebut memiliki riwayat trauma pada gigi sulung sebelumnya. Pemeriksaan objektif menunjukkan adanya saluran fistula pada gingiva bukal di area apeks gigi 11 dan gigi non-vital. Radiograf periapikal menunjukkan lesi radiolusen difus di area periapikal gigi 11 yang belum matur, mengindikasikan patosis periapikal terkait dens invaginatus Tipe IIIa.",
        radiograf_asset_id = "rbxassetid://79052772474706",
        intraoral_asset_id = "rbxassetid://88383773626670"
    },
    ["case_015"] = {
        id = "case_015",
        kode_kasus = "ABS-15",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "36",
        vignette_tes = "Seorang anak laki-laki berusia 3 tahun datang dengan keluhan nyeri dan pembengkakan hebat pada regio gigi depan atas kiri. Pemeriksaan klinis menunjukkan adanya gigi triple (fusi) yang melibatkan insisivus sentral dan lateral sulung kiri, serta gigi supernumerary. Tes vitalitas menunjukkan gigi non-vital. Pada pemeriksaan radiograf periapikal, terlihat lesi radiolusen difus pada periapikal elemen gigi 61, serta gambaran fusi gigi dengan akar, kamar pulpa, dan saluran akar yang terpisah.",
        radiograf_asset_id = "rbxassetid://140147499386387",
        intraoral_asset_id = "rbxassetid://89036191890830"
    },
    ["case_017"] = {
        id = "case_017",
        kode_kasus = "ABS-17",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "11",
        vignette_tes = "Seorang pasien laki-laki berusia 19 tahun datang dengan keluhan gigi depan atas (elemen 11) patah dan bengkak. Pasien memiliki riwayat trauma pada gigi tersebut. Pemeriksaan klinis menunjukkan fraktur koronal kompleks dan kebersihan mulut yang buruk. Tes termal menunjukkan respon negatif, sedangkan perkusi dan palpasi positif nyeri. Radiograf periapikal menunjukkan apeks terbuka, dinding akar tipis, ruang saluran akar yang lebar, dan area radiolusen difus pada regio periapikal gigi 11, mengindikasikan adanya infeksi periradikuler dan pembengkakan mukosa periapikal fluktuatif.",
        radiograf_asset_id = "rbxassetid://98824460636769",
        intraoral_asset_id = "rbxassetid://96567216338452"
    },
    ["case_018"] = {
        id = "case_018",
        kode_kasus = "ABS-18",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "32",
        vignette_tes = "An. Dodi, seorang remaja laki-laki berusia 14 tahun, datang dengan keluhan utama pembengkakan berulang di bawah dagu dan luka dengan drainase nanah di area submental kanan. Pemeriksaan klinis menunjukkan gigi 32 (insisivus lateral kiri bawah) non-vital dengan adanya talon cusp. Tes perkusi positif dan palpasi menunjukkan adanya fluktuasi di area submental. Radiografi periapikal menunjukkan lesi radiolusen difus di periapikal gigi 32, mengindikasikan pembengkakan mukosa periapikal fluktuatif kronis.",
        radiograf_asset_id = "rbxassetid://73200665510331",
        intraoral_asset_id = "rbxassetid://115927617022944"
    },
    ["case_019"] = {
        id = "case_019",
        kode_kasus = "ABS-19",
        kategori_lesi = "abses_periapikal",
        diagnosis_benar = "Abses Periapikal",
        elemen_gigi = "36",
        vignette_tes = "Seorang anak perempuan berusia 7 tahun datang dengan keluhan gigi geraham bawah kanan (elemen 85) berlubang dan disertai adanya benjolan serta saluran keluar nanah baik di dalam maupun di luar mulut yang tidak kunjung sembuh. Pemeriksaan objektif menunjukkan karies besar pada gigi 85, tes termal negatif, perkusi dan palpasi positif ringan di area furkasi. Radiograf periapikal menunjukkan lesi radiolusen difus di area furkasi gigi 85, dengan gutta-percha yang dimasukkan ke saluran sinus mencapai area furkasi.",
        radiograf_asset_id = "rbxassetid://106248021761835",
        intraoral_asset_id = "rbxassetid://135582175060356"
    },
    ["case_026"] = {
        id = "case_026",
        kode_kasus = "GRN-01",
        kategori_lesi = "granuloma_periapikal",
        diagnosis_benar = "Granuloma Periapikal",
        elemen_gigi = "14",
        vignette_tes = "Ny. Ratna, seorang perempuan berusia 40 tahun, datang dengan keluhan gigi geraham kecil atas kanan (elemen 14) yang sudah pernah dirawat saluran akar terasa tidak nyaman dan kadang nyeri ringan saat mengunyah. Pemeriksaan objektif menunjukkan gigi non-vital, perkusi dan palpasi negatif atau sedikit sensitif. Gambaran radiografik menunjukkan lesi radiolusen periapikal berbatas jelas non-kortikasi pada apeks gigi 14.",
        radiograf_asset_id = "rbxassetid://71993933353750",
        intraoral_asset_id = "rbxassetid://84243730614446"
    },
    ["case_027"] = {
        id = "case_027",
        kode_kasus = "GRN-02",
        kategori_lesi = "granuloma_periapikal",
        diagnosis_benar = "Granuloma Periapikal",
        elemen_gigi = "21",
        vignette_tes = "Seorang wanita berusia 61 tahun datang ke klinik gigi dengan keluhan pembengkakan tanpa nyeri di area gigi insisivus sentral kiri atas (elemen 21). Pemeriksaan klinis menunjukkan pembengkakan yang tidak fluktuatif. Tes termal pada gigi 21 menunjukkan hasil negatif, sedangkan tes perkusi dan palpasi menunjukkan respon negatif atau sedikit nyeri. Radiograf periapikal menunjukkan lesi radiolusen berbatas jelas non-kortikasi di area periapikal gigi 21.",
        radiograf_asset_id = "rbxassetid://110453479784241",
        intraoral_asset_id = "rbxassetid://74726599627296"
    },
    ["case_028"] = {
        id = "case_028",
        kode_kasus = "GRN-03",
        kategori_lesi = "granuloma_periapikal",
        diagnosis_benar = "Granuloma Periapikal",
        elemen_gigi = "12",
        vignette_tes = "Seorang pasien perempuan berusia 63 tahun datang dengan keluhan kehilangan gigi 12 dan berencana untuk pemasangan implan. Pada pemeriksaan radiografis pra-implan, ditemukan adanya lesi periapikal residual pada area gigi 12 yang hilang. Pasien tidak merasakan nyeri atau gejala akut lainnya pada area tersebut. Hasil pemeriksaan histopatologi setelah enukleasi lesi mengkonfirmasi diagnosis lesi periapikal kronis berbatas tegas non-kortikasi.",
        radiograf_asset_id = "rbxassetid://101743374192609",
        intraoral_asset_id = "rbxassetid://86966761357026"
    },
    ["case_029"] = {
        id = "case_029",
        kode_kasus = "GRN-04",
        kategori_lesi = "granuloma_periapikal",
        diagnosis_benar = "Granuloma Periapikal",
        elemen_gigi = "11",
        vignette_tes = "Ny. Ratna, seorang perempuan berusia 35 tahun, datang dengan keluhan nyeri tumpul persisten dan gusi bengkak pada gigi depan atas (elemen 11) yang sudah pernah dirawat saluran akar. Pemeriksaan objektif menunjukkan gingiva bengkak pada area anterior maksila, gigi 11 non-vital, sedikit sensitif terhadap perkusi, dan palpasi apeks sedikit nyeri. Radiograf periapikal menunjukkan lesi radiolusen besar pada area periapikal gigi 11, 12, dan 21 dengan batas tepi yang jelas namun tidak berkorteks.",
        radiograf_asset_id = "rbxassetid://132214317438633",
        intraoral_asset_id = "rbxassetid://133841074099897"
    },
    ["case_030"] = {
        id = "case_030",
        kode_kasus = "GRN-05",
        kategori_lesi = "granuloma_periapikal",
        diagnosis_benar = "Granuloma Periapikal",
        elemen_gigi = "12",
        vignette_tes = "Pasien perempuan, 25 tahun, datang dengan keluhan adanya benjolan/fistula di gusi depan atas dan perubahan warna gigi setelah riwayat trauma olahraga di masa lalu. Pemeriksaan klinis menunjukkan diskolorasi pada gigi 11 dan 21, serta adanya stoma fistula di area apikal antara gigi 11 dan 12. Gigi 12 memiliki riwayat perawatan saluran akar. Tes termal pada gigi 11 dan 12 kemungkinan negatif. Perkusi dan palpasi pada area periapikal gigi 12 dan 11 mungkin menunjukkan sedikit nyeri atau adanya fistula. Radiograf periapikal menunjukkan lesi radiolusen periapikal pada gigi 12 dengan riwayat perawatan saluran akar.",
        radiograf_asset_id = "rbxassetid://94158009636844",
        intraoral_asset_id = "rbxassetid://102757479542579"
    },
    ["case_031"] = {
        id = "case_031",
        kode_kasus = "GRN-06",
        kategori_lesi = "granuloma_periapikal",
        diagnosis_benar = "Granuloma Periapikal",
        elemen_gigi = "11",
        vignette_tes = "Seorang pasien laki-laki berusia 18 tahun datang untuk pemeriksaan rutin setelah mengalami trauma avulsi pada gigi depan atas (elemen 11) delapan tahun yang lalu. Pasien mengeluhkan perubahan warna pada gigi tersebut. Pemeriksaan klinis menunjukkan gigi 11 non-vital dengan kalsifikasi saluran akar. Pemeriksaan radiograf periapikal menunjukkan adanya lesi radiolusen berbatas jelas non-kortikasi di area periapikal gigi 11.",
        radiograf_asset_id = "rbxassetid://91230769647120",
        intraoral_asset_id = "rbxassetid://71427440178212"
    },
    ["case_032"] = {
        id = "case_032",
        kode_kasus = "GRN-07",
        kategori_lesi = "granuloma_periapikal",
        diagnosis_benar = "Granuloma Periapikal",
        elemen_gigi = "21",
        vignette_tes = "Seorang pasien perempuan berusia 13 tahun dirujuk ke bagian endodontik setelah penanganan darurat awal akibat trauma gigi. Pasien mengeluhkan gigi depan atas kiri (elemen 21) terasa tidak nyaman dan telah didiagnosis dengan periodontitis apikal persisten. Pemeriksaan klinis menunjukkan gigi 21 non-vital, tidak ada respon terhadap tes termal, dan perkusi/palpasi mungkin sedikit sensitif atau negatif. Radiograf periapikal menunjukkan lesi radiolusen berbatas relatif jelas di area periapikal gigi 21.",
        radiograf_asset_id = "rbxassetid://137186186896874",
        intraoral_asset_id = "rbxassetid://96679808843154"
    },
    ["case_051"] = {
        id = "case_051",
        kode_kasus = "KIS-01",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "21",
        vignette_tes = "Seorang pasien laki-laki berusia 24 tahun datang dengan keluhan gigi depan atas (11, 12, 21, 22) patah akibat riwayat trauma kecelakaan lalu lintas. Pemeriksaan klinis menunjukkan fraktur Ellis kelas IV pada gigi 11, 12, 21, dan 22. Meskipun telah dilakukan perawatan saluran akar non-bedah, terdapat eksudasi persisten dari gigi 21 dan 22. Radiograf periapikal menunjukkan lesi radiolusen periapikal yang luas pada regio anterior maksila.",
        radiograf_asset_id = "rbxassetid://96012844688967",
        intraoral_asset_id = "rbxassetid://93359282917628"
    },
    ["case_052"] = {
        id = "case_052",
        kode_kasus = "KIS-02",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "36",
        vignette_tes = "Seorang anak perempuan berusia 6 tahun datang dengan keluhan utama pembengkakan pada rahang atas kanan belakang. Pemeriksaan klinis menunjukkan pembengkakan difus di area gigi 55. Gigi 55 menunjukkan respon negatif terhadap tes termal dan perkusi ringan positif. Palpasi di area tersebut positif. Radiograf periapikal menunjukkan lesi radiolusen unilokuler berbatas jelas dengan kortikasi di sekitar apeks gigi 55 dan 16.",
        radiograf_asset_id = "rbxassetid://118015608638654",
        intraoral_asset_id = "rbxassetid://139995953220986"
    },
    ["case_053"] = {
        id = "case_053",
        kode_kasus = "KIS-03",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "36",
        vignette_tes = "Seorang pasien perempuan berusia 45 tahun datang dengan keluhan nyeri persisten pada gigi geraham bawah kiri (elemen 36) yang sebelumnya telah dirawat saluran akar dan direstorasi dengan mahkota metal-keramik. Pemeriksaan klinis menunjukkan gigi non-vital dan sedikit sensitif terhadap perkusi dan palpasi. Radiograf periapikal dan CBCT menunjukkan adanya lesi radiolusen berbatas jelas dan berkortikasi di area periapikal gigi 36, berukuran besar dan berdekatan dengan nervus alveolaris inferior.",
        radiograf_asset_id = "rbxassetid://74416118068396",
        intraoral_asset_id = "rbxassetid://130395502506966"
    },
    ["case_054"] = {
        id = "case_054",
        kode_kasus = "KIS-04",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "22",
        vignette_tes = "Seorang anak perempuan berusia 10 tahun datang dengan keluhan utama pembengkakan berulang pada area gigi insisivus lateral kiri rahang atas (elemen 22). Pemeriksaan klinis menunjukkan gigi 22 mengalami malformasi dengan mobilitas derajat II dan pembengkakan gingiva yang berfluktuasi. Tes termal menunjukkan respon negatif, mengindikasikan nekrosis pulpa. Radiograf periapikal menunjukkan lesi radiolusen besar di periapikal gigi 22 dengan apeks yang belum matur dan gambaran dens invaginatus.",
        radiograf_asset_id = "rbxassetid://133199570841826",
        intraoral_asset_id = "rbxassetid://128793166553487"
    },
    ["case_055"] = {
        id = "case_055",
        kode_kasus = "KIS-05",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "26",
        vignette_tes = "Seorang pasien perempuan berusia 20 tahun datang dengan keluhan nyeri dan ketidaknyamanan jangka panjang pada gigi 26 (geraham pertama rahang atas kiri) saat mengunyah. Pemeriksaan klinis menunjukkan adanya restorasi sementara pada gigi tersebut, nyeri saat perkusi, namun tidak ada pembengkakan gingiva. Riwayat perawatan saluran akar menunjukkan adanya instrumen patah yang keluar dari apeks akar mesiobukal. Radiograf periapikal dan CBCT mengkonfirmasi adanya instrumen nikel-titanium yang patah dan keluar dari apeks akar ke daerah periapikal berdekatan dengan dasar sinus maksila, disertai area radiolusen periapikal.",
        radiograf_asset_id = "rbxassetid://133024958309363",
        intraoral_asset_id = "rbxassetid://116597754563769"
    },
    ["case_056"] = {
        id = "case_056",
        kode_kasus = "KIS-06",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "11",
        vignette_tes = "Tn. Surya, seorang laki-laki berusia 49 tahun, datang dengan keluhan utama pembengkakan tanpa rasa sakit di daerah anterior rahang atas. Pemeriksaan klinis menunjukkan gigi 11 berubah warna dan terdapat pembengkakan lunak, tidak nyeri tekan, serta berfluktuasi di regio anterior maksila. Tes termal pada gigi 11 menunjukkan hasil negatif. Pemeriksaan radiografis periapikal mengungkapkan adanya lesi radiolusen di daerah periapikal gigi 11.",
        radiograf_asset_id = "rbxassetid://135554956212534",
        intraoral_asset_id = "rbxassetid://113109112559175"
    },
    ["case_057"] = {
        id = "case_057",
        kode_kasus = "KIS-07",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "11",
        vignette_tes = "Seorang pasien laki-laki berusia 35 tahun datang dengan keluhan nyeri pada gigi depan rahang atas dan sedikit pembengkakan di area tersebut. Pemeriksaan klinis menunjukkan diskolorasi pada mahkota gigi 11 dan sedikit edema pada mukosa bukal. Tes termal pada gigi 11 kemungkinan negatif, menunjukkan pulpa non-vital. Perkusi dan palpasi mungkin menunjukkan respon positif ringan hingga sedang. Radiograf periapikal menunjukkan lesi radiolusen berbatas jelas di area periapikal gigi 11.",
        radiograf_asset_id = "rbxassetid://125763897687638",
        intraoral_asset_id = "rbxassetid://82331003970523"
    },
    ["case_058"] = {
        id = "case_058",
        kode_kasus = "KIS-08",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "11",
        vignette_tes = "Seorang pasien perempuan berusia 16 tahun datang dengan keluhan utama pembengkakan pada sisi kanan wajah, disertai nanah dan nyeri pada mukosa labial di area gigi seri kanan atas (elemen 11). Pemeriksaan objektif menunjukkan pembengkakan intraoral dengan fluktuasi dan pus. Gigi 11 menunjukkan respon negatif terhadap tes termal dan positif terhadap perkusi serta palpasi. Gambaran radiografik menunjukkan lesi radiolusen besar, berbatas jelas, meluas dari periapikal gigi 11 hingga gigi 13.",
        radiograf_asset_id = "rbxassetid://106316016046053",
        intraoral_asset_id = "rbxassetid://122651129286971"
    },
    ["case_059"] = {
        id = "case_059",
        kode_kasus = "KIS-09",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "22",
        vignette_tes = "Seorang anak perempuan berusia 9 tahun datang dengan keluhan gigi depan atas kiri (elemen 22) berubah warna dan terdapat pembengkakan pada gusi di area tersebut. Pemeriksaan klinis menunjukkan adanya pit palatal yang dalam dan diskolorasi pada gigi 22. Tes termal menunjukkan respon negatif, perkusi negatif, dan palpasi negatif. Radiograf periapikal menunjukkan lesi radiolusen berbatas jelas dengan kortikasi di area periapikal gigi 22.",
        radiograf_asset_id = "rbxassetid://110336764959023",
        intraoral_asset_id = "rbxassetid://105368246369500"
    },
    ["case_061"] = {
        id = "case_061",
        kode_kasus = "KIS-11",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "12",
        vignette_tes = "Seorang pasien laki-laki berusia 28 tahun datang dengan keluhan utama keluar nanah dan pembengkakan yang hilang timbul pada area gigi 12 rahang atas kanan, setelah riwayat trauma gigi. Pemeriksaan objektif menunjukkan gigi 12 non-vital pada tes termal, palpasi positif dengan pembengkakan, dan perkusi negatif. Radiograf periapikal menunjukkan lesi radiolusen besar, berbatas jelas dengan kortikasi tipis pada area periapikal gigi 12.",
        radiograf_asset_id = "rbxassetid://86147551314062",
        intraoral_asset_id = "rbxassetid://95362832039275"
    },
    ["case_062"] = {
        id = "case_062",
        kode_kasus = "KIS-12",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "11",
        vignette_tes = "Ny. Siti, 38 tahun, datang dengan keluhan pembengkakan pada gusi depan atas yang disertai rasa tidak nyaman ringan. Gigi elemen 11 dan 21 menunjukkan non-vitalitas pada tes termal. Perkusi dan palpasi pada area apikal gigi 11 dan 21 menunjukkan sedikit sensitivitas. Radiograf periapikal menunjukkan lesi radiolusen unilokuler besar dengan batas tepi sklerotik yang jelas pada regio periapikal gigi 11 dan 21.",
        radiograf_asset_id = "rbxassetid://90645588394243",
        intraoral_asset_id = "rbxassetid://125488490960763"
    },
    ["case_063"] = {
        id = "case_063",
        kode_kasus = "KIS-13",
        kategori_lesi = "kista_radikuler",
        diagnosis_benar = "Kista Radikuler",
        elemen_gigi = "11",
        vignette_tes = "Seorang pasien perempuan berusia 32 tahun datang dengan keluhan utama nyeri dan keluar nanah di area gigi depan kanan atas sejak 2 bulan yang lalu. Pemeriksaan klinis menunjukkan adanya pembengkakan dan keluarnya nanah di regio anterior rahang atas. Tes termal pada gigi 11 dan 12 kemungkinan negatif, dan perkusi serta palpasi mungkin positif. Gambaran radiograf periapikal menunjukkan lesi radiolusen periapikal yang berbatas jelas pada gigi 11 dan 12.",
        radiograf_asset_id = "rbxassetid://80249610052748",
        intraoral_asset_id = "rbxassetid://84455531699147"
    },
}


-- Helper: Fisher-Yates Shuffle
local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

-- Stratified Random Sampling: 3 Abses, 3 Granuloma, 3 Kista
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
    for i = 1, math.min(3, #poolAbses) do
        table.insert(selected, poolAbses[i])
    end
    for i = 1, math.min(3, #poolGranuloma) do
        table.insert(selected, poolGranuloma[i])
    end
    for i = 1, math.min(3, #poolKista) do
        table.insert(selected, poolKista[i])
    end

    -- Acak urutan ke-9 soal agar kategori penyakit tidak berurutan
    shuffle(selected)
    return selected
end

return CasePool
