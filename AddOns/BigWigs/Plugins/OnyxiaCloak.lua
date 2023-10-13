--[[
    by Dorann
    Equips Onyxia Scale Cloak when you enter Nefarians Lair and switches back when you leave the area again
--]]


assert( BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------
local L = AceLibrary("AceLocale-2.2"):new("BigWigsOnyxiaCloak")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
    ["Onyxia Scale Cloak"] = true, -- plugin name
    ["onyxiaCloak"] = true, -- console command
    ["Equips Onyxia Scale Cloak when you enter Nefarians Lair and switches back when you leave the area again."] = true,
    ["Active"] = true, -- option name
    ["Activate the plugin."] = true, -- option description
	["Onyxia Scale Cloak"] = true, -- item name
	["Could not find %s"] = true,
	["Equipping %s"] = true, 
	trigger_engage = "In this world where time is your enemy, it is my greatest ally.", -- nefarian yell before the fight starts
	["Nefarians Lair"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
    ["Onyxia Scale Cloak"] = "奥妮克希亚鳞片披风", -- plugin name
    --["onyxiaCloak"] = true, -- console command
    ["Equips Onyxia Scale Cloak when you enter Nefarians Lair and switches back when you leave the area again."] = "当你进入奈法房间时和离开再返回时,自动装备奥妮克希亚披风.",
    ["Active"] = "激活", -- option name
    ["Activate the plugin."] = "激活插件.", -- option description
	["Onyxia Scale Cloak"] = "奥妮克希亚鳞片披风", -- item name
	["Could not find %s"] = "在你的背包里找不到 %s",
	["Equipping %s"] = "装备 %s", 
	trigger_engage = "In this world where time is your enemy, it is my greatest ally.", -- nefarian yell before the fight starts
	["Nefarians Lair"] = "奈法利安的巢穴",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------
BigWigsOnyxiaCloak = BigWigs:NewModule(L["Onyxia Scale Cloak"])
BigWigsOnyxiaCloak.revision = 20015
BigWigsOnyxiaCloak.external = true

BigWigsOnyxiaCloak.defaultDB = {
    active = true,
	defaultCloak = nil,
}
BigWigsOnyxiaCloak.consoleCmd = L["onyxiaCloak"]

BigWigsOnyxiaCloak.consoleOptions = {
	type = "group",
	name = L["Onyxia Scale Cloak"],
 	desc = L["Equips Onyxia Scale Cloak when you enter Nefarians Lair and switches back when you leave the area again."],
	args   = {
        active = {
			type = "toggle",
			name = L["Active"],
			desc = L["Activate the plugin."],
			order = 1,
			get = function() return BigWigsOnyxiaCloak.db.profile.active end,
			set = function(v) BigWigsOnyxiaCloak.db.profile.active = v end,
			--passValue = "reverse",
		}
	}
}


------------------------------
--      Initialization      --
------------------------------
function BigWigsOnyxiaCloak:OnEnable()
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("ZONE_CHANGED")
    self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

-- https://github.com/Numielle/EasyCloak/blob/master/EasyCloakMain.lua
local function IdFromLink(itemlink)
	if itemlink then
		local _,_,id = string.find(itemlink, "|Hitem:([^:]+)%:")
		return tonumber(id)
	end
	
	return nil	
end

local function GetItemInfo(pItemLink)
	if pItemLink then
		local vStartIndex, vEndIndex, color, itemId, enchantCode, itemSubId, unknownCode, itemName = 
			strfind(pItemLink, "|(%x+)|Hitem:(%d+):(%d+):(%d+):(%d+)|h%[([^%]]+)%]|h|r");
			
		local itemInfo = {
			color = color,
			itemId = itemId,
			enchantCode = enchantCode,
			itemSubId = itemSubId,
			name = itemName,
		}
	
		return itemInfo
	end
	
	return nil
end

local function GetNameOfCurrentCloak()
	local pItemLink = GetInventoryItemLink("player", 15)
	local itemInfo = GetItemInfo(pItemLink)
	
	if itemInfo then
		return itemInfo.name
	end
	
	return nil
end

-- https://github.com/Numielle/EasyCloak/blob/master/EasyCloakMain.lua
local ecTooltip
local function IsSoulbound(bag, slot)
	-- don't initialize twice
	ecTooltip = ecTooltip or CreateFrame( "GameTooltip", "ecTooltip", nil, 
		"GameTooltipTemplate" )
	ecTooltip:AddFontStrings(
		ecTooltip:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
		ecTooltip:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" ), 
		ecTooltip:CreateFontString( "$parentTextLeft2", nil, "GameTooltipText" ),
		ecTooltip:CreateFontString( "$parentTextRight2", nil, "GameTooltipText" ) 
	);	
	-- make tooltip "hidden"
	ecTooltip:SetOwner( WorldFrame, "ANCHOR_NONE" );

	ecTooltip:ClearLines()
	ecTooltip:SetBagItem(bag, slot)		
		
	return (ecTooltipTextLeft2:GetText() == ITEM_SOULBOUND)
end

-- https://github.com/Numielle/EasyCloak/blob/master/EasyCloakMain.lua
local function FindItem(name)
	local bagIdx, slotIdx 
	
	for bag = 0, 4 do		
		for slot = 1,GetContainerNumSlots(bag) do			
			local itemLink = GetContainerItemLink(bag, slot)		
			local itemInfo = GetItemInfo(itemLink)
			
			if itemInfo and itemInfo.name == name then				
				if IsSoulbound(bag, slot) then 
					-- this is definitely the right item
					return bag, slot
				else 
					-- keep looking for soulbound cloak, store values
					bagIdx, slotIdx = bag, slot
				end				
			end				
		end
	end
		
	return bagIdx, slotIdx
end

local function EquipItem(itemName)
	if itemName then
		local bag, slot = FindItem(itemName)
	
		if not (bag and slot) then
			BigWigs:Print(string.format(L["Could not find %s"], itemName))
			return
		end
		
		-- put previously selected item back
		if CursorHasItem() then 
			ClearCursor()
		end 
		
		-- pickup and equip ony scale cloak
		PickupContainerItem(bag, slot)
		AutoEquipCursorItem()
		
		BigWigs:Print(string.format(L["Equipping %s"], itemName))
	end
end
------------------------------
--      Event Handlers      --
------------------------------
function BigWigsOnyxiaCloak:ZONE_CHANGED_NEW_AREA()
	BigWigs:DebugMessage("ZONE_CHANGED_NEW_AREA")
end
function BigWigsOnyxiaCloak:ZONE_CHANGED()
	BigWigs:DebugMessage("ZONE_CHANGED")
end
function BigWigsOnyxiaCloak:ZONE_CHANGED_INDOORS()
	BigWigs:DebugMessage("ZONE_CHANGED_INDOORS [" .. GetSubZoneText() .. "]")
	if self.db.profile.active then
        --if AceLibrary("Babble-Zone-2.2")["Nefarians Lair"] == GetSubZoneText() then -- some wierd bug??
 		if (GetLocale() == "enUS" and string.find(GetSubZoneText(), "Nefarian.*Lair")) 
 			or (L["Nefarians Lair"] == GetSubZoneText())
 		then
             BigWigs:DebugMessage("Nefarians Lair")
			self.db.profile.defaultCloak = GetNameOfCurrentCloak()
			if GetNameOfCurrentCloak() ~= L["Onyxia Scale Cloak"] then
 				EquipItem(L["Onyxia Scale Cloak"])
 			end
        else
			BigWigs:DebugMessage("not Nefarians Lair")
            if GetNameOfCurrentCloak() == L["Onyxia Scale Cloak"] then
                if GetNameOfCurrentCloak() ~= self.db.profile.defaultCloak then
 					EquipItem(self.db.profile.defaultCloak)
 				end
            end
        end
    end
end

function BigWigsOnyxiaCloak:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.active and string.find(msg, L["trigger_engage"]) then
		local currentCloak = GetNameOfCurrentCloak()
		if currentCloak ~= L["Onyxia Scale Cloak"] then
			self.db.profile.defaultCloak = currentCloak
			EquipItem(L["Onyxia Scale Cloak"])
		end
	end
end
