const fs = require('fs');
const s = fs.readFileSync('C:/Users/Administrator/.gemini/antigravity/brain/95f4b483-5905-4b66-baba-ef68451711ed/.system_generated/steps/1072/output.txt', 'utf8');
const script = 'local rs = game:GetService("ReplicatedStorage")\nlocal cp = rs:FindFirstChild("CasePool") or Instance.new("ModuleScript", rs)\ncp.Name = "CasePool"\ncp.Source = [====[\n' + s + '\n]====]\nreturn "CasePool injected successfully!"';
fs.writeFileSync('C:/Users/Administrator/.gemini/antigravity/brain/95f4b483-5905-4b66-baba-ef68451711ed/scratch/inject_cp.luau', script, 'utf8');
console.log('Done, length:', script.length);

