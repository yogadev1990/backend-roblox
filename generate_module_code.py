import json

with open('dataset.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

compact = []
for c in data:
    compact.append({
        'id': c['id'],
        'kode_kasus': c['kode_kasus'],
        'kategori_lesi': c['kategori_lesi'],
        'diagnosis_benar': c['diagnosis_benar'],
        'elemen_gigi': c.get('elemen_gigi', ''),
        'vignette_tes': c['vignette_tes'],
        'radiograf_local': c.get('assets', {}).get('citra_radiograf', ''),
        'intraoral_local': c.get('assets', {}).get('foto_intraoral', ''),
        'radiograf_asset_id': '',
        'intraoral_asset_id': ''
    })

json_str = json.dumps(compact, ensure_ascii=False)

module_code = f'''local HttpService = game:GetService("HttpService")

--[[
    CasePool.luau
    Koleksi 41 Kasus Medis Pre-test (Stratified Random Sampling Engine)
    - abses_periapikal: 19 kasus (case_001 s.d. case_019 | ABS-01 s.d. ABS-19)
    - granuloma_periapikal: 8 kasus (case_026 s.d. case_033 | GRN-01 s.d. GRN-08)
    - kista_radikuler: 14 kasus (case_051 s.d. case_064 | KIS-01 s.d. KIS-14)
--]]

local CasePool = {{}}

local RAW_JSON = [==[{json_str}]==]

local decoded = HttpService:JSONDecode(RAW_JSON)
CasePool.List = decoded
CasePool.ById = {{}}
CasePool.ByCategory = {{
	abses_periapikal = {{}},
	granuloma_periapikal = {{}},
	kista_radikuler = {{}}
}}

for _, item in ipairs(decoded) do
	CasePool.ById[item.id] = item
	if CasePool.ByCategory[item.kategori_lesi] then
		table.insert(CasePool.ByCategory[item.kategori_lesi], item)
	end
end

-- =========================================================================
-- LOGIKA RANDOM SAMPLING (FISHER-YATES SHUFFLE WITHOUT REPLACEMENT)
-- =========================================================================

-- Kocok array acak (Fisher-Yates)
function CasePool.Shuffle(tbl)
	local cloned = table.clone(tbl)
	local n = #cloned
	for i = n, 2, -1 do
		local j = math.random(1, i)
		cloned[i], cloned[j] = cloned[j], cloned[i]
	end
	return cloned
end

-- Penarikan sampel tanpa pengembalian (Sampling Without Replacement)
function CasePool.SampleWithoutReplacement(tbl, count)
	local shuffled = CasePool.Shuffle(tbl)
	local result = {{}}
	for i = 1, math.min(count, #shuffled) do
		table.insert(result, shuffled[i])
	end
	return result
end

-- =========================================================================
-- GENERATE STRATIFIED PRE-TEST: TEPAT 9 BUTIR SOAL
-- Komposisi Wajib:
--   * 3 Kasus abses_periapikal
--   * 3 Kasus granuloma_periapikal
--   * 3 Kasus kista_radikuler
-- =========================================================================
function CasePool.GenerateStratifiedPretest(excludeIds)
	excludeIds = excludeIds or {{}}
	local excludeMap = {{}}
	for _, id in ipairs(excludeIds) do
		excludeMap[id] = true
	end

	local function getAvailable(category)
		local list = CasePool.ByCategory[category] or {{}}
		local available = {{}}
		for _, c in ipairs(list) do
			if not excludeMap[c.id] then
				table.insert(available, c)
			end
		end
		-- Jika kasus yang tersedia kurang dari 3 (misal sudah terpakai semua), fallback ke seluruh list
		if #available < 3 then
			return list
		end
		return available
	end

	local absesPool = getAvailable("abses_periapikal")
	local granuPool = getAvailable("granuloma_periapikal")
	local kistaPool = getAvailable("kista_radikuler")

	-- 1. Tarik acak 3 kasus per kategori tanpa pengembalian
	local selectedAbses = CasePool.SampleWithoutReplacement(absesPool, 3)
	local selectedGranu = CasePool.SampleWithoutReplacement(granuPool, 3)
	local selectedKista = CasePool.SampleWithoutReplacement(kistaPool, 3)

	-- 2. Gabungkan 9 kasus
	local combined9 = {{}}
	for _, c in ipairs(selectedAbses) do table.insert(combined9, c) end
	for _, c in ipairs(selectedGranu) do table.insert(combined9, c) end
	for _, c in ipairs(selectedKista) do table.insert(combined9, c) end

	-- 3. Kocok ulang (shuffle) ke-9 kasus agar urutan penyakit tidak dapat ditebak
	local finalShuffled9 = CasePool.Shuffle(combined9)

	return finalShuffled9
end

return CasePool
'''

with open('casepool_module.luau', 'w', encoding='utf-8') as f:
    f.write(module_code)

print("Saved casepool_module.luau, size:", len(module_code))

