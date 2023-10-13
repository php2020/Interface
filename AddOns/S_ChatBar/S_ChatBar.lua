-- Chatbar主框体 --
local chatFrame = SELECTED_DOCK_FRAME
local buttonWidth = 36
local buttonHeith = 26
local buttonTemplate  = "UIPanelButtonTemplate"
local fontWidthHeight = 25
local fontSize = 14
COLORSCHEME_BORDER   = { 0.3,0.3,0.3,1 }

local STANDARD_TEXT_FONT = "Fonts\\ARIALN.TTF";

local chatbar = CreateFrame("Frame", "chatbar", UIParent)
chatbar:SetWidth(300) -- 主框体宽度
chatbar:SetHeight(25) -- 主框体高度
chatbar:SetPoint("TOPLEFT" ,ChatFrame1, "BOTTOMLEFT", -2, -5)
chatbar:RegisterEvent("PLAYER_LOGIN")
chatbar:SetScript("OnEvent", function()
	--屏蔽频道进出提示
	ChatFrame_RemoveMessageGroup(ChatFrame1, "CHANNEL")
end)

-- "说(/s)" --
local ChannelSay = CreateFrame("Button", "ChannelSay", UIParent, buttonTemplate)
ChannelSay:SetWidth(buttonWidth)  -- 按钮宽度
ChannelSay:SetHeight(buttonHeith)  -- 按钮高度
ChannelSay:SetPoint("LEFT",chatbar,"LEFT",0, 0)   -- 锚点
ChannelSay:RegisterForClicks("LeftButtonUp")
ChannelSay:SetScript("OnClick", function() ChannelSay_OnClick() end)
ChannelSay:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0,6)
	GameTooltip:AddLine("说")
	GameTooltip:Show()
end)
ChannelSay:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelSayText = ChannelSay:CreateFontString("ChannelSayText", "OVERLAY")
ChannelSayText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE") -- 字体设置
ChannelSayText:SetJustifyH("CENTER")
ChannelSayText:SetWidth(fontWidthHeight)
ChannelSayText:SetHeight(fontWidthHeight)
ChannelSayText:SetText("说") -- 显示的文字
ChannelSayText:SetPoint("CENTER", 0, 0)
-- ChannelSayText:SetTextColor(1,1,1) -- 颜色
ChannelSayText:SetTextColor(255/255,209/255,0) -- 颜色

function ChannelSay_OnClick()
    ChatFrame_OpenChat("/s ", chatFrame)
end

-- "喊(/y)" --
local ChannelYell = CreateFrame("Button", "ChannelYell", UIParent, buttonTemplate)
ChannelYell:SetWidth(buttonWidth) 
ChannelYell:SetHeight(buttonHeith) 
ChannelYell:SetPoint("LEFT",ChannelSay,"RIGHT", -1, 0) 
ChannelYell:RegisterForClicks("LeftButtonUp")
ChannelYell:SetScript("OnClick", function() ChannelYell_OnClick() end)
ChannelYell:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("喊话")
	GameTooltip:Show()
end)
ChannelYell:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelYellText = ChannelYell:CreateFontString("ChannelYellText", "OVERLAY")
ChannelYellText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
ChannelYellText:SetJustifyH("CENTER")
ChannelYellText:SetWidth(fontWidthHeight)
ChannelYellText:SetHeight(fontWidthHeight)
ChannelYellText:SetText("喊")
ChannelYellText:SetPoint("CENTER", 0, 0)
-- ChannelYellText:SetTextColor(255/255, 64/255, 64/255)
ChannelYellText:SetTextColor(255/255, 209/255, 0)

function ChannelYell_OnClick()
    ChatFrame_OpenChat("/y ", chatFrame)
end

--"悄悄话(/w)" --
local ChannelWhisper = CreateFrame("Button", "ChannelWhisper", UIParent, buttonTemplate)
ChannelWhisper:SetWidth(buttonWidth) 
ChannelWhisper:SetHeight(buttonHeith) 
ChannelWhisper:SetPoint("LEFT",ChannelYell,"RIGHT", -1, 0) 
ChannelWhisper:RegisterForClicks("LeftButtonUp")
ChannelWhisper:SetScript("OnClick", function() ChannelWhisper_OnClick() end)
ChannelWhisper:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("悄悄话")
	GameTooltip:Show()
end)
ChannelWhisper:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelWhisperText = ChannelWhisper:CreateFontString("ChannelWhisperText", "OVERLAY")
ChannelWhisperText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
ChannelWhisperText:SetJustifyH("CENTER")
ChannelWhisperText:SetWidth(fontWidthHeight)
ChannelWhisperText:SetHeight(fontWidthHeight)
ChannelWhisperText:SetText("密")
ChannelWhisperText:SetPoint("CENTER", 0, 0)
-- ChannelWhisperText:SetTextColor(240/255, 128/255, 128/255)
ChannelWhisperText:SetTextColor(255/255, 209/255, 0)

function ChannelWhisper_OnClick()
    ChatFrame_OpenChat("/w ", chatFrame)
end

-- "队伍(/p)" --
local ChannelParty = CreateFrame("Button", "ChannelParty", UIParent, buttonTemplate)
ChannelParty:SetWidth(buttonWidth) 
ChannelParty:SetHeight(buttonHeith) 
ChannelParty:SetPoint("LEFT",ChannelWhisper,"RIGHT", -1, 0) 
ChannelParty:RegisterForClicks("LeftButtonUp")
ChannelParty:SetScript("OnClick", function() ChannelParty_OnClick() end)
ChannelParty:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("队伍")
	GameTooltip:Show()
end)
ChannelParty:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelPartyText = ChannelParty:CreateFontString("ChannelPartyText", "OVERLAY")
ChannelPartyText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
ChannelPartyText:SetJustifyH("CENTER")
ChannelPartyText:SetWidth(fontWidthHeight)
ChannelPartyText:SetHeight(fontWidthHeight)
ChannelPartyText:SetText("队")
ChannelPartyText:SetPoint("CENTER", 0, 0)
-- ChannelPartyText:SetTextColor(170/255, 170/255, 255/255)
ChannelPartyText:SetTextColor(255/255, 209/255, 0)

function ChannelParty_OnClick()
    ChatFrame_OpenChat("/p ", chatFrame)
end

-- "公会(/g)" --
local ChannelGuild = CreateFrame("Button", "ChannelGuild", UIParent, buttonTemplate)
ChannelGuild:SetWidth(buttonWidth) 
ChannelGuild:SetHeight(buttonHeith) 
ChannelGuild:SetPoint("LEFT",ChannelParty,"RIGHT", -1, 0) 
ChannelGuild:RegisterForClicks("LeftButtonUp")
ChannelGuild:SetScript("OnClick", function() ChannelGuild_OnClick() end)
ChannelGuild:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("公会")
	GameTooltip:Show()
end)
ChannelGuild:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelGuildText = ChannelGuild:CreateFontString("ChannelGuildText", "OVERLAY")
ChannelGuildText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
ChannelGuildText:SetJustifyH("CENTER")
ChannelGuildText:SetWidth(fontWidthHeight)
ChannelGuildText:SetHeight(fontWidthHeight)
ChannelGuildText:SetText("会")
ChannelGuildText:SetPoint("CENTER", 0, 0)
-- ChannelGuildText:SetTextColor(64/255, 255/255, 64/255)
ChannelGuildText:SetTextColor(255/255, 209/255, 0)

function ChannelGuild_OnClick()
    ChatFrame_OpenChat("/g ", chatFrame)
end

-- "团队(/raid)" --
local ChannelRaid = CreateFrame("Button", "ChannelRaid", UIParent, buttonTemplate)
ChannelRaid:SetWidth(buttonWidth) 
ChannelRaid:SetHeight(buttonHeith) 
ChannelRaid:SetPoint("LEFT",ChannelGuild,"RIGHT", -1, 0) 
ChannelRaid:RegisterForClicks("LeftButtonUp")
ChannelRaid:SetScript("OnClick", function() ChannelRaid_OnClick() end)
ChannelRaid:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("团队")
	GameTooltip:Show()
end)
ChannelRaid:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelRaidText = ChannelRaid:CreateFontString("ChannelRaidText", "OVERLAY")
ChannelRaidText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
ChannelRaidText:SetJustifyH("CENTER")
ChannelRaidText:SetWidth(fontWidthHeight)
ChannelRaidText:SetHeight(fontWidthHeight)
ChannelRaidText:SetText("团")
ChannelRaidText:SetPoint("CENTER", 0, 0)
-- ChannelRaidText:SetTextColor(255/255, 127/255, 0)
ChannelRaidText:SetTextColor(255/255, 209/255, 0)

function ChannelRaid_OnClick()
    ChatFrame_OpenChat("/raid ", chatFrame)
end

-- "World频道 世界5" --
local ChannelWorld = CreateFrame("Button", "ChannelWorld", UIParent, buttonTemplate)
ChannelWorld:SetWidth(buttonWidth + 10) 
ChannelWorld:SetHeight(buttonHeith) 
ChannelWorld:SetPoint("LEFT",ChannelRaid,"RIGHT", -1, 0) 
ChannelWorld:RegisterForClicks("LeftButtonUp")
ChannelWorld:SetScript("OnClick", function() ChannelWorld_OnClick() end)
ChannelWorld:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("World")
	GameTooltip:Show()
end)
ChannelWorld:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelWorldText = ChannelWorld:CreateFontString("ChannelWorldText", "OVERLAY")
ChannelWorldText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
ChannelWorldText:SetJustifyH("CENTER")
ChannelWorldText:SetWidth(fontWidthHeight + 15)
ChannelWorldText:SetHeight(fontWidthHeight)
ChannelWorldText:SetText("World")
ChannelWorldText:SetPoint("CENTER", 0, 0)
-- ChannelWorldText:SetTextColor(231/255, 178/255, 179/255) 
ChannelWorldText:SetTextColor(255/255, 209/255, 0)

function ChannelWorld_OnClick()
	for k, v in pairs({GetChannelList()}) do
		if not string.find(v, 'World') then
			JoinChannelByName('World', nil, 1)
		else
			for i=0, 10 do
				local id, name = GetChannelName(i);
				if name == "World" then
					ChatFrame_OpenChat("/"..id.." ", chatFrame)
				end
			end	
		end
	end
end

-- "世界频道" --
local ChannelWorld7 = CreateFrame("Button", "ChannelWorld7", UIParent, buttonTemplate)
ChannelWorld7:SetWidth(buttonWidth + 10) 
ChannelWorld7:SetHeight(buttonHeith) 
ChannelWorld7:SetPoint("LEFT",ChannelWorld,"RIGHT", -1, 0) 
ChannelWorld7:RegisterForClicks("LeftButtonUp")
ChannelWorld7:SetScript("OnClick", function() ChannelWorld_OnClick7() end)
ChannelWorld7:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("世界频道")
	GameTooltip:Show()
end)
ChannelWorld7:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelWorldText7 = ChannelWorld7:CreateFontString("ChannelWorldText7", "OVERLAY")
ChannelWorldText7:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
ChannelWorldText7:SetJustifyH("CENTER")
ChannelWorldText7:SetWidth(fontWidthHeight + 10)
ChannelWorldText7:SetHeight(fontWidthHeight)
ChannelWorldText7:SetText("世")
ChannelWorldText7:SetPoint("CENTER", 0, 0)
-- ChannelWorldText7:SetTextColor(231/255, 178/255, 179/255) 
ChannelWorldText7:SetTextColor(255/255, 209/255, 0)

function ChannelWorld_OnClick7()
	for k, v in pairs({GetChannelList()}) do
		if not string.find(v,"世界频道") then
			JoinChannelByName("世界频道", nil, 1)
		else
			for i=0, 10 do
				local id, name = GetChannelName(i);
				if name == "世界频道" then
					ChatFrame_OpenChat("/"..id.." ", chatFrame)
				end
			end	
		end
	end
end

--"中国" --
local ChannelChina = CreateFrame("Button", "ChannelChina", UIParent, buttonTemplate)
ChannelChina:SetWidth(buttonWidth) 
ChannelChina:SetHeight(buttonHeith) 
ChannelChina:SetPoint("LEFT",ChannelWorld7,"RIGHT", -1, 0) 
ChannelChina:RegisterForClicks("LeftButtonUp")
ChannelChina:SetScript("OnClick", function() ChannelChina_OnClick() end)
ChannelChina:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("中国")
	GameTooltip:Show()
end)
ChannelChina:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelRaidText = ChannelChina:CreateFontString("ChannelRaidText", "OVERLAY")
ChannelRaidText:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
ChannelRaidText:SetJustifyH("CENTER")
ChannelRaidText:SetWidth(fontWidthHeight)
ChannelRaidText:SetHeight(fontWidthHeight)
ChannelRaidText:SetText("中")
ChannelRaidText:SetPoint("CENTER", 0, 0)
-- ChannelRaidText:SetTextColor(0.902, 0, 0)
ChannelRaidText:SetTextColor(255/255, 209/255, 0)

function ChannelChina_OnClick()
	for k, v in pairs({GetChannelList()}) do
		if not string.find(v, "中国") then
			JoinChannelByName("中国", nil, 1)
		else
			for i=0, 10 do
				local id, name = GetChannelName(i);
				if name == "中国" then
					ChatFrame_OpenChat("/"..id.." ", chatFrame)
				end
			end	
		end
	end
end

-- Roll --
local roll = CreateFrame("Button", "rollMacro", UIParent)
roll:SetWidth(35)
roll:SetHeight(35)
roll:SetPoint("LEFT",ChannelChina,"RIGHT",10 , 0)
roll:RegisterForClicks("LeftButtonUp")
roll:SetScript("OnClick", function() ChannelRoll_OnClick() end)
roll:SetScript("OnEnter", function() 
	GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("Roll")
	GameTooltip:Show()
end)
roll:SetScript("OnLeave", function() GameTooltip:Hide() end)
roll.t = roll:CreateTexture()
roll.t:SetAllPoints()
roll.t:SetWidth(35)
roll.t:SetHeight(35)
roll.t:SetTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")

function ChannelRoll_OnClick()
	DEFAULT_CHAT_FRAME.editBox:SetText("/roll")
	ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox,0)	
end