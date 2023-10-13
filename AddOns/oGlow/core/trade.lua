-- Globally used
local _G = getfenv(0)
local oGlow = oGlow

hooksecurefunc("TradeFrame_UpdatePlayerItem", function(id)
	local tradeItemButton = _G["TradePlayerItem"..id.."ItemButton"]
	local tradeItemName = _G["TradePlayerItem"..id.."Name"]

	local name, _, _, quality = GetTradePlayerItemInfo(id)

	if name and not oGlow.preventTrade then
		tradeItemName:SetTextColor(GetItemQualityColor(quality))
		
		local q = select(3, GetItemInfoByName(name))
		oGlow(tradeItemButton, q or quality)
	elseif(tradeItemButton.bc) then
		tradeItemButton.bc:Hide()
	end
end)

hooksecurefunc("TradeFrame_UpdateTargetItem", function(id)
	local tradeItemButton = _G["TradeRecipientItem"..id.."ItemButton"]
	local tradeItemName = _G["TradeRecipientItem"..id.."Name"]

	local name, _, _, quality = GetTradeTargetItemInfo(id)

	if name and not oGlow.preventTrade then
		tradeItemName:SetTextColor(GetItemQualityColor(quality))

		local q = select(3, GetItemInfoByName(name))
		oGlow(tradeItemButton, q or quality)
	elseif(tradeItemButton.bc) then
		tradeItemButton.bc:Hide()
	end
end)

oGlow.updateTrade = update
