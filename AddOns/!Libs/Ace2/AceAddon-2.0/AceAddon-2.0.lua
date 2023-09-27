--[[
Name: AceAddon-2.0
Revision: $Rev: 17957 $
Developed by: The Ace Development Team (http://www.wowace.com/index.php/The_Ace_Development_Team)
Inspired By: Ace 1.x by Turan (turan@gryphon.com)
Website: http://www.wowace.com/
Documentation: http://www.wowace.com/index.php/AceAddon-2.0
SVN: http://svn.wowace.com/root/trunk/Ace2/AceAddon-2.0
Description: Base for all Ace addons to inherit from.
Dependencies: AceLibrary, AceOO-2.0, AceEvent-2.0, (optional) AceConsole-2.0
]]

local MAJOR_VERSION = "AceAddon-2.0"
local MINOR_VERSION = "$Revision: 17957 $"

-- This ensures the code is only executed if the libary doesn't already exist, or is a newer version
if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary.") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end

if loadstring("return function(...) return ... end") and AceLibrary:HasInstance(MAJOR_VERSION) then return end -- lua51 check
if not AceLibrary:HasInstance("AceOO-2.0") then error(MAJOR_VERSION .. " requires AceOO-2.0.") end

local function safecall(func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
	local success, err = pcall(func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
	if not success then geterrorhandler()(err) end
end

-- Localization
local STANDBY, TITLE, NOTES, VERSION, AUTHOR, DATE, CATEGORY, EMAIL, CREDITS, WEBSITE, COMMANDS, CATEGORIES, ABOUT, PRINT_ADDON_INFO
if GetLocale() == "deDE" then
	STANDBY = "|cffff5050(Standby)|r" -- capitalized

	TITLE = "Titel"
	NOTES = "Anmerkung"
	VERSION = "Version"
	AUTHOR = "Autor"
	DATE = "Datum"
	CATEGORY = "Kategorie"
	EMAIL = "E-mail"
	WEBSITE = "Webseite"
	CREDITS = "Credits" -- fix
	COMMANDS = "Commands"
	
	ABOUT = "\195\188ber"
	PRINT_ADDON_INFO = "Gibt Addondaten aus"

	CATEGORIES = {
		["Action Bars"] = "Aktionsleisten",
		["Auction"] = "Auktion",
		["Audio"] = "Audio",
		["Battlegrounds/PvP"] = "Schlachtfeld/PvP",
		["Buffs"] = "Buffs",
		["Chat/Communication"] = "Chat/Kommunikation",
		["Druid"] = "Druide",
		["Hunter"] = "Jäger",
		["Mage"] = "Magier",
		["Paladin"] = "Paladin",
		["Priest"] = "Priester",
		["Rogue"] = "Schurke",
		["Shaman"] = "Schamane",
		["Warlock"] = "Hexenmeister",
		["Warrior"] = "Krieger",
		["Healer"] = "Heiler",
		["Tank"] = "Tank", -- noone use "Brecher"...
		["Caster"] = "Caster",
		["Combat"] = "Kampf",
		["Compilations"] = "Compilations", -- whats that o_O
		["Data Export"] = "Datenexport",
		["Development Tools"] = "Entwicklungs Tools",
		["Guild"] = "Gilde",
		["Frame Modification"] = "Frame Modifikation",
		["Interface Enhancements"] = "Interface Verbesserungen",
		["Inventory"] = "Inventar",
		["Library"] = "Library",
		["Map"] = "Map",
		["Mail"] = "Mail",
		["Miscellaneous"] = "Diverses",
		["Quest"] = "Quest",
		["Raid"] = "Schlachtzug",
		["Tradeskill"] = "Handelsf\195\164higkeit",
		["UnitFrame"] = "UnitFrame",
	}
elseif GetLocale() == "frFR" then
	STANDBY = "|cffff5050(attente)|r"
	
	TITLE = "Titre"
	NOTES = "Notes"
	VERSION = "Version"
	AUTHOR = "Auteur"
	DATE = "Date"
	CATEGORY = "Cat\195\169gorie"
	EMAIL = "E-mail"
	WEBSITE = "Site web"
	CREDITS = "Credits" -- fix
	COMMANDS = "Commands"
	
	ABOUT = "A propos"
	PRINT_ADDON_INFO = "Afficher les informations sur l'addon"
	
	CATEGORIES = {
		["Action Bars"] = "Barres d'action",
		["Auction"] = "H\195\180tel des ventes",
		["Audio"] = "Audio",
		["Battlegrounds/PvP"] = "Champs de bataille/JcJ",
		["Buffs"] = "Buffs",
		["Chat/Communication"] = "Chat/Communication",
		["Druid"] = "Druide",
		["Hunter"] = "Chasseur",
		["Mage"] = "Mage",
		["Paladin"] = "Paladin",
		["Priest"] = "Pr\195\170tre",
		["Rogue"] = "Voleur",
		["Shaman"] = "Chaman",
		["Warlock"] = "D\195\169moniste",
		["Warrior"] = "Guerrier",
		["Healer"] = "Soigneur",
		["Tank"] = "Tank",
		["Caster"] = "Casteur",
		["Combat"] = "Combat",
		["Compilations"] = "Compilations",
		["Data Export"] = "Exportation de donn\195\169es",
		["Development Tools"] = "Outils de d\195\169veloppement",
		["Guild"] = "Guilde",
		["Frame Modification"] = "Modification des fen\195\170tres",
		["Interface Enhancements"] = "Am\195\169liorations de l'interface",
		["Inventory"] = "Inventaire",
		["Library"] = "Biblioth\195\168ques",
		["Map"] = "Carte",
		["Mail"] = "Courrier",
		["Miscellaneous"] = "Divers",
		["Quest"] = "Qu\195\170tes",
		["Raid"] = "Raid",
		["Tradeskill"] = "M\195\169tiers",
		["UnitFrame"] = "Fen\195\170tres d'unit\195\169",
	}
elseif GetLocale() == "koKR" then
	STANDBY = "|cffff5050(ì‚¬ìš©ê°€ëŠ¥)|r"
	
	TITLE = "ì œëª©"
	NOTES = "ë…¸íŠ¸"
	VERSION = "ë²„ì „"
	AUTHOR = "ì €ìž‘ìž"
	DATE = "ë‚ ì§œ"
	CATEGORY = "ë¶„ë¥˜"
	EMAIL = "E-mail"
	WEBSITE = "ì›¹ì‚¬ì´íŠ¸"
	CREDITS = "Credits" -- fix
	COMMANDS = "Commands"
	
	ABOUT = "ì •ë³´"
	PRINT_ADDON_INFO = "ì• ë“œì˜¨ ì •ë³´ ì¶œë ¥"
	
	CATEGORIES = {
		["Action Bars"] = "ì•¡ì…˜ë°”",
		["Auction"] = "ê²½ë§¤",
		["Audio"] = "ìŒí–¥",
		["Battlegrounds/PvP"] = "ì „ìž¥/PvP",
		["Buffs"] = "ë²„í”„",
		["Chat/Communication"] = "ëŒ€í™”/ì˜ì‚¬ì†Œí†µ",
		["Druid"] = "ë“œë£¨ì´ë“œ",
		["Hunter"] = "ì‚¬ëƒ¥ê¾¼",
		["Mage"] = "ë§ˆë²•ì‚¬",
		["Paladin"] = "ì„±ê¸°ì‚¬",
		["Priest"] = "ì‚¬ì œ",
		["Rogue"] = "ë„ì ",
		["Shaman"] = "ì£¼ìˆ ì‚¬",
		["Warlock"] = "í‘ë§ˆë²•ì‚¬",
		["Warrior"] = "ì „ì‚¬",
		["Healer"] = "ížëŸ¬",
		["Tank"] = "íƒ±ì»¤",
		["Caster"] = "ìºìŠ¤í„°",
		["Combat"] = "ì „íˆ¬",
		["Compilations"] = "ë³µí•©",
		["Data Export"] = "ìžë£Œ ì¶œë ¥",
		["Development Tools"] = "ê°œë°œ ë„êµ¬",
		["Guild"] = "ê¸¸ë“œ",
		["Frame Modification"] = "êµ¬ì¡° ë³€ê²½",
		["Interface Enhancements"] = "ì¸í„°íŽ˜ì´ìŠ¤ ê°•í™”",
		["Inventory"] = "ì¸ë²¤í† ë¦¬",
		["Library"] = "ë¼ì´ë¸ŒëŸ¬ë¦¬",
		["Map"] = "ì§€ë„",
		["Mail"] = "ìš°íŽ¸",
		["Miscellaneous"] = "ê¸°íƒ€",
		["Quest"] = "í€˜ìŠ¤íŠ¸",
		["Raid"] = "ê³µê²©ëŒ€",
		["Tradeskill"] = "ì „ë¬¸ê¸°ìˆ ",
		["UnitFrame"] = "ìœ ë‹› í”„ë ˆìž„",
	}
elseif GetLocale() == "zhTW" then
	STANDBY = "|cffff5050(å¾…å‘½)|r"
	
	TITLE = "æ¨™é¡Œ"
	NOTES = "è¨»è¨˜"
	VERSION = "ç‰ˆæœ¬"
	AUTHOR = "ä½œè€…"
	DATE = "æ—¥æœŸ"
	CATEGORY = "é¡žåˆ¥"
	EMAIL = "E-mail"
	WEBSITE = "ç¶²ç«™"
	CREDITS = "Credits" -- fix
	COMMANDS = "Commands"
	
	ABOUT = "é—œæ–¼"
	PRINT_ADDON_INFO = "é¡¯ç¤ºæ’ä»¶è³‡è¨Š"
	
	CATEGORIES = {
		["Action Bars"] = "å‹•ä½œåˆ—",
		["Auction"] = "æ‹è³£",
		["Audio"] = "éŸ³æ¨‚",
		["Battlegrounds/PvP"] = "æˆ°å ´/PvP",
		["Buffs"] = "å¢žç›Š",
		["Chat/Communication"] = "èŠå¤©/é€šè¨Š",
		["Druid"] = "å¾·é­¯ä¼Š",
		["Hunter"] = "çµäºº",
		["Mage"] = "æ³•å¸«",
		["Paladin"] = "è–é¨Žå£«",
		["Priest"] = "ç‰§å¸«",
		["Rogue"] = "ç›œè³Š",
		["Shaman"] = "è–©æ»¿",
		["Warlock"] = "è¡“å£«",
		["Warrior"] = "æˆ°å£«",
		["Healer"] = "æ²»ç™‚è€…",
		["Tank"] = "å¦å…‹",
		["Caster"] = "æ–½æ³•è€…",
		["Combat"] = "æˆ°é¬¥",
		["Compilations"] = "ç·¨è¼¯",
		["Data Export"] = "è³‡æ–™åŒ¯å‡º",
		["Development Tools"] = "é–‹ç™¼å·¥å…·",
		["Guild"] = "å…¬æœƒ",
		["Frame Modification"] = "æ¡†æž¶ä¿®æ”¹",
		["Interface Enhancements"] = "ä»‹é¢å¢žå¼·",
		["Inventory"] = "èƒŒåŒ…",
		["Library"] = "è³‡æ–™åº«",
		["Map"] = "åœ°åœ–",
		["Mail"] = "éƒµä»¶",
		["Miscellaneous"] = "ç¶œåˆ",
		["Quest"] = "ä»»å‹™",
		["Raid"] = "åœ˜éšŠ",
		["Tradeskill"] = "å•†æ¥­æŠ€èƒ½",
		["UnitFrame"] = "å–®ä½æ¡†æž¶",
	}
elseif GetLocale() == "zhCN" then
	STANDBY = "|cffff5050(暂挂)|r"
	
	TITLE = "标题"
	NOTES = "附注"
	VERSION = "版本"
	AUTHOR = "作者"
	DATE = "日期"
	CATEGORY = "分类"
	EMAIL = "电子邮件"
	WEBSITE = "网站"
	CREDITS = "Credits" -- fix
	COMMANDS = "Commands"
	
	ABOUT = "关于"
	PRINT_ADDON_INFO = "印列出插件信息"
	
	CATEGORIES = {
		["Action Bars"] = "动作条",
		["Auction"] = "拍卖",
		["Audio"] = "音频",
		["Battlegrounds/PvP"] = "战场/PvP",
		["Buffs"] = "增益魔法",
		["Chat/Communication"] = "聊天/交流",
		["Druid"] = "德鲁伊",
		["Hunter"] = "猎人",
		["Mage"] = "法师",
		["Paladin"] = "圣骑士",
		["Priest"] = "牧师",
		["Rogue"] = "盗贼",
		["Shaman"] = "萨满祭司",
		["Warlock"] = "术士",
		["Warrior"] = "战士",
		["Healer"] = "治疗保障",
		["Tank"] = "近战控制",
		["Caster"] = "远程输出",
		["Combat"] = "战斗",
		["Compilations"] = "编译",
		["Data Export"] = "数据导出",
		["Development Tools"] = "开发工具",
		["Guild"] = "公会",
		["Frame Modification"] = "框架修改",
		["Interface Enhancements"] = "界面增强",
		["Inventory"] = "背包",
		["Library"] = "库",
		["Map"] = "地图",
		["Mail"] = "邮件",
		["Miscellaneous"] = "杂项",
		["Quest"] = "任务",
		["Raid"] = "团队",
		["Tradeskill"] = "商业技能",
		["UnitFrame"] = "头像框架",
	}
elseif GetLocale() == "ruRU" then
	STANDBY = "|cffff5050(Ð² Ñ€ÐµÐ¶Ð¸Ð¼Ðµ Ð¾Ð¶Ð¸Ð´Ð°Ð½Ð¸Ñ)|r"
	
	TITLE = "ÐÐ°Ð·Ð²Ð°Ð½Ð¸Ðµ"
	NOTES = "ÐžÐ¿Ð¸ÑÐ°Ð½Ð¸Ðµ"
	VERSION = "Ð’ÐµÑ€ÑÐ¸Ñ"
	AUTHOR = "ÐÐ²Ñ‚Ð¾Ñ€"
	DATE = "Ð”Ð°Ñ‚Ð°"
	CATEGORY = "ÐšÐ°Ñ‚ÐµÐ³Ð¾Ñ€Ð¸Ñ"
	EMAIL = "E-mail"
	WEBSITE = "Ð¡Ð°Ð¹Ñ‚"
	CREDITS = "Ð¢Ð¸Ñ‚Ñ€Ñ‹"
	COMMANDS = "ÐšÐ¾Ð¼Ð°Ð½Ð´Ñ‹"
	
	ABOUT = "ÐžÐ± Ð°Ð´Ð´Ð¾Ð½Ðµ"
	PRINT_ADDON_INFO = "ÐŸÐ¾ÐºÐ°Ð·Ð°Ñ‚ÑŒ Ð¸Ð½Ñ„Ð¾Ñ€Ð¼Ð°Ñ†Ð¸ÑŽ Ð¾Ð± Ð°Ð´Ð´Ð¾Ð½Ðµ."
	
	CATEGORIES = {
		["Action Bars"] = "ÐŸÐ°Ð½ÐµÐ»Ð¸ ÐºÐ¾Ð¼Ð°Ð½Ð´",
		["Auction"] = "ÐÑƒÐºÑ†Ð¸Ð¾Ð½",
		["Audio"] = "ÐÑƒÐ´Ð¸Ð¾",
		["Battlegrounds/PvP"] = "ÐŸÐ¾Ð»Ñ ÑÑ€Ð°Ð¶ÐµÐ½Ð¸Ð¹/PvP",
		["Buffs"] = "Ð‘Ð°Ñ„Ñ„Ñ‹",
		["Chat/Communication"] = "Ð§Ð°Ñ‚/ÐšÐ¾Ð¼Ð¼ÑƒÐ½Ð¸ÐºÐ°Ñ†Ð¸Ñ",
		["Druid"] = "Ð”Ñ€ÑƒÐ¸Ð´",
		["Hunter"] = "ÐžÑ…Ð¾Ñ‚Ð½Ð¸Ðº",
		["Mage"] = "ÐœÐ°Ð³",
		["Paladin"] = "ÐŸÐ°Ð»Ð°Ð´Ð¸Ð½",
		["Priest"] = "Ð–Ñ€ÐµÑ†",
		["Rogue"] = "Ð Ð°Ð·Ð±Ð¾Ð¹Ð½Ð¸Ðº",
		["Shaman"] = "Ð¨Ð°Ð¼Ð°Ð½",
		["Warlock"] = "Ð§ÐµÑ€Ð½Ð¾ÐºÐ½Ð¸Ð¶Ð½Ð¸Ðº",
		["Warrior"] = "Ð’Ð¾Ð¸Ð½",
		["Healer"] = "Ð›ÐµÐºÐ°Ñ€ÑŒ",
		["Tank"] = "Ð¢Ð°Ð½Ðº",
		["Caster"] = "ÐšÐ°ÑÑ‚ÐµÑ€",
		["Combat"] = "Ð¡Ñ€Ð°Ð¶ÐµÐ½Ð¸Ñ",
		["Compilations"] = "ÐšÐ¾Ð¼Ð¿Ð¸Ð»ÑÑ†Ð¸Ñ",
		["Data Export"] = "Ð­ÐºÑÐ¿Ð¾Ñ€Ñ‚ Ð´Ð°Ð½Ð½Ñ‹Ñ…",
		["Development Tools"] = "Ð˜Ð½ÑÑ‚Ñ€ÑƒÐ¼ÐµÐ½Ñ‚Ñ‹ Ñ€Ð°Ð·Ñ€Ð°Ð±Ð¾Ñ‚Ñ‡Ð¸ÐºÐ°",
		["Guild"] = "Ð“Ð¸Ð»ÑŒÐ´Ð¸Ñ",
		["Frame Modification"] = "ÐœÐ¾Ð´Ð¸Ñ„Ð¸ÐºÐ°Ñ†Ð¸Ñ Ñ„Ñ€ÐµÐ¹Ð¼Ð¾Ð²",
		["Interface Enhancements"] = "Ð£Ð»ÑƒÑ‡ÑˆÐµÐ½Ð¸Ðµ Ð¸Ð½Ñ‚ÐµÑ€Ñ„ÐµÐ¹ÑÐ°",
		["Inventory"] = "Ð˜Ð½Ð²ÐµÐ½Ñ‚Ð°Ñ€ÑŒ",
		["Library"] = "Ð‘Ð¸Ð±Ð»Ð¸Ð¾Ñ‚ÐµÐºÐ¸",
		["Map"] = "ÐšÐ°Ñ€Ñ‚Ð°",
		["Mail"] = "ÐŸÐ¾Ñ‡Ñ‚Ð°",
		["Miscellaneous"] = "Ð Ð°Ð·Ð½Ð¾Ðµ",
		["Quest"] = "Ð—Ð°Ð´Ð°Ð½Ð¸Ñ",
		["Raid"] = "Ð ÐµÐ¹Ð´",
		["Tradeskill"] = "Ð£Ð¼ÐµÐ½Ð¸Ñ",
		["UnitFrame"] = "Ð¤Ñ€ÐµÐ¹Ð¼Ñ‹ Ð¿ÐµÑ€ÑÐ¾Ð½Ð°Ð¶ÐµÐ¹",
	}
	else -- enUS
	STANDBY = "|cffff5050(standby)|r"
	
	TITLE = "Title"
	NOTES = "Notes"
	VERSION = "Version"
	AUTHOR = "Author"
	DATE = "Date"
	CATEGORY = "Category"
	EMAIL = "E-mail"
	WEBSITE = "Website"
	CREDITS = "Credits"
	COMMANDS = "Commands"
	
	ABOUT = "About"
	PRINT_ADDON_INFO = "Print out addon info"
	
	CATEGORIES = {
		["Action Bars"] = "Action Bars",
		["Auction"] = "Auction",
		["Audio"] = "Audio",
		["Battlegrounds/PvP"] = "Battlegrounds/PvP",
		["Buffs"] = "Buffs",
		["Chat/Communication"] = "Chat/Communication",
		["Druid"] = "Druid",
		["Hunter"] = "Hunter",
		["Mage"] = "Mage",
		["Paladin"] = "Paladin",
		["Priest"] = "Priest",
		["Rogue"] = "Rogue",
		["Shaman"] = "Shaman",
		["Warlock"] = "Warlock",
		["Warrior"] = "Warrior",
		["Healer"] = "Healer",
		["Tank"] = "Tank",
		["Caster"] = "Caster",
		["Combat"] = "Combat",
		["Compilations"] = "Compilations",
		["Data Export"] = "Data Export",
		["Development Tools"] = "Development Tools",
		["Guild"] = "Guild",
		["Frame Modification"] = "Frame Modification",
		["Interface Enhancements"] = "Interface Enhancements",
		["Inventory"] = "Inventory",
		["Library"] = "Library",
		["Map"] = "Map",
		["Mail"] = "Mail",
		["Miscellaneous"] = "Miscellaneous",
		["Quest"] = "Quest",
		["Raid"] = "Raid",
		["Tradeskill"] = "Tradeskill",
		["UnitFrame"] = "UnitFrame",
	}
end

setmetatable(CATEGORIES, { __index = function(self, key) -- case-insensitive
	local lowerKey = string.lower(key)
	for k,v in pairs(CATEGORIES) do
		if string.lower(k) == lowerKey then
			return v
		end
	end
end })

-- Create the library object

local AceOO = AceLibrary("AceOO-2.0")
local AceAddon = AceOO.Class()
local AceEvent
local AceConsole
local AceModuleCore

function AceAddon:ToString()
	return "AceAddon"
end

local function print(text)
	DEFAULT_CHAT_FRAME:AddMessage(text)
end

function AceAddon:ADDON_LOADED(name)
	while table.getn(self.nextAddon) > 0 do
		local addon = table.remove(self.nextAddon, 1)
		table.insert(self.addons, addon)
		if not self.addons[name] then
			self.addons[name] = addon
		end
		self:InitializeAddon(addon, name)
	end
end

local function RegisterOnEnable(self)
	if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.defaultLanguage then -- HACK
		AceAddon.playerLoginFired = true
	end
	if AceAddon.playerLoginFired then
		AceAddon.addonsStarted[self] = true
		if (type(self.IsActive) ~= "function" or self:IsActive()) and (not AceModuleCore or not AceModuleCore:IsModule(self) or AceModuleCore:IsModuleActive(self)) then
			local current = self.class
			while true do
				if current == AceOO.Class then
					break
				end
				if current.mixins then
					for mixin in pairs(current.mixins) do
						if type(mixin.OnEmbedEnable) == "function" then
							safecall(mixin.OnEmbedEnable,mixin,self)
						end
					end
				end
				current = current.super
			end
			if type(self.OnEnable) == "function" then
				safecall(self.OnEnable,self)
			end
			if AceEvent then
				AceEvent:TriggerEvent("Ace2_AddonEnabled", self)
			end
		end
	else
		if not AceAddon.addonsToOnEnable then
			AceAddon.addonsToOnEnable = {}
		end
		table.insert(AceAddon.addonsToOnEnable, self)
	end
end

local function stripSpaces(text)
	if type(text) == "string" then
		return (string.gsub(string.gsub(text, "^%s*(.-)%s*$", "%1"), "%s%s+", " "))
	end
	return text
end

function AceAddon:InitializeAddon(addon, name)
	if addon.name == nil then
		addon.name = name
	end
	if GetAddOnMetadata then
		-- TOC checks
		if addon.title == nil then
			addon.title = GetAddOnMetadata(name, "Title")
		end
		if addon.title then
			local num = string.find(addon.title, " |cff7fff7f %-Ace2%-|r$")
			if num then
				addon.title = string.sub(addon.title, 1, num - 1)
			end
			addon.title = stripSpaces(addon.title)
		end
		
		if addon.notes == nil then
			addon.notes = GetAddOnMetadata(name, "Notes")
			addon.notes = stripSpaces(addon.notes)
		end
		if addon.version == nil then
			addon.version = GetAddOnMetadata(name, "Version")
		end
		if addon.version then
			if string.find(addon.version, "%$Revision: (%d+) %$") then
				addon.version = string.gsub(addon.version, "%$Revision: (%d+) %$", "%1")
			elseif string.find(addon.version, "%$Rev: (%d+) %$") then
				addon.version = string.gsub(addon.version, "%$Rev: (%d+) %$", "%1")
			elseif string.find(addon.version, "%$LastChangedRevision: (%d+) %$") then
				addon.version = string.gsub(addon.version, "%$LastChangedRevision: (%d+) %$", "%1")
			end
		end
		addon.version = stripSpaces(addon.version)
		if addon.author == nil then
			addon.author = GetAddOnMetadata(name, "Author")
			addon.author = stripSpaces(addon.author)
		end
		if addon.credits == nil then
			addon.credits = GetAddOnMetadata(name, "X-Credits")
			addon.credits = stripSpaces(addon.credits)
		end
		if addon.date == nil then
			addon.date = GetAddOnMetadata(name, "X-Date") or GetAddOnMetadata(name, "X-ReleaseDate")
		end
		if addon.date then
			if string.find(addon.date, "%$Date: (.-) %$") then
				addon.date = string.gsub(addon.date, "%$Date: (.-) %$", "%1")
			elseif string.find(addon.date, "%$LastChangedDate: (.-) %$") then
				addon.date = string.gsub(addon.date, "%$LastChangedDate: (.-) %$", "%1")
			end
		end
		addon.date = stripSpaces(addon.date)

		if addon.category == nil then
			addon.category = GetAddOnMetadata(name, "X-Category")
			addon.category = stripSpaces(addon.category)
		end
		if addon.email == nil then
			addon.email = GetAddOnMetadata(name, "X-eMail") or GetAddOnMetadata(name, "X-Email")
			addon.email = stripSpaces(addon.email)
		end
		if addon.website == nil then
			addon.website = GetAddOnMetadata(name, "X-Website")
			addon.website = stripSpaces(addon.website)
		end
		if addon.commands == nil then
			addon.commands = GetAddOnMetadata(name, "X-Commands")
			addon.commands = stripSpaces(addon.commands)
		end
	end
	local current = addon.class
	while true do
		if current == AceOO.Class then
			break
		end
		if current.mixins then
			for mixin in pairs(current.mixins) do
				if type(mixin.OnEmbedInitialize) == "function" then
					mixin:OnEmbedInitialize(addon, name)
				end
			end
		end
		current = current.super
	end
	if type(addon.OnInitialize) == "function" then
		safecall(addon.OnInitialize, addon, name)
	end
	if AceEvent then
		AceEvent:TriggerEvent("Ace2_AddonInitialized", addon)
	end
	RegisterOnEnable(addon)
end

function AceAddon.prototype:PrintAddonInfo()
	local x
	if self.title then
		x = "|cffffff7f" .. tostring(self.title) .. "|r"
	elseif self.name then
		x = "|cffffff7f" .. tostring(self.name) .. "|r"
	else
		x = "|cffffff7f<" .. tostring(self.class) .. " instance>|r"
	end
	if type(self.IsActive) == "function" then
		if not self:IsActive() then
			x = x .. " " .. STANDBY
		end
	end
	if self.version then
		x = x .. " - |cffffff7f" .. tostring(self.version) .. "|r"
	end
	if self.notes then
		x = x .. " - " .. tostring(self.notes)
	end
	print(x)
	if self.author then
		print(" - |cffffff7f" .. AUTHOR .. ":|r " .. tostring(self.author))
	end
	if self.credits then
		print(" - |cffffff7f" .. CREDITS .. ":|r " .. tostring(self.credits))
	end
	if self.date then
		print(" - |cffffff7f" .. DATE .. ":|r " .. tostring(self.date))
	end
	if self.category then
		local category = CATEGORIES[self.category]
		if category then
			print(" - |cffffff7f" .. CATEGORY .. ":|r " .. category)
		end
	end
	if self.email then
		print(" - |cffffff7f" .. EMAIL .. ":|r " .. tostring(self.email))
	end
	if self.website then
		print(" - |cffffff7f" .. WEBSITE .. ":|r " .. tostring(self.website))
	end
	if self.commands then
		print(" - |cffffff7f" .. COMMANDS .. ":|r " .. tostring(self.commands))
	end
end

local options
function AceAddon:GetAceOptionsDataTable(target)
	if not options then
		options = {
			about = {
				name = ABOUT,
				desc = PRINT_ADDON_INFO,
				type = "execute",
				func = "PrintAddonInfo",
				order = -1,
			}
		}
	end
	return options
end

function AceAddon:PLAYER_LOGIN()
	self.playerLoginFired = true
	if self.addonsToOnEnable then
		while table.getn(self.addonsToOnEnable) > 0 do
			local addon = table.remove(self.addonsToOnEnable, 1)
			self.addonsStarted[addon] = true
			if (type(addon.IsActive) ~= "function" or addon:IsActive()) and (not AceModuleCore or not AceModuleCore:IsModule(addon) or AceModuleCore:IsModuleActive(addon)) then
				local current = addon.class
				while true do
					if current == AceOO.Class then
						break
					end
					if current.mixins then
						for mixin in pairs(current.mixins) do
							if type(mixin.OnEmbedEnable) == "function" then
								safecall(mixin.OnEmbedEnable,mixin,addon)
							end
						end
					end
					current = current.super
				end
				if type(addon.OnEnable) == "function" then
					safecall(addon.OnEnable,addon)
				end
				if AceEvent then
					AceEvent:TriggerEvent("Ace2_AddonEnabled", addon)
				end
			end
		end
		self.addonsToOnEnable = nil
	end
end

function AceAddon.prototype:Inject(t)
	AceAddon:argCheck(t, 2, "table")
	for k,v in pairs(t) do
		self[k] = v
	end
end

function AceAddon.prototype:init()
	if not AceEvent then
		error(MAJOR_VERSION .. " requires AceEvent-2.0", 4)
	end
	AceAddon.super.prototype.init(self)
	
	self.super = self.class.prototype
	
	AceAddon:RegisterEvent("ADDON_LOADED", "ADDON_LOADED", true)
	table.insert(AceAddon.nextAddon, self)
end

function AceAddon.prototype:ToString()
	local x
	if type(self.title) == "string" then
		x = self.title
	elseif type(self.name) == "string" then
		x = self.name
	else
		x = "<" .. tostring(self.class) .. " instance>"
	end
	if (type(self.IsActive) == "function" and not self:IsActive()) or (AceModuleCore and AceModuleCore:IsModule(addon) and AceModuleCore:IsModuleActive(addon)) then
		x = x .. " " .. STANDBY
	end
	return x
end

AceAddon.new = function(self, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, m16, m17, m18, m19, m20)
	local class = AceAddon:pcall(AceOO.Classpool, self, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, m16, m17, m18, m19, m20)
	return class:new()
end

local function external(self, major, instance)
	if major == "AceEvent-2.0" then
		AceEvent = instance
		
		AceEvent:embed(self)
		
		self:RegisterEvent("PLAYER_LOGIN", "PLAYER_LOGIN", true)
	elseif major == "AceConsole-2.0" then
		AceConsole = instance
		
		local slashCommands = { "/ace2" }
		local _,_,_,enabled,loadable = GetAddOnInfo("Ace")
		if not enabled or not loadable then
			table.insert(slashCommands, "/ace")
		end
		local function listAddon(addon, depth)
			if not depth then
				depth = 0
			end
			
			local s = string.rep("  ", depth) .. " - " .. tostring(addon)
			if rawget(addon, 'version') then
				s = s .. " - |cffffff7f" .. tostring(addon.version) .. "|r"
			end
			if rawget(addon, 'slashCommand') then
				s = s .. " |cffffff7f(" .. tostring(addon.slashCommand) .. ")|r"
			end
			print(s)
			if type(rawget(addon, 'modules')) == "table" then
				local i = 0
				for k,v in pairs(addon.modules) do
					i = i + 1
					if i == 6 then
						print(string.rep("  ", depth + 1) .. " - more...")
						break
					else
						listAddon(v, depth + 1)
					end
				end
			end
		end
		local function listNormalAddon(i)
			local name,_,_,enabled,loadable = GetAddOnInfo(i)
			if not loadable then
				enabled = false
			end
			if self.addons[name] then
				local addon = self.addons[name]
				if not AceCoreAddon or not AceCoreAddon:IsModule(addon) then
					listAddon(addon)
				end
			else
				local s = " - " .. tostring(GetAddOnMetadata(i, "Title") or name)
				local version = GetAddOnMetadata(i, "Version")
				if version then
					if string.find(version, "%$Revision: (%d+) %$") then
						version = string.gsub(version, "%$Revision: (%d+) %$", "%1")
					elseif string.find(version, "%$Rev: (%d+) %$") then
						version = string.gsub(version, "%$Rev: (%d+) %$", "%1")
					elseif string.find(version, "%$LastChangedRevision: (%d+) %$") then
						version = string.gsub(version, "%$LastChangedRevision: (%d+) %$", "%1")
					end
					s = s .. " - |cffffff7f" .. version .. "|r"
				end
				if not enabled then
					s = s .. " |cffff0000(disabled)|r"
				end
				if IsAddOnLoadOnDemand(i) then
					s = s .. " |cff00ff00[LoD]|r"
				end
				print(s)
			end
		end
		local function mySort(alpha, bravo)
			return tostring(alpha) < tostring(bravo)
		end
		AceConsole.RegisterChatCommand(self, slashCommands, {
			desc = "AddOn development framework",
			name = "Ace2",
			type = "group",
			args = {
				about = {
					desc = "Get information about Ace2",
					name = "About",
					type = "execute",
					func = function()
						print("|cffffff7fAce2|r - |cffffff7f2.0." .. string.gsub(MINOR_VERSION, "%$Revision: (%d+) %$", "%1") .. "|r - AddOn development framework")
						print(" - |cffffff7f" .. AUTHOR .. ":|r Ace Development Team")
						print(" - |cffffff7f" .. WEBSITE .. ":|r http://www.wowace.com/")
					end
				},
				list = {
					desc = "List addons",
					name = "List",
					type = "group",
					args = {
						ace2 = {
							desc = "List addons using Ace2",
							name = "Ace2",
							type = "execute",
							func = function()
								print("|cffffff7fAddon list:|r")
								local AceCoreAddon = AceLibrary:HasInstance("AceCoreAddon-2.0") and AceLibrary("AceCoreAddon-2.0")
								table.sort(self.addons, mySort)
								for _,v in ipairs(self.addons) do
									if not AceCoreAddon or not AceCoreAddon:IsModule(v) then
										listAddon(v)
									end
								end
							end
						},
						all = {
							desc = "List all addons",
							name = "All",
							type = "execute",
							func = function()
								print("|cffffff7fAddon list:|r")
								local AceCoreAddon = AceLibrary:HasInstance("AceCoreAddon-2.0") and AceLibrary("AceCoreAddon-2.0")
								local count = GetNumAddOns()
								for i = 1, count do
									listNormalAddon(i)
								end
							end
						},
						enabled = {
							desc = "List all enabled addons",
							name = "Enabled",
							type = "execute",
							func = function()
								print("|cffffff7fAddon list:|r")
								local AceCoreAddon = AceLibrary:HasInstance("AceCoreAddon-2.0") and AceLibrary("AceCoreAddon-2.0")
								local count = GetNumAddOns()
								for i = 1, count do
									local _,_,_,enabled,loadable = GetAddOnInfo(i)
									if enabled and loadable then
										listNormalAddon(i)
									end
								end
							end
						},
						disabled = {
							desc = "List all disabled addons",
							name = "Disabled",
							type = "execute",
							func = function()
								print("|cffffff7fAddon list:|r")
								local AceCoreAddon = AceLibrary:HasInstance("AceCoreAddon-2.0") and AceLibrary("AceCoreAddon-2.0")
								local count = GetNumAddOns()
								for i = 1, count do
									local _,_,_,enabled,loadable = GetAddOnInfo(i)
									if not enabled or not loadable then
										listNormalAddon(i)
									end
								end
							end
						},
						lod = {
							desc = "List all LoadOnDemand addons",
							name = "LoadOnDemand",
							type = "execute",
							func = function()
								print("|cffffff7fAddon list:|r")
								local AceCoreAddon = AceLibrary:HasInstance("AceCoreAddon-2.0") and AceLibrary("AceCoreAddon-2.0")
								local count = GetNumAddOns()
								for i = 1, count do
									if IsAddOnLoadOnDemand(i) then
										listNormalAddon(i)
									end
								end
							end
						},
						ace1 = {
							desc = "List all addons using Ace1",
							name = "Ace 1.x",
							type = "execute",
							func = function()
								print("|cffffff7fAddon list:|r")
								local count = GetNumAddOns()
								for i = 1, count do
									local dep1, dep2, dep3, dep4 = GetAddOnDependencies(i)
									if dep1 == "Ace" or dep2 == "Ace" or dep3 == "Ace" or dep4 == "Ace" then
										listNormalAddon(i)
									end
								end
							end
						},
						libs = {
							desc = "List all libraries using AceLibrary",
							name = "Libraries",
							type = "execute",
							func = function()
								if type(AceLibrary) == "table" and type(AceLibrary.libs) == "table" then
									print("|cffffff7fLibrary list:|r")
									for name, data in pairs(AceLibrary.libs) do
										local s
										if data.minor then
											s = " - " .. tostring(name) .. "." .. tostring(data.minor)
										else
											s = " - " .. tostring(name)
										end
										if AceLibrary(name).slashCommand then
											s = s .. " |cffffff7f(" .. tostring(AceLibrary(name).slashCommand) .. "|cffffff7f)"
										end
										print(s)
									end
								end
							end
						},
						search = {
							desc = "Search by name",
							name = "Search",
							type = "text",
							usage = "<keyword>",
							input = true,
							get = false,
							set = function(...)
								for i,v in ipairs(arg) do
									arg[i] = string.lower(string.gsub(string.gsub(v, '%*', '.*'), '%%', '%%%%'))
								end
								local count = GetNumAddOns()
								for i = 1, count do
									local name = GetAddOnInfo(i)
									local good = true
									for _,v in ipairs(arg) do
										if not string.find(string.lower(name), v) then
											good = false
											break
										end
									end
									if good then
										listNormalAddon(i)
									end
								end
							end
						}
					},
				},
				enable = {
					desc = "Enable addon",
					name = "Enable",
					type = "text",
					usage = "<addon>",
					get = false,
					set = function(text)
						local name,title,_,_,_,reason = GetAddOnInfo(text)
						if reason == "MISSING" then
							print(string.format("|cffffff7fAce2:|r AddOn %q does not exist", text))
						else
							EnableAddOn(text)
							print(string.format("|cffffff7fAce2:|r %s is now enabled", title or name))
						end
					end,
				},
				disable = {
					desc = "Disable addon",
					name = "Disable",
					type = "text",
					usage = "<addon>",
					get = false,
					set = function(text)
						local name,title,_,_,_,reason = GetAddOnInfo(text)
						if reason == "MISSING" then
							print(string.format("|cffffff7fAce2:|r AddOn %q does not exist", text))
						else
							DisableAddOn(text)
							print(string.format("|cffffff7fAce2:|r %s is now disabled", title or name))
						end
					end,
				},
				load = {
					desc = "Load addon",
					name = "Load",
					type = "text",
					usage = "<addon>",
					get = false,
					set = function(text)
						local name,title,_,_,loadable,reason = GetAddOnInfo(text)
						if reason == "MISSING" then
							print(string.format("|cffffff7fAce2:|r AddOn %q does not exist.", text))
						elseif not loadable then
							print(string.format("|cffffff7fAce2:|r AddOn %q is not loadable. Reason: %s", text, reason))
						else
							LoadAddOn(text)
							print(string.format("|cffffff7fAce2:|r %s is now loaded", title or name))
						end
					end
				},
				info = {
					desc = "Display information",
					name = "Information",
					type = "execute",
					func = function()
						local mem, threshold = gcinfo()
						print(string.format(" - |cffffff7fMemory usage [|r%.3f MiB|cffffff7f]|r", mem / 1024))
						print(string.format(" - |cffffff7fThreshold [|r%.3f MiB|cffffff7f]|r", threshold / 1024))
						print(string.format(" - |cffffff7fFramerate [|r%.0f fps|cffffff7f]|r", GetFramerate()))
						local bandwidthIn, bandwidthOut, latency = GetNetStats()
						bandwidthIn, bandwidthOut = floor(bandwidthIn * 1024), floor(bandwidthOut * 1024)
						print(string.format(" - |cffffff7fLatency [|r%.0f ms|cffffff7f]|r", latency))
						print(string.format(" - |cffffff7fBandwidth in [|r%.0f B/s|cffffff7f]|r", bandwidthIn))
						print(string.format(" - |cffffff7fBandwidth out [|r%.0f B/s|cffffff7f]|r", bandwidthOut))
						print(string.format(" - |cffffff7fTotal addons [|r%d|cffffff7f]|r", GetNumAddOns()))
						print(string.format(" - |cffffff7fAce2 addons [|r%d|cffffff7f]|r", table.getn(self.addons)))
						local ace = 0
						local enabled = 0
						local disabled = 0
						local lod = 0
						for i = 1, GetNumAddOns() do
							local dep1, dep2, dep3, dep4 = GetAddOnDependencies(i)
							if dep1 == "Ace" or dep2 == "Ace" or dep3 == "Ace" or dep4 == "Ace" then
								ace = ace + 1
							end
							if IsAddOnLoadOnDemand(i) then
								lod = lod + 1
							end
							local _,_,_,IsActive,loadable = GetAddOnInfo(i)
							if not IsActive or not loadable then
								disabled = disabled + 1
							else
								enabled = enabled + 1
							end
						end
						print(string.format(" - |cffffff7fAce 1.x addons [|r%d|cffffff7f]|r", ace))
						print(string.format(" - |cffffff7fLoadOnDemand addons [|r%d|cffffff7f]|r", lod))
						print(string.format(" - |cffffff7fenabled addons [|r%d|cffffff7f]|r", enabled))
						print(string.format(" - |cffffff7fdisabled addons [|r%d|cffffff7f]|r", disabled))
						local libs = 0
						if type(AceLibrary) == "table" and type(AceLibrary.libs) == "table" then
							for _ in pairs(AceLibrary.libs) do
								libs = libs + 1
							end
						end
						print(string.format(" - |cffffff7fAceLibrary instances [|r%d|cffffff7f]|r", libs))
					end
				}
			}
		})
	elseif major == "AceModuleCore-2.0" then
		AceModuleCore = instance
	end
end

local function activate(self, oldLib, oldDeactivate)
	AceAddon = self
	
	if oldLib then
		self.playerLoginFired = oldLib.playerLoginFired or DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.defaultLanguage
		self.addonsToOnEnable = oldLib.addonsToOnEnable
		self.addons = oldLib.addons
		self.nextAddon = oldLib.nextAddon
		self.addonsStarted = oldLib.addonsStarted
	end
	if not self.addons then
		self.addons = {}
	end
	if not self.nextAddon then
		self.nextAddon = {}
	end
	if not self.addonsStarted then
		self.addonsStarted = {}
	end
	if oldDeactivate then
		oldDeactivate(oldLib)
	end
end

AceLibrary:Register(AceAddon, MAJOR_VERSION, MINOR_VERSION, activate, nil, external)
AceAddon = AceLibrary(MAJOR_VERSION)
