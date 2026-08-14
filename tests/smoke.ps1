$module = Get-Content "$PSScriptRoot\..\src\RereGui.lua" -Raw
$required = @(
    'Version = "1.3.2"',
    'function ReGui:Init(Overwrites)',
    'game:GetObjects("rbxassetid://" .. tostring(self.PrefabsId))[1]',
    'function ReGui:DefineElement(Name: string, Data)',
    'function ReGui:MakeDraggable(Config: MakeDraggableFlags)',
    'function ReGui:MakeResizable(Config: MakeResizableFlags)',
    'ReGui:DefineElement("Dropdown"',
    'ReGui:DefineElement("Checkbox"',
    'ReGui:DefineElement("InputText"',
    'ReGui:DefineElement("Table"',
    'ReGui:DefineElement("CollapsingHeader"',
    'ReGui:DefineElement("SliderInt"',
    'ReGui:DefineElement("Combo"',
    'ReGui:DefineElement("TabsWindow"',
    'ReGui:DefineElement("PopupModal"',
    'GenerateMultiInput("InputInt2"',
    'GenerateColor3Input("InputColor3"',
    'GenerateCFrameInput("InputCFrame"',
    'return ReGui'
)
foreach ($marker in $required) {
    if (-not $module.Contains($marker)) { throw "Missing ReGui API marker: $marker" }
}
$demo = Get-Content "$PSScriptRoot\..\demo\Demo.lua" -Raw
$elements = Get-Content "$PSScriptRoot\..\ELEMENTS.md" -Raw
if (-not $demo.Contains('ReGui:Init()')) { throw 'Demo does not initialize ReGui.' }
if (-not $demo.Contains('window:CreateTab')) { throw 'Demo does not create tabs.' }
if (-not $elements.Contains('PopupModal')) { throw 'Element index is incomplete.' }
Write-Output 'RereGui full-source smoke test passed: initialization, prefab fallback, direct elements, and generated variants are present.'
