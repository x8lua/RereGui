$module = Get-Content "$PSScriptRoot\..\src\RereGui.lua" -Raw
$required = @('local function parentGui', 'environment.gethui', 'synapse.protect_gui', 'game:GetService("CoreGui")', 'function RereGui.new', 'function Window:Tab', 'function Tab:Checkbox', 'function Tab:Slider', 'function Tab:InputText', 'function Tab:CollapsingHeader', 'return RereGui')
foreach ($marker in $required) {
    if (-not $module.Contains($marker)) { throw "Missing expected public primitive: $marker" }
}
$readme = Get-Content "$PSScriptRoot\..\README.md" -Raw
$demo = Get-Content "$PSScriptRoot\..\demo\Demo.lua" -Raw
if (-not $demo.Contains('local compiler = loadstring or load')) { throw 'Demo is missing portable executor compiler usage.' }
if (-not $readme.Contains('local compiler = loadstring or load')) { throw 'README is missing portable executor compiler usage.' }
Write-Output 'RereGui smoke test passed: executor parenting, portable loader, and public primitives are present.'
