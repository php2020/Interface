-- Globally used
local G = getfenv(0)
local oGlow = oGlow

-- Merchant
local GetMerchantItemLink = GetMerchantItemLink

local numPage = MERCHANT_ITEMS_PER_PAGE

-- Addon
local MerchantFrame = MerchantFrame

local update = function()
	if(MerchantFrame.selectedTab == 1) then
		for i=1, numPage do
			local index = (((MerchantFrame.page - 1) * numPage) + i)
			local link = GetMerchantItemLink(index)
			local button = G["MerchantItem"..i.."ItemButton"]
			local buybackName = GetBuybackItemInfo(GetNumBuybackItems())
			local BuyBackbutton = G["MerchantBuyBackItemItemButton"]
			
			if(link and not oGlow.preventMerchant) then
				local q = select(3, GetItemInfo(string.match(link, "item:(%d+)")))
				oGlow(button, q)
			elseif(button.bc) then
				button.bc:Hide()
			end
			
			if buybackName and not oGlow.preventMerchant then
				local q = select(3, GetItemInfoByName(buybackName))
				oGlow(BuyBackbutton, q)
			elseif(BuyBackbutton.bc) then
				BuyBackbutton.bc:Hide()
			end
		end
	else
		for i=1, 12 do
			local index = (((MerchantFrame.page - 1) * 12) + i)
			local link = GetBuybackItemInfo(index)
			local button = G["MerchantItem"..i.."ItemButton"]

			if(link and not oGlow.preventBuyback) then
				local q = select(3, GetItemInfoByName(link))
				oGlow(button, q)
			elseif(button.bc) then
				button.bc:Hide()
			end
		end
	end
end

hooksecurefunc("MerchantFrame_Update", update)
oGlow.updateMerchant = update
