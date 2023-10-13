-- ======================双倍经验监控========================
-- 作者: 熊怪
-- 日期: 2023-07-20
-- 版本: 1.0
-- 描述: 显示当前双倍经验的文本和进度条
-- ========================================================

local DoubleExperience = {
	DoubleXpWindowFrame = nil,
	DoubleXpText = nil,
	DoubleXpProgressBar = nil,
}
function DoubleExperience:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

-- 初始化
function DoubleExperience:Init()
	self.CreateFrame(self)
	self.UpdateDoubleXpTextAndProgressBar(self)
end

-- 创建一个Frame框架作为显示窗口
function DoubleExperience:CreateFrame()
	self.CreateDoubleXpWindowFrame(self)
	self.CreateDoubleXpText(self)
	self.CreateDoubleXpProgressBar(self)
end

-- 创建一个Frame框架作为显示窗口
function DoubleExperience:CreateDoubleXpWindowFrame()
	self.DoubleXpWindowFrame = CreateFrame("Frame", "DoubleXpWindow", UIParent)
	self.DoubleXpWindowFrame:SetWidth(200)
	self.DoubleXpWindowFrame:SetHeight(80)
	self.DoubleXpWindowFrame:SetPoint("TOP", 0, -100)
	self.DoubleXpWindowFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	self.DoubleXpWindowFrame:SetBackdropColor(0, 0, 0, 0)
	self.DoubleXpWindowFrame:SetMovable(true)
	self.DoubleXpWindowFrame:EnableMouse(true)
	self.DoubleXpWindowFrame:RegisterForDrag("LeftButton")
	self.DoubleXpWindowFrame:SetScript("OnDragStart", function() this:StartMoving() end)
	self.DoubleXpWindowFrame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
end

-- 创建显示文本的字体对象
function DoubleExperience:CreateDoubleXpText()
	self.DoubleXpText = self.DoubleXpWindowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.DoubleXpText:SetPoint("CENTER", 0, 0)
end

-- 创建进度条框架
function DoubleExperience:CreateDoubleXpProgressBar()
	self.DoubleXpProgressBar = CreateFrame("StatusBar", nil, self.DoubleXpWindowFrame)
	self.DoubleXpProgressBar:SetPoint("BOTTOM", 0, 10)
	self.DoubleXpProgressBar:SetWidth(180)
	self.DoubleXpProgressBar:SetHeight(10)
	self.DoubleXpProgressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	self.DoubleXpProgressBar:SetStatusBarColor(0, 0, 1)
	-- 创建进度条背景
	local background = self.DoubleXpProgressBar:CreateTexture(nil, "BACKGROUND")
	background:SetAllPoints(true)
	background:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	background:SetVertexColor(0.5, 0.5, 0.5, 0.8)
	-- 设置进度条的最小值和最大值
	self.DoubleXpProgressBar:SetMinMaxValues(0, 100)
end

-- 更新显示窗口中的文本
function DoubleExperience:UpdateDoubleXpTextAndProgressBar()
	-- showText("..双倍..", { r = 0, g = 1, b = 0 })
	local exhaustionXP = GetXPExhaustion() or 0
	local level = UnitLevel("player")
	local currentXP = UnitXP("player")
	local maxXP = UnitXPMax("player")
	local maxExhaustion = maxXP * 1.5

	-- 文本
	self.DoubleXpText:SetText("当前累计双倍经验\n" .. exhaustionXP .. " / " .. maxExhaustion)

	-- 进度条
	local percent = (exhaustionXP / maxExhaustion) * 100
	-- showText(".." .. percent .. "..", { r = 0, g = 1, b = 0 })
	self.DoubleXpProgressBar:SetValue(percent)
end

-- 创建对象
DBE = DoubleExperience:new(nil)

DBE:Init()

-- DBE.DoubleXpWindowFrame:SetScript("OnEvent", function() 
-- 	DBE:UpdateDoubleXpTextAndProgressBar()
-- end)
-- DBE.DoubleXpWindowFrame:RegisterEvent("PLAYER_XP_UPDATE")
-- DBE.DoubleXpWindowFrame:RegisterEvent("PLAYER_LEVEL_UP")

DBE.DoubleXpWindowFrame:SetScript("OnUpdate", function() 
	DBE:UpdateDoubleXpTextAndProgressBar()
end)

-- 进入游戏时
function DBE.DoubleXpWindowFrame:PLAYER_ENTERING_WORLD()
	DBE:UpdateDoubleXpTextAndProgressBar()
end

-- 输入/DBEHIDE / DBESHOW 控制显示与隐藏
-- 处理输入命令
SLASH_DBESHOW1 = "/DBESHOW"
SLASH_DBEHIDE1 = "/DBEHIDE"

SlashCmdList["DBESHOW"] = function()
    DBE.DoubleXpWindowFrame:Show()
	DBE:UpdateDoubleXpTextAndProgressBar()
end

SlashCmdList["DBEHIDE"] = function()
    DBE.DoubleXpWindowFrame:Hide()
end

-- 重置位置命令
SLASH_DBEREST1 = "/DBEREST"
SlashCmdList["DBEREST"] = function()
	DBE.DoubleXpWindowFrame:ClearAllPoints()
    DBE.DoubleXpWindowFrame:SetPoint("TOP", 0, -100)
end