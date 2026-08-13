# RereGui

`RereGui` is a compact, Dear ImGui-inspired Roblox executor UI library. It recreates the dense desktop presentation from the supplied ReGui reference without depending on the deleted project.

## Initial feature set

- Draggable, closable windows with a configurable toggle key
- Tab bar and independently scrollable pages
- Menus, labels, buttons, separators, collapsible headers
- Checkboxes, numeric sliders, and text inputs
- One centrally editable dark/blue theme

## Executor usage

Load the library from an executor with HTTP and either `loadstring` or `load`:

```lua
local compiler = loadstring or load
local source = game:HttpGet("https://raw.githubusercontent.com/x8lua/RereGui/main/src/RereGui.lua")
local chunk = assert(compiler(source))
local RereGui = chunk()

local window = RereGui.new("My window")
local tab = window:Tab("Main")
tab:Checkbox("Enabled", true, function(enabled)
    print(enabled)
end)
```

The library parents to `gethui()` when available. On executors without `gethui`, it uses `syn.protect_gui` when exposed and parents to `CoreGui`. An explicit `Parent` option remains available.

The default visibility key is `RightShift`; set `ToggleKey` in `RereGui.new` to change it. See `demo/Demo.lua` for the full executor example.

## Repository layout

```
src/RereGui.lua      executor-loadable library
demo/Demo.lua        complete executor example
tests/smoke.ps1      repository smoke checks
```
