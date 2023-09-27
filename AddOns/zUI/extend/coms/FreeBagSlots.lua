---------------------------
--                       --
--  FreeBagSlots 1.12.1  --
--     by kebabstorm     --
--                       --
---------------------------

zUI:RegisterComponent("FreeBagSlots", function () 
local function isRegularBag(bag)
	if( bag < 0 ) then return false end
	if( bag == 0 ) then return true end -- bag 0 = backpack
	local _, _, id = strfind(GetInventoryItemLink("player", ContainerIDToInventoryID(bag)) or "", "item:(%d+)")
	if id then
		local _, _, _, _, _, subType = GetItemInfo(id)
		-- enUS / deDE / frFR / zhTW / zhCN / koKR / esES / ruRU
		return (subType == "Bag" or subType == "Beh\195\164lter" or subType == "Sac" or subType == "\229\174\185\229\153\168" or subType == "\232\131\140\229\140\133" or subType == "\234\176\128\235\176\169" or subType == "Bolsa" or subType == "\208\161\209\131\208\188\208\186\208\176" or false)
	end
	return false
end

function MainMenuBarBackpackButton_UpdateFreeSlots()
	if not MainMenuBarBackpackButton then return end
	if not MainMenuBarBackpackButton.text then
		MainMenuBarBackpackButton.text = MainMenuBarBackpackButton:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
		MainMenuBarBackpackButton.text:SetTextColor(1, 1, 1)
		MainMenuBarBackpackButton.text:SetFont(STANDARD_TEXT_FONT, 24, 'OUTLINE')
		MainMenuBarBackpackButton.text:SetPoint('CENTER', MainMenuBarBackpackButton, 'CENTER', 0, 0)
		MainMenuBarBackpackButton.text:SetDrawLayer('OVERLAY', 2)
	end

	local totalFree, freeSlots = 0
	for i = 0, NUM_BAG_SLOTS do
		if(isRegularBag(i)) then
			freeSlots = 0
			for slot = 1, GetContainerNumSlots(i) do
				local texture = GetContainerItemInfo(i, slot)
				if not (texture) then 
					freeSlots = freeSlots + 1 
				end
			end
			totalFree = totalFree + freeSlots
		end
	end

	MainMenuBarBackpackButton.freeSlots = totalFree

	MainMenuBarBackpackButton.text:SetText(string.format('%s', totalFree))
end

---------------------------------------------------
do
	local f = CreateFrame('Frame')
	f:RegisterEvent('PLAYER_LOGIN')
	f:RegisterEvent('BAG_UPDATE')
	f:SetScript('OnEvent', function()
		MainMenuBarBackpackButton_UpdateFreeSlots()
	end)
end
---------------------------------------------------
end)