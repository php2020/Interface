SLASH_RL1 = '/rl'
function SlashCmdList.RL(msg, editbox)
	ReloadUI();
end

SLASH_KEYBIND1 = '/kb'
function SlashCmdList.KEYBIND(msg, editbox)
	zUI.zKeybind:Show();
end

SLASH_ZUI1 = "/zui" -- test stuff
function SlashCmdList.ZUI(msg, editbox)
	if zUI.gui:IsShown() then
		zUI.gui:Hide()
	else
		zUI.gui:Show()
	end
end
-- 创建ZUI基本框体
zUI = CreateFrame("Frame", nil, UIParent);
-- 注册事件 插件加载时
zUI:RegisterEvent("ADDON_LOADED");
-- 加载指示
zUI.loading = true;

-- 初始化保存的变量
zUI_playerDB = {} -- 玩家数据库
zUI_config = {} -- 配置
zUI_init = {} -- 初始
zUI_profiles = {} -- 简介
zUI_addon_profiles = {} -- 插件简介

-- 本地化
zUI_locale = {} -- 本地语言
zUI_translation = {} -- 本地翻译

-- 初始化默认变量
zUI.loc = GetLocale() -- 获取本地语言
zUI.cache = {} -- 缓存
zUI.component = {} -- 组件
zUI.components = {} -- 所有组件
zUI.skin = {} -- 皮肤
zUI.skins = {} -- 所有皮肤
zUI.environment = {} -- 环境变量
zUI.movables = {}
zUI.version = {} -- 版本
zUI.hooks = {} -- 钩子
zUI.env = {} -- env 配置
zUI.Classicmacro=false -- 宏
zUI.api={} -- 自定义的api

-- 获取当前版本
local _, _, _, client = GetBuildInfo();
zUI.client = client or 11200;

-- 职业颜色
function zUI:UpdateColors()
	RAID_CLASS_COLORS = {
		["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, colorStr = "ffc79c6e" },
		["MAGE"]    = { r = 0.41, g = 0.8, b = 0.94, colorStr = "ff69ccf0" },
		["ROGUE"]   = { r = 1, g = 0.96, b = 0.41, colorStr = "fffff569" },
		["DRUID"]   = { r = 1, g = 0.49, b = 0.04, colorStr = "ffff7d0a" },
		["HUNTER"]  = { r = 0.67, g = 0.83, b = 0.45, colorStr = "ffabd473" },
		["SHAMAN"]  = { r = 0.14, g = 0.35, b = 1.0, colorStr = "ff0070de" },
		["PRIEST"]  = { r = 1, g = 1, b = 1, colorStr = "ffffffff" },
		["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, colorStr = "ff9482c9" },
		["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, colorStr = "fff58cba" },
	}
	-- 未知 index 时返回一个 灰色
	RAID_CLASS_COLORS = setmetatable(RAID_CLASS_COLORS, {
		__index = function(tab, key)
			return { r = 0.6, g = 0.6, b = 0.6, colorStr = "ff999999" }
		end
	})
end

-- 打印
function zPrint(txt)
	local _, class = UnitClass("player")
	local color = RAID_CLASS_COLORS[class].colorStr
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffd200z|c" .. color .. "UI|r - " .. txt)
	end
end
-- 设置一个命名空间 zUI.env，以防止在当前环境中引入过多的全局变量，从而减少对全局命名空间的污染
setmetatable(zUI.env, { __index = getfenv(0) })

-- 获取 env 配置信息
function zUI:GetEnvironment()
	-- 加载 api 到 env 里
	for n, func in pairs(zUI.api or {}) do
		zUI.env[n] = func
	end

	-- 加载本地翻译
	local lang = zUI_config.global and zUI_translation[zUI_config.global.language] and zUI_config.global.language or GetLocale()
	local T = setmetatable(zUI_translation[lang] or {}, {
		__index = function(tab, key)
			local value = tostring(key)
			rawset(tab, key, value)
			return value
		end
	})

	zUI.env._G = getfenv(0)
	zUI.env.T = T -- 本地翻译
	zUI.env.C = zUI_config -- config 配置
	zUI.env.L = (zUI_locale[GetLocale()] or zUI_locale["enUS"]) -- 本地语言

	return zUI.env
end

-- 注册组件
function zUI:RegisterComponent(n, f)
	if zUI.component[n] then return end
	zUI.component[n] = f
	table.insert(zUI.components, n)
	if not zUI.loading then
		zUI:LoadComponent(n)
	end
end

-- 注册皮肤
function zUI:RegisterSkin(s, f)
	if zUI.skin[s] then return end
	zUI.skin[s] = f
	table.insert(zUI.skins, s)
	if not zUI.loading then
		zUI:LoadSkin(s)
	end
end

-- 加载组件
function zUI:LoadComponent(c)
	setfenv(zUI.component[c], zUI:GetEnvironment())
	--zPrint(fontOrange.. c .."|r component " ..fontGreen.. "Loaded.") --nice little load msg
	zUI.component[c]()
end

-- 加载皮肤
function zUI:LoadSkin(s)
	setfenv(zUI.skin[s], zUI:GetEnvironment())
	--zPrint(fontLightBlue.. s .."|r skin " ..fontGreen.. "Loaded.") --nice little load msg
	zUI.skin[s]()
end

-- 设置事件
zUI:SetScript("OnEvent", function()
	zUI:UpdateColors();

	--匹配命令
	if arg1 == "zUI" then
		-- ADDON LOADED, READY FOR ACTION
		--zPrint("Core initiating component load sequence.")
		-- zPrint("Thank's for using zUI, type /zui for options frame.");
		-- zPrint("/kb to bind your keys.");
		-- zPrint("/calc to show the calculator.");

		local major, minor, fix = zUI.api.strsplit(".", tostring(GetAddOnMetadata("zUI", "Version")))
		zUI.version.major       = tonumber(major) or 1
		zUI.version.minor       = tonumber(minor) or 2
		zUI.version.fix         = tonumber(fix) or 0
		zUI.version.string      = zUI.version.major .. "." .. zUI.version.minor .. "." .. zUI.version.fix

		-- 加载配置文件
		zUI:LoadConfig()

		-- 加载组件
		for _, c in pairs(this.components) do
			if not (zUI_config["disabled"] and zUI_config["disabled"][c] == "1") then
				zUI:LoadComponent(c)
			end
		end

		-- 加载皮肤
		for _, s in pairs(this.skins) do
			if not (zUI_config["disabled"] and zUI_config["disabled"]["skin_" .. s] == "1") then
				zUI:LoadSkin(s)
			end
		end

		zUI.loading = nil;
	end
end)

-- 背景
zUI.backdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	tile = false,
	tileSize = 0,
	edgeFile = "Interface\\BUTTONS\\WHITE8X8",
	edgeSize = 1,
	insets = { left = -1, right = -1, top = -1, bottom = -1 },
}

-- 背景无顶部
zUI.backdrop_no_top = zUI.backdrop

-- 背景悬停
zUI.backdrop_hover  = {
	edgeFile = "Interface\\BUTTONS\\WHITE8X8",
	edgeSize = 24,
	insets = { left = -1, right = -1, top = -1, bottom = -1 },
}

-- 平面纹理
--ZUI_FLAT_TEXTURE   = [[Interface\AddOns\zUI\img\name]]
ZUI_FLAT_TEXTURE    = [[Interface\BUTTONS\WHITE8X8]]
ZUI_ORIG_TEXTURE    = [[Interface\TargetingFrame\UI-StatusBar.blp]]

-- 颜色
fontLightBlue  = "|cff00e0ff"
fontLightGreen = "|cff60ff60"
fontLightRed   = "|cffff8080"
fontRed        = "|cffff0000"
fontOrange     = "|cffff7000"
fontWhite      = "|cffffffff"
fontGreen      = "|cff00ff00"
fontBlue       = "|cff068fff"
