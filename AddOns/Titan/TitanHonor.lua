TITAN_HONOR_ID = "Honor";
TITAN_HONOR_ICON_PATH = "Interface\\PvPRankBadges\\PvPRank";

function TitanPanelHonorButton_OnLoad()
	this.registry = {
		id = TITAN_HONOR_ID,
		builtIn = 1,
		version = TITAN_VERSION,
		menuText = TITAN_HONOR_MENU_TEXT,
		buttonTextFunction = "TitanPanelHonorButton_GetButtonText", 
		tooltipTitle = TITAN_HONOR_TOOLTIP, 
		tooltipTextFunction = "TitanPanelHonorButton_GetTooltipText",
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = TITAN_NIL,
		}
	};	

	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
	this:RegisterEvent("PLAYER_PVP_RANK_CHANGED");
end

function TitanPanelHonorButton_OnEvent()
	TitanPanelButton_UpdateButton(TITAN_HONOR_ID);	
	TitanPanelButton_UpdateTooltip();
end

function TitanPanelHonorButton_OnShow()
	TitanPanelHonorButton_SetPVPHonorIcon();
end

function TitanPanelHonorButton_GetButtonText(id)
	local lifetimeRank, sessionHK, sessionDK, yesterdayHK, yesterdayDK, lastweekHK, lastweekDK, lifetimeHK, lifetimeDK, yesterdayContribution, lastweekContribution, lastweekRank = GetInspectHonorData();
	
	-- Current rank
	local rankName, rankNumber = GetPVPRankInfo(UnitPVPRank("player"));	
	if (not rankName) then
		rankName = NONE;
	end

	-- This session's values
	local sessionHK, sessionDK = GetPVPSessionStats();
	
	return ""..
		TITAN_HONOR_BUTTON_LABEL_RANK, TitanUtils_GetHighlightText(rankNumber),
		TITAN_HONOR_BUTTON_LABEL_HK, TitanUtils_GetGreenText(sessionHK),
		TITAN_HONOR_BUTTON_LABEL_DK, TitanUtils_GetRedText(sessionDK);
end

function TitanPanelHonorButton_GetTooltipText()
	-- Current rank
	local rankName, rankNumber = GetPVPRankInfo(UnitPVPRank("player"));	
	if (not rankName) then
		rankName = NONE;
	end

	-- This session's values
	local sessionHK, sessionDK = GetPVPSessionStats();
	
	-- Yesterday's values	
	local yesterdayHK, yesterdayDK, yesterdayContribution = GetPVPYesterdayStats();

	-- Last Week's values	
	local lastweekHK, lastweekDK, lastweekContribution, lastweekRank = GetPVPLastWeekStats();
	
	-- Lifetime stats
	local lifetimeHK, lifetimeDK, highestRank = GetPVPLifetimeStats();	
	local highestRankName, highestRankNumber = GetPVPRankInfo(highestRank);
	if ( not highestRankName ) then
		highestRankName = NONE;
	end

	return ""..
		RANK..": "..TitanUtils_GetHighlightText(rankName.." ("..RANK.." "..rankNumber..")").."\n"..
		"\n"..
		TitanUtils_GetHighlightText(HONOR_THIS_SESSION).."\n"..
		HONORABLE_KILLS..": \t"..TitanUtils_GetGreenText(sessionHK).."\n"..
		DISHONORABLE_KILLS..": \t"..TitanUtils_GetRedText(sessionDK).."\n"..
		"\n"..
		TitanUtils_GetHighlightText(HONOR_YESTERDAY).."\n"..
		HONORABLE_KILLS..": \t"..TitanUtils_GetGreenText(yesterdayHK).."\n"..
		DISHONORABLE_KILLS..": \t"..TitanUtils_GetRedText(yesterdayDK).."\n"..
		HONOR_CONTRIBUTION_POINTS..": \t"..TitanUtils_GetHighlightText(yesterdayContribution).."\n"..
		"\n"..
		TitanUtils_GetHighlightText(HONOR_LASTWEEK).."\n"..
		HONORABLE_KILLS..": \t"..TitanUtils_GetGreenText(lastweekHK).."\n"..
		DISHONORABLE_KILLS..": \t"..TitanUtils_GetRedText(lastweekDK).."\n"..
		HONOR_CONTRIBUTION_POINTS..": \t"..TitanUtils_GetHighlightText(lastweekContribution).."\n"..
		HONOR_STANDING..": \t"..TitanUtils_GetHighlightText(lastweekRank).."\n"..
		"\n"..
		TitanUtils_GetHighlightText(HONOR_LIFETIME).."\n"..
		HONORABLE_KILLS..": \t"..TitanUtils_GetGreenText(lifetimeHK).."\n"..
		DISHONORABLE_KILLS..": \t"..TitanUtils_GetRedText(lifetimeDK).."\n"..
		HONOR_HIGHEST_RANK..": \t"..TitanUtils_GetHighlightText(highestRankName);
end

function TitanPanelHonorButton_SetPVPHonorIcon()
	local rankName, rankNumber = GetPVPRankInfo(UnitPVPRank("player"));	
	if (rankNumber > 0) then
		TitanPanelHonorButtonIcon:SetTexture(format("%s%02d", TITAN_HONOR_ICON_PATH, rankNumber));
	else
		TitanPanelHonorButtonIcon:SetTexture(TITAN_HONOR_ICON_PATH..UnitFactionGroup("player"));
	end
	TitanPanelHonorButtonIcon:SetWidth(16);
end

function TitanPanelRightClickMenu_PrepareHonorMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_HONOR_ID].menuText);
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_HONOR_ID);
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_HONOR_ID);
	
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_HONOR_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

