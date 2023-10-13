-- version
TITAN_GUILD_VERSION = "2.5";
--[[

	Titan Panel [Guild]: A simple guild list for the Titan Panel AddOn.
		copyright 2005 by chicogrande (jluzier@gmail.com)
		tooltip coloration enhancements and frame detection by Dsanai
		
	- Lists online guild members in a tooltip, green rank text indicating an officer
	- Menu shows names of online members, with click to /whisper functionality. Green text = officer
	- Menu has options to /guild chat and /officer chat
	- Menu has option to toggle Show offline members, which changes this setting in your Social frame, Guild tab
	- Advanced menus to /w, /invite, /friend or /who guild members
	- Shows default messages if the player is not a member of a guild
	- Updates the guild listing every 5 minutes to accomodate the GuildRoster() delay. The update only takes place if
	  the player is 'idle' and not accessing conflicting UI frames or Titan elements
	- Tooltip and right-click menu content is sortable using the Sort menu option, works like the guild frame
	- Colors rank names (Advanced) or player names (Simple) based on rank index
	- To save space, player can turn off menu options
	- Filtering on a level range and zone, as it relates to the player
	- Filtering on a single class in the player's faction
	- Paging of simple and advanced right-click menu contents to deal with large-guild issues
]]

----------------------------------------------------------------------
--  Local variables
----------------------------------------------------------------------
TITAN_GUILD_ID = "Guild";
-- attempting to update every 300 seconds
TITAN_GUILD_FREQUENCY = 300;
-- the guild tab #
TITAN_GUILD_TAB_NUMBER = 3;
-- function used to hide options
TITAN_GUILD_BUTTON_SHOWOPTIONS = "TitanPanelGuildButton_ToggleShowMenuOptions";
TITAN_GUILD_BUTTON_CLOSEMENU = "TitanPanelGuildButton_CloseMenu";
TITAN_GUILD_BUTTON_COMPUTEPAGES = "TitanPanelGuildButton_ComputePages";
TITAN_GUILD_BUTTON_FORWARDPAGE = "TitanPanelGuildButton_PageForward";
TITAN_GUILD_BUTTON_BACKWARDPAGE = "TitanPanelGuildButton_PageBackward";

-- threshold for leaf level items in right-click menu
TITAN_GUILD_LIST_THRESHOLD = 15;
TITAN_GUILD_TOOLTIP_THRESHOLD = 26;

-- used to help hide the FriendsFame on GuildRoster() calls
hide_TitanPanelGuildButton_FriendsFrame = 0;
-- my internal timer used to keep track of when to run GuildRoster()
guild_TimeCounter = 0;
-- tables used to build the rank based right-click messaging menu
masterTable = {};
masterTableSimple = {};
-- level range for filtering on level +/- TITAN_GUILD_LEVEL_RANGE
TITAN_GUILD_LEVEL_RANGE = 5;

-- paging vars
currIndex = 1;
maxIndex = TITAN_GUILD_LIST_THRESHOLD;
numGuildOnline = 0;
numGuildOnlineFiltered = 0;
numPages = 0;
currPage = 1;
pagingRemainder = 0;
priorAdvMenuValue = TITAN_NIL;
TitanGuildFirstCycle = true;

-- hooking
local pre_TitanPanelGuildButton_FriendsFrame_OnShow;
local pre_TitanPanelGuildButton_FriendsFrame_OnHide;

----------------------------------------------------------------------
--  TitanPanelGuildButton_OnLoad()
----------------------------------------------------------------------
function TitanPanelGuildButton_OnLoad()
	if( DEFAULT_CHAT_FRAME ) then
		--DEFAULT_CHAT_FRAME:AddMessage("Titan Panel [Guild] v"..TITAN_GUILD_VERSION.." loaded");
	end
	-- init hide_TitanPanelGuildButton_FriendsFrame
	hide_TitanPanelGuildButton_FriendsFrame = 0;	
	-- init guild_TimeCounter
	guild_TimeCounter = 0;
	masterTable = {};
	masterTableSimple = {};
	--TitanPanelGuildButton_ListInitMaster();
	this.registry = { 
		id = TITAN_GUILD_ID,
		menuText = TITAN_GUILD_MENU_TEXT, 
		buttonTextFunction = "TitanPanelGuildButton_GetButtonText",
		tooltipTitle = TITAN_GUILD_TOOLTIP,
		tooltipTextFunction = "TitanPanelGuildButton_GetTooltipText",
		icon = "Interface\\PetitionFrame\\GuildCharter-Icon.blp",	
		iconWidth = 16,
		savedVariables = {
			ShowLabelText = 1,
			ShowIcon = 1,
			ShowAdvancedMenus = 0,
			ShowMenuOptions = 1,
			ShowTooltipName = 1,
			ShowTooltipZone = 1,
			ShowTooltipRank = 1,
			ShowTooltipNote = TITAN_NIL,
			ShowTooltipLevel = 1,
			ShowTooltipClass = 1,
			FilterMyLevel = TITAN_NIL,
			FilterMyZone = TITAN_NIL,
			FilterClasses = TITAN_NIL,
			SortByValue = TITAN_NIL,
			DisableRosterUpdates = TITAN_NIL,
		}
	};
	this:RegisterEvent("GUILD_ROSTER_SHOW");
	this:RegisterEvent("GUILD_ROSTER_UPDATE");
	this:RegisterEvent("GUILD_REGISTRAR_SHOW");
	this:RegisterEvent("GUILD_REGISTRAR_CLOSED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("SYSMSG");
	
	-- hooking FriendsFrame_OnShow()
	pre_TitanPanelGuildButton_FriendsFrame_OnShow = FriendsFrame_OnShow;
	FriendsFrame_OnShow = TitanPanelGuildButton_FriendsFrame_OnShow;
	-- hooking FriendsFrame_OnHide()
	pre_TitanPanelGuildButton_FriendsFrame_OnHide = FriendsFrame_OnHide;
	FriendsFrame_OnHide = TitanPanelGuildButton_FriendsFrame_OnHide;		
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_FriendsFrame_OnShow()
--  used to hook the FriendsFrame_OnShow() call
--  and not play a sound when the Titan Guild is updating
----------------------------------------------------------------------
function TitanPanelGuildButton_FriendsFrame_OnShow()
	-- if the variable exists, TitanGuild is being used
	if (hide_TitanPanelGuildButton_FriendsFrame) then
		if (hide_TitanPanelGuildButton_FriendsFrame == 0) then
			pre_TitanPanelGuildButton_FriendsFrame_OnShow();
		elseif (hide_TitanPanelGuildButton_FriendsFrame == 1) then
			-- From Interface\FrameXML\FriendsFrame.lua
			FriendsFrame_Update();
			UpdateMicroButtons();
			--PlaySound("igMainMenuOpen");
			GuildFrame.selectedGuildMember = 0;
			SetGuildRosterSelection(0);
		end
	else
		-- it's a reglar old FriendsFrame_OnShow() call
		pre_TitanPanelGuildButton_FriendsFrame_OnShow();
	end
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_FriendsFrame_OnHide()
--  used to hook the FriendsFrame_OnHide() call
--  and not play a sound when the Titan Guild is updating
----------------------------------------------------------------------
function TitanPanelGuildButton_FriendsFrame_OnHide()
	-- if the variable exists, TitanGuild is being used
	if (hide_TitanPanelGuildButton_FriendsFrame) then
		if (hide_TitanPanelGuildButton_FriendsFrame == 0) then
			pre_TitanPanelGuildButton_FriendsFrame_OnHide();
		elseif (hide_TitanPanelGuildButton_FriendsFrame == 1) then
			-- From Interface\FrameXML\FriendsFrame.lua
			UpdateMicroButtons();
			--PlaySound("igMainMenuClose");
			SetGuildRosterSelection(0);
			GuildFrame.selectedGuildMember = 0;
			GuildControlPopupFrame:Hide();
			hide_TitanPanelGuildButton_FriendsFrame = 0;
		end
	else
		-- it's a reglar old FriendsFrame_OnHide() call
		pre_TitanPanelGuildButton_FriendsFrame_OnHide();
		return;
	end
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_OnEvent()
--  traps and deals with GUILD_ROSTER_SHOW and GUILD_ROSTER_UPDATE
----------------------------------------------------------------------
function TitanPanelGuildButton_OnEvent()
	-- hide the FriendsFrame by capturing the GUILD_ROSTER_SHOW event	
	if (event == "PLAYER_ENTERING_WORLD") then
		--guildPrintDebugMessage(event);
		-- having issues on initial load
		GuildRoster();
		TitanPanelGuildButton_SortGuildRoster();	
		TitanPanelGuildButton_ListInitMaster();
		TitanPanelGuildButton_GetGuildRoster(0); -- EMERALD
	elseif (event == "GUILD_ROSTER_SHOW") then
		--guildPrintDebugMessage(event);
		-- build the table used to generate the right-click menus
		TitanPanelGuildButton_ListInitMaster();
		if(hide_TitanPanelGuildButton_FriendsFrame == 1) then
			HideUIPanel(FriendsFrame);
		end
	elseif (event == "GUILD_ROSTER_UPDATE") then
		--guildPrintDebugMessage(event);
		-- having issues on initial load
		TitanPanelGuildButton_ListInitMaster();
	--elseif (event == "SYSMSG") then
		--DEFAULT_CHAT_FRAME:AddMessage("DEBUG(SYSMSG): arg1="..arg1);
	end
	TitanPanelButton_UpdateButton(TITAN_GUILD_ID);	
	TitanPanelButton_UpdateTooltip();
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_OnEnter()
----------------------------------------------------------------------
function TitanPanelGuildButton_OnEnter()
	--TitanPanelButton_UpdateButton(TITAN_GUILD_ID);	
	--TitanPanelButton_UpdateTooltip();	
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_OnClick(arg1)
----------------------------------------------------------------------
function TitanPanelGuildButton_OnClick(button)
	-- open the guild pane on a left click
	if ( button == "LeftButton" and not IsControlKeyDown()) then
		if (GuildOrg) then -- EMERALD: If GuildOrg is installed, open its window instead of the Blizzard default one
			if (not GuildOrg:IsVisible()) then
				ShowUIPanel(GuildOrg);
			elseif (GuildOrg:IsVisible()) then
				HideUIPanel(GuildOrg);
			end
		else
			if (not FriendsFrame:IsVisible()) then
				PanelTemplates_SetTab(FriendsFrame, TITAN_GUILD_TAB_NUMBER);
				ShowUIPanel(FriendsFrame);
			elseif (FriendsFrame:IsVisible()) then
				HideUIPanel(FriendsFrame);
			end
		end
	elseif ( button == "LeftButton" and IsControlKeyDown()) then
		-- forcing an update, since auto-update might be off
		GuildRoster();
		TitanPanelGuildButton_ListInitMaster();
	end
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_OnUpdate()
----------------------------------------------------------------------
function TitanPanelGuildButton_OnUpdate(elapsed)
	-- using my own damn timer
	-- EMERALD: That worked well  :P  j/k  ;)
	if (TitanGuildFirstCycle) then -- This will prevent the login delay before first update
		guild_TimeCounter = TITAN_GUILD_FREQUENCY;
		if (not (TitanGetVar(TITAN_GUILD_ID, "DisableRosterUpdates"))) then
			TitanPanelGuildButton_GetGuildRoster(timeLeft);
		end
		TitanGuildFirstCycle = false;
	else
		local timeLeft = guild_TimeCounter - elapsed;
		if (timeLeft <= 0) then
			guild_TimeCounter = TITAN_GUILD_FREQUENCY;
			if (not (TitanGetVar(TITAN_GUILD_ID, "DisableRosterUpdates"))) then
				TitanPanelGuildButton_GetGuildRoster(timeLeft);
			end
		else
			guild_TimeCounter = timeLeft;
		end
	end
end

----------------------------------------------------------------------
-- TitanPanelGuildButton_GetButtonText(id)
----------------------------------------------------------------------
function TitanPanelGuildButton_GetButtonText(id)
	local id = TitanUtils_GetButton(id, true);
	local NumGuild = 0;
	local guild_name = "";
	local guild_rank = "";
	local guild_rankIndex = "";
	local guild_level = "";
	local guild_class = "";
	local guild_zone = " . ";
	local guild_group = "";
	local guild_note = "";
	local guild_officernote = "";
	local guild_online = "";
	local guildIndex;
	local buttonRichText = "";
	if (IsInGuild()) then
		NumGuild = GetNumGuildMembers();
		-- create string for Titan bar display
		if (GetGuildRosterShowOffline()) then
			if (numGuildOnlineFiltered > 0) then
				buttonRichText = format(TITAN_GUILD_BUTTON_TEXT_FILTERED, TitanUtils_GetGreenText(numGuildOnline), TitanUtils_GetNormalText(numGuildOnlineFiltered), TitanUtils_GetHighlightText(NumGuild));
			else
				buttonRichText = format(TITAN_GUILD_BUTTON_TEXT, TitanUtils_GetGreenText(numGuildOnline), TitanUtils_GetHighlightText(NumGuild));
			end
		else
			if (numGuildOnlineFiltered > 0) then
				buttonRichText = format(TITAN_GUILD_BUTTON_TEXT, TitanUtils_GetGreenText(numGuildOnline), TitanUtils_GetNormalText(numGuildOnlineFiltered));
			else
				buttonRichText = format(TITAN_GUILD_BUTTON_TEXT_ONLINEONLY_FORMAT, TitanUtils_GetGreenText(numGuildOnline));	
			end
		end
		-- return button text
		return TITAN_GUILD_BUTTON_LABEL, buttonRichText;
	else
		return TITAN_GUILD_BUTTON_LABEL, TITAN_GUILD_NOT_IN_GUILD;
	end
end

----------------------------------------------------------------------
-- TitanPanelGuildButton_GetTooltipText()
----------------------------------------------------------------------
function TitanPanelGuildButton_GetTooltipText()
	local NumGuild = 0;
	local tooltipRichText = "";
	local guild_name = "";
	local guild_rank = "";
	local guild_rankIndex = "";
	local guild_level = "";
	local guild_class = "";
	local guild_zone = "";
	local guild_group = "";
	local guild_note = "";
	local guild_officernote = "";
	local guild_online = "";
	local guildIndex;
	local richRankText = " ";
	local showWarning = 0;
	local rowCount = 0;
	-- player is in a guild, construct the tooltip text
	if (IsInGuild()) then
		tooltipRichText = TitanUtils_GetNormalText(GetGuildInfo("player"));
		tooltipRichText = tooltipRichText.."\t"..TitanUtils_GetGreenText(TITAN_GUILD_TOOLTIP_HINT_TEXT); -- add hint
		--if (TitanGetVar(TITAN_GUILD_ID, "SortByValue")) then
		--	tooltipRichText = tooltipRichText.."\t".."Sorted by: "..TitanGetVar(TITAN_GUILD_ID, "SortByValue").."\n";
		--else
			tooltipRichText = tooltipRichText.."\n";
		--end
		-- display current filters
		if (TitanGetVar(TITAN_GUILD_ID, "FilterMyZone")) then
			tooltipRichText = tooltipRichText..TITAN_GUILD_MENU_FILTER_MYZONE..": "..GetZoneText().."\n";
		end
		if (TitanGetVar(TITAN_GUILD_ID, "FilterMyLevel")) then
			tooltipRichText = tooltipRichText..TITAN_GUILD_MENU_FILTER_MYLEVEL..": "..TitanPanelGuildButton_GetMinLevel().."-"..TitanPanelGuildButton_GetMaxLevel().."\n";
		end
		if (TitanGetVar(TITAN_GUILD_ID, "FilterClasses")) then
			tooltipRichText = tooltipRichText..TITAN_GUILD_MENU_FILTER_CLASS..": "..TitanGetVar(TITAN_GUILD_ID, "FilterClasses").."\n";
		end		
		NumGuild = GetNumGuildMembers();
		for guildIndex=1, NumGuild do
			guild_name, guild_rank, guild_rankIndex, guild_level, guild_class, guild_zone, guild_group, guild_note, guild_officernote, guild_online = GetGuildRosterInfo(guildIndex);
			richRankText = TitanPanelGuildButton_ColorRankNameText(guild_rankIndex, guild_rank);
			-- on game load, the zone info is sometimes unknown
			if (not guild_zone) then
				guild_zone = " . ";
			end
			if ( guild_online ) then -- EMERALD: Changed colors and whatnot here
				-- check for player zone and level filters
				if TitanPanelGuildButton_IsPassFilter(guild_zone, guild_level, guild_class) then
					if (TitanGetVar(TITAN_GUILD_ID, "ShowTooltipName")) then
						tooltipRichText = tooltipRichText..TitanUtils_GetColoredText(guild_name, TG.Color["yellow"]);
					end
					if (TitanGetVar(TITAN_GUILD_ID, "ShowTooltipNote")) then
						if (guild_note ~= "") then
							tooltipRichText = tooltipRichText..TitanUtils_GetColoredText(" ("..guild_note..")", TG.Color["gray"]).."\t";
						else
							tooltipRichText = tooltipRichText.."\t";
						end
					else
						tooltipRichText = tooltipRichText.."\t";
					end
					if (TitanGetVar(TITAN_GUILD_ID, "ShowTooltipZone")) then
						tooltipRichText = tooltipRichText.." "..TitanUtils_GetColoredText(guild_zone, TG.Color["cyan"]);
					end
					if (TitanGetVar(TITAN_GUILD_ID, "ShowTooltipLevel")) then
						tooltipRichText = tooltipRichText.." "..TitanUtils_GetColoredText(guild_level, TG.Color["orange"]);
					end
					if (TitanGetVar(TITAN_GUILD_ID, "ShowTooltipClass")) then
						tooltipRichText = tooltipRichText.." "..TitanUtils_GetColoredText(guild_class, TG.Color["white"]);
					end
					if (TitanGetVar(TITAN_GUILD_ID, "ShowTooltipRank")) then
						tooltipRichText = tooltipRichText.." "..richRankText;
					end
					tooltipRichText = tooltipRichText.."\n";				
				
				rowCount = rowCount+1
				end
			end
			-- if the tooltip limit is going to be exceeded, stop
			if (rowCount == TITAN_GUILD_TOOLTIP_THRESHOLD) then
				showWarning = 1
				break;
			end
		end
		
		-- add warning if too large
		if (showWarning == 1) then
			tooltipRichText = tooltipRichText.."\n"..TitanUtils_GetRedText(TITAN_GUILD_TOOLTIP_WARNING);		
		end
		return tooltipRichText;
	else
		-- show a default message if the player is not in a guild	
		return TitanUtils_GetNormalText(TITAN_GUILD_NOT_IN_GUILD);
	end
end

----------------------------------------------------------------------
-- Utility functions
----------------------------------------------------------------------
	TG = {};
	TG.Color = {};
	TG.Color["red"] = { r = 1.0, g = 0.0, b = 0.0 }
	TG.Color["green"] = { r = 0.0, g = 1.0, b = 0.0 }
	TG.Color["blue"] = { r = 0.0, g = 0.0, b = 1.0 }
	TG.Color["white"] = { r = 1.0, g = 1.0, b = 1.0 }
	TG.Color["magenta"] = { r = 1.0, g = 0.0, b = 1.0 }
	TG.Color["yellow"] = { r = 1.0, g = 1.0, b = 0.0 }
	TG.Color["cyan"] = { r = 0.0, g = 1.0, b = 1.0 }
	TG.Color["gray"] = { r = 0.7, g = 0.7, b = 0.7 }
	TG.Color["orange"] = { r = 1.0, g = 0.6, b = 0.0 }

----------------------------------------------------------------------
--  TitanPanelGuildButton_SortGuildRoster()
--  executes the SortGuildRoster function and updates the button
----------------------------------------------------------------------
function TitanPanelGuildButton_SortGuildRoster()
	-- if a stored sort value exists, then sort
	--guildPrintDebugMessage(TitanGetVar(TITAN_GUILD_ID, "SortByValue"));
	if (TitanGetVar(TITAN_GUILD_ID, "SortByValue")) then
		SortGuildRoster(string.lower(TitanGetVar(TITAN_GUILD_ID, "SortByValue")));
	end
	--guildPrintDebugMessage("Done sorting");
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_SetSortByValue()
--  persist the user's sort selection
----------------------------------------------------------------------
function TitanPanelGuildButton_SetSortByValue()
	TitanSetVar(TITAN_GUILD_ID, "SortByValue", this.value);
	-- conduct the sort
	TitanPanelGuildButton_SortGuildRoster()
	TitanPanelGuildButton_CloseMenu();
	TitanPanelGuildButton_ListInitMaster();
	TitanPanelButton_UpdateButton(TITAN_GUILD_ID);
	TitanPanelButton_UpdateTooltip();	
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_SetTooltipChoice()
--  used to config the tooltip output
----------------------------------------------------------------------
function TitanPanelGuildButton_SetTooltipChoice()
	local tooltipConfigVar = "ShowTooltip"..this.value;
	TitanToggleVar(TITAN_GUILD_ID, tooltipConfigVar);
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_CloseMenu()
----------------------------------------------------------------------
function TitanPanelGuildButton_CloseMenu() 
	TitanPanelRightClickMenu_Close()
end

-- toggle the advanced menuing
function TitanPanelGuildButton_ToggleAdvancedMenus()
	TitanToggleVar(TITAN_GUILD_ID, "ShowAdvancedMenus");
	TitanPanelGuildButton_ListInitMaster()
	TitanPanelButton_UpdateButton(TITAN_GUILD_ID);
end

-- toggle the advanced menuing
function TitanPanelGuildButton_ToggleShowMenuOptions()
	TitanToggleVar(TITAN_GUILD_ID, "ShowMenuOptions");
	TitanPanelGuildButton_ListInitMaster();
	TitanPanelButton_UpdateButton(TITAN_GUILD_ID);
end

-- toggle filter on player level menuing
function TitanPanelGuildButton_ToggleFilterMyLevel()
	TitanToggleVar(TITAN_GUILD_ID, "FilterMyLevel");
	TitanPanelGuildButton_CloseMenu();
	TitanPanelGuildButton_ListInitMaster();
	TitanPanelButton_UpdateButton(TITAN_GUILD_ID);
end

-- toggle filter on player zone advanced menuing
function TitanPanelGuildButton_ToggleFilterMyZone()
	TitanToggleVar(TITAN_GUILD_ID, "FilterMyZone");
	TitanPanelGuildButton_CloseMenu();
	TitanPanelGuildButton_ListInitMaster();
	TitanPanelButton_UpdateButton(TITAN_GUILD_ID);
end

-- toggle the roster updates
function TitanPanelGuildButton_ToggleRosterUpdates()
	TitanToggleVar(TITAN_GUILD_ID, "DisableRosterUpdates");
	TitanPanelGuildButton_ListInitMaster()
	TitanPanelButton_UpdateButton(TITAN_GUILD_ID);
end

-- add class filters
function TitanPanelGuildButton_AddClassFilter()
	--local lClasses = TitanGetVar(TITAN_GUILD_ID, "FilterClasses");
	--table.insert(lClasses, classValue);
	--TitanSetVar(TITAN_GUILD_ID, "FilterClasses", lClasses);
	if (this.value == "All") then
		TitanSetVar(TITAN_GUILD_ID, "FilterClasses", TITAN_NIL);
	else
		TitanSetVar(TITAN_GUILD_ID, "FilterClasses", this.value);
	end
	TitanPanelGuildButton_CloseMenu();
	TitanPanelGuildButton_ListInitMaster();
	TitanPanelButton_UpdateButton(TITAN_GUILD_ID);
end

-- send a /w chat command
function TitanPanelGuildButton_GuildWhisper()
	if ( not ChatFrameEditBox:IsVisible() ) then
		ChatFrame_OpenChat("/w".." "..this.value.." ");
	else
		ChatFrameEditBox:SetText("/w".." "..this.value.." ");
	end
end

-- send a /g chat command
function TitanPanelGuildButton_OpenGuildChat()
	if ( not ChatFrameEditBox:IsVisible() ) then
		ChatFrame_OpenChat("/g");
	else
		ChatFrameEditBox:SetText("/g");
	end
end

-- send a /o chat command
function TitanPanelGuildButton_OpenGuildOfficerChat()
	if ( not ChatFrameEditBox:IsVisible() ) then
		ChatFrame_OpenChat("/o");
	else
		ChatFrameEditBox:SetText("/o");
	end
end

-- invoke invite to group command
function TitanPanelGuildButton_InviteToGroup()
	InviteByName(this.value);
end

-- invoke a /who query on a guild member
function TitanPanelGuildButton_SendWhoRequest()
	SendWho(this.value);
end

-- add a guild member to your friends list
function TitanPanelGuildButton_AddFriend()
	AddFriend(this.value);
end

-- check for frames which only exist for certain classes
function TitanPanelGuildButton_CheckForFrame(frameName)
	if (frameName) then
		return frameName:IsVisible();
	end
end

-- get the min level for filtering
function TitanPanelGuildButton_GetMinLevel()
	local playerLevel = UnitLevel("player");
	local levelMin = 1;
	if (playerLevel <= TITAN_GUILD_LEVEL_RANGE) then
		levelMin = 1;
	else
		levelMin = playerLevel - TITAN_GUILD_LEVEL_RANGE;
	end
	return levelMin;
end

-- get the max level for filtering
function TitanPanelGuildButton_GetMaxLevel()
	local playerLevel = UnitLevel("player");
	local levelMax = 60;
	if (playerLevel + TITAN_GUILD_LEVEL_RANGE >= 60) then
		levelMax = 60;
	else
		levelMax = playerLevel + TITAN_GUILD_LEVEL_RANGE;
	end
	return levelMax;
end

-- TitanPanelGuildButton_ColorRankNameText()
function TitanPanelGuildButton_ColorRankNameText(guild_rankIndex, guild_rank)
	local green = GREEN_FONT_COLOR;		-- 0.1, 1.00, 0.1
	local yellow = NORMAL_FONT_COLOR;	-- 1.0, 0.82, 0.0
	local red = RED_FONT_COLOR;				-- 1.0, 0.10, 0.1
	
	local color = {};
	local index = guild_rankIndex;
	local nRanks = GuildControlGetNumRanks();
	local pct = ((guild_rankIndex*100)/nRanks)/100;
	local colortxt = "";
	if (index == 0) then
		color = red;
	elseif (index == (nRanks/2)) then
		color = yellow;
	elseif (index == nRanks) then
		color = green;
	elseif (index > (nRanks/2)) then
		local pctmod = (1.0 - pct) * 2;
		color.r =(yellow.r - green.r)*pctmod + green.r;
		color.g = (yellow.g - green.g)*pctmod + green.g;
		color.b = (yellow.b - green.b)*pctmod + green.b;
	elseif (index < (nRanks/2)) then
		local pctmod = (0.5 - pct) * 2;	
		color.r = (red.r - yellow.r)*pctmod + yellow.r;
		color.g = (red.g - yellow.g)*pctmod + yellow.g;
		color.b = (red.b - yellow.b)*pctmod + yellow.b;
	end
	colortxt = TitanUtils_GetColoredText(guild_rank, color);
	return colortxt;
end

--[[
function bootstrapColorTest()
	for rIndex=0, 10 do
		guildPrintDebugMessage(rIndex.." "..TitanPanelGuildButton_ColorRankNameText(rIndex, "RankRankRank"));
	end
end
]]

-- used for chat frame based debug messaging
function guildPrintDebugMessage(msg)
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end	
end

----------------------------------------------------------------------
-- TitanPanelGuildButton_GetGuildRoster(timer)
-- time based wrapper for the GuildRoster() call
-- calling based on a countdown from TITAN_GUILD_FREQUENCY
----------------------------------------------------------------------
function TitanPanelGuildButton_GetGuildRoster(timer)
	-- if the user is accessing any frames or menus in Titan
	-- or if the user is accessing general game frames which might conflict with a FriendsFrame open
	-- then do not conduct a GuildRoster() call.
	local isInGuildFrame;
	local isRightClickMenuVisible;
	isInGuildFrame = MouseIsOver(TitanPanelGuildButton);
	isRightClickMenuVisible = TitanPanelRightClickMenu_IsVisible();
	if (timer and timer <= 0) then
		-- EMERALD: Trying to account for all those LoadOnDemand UI bits
--DEFAULT_CHAT_FRAME:AddMessage("DEBUG: Timer expired, firing!");
		local trapIt = false;
		if (FriendsFrame and FriendsFrame:IsVisible()) then trapIt = true;
		elseif (MailFrame and MailFrame:IsVisible()) then trapIt = true;
		elseif (QuestLogFrame and QuestLogFrame:IsVisible()) then trapIt = true;
		elseif (SpellBookFrame and SpellBookFrame:IsVisible()) then trapIt = true;
		elseif (InspectFrame and InspectFrame:IsVisible()) then trapIt = true;
		elseif (AuctionFrame and AuctionFrame:IsVisible()) then trapIt = true;
		elseif (BankFrame and BankFrame:IsVisible()) then trapIt = true;
		elseif (TradeFrame and TradeFrame:IsVisible()) then trapIt = true;
		elseif (GuildRegistrarFrame and GuildRegistrarFrame:IsVisible()) then trapIt = true;
		elseif (LootFrame and LootFrame:IsVisible()) then trapIt = true;
		elseif (TaxiFrame and TaxiFrame:IsVisible()) then trapIt = true;
		elseif (MerchantFrame and MerchantFrame:IsVisible()) then trapIt = true;
		elseif (QuestFrame and QuestFrame:IsVisible()) then trapIt = true;
		elseif (WorldMapFrame and WorldMapFrame:IsVisible()) then trapIt = true;
		elseif (GossipFrame and GossipFrame:IsVisible()) then trapIt = true;
		elseif (ClassTrainerFrame and ClassTrainerFrame:IsVisible()) then trapIt = true;
		elseif (CoinPickupFrame and CoinPickupFrame:IsVisible()) then trapIt = true;
		elseif (CraftFrame and CraftFrame:IsVisible()) then trapIt = true;
		elseif (GuildRegistrarFrame and GuildRegistrarFrame:IsVisible()) then trapIt = true;
		elseif (TabardFrame and TabardFrame:IsVisible()) then trapIt = true;
		elseif (ItemTextFrame and ItemTextFrame:IsVisible()) then trapIt = true;
		elseif (TradeSkillFrame and TradeSkillFrame:IsVisible()) then trapIt = true;
		elseif (TalentFrame and TalentFrame:IsVisible()) then trapIt = true;
		elseif (BattlefieldFrame and BattlefieldFrame:IsVisible()) then trapIt = true;
		elseif (TalentTrainerFrame and TitanPanelGuildButton_CheckForFrame(TalentTrainerFrame)) then trapIt = true;
		elseif (GuildOrg and GuildOrg:IsVisible()) then trapIt = true;
		elseif isInGuildFrame then trapIt = true;
		elseif isRightClickMenuVisible then trapIt = true;
		else trapIt = false;
		end
		
		if (not trapIt) then
			hide_TitanPanelGuildButton_FriendsFrame = 1;
			if (IsInGuild()) then
				GuildRoster();
				-- reset the timer to full ... EMERALD: Only do this reset on positive hit
				guild_TimeCounter = TITAN_GUILD_FREQUENCY;
--DEFAULT_CHAT_FRAME:AddMessage("DEBUG: Update successful. We think.");
			end
		else
			-- EMERALD: Set the timer out a little bit, so we can hopefully catch a break when the preventative window closes
			guild_TimeCounter = 15;
--DEFAULT_CHAT_FRAME:AddMessage("DEBUG: Unable to update, waiting 15 seconds.");
		end
		
	end
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_ConstructGuildTable()
--  constructs a table used to generate the right-click menu nav
----------------------------------------------------------------------
function TitanPanelGuildButton_ConstructGuildTable()
	local g_name, g_rank, g_rankIndex, g_level, g_class, g_zone, g_group, g_note, g_officernote, g_online
	local rankTable = {};
	local rankMembers = {};
	masterTable = {};
	local gIndex;
	local rIndex;
	-- don't show offline
	--local origShowoffline = GetGuildRosterShowOffline();
	-- turn offline member showing off
	--SetGuildRosterShowOffline(false)
	local guildNum = GetNumGuildMembers();
	local numRanks = GuildControlGetNumRanks();
	local rankMemberTablePos;
	-- for all ranks, create the tabled used for the right-click menus
	for rIndex=1, numRanks do
		rankMembers = {};
		rankTable = {};
		rankMemberTablePos = 1;
		-- insert the rank name at pos 1
		rankTable.rank = GuildControlGetRankName(rIndex);
		for gIndex=1, guildNum do
			g_name, g_rank, g_rankIndex, g_level, g_class, g_zone, g_group, g_note, g_officernote, g_online = GetGuildRosterInfo(gIndex);
			--guildPrintDebugMessage("guild_rankIndex: "..g_rankIndex.." = "..rIndex.." "..g_name.." "..g_rank);
			-- guild rank index might be zero based, so add 1
			g_rankIndex = g_rankIndex + 1;
			-- check if online before adding to table
			if (g_online) then
				-- check filters before adding to table
				if TitanPanelGuildButton_IsPassFilter(g_zone, g_level, g_class) then
					if (g_rankIndex == rIndex) then
						--guildPrintDebugMessage("MATCH guild_rankIndex: "..g_rankIndex.." = "..rIndex.." "..g_name.." "..g_rank);
						table.insert(rankMembers, rankMemberTablePos, g_name);
						--guildPrintDebugMessage(rankMembers[rankMemberTablePos]);
						rankMemberTablePos = rankMemberTablePos + 1;
					end
				end
			end
		end
		rankTable.members = rankMembers;
		table.insert(masterTable, rIndex, rankTable);
	end
	-- restore original offline setting
	--SetGuildRosterShowOffline(origShowoffline);
	
--[[
	-- debug
	local x = 1;
	local y = 1;
	tsize = table.getn(masterTable);
	guildPrintDebugMessage("size: "..tsize);
	for x = 1, table.getn(masterTable) do
		guildPrintDebugMessage("index: "..x);
		tRankTable = masterTable[x];
		guildPrintDebugMessage(tRankTable.rank);
		tRankMembers = tRankTable.members;
		for y = 1, table.getn(tRankMembers) do
			guildPrintDebugMessage(tRankMembers[y]);
		end
	end
]]
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_ConstructSimpleGuildTable()
--  constructs a table used to generate the flat right-click nav
----------------------------------------------------------------------
function TitanPanelGuildButton_ConstructSimpleGuildTable()
	local g_name, g_rank, g_rankIndex, g_level, g_class, g_zone, g_group, g_note, g_officernote, g_online
	masterTableSimple = {};
	local gIndex;
	local rIndex;
	local guildNum = GetNumGuildMembers();
	local simpleMemberTablePos = 1;
	for gIndex=1, guildNum do
		g_name, g_rank, g_rankIndex, g_level, g_class, g_zone, g_group, g_note, g_officernote, g_online = GetGuildRosterInfo(gIndex);
		-- check if online before adding to table
		if (g_online) then
			-- check filters before adding to table
			if TitanPanelGuildButton_IsPassFilter(g_zone, g_level, g_class) then
				-- insert into a flat table for rendering the simple menus
				local filteredPlayer = {name=g_name,rankIndex=g_rankIndex};
				table.insert(masterTableSimple, simpleMemberTablePos, filteredPlayer);
				simpleMemberTablePos = simpleMemberTablePos + 1;	
			end
		end
	end
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_ListInitMaster()
--  wrapper for several functions called on a list update
----------------------------------------------------------------------
function TitanPanelGuildButton_ListInitMaster()
	TitanPanelGuildButton_InitPaging();
	TitanPanelGuildButton_ComputeOnlineGuildMembers();
	TitanPanelGuildButton_ComputePages();
	TitanPanelGuildButton_ConstructSimpleGuildTable();
	TitanPanelGuildButton_ConstructGuildTable();
end
