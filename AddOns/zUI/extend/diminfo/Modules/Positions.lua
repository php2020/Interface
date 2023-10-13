-- 地图信息
local diminfo_pos = CreateFrame("Button", "diminfo_pos", UIParent)
local Text = diminfo_pos:CreateFontString(nil, "OVERLAY")
Text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
Text:SetPoint("CENTER", diminfopanel, "CENTER", 0, 0)
diminfo_pos:SetAllPoints(Text)

-- 区域文字染色
local colorT = {
	sanctuary = {SANCTUARY_TERRITORY, {.41, .8, .94}},
	arena = {FREE_FOR_ALL_TERRITORY, {1, .1, .1}},
	friendly = {FACTION_CONTROLLED_TERRITORY, {.1, 1, .1}},
	hostile = {FACTION_CONTROLLED_TERRITORY, {1, .1, .1}},
	contested = {CONTESTED_TERRITORY, {1, .7, 0}},
	combat = {COMBAT_ZONE, {1, .1, .1}},
	neutral = {format(FACTION_CONTROLLED_TERRITORY,FACTION_STANDING_LABEL4), {1, 1, 1}}
}

-- 显示区域名称及坐标
local subzone, zone, pvp, posXY
local function OnEvent()
	subzone, zone, pvp = GetSubZoneText(), GetRealZoneText(), {GetZonePVPInfo()}
	if not pvp[1] then pvp[1] = "neutral" end
	local r,g,b = unpack(colorT[pvp[1]][2])

	this:SetScript("OnUpdate", function()
		local x, y = GetPlayerMapPosition("player")
	
		if x == 0 and y == 0 then 
			posXY = ""
		else
			posXY = zUI.api.Round(x * 100)..","..zUI.api.Round(y *100)
		end

		Text:SetText((subzone ~= "") and subzone..posXY or zone..posXY)
		Text:SetTextColor(r,g,b)
	end)
end
	
-- 鼠标提示
diminfo_pos:SetScript("OnEnter",function()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:ClearAllPoints()
	GameTooltip:ClearLines()
	GameTooltip:AddLine("地图")
	GameTooltip:AddLine("左键:世界地图", .3, 1, .6)
	if IsAddOnLoaded'Atlas' then
		GameTooltip:AddLine("右键:副本地图", .3, 1, .6)
	end
	GameTooltip:AddLine("Shift左键:网格线", .3, 1, .6)

	if pvp[1] and not IsInInstance() then
		local r,g,b = unpack(colorT[pvp[1]][2])
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(zone, r, g, b)
		GameTooltip:AddLine(format(colorT[pvp[1]][1],pvp[2] or pvp[3] or ""), r, g, b)
	end
	
	GameTooltip:Show()
end)
	
diminfo_pos:SetScript("OnLeave",function()
	this:SetScript("OnUpdate", nil)
	GameTooltip:Hide()
end)

--网格界面
local function ToggleAlignFrame()
	if AlignFrame then
		AlignFrame:Hide()
		AlignFrame = nil		
	else
		AlignFrame = CreateFrame('Frame', nil, UIParent) 
		AlignFrame:SetAllPoints(UIParent)
		local w = GetScreenWidth() / 64
		local h = GetScreenHeight() / 36
		for i = 0, 64 do
			local AlignTexture = AlignFrame:CreateTexture(nil, 'BACKGROUND')
			if i == 32 then
				AlignTexture:SetTexture(1, 0, 0, 0.5)
			else
				AlignTexture:SetTexture(0, 0, 0, 0.5)
			end
			AlignTexture:SetPoint('TOPLEFT', AlignFrame, 'TOPLEFT', i * w - 1, 0)
			AlignTexture:SetPoint('BOTTOMRIGHT', AlignFrame, 'BOTTOMLEFT', i * w + 1, 0)
		end
		for i = 0, 36 do
			local AlignTexture = AlignFrame:CreateTexture(nil, 'BACKGROUND')
			if i == 18 then
				AlignTexture:SetTexture(1, 0, 0, 0.5)
			else
				AlignTexture:SetTexture(0, 0, 0, 0.5)
			end
			AlignTexture:SetPoint('TOPLEFT', AlignFrame, 'TOPLEFT', 0, -i * h + 1)
			AlignTexture:SetPoint('BOTTOMRIGHT', AlignFrame, 'TOPRIGHT', 0, -i * h - 1)
		end	
	end
end

-- 左键点击打开世界地图，右键打开副本地图
diminfo_pos:SetScript("OnMouseUp", function()
	if IsShiftKeyDown() and arg1 == "LeftButton" then
		ToggleAlignFrame()
	else
		if arg1 == "LeftButton" then
			ToggleWorldMap()
		else
			if IsAddOnLoaded'Atlas' then
				Atlas_Toggle()
			end
		end	
	end
end)

diminfo_pos:RegisterEvent("ZONE_CHANGED")
diminfo_pos:RegisterEvent("ZONE_CHANGED_INDOORS")
diminfo_pos:RegisterEvent("ZONE_CHANGED_NEW_AREA")
diminfo_pos:RegisterEvent("PLAYER_ENTERING_WORLD")
diminfo_pos:RegisterEvent("PLAYER_LOGIN")
diminfo_pos:SetScript("OnEvent", OnEvent)