-- 金币
local diminfo_Gold = CreateFrame("Button", "diminfo_Gold", UIParent)
local Text = diminfo_Gold:CreateFontString("Text", "OVERLAY")
Text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
Text:SetPoint("LEFT", diminfo_Bag, "RIGHT", 30, 0)
diminfo_Gold:SetPoint("LEFT", diminfo_Bag, "RIGHT", 30, 0)
local Gold = diminfo_Gold:CreateTexture(nil, "OVERLAY")
Gold:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
zUI.api.SetSize(Gold, 13, 13)
Gold:SetPoint("LEFT", Text, "RIGHT", 0, 0)
Gold:SetTexCoord(0, 0.255, 0, 1)

local function OnEvent()
	-- 记录收入与支出
	if event == "PLAYER_LOGIN" then
		diminfo_lastmoney = GetMoney()
		diminfo_income = 0
	elseif event == "PLAYER_MONEY" then
    	local diminfo_newmoney = GetMoney()
    	if diminfo_newmoney ~= diminfo_lastmoney then
    		local inc_dec = (diminfo_newmoney - diminfo_lastmoney)
    		diminfo_income = diminfo_income + inc_dec
            diminfo_lastmoney = diminfo_newmoney
        end
	end

	local gold = floor(GetMoney() / (COPPER_PER_SILVER * SILVER_PER_GOLD))

	Text:SetText(zUI.api.Over1E3toK(gold))
	zUI.api.SetSize(diminfo_Gold, Text:GetStringWidth() + 12, 12)
end

diminfo_Gold:SetScript("OnEnter", function()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("金币")
	GameTooltip:AddLine("左键:背包", .3, 1, .6)
	if IsAddOnLoaded("Accountant") then
		GameTooltip:AddLine("右键:收支明细", .3, 1, .6)
	end
	if diminfo_income > 0 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("本次登录净利润")
		SetTooltipMoney(GameTooltip, diminfo_income)
	end
	GameTooltip:Show()
end)
diminfo_Gold:SetScript("OnLeave", function() GameTooltip:Hide() end)

diminfo_Gold:RegisterEvent("PLAYER_LOGIN")
diminfo_Gold:RegisterEvent("PLAYER_MONEY")
diminfo_Gold:SetScript("OnEvent", OnEvent)
diminfo_Gold:SetScript("OnMouseDown", function()
	if arg1 == "LeftButton" then
		OpenAllBags()
	else
		if IsAddOnLoaded("Accountant") then
			AccountantButton_OnClick()
		end
	end
end)