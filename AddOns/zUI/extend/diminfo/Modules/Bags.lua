local onestorage = AceLibrary("OneStorage-2.0")
local lastmoney, income = 0, 0

-- 背包
local diminfo_Bag = CreateFrame("Button", "diminfo_Bag", UIParent)
local Text = diminfo_Bag:CreateFontString(nil, "OVERLAY")
Text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
Text:SetPoint("LEFT", diminfo_Durability, "RIGHT", 30, 0)
diminfo_Bag:SetAllPoints(Text)

local usedSlots, usedAmmoSlots, usedSoulSlots, usedProfSlots, ammoQuantity, totalSlots
local function OnEvent()
	-- 是否有箭袋、灵魂袋、专业袋的情况
	usedSlots, usedAmmoSlots, usedSoulSlots, usedProfSlots, ammoQuantity, totalSlots = 0, 0, 0, 0, 0, 0
	local d_Bags = {0, 1, 2, 3, 4}
	
	for _, bag in d_Bags do
	local tmp, qty = 0, 0
		for slot = 1, GetContainerNumSlots(bag) do
			local texture, itemCount = GetContainerItemInfo(bag, slot)
			if( texture) then
				tmp = tmp + 1
				qty = qty + itemCount
			end
		end
			
		local isAmmo, isSoul, isProf = onestorage:GetBagTypes(bag)
			
		if isAmmo then
			usedAmmoSlots = usedAmmoSlots + tmp
			ammoQuantity = ammoQuantity + qty
		elseif isSoul then
			usedSoulSlots = usedSoulSlots + tmp
		elseif isProf then
			usedProfSlots = usedProfSlots + tmp
		else
			usedSlots = usedSlots + tmp
			totalSlots = totalSlots + GetContainerNumSlots(bag)
		end
	end
	
	freeSlots = totalSlots - usedSlots

	Text:SetText("背包"..zUI.api.HexColors(zUI.api.SetPercentColor(freeSlots, totalSlots))..freeSlots.."|r")
end

--鼠标提示
diminfo_Bag:SetScript("OnEnter", function()
	local gold = floor(GetMoney())
	
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("背包")
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("容量 "..usedSlots.."/"..totalSlots)
	if usedAmmoSlots and usedAmmoSlots > 0 then
		GameTooltip:AddLine("箭矢|弹药 "..usedAmmoSlots)
	elseif usedSoulSlots and usedSoulSlots > 0 then
		GameTooltip:AddLine("灵魂碎片 "..usedSoulSlots)
	end
	GameTooltip:Show()
end)

diminfo_Bag:SetScript("OnLeave", function() GameTooltip:Hide() end)
diminfo_Bag:RegisterEvent("PLAYER_LOGIN")
diminfo_Bag:RegisterEvent("BAG_UPDATE")
diminfo_Bag:RegisterEvent("PLAYER_MONEY")
diminfo_Bag:SetScript("OnEvent", OnEvent)
diminfo_Bag:SetScript("OnMouseDown", function() OpenAllBags() end)