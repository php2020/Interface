-- 系统信息
local diminfo_Performance = CreateFrame("Button", "diminfo_Performance", UIParent)
local Text = diminfo_Performance:CreateFontString("Text", "OVERLAY")
Text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
Text:SetPoint("RIGHT", diminfopanel, "LEFT", 10, 0)
diminfo_Performance:SetAllPoints(Text)

-- FPS染色
local function colorFPS(v)
	if v < 15 then
		return "|cffD80909"..v
	elseif v < 30 then
		return "|cffE8DA0F"..v
	else
		return "|cff0CD809"..v
	end
end

-- 延迟染色、换算
local function color_ms_Latency(v)
	if v < 300 then
		return "|cff0CD809"..format("%.0f", v).."|rms"
	elseif (v >= 300 and v < 500) then
		return "|cffE8DA0F"..format("%.0f", v).."|rms"
	elseif (v >= 500 and v < 1000) then
		return "|cffD80909"..format("%.0f", v).."|rms"
	else
		return "|cffD80909"..format("%.1f", v / 1000).."|rs"
	end
end

-- 更新帧数、延迟
local function OnUpdate()
	if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + 1 end
	local fps = tonumber(math.ceil(GetFramerate()))
	local lag = zUI.api.select(3, GetNetStats())
	Text:SetText(colorFPS(fps).."|rfps".." "..color_ms_Latency(lag))
end

-- 网速换算
local function KbToString(v)
	if v > 1024 then
		return format("%.2f MB", v / 1024);
	else
		return format("%.0f KB", v)
	end
end

-- 鼠标提示
local function OnEnter()
	local memkb, gckb = gcinfo()
	local memmb = memkb and memkb > 0 and KbToString(memkb) or UNAVAILABLE
	local gcmb = gckb and gckb > 0 and KbToString(gckb) or UNAVAILABLE
	local nin, nout = GetNetStats()
	nin, nout = floor(nin * 1024), floor(nout * 1024)

	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("系统")
	if IsAddOnLoaded("Warmup") then
		GameTooltip:AddLine("左键:内存明细", .3, 1, .6)
	end
	GameTooltip:AddLine("右键:清理内存", .3, 1, .6)	
	GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("内存占用", memmb)
	GameTooltip:AddDoubleLine("下次清理", gcmb)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("下行速率", KbToString(nin))
	GameTooltip:AddDoubleLine("上行速率", KbToString(nout))

	GameTooltip:Show()
end

diminfo_Performance:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- 鼠标点击
diminfo_Performance:SetScript("OnMouseDown", function()
	if arg1 == "LeftButton" then
		if IsAddOnLoaded("Warmup") then
			Warmup:Slash(wu)
		end
	else
		collectgarbage()
		OnEnter()
	end
end)

local f = CreateFrame("Frame")
f:SetScript("OnUpdate", OnUpdate)
diminfo_Performance:SetScript("OnEnter", OnEnter)