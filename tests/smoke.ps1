$module = Get-Content "$PSScriptRoot\..\src\RereGui.lua" -Raw
$required = @('Enum.FontWeight.Regular', 'textObject.FontFace = RegularMono', 'expanded and "▼" or "▶"', 'local function parentGui', 'environment.gethui', 'synapse.protect_gui', 'game:GetService("CoreGui")', 'function RereGui.new', 'function Window:Tab', 'function Tab:Checkbox', 'function Tab:Slider', 'function Tab:InputText', 'function Tab:CollapsingHeader', 'return RereGui')
foreach ($marker in $required) {
    if (-not $module.Contains($marker)) { throw "Missing expected public primitive: $marker" }
}
$readme = Get-Content "$PSScriptRoot\..\README.md" -Raw
$demo = Get-Content "$PSScriptRoot\..\demo\Demo.lua" -Raw
if (-not $demo.Contains('local compiler = loadstring or load')) { throw 'Demo is missing portable executor compiler usage.' }
if (-not $readme.Contains('local compiler = loadstring or load')) { throw 'README is missing portable executor compiler usage.' }
if (-not $demo.Contains('local chunk = compiler(source)')) { throw 'Demo is missing unambiguous compiler invocation.' }
if ($module -match '(?m)^\s*\(') { throw 'Module contains a statement beginning with a parenthesized expression, which is ambiguous in Luau.' }
Write-Output 'RereGui smoke test passed: executor parenting, portable loader, and public primitives are present.'
