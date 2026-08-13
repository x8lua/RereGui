# RereGui

`RereGui` is a compact, Dear ImGui-inspired Roblox UI library. It recreates the dense desktop presentation from the supplied ReGui reference without depending on the deleted project.

## Initial feature set

- Draggable, closable windows with a configurable toggle key
- Tab bar and independently scrollable pages
- Menus, labels, buttons, separators, collapsible headers
- Checkboxes, numeric sliders, and text inputs
- One centrally editable dark/blue theme

## Install

Copy `src/RereGui.lua` into Roblox Studio as a `ModuleScript`, then require it from a `LocalScript`. `demo/Demo.client.lua` is a runnable reference implementation.

```lua
local RereGui = require(path.to.RereGui)
local window = RereGui.new("My window")
local tab = window:Tab("Main")
tab:Checkbox("Enabled", true, function(enabled)
    print(enabled)
end)
```

The default visibility key is `RightShift`; set `ToggleKey` in `RereGui.new` to change it.

## Repository layout

```
src/RereGui.lua      library ModuleScript
demo/Demo.client.lua sample LocalScript
tests/smoke.ps1      repository smoke checks
```
