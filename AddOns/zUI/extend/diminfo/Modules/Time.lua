-- 时间
local diminfo_Time = CreateFrame("Button", "diminfo_Time", UIParent)
local Text  = diminfo_Time:CreateFontString(nil, "OVERLAY")
Text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
Text:SetPoint("LEFT", diminfo_Performance, "RIGHT", 25, 0)
diminfo_Time:SetAllPoints(Text)

--时间转换
local OnlineTime = function()
	local sessiontime = GetTime() - starttime
	if sessiontime < 60 then
		return format("%.0f", sessiontime).."s"
	elseif (sessiontime >= 60 and sessiontime < 3600) then
		return format("%.0f", sessiontime/60).."m"
	elseif (sessiontime >= 3600) then
		return math.floor(format("%.1f", sessiontime/3600)).."h"..format("%.0f", (sessiontime - math.floor(sessiontime/3600)*3600)/60).."m"
	end
end

-- 鼠标提示：显示具体时间信息
diminfo_Time:SetScript("OnEnter", function()
	local Weekday = {[0] = "日","一","二","三","四","五","六"}
	local h, m = GetGameTime()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("时间")
	GameTooltip:AddLine("左键:计时器", .3, 1, .6)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine((date("%Y年%m月%d日".." 星期"..Weekday[tonumber(date("%w"))])))
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine('|cffffffff在线时长|r', OnlineTime())
	GameTooltip:AddDoubleLine('|cffffffff本地时间|r', date("%H:%M"))
	GameTooltip:AddDoubleLine('|cffffffff服务器时间|r', format("%02d:%s", h, m < 10 and ("0"..m) or m))
	GameTooltip:Show()
end)

diminfo_Time:SetScript("OnLeave", function() GameTooltip:Hide() end)	

--来自于Modui的秒表计时器
local x, y = 0, 0
local visible = false
local t0
local saved_time = 0
local MAX_TIMER_SEC = 99*3600 + 59*60 + 59
local orig = {}
local pad  = function(n) return strlen(n) == 2 and n or '0'..n end

local d_stopwatch = CreateFrame('Frame', 'd_stopwatch', UIParent)
d_stopwatch:EnableMouse(true) d_stopwatch:SetMovable(true)
d_stopwatch:SetWidth(140) d_stopwatch:SetHeight(28)
d_stopwatch:RegisterForDrag'LeftButton'
d_stopwatch:SetPoint('TOP', Text, x, y - 20)
d_stopwatch:SetBackdrop({
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 14, edgeSize = 14,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
})
d_stopwatch:SetBackdropColor(0, 0, 0, .8)
d_stopwatch:Hide()

local t = d_stopwatch:CreateFontString(nil, 'OVERLAY')
t:SetFontObject'GameFontNormalLarge'
t:SetPoint('LEFT', 6, 0)

local reset = CreateFrame('Button', 'd_stopwatch_reset', d_stopwatch, 'UIPanelButtonTemplate')
reset:SetWidth(35) reset:SetHeight(20)
reset:SetPoint('RIGHT', -6, 0)
reset:SetText'重置'

local play = CreateFrame('Button', 'd_stopwatch_playpause', d_stopwatch, 'UIPanelButtonTemplate')
play:SetWidth(35) play:SetHeight(20)
play:SetPoint('RIGHT', reset, 'LEFT', -2, 0)
play:SetText'开始'

local sw_stop = function()
	if not play.playing then return end
	play.playing = false
	play:SetText'开始'
	if t0 then saved_time = floor(saved_time + GetTime() - t0) end
	t0 = nil
	d_stopwatch:SetScript('OnUpdate', nil)
end

local sw_reset = function()
	d_stopwatch:SetScript('OnUpdate', nil)
	play.reverse, t0 = nil
	sw_stop()
	d_stopwatch:SetWidth(140)
	t:SetText'0:0:0'
	saved_time = 0
end

local sw_OnUpdate = function()
	local time = GetTime()
	local h, m, s
	if time - 0 > 1 then
		if play.reverse then
			s = (play.timer + t0) - time
			if  s <= 0 then s = 0 sw_reset() end
		else s = (t0 and floor(time - t0) or 0) + saved_time end
		h = floor(s/3600)
		s = s - h*3600
		m = floor(s/60)
		s = s - m*60
		t:SetText(string.format('%d:%d:%d', pad(h), pad(m), pad(s)))
	end
end

local sw_start = function()
	if play.playing then return end
	play.playing = true
	play:SetText'暂停'
	t0 = GetTime()
	d_stopwatch:SetScript('OnUpdate', sw_OnUpdate)
end

local sw_show = function(bu)
	if visible then
		d_stopwatch:Hide()
		visible = false
	else
		d_stopwatch:Show()
		t:SetText'0:0:0'
		visible = true
	end
end

local sw_countdown = function(h, m, s)
	local text
	local sec = 0
	if h then sec = h*3600 end
	if m then sec = sec + m*60 end
	if s then sec = sec + s end

	if sec > MAX_TIMER_SEC then
		play.timer = MAX_TIMER_SEC
		t0 = GetTime()
	elseif sec < 0 then
		play.timer = 0
		t0 = nil
	else
		play.timer = sec
		t0 = GetTime()
	end
	play.reverse = sec > 0
	play.playing = true
	play:SetText'暂停'
	d_stopwatch:SetScript('OnUpdate', sw_OnUpdate)
	d_stopwatch:Show()
	visible = true
end

local sw_toggle = function()
	if this.playing then
		sw_stop()
		PlaySound'igMainMenuOptionCheckBoxOff'
	else
		sw_start()
		PlaySound'igMainMenuOptionCheckBoxOn'
	end
end

d_stopwatch:SetScript('OnDragStart', function() d_stopwatch:StartMoving() end)
d_stopwatch:SetScript('OnDragStop',  function() d_stopwatch:StopMovingOrSizing() end)

play:SetScript('OnClick', sw_toggle)
reset:SetScript('OnClick', sw_reset)

diminfo_Time:RegisterEvent("PLAYER_ENTERING_WORLD")
diminfo_Time:SetScript("OnEvent", function() if event == "PLAYER_ENTERING_WORLD" then starttime = GetTime() end end)

local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function() Text:SetText(date("%H:%M")) end)

diminfo_Time:SetScript("OnMouseDown", function()
	if arg1 == "LeftButton"  then
		sw_show()
	end
end)