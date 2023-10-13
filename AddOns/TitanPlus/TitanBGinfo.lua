--------------------------------------------------------------------------
-- TitanBGinfo.lua 
--------------------------------------------------------------------------
--[[

Titan Panel [BGinfo]
	Plug-in for Titan Panel that displays Battleground info.  When you are
	in a queue to enter a Battleground, the estimated wait time and your 
	current wait time will be displayed when hovering over BGinfo.  When you
	are in a Battleground your BG stats will be displayed.  Can be used to
	replace the Minimap Battleground icon (which can be hidden).   

Author: Corgi - corgiwow@gmail.com

v0.05 (September 15, 2005 11:37 PST)
- updated toc# for 1.70 patch
- added support for Arathi Basin Battleground

v0.04 (June 13, 2005 20:05 PST)
- added BattleField Instance Run Time
- updated toc# for 1.60 patch
- updated for Titan Panel 1.24
- added French localization

v0.03 (June 12, 2005 22:35 PST)
- renamed "Honor Gained" to "Bonus Honor"

v0.02 (June 11, 2005 15:00 PST)
- added estimated wait time and time waited to the BGinfo button when
  in a queue to enter a Battleground
- clicking on the BGinfo icon while in a Battleground will toggle the Stats
  window
- added abbreviated Battleground map name to the BGinfo button when in a
  queue or a Battleground
- added the ability to handle "confirm" state

v0.01 (June 10, 2005 12:40 PST)
- Initial Release

TODO: German, French and Korean translations.
      
NOTE: Requires Titan Panel version 1.22+

]]--

TITAN_BGINFO_ID = "BGinfo";

-- default icon
TITAN_BGINFO_ICON = "Interface\\PvPRankBadges\\PvPRankAlliance";

--
-- OnFuctions
--
function TitanPanelBGinfoButton_OnLoad()	
	this.registry = { 
		id = TITAN_BGINFO_ID,
		menuText = TITAN_BGINFO_MENU_TEXT, 
		buttonTextFunction = "TitanPanelBGinfoButton_GetButtonText", 
		tooltipTitle = TITAN_BGINFO_TOOLTIP,
		tooltipTextFunction = "TitanPanelBGinfoButton_GetTooltipText",
		icon = TITAN_BGINFO_ICON,
		iconWidth = 16,
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			HideMinimap = TITAN_NIL,
		}
	};
	this:RegisterEvent("UPDATE_WORLD_STATES");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    
    this:RegisterEvent("BATTLEFIELDS_SHOW");
    this:RegisterEvent("BATTLEFIELDS_CLOSED");
    
    this:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
    this:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
    
    this:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
	--this:RegisterEvent("PLAYER_PVP_RANK_CHANGED");
end

function TitanPanelBGinfoButton_OnEvent()
	
	--TitanPanelBGinfo_ChatPrint("BGinfo: OnEvent MAIN : "..event);
	
	if ( event == "UPDATE_WORLD_STATES" ) then
		--TitanPanelBGinfo_ChatPrint("In OnEvent => Update_World_State\n");
		RequestBattlefieldScoreData();
	end
	
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		--TitanPanelBGinfo_ChatPrint("In OnEvent => Player_Entering_World");
		if ( UnitFactionGroup("player") == FACTION_ALLIANCE ) then
			TITAN_BGINFO_ICON = "Interface\\PvPRankBadges\\PvPRankAlliance";
		else
			TITAN_BGINFO_ICON = "Interface\\PvPRankBadges\\PvPRankHorde";
		end
		TitanPlugins[TITAN_BGINFO_ID].icon = TITAN_BGINFO_ICON;
		RequestBattlefieldScoreData();
	end
	
	if ( event == "BATTLEFIELDS_SHOW" ) then
		--TitanPanelBGinfo_ChatPrint("In OnEvent => Battlefields_Show\n");
	end
	
	if ( event == "BATTLEFIELDS_CLOSED" ) then
		--TitanPanelBGinfo_ChatPrint("In OnEvent => Battlefields_Closed\n");
	end
	
	if ( event == "UPDATE_BATTLEFIELD_SCORE" ) then
		--TitanPanelBGinfo_ChatPrint("In OnEvent => Update_Battlefield_Score\n");
		RequestBattlefieldScoreData();
	end
	
	if ( event == "UPDATE_BATTLEFIELD_STATUS" ) then
		--TitanPanelBGinfo_ChatPrint("In OnEvent => Update_Battlefield_Status\n");
		RequestBattlefieldScoreData();
	end
	
	if ( event == "PLAYER_PVP_KILLS_CHANGED" ) then
		--TitanPanelBG_ChatPrint("In OnEvent => Player_PVP_Kills_Changed\n");
		RequestBattlefieldScoreData();
	end
	
	if ( TitanGetVar(TITAN_BGINFO_ID, "HideMinimap") ) then
			MiniMapBattlefieldFrame:Hide();
	end
	
	TitanPanelButton_UpdateButton(TITAN_BGINFO_ID);	
	TitanPanelButton_UpdateTooltip();
end

function TitanPanelBGinfoButton_OnClick(button)
	if ( button == "LeftButton" ) then
		local status, mapName, instanceID = GetBattlefieldStatus(1);
		if ( status == "active" ) then
			ToggleWorldStateScoreFrame();
		end
	end
end

--
-- Titan functions
--
function TitanPanelBGinfoButton_GetButtonText(id)	
	local buttonRichText = "";
	
	local status, mapName, instanceID = GetBattlefieldStatus(1);
	
	local abbrmapName = TitanPanelBGinfo_MapNameAbbr(mapName);
	
	if ( abbrmapName == nil ) then
		abbrmapName = "";
	end
	
	if ( instanceID ~= 0 ) then
		abbrmapName = abbrmapName..instanceID;
	end
	
	if ( status == "queued" ) then
		
		local waitTime = GetBattlefieldEstimatedWaitTime();
		local timeInQueue = GetBattlefieldTimeWaited();
		
		if ( waitTime == 0 ) then
			waitTime = UNAVAILABLE;
		elseif ( waitTime < 60000 ) then 
			waitTime = LESS_THAN_ONE_MINUTE;
		else
			waitTime = TitanPanelBGinfo_SecondsToTimeAbbrev(waitTime/1000);
		end

		if ( timeInQueue == 0 ) then
			timeInQueue = UNAVAILABLE;
		elseif ( timeInQueue < 60000 ) then 
			timeInQueue = LESS_THAN_ONE_MINUTE;
		else
			timeInQueue = TitanPanelBGinfo_SecondsToTimeAbbrev(timeInQueue/1000);
		end
	    
		buttonRichText = " "..TitanUtils_GetGreenText(abbrmapName)..":"..TitanUtils_GetHighlightText(waitTime)..TitanUtils_GetNormalText(" / ")..TitanUtils_GetHighlightText(timeInQueue);
	
	elseif ( status == "confirm" ) then
		
		buttonRichText = " "..TitanUtils_GetGreenText(abbrmapName)..":"..TitanUtils_GetHighlightText(TITAN_BGINFO_CONFIRM_TEXT);
		
	elseif ( status == "active" ) then
		
		--local numStatColumns = GetNumBattlefieldStats();
		
		--if ( numStatColumns == 2 ) then
		--	buttonRichText = TitanUtils_GetHighlightText(" CTF: "..abbrmapName);
		--elseif ( numStatColumns == 7 ) then
			buttonRichText = TitanUtils_GetHighlightText(" "..abbrmapName);
		--end
			
	else
		buttonRichText = TitanUtils_GetHighlightText(" N/A");
	end
	
	return TITAN_BGINFO_BUTTON_LABEL, buttonRichText;
end

function TitanPanelBGinfoButton_GetTooltipText()
	local tooltipRichText = "";
	local bgName = nil;
	
	RequestBattlefieldScoreData();

	local playerName = UnitName("player");
	
	local status, mapName, instanceID = GetBattlefieldStatus(1);
	
	local abbrmapName = TitanPanelBGinfo_MapNameAbbr(mapName);
	
	if ( abbrmapName == nil ) then
		abbrmapName = "";
	end
			
    if ( instanceID ~= 0 ) then
        mapName = mapName.." "..instanceID;
    end
        
    if ( status == "none" ) then
    
		tooltipRichText = TITAN_BGINFO_NOTIN_TEXT;
		
	elseif ( status == "queued" ) then
	
		local waitTime = GetBattlefieldEstimatedWaitTime();
        local timeInQueue = GetBattlefieldTimeWaited()/1000;
		if ( waitTime == 0 ) then
			waitTime = UNAVAILABLE;
        elseif ( waitTime < 60000 ) then
            waitTime = LESS_THAN_ONE_MINUTE;
        else
            waitTime = SecondsToTime(waitTime/1000, 1);
        end
        tooltipRichText = format(BATTLEFIELD_IN_QUEUE, mapName, TitanUtils_GetHighlightText(waitTime), TitanUtils_GetHighlightText(SecondsToTime(timeInQueue)));
	
	elseif ( status == "confirm" ) then
	
		tooltipRichText = format(BATTLEFIELD_QUEUE_CONFIRM, mapName, TitanUtils_GetHighlightText(SecondsToTime(GetBattlefieldPortExpiration()/1000)));
		
	elseif ( status == "active" ) then
	
		local numScores = GetNumBattlefieldScores();
		local name, kills, killingBlows, deaths, honorGained, faction, rank, race, class;
        
		--TitanPanelBGinfo_ChatPrint("numScores: "..numScores.."\n");
		
		tooltipRichText = mapName.."\n";
		
		for i=1, 80 do
			name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class = GetBattlefieldScore(i);
			
			if ( name == playerName ) then
				--TitanPanelBGinfo_ChatPrint(i..":"..name..":"..killingBlows..":"..honorableKills..":"..deaths.."\n");
				tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(KILLING_BLOWS..":").."\t"..TitanUtils_GetHighlightText(killingBlows).."\n";
				tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(HONORABLE_KILLS..":").."\t"..TitanUtils_GetHighlightText(honorableKills).."\n";
				tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(DEATHS..":").."\t"..TitanUtils_GetHighlightText(deaths).."\n";
				tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_BONUS_HONOR_TEXT..":").."\t"..TitanUtils_GetHighlightText(honorGained).."\n";
				
				local numStatColumns = GetNumBattlefieldStats();
				--TitanPanelBGinfo_ChatPrint(numStatColumns);
				
				for j=1, MAX_NUM_STAT_COLUMNS do
					if ( j <= numStatColumns ) then
                        columnData = GetBattlefieldStatData(i, j);
              
                        if ( abbrmapName == TITAN_BGINFO_WG_TEXT) then
							if ( j == 1 ) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_FLAGS_CAPTURED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							elseif ( j == 2) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_FLAGS_RETURNED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							end
						elseif ( abbrmapName == TITAN_BGINFO_AV_TEXT ) then					
							if ( j == 1 ) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_GRAVEYARDS_ASSAULTED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							elseif ( j == 2 ) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_GRAVEYARDS_DEFENDED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							elseif ( j == 3 ) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_TOWERS_ASSAULTED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							elseif ( j == 4 ) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_TOWERS_DEFENDED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							elseif ( j == 5 ) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_MINES_CAPTURED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							elseif ( j == 6 ) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_LEADERS_KILLED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							elseif ( j == 7 ) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_SECONDARY_OBJECTIVES_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							end
						elseif ( abbrmapName == TITAN_BGINFO_AB_TEXT ) then
							if ( j == 1 ) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_BASES_ASSAULTED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							elseif ( j == 2) then
								tooltipRichText = tooltipRichText..TitanUtils_GetGreenText(TITAN_BGINFO_BASES_DEFENDED_TEXT..": ").."\t"..TitanUtils_GetHighlightText(columnData).."\n";
							end
						end
					end
				end
				break;
			end
		end	
	end
	
	local bgtime = GetBattlefieldInstanceRunTime();
	
	tooltipRichText = tooltipRichText.."\n"..TitanUtils_GetGreenText(TITAN_BGINFO_HINT_TEXT);

	return tooltipRichText;
end

--
-- create menus
--
function TitanPanelRightClickMenu_PrepareBGinfoMenu()
	local info = {};
	
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then		
		if ( UIDROPDOWNMENU_MENU_VALUE == "DisplayAbout" ) then
			info = {};
			info.text = TITAN_BGINFO_ABOUT_POPUP_TEXT;
			info.value = "AboutTextPopUP";
			info.notClickable = 1;
			info.isTitle = 0;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
		end
		return;
	end
	
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_BGINFO_ID].menuText);
	
	local status, mapName, instanceID = GetBattlefieldStatus(1);
	
	if ( status == "queued" ) then
		info = {};
        info.text = CHANGE_INSTANCE;
        info.func = ShowBattlefieldList;
        UIDropDownMenu_AddButton(info);
                
        info = {};
        info.text = LEAVE_QUEUE;
        info.func = AcceptBattlefieldPort;
        UIDropDownMenu_AddButton(info);
        TitanPanelRightClickMenu_AddSpacer();
	elseif ( status == "confirm") then
		info = {};
	    info.text = ENTER_BATTLE;
        info.func = BattlefieldFrame_EnterBattlefield;
        UIDropDownMenu_AddButton(info);
         
        info = {};
        info.text = LEAVE_QUEUE;
        info.func = AcceptBattlefieldPort;
		UIDropDownMenu_AddButton(info);
		TitanPanelRightClickMenu_AddSpacer();
	elseif ( status == "active" ) then
		info = {};
        info.text = TITAN_BGINFO_TOGGLE_SCORES_TEXT;
        info.func = ToggleWorldStateScoreFrame;
        UIDropDownMenu_AddButton(info);         
	end
	
	if ( status == "queued" or status == "active" or status == "confirm" ) then
		info = {};
		info.text = TITAN_BGINFO_TOGGLE_MINIMAP_TEXT;
		info.value = "ToggleMiniIcon";
		info.func = function ()
			if ( MiniMapBattlefieldFrame ~= nil) then
				if ( MiniMapBattlefieldFrame:IsVisible() ) then
					TitanSetVar(TITAN_BGINFO_ID,"HideMinimap",1);
					MiniMapBattlefieldFrame:Hide();
				else
					TitanSetVar(TITAN_BGINFO_ID,"HideMinimap",nil);
					MiniMapBattlefieldFrame:Show();
				end
			end
		end
		UIDropDownMenu_AddButton(info);
		TitanPanelRightClickMenu_AddSpacer();
	end
	
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_BGINFO_ID);
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_BGINFO_ID, TITAN_PANEL_MENU_FUNC_HIDE);

	-- info about plugin
	local info = {};
	info.text = TITAN_BGINFO_ABOUT_TEXT;
	info.value = "DisplayAbout";
	info.hasArrow = 1;
	UIDropDownMenu_AddButton(info);
end

--
-- BGinfo functions
--
function TitanPanelBGinfo_MapNameAbbr(mapName)

	if ( mapName == TITAN_BGINFO_AV_FULL_TEXT ) then
		mapName = TITAN_BGINFO_AV_TEXT;
	elseif ( mapName == TITAN_BGINFO_WG_FULL_TEXT ) then
		mapName = TITAN_BGINFO_WG_TEXT;
	elseif ( mapName == TITAN_BGINFO_AB_FULL_TEXT ) then
		mapName = TITAN_BGINFO_AB_TEXT;
	end
	
	return mapName;
end

function TitanPanelBGinfo_SecondsToTimeAbbrev(seconds)
        local time = "";
        local tempTime;
        if ( seconds > 86400  ) then
                tempTime = floor(seconds / 86400);
                time = tempTime.." "..DAY_ONELETTER_ABBR;
                return time;
        end
        if ( seconds > 3600  ) then
                tempTime = floor(seconds / 3600);
                time = tempTime.." "..HOUR_ONELETTER_ABBR;
                return time;
        end
        if ( seconds > 60  ) then
                tempTime = floor(seconds / 60);
                time = tempTime.." "..MINUTE_ONELETTER_ABBR;
                return time;
        end
        tempTime = format("%d", seconds);
        time = tempTime.." "..SECOND_ONELETTER_ABBR;
        return time;
end

function TitanPanelBGinfo_ChatPrint(msg)
        DEFAULT_CHAT_FRAME:AddMessage(msg);
end