import json

with open('dataset.json', 'r', encoding='utf-8') as f:
    dataset = json.load(f)

cases1 = dataset[:18]
cases2 = dataset[18:]

def make_chunk_cases(cases):
    lines = []
    for c in cases:
        cid = c['id']
        kode = c.get('kode_kasus', '')
        kat = c.get('kategori_lesi', '')
        diag = c.get('diagnosis_benar', '')
        gigi = c.get('elemen_gigi', '')
        vig = c.get('vignette_tes', '').replace('"', '\\"').replace('\n', ' ')
        rad_asset = c['roblox_assets']['radiograf_asset_id']
        intra_asset = c['roblox_assets']['intraoral_asset_id']
        lines.append(f'CasePool.Cases["{cid}"] = {{')
        lines.append(f'    id = "{cid}", kode_kasus = "{kode}", kategori_lesi = "{kat}", diagnosis_benar = "{diag}", elemen_gigi = "{gigi}",')
        lines.append(f'    vignette_tes = "{vig}",')
        lines.append(f'    radiograf_asset_id = "{rad_asset}", intraoral_asset_id = "{intra_asset}"')
        lines.append('}')
    return '\n'.join(lines)

with open('chunk1.luau', 'w', encoding='utf-8') as f:
    f.write('''local rep = game:GetService("ReplicatedStorage")
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
''' + make_chunk_cases(cases1) + '''
]==]

mod.Source = header .. chunk1
return "Chunk 1 injected (" .. tostring(#mod.Source) .. " bytes)"
''')

with open('chunk2.luau', 'w', encoding='utf-8') as f:
    f.write('''local rep = game:GetService("ReplicatedStorage")
local folder = rep:WaitForChild("PreTestSystem")
local mod = folder:WaitForChild("CasePool")

local chunk2 = [==[

''' + make_chunk_cases(cases2) + '''

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
''')

print("Chunks 1 & 2 ready.")

