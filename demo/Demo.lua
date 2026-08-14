local compiler = loadstring or load
assert(type(compiler) == "function", "ReGui: executor must expose loadstring or load")
local source = game:HttpGet("https://raw.githubusercontent.com/x8lua/RereGui/main/src/RereGui.lua")
local chunk = assert(compiler(source))
local ReGui = chunk()

ReGui:Init()

local window = ReGui:TabsWindow({
	Title = "Dear ReGui Demo",
	Size = UDim2.fromOffset(650, 430),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
})

local demo = window:CreateTab({Name = "Demo"})
demo:Label({Text = "Dear ReGui says hello! (1.3.2)"})
for _, title in ipairs({"Help", "Configuration", "Window options", "Widgets", "Popups & child windows", "Tables & Columns"}) do
	local section = demo:CollapsingHeader({Title = title})
	section:Label({Text = "Content for " .. title})
end

local tabs = window:CreateTab({Name = "Tabs"})
tabs:Label({Text = "This is the Avocado tab!"})
tabs:Separator({})
tabs:Checkbox({Label = "Checkbox", Value = true})
tabs:SliderInt({Label = "Slider Int", Minimum = 0, Maximum = 10, Value = 5})
tabs:InputText({Label = "Input text", Text = "Hello world!"})
tabs:Button({Text = "Print hello", Callback = function() print("Hello world!") end})
