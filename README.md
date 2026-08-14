# RereGui

`RereGui` now ships the complete ReGui 1.3.2 source supplied by the project owner, including the original MIT attribution and all registered widgets.

## Executor usage

```lua
local compiler = loadstring or load
local source = game:HttpGet("https://raw.githubusercontent.com/x8lua/RereGui/main/src/RereGui.lua")
local chunk = assert(compiler(source))
local ReGui = chunk()

ReGui:Init()

local window = ReGui:TabsWindow({
    Title = "My window",
    Size = UDim2.fromOffset(640, 420),
})

local tab = window:CreateTab({Name = "Main"})
tab:Checkbox({Label = "Enabled", Value = true})
```

`Init()` creates the ReGui container and loads the required prefab asset (`71968920594655`) when the source is used through an executor. The module first checks for embedded/local prefabs before loading that asset.

Run the complete official ReGui demo, including configuration, widget, popup, modal, table, tab, viewport, and input examples:

```lua
local compiler = loadstring or load
local source = game:HttpGet("https://raw.githubusercontent.com/x8lua/RereGui/main/demo/Demo.lua")
assert(compiler(source))()
```

## Elements

See [ELEMENTS.md](ELEMENTS.md) for every direct and generated element in the complete source.

## Layout

```
src/RereGui.lua      complete ReGui source
demo/Demo.lua        executor demo
ELEMENTS.md          full element index
```
