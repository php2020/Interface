--独立的"整理"和"拾取过滤"按钮，修改by狗血编剧男2020.3.2
OneBagButton = OneCore:NewModule("OneBagButton")

function OneBagButton:OnInitialize()
	local OneBagClean_Up = CreateFrame("Button", "OneBagClean_Up", OneBagFrame)
	SetSize(OneBagClean_Up, 25, 25)
	OneBagClean_Up:SetPoint("RIGHT", OneBagFrameConfigButton, "LEFT", -3, 0)
	OneBagClean_Up:SetNormalTexture("Interface\\AddOns\\OneBag\\media\\INV_Pet_Broom")
	OneBagClean_Up:SetPushedTexture("Interface\\AddOns\\OneBag\\media\\INV_Pet_Broom")
	OneBagClean_Up:GetPushedTexture():SetTexCoord(.09,.91,.09,.91)
	OneBagClean_Up:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	OneBagClean_Up:GetHighlightTexture():SetTexCoord(.09,.91,.09,.91)
	
	OneBagClean_Up:SetScript("OnMouseDown", function()
		if arg1 == "LeftButton" then
			if IsAltKeyDown() then
				if IsAddOnLoaded("OneView") then
					if OneViewFrame:IsVisible() then
						OneViewFrame:Hide()
					else
						OneViewFrame:Show()
					end	
				end
			else
				Clean_Up("bags", 1)
			end
		else
			Clean_Up("bags")
		end	
	end)
	OneBagClean_Up:SetScript("OnEnter", function()
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
		GameTooltip:AddLine("[左键]:正序整理|N[右键]:倒序整理|N[Alt+左键]:离线银行")
		GameTooltip:Show()	
	end)
	OneBagClean_Up:SetScript("OnLeave", function() GameTooltip:Hide() end)

	if IsAddOnLoaded("LootFilter") then
		local OneBagLootFilter = CreateFrame("Button", "OneBagLootFilter", OneBagFrame)
		SetSize(OneBagLootFilter, 25, 25)
		OneBagLootFilter:SetPoint("RIGHT", OneBagClean_Up, "LEFT", -3, 0)
		OneBagLootFilter:SetNormalTexture("Interface\\Icons\\INV_Misc_Spyglass_03")
		OneBagLootFilter:SetPushedTexture("Interface\\Icons\\INV_Misc_Spyglass_03")
		OneBagLootFilter:GetPushedTexture():SetTexCoord(.09,.91,.09,.91)
		OneBagLootFilter:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		OneBagLootFilter:GetHighlightTexture():SetTexCoord(.09,.91,.09,.91)

		OneBagLootFilter:SetScript('OnClick', function()
			if (not LootFilterOptions:IsShown()) then
				LootFilterOptions:Show()
			else
				LootFilterOptions:Hide()
			end	
		end)
		
		OneBagLootFilter:SetScript("OnEnter", function()
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
			GameTooltip:AddLine("拾取过滤")
			GameTooltip:Show()	
		end)
		
		OneBagLootFilter:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
end