$module = Get-Content "$PSScriptRoot\..\src\RereGui.lua" -Raw
$required = @('function RereGui.new', 'function Window:Tab', 'function Tab:Checkbox', 'function Tab:Slider', 'function Tab:InputText', 'function Tab:CollapsingHeader', 'return RereGui')
foreach ($marker in $required) {
    if (-not $module.Contains($marker)) { throw "Missing expected public primitive: $marker" }
}
Write-Output 'RereGui smoke test passed: all initial public primitives are present.'
