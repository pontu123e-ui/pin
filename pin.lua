--==================================================
-- KHUB UI LIBRARY
--==================================================
-- Author : Kyiel Pambid (KHUB)
-- Logo   : rbxassetid://116838166946511
-- Discord: https://discord.gg/CTqBhzTGHV
-- YouTube: https://www.youtube.com/@kyielpambid
--
-- LOAD:
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/pontu123e-ui/pin/main/pin.lua"))()
--   local Library = getgenv().KHUB_UI_LIBRARY or getgenv().CM_UI_LIBRARY
--
-- ==================================================
-- HOW TO USE (for humans + AI)
-- ==================================================
--
-- 1) CREATE WINDOW
--    local Window = Library:CreateWindow({
--        Title = "Game Name",
--        Subtitle = "KHUB",
--        -- SkipIntro = true,  -- optional
--    })
--
-- 2) ADD TAB (with icon)
--    Icons examples: home, settings, user, sword, zap, eye, star,
--                    tools, info, save, server, heart, misc, speed
--    local Main = Window:AddTab({ Title = "Main", Icon = "zap" })
--
-- 3) INSTRUCTIONS BOX (one box per tab · colored lines)
--    Prefixes:
--      "<> text"  = green
--      "$ text"   = violet
--      "> text"   = blue
--      plain text = green
--    Main:AddMessages({
--        "<> Script made by KHUB · Kyiel Pambid",
--        "<> How it works: enable the toggles you need.",
--        "$ Report bugs on Discord.",
--    })
--
-- 4) SECTION + CONTROLS
--    local sec = Main:NewSection("Farm")
--
--    sec:AddToggle("AutoFarm", {
--        Title = "Auto Farm",
--        Description = "Optional desc",
--        Default = false,
--        -- Notify = false,  -- hide side toast
--        Callback = function(value) end,
--    })
--
--    sec:AddSlider("WalkSpeed", {
--        Title = "Walk Speed",
--        Min = 16, Max = 120, Default = 28, Rounding = 0,
--        Callback = function(value) end,
--    })
--
--    sec:AddDropdown("Zone", {
--        Title = "Select Zone",
--        Values = { "A", "B", "C" },
--        Default = "A",
--        Callback = function(option) end,
--    })
--
--    sec:AddButton({
--        Title = "Do Something",
--        Description = "Optional",
--        Callback = function() end,
--    })
--
--    sec:AddInput("Name", {
--        Title = "Config name",
--        Placeholder = "default",
--        Default = "default",
--        Callback = function(text) end,
--    })
--
--    sec:AddLabel({ Title = "Info text" })
--    sec:AddParagraph({ Title = "Title", Content = "Body text" })
--
-- 5) SIDE TOAST (manual)
--    Library:Notify({ Title = "KHUB", Content = "Hello", Duration = 3 })
--    -- Auto toasts fire on Toggle / Button / Dropdown clicks (CM Hub style)
--
-- 6) INTRO
--    Plays automatically before UI (KHUB PANEL).
--    SkipIntro = true on CreateWindow to disable.
--
-- 7) THEME
--    Default is Purple (violet). Settings tab has theme picker.
--
-- Legacy: Library.CreateLib("Title", "Purple")
--==================================================

--==================================================
-- SERVICES
--==================================================

local CloneRef = (typeof(cloneref) == "function") and cloneref or function(object)
	return object
end

local Players          = CloneRef(game:GetService("Players"))
local TweenService     = CloneRef(game:GetService("TweenService"))
local UserInputService = CloneRef(game:GetService("UserInputService"))
local RunService       = CloneRef(game:GetService("RunService"))
local HttpService      = CloneRef(game:GetService("HttpService"))
local CoreGui          = CloneRef(game:GetService("CoreGui"))
local GuiService       = CloneRef(game:GetService("GuiService"))

local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONSTANTS
--==================================================

local LIB_NAME       = "KHUB UI Library"
local LIB_VERSION    = "2.0.0-KHUB"
local GUI_NAME       = "KHUB_UI_LIBRARY"
local ROOT_FOLDER    = "KHUB_UI"
local CONFIG_FOLDER  = "KHUB_UI/configs"
local INTERFACE_FILE = "KHUB_UI/interface.json"

local YOUTUBE_URL = "https://www.youtube.com/@kyielpambid"
local DISCORD_URL = "https://discord.gg/CTqBhzTGHV"

local function SafeFont(name, fallback)
	local ok, font = pcall(function()
		return Enum.Font[name]
	end)
	if ok and font then
		return font
	end
	return fallback
end

local FONT        = SafeFont("Gotham", Enum.Font.SourceSans)
local FONT_MEDIUM = SafeFont("GothamMedium", FONT)
local FONT_BOLD   = SafeFont("GothamBold", Enum.Font.SourceSansBold)

local GLYPH = {
	Arrow    = utf8.char(0x2192),
	Check    = utf8.char(0x2713),
	Down     = utf8.char(0x25BE),
	Up       = utf8.char(0x25B4),
	Close    = utf8.char(0x2715),
	Minimize = utf8.char(0x2013),
	Dot      = utf8.char(0x25CF),
}

local ICONS = {
	home = "home", main = "home", dashboard = "home", lobby = "home", hub = "home",
	settings = "settings", gear = "settings", config = "settings", options = "settings", setup = "settings",
	credits = "heart", heart = "heart", love = "heart", donators = "heart", support = "heart",
	info = "info", about = "info", help = "info", faq = "info", guide = "book",
	list = "list", menu = "list", task = "list", tasks = "list", quests = "list", log = "list",
	search = "search", find = "search", inspect = "search", lookup = "search",
	misc = "misc", items = "misc", other = "misc", extra = "misc", utilities = "misc",
	["arrow-right"] = "chevron-right", ["arrow_right"] = "chevron-right", arrowright = "chevron-right",
	["arrow-left"] = "chevron-left", ["arrow_left"] = "chevron-left", arrowleft = "chevron-left",
	["chevron-right"] = "chevron-right", ["chevron_right"] = "chevron-right", chevronright = "chevron-right",
	["chevron-left"] = "chevron-left", ["chevron_left"] = "chevron-left", chevronleft = "chevron-left",
	["chevron-down"] = "chevron-down", ["chevron_down"] = "chevron-down", chevrondown = "chevron-down",
	arrow = "chevron-right", forward = "chevron-right", back = "chevron-left",
	sword = "sword", combat = "sword", pvp = "sword", attack = "sword", weapon = "sword", weapons = "sword", fight = "sword",
	shield = "shield", defense = "shield", protect = "shield", boss = "shield", armor = "shield",
	target = "target", aim = "target", aimbot = "target", silentaim = "target", crosshair = "target", shoot = "target", gun = "target",
	skull = "skull", kill = "skull", kills = "skull", death = "skull", dangerous = "skull", poison = "skull",
	tools = "tools", tool = "tools", farm = "tools", autofarm = "tools", farming = "tools", training = "tools", train = "tools", build = "tools", craft = "tools",
	bot = "bot", auto = "bot", robot = "bot", cpu = "bot", automation = "bot", ai = "bot", macro = "bot", loop = "bot",
	play = "play", stages = "play", stage = "play", autoquest = "play", game = "play", start = "play", run = "speed",
	refresh = "refresh", reload = "refresh", sync = "refresh", reset = "refresh", restart = "refresh", loop_arrow = "refresh",
	layers = "layers", layer = "layers", stack = "layers", platform = "layers", platforms = "layers",
	user = "user", player = "user", character = "user", avatar = "user", profile = "user", humanoid = "user",
	speed = "speed", movement = "speed", walk = "speed", walkspeed = "speed", sprint = "speed", fast = "speed", dash = "speed",
	rocket = "rocket", fly = "rocket", flight = "rocket", jump = "rocket", jumppower = "rocket", wings = "rocket", boost = "rocket",
	teleport = "teleport", world = "teleport", worlds = "teleport", map = "teleport", maps = "teleport", globe = "teleport", zone = "teleport", travel = "teleport", waypoint = "teleport",
	compass = "compass", radar = "compass", nav = "compass", direction = "compass",
	shop = "shop", store = "shop", cart = "shop", market = "shop", buy = "shop", trade = "shop", merchant = "shop",
	coin = "coin", coins = "coin", cash = "coin", money = "coin", currency = "coin", dollar = "coin", rich = "coin", gold = "coin",
	diamond = "diamond", gem = "diamond", gems = "diamond", crystal = "diamond", crystals = "diamond", ruby = "diamond",
	gift = "gift", rewards = "gift", reward = "gift", free = "gift", box = "gift", crate = "gift", chest = "gift", bundle = "gift",
	trophy = "trophy", rank = "trophy", badge = "trophy", medal = "trophy", leaderboard = "trophy", top = "trophy", winner = "trophy",
	eye = "eye", visuals = "eye", esp = "eye", chams = "eye", see = "eye", xray = "eye", render = "eye",
	sun = "sun", light = "sun", day = "sun", brightness = "sun",
	moon = "moon", dark = "moon", night = "moon",
	flame = "flame", fire = "flame", hot = "flame", burn = "flame", streak = "flame",
	bolt = "bolt", zap = "bolt", lightning = "bolt", energy = "bolt", power = "bolt", shock = "bolt", flash = "bolt",
	star = "star", pets = "star", pet = "star", favorite = "star", vip = "star", premium = "star",
	code = "code", script = "code", scripts = "code", dev = "code", execute = "code", console = "code", terminal = "code",
	lock = "lock", unlock = "lock", security = "lock", key = "key", auth = "key", password = "key",
	bell = "bell", alert = "bell", notification = "bell", notify = "bell",
	book = "book", docs = "book", wiki = "book", manual = "book", tutorial = "book",
	potion = "potion", buff = "potion", flask = "potion", heal = "potion", health = "potion", elixir = "potion",
	music = "music", sound = "music", audio = "music", volume = "music", song = "music",
	cloud = "cloud", server = "cloud", network = "cloud", ping = "cloud", online = "cloud",
	folder = "folder", files = "folder", directory = "folder",
	copy = "copy", clipboard = "copy",
	trash = "trash", delete = "trash", remove = "trash", clear = "trash",
	stats = "stats", chart = "stats", level = "stats", levels = "stats", progress = "stats",
	sparkles = "sparkles", sparkle = "sparkles", effects = "sparkles", aura = "sparkles",
	crown = "crown", royal = "crown", king = "crown",
	users = "users", team = "users", friends = "users", party = "users",
	backpack = "backpack", inventory = "backpack", bag = "backpack",
	calendar = "calendar", daily = "calendar", events = "calendar",
	clock = "clock", timer = "clock", time = "clock", history = "clock",
	sliders = "sliders", adjustments = "sliders", tuning = "sliders",
	gamepad = "gamepad", controller = "gamepad", controls = "gamepad",
	link = "link", connect = "link", connection = "link",
	download = "download", import = "download",
	upload = "upload", export = "upload",
	flag = "flag", checkpoint = "flag", mission = "flag",
	default = "default",
}

local DEFAULT_WINDOW_SIZE = UDim2.fromOffset(580, 460)
local LOGO_ID = "rbxassetid://116838166946511"
local BG_ID   = "rbxassetid://127230219966945"

local Settings = {
	Theme        = "Purple",
	CustomAccent = nil,
	Scale        = 1,
	Transparency = 0,
	Animations   = true,
	MinimizeKey  = Enum.KeyCode.RightControl,
	Position     = nil,
	ConfigName   = "default",
	AutoLoad     = nil,
}

local function New(className, properties, children)
	local instance = Instance.new(className)
	if properties then
		for property, value in pairs(properties) do
			if property ~= "Parent" then
				instance[property] = value
			end
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = instance
		end
	end
	if properties and properties.Parent then
		instance.Parent = properties.Parent
	end
	return instance
end

local function SafeCallback(callback, ...)
	if typeof(callback) ~= "function" then
		return
	end
	local packed = table.pack(...)
	local success, result = pcall(function()
		return callback(table.unpack(packed, 1, packed.n))
	end)
	if not success then
		warn("[KHUB UI] Callback error:", result)
		return nil
	end
	return result
end

local function Clamp(value, minimum, maximum)
	if minimum > maximum then
		minimum, maximum = maximum, minimum
	end
	return math.max(minimum, math.min(maximum, value))
end

local function Round(value, decimals)
	decimals = decimals or 0
	local multiplier = 10 ^ decimals
	return math.floor(value * multiplier + 0.5) / multiplier
end

local function Lerp(a, b, alpha)
	return a + (b - a) * alpha
end

local function GetInset()
	local ok, inset = pcall(function()
		return GuiService:GetGuiInset()
	end)
	if ok and inset then
		return inset
	end
	return Vector2.new(0, 0)
end

local function InputToGui(position)
	local inset = GetInset()
	return Vector2.new(position.X + inset.X, position.Y + inset.Y)
end

local function IsTouchDevice()
	local ok, touch = pcall(function()
		return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
	end)
	if ok then
		return touch
	end
	return false
end

local function CopyToClipboard(text)
	local functions = {}
	if typeof(setclipboard) == "function" then table.insert(functions, setclipboard) end
	if typeof(toclipboard) == "function" then table.insert(functions, toclipboard) end
	if typeof(set_clipboard) == "function" then table.insert(functions, set_clipboard) end
	if typeof(getgenv) == "function" then
		local ok, env = pcall(getgenv)
		if ok and typeof(env) == "table" then
			for _, name in ipairs({ "setclipboard", "toclipboard", "set_clipboard" }) do
				if typeof(env[name]) == "function" then table.insert(functions, env[name]) end
			end
		end
	end
	for _, fn in ipairs(functions) do
		local success = pcall(fn, text)
		if success then return true end
	end
	return false
end

local FS = {}
function FS.Available()
	return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
end
function FS.FolderAvailable()
	return typeof(makefolder) == "function" and typeof(isfolder) == "function"
end
function FS.EnsureFolder(path)
	if not FS.FolderAvailable() then return false end
	local ok, exists = pcall(isfolder, path)
	if ok and exists then return true end
	return (pcall(makefolder, path))
end
function FS.Exists(path)
	if not FS.Available() then return false end
	local ok, exists = pcall(isfile, path)
	if ok and exists then return true end
	return false
end
function FS.Write(path, content)
	if not FS.Available() then return false end
	return (pcall(writefile, path, content))
end
function FS.Read(path)
	if not FS.Exists(path) then return nil end
	local ok, content = pcall(readfile, path)
	if ok then return content end
	return nil
end
function FS.Delete(path)
	if typeof(delfile) ~= "function" then return false end
	return (pcall(delfile, path))
end
function FS.List(path)
	if typeof(listfiles) ~= "function" then return {} end
	local ok, files = pcall(listfiles, path)
	if ok and typeof(files) == "table" then return files end
	return {}
end

local Maid = {}
Maid.__index = Maid
function Maid.new()
	return setmetatable({ _tasks = {} }, Maid)
end
function Maid:Give(item)
	if item == nil then return nil end
	table.insert(self._tasks, item)
	return item
end
local function CleanupItem(item)
	local itemType = typeof(item)
	if itemType == "RBXScriptConnection" then
		pcall(function() item:Disconnect() end)
	elseif itemType == "Instance" then
		pcall(function() item:Destroy() end)
	elseif itemType == "function" then
		pcall(item)
	elseif itemType == "table" then
		if typeof(item.DoCleaning) == "function" then pcall(function() item:DoCleaning() end)
		elseif typeof(item.Destroy) == "function" then pcall(function() item:Destroy() end)
		elseif typeof(item.Cancel) == "function" then pcall(function() item:Cancel() end)
		end
	end
end
function Maid:DoCleaning()
	local tasks = self._tasks
	self._tasks = {}
	for index = #tasks, 1, -1 do
		CleanupItem(tasks[index])
	end
end
Maid.Destroy = Maid.DoCleaning

local Themes = {
	DarkTheme = {
		Background   = Color3.fromRGB(10, 6, 18),
		Header       = Color3.fromRGB(16, 10, 28),
		Element      = Color3.fromRGB(26, 14, 44),
		ElementHover = Color3.fromRGB(40, 22, 66),
		Text         = Color3.fromRGB(248, 240, 255),
		SubText      = Color3.fromRGB(180, 150, 220),
		Accent       = Color3.fromRGB(170, 80, 255),
		Border       = Color3.fromRGB(90, 45, 150),
	},
	Purple = {
		Background   = Color3.fromRGB(10, 6, 18),
		Header       = Color3.fromRGB(16, 10, 28),
		Element      = Color3.fromRGB(26, 14, 44),
		ElementHover = Color3.fromRGB(40, 22, 66),
		Text         = Color3.fromRGB(248, 240, 255),
		SubText      = Color3.fromRGB(180, 150, 220),
		Accent       = Color3.fromRGB(170, 80, 255),
		Border       = Color3.fromRGB(90, 45, 150),
	},
	LightTheme = {
		Background   = Color3.fromRGB(242, 242, 242),
		Header       = Color3.fromRGB(255, 255, 255),
		Element      = Color3.fromRGB(255, 255, 255),
		ElementHover = Color3.fromRGB(232, 232, 232),
		Text         = Color3.fromRGB(15, 15, 15),
		SubText      = Color3.fromRGB(95, 95, 95),
		Accent       = Color3.fromRGB(15, 15, 15),
		Border       = Color3.fromRGB(214, 214, 214),
	},
}

local ThemeAliases = {
	Dark = "DarkTheme", Light = "LightTheme", dark = "DarkTheme", light = "LightTheme",
	Purple = "Purple", purple = "Purple", violet = "Purple", Default = "Purple", KHUB = "Purple",
}

local function ResolveThemeName(name)
	if typeof(name) ~= "string" then return "Purple" end
	if Themes[name] then return name end
	if ThemeAliases[name] and Themes[ThemeAliases[name]] then return ThemeAliases[name] end
	return "Purple"
end

local CurrentThemeName = "Purple"
local Theme = Themes.Purple or Themes.DarkTheme

local function T(key)
	local value = Theme[key]
	if value == nil then return Color3.fromRGB(255, 0, 255) end
	return value
end

local ThemeRegistry = {}
local ThemeChangedListeners = {}

local function ApplyThemeTo(instance, map)
	for property, key in pairs(map) do
		local value
		if typeof(key) == "function" then value = key(Theme) else value = Theme[key] end
		if value ~= nil then pcall(function() instance[property] = value end) end
	end
end

local function RegisterTheme(instance, map)
	table.insert(ThemeRegistry, { Instance = instance, Map = map })
	ApplyThemeTo(instance, map)
	return instance
end

local function ApplyTheme()
	for index = #ThemeRegistry, 1, -1 do
		local entry = ThemeRegistry[index]
		local instance = entry.Instance
		local ok, parent = pcall(function() return instance.Parent end)
		if ok and parent ~= nil then ApplyThemeTo(instance, entry.Map) else table.remove(ThemeRegistry, index) end
	end
	for _, listener in ipairs(ThemeChangedListeners) do SafeCallback(listener, Theme, CurrentThemeName) end
end

local Library = {}
Library.Name = LIB_NAME
Library.Version = LIB_VERSION
Library.Options = {}
Library.Flags = {}
Library.Settings = Settings
Library.Themes = Themes
Library.Windows = {}

function Library:CreateWindow(config)
	config = config or {}
	local title = config.Title or "KHUB Hub"
	local subtitle = config.Subtitle or "UI Library"

	local ScreenGui = New("ScreenGui", {
		Name = GUI_NAME,
		Parent = CoreGui,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
	})

	local MainFrame = New("Frame", {
		Name = "MainFrame",
		Parent = ScreenGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = DEFAULT_WINDOW_SIZE,
		BackgroundColor3 = T("Background"),
		BorderSizePixel = 0,
	})
	Corner(MainFrame, 12)
	Stroke(MainFrame, "Border", 1, 0)

	local TopBar = New("Frame", {
		Name = "TopBar",
		Parent = MainFrame,
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = T("Header"),
		BorderSizePixel = 0,
	})
	Corner(TopBar, 12)

	local TitleLabel = New("TextLabel", {
		Name = "Title",
		Parent = TopBar,
		Position = UDim2.new(0, 15, 0, 0),
		Size = UDim2.new(0.8, 0, 1, 0),
		BackgroundTransparency = 1,
		Font = FONT_BOLD,
		Text = title .. " <font color=\"#b496dc\">[" .. subtitle .. "]</font>",
		RichText = true,
		TextColor3 = T("Text"),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local ContentArea = New("Frame", {
		Name = "ContentArea",
		Parent = MainFrame,
		Position = UDim2.new(0, 10, 0, 50),
		Size = UDim2.new(1, -20, 1, -60),
		BackgroundTransparency = 1,
	})

	local Tabs = {}
	local WindowObj = {}

	function WindowObj:AddTab(tabConfig)
		tabConfig = tabConfig or {}
		local tabTitle = tabConfig.Title or "Tab"
		
		local TabContent = New("ScrollingFrame", {
			Name = tabTitle .. "Content",
			Parent = ContentArea,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = #Tabs == 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 4,
		})
		ListLayout(TabContent, 8)
		Padding(TabContent, 5, 5, 5, 5)

		local TabObj = {}
		function TabObj:NewSection(sectionName)
			local SectionFrame = New("Frame", {
				Parent = TabContent,
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = T("Element"),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
			})
			Corner(SectionFrame, 8)
			Stroke(SectionFrame, "Border", 1, 0)
			ListLayout(SectionFrame, 6)
			Padding(SectionFrame, 8, 8, 10, 10)

			local SecTitle = New("TextLabel", {
				Parent = SectionFrame,
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				Font = FONT_BOLD,
				Text = sectionName,
				TextColor3 = T("Accent"),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local SecObj = {}
			function SecObj:AddButton(btnConfig)
				btnConfig = btnConfig or {}
				local btnTitle = btnConfig.Title or "Button"
				local callback = btnConfig.Callback or function() end

				local Btn = New("TextButton", {
					Parent = SectionFrame,
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = T("ElementHover"),
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Font = FONT_MEDIUM,
					Text = "  " .. btnTitle,
					TextColor3 = T("Text"),
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
				})
				Corner(Btn, 6)

				Btn.MouseButton1Click:Connect(function()
					pcall(callback)
				end)
			end

			function SecObj:AddToggle(toggleConfig)
				-- Placeholder toggle basic
			end

			return SecObj
		end

		table.insert(Tabs, TabObj)
		return TabObj
	end

	return WindowObj
end

getgenv().KHUB_UI_LIBRARY = Library
return Library
