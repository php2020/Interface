-- 好友
local diminfo_Friend = CreateFrame("Button", "diminfo_Friend", UIParent)
local Text = diminfo_Friend:CreateFontString(nil, "OVERLAY")
Text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
Text:SetPoint("LEFT", diminfo_Time, "RIGHT", 25, 0)
diminfo_Friend:SetAllPoints(Text)

local function GetNumberFriends()
	local onlineF, numF = 0, GetNumFriends()

	for i = 1, numF do if zUI.api.select(5, GetFriendInfo(i)) then onlineF = onlineF + 1 end end

	return onlineF, numF
end

-- 在线人数	
local function OnEvent()
	local onlineF = GetNumberFriends()
	Text:SetText(FRIENDS..onlineF)
end

-- 鼠标提示
diminfo_Friend:SetScript("OnEnter", function()
	local onlineF, numF = GetNumberFriends()
	local guildName, guildRank = GetGuildInfo("player")
	local guildonline, guildtotal = 0, GetNumGuildMembers(true)
	local guildMotD = GetGuildRosterMOTD()
	local guildinfotext = GetGuildInfoText()
	
	for i = 0, guildtotal do 
		local guildconnected = zUI.api.select(9, GetGuildRosterInfo(i)) 
		if guildconnected then 
			guildonline = guildonline + 1 
		end 
	end
	
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 0, -10)	
	GameTooltip:ClearLines()
	GameTooltip:AddLine("好友")
	GameTooltip:AddLine("|CFF4CFF99左键:好友|R".." [在线"..onlineF.."  总数"..numF.."]")
	
	if guildName then
		GameTooltip:AddLine("|CFF4CFF99右键:公会|R".." [在线"..guildonline.."  总数"..guildtotal.."]")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("公会："..guildName,nil, nil, nil, 5)		--避免长公会名，最长显示5行
		GameTooltip:AddLine(RANK..": ".."|cffffffff"..guildRank)
		-- 公会今日信息
		if guildMotD ~= "" then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(GUILD_MOTD)
			GameTooltip:AddLine(guildMotD, 0, .8 , 1, 20)			--最长显示20行
		end
		--公会信息
		if guildinfotext ~= "" then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("公会信息")
			GameTooltip:AddLine(guildinfotext, 0, .8, 1, 30)				--最长显示30行
		end
	else
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("您还没有公会")
	end
	GameTooltip:Show()
end)
	
diminfo_Friend:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

-- 每10秒更新公会在线人数
diminfo_Friend:SetScript("OnUpdate", function()
    if ( this.tick or 10) > GetTime() then
		return
	else
		this.tick = GetTime() + 10
	end
	
	GuildRoster()
end)

-- 左键点击打开好友列表
diminfo_Friend:SetScript("OnMouseUp", function()
	if arg1 == "LeftButton" then 
		ToggleFriendsFrame(1)
	else
		if IsInGuild() then
			if not GuildFrame then
				LoadAddOn("Blizzard_GuildUI")
			end
			ToggleFriendsFrame(3)
		end
	end
end)

diminfo_Friend:RegisterEvent("PLAYER_ENTERING_WORLD")
diminfo_Friend:RegisterEvent("FRIENDLIST_UPDATE")
diminfo_Friend:SetScript("OnEvent", OnEvent)