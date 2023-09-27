--[[
Name: Babble-Class-2.2
Revision: $Rev: 14410 $
Author(s): ckknight (ckknight@gmail.com)
Website: http://ckknight.wowinterface.com/
Documentation: http://wiki.wowace.com/index.php/Babble-Class-2.2
SVN: http://svn.wowace.com/root/trunk/Babble-2.2/Babble-Class-2.2
Description: 职业本地化库
Dependencies: AceLibrary, AceLocale-2.2
]]

local MAJOR_VERSION = "Babble-Class-2.2"
local MINOR_VERSION = tonumber(string.sub("$Revision: 14410 $", 12, -3))

if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary") end

if not AceLibrary:HasInstance("AceLocale-2.2") then error(MAJOR_VERSION .. " requires AceLocale-2.2") end

local _, x = AceLibrary("AceLocale-2.2"):GetLibraryVersion()
MINOR_VERSION = MINOR_VERSION * 100000 + x

if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end

local BabbleClass = AceLibrary("AceLocale-2.2"):new(MAJOR_VERSION)

-- uncomment below for debug information
-- BabbleClass:EnableDebugging()

BabbleClass:RegisterTranslations("enUS", function()
	return {
		["Warlock"] = true,
		["Warrior"] = true,
		["Hunter"] = true,
		["Mage"] = true,
		["Priest"] = true,
		["Druid"] = true,
		["Paladin"] = true,
		["Shaman"] = true,
		["Rogue"] = true,
	}
end)

BabbleClass:RegisterTranslations("zhCN", function()
	return {
		["Warlock"] = "术士",
		["Warrior"] = "战士",
		["Hunter"] = "猎人",
		["Mage"] = "法师",
		["Priest"] = "牧师",
		["Druid"] = "德鲁伊",
		["Paladin"] = "圣骑士",
		["Shaman"] = "萨满祭司",
		["Rogue"] = "盗贼",
	}
end)

BabbleClass:Debug()
BabbleClass:SetStrictness(true)

function BabbleClass:GetColor(class)
	self:argCheck(class, 2, "string")
	if self:HasReverseTranslation(class) then
		class = string.upper(self:GetReverseTranslation(class))
	else
		class = string.upper(class)
	end
	if RAID_CLASS_COLORS and RAID_CLASS_COLORS[class] then
		return RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	end
	return 0.63, 0.63, 0.63
end

function BabbleClass:GetHexColor(class)
	self:argCheck(class, 2, "string")
	local r, g, b = self:GetColor(class)
	return string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

AceLibrary:Register(BabbleClass, MAJOR_VERSION, MINOR_VERSION)
BabbleClass = nil
