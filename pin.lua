--==================================================
-- KHUB UI LIBRARY
--==================================================
-- Author : Kyiel Pambid (KHUB)
-- Logo   : rbxassetid://116838166946511
-- Discord: https://discord.gg/CTqBhzTGHV
-- YouTube: https://www.youtube.com/@kyielpambid
--
-- LOAD:
--   loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()
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

-- Canonical names for the vector-style sidebar icons.  These deliberately do
-- not use Unicode symbols: Roblox font fallbacks rendered several of the old
-- glyphs as emoji or missing-character boxes on different devices.
local ICONS = {
	-- Navigation & System
	home = "home", main = "home", dashboard = "home", lobby = "home", hub = "home",
	settings = "settings", gear = "settings", config = "settings", options = "settings", setup = "settings",
	credits = "heart", heart = "heart", love = "heart", donators = "heart", support = "heart",
	info = "info", about = "info", help = "info", faq = "info", guide = "book",
	list = "list", menu = "list", task = "list", tasks = "list", quests = "list", log = "list",
	search = "search", find = "search", inspect = "search", lookup = "search",
	misc = "misc", items = "misc", other = "misc", extra = "misc", utilities = "misc",

	-- Directional & Arrows
	["arrow-right"] = "chevron-right", ["arrow_right"] = "chevron-right", arrowright = "chevron-right",
	["arrow-left"] = "chevron-left", ["arrow_left"] = "chevron-left", arrowleft = "chevron-left",
	["chevron-right"] = "chevron-right", ["chevron_right"] = "chevron-right", chevronright = "chevron-right",
	["chevron-left"] = "chevron-left", ["chevron_left"] = "chevron-left", chevronleft = "chevron-left",
	["chevron-down"] = "chevron-down", ["chevron_down"] = "chevron-down", chevrondown = "chevron-down",
	arrow = "chevron-right", forward = "chevron-right", back = "chevron-left",

	-- Combat & Weapons
	sword = "sword", combat = "sword", pvp = "sword", attack = "sword", weapon = "sword", weapons = "sword", fight = "sword",
	shield = "shield", defense = "shield", protect = "shield", boss = "shield", armor = "shield",
	target = "target", aim = "target", aimbot = "target", silentaim = "target", crosshair = "target", shoot = "target", gun = "target",
	skull = "skull", kill = "skull", kills = "skull", death = "skull", dangerous = "skull", poison = "skull",

	-- Automation & Farming
	tools = "tools", tool = "tools", farm = "tools", autofarm = "tools", farming = "tools", training = "tools", train = "tools", build = "tools", craft = "tools",
	bot = "bot", auto = "bot", robot = "bot", cpu = "bot", automation = "bot", ai = "bot", macro = "bot", loop = "bot",
	play = "play", stages = "play", stage = "play", autoquest = "play", game = "play", start = "play", run = "speed",
	refresh = "refresh", reload = "refresh", sync = "refresh", reset = "refresh", restart = "refresh", loop_arrow = "refresh",
	layers = "layers", layer = "layers", stack = "layers", platform = "layers", platforms = "layers",

	-- Movement & Player
	user = "user", player = "user", character = "user", avatar = "user", profile = "user", humanoid = "user",
	speed = "speed", movement = "speed", walk = "speed", walkspeed = "speed", sprint = "speed", fast = "speed", dash = "speed",
	rocket = "rocket", fly = "rocket", flight = "rocket", jump = "rocket", jumppower = "rocket", wings = "rocket", boost = "rocket",
	teleport = "teleport", world = "teleport", worlds = "teleport", map = "teleport", maps = "teleport", globe = "teleport", zone = "teleport", travel = "teleport", waypoint = "teleport",
	compass = "compass", radar = "compass", nav = "compass", direction = "compass",

	-- Economy & Shop
	shop = "shop", store = "shop", cart = "shop", market = "shop", buy = "shop", trade = "shop", merchant = "shop",
	coin = "coin", coins = "coin", cash = "coin", money = "coin", currency = "coin", dollar = "coin", rich = "coin", gold = "coin",
	diamond = "diamond", gem = "diamond", gems = "diamond", crystal = "diamond", crystals = "diamond", ruby = "diamond",
	gift = "gift", rewards = "gift", reward = "gift", free = "gift", box = "gift", crate = "gift", chest = "gift", bundle = "gift",
	trophy = "trophy", rank = "trophy", badge = "trophy", medal = "trophy", leaderboard = "trophy", top = "trophy", winner = "trophy",

	-- Visuals & ESP
	eye = "eye", visuals = "eye", esp = "eye", chams = "eye", see = "eye", xray = "eye", render = "eye",
	sun = "sun", light = "sun", day = "sun", brightness = "sun",
	moon = "moon", dark = "moon", night = "moon",
	flame = "flame", fire = "flame", hot = "flame", burn = "flame", streak = "flame",
	bolt = "bolt", zap = "bolt", lightning = "bolt", energy = "bolt", power = "bolt", shock = "bolt", flash = "bolt",
	star = "star", pets = "star", pet = "star", favorite = "star", vip = "star", premium = "star",

	-- Utility & Tech
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

	-- Additional consistent line icons; aliases work in tab and button APIs.
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

--==================================================
-- GLOBAL RUNTIME SETTINGS
--==================================================

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

--==================================================
-- UTILITY FUNCTIONS
--==================================================

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

-- Converts a raw input position into ScreenGui (IgnoreGuiInset) space.
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

	if typeof(setclipboard) == "function" then
		table.insert(functions, setclipboard)
	end
	if typeof(toclipboard) == "function" then
		table.insert(functions, toclipboard)
	end
	if typeof(set_clipboard) == "function" then
		table.insert(functions, set_clipboard)
	end

	if typeof(getgenv) == "function" then
		local ok, env = pcall(getgenv)
		if ok and typeof(env) == "table" then
			for _, name in ipairs({ "setclipboard", "toclipboard", "set_clipboard" }) do
				if typeof(env[name]) == "function" then
					table.insert(functions, env[name])
				end
			end
		end
	end

	for _, fn in ipairs(functions) do
		local success = pcall(fn, text)
		if success then
			return true
		end
	end

	return false
end

--==================================================
-- FILE SYSTEM (fails gracefully when unavailable)
--==================================================

local FS = {}

function FS.Available()
	return typeof(writefile) == "function"
		and typeof(readfile) == "function"
		and typeof(isfile) == "function"
end

function FS.FolderAvailable()
	return typeof(makefolder) == "function" and typeof(isfolder) == "function"
end

function FS.EnsureFolder(path)
	if not FS.FolderAvailable() then
		return false
	end

	local ok, exists = pcall(isfolder, path)
	if ok and exists then
		return true
	end

	return (pcall(makefolder, path))
end

function FS.Exists(path)
	if not FS.Available() then
		return false
	end
	local ok, exists = pcall(isfile, path)
	if ok and exists then
		return true
	end
	return false
end

function FS.Write(path, content)
	if not FS.Available() then
		return false
	end
	return (pcall(writefile, path, content))
end

function FS.Read(path)
	if not FS.Exists(path) then
		return nil
	end
	local ok, content = pcall(readfile, path)
	if ok then
		return content
	end
	return nil
end

function FS.Delete(path)
	if typeof(delfile) ~= "function" then
		return false
	end
	return (pcall(delfile, path))
end

function FS.List(path)
	if typeof(listfiles) ~= "function" then
		return {}
	end
	local ok, files = pcall(listfiles, path)
	if ok and typeof(files) == "table" then
		return files
	end
	return {}
end

--==================================================
-- CLEANUP SYSTEM (Maid)
--==================================================

local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({ _tasks = {} }, Maid)
end

function Maid:Give(item)
	if item == nil then
		return nil
	end
	table.insert(self._tasks, item)
	return item
end

local function CleanupItem(item)
	local itemType = typeof(item)

	if itemType == "RBXScriptConnection" then
		pcall(function()
			item:Disconnect()
		end)
	elseif itemType == "Instance" then
		pcall(function()
			item:Destroy()
		end)
	elseif itemType == "function" then
		pcall(item)
	elseif itemType == "table" then
		if typeof(item.DoCleaning) == "function" then
			pcall(function()
				item:DoCleaning()
			end)
		elseif typeof(item.Destroy) == "function" then
			pcall(function()
				item:Destroy()
			end)
		elseif typeof(item.Cancel) == "function" then
			pcall(function()
				item:Cancel()
			end)
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

--==================================================
-- THEME SYSTEM
--==================================================

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

	Serpent = {
		Background   = Color3.fromRGB(8, 14, 10),
		Header       = Color3.fromRGB(12, 20, 15),
		Element      = Color3.fromRGB(18, 28, 22),
		ElementHover = Color3.fromRGB(27, 41, 32),
		Text         = Color3.fromRGB(236, 255, 242),
		SubText      = Color3.fromRGB(139, 176, 151),
		Accent       = Color3.fromRGB(0, 255, 140),
		Border       = Color3.fromRGB(31, 61, 43),
	},

	Midnight = {
		Background   = Color3.fromRGB(11, 14, 20),
		Header       = Color3.fromRGB(16, 21, 30),
		Element      = Color3.fromRGB(21, 28, 40),
		ElementHover = Color3.fromRGB(30, 41, 59),
		Text         = Color3.fromRGB(248, 250, 252),
		SubText      = Color3.fromRGB(148, 163, 184),
		Accent       = Color3.fromRGB(59, 130, 246),
		Border       = Color3.fromRGB(30, 41, 59),
	},

	Crimson = {
		Background   = Color3.fromRGB(14, 8, 8),
		Header       = Color3.fromRGB(22, 12, 12),
		Element      = Color3.fromRGB(30, 16, 16),
		ElementHover = Color3.fromRGB(44, 24, 24),
		Text         = Color3.fromRGB(255, 245, 245),
		SubText      = Color3.fromRGB(200, 130, 130),
		Accent       = Color3.fromRGB(239, 68, 68),
		Border       = Color3.fromRGB(65, 26, 26),
	},

	Emerald = {
		Background   = Color3.fromRGB(8, 16, 12),
		Header       = Color3.fromRGB(12, 24, 18),
		Element      = Color3.fromRGB(16, 34, 25),
		ElementHover = Color3.fromRGB(24, 48, 36),
		Text         = Color3.fromRGB(240, 255, 248),
		SubText      = Color3.fromRGB(130, 190, 155),
		Accent       = Color3.fromRGB(16, 185, 129),
		Border       = Color3.fromRGB(24, 60, 42),
	},

	Amethyst = {
		Background   = Color3.fromRGB(14, 10, 20),
		Header       = Color3.fromRGB(20, 14, 30),
		Element      = Color3.fromRGB(28, 20, 42),
		ElementHover = Color3.fromRGB(40, 28, 60),
		Text         = Color3.fromRGB(250, 245, 255),
		SubText      = Color3.fromRGB(180, 150, 215),
		Accent       = Color3.fromRGB(168, 85, 247),
		Border       = Color3.fromRGB(55, 35, 80),
	},

	Sunset = {
		Background   = Color3.fromRGB(18, 12, 8),
		Header       = Color3.fromRGB(26, 17, 12),
		Element      = Color3.fromRGB(36, 24, 16),
		ElementHover = Color3.fromRGB(50, 34, 22),
		Text         = Color3.fromRGB(255, 248, 240),
		SubText      = Color3.fromRGB(210, 165, 135),
		Accent       = Color3.fromRGB(245, 158, 11),
		Border       = Color3.fromRGB(70, 44, 25),
	},

	Aqua = {
		Background   = Color3.fromRGB(8, 16, 20),
		Header       = Color3.fromRGB(12, 24, 30),
		Element      = Color3.fromRGB(16, 32, 42),
		ElementHover = Color3.fromRGB(24, 46, 60),
		Text         = Color3.fromRGB(240, 253, 255),
		SubText      = Color3.fromRGB(130, 195, 215),
		Accent       = Color3.fromRGB(6, 182, 212),
		Border       = Color3.fromRGB(25, 58, 75),
	},

	Rose = {
		Background   = Color3.fromRGB(18, 10, 14),
		Header       = Color3.fromRGB(26, 14, 20),
		Element      = Color3.fromRGB(36, 20, 28),
		ElementHover = Color3.fromRGB(52, 28, 40),
		Text         = Color3.fromRGB(255, 242, 246),
		SubText      = Color3.fromRGB(215, 145, 170),
		Accent       = Color3.fromRGB(244, 63, 94),
		Border       = Color3.fromRGB(70, 30, 50),
	},
}

local ThemeAliases = {
	Dark      = "DarkTheme",
	Light     = "LightTheme",
	dark      = "DarkTheme",
	light     = "LightTheme",
	serpent   = "Serpent",
	midnight  = "Midnight",
	blue      = "Midnight",
	cyberblue = "Midnight",
	crimson   = "Crimson",
	red       = "Crimson",
	blood     = "Crimson",
	emerald   = "Emerald",
	green     = "Emerald",
	mint      = "Emerald",
	amethyst  = "Amethyst",
	purple    = "Amethyst",
	violet    = "Amethyst",
	sunset    = "Sunset",
	gold      = "Sunset",
	orange    = "Sunset",
	amber     = "Sunset",
	aqua      = "Aqua",
	cyan      = "Aqua",
	teal      = "Aqua",
	rose      = "Rose",
	pink      = "Rose",
	Purple    = "Purple",
	purple    = "Purple",
	violet    = "Purple",
	Default   = "Purple",
	KHUB      = "Purple",
}

local function ResolveThemeName(name)
	if typeof(name) ~= "string" then
		return "Purple"
	end
	if Themes[name] then
		return name
	end
	if ThemeAliases[name] and Themes[ThemeAliases[name]] then
		return ThemeAliases[name]
	end
	return "Purple"
end

local CurrentThemeName = "Purple"
local Theme = Themes.Purple or Themes.DarkTheme

local function T(key)
	local value = Theme[key]
	if value == nil then
		return Color3.fromRGB(255, 0, 255)
	end
	return value
end

local ThemeRegistry = {}
local ThemeChangedListeners = {}

local function ApplyThemeTo(instance, map)
	for property, key in pairs(map) do
		local value

		if typeof(key) == "function" then
			value = key(Theme)
		else
			value = Theme[key]
		end

		if value ~= nil then
			pcall(function()
				instance[property] = value
			end)
		end
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

		local ok, parent = pcall(function()
			return instance.Parent
		end)

		if ok and parent ~= nil then
			ApplyThemeTo(instance, entry.Map)
		else
			table.remove(ThemeRegistry, index)
		end
	end

	for _, listener in ipairs(ThemeChangedListeners) do
		SafeCallback(listener, Theme, CurrentThemeName)
	end
end

local function OnThemeChanged(listener)
	table.insert(ThemeChangedListeners, listener)
end

local function SetCustomAccentInternal(color)
	if typeof(color) == "Color3" then
		Settings.CustomAccent = color
		Theme.Accent = color
	else
		Settings.CustomAccent = nil
		local baseTheme = Themes[CurrentThemeName]
		if baseTheme then
			Theme.Accent = baseTheme.Accent
		end
	end
	ApplyTheme()
end

local function SetThemeInternal(name, preserveCustomAccent)
	local resolved = ResolveThemeName(name)
	CurrentThemeName = resolved
	Theme = Themes[resolved]
	if not preserveCustomAccent then
		Settings.CustomAccent = nil
	elseif Settings.CustomAccent and typeof(Settings.CustomAccent) == "Color3" then
		Theme.Accent = Settings.CustomAccent
	end
	Settings.Theme = resolved
	ApplyTheme()
	if typeof(Library) == "table" and Library.Options and Library.Options.__KHUBCustomAccent then
		Library.Options.__KHUBCustomAccent:SetValue(Theme.Accent, 0, true)
	end
	return resolved
end

--==================================================
-- ANIMATION SYSTEM
--==================================================

local ActiveTweens = {}
local TweenSequence = 0

local SPEED = {
	Fast   = 0.12,
	Normal = 0.20,
	Slow   = 0.34,
}

local function Tween(object, properties, duration, easingStyle, easingDirection)
	if typeof(object) ~= "Instance" then
		return nil
	end

	if not Settings.Animations then
		for property, value in pairs(properties) do
			pcall(function()
				object[property] = value
			end)
		end
		return nil
	end

	local info = TweenInfo.new(
		duration or SPEED.Normal,
		easingStyle or Enum.EasingStyle.Quad,
		easingDirection or Enum.EasingDirection.Out
	)

	local ok, tween = pcall(function()
		return TweenService:Create(object, info, properties)
	end)

	if not ok or not tween then
		for property, value in pairs(properties) do
			pcall(function()
				object[property] = value
			end)
		end
		return nil
	end

	TweenSequence += 1
	ActiveTweens[tween] = {Object = object, Goals = properties, Order = TweenSequence}

	tween.Completed:Connect(function()
		ActiveTweens[tween] = nil
	end)

	tween:Play()

	return tween
end

local function CancelAllTweens(finish)
	local pending = {}
	for tween in pairs(ActiveTweens) do
		table.insert(pending, {Tween = tween, Target = ActiveTweens[tween]})
	end
	table.sort(pending, function(a, b) return a.Target.Order < b.Target.Order end)
	for _, entry in ipairs(pending) do
		pcall(function()
			entry.Tween:Cancel()
		end)
		if finish and entry.Target.Object.Parent then
			for property, value in pairs(entry.Target.Goals) do
				pcall(function() entry.Target.Object[property] = value end)
			end
		end
	end
	table.clear(ActiveTweens)
end

--==================================================
-- SHARED UI HELPERS
--==================================================

local function Corner(parent, radius)
	return New("UICorner", {
		Parent = parent,
		CornerRadius = UDim.new(0, radius or 8),
	})
end

local function Stroke(parent, themeKey, thickness, transparency)
	local stroke = New("UIStroke", {
		Parent = parent,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})

	RegisterTheme(stroke, { Color = themeKey or "Border" })

	return stroke
end

local function Padding(parent, top, bottom, left, right)
	return New("UIPadding", {
		Parent = parent,
		PaddingTop = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		PaddingLeft = UDim.new(0, left or 0),
		PaddingRight = UDim.new(0, right or left or 0),
	})
end

local function ListLayout(parent, padding, direction, verticalAlignment)
	return New("UIListLayout", {
		Parent = parent,
		FillDirection = direction or Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, padding or 8),
		VerticalAlignment = verticalAlignment or Enum.VerticalAlignment.Top,
	})
end

-- Small line-drawn glyphs stay sharp at Roblox UI sizes and remain visually
-- identical on Windows, mobile and executor font builds.  The returned parts
-- can be themed or animated without relying on an external image asset.
local function CreateLineGlyph(parent, kind, size, zIndex)
	size = size or 20
	zIndex = zIndex or (parent.ZIndex + 1)

	local holder = New("Frame", {
		Name = "Glyph",
		Parent = parent,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size, size),
		ZIndex = zIndex,
	})

	local canvas = New("Frame", {
		Name = "Canvas",
		Parent = holder,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1,
		ZIndex = zIndex,
	})

	New("UIScale", { Parent = canvas, Scale = size / 20 })

	local parts = {}

	local function Line(x, y, length, rotation, thickness)
		local line = New("Frame", {
			Parent = canvas,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(x, y),
			Size = UDim2.fromOffset(length, thickness or 2),
			Rotation = rotation or 0,
			BackgroundColor3 = T("SubText"),
			BorderSizePixel = 0,
			ZIndex = zIndex,
		})
		Corner(line, 2)
		table.insert(parts, line)
		return line
	end

	local function Ring(x, y, width, height, thickness)
		local ring = New("Frame", {
			Parent = canvas,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(x, y),
			Size = UDim2.fromOffset(width, height or width),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = zIndex,
		})
		Corner(ring, math.floor(math.min(width, height or width) / 2))
		local stroke = New("UIStroke", {
			Parent = ring,
			Color = T("SubText"),
			Thickness = thickness or 2,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})
		table.insert(parts, stroke)
		return ring
	end

	local function Rect(x, y, width, height, cornerRadius, thickness)
		local rect = New("Frame", {
			Parent = canvas,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(x, y),
			Size = UDim2.fromOffset(width, height),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = zIndex,
		})
		if cornerRadius and cornerRadius > 0 then
			Corner(rect, cornerRadius)
		end
		local stroke = New("UIStroke", {
			Parent = rect,
			Color = T("SubText"),
			Thickness = thickness or 1.8,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})
		table.insert(parts, stroke)
		return rect
	end

	local function Dot(x, y, radius)
		local dot = New("Frame", {
			Parent = canvas,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(x, y),
			Size = UDim2.fromOffset(radius or 3, radius or 3),
			BackgroundColor3 = T("SubText"),
			BorderSizePixel = 0,
			ZIndex = zIndex,
		})
		Corner(dot, math.floor((radius or 3) / 2))
		table.insert(parts, dot)
		return dot
	end

	kind = tostring(kind or "default"):lower()

	if kind == "close" then
		Line(10, 10, 12, 45, 2)
		Line(10, 10, 12, -45, 2)
	elseif kind == "success" or kind == "check" then
		Line(7.2, 11.5, 7, 45, 2.2)
		Line(12.5, 9, 11, -45, 2.2)
	elseif kind == "error" then
		Ring(10, 10, 16, 16, 1.8)
		Line(10, 10, 8, 45, 2)
		Line(10, 10, 8, -45, 2)
	elseif kind == "warning" then
		Line(6.3, 10.5, 14, -60, 2)
		Line(13.7, 10.5, 14, 60, 2)
		Line(10, 16.5, 14, 0, 2)
		Line(10, 9.5, 5, 90, 1.8)
		Ring(10, 13.5, 1.8, 1.8, 1.2)
	elseif kind == "loading" then
		Ring(5, 10, 3, 3, 1.5)
		Ring(10, 10, 3, 3, 1.5)
		Ring(15, 10, 3, 3, 1.5)
	elseif kind == "minimize" then
		Line(10, 11, 11, 0, 2)
	elseif kind == "chevron-right" or kind == "arrow-right" or kind == "arrow" then
		Line(9, 7.5, 7, 45, 2)
		Line(9, 12.5, 7, -45, 2)
	elseif kind == "chevron-left" or kind == "arrow-left" then
		Line(11, 7.5, 7, -45, 2)
		Line(11, 12.5, 7, 45, 2)
	elseif kind == "chevron-down" then
		Line(7.5, 9, 7, 45, 2)
		Line(12.5, 9, 7, -45, 2)
	elseif kind == "refresh" or kind == "reload" or kind == "sync" or kind == "reset" then
		Ring(10, 10, 13, 13, 1.8)
		Line(14.5, 7, 4, 45, 1.8)
		Line(14.5, 7, 4, -45, 1.8)
	elseif kind == "layers" or kind == "platform" then
		Line(10, 5.5, 13, 0, 1.8)
		Line(10, 10, 13, 0, 1.8)
		Line(10, 14.5, 13, 0, 1.8)
	elseif kind == "home" then
		Line(6.5, 7, 9, -45, 2)
		Line(13.5, 7, 9, 45, 2)
		Line(5, 13, 10, 90, 2)
		Line(15, 13, 10, 90, 2)
		Line(10, 18, 10, 0, 2)
	elseif kind == "stats" then
		Line(4, 14, 6, 90, 2.5)
		Line(9, 11.5, 11, 90, 2.5)
		Line(14, 9, 16, 90, 2.5)
	elseif kind == "teleport" then
		Ring(10, 10, 16, 16, 1.8)
		Line(10, 10, 14, 0, 1.5)
		Line(10, 10, 14, 90, 1.5)
		Ring(10, 10, 8, 16, 1.2)
	elseif kind == "settings" then
		Ring(10, 10, 10, 10, 1.8)
		Ring(10, 10, 3, 3, 1.5)
		Line(10, 2.5, 4, 90, 2.5)
		Line(10, 17.5, 4, 90, 2.5)
		Line(2.5, 10, 4, 0, 2.5)
		Line(17.5, 10, 4, 0, 2.5)
	elseif kind == "user" then
		Ring(10, 6.5, 6, 6, 1.8)
		Line(6.5, 14, 7, -35, 2)
		Line(13.5, 14, 7, 35, 2)
		Line(10, 16.8, 9, 0, 2)
	elseif kind == "tools" then
		Line(10, 10, 17, 45, 2.2)
		Line(10, 10, 15, -45, 2.2)
		Line(4.5, 4.5, 5, 0, 2)
		Line(15, 4.7, 4, 90, 2)
	elseif kind == "list" then
		for y = 5, 15, 5 do
			Ring(4, y, 2.5, 2.5, 1.5)
			Line(12, y, 10, 0, 2)
		end
	elseif kind == "play" then
		Line(8.5, 7, 10, 55, 2)
		Line(8.5, 13, 10, -55, 2)
		Line(12.7, 10, 7, 90, 2)
	elseif kind == "eye" then
		Line(6, 7, 10, -28, 2)
		Line(14, 7, 10, 28, 2)
		Line(6, 13, 10, 28, 2)
		Line(14, 13, 10, -28, 2)
		Ring(10, 10, 4.5, 4.5, 1.5)
	elseif kind == "shield" then
		Line(6.5, 5, 8, -20, 2)
		Line(13.5, 5, 8, 20, 2)
		Line(5.3, 11, 11, 78, 2)
		Line(14.7, 11, 11, -78, 2)
		Line(10, 16.3, 9, 0, 2)
	elseif kind == "search" then
		Ring(8.5, 8.5, 11, 11, 2)
		Line(14.5, 14.5, 7, 45, 2)
	elseif kind == "info" then
		Ring(10, 10, 16, 16, 1.8)
		Ring(10, 6, 2, 2, 1.5)
		Line(10, 12, 7, 90, 2)
	elseif kind == "heart" then
		Ring(7, 7, 7, 7, 1.8)
		Ring(13, 7, 7, 7, 1.8)
		Line(6.2, 12, 10, 45, 2)
		Line(13.8, 12, 10, -45, 2)
	elseif kind == "star" or kind == "sun" then
		Ring(10, 10, 6, 6, 1.8)
		for rotation = 0, 135, 45 do
			Line(10, 10, 17, rotation, 1.5)
		end
	elseif kind == "bolt" then
		Line(11, 6, 9, -58, 2.5)
		Line(9, 14, 9, -58, 2.5)
		Line(10, 10, 7, 0, 2.5)
	elseif kind == "sword" then
		Line(11, 8.5, 14, 45, 2.2)
		Line(6.5, 13.5, 7, -45, 2.2)
		Line(4.5, 15.5, 4, 45, 2.2)
		Dot(3, 17, 2.5)
	elseif kind == "target" then
		Ring(10, 10, 15, 15, 1.8)
		Ring(10, 10, 6, 6, 1.4)
		Dot(10, 10, 2)
		Line(10, 2.5, 3.5, 90, 1.6)
		Line(10, 17.5, 3.5, 90, 1.6)
		Line(2.5, 10, 3.5, 0, 1.6)
		Line(17.5, 10, 3.5, 0, 1.6)
	elseif kind == "shop" then
		Line(4.5, 5.5, 4, 0, 2)
		Line(6, 9, 8, 70, 2)
		Line(10.5, 13, 8, 0, 2)
		Line(14.5, 9.5, 8, -75, 2)
		Ring(7.5, 16.5, 3.5, 3.5, 1.5)
		Ring(13.5, 16.5, 3.5, 3.5, 1.5)
	elseif kind == "coin" then
		Ring(10, 10, 16, 16, 1.8)
		Line(10, 10, 10, 90, 1.6)
		Line(10, 7.5, 5, 0, 1.6)
		Line(10, 12.5, 5, 0, 1.6)
		Line(12, 8.5, 3, 90, 1.6)
		Line(8, 11.5, 3, 90, 1.6)
	elseif kind == "diamond" then
		Line(10, 5.5, 9, 0, 1.8)
		Line(4.5, 8, 6, 45, 1.8)
		Line(15.5, 8, 6, -45, 1.8)
		Line(10, 10.5, 14, 0, 1.8)
		Line(6.5, 14.5, 10, -55, 1.8)
		Line(13.5, 14.5, 10, 55, 1.8)
		Line(10, 14, 7, 90, 1.4)
	elseif kind == "flame" then
		Line(6.5, 13, 9, 25, 2)
		Line(13.5, 13, 9, -25, 2)
		Line(10, 17, 8, 0, 2)
		Ring(10, 13.5, 4.5, 6, 1.5)
		Line(10, 6, 6, 90, 2)
	elseif kind == "speed" then
		Line(4.5, 6, 6, 0, 1.8)
		Line(3, 10, 8, 0, 1.8)
		Line(5, 14, 6, 0, 1.8)
		Line(11.5, 9.5, 13, 65, 2.5)
		Line(15.5, 5, 5, 0, 2)
		Line(13.5, 15, 6, 20, 2)
	elseif kind == "rocket" then
		Rect(10, 8.5, 6, 9, 3, 1.8)
		Line(8.5, 4.5, 4.5, 45, 1.8)
		Line(11.5, 4.5, 4.5, -45, 1.8)
		Line(5, 13.5, 5, -35, 2)
		Line(15, 13.5, 5, 35, 2)
		Line(10, 15.5, 4, 0, 1.8)
		Line(10, 17.5, 3.5, 90, 2)
	elseif kind == "bot" then
		Rect(10, 11, 13, 10, 3, 1.8)
		Line(10, 4.5, 3, 90, 1.8)
		Dot(10, 2.5, 2.5)
		Line(2.5, 11, 3, 90, 1.8)
		Line(17.5, 11, 3, 90, 1.8)
		Dot(7.5, 9.5, 2.5)
		Dot(12.5, 9.5, 2.5)
		Line(10, 13.5, 6, 0, 1.6)
	elseif kind == "code" then
		Line(6.5, 8, 6, -45, 2)
		Line(6.5, 12, 6, 45, 2)
		Line(13.5, 8, 6, 45, 2)
		Line(13.5, 12, 6, -45, 2)
		Line(10, 10, 11, 65, 1.8)
	elseif kind == "lock" then
		Ring(10, 7, 8, 8, 1.8)
		Rect(10, 13.5, 13, 9, 2.5, 1.8)
		Dot(10, 12.5, 2.2)
		Line(10, 14.5, 2.5, 90, 1.6)
	elseif kind == "key" then
		Ring(7, 7, 7, 7, 1.8)
		Line(12.5, 12.5, 11, 45, 2)
		Line(14, 11, 3, -45, 2)
		Line(16.5, 13.5, 3, -45, 2)
	elseif kind == "bell" then
		Ring(10, 9, 10, 10, 1.8)
		Line(10, 14, 13, 0, 2)
		Dot(10, 16.5, 3)
		Dot(10, 3.5, 2.5)
	elseif kind == "gift" then
		Rect(10, 13, 13, 9, 2, 1.8)
		Rect(10, 7.5, 15, 3.5, 2, 1.8)
		Line(10, 11, 14, 90, 1.8)
		Ring(8, 4.5, 3.5, 3.5, 1.4)
		Ring(12, 4.5, 3.5, 3.5, 1.4)
	elseif kind == "trophy" then
		Rect(10, 7, 10, 7, 3, 1.8)
		Ring(4.5, 7, 4, 5, 1.5)
		Ring(15.5, 7, 4, 5, 1.5)
		Line(10, 12.5, 4, 90, 2)
		Line(10, 15.5, 10, 0, 2)
	elseif kind == "skull" then
		Ring(10, 8, 12, 10, 1.8)
		Dot(7.5, 8, 2.5)
		Dot(12.5, 8, 2.5)
		Line(10, 14.5, 6, 0, 2)
		Line(8, 13.5, 2.5, 90, 1.6)
		Line(12, 13.5, 2.5, 90, 1.6)
	elseif kind == "book" then
		Line(10, 10.5, 11, 90, 2)
		Line(5.5, 6, 8, 15, 1.8)
		Line(5.5, 15, 8, 15, 1.8)
		Line(2, 10.5, 9, 90, 1.8)
		Line(14.5, 6, 8, -15, 1.8)
		Line(14.5, 15, 8, -15, 1.8)
		Line(18, 10.5, 9, 90, 1.8)
	elseif kind == "potion" then
		Line(10, 3, 4, 0, 2)
		Line(10, 5, 4, 90, 2)
		Ring(10, 12.5, 11, 11, 1.8)
		Line(10, 13, 7, 0, 1.5)
	elseif kind == "music" then
		Dot(6.5, 14.5, 4)
		Dot(14.5, 12.5, 4)
		Line(8, 10.5, 9, 90, 1.8)
		Line(16, 8.5, 9, 90, 1.8)
		Line(12, 5.5, 8.5, -15, 2.5)
	elseif kind == "cloud" then
		Line(10, 15, 12, 0, 2)
		Ring(6.5, 13, 6, 6, 1.6)
		Ring(10, 10.5, 8, 8, 1.6)
		Ring(14, 13, 6, 6, 1.6)
	elseif kind == "moon" then
		Ring(10, 10, 14, 14, 1.8)
		Line(12, 7, 6, 45, 1.8)
		Line(12, 13, 6, -45, 1.8)
		Line(14, 10, 6, 90, 1.8)
	elseif kind == "compass" then
		Ring(10, 10, 16, 16, 1.8)
		Line(10, 10, 10, 45, 2.2)
		Dot(10, 10, 2.5)
	elseif kind == "folder" then
		Line(6, 5, 5, 0, 2)
		Rect(10, 11.5, 14, 10, 2, 1.8)
	elseif kind == "copy" then
		Rect(12, 8, 9, 11, 2, 1.6)
		Rect(8, 12, 9, 11, 2, 1.6)
	elseif kind == "trash" then
		Line(10, 3.5, 4, 0, 1.8)
		Line(10, 5.5, 13, 0, 2)
		Rect(10, 12.5, 9, 10, 2, 1.8)
		Line(8.5, 12.5, 5, 90, 1.4)
		Line(11.5, 12.5, 5, 90, 1.4)
	elseif kind == "sparkles" then
		for _, spec in ipairs({{8, 10, 12}, {15, 4, 5}, {16, 16, 4}}) do
			Line(spec[1], spec[2], spec[3], 0, 1.6)
			Line(spec[1], spec[2], spec[3], 90, 1.6)
		end
		Line(8, 10, 6, 45, 1.3); Line(8, 10, 6, -45, 1.3)
	elseif kind == "crown" then
		Line(10, 16, 13, 0, 1.8)
		Line(3.5, 10.5, 9, 80, 1.8); Line(16.5, 10.5, 9, -80, 1.8)
		Line(5.5, 8.5, 6, 45, 1.8); Line(8.5, 8, 8, -65, 1.8)
		Line(11.5, 8, 8, 65, 1.8); Line(14.5, 8.5, 6, -45, 1.8)
	elseif kind == "users" then
		Ring(7, 6, 5, 5, 1.6); Ring(14, 7, 4, 4, 1.5)
		Rect(7, 14, 10, 6, 3, 1.7); Rect(15, 14.5, 5, 5, 2, 1.5)
	elseif kind == "backpack" then
		Ring(10, 4, 6, 4, 1.6); Rect(10, 11, 13, 14, 4, 1.8)
		Rect(10, 13.5, 8, 5, 1.5, 1.4); Line(10, 7.5, 4, 0, 1.5)
	elseif kind == "calendar" then
		Rect(10, 11, 15, 13, 2, 1.7); Line(10, 8.5, 14, 0, 1.5)
		Line(6, 4.5, 5, 90, 1.8); Line(14, 4.5, 5, 90, 1.8)
		for _, x in ipairs({6, 10, 14}) do Dot(x, 12, 2); Dot(x, 15, 2) end
	elseif kind == "clock" then
		Ring(10, 10, 16, 16, 1.8)
		Line(10, 7, 6, 90, 1.8); Line(12, 11, 5, 27, 1.8)
	elseif kind == "sliders" then
		for i, x in ipairs({4, 10, 16}) do
			Line(x, 10, 15, 90, 1.4)
			Rect(x, i == 2 and 13 or 7, 4, 4, 1, 1.6)
		end
	elseif kind == "gamepad" then
		Rect(10, 11, 17, 11, 4, 1.8)
		Line(6, 11, 5, 0, 1.6); Line(6, 11, 5, 90, 1.6)
		Dot(13, 10, 2); Dot(16, 12, 2)
	elseif kind == "link" then
		local a = Rect(6.5, 12.5, 10, 6, 3, 1.8); a.Rotation = -45
		local b = Rect(13.5, 6.5, 10, 6, 3, 1.8); b.Rotation = -45
		Line(10, 9.5, 7, -45, 1.7)
	elseif kind == "download" or kind == "upload" then
		Line(10, 8, 11, 90, 1.8)
		local y, direction = kind == "download" and 10.5 or 5.5, kind == "download" and 1 or -1
		Line(7.5, y, 7, direction * 45, 1.8); Line(12.5, y, 7, -direction * 45, 1.8)
		Line(10, 17, 14, 0, 1.8); Line(3, 15, 4, 90, 1.8); Line(17, 15, 4, 90, 1.8)
	elseif kind == "flag" then
		Line(4, 10, 16, 90, 1.8); Rect(10, 6, 12, 7, 1, 1.6)
	elseif kind:sub(1, 13) == "rbxassetid://" or tonumber(kind) ~= nil then
		local asset = tonumber(kind) and ("rbxassetid://" .. kind) or kind
		local img = New("ImageLabel", {
			Parent = canvas,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.85, 0.85),
			BackgroundTransparency = 1,
			Image = asset,
			ImageColor3 = T("SubText"),
			ZIndex = zIndex,
		})
		table.insert(parts, img)
	elseif kind == "misc" then
		Ring(10, 6, 6, 6, 1.7)
		Ring(6.5, 13, 6, 6, 1.7)
		Ring(13.5, 13, 6, 6, 1.7)
	else
		Ring(6.5, 6.5, 4, 4, 1.6)
		Ring(13.5, 6.5, 4, 4, 1.6)
		Ring(6.5, 13.5, 4, 4, 1.6)
		Ring(13.5, 13.5, 4, 4, 1.6)
	end

	return holder, parts
end

local function SetGlyphColor(parts, color)
	for _, part in ipairs(parts) do
		if part:IsA("UIStroke") then
			part.Color = color
		elseif part:IsA("ImageLabel") then
			part.ImageColor3 = color
		else
			part.BackgroundColor3 = color
		end
	end
end

local function RegisterGlyphTheme(parts, resolver)
	for _, part in ipairs(parts) do
		local prop = "BackgroundColor3"
		if part:IsA("UIStroke") then
			prop = "Color"
		elseif part:IsA("ImageLabel") then
			prop = "ImageColor3"
		end
		RegisterTheme(part, { [prop] = resolver })
	end
end

local function TweenGlyphColor(parts, color)
	for _, part in ipairs(parts) do
		local property = part:IsA("UIStroke") and "Color" or (part:IsA("ImageLabel") and "ImageColor3" or "BackgroundColor3")
		Tween(part, {[property] = color}, SPEED.Fast)
	end
end

local function ResolveTabIcon(icon, title)
	local requested = tostring(icon or ""):lower():match("^%s*(.-)%s*$")
	if requested:match("^rbxassetid://%d+$") or requested:match("^%d+$") then
		return requested
	end
	if ICONS[requested] then
		return ICONS[requested]
	end

	local search = (requested .. " " .. tostring(title or "")):lower()
	local keywords = {
		{ "setting", "settings" }, { "config", "settings" }, { "option", "settings" },
		{ "main", "home" }, { "home", "home" }, { "hub", "home" }, { "dash", "home" },
		{ "sword", "sword" }, { "combat", "sword" }, { "pvp", "sword" }, { "attack", "sword" }, { "weapon", "sword" },
		{ "target", "target" }, { "aim", "target" }, { "aimbot", "target" }, { "shoot", "target" }, { "gun", "target" },
		{ "bot", "bot" }, { "auto", "bot" }, { "macro", "bot" }, { "robot", "bot" }, { "cpu", "bot" },
		{ "shop", "shop" }, { "store", "shop" }, { "cart", "shop" }, { "market", "shop" }, { "buy", "shop" },
		{ "coin", "coin" }, { "cash", "coin" }, { "money", "coin" }, { "gold", "coin" },
		{ "diamond", "diamond" }, { "gem", "diamond" }, { "crystal", "diamond" },
		{ "speed", "speed" }, { "walk", "speed" }, { "sprint", "speed" }, { "movement", "speed" },
		{ "rocket", "rocket" }, { "fly", "rocket" }, { "flight", "rocket" }, { "jump", "rocket" }, { "boost", "rocket" },
		{ "teleport", "teleport" }, { "map", "teleport" }, { "world", "teleport" }, { "travel", "teleport" }, { "zone", "teleport" },
		{ "compass", "compass" }, { "radar", "compass" }, { "nav", "compass" },
		{ "stat", "stats" }, { "chart", "stats" }, { "level", "stats" }, { "rank", "trophy" }, { "leader", "trophy" },
		{ "reward", "gift" }, { "gift", "gift" }, { "box", "gift" }, { "crate", "gift" }, { "chest", "gift" },
		{ "trophy", "trophy" }, { "badge", "trophy" }, { "medal", "trophy" },
		{ "visual", "eye" }, { "esp", "eye" }, { "cham", "eye" }, { "xray", "eye" },
		{ "player", "user" }, { "character", "user" }, { "avatar", "user" },
		{ "train", "tools" }, { "farm", "tools" }, { "tool", "tools" }, { "build", "tools" }, { "craft", "tools" },
		{ "stage", "play" }, { "play", "play" }, { "game", "play" },
		{ "boss", "shield" }, { "protect", "shield" }, { "shield", "shield" }, { "defense", "shield" },
		{ "skull", "skull" }, { "kill", "skull" }, { "death", "skull" },
		{ "book", "book" }, { "doc", "book" }, { "wiki", "book" }, { "guide", "book" },
		{ "potion", "potion" }, { "buff", "potion" }, { "heal", "potion" }, { "health", "potion" },
		{ "music", "music" }, { "sound", "music" }, { "audio", "music" },
		{ "script", "code" }, { "code", "code" }, { "dev", "code" }, { "exec", "code" },
		{ "lock", "lock" }, { "key", "key" },
		{ "bell", "bell" }, { "alert", "bell" }, { "notif", "bell" },
		{ "cloud", "cloud" }, { "server", "cloud" }, { "ping", "cloud" },
		{ "flame", "flame" }, { "fire", "flame" }, { "streak", "flame" },
		{ "bolt", "bolt" }, { "lightn", "bolt" }, { "power", "bolt" },
		{ "pet", "star" }, { "favorite", "star" }, { "star", "star" }, { "vip", "star" },
		{ "credit", "heart" }, { "heart", "heart" },
		{ "search", "search" },
		{ "misc", "misc" }, { "item", "misc" },
	}

	for _, entry in ipairs(keywords) do
		if string.find(search, entry[1], 1, true) then
			return entry[2]
		end
	end

	return "default"
end

--==================================================
-- DRAG SYSTEM
--==================================================

local function MakeDraggable(frame, handle, maid, options)
	options = options or {}

	local dragging = false
	local moved = false
	local dragStart = Vector2.new()
	local startPosition = frame.Position
	local activeInput = nil

	local function UpdatePosition(inputPosition)
		local delta = Vector2.new(inputPosition.X, inputPosition.Y) - dragStart

		if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
			moved = true
		end

		local newX = startPosition.X.Offset + delta.X
		local newY = startPosition.Y.Offset + delta.Y

		local container = frame.Parent

		if container then
			local ok, viewport = pcall(function()
				return container.AbsoluteSize
			end)

			if ok and viewport and viewport.X > 0 then
				local size = frame.AbsoluteSize
				local margin = 46

				local baseX = startPosition.X.Scale * viewport.X
				local baseY = startPosition.Y.Scale * viewport.Y

				if options.KeepInBounds then
					local inset = 14
					newX = Clamp(newX, inset - baseX, math.max(inset, viewport.X - size.X - inset) - baseX)
					newY = Clamp(newY, inset - baseY, math.max(inset, viewport.Y - size.Y - inset) - baseY)
				else
					newX = Clamp(newX, -baseX - size.X + margin, viewport.X - baseX - margin)
					newY = Clamp(newY, -baseY, viewport.Y - baseY - margin)
				end
			end
		end

		frame.Position = UDim2.new(startPosition.X.Scale, newX, startPosition.Y.Scale, newY)
	end

	maid:Give(handle.InputBegan:Connect(function(input)
		if dragging then return end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			activeInput = input
			moved = false
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			startPosition = frame.Position

			if options.OnStart then
				SafeCallback(options.OnStart)
			end
		end
	end))

	maid:Give(UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if
			(activeInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement)
			or input == activeInput
		then
			UpdatePosition(input.Position)
		end
	end))

	maid:Give(UserInputService.InputEnded:Connect(function(input)
		if not dragging then
			return
		end

		if input == activeInput or (activeInput.UserInputType == Enum.UserInputType.MouseButton1
			and input.UserInputType == Enum.UserInputType.MouseButton1)
		then
			dragging = false
			activeInput = nil

			if options.OnEnd then
				SafeCallback(options.OnEnd, moved)
			end
		end
	end))

	return {
		WasDragged = function()
			return moved
		end,
	}
end

-- Reusable "press and slide" binding used by sliders and colour pickers.
local function BindSlide(trigger, maid, onUpdate)
	local sliding = false

	maid:Give(trigger.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			sliding = true
			onUpdate(InputToGui(input.Position))
		end
	end))

	maid:Give(UserInputService.InputChanged:Connect(function(input)
		if not sliding then
			return
		end

		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			onUpdate(InputToGui(input.Position))
		end
	end))

	maid:Give(UserInputService.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			sliding = false
		end
	end))
end

--==================================================
-- LIBRARY OBJECT + ROOT GUI
--==================================================

local Library = {}

local executionId = tostring(os.clock())
pcall(function()
	executionId = HttpService:GenerateGUID(false)
end)

Library.Name          = LIB_NAME
Library.Version       = LIB_VERSION
Library.ExecutionId   = executionId
Library.Options       = {}
Library.Flags         = {}
Library.Settings      = Settings
Library.Themes        = Themes
Library.Windows       = {}
Library.Notifications = {}
Library.Dialogs       = {}
Library.Unloaded      = false
Library.Unloading     = false
Library.UnloadCallbacks = {}

-- Sorted canonical names by default; pass true to include every alias.
function Library:GetIcons(includeAliases)
	local names, seen = {}, {}
	for alias, canonical in pairs(ICONS) do
		local name = includeAliases and alias or canonical
		if not seen[name] then seen[name] = true; table.insert(names, name) end
	end
	table.sort(names)
	return names
end

function Library:ResolveIcon(icon, title)
	return ResolveTabIcon(icon, title)
end

local LibraryMaid = Maid.new()

-- One shared player for both brand marks. Original GIF timing is preserved.
do
-- BEGIN LOGO TIMING (same as CM hub timing)
local CM_LOGO_DATA = "iVBORw0KGgoAAAANSUhEUgAABAAAAAGwCAIAAAC4jYAGAAEAAElEQVR42rS9dXxU1742vmTv0cxk4kaMkBCCu9NixSmlLdBSd9rSnvbUTt1O3YW6UEoNKYUa7hSHIEkgCRKbiY5kkpG991q/P7atPUnPPfd93x/3c7ncEka+e62vPt/ngQgiCAEAEAAIAACAAgAoBRACAAAEEABAAQXKLwj0PwMIIFX/ieE/UgAgZV4QQvU1IYQAAEophBBAIP8nAACEkFKqvQdgfgxC+QUBZD8YhMqLAEAIlV+ZUgAAlf9KfwuqfQpAKQUQAMJ+I0oBgBACCgClhFL19ZEQjbz37vsnTpxMSkosPX78z01/8hxPJAKg/MWp9oGB+goUUPnDM38FtY8EAVQ+g249qn5XAAD6/8H+VHsR7UnI76v8WwSh+vaUEgBkeysPQTZa9/aXXyTW/von0Z6O/Gf2Ect/pf4wpVQ/FfKPQggABUSSbDbbkiX3fPrpJ0uXLq2trV3+zdcmziQR6f+l/eXHr31lQLUv/vf21w37X9pfuwygW/srh/M/2V+25d/Yn6jXhDI/ydhc/WaU0pgDBBRrxNqfUgAIBYBiDj/6yGOtrW0LFy689967T546yWOeUiqbTrOMbuFYcyn/+x/OPwD/yf7sqymeQX535i3+5lJ0Z3/NH2kPFwKIEaCAEqKYH2oGYY1JIUT68wcQ6CecPcP/rf2h9lWp7u7kRwAAQAASStS/RIBSAojT4RBFMRwKK8+dkq7nHwDjYTTYP+ZqaOaFjHGo8rty9hBGiAIqiqL8Axhi5X5S9mmxFxCCLr8oBEg79pRSQCFE+qvIrwiNN0x9VKqrj3GA+h/Yb6S+EgSxptB8KwDaCacUqC8uvwYEgFKKmKevHyP11BnPZHfvAbv/G9kTAUJZi1NKoRyCqcH+EECMMaVUlBTLFxYUNjY1tQfbMURUDWUx9u/2e8c8YOX1Ifspu7M/jf17+WEo1pZPPHucoP5OsItX/Hv7K/9KuS+s/fVXpVo0kd3I/7n9VQek2x9QCFQnDAChBCEkEQkAkJ6WPnfu5Q
