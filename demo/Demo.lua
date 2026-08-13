local function fetch(url)
	if type(game.HttpGet) == "function" then
		local ok, body = pcall(function() return game:HttpGet(url) end)
		if ok and type(body) == "string" then return body end
	end
	local environment = (getgenv and getgenv()) or getfenv()
	local requester = environment.request or environment.http_request or (environment.syn and environment.syn.request)
	assert(type(requester) == "function", "RereGui: executor has no HTTP request function")
	local response = requester({Url = url, Method = "GET"})
	assert(response and response.Body, "RereGui: HTTP request returned no body")
	return response.Body
end

local compiler = loadstring or load
assert(type(compiler) == "function", "RereGui: executor must expose loadstring or load")
local source = fetch("https://raw.githubusercontent.com/x8lua/RereGui/main/src/RereGui.lua")
local chunk = compiler(source)
assert(type(chunk) == "function", "RereGui: compiler returned no chunk")
local RereGui = chunk()

local window = RereGui.new("Dear RereGui Demo", {
	Size = UDim2.fromOffset(650, 430),
	ToggleKey = Enum.KeyCode.RightShift,
})

local demo = window:Tab("Demo")
demo:Menu("Menu", {
	{Text = "Print hello", Callback = function() print("Hello from RereGui") end},
	{Text = "Tabs window", Callback = function() print("Use the Tabs page") end},
	{Text = "Configuration", Callback = function() print("Settings ready") end},
})
demo:Label("Dear RereGui (0.1.0)")
for _, title in ipairs({"Help", "Configuration", "Windows", "Widgets", "Popups & child windows", "Tables & Columns"}) do
	local group = demo:CollapsingHeader(title, false)
	group:Label("Content for " .. title)
end

local tabs = window:Tab("Tabs")
tabs:Label("This is the Avocado tab!")
tabs:Separator()
tabs:Checkbox("Checkbox", true, function(value) print("Checkbox:", value) end)
tabs:Slider("Slider Int", 0, 10, 5, function(value) print("Slider:", value) end)
tabs:InputText("Input text", "Hello world!", function(value) print("Input:", value) end)
tabs:Button("Print hello", function() print("Hello world!") end)
