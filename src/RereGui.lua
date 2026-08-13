--!strict
-- RereGui: compact Dear ImGui-inspired controls for Roblox.

local RereGui = {}
RereGui.Version = "0.1.0"

local UserInputService = game:GetService("UserInputService")

export type Theme = {
	WindowBg: Color3, Border: Color3, TitleBg: Color3, TitleBgInactive: Color3,
	TabBg: Color3, TabActive: Color3, TabHover: Color3, FrameBg: Color3,
	FrameHover: Color3, Accent: Color3, AccentHover: Color3, Text: Color3,
	TextMuted: Color3, Header: Color3, HeaderHover: Color3,
}

RereGui.Theme = {
	WindowBg = Color3.fromRGB(17, 22, 29), Border = Color3.fromRGB(54, 72, 91),
	TitleBg = Color3.fromRGB(38, 82, 126), TitleBgInactive = Color3.fromRGB(32, 47, 64),
	TabBg = Color3.fromRGB(25, 35, 47), TabActive = Color3.fromRGB(48, 89, 132),
	TabHover = Color3.fromRGB(39, 62, 87), FrameBg = Color3.fromRGB(20, 31, 43),
	FrameHover = Color3.fromRGB(29, 49, 71), Accent = Color3.fromRGB(42, 114, 181),
	AccentHover = Color3.fromRGB(63, 137, 204), Text = Color3.fromRGB(232, 238, 245),
	TextMuted = Color3.fromRGB(164, 180, 195), Header = Color3.fromRGB(35, 76, 117),
	HeaderHover = Color3.fromRGB(48, 96, 143),
} :: Theme

local function make(className: string, properties: {[string]: any}): Instance
	local object = Instance.new(className)
	local writable = object :: any
	for property, value in pairs(properties) do
		writable[property] = value
	end
	return object
end

local function text(object: GuiObject, value: string, size: number?)
	local textObject = object :: any
	textObject.Font = Enum.Font.Code
	textObject.Text = value
	textObject.TextSize = size or 14
	textObject.TextColor3 = RereGui.Theme.Text
end

local function label(parent: Instance, value: string, width: number?): TextLabel
	local item = make("TextLabel", {
		Size = UDim2.new(0, width or 0, 0, 21), AutomaticSize = width and Enum.AutomaticSize.None or Enum.AutomaticSize.X,
		BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = parent,
	}) :: TextLabel
	text(item, value)
	return item
end

local function addList(parent: Instance, padding: number): UIListLayout
	return make("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, padding), Parent = parent}) :: UIListLayout
end

local function parentGui(gui: ScreenGui, explicitParent: Instance?)
	if explicitParent then
		gui.Parent = explicitParent
		return
	end

	local environment = getfenv()
	local getHiddenUi = environment.gethui
	if type(getHiddenUi) == "function" then
		local ok, hiddenUi = pcall(getHiddenUi)
		if ok and typeof(hiddenUi) == "Instance" then
			gui.Parent = hiddenUi
			return
		end
	end

	local synapse = environment.syn
	if type(synapse) == "table" and type(synapse.protect_gui) == "function" then
		pcall(synapse.protect_gui, gui)
	end
	gui.Parent = game:GetService("CoreGui")
end

local function drag(frame: GuiObject, handle: GuiObject)
	local active = false
	local startPointer = Vector2.zero
	local startPosition = frame.Position
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			active, startPointer, startPosition = true, input.Position, frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - startPointer
			frame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then active = false end
	end)
end

local Window = {}
Window.__index = Window
local Tab = {}
Tab.__index = Tab

function RereGui.new(title: string, options: {Size: UDim2?, Position: UDim2?, Parent: Instance?, ToggleKey: Enum.KeyCode?}?)
	options = options or {}
	local gui = make("ScreenGui", {Name = "RereGui", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}) :: ScreenGui
	parentGui(gui, options.Parent)
	local frame = make("Frame", {
		Name = "Window", Size = options.Size or UDim2.fromOffset(640, 420), Position = options.Position or UDim2.new(0.5, -320, 0.5, -210),
		BackgroundColor3 = RereGui.Theme.WindowBg, BorderColor3 = RereGui.Theme.Border, BorderSizePixel = 1, Active = true, Parent = gui,
	}) :: Frame
	make("UISizeConstraint", {MinSize = Vector2.new(310, 170), MaxSize = Vector2.new(1100, 760), Parent = frame})
	local titleBar = make("TextButton", {Name = "TitleBar", Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = RereGui.Theme.TitleBg, BorderSizePixel = 0, AutoButtonColor = false, Text = "", Parent = frame}) :: TextButton
	drag(frame, titleBar)
	local collapse = make("TextButton", {Size = UDim2.fromOffset(24, 24), Position = UDim2.fromOffset(2, 1), BackgroundTransparency = 1, AutoButtonColor = false, Parent = titleBar}) :: TextButton
	text(collapse, "v", 18)
	local titleLabel = label(titleBar, title)
	titleLabel.Size, titleLabel.Position = UDim2.new(1, -58, 1, 0), UDim2.fromOffset(28, 0)
	local close = make("TextButton", {Size = UDim2.fromOffset(25, 25), Position = UDim2.new(1, -27, 0, 1), BackgroundTransparency = 1, AutoButtonColor = false, Parent = titleBar}) :: TextButton
	text(close, "x", 19)
	local tabs = make("Frame", {Name = "Tabs", Size = UDim2.new(1, -10, 0, 25), Position = UDim2.fromOffset(5, 30), BackgroundColor3 = RereGui.Theme.FrameBg, BorderColor3 = RereGui.Theme.Border, Parent = frame}) :: Frame
	make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = tabs})
	local content = make("Frame", {Name = "Content", Size = UDim2.new(1, -10, 1, -65), Position = UDim2.fromOffset(5, 60), BackgroundTransparency = 1, ClipsDescendants = true, Parent = frame}) :: Frame
	local self = setmetatable({Gui = gui, Frame = frame, Tabs = {}, TabBar = tabs, Content = content, Visible = true, ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift}, Window)
	close.MouseButton1Click:Connect(function() self:Destroy() end)
	collapse.MouseButton1Click:Connect(function()
		self.Collapsed = not self.Collapsed; tabs.Visible = not self.Collapsed; content.Visible = not self.Collapsed
		collapse.Text = self.Collapsed and ">" or "v"
	end)
	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == self.ToggleKey then self:SetVisible(not self.Visible) end
	end)
	return self
end

function Window:SetVisible(visible: boolean) self.Visible = visible; self.Gui.Enabled = visible end
function Window:Destroy() self.Gui:Destroy() end

function Window:Tab(name: string)
	local button = make("TextButton", {Name = name, Size = UDim2.fromOffset(0, 23), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = RereGui.Theme.TabBg, BorderSizePixel = 0, AutoButtonColor = false, Parent = self.TabBar}) :: TextButton
	text(button, "  " .. name .. "  ")
	local page = make("ScrollingFrame", {Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = self.Content}) :: ScrollingFrame
	make("UIPadding", {PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 7), PaddingTop = UDim.new(0, 2), Parent = page})
	addList(page, 5)
	local tab = setmetatable({Window = self, Button = button, Page = page, Name = name}, Tab)
	table.insert(self.Tabs, tab)
	button.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
	button.MouseEnter:Connect(function() if not page.Visible then button.BackgroundColor3 = RereGui.Theme.TabHover end end)
	button.MouseLeave:Connect(function() if not page.Visible then button.BackgroundColor3 = RereGui.Theme.TabBg end end)
	if #self.Tabs == 1 then self:SelectTab(tab) end
	return tab
end

function Window:SelectTab(selected)
	for _, tab in ipairs(self.Tabs) do
		local active = tab == selected; tab.Page.Visible = active; tab.Button.BackgroundColor3 = active and RereGui.Theme.TabActive or RereGui.Theme.TabBg
	end
end

function Tab:Label(value: string) return label(self.Page, value) end

function Tab:Separator()
	return make("Frame", {Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = RereGui.Theme.Border, BorderSizePixel = 0, Parent = self.Page})
end

function Tab:Button(value: string, callback: (() -> ())?)
	local item = make("TextButton", {Size = UDim2.new(0, 150, 0, 23), BackgroundColor3 = RereGui.Theme.Accent, BorderColor3 = RereGui.Theme.Border, AutoButtonColor = false, Parent = self.Page}) :: TextButton
	text(item, value); item.MouseEnter:Connect(function() item.BackgroundColor3 = RereGui.Theme.AccentHover end); item.MouseLeave:Connect(function() item.BackgroundColor3 = RereGui.Theme.Accent end)
	if callback then item.MouseButton1Click:Connect(callback) end
	return item
end

function Tab:Checkbox(value: string, default: boolean?, callback: ((boolean) -> ())?)
	local checked = default == true
	local item = make("TextButton", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, AutoButtonColor = false, Text = "", Parent = self.Page}) :: TextButton
	local box = make("Frame", {Size = UDim2.fromOffset(15, 15), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = checked and RereGui.Theme.Accent or RereGui.Theme.FrameBg, BorderColor3 = RereGui.Theme.Border, Parent = item}) :: Frame
	local tick = label(box, checked and "x" or ""); tick.Size = UDim2.fromScale(1, 1); tick.TextXAlignment, tick.TextYAlignment = Enum.TextXAlignment.Center, Enum.TextYAlignment.Center
	local title = label(item, value); title.Position = UDim2.fromOffset(25, 0); title.Size = UDim2.new(1, -25, 1, 0)
	local control = {}
	function control:Set(valueToSet: boolean) checked = valueToSet; tick.Text = checked and "x" or ""; box.BackgroundColor3 = checked and RereGui.Theme.Accent or RereGui.Theme.FrameBg; if callback then callback(checked) end end
	function control:Get() return checked end
	item.MouseButton1Click:Connect(function() control:Set(not checked) end)
	return control
end

function Tab:Slider(value: string, minimum: number, maximum: number, default: number, callback: ((number) -> ())?)
	local row = make("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = self.Page}) :: Frame
	local title = label(row, value, 150)
	local bar = make("TextButton", {Size = UDim2.new(1, -245, 0, 20), Position = UDim2.fromOffset(155, 1), BackgroundColor3 = RereGui.Theme.FrameBg, BorderColor3 = RereGui.Theme.Border, AutoButtonColor = false, Text = "", Parent = row}) :: TextButton
	local fill = make("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = RereGui.Theme.Accent, BorderSizePixel = 0, Parent = bar}) :: Frame
	local number = label(row, "", 80); number.Position = UDim2.new(1, -84, 0, 0); number.TextXAlignment = Enum.TextXAlignment.Right
	local current = math.clamp(default, minimum, maximum); local dragging = false
	local control = {}
	function control:Set(nextValue: number)
		current = math.clamp(nextValue, minimum, maximum); local alpha = (current - minimum) / (maximum - minimum)
		fill.Size = UDim2.new(alpha, 0, 1, 0); number.Text = string.format("%.2f", current):gsub("%.00$", "")
		if callback then callback(current) end
	end
	function control:Get() return current end
	local function update(pointer: Vector2) control:Set(minimum + (maximum - minimum) * math.clamp((pointer.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)) end
	bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input.Position) end end)
	UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input.Position) end end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	control:Set(current); return control
end

function Tab:InputText(value: string, default: string?, callback: ((string) -> ())?)
	local row = make("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = self.Page}) :: Frame
	label(row, value, 150)
	local input = make("TextBox", {Size = UDim2.new(1, -155, 0, 22), Position = UDim2.fromOffset(155, 0), BackgroundColor3 = RereGui.Theme.FrameBg, BorderColor3 = RereGui.Theme.Border, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, Text = default or "", Parent = row}) :: TextBox
	text(input, input.Text); input.Focused:Connect(function() input.BackgroundColor3 = RereGui.Theme.FrameHover end); input.FocusLost:Connect(function() input.BackgroundColor3 = RereGui.Theme.FrameBg; if callback then callback(input.Text) end end)
	return input
end

function Tab:CollapsingHeader(value: string, open: boolean?)
	local holder = make("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = self.Page}) :: Frame
	addList(holder, 4)
	local expanded = open ~= false
	local header = make("TextButton", {Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = RereGui.Theme.Header, BorderColor3 = RereGui.Theme.Border, AutoButtonColor = false, Parent = holder}) :: TextButton
	text(header, (expanded and "v  " or ">  ") .. value); header.TextXAlignment = Enum.TextXAlignment.Left
	local body = make("Frame", {Size = UDim2.new(1, -12, 0, 0), Position = UDim2.fromOffset(6, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = expanded, Parent = holder}) :: Frame
	addList(body, 4)
	header.MouseButton1Click:Connect(function() expanded = not expanded; body.Visible = expanded; header.Text = (expanded and "v  " or ">  ") .. value end)
	return setmetatable({Page = body}, Tab)
end

function Tab:Menu(labelText: string, entries: {{Text: string, Callback: (() -> ())?}})
	local holder = make("Frame", {Size = UDim2.fromOffset(0, 24), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, ZIndex = 5, Parent = self.Page}) :: Frame
	local trigger = make("TextButton", {Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = RereGui.Theme.TabBg, BorderColor3 = RereGui.Theme.Border, AutoButtonColor = false, Parent = holder}) :: TextButton
	text(trigger, "  " .. labelText .. "  ")
	local popup = make("Frame", {Size = UDim2.fromOffset(145, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(0, 24), BackgroundColor3 = RereGui.Theme.WindowBg, BorderColor3 = RereGui.Theme.Border, Visible = false, ZIndex = 10, Parent = holder}) :: Frame
	addList(popup, 1)
	for _, entry in ipairs(entries) do
		local item = make("TextButton", {Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = RereGui.Theme.WindowBg, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 11, Parent = popup}) :: TextButton
		text(item, "  " .. entry.Text); item.TextXAlignment = Enum.TextXAlignment.Left; item.MouseEnter:Connect(function() item.BackgroundColor3 = RereGui.Theme.TabHover end); item.MouseLeave:Connect(function() item.BackgroundColor3 = RereGui.Theme.WindowBg end)
		item.MouseButton1Click:Connect(function() popup.Visible = false; if entry.Callback then entry.Callback() end end)
	end
	trigger.MouseButton1Click:Connect(function() popup.Visible = not popup.Visible end)
	return holder
end

return RereGui
