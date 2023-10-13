local gratuity = AceLibrary("Gratuity-2.0")
local _G=getfenv(0)
-- 耐久
local diminfo_Durability = CreateFrame("Button", "diminfo_Durability", UIParent)
local Text = diminfo_Durability:CreateFontString(nil, "OVERLAY")
Text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
Text:SetPoint("CENTER", diminfopanel, "CENTER", 150, 0)
diminfo_Durability:SetAllPoints(Text)

-- 装备槽
local CharSlots = {
	{slot = "Head"},
	{slot = "Shoulder"},
	{slot = "Chest"},
	{slot = "Waist"},
	{slot = "Legs"},
	{slot = "Feet"},
	{slot = "Wrist"},
	{slot = "Hands"},
	{slot = "MainHand"},
	{slot = "SecondaryHand"},
	{slot = "Ranged"},
}

-- 耐久显示
local function OnEvent()
	local repairCost, Dur, ItemCntr, prtext, allprtext = 0, 0, 0, 0
	local font, _, flags = NumberFontNormal:GetFont()
	
	for _, item in pairs(CharSlots) do
		-- 找到各个装备槽的位置
		local gslot = _G["Character"..item.slot.."Slot"]
		if gslot then
			local str = gslot:CreateFontString(item.slot, "OVERLAY")
			str:SetFont(font, 13, flags)
			str:SetPoint("CENTER", gslot, "BOTTOM", 0, 8)
		end
		
		-- 获取各个装备的 当前耐久/最大耐久（如果有装备）
		local id = GetInventorySlotInfo(item.slot .. "Slot")
		local hasItem, _, cost = gratuity:SetInventoryItem("player", id)
		local str = _G[item.slot]
		
		local v1, v2
		if hasItem then v1, v2 = gratuity:FindDeformat(DURABILITY_TEMPLATE) end
		v1, v2, cost = tonumber(v1) or 0, tonumber(v2) or 0, tonumber(cost) or 0
		local percent = v1 / v2
		repairCost = repairCost + cost
		if v2 > 0 then
			str:SetText(zUI.api.HexColors(zUI.api.SetPercentColor(v1, v2))..zUI.api.Round(percent*100).."%")
			-- 信息条平均耐久
			Dur = Dur + percent
			ItemCntr = ItemCntr + 1
		else
			-- 没有装备不显示百分比
			str:SetText("")
		end
		allprtext = zUI.api.Round(Dur/ItemCntr*100)
		if allprtext>0 then
			allprtext = string.format("%d%%", allprtext)
		else
			allprtext = "无"
		end
		Text:SetText("耐久"..zUI.api.HexColors(zUI.api.SetPercentColor(Dur, ItemCntr))..allprtext)
	end

	-- 鼠标提示
	this:SetScript("OnEnter", function()
		local UnitName = UnitName
		GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine("角色")
		GameTooltip:AddLine("左键:角色", .3, 1, .6)
		if IsAddOnLoaded'EN_AutoEquip' then
			GameTooltip:AddLine("右键:换装", .3, 1, .6)
		end
		if repairCost > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine('修理费预估')
			SetTooltipMoney(GameTooltip, repairCost)
		end
		GameTooltip:Show()
	end)
	this:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- 左键：角色，右键：一键换装
local function OnClick()
	if arg1 == "LeftButton" then
		ToggleCharacter("PaperDollFrame")
	else
		if IsAddOnLoaded'EN_AutoEquip' and not EAE_Frame:IsShown() then
			ShowUIPanel(EAE_Frame)
			PlaySound("igCharacterInfoOpen")
		else
			HideUIPanel(EAE_Frame)
			PlaySound("igCharacterInfoClose")
		end
	end
end

diminfo_Durability:RegisterEvent("PLAYER_ENTERING_WORLD")
diminfo_Durability:RegisterEvent("UNIT_INVENTORY_CHANGED")
diminfo_Durability:RegisterEvent("PLAYER_REGEN_ENABLED")
diminfo_Durability:RegisterEvent("MERCHANT_SHOW")
diminfo_Durability:RegisterEvent("MERCHANT_UPDATE")
diminfo_Durability:RegisterEvent("MERCHANT_CLOSED")
diminfo_Durability:RegisterEvent("PLAYER_DEAD")
diminfo_Durability:RegisterEvent("PLAYER_UNGHOST")
diminfo_Durability:SetScript("OnEvent", OnEvent)
diminfo_Durability:SetScript("OnMouseDown", OnClick)