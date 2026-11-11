with open('CasePool.luau', 'r', encoding='utf-8') as f:
    source = f.read()

with open('inject_casepool.luau', 'w', encoding='utf-8') as f:
    f.write('local rep = game:GetService("ReplicatedStorage")\n')
    f.write('local folder = rep:WaitForChild("PreTestSystem")\n')
    f.write('local mod = folder:FindFirstChild("CasePool")\n')
    f.write('if not mod then\n')
    f.write('    mod = Instance.new("ModuleScript")\n')
    f.write('    mod.Name = "CasePool"\n')
    f.write('    mod.Parent = folder\n')
    f.write('end\n')
    f.write('mod.Source = [==[\n')
    f.write(source)
    f.write('\n]==]\n')
    f.write('return "CasePool updated successfully: " .. tostring(#mod.Source) .. " bytes"\n')

print("Done preparing inject_casepool.luau")

