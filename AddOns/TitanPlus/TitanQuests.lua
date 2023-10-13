--------------------------------------------------------------------------
-- TitanQuests.lua 
--------------------------------------------------------------------------
--[[

Titan Panel [Quests]
	Displays number of quests in Titan Panel. When hovered over it 
	displays the following info:
	- total number of quests
	- number of Elite quests
	- number of Dungeon quests
	- number of Raid quests
	- number of PvP quests 
	- number of regular quests (non elite/dungeon/raid/pvp)
	- number of quests in log currently completed

	Right-click to see a color coded list of current quests. When hovered 
	over a dropdown menu will appear with a list of quest objectives, add to
	Blizzard's Quest Tracker, share quest, abandon quest, open quest details
    and link quest to chat.

	The Options menu allows you to sort and groupthe quests by level, zone, 
	or by title. You can also apply a filter to view only dungeon, elite,
	complete, incomplete, or regular quests.

	Can toggle MonkeyQuest, QuestHistory, PartyQuests, QuestIon and
	QuestBank if these AddOns are installed.

	NOTE: Requires Titan Panel version 1.22+

	TODO: Minor French and German translations.  Complete Korean translations.

v0.13 (June 28, 2005 9:11 PST)
- fixed bug when clicking on "Quest Details"
- minor German translation fix (thanks Scarabeus)

v0.12 (June 22, 2005 01:00 PST)
- added ability to click on a quest to add to the quest tracker directly [Ryessa]
- added option to set "Watch" or "Quest Details" as primary action when clicking a quest [Ryessa]
- added SHIFT-click to perform the secondary action ("Watch" or "Quest Details") [Ryessa]
- cleaned up info display panel a bit [Ryessa]
- set quests to store their toggle state in Titan variables (prep to persist watched quests between sessions) [Ryessa]
- added option to disable grouping of quests under Zone or Level headings [Ryessa]
- moved a lot of code into utility functions for code cleanliness at cost of a slight perf hit (not noticable) [Ryessa]
- added "Failed" quest tag [Corgi]

v0.11 (June 15, 2005 16:40 PST)
- new quest list layout [Ryessa]
- added option to show only incomplete quests (need loc guys to review) [Ryessa]
- added grouping headers when sorting by location or level [Ryessa]
- moved most options to a side menu because of the larger size from grouping [Ryessa]
- Shortened English tooltip descriptors [Ryessa]
- Changed Titan button text to be NumComplete/NumCurrent [Ryessa]
- updated for Titan Panel 1.24 [Corgi]

v0.10 (June 7, 2005 20:30 PST)
- German localization changes (thanks Kaesemuffin)
- added French localization (thanks Vorpale)
- toc updated for 1.50 patch

v0.09 (June 2, 2005 15:31 PST)
- fixed bug that was causing WoW.exe to crash when changing characters
- added German localization (thanks Scarabeus)
	
v0.08 (May 30, 2005 14:00 PST)
- added the ability to sort the quest list by location (default), level or title.
- added the ability to just show quests based on their type (ie, just show elite quests).

v0.07 (May 27, 2005 17:41 PST)
- added a [Quests] icon for the Titan Panel, which can be turned on/off.
- minor changes to text displayed in mouseover tooltip.

v0.06 (May 20, 2005 20:27 PST)
- added 'Quest Details' button to quest dropdown menu.
- added a 'Link Quest' button to quest dropdown menu.
- added Location to Quest Details.
- added colored quest level text to Quest Details window title.
- fixed ui scaling issue with Quest Details window.
- added 'Toggle' dropdown menu to toggle the blizzard's quest log and various 3rd party addons.
- clicking on quest now opens a movable window with complete quest info, including rewards.
- Share Quest has been added to quest dropdown menu.
- Abandon Quest has been added to quest dropdown menu (a window will open for confirmation).
- localization.lua is ready for german, french and korean translations

v0.05 (May 15, 2005 16:20 PST)
- clicking on a quest in the quest list will open a dropdown menu showing the quest objectives and a button to add/remove the quest from Blizzard's Quest Tracker.
- added quest location and complete tag to the quest list.
- added the ability to toggle PartyQuests, QuestBank, QuestIon if they are installed.
- changed 'About' button to open a dropdown menu displaying mod name, version and author name.

v0.04 (May 14, 2005 19:43 PST)
- added the ability to toggle MonkeyQuest and/or QuestHistory from the right-click menu if they are installed.
- added version info to mouseover tooltip.
- added 'About' to right-click menu, which opens a window displaying mod name, version and author name.

v0.03 (May 13, 2005 14:28 PST)
- clicking on quest will now open the quest log to that particular quest.

v0.02 (May 13, 2005 12:01 PST)
- fixed typo to allow 'Show Label Text' to work.

v0.01 (May 13, 2005 10:30 PST)
- Initial Release

]]--

--
-- Titan Panel Variables
--
TITAN_QUESTS_ID = "Quests";

TITAN_QUESTS_ARTWORK_PATH = "Interface\\AddOns\\TitanPlus\\Artwork\\";
 

-- 
-- OnFunctions
--
function TitanPanelQuestsButton_OnLoad()

	this.registry = { 
		id = TITAN_QUESTS_ID,
		builtIn_t = 1,
		menuText = TITAN_QUESTS_MENU_TEXT,
		buttonTextFunction = "TitanPanelQuestsButton_GetButtonText",	
		tooltipTitle = TITAN_QUESTS_TOOLTIP,
		tooltipTextFunction = "TitanPanelQuestsButton_GetTooltipText",
		icon = TITAN_QUESTS_ARTWORK_PATH.."TitanQuests",	
		iconWidth = 16,
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			SortByLevel = TITAN_NIL,
			SortByLocation = 1,
			SortByTitle = TITAN_NIL,
			ShowElite = TITAN_NIL,
			ShowDungeon = TITAN_NIL,
			ShowRaid = TITAN_NIL,
			ShowPVP = TITAN_NIL,
			ShowRegular = TITAN_NIL,
			ShowCompleted = TITAN_NIL,
			ShowIncomplete = TITAN_NIL,
			ShowAll = 1,
			GroupBehavior = 1,
			ClickBehavior = TITAN_NIL,
		}
	};

	this:RegisterEvent("QUEST_LOG_UPDATE");
end

function TitanPanelQuestsButton_OnEvent()

	TitanPanelButton_UpdateButton(TITAN_QUESTS_ID);	
	TitanPanelButton_UpdateTooltip();

	if ( event == "QUEST_LOG_UPDATE" ) then
		if ( TitanQuests_Details ~= nil ) then
			if ( TitanQuests_Details:IsVisible() ) then
				TitanQuests_Details_Update();
			end
		end
	end
end 

--
-- create button text
--
function TitanPanelQuestsButton_GetButtonText(id)

	local MaxQuests = 20;
	local NumCompleteQuests = 0;

	local NumEntries, NumQuests;

	NumEntries, NumQuests = GetNumQuestLogEntries();

	-- get quest list
	local questlist = TitanPanelQuests_BuildQuestList();
	local i = 0;

	-- count the number of incomplete quests
	for i=1, NumQuests do
		if(questlist[i]) then
			if ( questlist[i].questisComplete ) then
				NumCompleteQuests = NumCompleteQuests + 1;
			end
		end
	end

	-- create string for Titan bar display
	local buttonRichText = format(TITAN_QUESTS_BUTTON_TEXT, TitanUtils_GetGreenText(NumCompleteQuests), TitanUtils_GetHighlightText(NumQuests) );

	return TITAN_QUESTS_BUTTON_LABEL, buttonRichText;
end

--
-- create tooltip text
--
function TitanPanelQuestsButton_GetTooltipText()

	-- Expand everything
	ExpandQuestHeader(0);
	
	-- return string for tooltip
	local tooltipRichText = "";
	
	-- counters
	local numElite = 0;
	local numDungeon = 0;
	local numRaid = 0;
	local numPVP = 0;
	local numReg = 0;
	local numComplete = 0;
	local numIncomplete = 0;

	local i = 0;

	local numQuests = 0;

	-- get quest list
	local questlist = TitanPanelQuests_BuildQuestList();

	-- total number of quests
	numQuests = table.getn(questlist);

	-- count the different type of quests and count completed quests
	for i=1, numQuests do
		if ( questlist[i].questTag == ELITE ) then
			numElite = numElite + 1;
		elseif ( questlist[i].questTag == TITAN_QUESTS_DUNGEON ) then
			numDungeon = numDungeon + 1;
		elseif ( questlist[i].questTag == TITAN_QUESTS_RAID ) then
			numRaid = numRaid + 1;
		elseif ( questlist[i].questTag == TITAN_QUESTS_PVP ) then
			numPVP = numPVP + 1;
		else
			numReg = numReg + 1;
		end

		if ( questlist[i].questisComplete ) then
			numComplete = numComplete + 1;
		else
			numIncomplete = numIncomplete + 1;
		end
	end

	tooltipRichText = tooltipRichText..TitanUtils_GetNormalText(TITAN_QUESTS_TOOLTIP_QUESTS_TEXT)..TitanUtils_GetHighlightText(numQuests.."\n");
	tooltipRichText = tooltipRichText..TitanUtils_GetNormalText(TITAN_QUESTS_TOOLTIP_ELITE_TEXT)..TitanUtils_GetHighlightText(numElite.."\n");
	tooltipRichText = tooltipRichText..TitanUtils_GetNormalText(TITAN_QUESTS_TOOLTIP_DUNGEON_TEXT)..TitanUtils_GetHighlightText(numDungeon.."\n");
	tooltipRichText = tooltipRichText..TitanUtils_GetNormalText(TITAN_QUESTS_TOOLTIP_RAID_TEXT)..TitanUtils_GetHighlightText(numRaid.."\n");
	tooltipRichText = tooltipRichText..TitanUtils_GetNormalText(TITAN_QUESTS_TOOLTIP_PVP_TEXT)..TitanUtils_GetHighlightText(numPVP.."\n");
	tooltipRichText = tooltipRichText..TitanUtils_GetNormalText(TITAN_QUESTS_TOOLTIP_REGULAR_TEXT)..TitanUtils_GetHighlightText(numReg.."\n");
	tooltipRichText = tooltipRichText.."\n";
	tooltipRichText = tooltipRichText..TitanUtils_GetNormalText(TITAN_QUESTS_TOOLTIP_COMPLETED_TEXT)..TitanUtils_GetHighlightText(numComplete).."\n";
	tooltipRichText = tooltipRichText..TitanUtils_GetNormalText(TITAN_QUESTS_TOOLTIP_INCOMPLETE_TEXT)..TitanUtils_GetHighlightText(numIncomplete).."\n";
	tooltipRichText = tooltipRichText.."\n"..TitanUtils_GetGreenText(TITAN_QUESTS_TOOLTIP_HINT_TEXT);
	return tooltipRichText;
end

--
-- create toplevel right-click menu
--
function TitanPanelRightClickMenu_PrepareQuestsMenu()
	-- Large sections commented out, since they are replaced by various utility functions. - Ryessa

	if ( UIDROPDOWNMENU_MENU_LEVEL >= 2 ) then
		TitanPanelQuestsRightClickMenu_CreateMenu();
	else
		-- get quest list
		local questlist = TitanPanelQuests_BuildQuestList();
	
		-- total number of quests
		local numQuests = table.getn(questlist);

		local groupBy = "Location";

		-- tracking length of list
		local numButtons = 1; -- Starts at 1 because "Quests" header is added elsewhere. - Ryessa
	
		if ( TitanGetVar(TITAN_QUESTS_ID, "SortByLevel") ) then
			table.sort(questlist, function(a,b) return (a.questLevel < b.questLevel); end);
			groupBy = "Level";
		end
	
		if ( TitanGetVar(TITAN_QUESTS_ID, "SortByTitle") ) then
			table.sort(questlist, function(a,b) return (a.questTitle < b.questTitle); end);
			groupBy = "Title";
		end
	
		local useTag;
		local completeTag;
		local questWatched = "";
		local diff;
	
		local groupId = "";
		local lastGroupId = "";
	
		local questDisplayCount = 0;
	
		local i = 0;
	
		local info = {};
	
		TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_QUESTS_ID].menuText);
	
		-- create a configuration entry
		info = {};
		info.text = TITAN_QUESTS_OPTIONS_TEXT;
		info.value = "Options";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);
		numButtons = numButtons + 1;
	
		-- output quest list to menu
		for i=1, numQuests do
			local unCheckableQuest = nil; -- added
--[[			
			if ( questlist[i].questTag == ELITE ) then
				useTag = "+"
			elseif ( questlist[i].questTag == TITAN_QUESTS_DUNGEON ) then
				useTag = "d";
			elseif ( questlist[i].questTag == TITAN_QUESTS_RAID ) then
				useTag = "r";
			elseif ( questlist[i].questTag == TITAN_QUESTS_PVP ) then
				useTag = "p";
			else
				useTag = "";
			end 
	
			if ( questlist[i].questisComplete ) then
				--useTag = "C";
				completeTag = "  ("..COMPLETE..")";
			else
				completeTag = "";
			end
	
			if ( IsQuestWatched(questlist[i].questID) ) then
				questWatched = TitanUtils_GetGreenText(" (W)");
			else
				questWatched = "";
			end
]]--		
			if ( TitanGetVar(TITAN_QUESTS_ID, "SortByLocation") and TitanGetVar(TITAN_QUESTS_ID, "GroupBehavior") ) then
				groupId = questlist[i].questLocation;
			elseif ( TitanGetVar(TITAN_QUESTS_ID, "SortByLevel") and TitanGetVar(TITAN_QUESTS_ID, "GroupBehavior") ) then
				groupId = TITAN_QUESTS_LEVEL_TEXT..questlist[i].questLevel;
			end
--[[	
	
			diff = GetDifficultyColor(questlist[i].questLevel);
]]--	
			-- check to see if quest is to be displayed
			local checkDisplay = 0;
	
			if ( TitanGetVar(TITAN_QUESTS_ID, "ShowElite") ) then
				if ( questlist[i].questTag == ELITE ) then
					checkDisplay = 1;
				end
			elseif ( TitanGetVar(TITAN_QUESTS_ID, "ShowDungeon") ) then
				if ( questlist[i].questTag == TITAN_QUESTS_DUNGEON ) then
					checkDisplay = 1;
				end
			elseif ( TitanGetVar(TITAN_QUESTS_ID, "ShowRaid") ) then
				if ( questlist[i].questTag == TITAN_QUESTS_RAID ) then
					checkDisplay = 1;
				end
			elseif ( TitanGetVar(TITAN_QUESTS_ID, "ShowPVP") ) then
				if ( questlist[i].questTag == TITAN_QUESTS_PVP ) then
					checkDisplay = 1;
				end
			elseif ( TitanGetVar(TITAN_QUESTS_ID, "ShowRegular") ) then
				if ( questlist[i].questTag == nil ) then
					checkDisplay = 1;
				end
			elseif ( TitanGetVar(TITAN_QUESTS_ID, "ShowCompleted") ) then
				if ( questlist[i].questisComplete ) then
					checkDisplay = 1;
				end
			elseif ( TitanGetVar(TITAN_QUESTS_ID, "ShowIncomplete") ) then
				if ( not questlist[i].questisComplete ) then
					checkDisplay = 1;
				end
			else	
				checkDisplay = 1;
			end
	
			if ( checkDisplay == 1 ) then
	
				-- Check if this will be the last item displayed
				if ( (questDisplayCount == 29) or ((groupId ~= "" and groupId ~= lastGroupId) and (questDisplayCount==28)) ) then
	
					-- Display a truncation notice and exit for loop
					info.text = TITAN_QUESTS_QUESTLOG_TRUNCATED_TEXT;
					info.isTitle = 1;
					info.value = "QuestLogTruncated";
					info.hasArrow = nil;
					info.notCheckable = 1;
					UIDropDownMenu_AddButton(info);
					numButtons = numButtons + 1;
	
					break;
				else
					questDisplayCount = questDisplayCount + 1;
					info = {};
					if ( groupId ~= "" and groupId ~= lastGroupId ) then
						info.text = groupId;
						info.isTitle = 1;
						info.notCheckable = 1;
						UIDropDownMenu_AddButton(info);
						numButtons = numButtons + 1;
						info = {};
						lastGroupId = groupId;
						questDisplayCount = questDisplayCount + 1;
					end
		
					if ( IsQuestWatched(questlist[i].questID) ) then
						-- May want to move part of this code to OnLoad() - Ryessa
						TitanSetVar(TITAN_QUESTS_ID, questlist[i].questID, 1);
						info.checked = TitanGetVar(TITAN_QUESTS_ID, questlist[i].questID);
					end
	
--[[					if ( groupBy == "Location" and TitanGetVar(TITAN_QUESTS_ID, "GroupBehavior") ) then
						info.text = TitanUtils_GetColoredText("["..questlist[i].questLevel..useTag.."]  ",diff)..questlist[i].questTitle..TitanUtils_GetRedText(completeTag)..questWatched;
					else
						info.text = TitanUtils_GetColoredText("["..questlist[i].questLevel..useTag.."]  ",diff)..questlist[i].questTitle..TitanUtils_GetRedText(completeTag)..TitanUtils_GetNormalText("  ["..questlist[i].questLocation.."]")..questWatched;
					end
]]--
					info.text = TitanPanelQuests_GetQuestText(questlist[i].questID); -- added

					info.value = {TITAN_QUESTS_ID, questlist[i].questID, nil};
					info.hasArrow = 1;

					info.func = TitanPanelQuests_ClickQuest;
					--info.notCheckable = 1;
					info.keepShownOnClick = 1;
					UIDropDownMenu_AddButton(info);
					numButtons = numButtons + 1;
					
					-- Add a tracking variable to set the button id for this quest.
					TitanSetVar(TITAN_QUESTS_ID, questlist[i].questID.."ButtonID", numButtons);
				end
			end	
		end
	end
end

--
-- utility function to get the string tag for a quest
--
function TitanPanelQuests_GetQuestTagText(questID)
	local useTag = "";
	local Title, Level, Tag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questID);

	-- Loc Note: Need to localize these tags - Ryessa
	if ( Tag == ELITE ) then
		useTag = "+"
	elseif ( Tag == TITAN_QUESTS_DUNGEON ) then
		useTag = "d";
	elseif ( Tag == TITAN_QUESTS_RAID ) then
		useTag = "r";
	elseif ( Tag == TITAN_QUESTS_PVP ) then
		useTag = "p";
	else
		useTag = "";
	end 
	
	if ( isComplete ) then
		--useTag = "C";
	end

	return useTag;
end

--
-- utility function to get the string tag for a watched quest
--
function TitanPanelQuests_GetQuestWatchText(questID)
	local questWatched;

	if ( IsQuestWatched(questID) ) then
		-- Loc Note: Need to localize this tag - Ryessa
		questWatched = TitanPanelQuests_BlueText(" (W)");
	else
		questWatched = "";
	end
	
	return questWatched;
end

--
-- utility function to get the string tag for a completed quest
--
function TitanPanelQuests_GetQuestCompleteText(questID)
	local completeTag;
	local Title, Level, Tag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questID);

	if ( isComplete ) then
		completeTag = "  ("..COMPLETE..")";
	else
		completeTag = "";
	end
	
	SelectQuestLogEntry(questID);
	if ( IsCurrentQuestFailed() ) then
		completeTag = " ("..TEXT(FAILED)..")";
	end
			
	return completeTag;
end

--
-- utility function to get the location string for a quest
--
function TitanPanelQuests_GetQuestLocationText(questID)
	local i;
	local questLocation = "";

	local questlist = TitanPanelQuests_BuildQuestList();
	local numQuests = table.getn(questlist);

	for i=1, numQuests do
		if ( questID == questlist[i].questID ) then
			questLocation = questlist[i].questLocation;
			break;
		end
	end

	if ( TitanGetVar(TITAN_QUESTS_ID, "SortByLocation") and TitanGetVar(TITAN_QUESTS_ID, "GroupBehavior") ) then
		return "";
	else
		return TitanUtils_GetNormalText("  ["..questLocation.."]");
	end
end

--
-- utility function to get the string tag for a watched quest
--

function TitanPanelQuests_GetQuestText(questID)
	local Title, Level, Tag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questID);
	local questTag;
	local locationTag = TitanPanelQuests_GetQuestLocationText(questID);

	questTag = TitanUtils_GetColoredText("["..Level..TitanPanelQuests_GetQuestTagText(questID).."]  ",GetDifficultyColor(Level))..Title..TitanUtils_GetRedText(TitanPanelQuests_GetQuestCompleteText(questID))..locationTag..TitanPanelQuests_GetQuestWatchText(questID);

	return questTag;
end

--
-- create 2nd level right-click menu
--

function TitanPanelQuestsRightClickMenu_CreateMenu()
    
    local info = {};

	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		if ( UIDROPDOWNMENU_MENU_VALUE == "Options" ) then
			-- sort selection
			info = {};
			info.text = TITAN_QUESTS_SORT_TEXT;
			info.value = "Sort";
			info.hasArrow = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- show selection
			info = {};
			info.text = TITAN_QUESTS_SHOW_TEXT;
			info.value = "Show";
			info.hasArrow = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- toggle dropdown menu
			info = {};
			info.text = TITAN_QUESTS_TOGGLE_TEXT;
			info.value = "Toggle";
			info.hasArrow = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			TitanPanelRightClickMenu_AddSpacer(UIDROPDOWNMENU_MENU_LEVEL);

			-- toggle click behavior
			info = {};
			info.text = TITAN_QUESTS_CLICK_BEHAVIOR_TEXT;
			info.value = "ClickBehavior";
			info.hasArrow = nil;
			info.keepShownOnClick = 1;	
			info.func = TitanPanelQuests_ToggleClickBehavior;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ClickBehavior");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
					
			-- toggle grouping
			info = {};
			info.text = TITAN_QUESTS_GROUP_BEHAVIOR_TEXT;
			info.value = "GroupBehavior";
			info.hasArrow = nil;
			info.keepShownOnClick = nil;	
			info.func = TitanPanelQuests_ToggleGroupBehavior;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "GroupBehavior");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			TitanPanelRightClickMenu_AddSpacer(UIDROPDOWNMENU_MENU_LEVEL);

			-- Toggle icon
			info = {};
			info.text = TITAN_PANEL_MENU_SHOW_ICON;
			info.value = {TITAN_QUESTS_ID, "ShowIcon", nil};
			info.func = TitanPanelRightClickMenu_ToggleVar;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowIcon");
			info.keepShownOnClick = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Toggle Label Text
			info = {};
			info.text = TITAN_PANEL_MENU_SHOW_LABEL_TEXT;
			info.value = {TITAN_QUESTS_ID, "ShowLabelText", nil};
			info.func = TitanPanelRightClickMenu_ToggleVar;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowLabelText");
			info.keepShownOnClick = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE,TITAN_QUESTS_ID,TITAN_PANEL_MENU_FUNC_HIDE, UIDROPDOWNMENU_MENU_LEVEL);
			TitanPanelRightClickMenu_AddSpacer(UIDROPDOWNMENU_MENU_LEVEL);

			-- info about plugin
			info = {};
			info.text = TITAN_QUESTS_ABOUT_TEXT;
			info.value = "DisplayAbout";
			info.hasArrow = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		else
			--
			-- build quest objectives list
			--
			local questID = UIDROPDOWNMENU_MENU_VALUE[2];
			--TitanPanelQuests_ChatPrint("QuestID: "..questID);

			--local questTitle, questLevel, questTag, questisHeader, questisCollapsed, questisComplete;
			--local diff, useTag, completeTag;
			--questTitle, questLevel, questTag, questisHeader, questisCollapsed, questisComplete = GetQuestLogTitle(questID);

			local questTitle, questLevel = GetQuestLogTitle(questID);

			local questDescription = "";
			local questObjectives = "";

			local numObjectives = 0;
	
			local ObjectivesText = "";

		        -- select the quest entry
 		        SelectQuestLogEntry(questID);
	                QuestLog_SetSelection(questID);
	
			questDescription, questObjectives = GetQuestLogQuestText();

			numObjectives = GetNumQuestLeaderBoards();

			info = {};
			info.value = questTitle;
			info.text = questTitle;
			info.isTitle = 1;
			info.notClickable = 1;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			if ( numObjectives > 0 ) then
				for j = 1, numObjectives, 1 do
					local text;
                			local type;
                			local finished;

					info = {};
			
					text, type, finished = GetQuestLogLeaderBoard(j);

					if ( finished ) then
						info.text = TitanUtils_GetRedText(text);
					else
						info.text = text;
					end
					info.value = text;
					info.notClickable = 1;
					--info.isTitle = 0;
					UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
				end
			else
					info = {};
					if ( strlen(questObjectives) < 65 ) then
						info.text = TitanUtils_GetHighlightText(questObjectives);
					else
						info.text = TitanUtils_GetHighlightText(TITAN_QUESTS_OBJECTIVESTXT_LONG_TEXT);
					end
					info.value = "noobjective";
					info.notClickable = 1;
					info.func = TitanPanelQuests_DisplayQuest;
					UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			
			-- spacer				
			info = {};
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Header for options stuff
			info = {};
			info.value = "Quest Options";
			info.text = TITAN_QUESTS_QUEST_DETAILS_OPTIONS_TEXT;
			info.isTitle = 1;
			info.notClickable = 1;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Add/Remove quest from Quest Tracker
			if ( IsQuestWatched(questID) ) then
				info = {};
				info.text = TITAN_QUESTS_REMOVE_FROM_WATCHER_TEXT;
				info.value = {TITAN_QUESTS_ID, questID, nil};
				info.isTitle = nil;
				info.notClickable = nil;
				info.notCheckable = nil;
				info.func = TitanPanelQuests_ToggleWatchStatus;
				--function ()
				--		RemoveQuestWatch(questID);
				--		QuestWatch_Update();
				--end
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			else
				if ( GetNumQuestLeaderBoards(questID) > 0 ) then
					info.text = TITAN_QUESTS_ADD_TO_WATCHER_TEXT;
					info.value = {TITAN_QUESTS_ID, questID, nil};
					info.isTitle = nil;
					info.notClickable = nil;
					info.notCheckable = nil;
					info.disabled = nil;
					info.func = TitanPanelQuests_ToggleWatchStatus;
					--function ()
					--	if ( GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS ) then
               				--		-- Set an error message if trying to show too many quests
                        		--		UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
                			--	else
					--		AddQuestWatch(questID);
					--		QuestWatch_Update();
					--	end
					--end
					
					UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
				end
			end
			
			-- share quest
			if ( GetQuestLogPushable() ) then
				info = {};
				info.value = "ShareQuest";
				info.text = SHARE_QUEST;
				info.func = function ()
					QuestLogPushQuest();
				end
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

			-- abandon quest
			info = {};
			info.value = "AbandonQuest";
			info.text = ABANDON_QUEST;
			info.func = function ()	
					DropDownList1:Hide();				
					SetAbandonQuest();
                			StaticPopup_Show("ABANDON_QUEST", GetAbandonQuestName());
			end
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			
			-- spacer				
			info = {};
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- quest details
			info = {};
			--info.value = questID;
			info.value = {TITAN_QUESTS_ID, questID, nil};
			info.text = TITAN_QUESTS_QUEST_DETAILS_TEXT;
			info.func = TitanPanelQuests_DisplayQuest;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
			-- link quest
			info = {};
			info.value = "LinkQuest";
			info.text = TITAN_QUESTS_LINK_QUEST_TEXT;
			info.func = function ()
					ChatFrameEditBox:Insert("["..questLevel.."]"..questTitle.." ");
			end
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			
		end
	elseif ( UIDROPDOWNMENU_MENU_LEVEL == 3 ) then

		if ( UIDROPDOWNMENU_MENU_VALUE == "DisplayAbout" ) then

			local AboutText = TITAN_QUESTS_ABOUT_POPUP_TEXT;

			info.text = AboutText;
			info.value = "AboutTextPopUP";
			info.notClickable = 1;
			info.isTitle = 0;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		elseif ( UIDROPDOWNMENU_MENU_VALUE == "Sort" ) then

			info = { };
			info.text = TITAN_QUESTS_SORT_TEXT;
			info.isTitle = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- sort by location (default)
			info = {};
			info.text = TITAN_QUESTS_SORT_LOCATION_TEXT;
			info.func = TitanPanelQuests_SortByLocation;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "SortByLocation");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- sort by level
			info = {};
			info.text = TITAN_QUESTS_SORT_LEVEL_TEXT;
			info.func = TitanPanelQuests_SortByLevel;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "SortByLevel");
			--info.checked = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- sort by title
			info = {};
			info.text = TITAN_QUESTS_SORT_TITLE_TEXT;
			info.func = TitanPanelQuests_SortByTitle;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "SortByTitle");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		elseif ( UIDROPDOWNMENU_MENU_VALUE == "Show" ) then

			info = { };
			info.text = TITAN_QUESTS_SHOW_TEXT;
			info.isTitle = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- show just elite
			info = {};
			info.text = TITAN_QUESTS_SHOW_ELITE_TEXT;
			info.func = TitanPanelQuests_ShowElite;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowElite");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- show just dungeon
			info = {};
			info.text = TITAN_QUESTS_SHOW_DUNGEON_TEXT;
			info.func = TitanPanelQuests_ShowDungeon;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowDungeon");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- show just raid
			info = {};
			info.text = TITAN_QUESTS_SHOW_RAID_TEXT;
			info.func = TitanPanelQuests_ShowRaid;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowRaid");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			
			-- show just pvp
			info = {};
			info.text = TITAN_QUESTS_SHOW_PVP_TEXT;
			info.func = TitanPanelQuests_ShowPVP;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowPVP");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			
			-- show just regular
			info = {};
			info.text = TITAN_QUESTS_SHOW_REGULAR_TEXT;
			info.func = TitanPanelQuests_ShowRegular;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowRegular");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- show just completed
			info = {};
			info.text = TITAN_QUESTS_SHOW_COMPLETED_TEXT;
			info.func = TitanPanelQuests_ShowCompleted;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowCompleted");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- show only incomplete
			info = {};
			info.text = TITAN_QUESTS_SHOW_INCOMPLETE_TEXT;
			info.func = TitanPanelQuests_ShowIncomplete;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowIncomplete");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- show all
			info = {};
			info.text = TITAN_QUESTS_SHOW_ALL_TEXT;
			info.func = TitanPanelQuests_ShowAll;
			info.checked = TitanGetVar(TITAN_QUESTS_ID, "ShowAll");
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);


		elseif ( UIDROPDOWNMENU_MENU_VALUE == "Toggle" ) then

			info = { };
			info.text = TITAN_QUESTS_TOGGLE_TEXT;
			info.isTitle = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- toggle blizzard's questlog
			info = {};
			if ( QuestLogFrame:IsVisible() ) then
				info.text = TITAN_QUESTS_CLOSE_QUESTLOG_TEXT;
			else
				info.text = TITAN_QUESTS_OPEN_QUESTLOG_TEXT;
			end

			info.value = "OpenQuestLog";
			info.func = ToggleQuestLog;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- toggle MonkeyQuest
			if ( MonkeyQuestFrame ~= nil ) then
				info = {};
				if ( MonkeyQuestFrame:IsVisible() ) then
					info.text = TITAN_QUESTS_CLOSE_MONKEYQUEST_TEXT;
				else
					info.text = TITAN_QUESTS_OPEN_MONKEYQUEST_TEXT;
				end
				info.value = "OpenMonkeyQuest";
				info.func = TitanPanelQuests_ToggleMonkeyQuest;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

			-- toggle QuestIon
			if ( QuestIon_Frame ~= nil ) then
				info = {};
				if ( QuestIon_Frame:IsVisible() ) then
					info.text = TITAN_QUESTS_CLOSE_QUESTION_TEXT;
				else
					info.text = TITAN_QUESTS_OPEN_QUESTION_TEXT;
				end
				info.value = "OpenQuestIon";
				info.func = QuestIon_ToggleVisible;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

			-- toggle PartyQuests
			if ( PartyQuestsFrame ~= nil ) then
				info = {};
				if ( PartyQuestsFrame:IsVisible() ) then
					info.text = TITAN_QUESTS_CLOSE_PARTYQUESTS_TEXT;
				else
					info.text = TITAN_QUESTS_OPEN_PARTYQUESTS_TEXT;
				end
				info.value = "OpenPartyQuests";
				info.func = TogglePartyQuests;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

			-- toggle QuestHistory
 			if ( QuestHistoryFrame ~= nil ) then
				info = {};
				if ( QuestHistoryFrame:IsVisible() ) then
					info.text = TITAN_QUESTS_CLOSE_QUESTHISTORY_TEXT;
				else
					info.text = TITAN_QUESTS_OPEN_QUESTHISTORY_TEXT;
				end
				info.value = "OpenQuestHistory";
				info.func = QuestHistory_Toggle;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end	
	
			-- toggle QuestBank
			if (QuestBankFrame ~= nil ) then
				info = {};
				if ( QuestBankFrame:IsVisible() ) then
					info.text = TITAN_QUESTS_CLOSE_QUESTBANK_TEXT;
				else
					info.text = TITAN_QUESTS_OPEN_QUESTHISTORY_TEXT;
				end
				info.value = "OpenQuestBank";
				info.func = QuestBank_Toggle;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			-- end toggles	
		end
	end
end

--
-- Click on a Quest entry
--	
function TitanPanelQuests_ClickQuest()
	if ( (TitanGetVar(TITAN_QUESTS_ID, "ClickBehavior") and not IsShiftKeyDown()) or (not TitanGetVar(TITAN_QUESTS_ID, "ClickBehavior") and IsShiftKeyDown()) ) then
		TitanPanelQuests_ToggleWatchStatus()
	else
		TitanPanelQuests_DisplayQuest();
		this:GetParent():Hide();
	end
end

--
-- Toggle Watch Status
--	
function TitanPanelQuests_ToggleWatchStatus()
	local questID;
	local button;

	-- Get current Quest selected
	questID = this.value[2];

	-- Get the quest button
	for i=1, UIDROPDOWNMENU_MAXBUTTONS, 1 do
		button = getglobal("DropDownList1Button"..i);
		if ( type(button.value) == type(this.value) ) then
			if ( button.value[2] and this.value[2] == button.value[2] ) then
				break;
			else
				button = nil;
			end
		else
			button = nil;
		end
	end

	-- Add/Remove quest from Quest Tracker
	if ( IsQuestWatched(questID) ) then
		-- Update Quest Tracker
		RemoveQuestWatch(questID);
		QuestWatch_Update();
		-- Toggle Status
		TitanPanelRightClickMenu_ToggleVar(TITAN_QUESTS_ID, questID);
		-- Update watcher tag.
		button:SetText(TitanPanelQuests_GetQuestText(questID));
		-- Update the secondary pane
		getglobal("DropDownList2"):Hide();
		if ( this:GetParent():GetName() == "DropDownList2" ) then
			button.checked = nil;
			getglobal(button:GetName().."Check"):Hide();
			UIDropDownMenu_Refresh();
		end
	else
		if (TitanPanelQuests_IsWatchAllowed(questID)) then
			-- Update Quest Tracker
			AddQuestWatch(questID);
			QuestWatch_Update();
			-- Toggle Status
			TitanPanelRightClickMenu_ToggleVar(TITAN_QUESTS_ID, questID);
			-- Update watcher tag.
			button:SetText(TitanPanelQuests_GetQuestText(questID));
			-- Update the secondary pane
			getglobal("DropDownList2"):Hide();
			if ( this:GetParent():GetName() == "DropDownList2" ) then
				button.checked = 1;
				getglobal(button:GetName().."Check"):Show();
				UIDropDownMenu_Refresh();
			end
		else
			-- Prevent checkmark from showing up... pretty counter-intuitive, we need to set this to checked
			-- so that the later code in UIDropDownMenu.lua will uncheck it again. - Ryessa
			if ( this:GetParent():GetName() == "DropDownList1" ) then
				button.checked = 1;
			else
				button.checked = nil;
				getglobal(button:GetName().."Check"):Hide();
				this:GetParent():Hide();
				UIDropDownMenu_Refresh();
			end;
		end
	end
end

--
-- IsWatchAllowed
--	
function TitanPanelQuests_IsWatchAllowed(questID)
		if ( GetNumQuestLeaderBoards(questID) == 0 ) then
			-- Set an error that there are no objectives for the quest, so it may not be watched.
			UIErrorsFrame:AddMessage(QUEST_WATCH_NO_OBJECTIVES, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
			return false;
		end
		if ( GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS ) then
         		-- Set an error message if trying to show too many quests
                  UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
			return false;
           	end

		-- Retrieve the quest info for questID.
		local Title, Level, Tag, isHeader, isCollapsed, isComplete;
		Title, Level, Tag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questID);
		if ( isComplete ) then
			-- We can't watch a complete item.
			return false;
		end
		return true;
end
--
-- SortBy toggle functions
--	
function TitanPanelQuests_SortByLevel()
	if ( TitanGetVar(TITAN_QUESTS_ID, "SortByLevel") ) then
		TitanSetVar(TITAN_QUESTS_ID, "SortByLevel", nil);
		TitanSetVar(TITAN_QUESTS_ID, "SortByLocation", 1);
		TitanSetVar(TITAN_QUESTS_ID, "SortByTitle", nil);
	else
		TitanSetVar(TITAN_QUESTS_ID, "SortByLevel", 1);
		TitanSetVar(TITAN_QUESTS_ID, "SortByLocation", nil);
		TitanSetVar(TITAN_QUESTS_ID, "SortByTitle", nil);
	end
	DropDownList1:Hide();
end

function TitanPanelQuests_SortByLocation()
	TitanSetVar(TITAN_QUESTS_ID, "SortByLevel", nil);
	TitanSetVar(TITAN_QUESTS_ID, "SortByLocation", 1);
	TitanSetVar(TITAN_QUESTS_ID, "SortByTitle", nil);
	TitanPanelButton_UpdateButton(TITAN_QUESTS_ID)
	DropDownList1:Hide();
end

function TitanPanelQuests_SortByTitle()
	if ( TitanGetVar(TITAN_QUESTS_ID, "SortByTitle") ) then
		TitanSetVar(TITAN_QUESTS_ID, "SortByLevel", nil);
		TitanSetVar(TITAN_QUESTS_ID, "SortByLocation", 1);
		TitanSetVar(TITAN_QUESTS_ID, "SortByTitle", nil);
	else
		TitanSetVar(TITAN_QUESTS_ID, "SortByLevel", nil);
		TitanSetVar(TITAN_QUESTS_ID, "SortByLocation", nil);
		TitanSetVar(TITAN_QUESTS_ID, "SortByTitle", 1);
	end
	DropDownList1:Hide();
end

--
-- Show toggle functions
--
function TitanPanelQuests_ShowElite()
	if ( TitanGetVar(TITAN_QUESTS_ID, "ShowElite") ) then
		TitanSetVar(TITAN_QUESTS_ID, "ShowElite", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", 1);
	else
		TitanSetVar(TITAN_QUESTS_ID, "ShowElite", 1);
		TitanSetVar(TITAN_QUESTS_ID, "ShowDungeon", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRaid", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowPVP", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRegular", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowCompleted", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowIncomplete", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", nil);
	end
	DropDownList1:Hide();
end

function TitanPanelQuests_ShowDungeon()
	if ( TitanGetVar(TITAN_QUESTS_ID, "ShowDungeon") ) then
		TitanSetVar(TITAN_QUESTS_ID, "ShowDungeon", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", 1);
	else
		TitanSetVar(TITAN_QUESTS_ID, "ShowDungeon", 1);
		TitanSetVar(TITAN_QUESTS_ID, "ShowElite", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRaid", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowPVP", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRegular", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowCompleted", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowIncomplete", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", nil);
	end
	DropDownList1:Hide();
end

function TitanPanelQuests_ShowRaid()
	if ( TitanGetVar(TITAN_QUESTS_ID, "ShowRaid") ) then
		TitanSetVar(TITAN_QUESTS_ID, "ShowRaid", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", 1);
	else
		TitanSetVar(TITAN_QUESTS_ID, "ShowRaid", 1);
		TitanSetVar(TITAN_QUESTS_ID, "ShowElite", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowDungeon", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowPVP", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRegular", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowCompleted", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowIncomplete", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", nil);
	end
	DropDownList1:Hide();
end

function TitanPanelQuests_ShowPVP()
	if ( TitanGetVar(TITAN_QUESTS_ID, "ShowPVP") ) then
		TitanSetVar(TITAN_QUESTS_ID, "ShowPVP", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", 1);
	else
		TitanSetVar(TITAN_QUESTS_ID, "ShowPVP", 1);
		TitanSetVar(TITAN_QUESTS_ID, "ShowElite", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowDungeon", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRaid", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRegular", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowCompleted", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowIncomplete", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", nil);
	end
	DropDownList1:Hide();
end

function TitanPanelQuests_ShowRegular()
	if ( TitanGetVar(TITAN_QUESTS_ID, "ShowRegular") ) then
		TitanSetVar(TITAN_QUESTS_ID, "ShowRegular", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", 1);
	else
		TitanSetVar(TITAN_QUESTS_ID, "ShowRegular", 1);
		TitanSetVar(TITAN_QUESTS_ID, "ShowElite", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowDungeon", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRaid", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowPVP", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowCompleted", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowIncomplete", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", nil);
	end
	DropDownList1:Hide();
end

function TitanPanelQuests_ShowCompleted()
	if ( TitanGetVar(TITAN_QUESTS_ID, "ShowCompleted") ) then
		TitanSetVar(TITAN_QUESTS_ID, "ShowCompleted", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", 1);
	else
		TitanSetVar(TITAN_QUESTS_ID, "ShowCompleted", 1);
		TitanSetVar(TITAN_QUESTS_ID, "ShowIncomplete", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowElite", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowDungeon", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRaid", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowPVP", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRegular", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", nil);
	end
	DropDownList1:Hide();
end

function TitanPanelQuests_ShowIncomplete()
	if ( TitanGetVar(TITAN_QUESTS_ID, "ShowIncomplete") ) then
		TitanSetVar(TITAN_QUESTS_ID, "ShowIncomplete", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", 1);
	else
		TitanSetVar(TITAN_QUESTS_ID, "ShowIncomplete", 1);
		TitanSetVar(TITAN_QUESTS_ID, "ShowCompleted", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowElite", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowDungeon", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRaid", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowPVP", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowRegular", nil);
		TitanSetVar(TITAN_QUESTS_ID, "ShowAll", nil);
	end
	DropDownList1:Hide();
end

function TitanPanelQuests_ShowAll()
	TitanSetVar(TITAN_QUESTS_ID, "ShowAll", 1);
	TitanSetVar(TITAN_QUESTS_ID, "ShowElite", nil);
	TitanSetVar(TITAN_QUESTS_ID, "ShowDungeon", nil);
	TitanSetVar(TITAN_QUESTS_ID, "ShowRaid", nil);
	TitanSetVar(TITAN_QUESTS_ID, "ShowPVP", nil);
	TitanSetVar(TITAN_QUESTS_ID, "ShowRegular", nil);
	TitanSetVar(TITAN_QUESTS_ID, "ShowCompleted", nil);
	TitanSetVar(TITAN_QUESTS_ID, "ShowIncomplete", nil);
	DropDownList1:Hide();
end

--
-- Click Behavior toggle function
--
function TitanPanelQuests_ToggleClickBehavior()
	TitanToggleVar(TITAN_QUESTS_ID, "ClickBehavior");
end

--
-- Group Behavior toggle function
--
function TitanPanelQuests_ToggleGroupBehavior()
	TitanToggleVar(TITAN_QUESTS_ID, "GroupBehavior");
	TitanPanelRightClickMenu_Close();
end

--
-- build quest list (returns table of current active quests)
--
function TitanPanelQuests_BuildQuestList()

	local NumEntries, NumQuests;

	local Title, Level, Tag, isHeader, isCollapsed, isComplete;
	local questIndex;

	local Location;

	local useTag;
	local completeTag;
	local questWatched = "";
	local diff;

	local QuestList = { };

	NumEntries, NumQuests = GetNumQuestLogEntries();
	
	for questIndex=1, NumEntries do
		Title, Level, Tag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questIndex);

		if ( Level == 0 ) then
			Location = Title;
		else	
			local entry = { questID = questIndex, questTitle = Title, questLevel = Level, questTag = Tag, questisHeader = isHeader, questisComplete = isComplete, questLocation = Location };
			table.insert(QuestList, entry);
		end
	end	

	return QuestList;
end

--
-- debug
--
function TitanPanelQuests_DisplayTheList(thelist)
	local i = 0;
	for i=1, table.getn(thelist) do
		TitanPanelQuests_ChatPrint(i..":"..thelist[i].questLevel..":"..thelist[i].questTitle..":"..thelist[i].questLocation..":"..thelist[i].questID.."\n");
	end
end
	
--
-- display quest details window
--
function TitanPanelQuests_DisplayQuest()

	local questTitle, questLevel, questTag, questisHeader, questisCollapsed, questisComplete;
	local questDescription = "";
	local questObjectives = "";

	local diff, useTag, completeTag;

	local numObjectives = 0;

	local ObjectivesText = "";

    -- select the quest entry
    SelectQuestLogEntry(this.value[2]);
    QuestLog_SetSelection(this.value[2]);
	
	questDescription, questObjectives = GetQuestLogQuestText();

	questTitle, questLevel, questTag, questisHeader, questisCollapsed, questisComplete = GetQuestLogTitle(this.value[2]);	

	if ( questTag == ELITE ) then
		useTag = "+"
	elseif ( questTag == TITAN_QUESTS_DUNGEON ) then
		useTag = "d";
	elseif ( questTag == TITAN_QUESTS_RAID ) then
		useTag = "r";
	elseif ( questTag == TITAN_QUESTS_PVP ) then
		useTag = "p";
	else
		useTag = "";
	end 

	if ( questisComplete ) then
		useTag = "C";
		completeTag = "("..COMPLETE..")";
	else 
		completeTag = "";
	end

	diff = GetDifficultyColor(questLevel);

        -- find location
	local qid = 0;

	local questLocation = "";

	qid = this.value[2] - 1;

	for k = qid, 1, -1 do
		local qtitle, qlevel, qtag, qisheader, qiscollapsed, qiscomplete = GetQuestLogTitle(k);
		if ( qlevel == 0 ) then
			questLocation = qtitle;
			break;
		end
	end			
	-- end find location

	-- set title
	local newquestTitle = TitanUtils_GetColoredText("["..questLevel..useTag.."]",diff)..TitanUtils_GetHighlightText(questTitle);
	TitanQuests_Details_Title:SetText(newquestTitle);

	if ( IsCurrentQuestFailed() ) then
                questTitle = questTitle.." - ("..TEXT(FAILED)..")";
        end

	TitanQuests_Details_ScrollChild_QuestTitle:SetText(questTitle);

	-- add location to objectives
	local newquestObjectives = LOCATION_COLON.." "..questLocation.."\n\n"..questObjectives;
	TitanQuests_Details_ScrollChild_ObjectivesText:SetText(newquestObjectives);
	
	-- display quest timer 
        local questTimer = GetQuestLogTimeLeft();
        if ( questTimer ) then
                TitanQuests_Details.hasTimer = 1;
                TitanQuests_Details.timePassed = 0;
                TitanQuests_Details_ScrollChild_TimerText:Show();
                TitanQuests_Details_ScrollChild_TimerText:SetText(TEXT(TIME_REMAINING).." "..SecondsToTime(questTimer));
                TitanQuests_Details_ScrollChild_Objective1:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_TimerText", "BOTTOMLEFT", 0, -10);
        else
                TitanQuests_Details.hasTimer = nil;
                TitanQuests_Details_ScrollChild_TimerText:Hide();
                TitanQuests_Details_ScrollChild_Objective1:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_ObjectivesText", "BOTTOMLEFT", 0, -10);
        end

	-- display objectives
	numObjectives = GetNumQuestLeaderBoards();

	for i=1, numObjectives, 1 do
                local string = getglobal("TitanQuests_Details_ScrollChild_Objective"..i);
                local text;
                local type;
                local finished;
                text, type, finished = GetQuestLogLeaderBoard(i);
                if ( not text or strlen(text) == 0 ) then
                        text = type;
                end
                if ( finished ) then
                        string:SetTextColor(0.2, 0.2, 0.2);
                        text = text.." ("..TEXT(COMPLETE)..")";
                else
                        string:SetTextColor(0, 0, 0);
                end
                string:SetText(text);
                string:Show();
                QuestFrame_SetAsLastShown(string,TitanQuests_Details_ScrollChild_SpacerFrame);
        end

	for i=numObjectives + 1, MAX_OBJECTIVES, 1 do
                getglobal("TitanQuests_Details_ScrollChild_Objective"..i):Hide();
        end

	-- If there's money required then anchor and display it
	if ( GetQuestLogRequiredMoney() > 0 ) then
		if ( numObjectives > 0 ) then
			TitanQuests_Details_ScrollChild_RequiredMoneyText:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_Objective"..numObjectives, "BOTTOMLEFT", 0, -4);
		else
			TitanQuests_Details_ScrollChild_RequiredMoneyText:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_ObjectivesText", "BOTTOMLEFT", 0, -10);
		end
		
		MoneyFrame_Update("TitanQuests_Details_ScrollChild_RequiredMoneyFrame", GetQuestLogRequiredMoney());
		
		if ( GetQuestLogRequiredMoney() > GetMoney() ) then
			-- Not enough money
			TitanQuests_Details_ScrollChild_RequiredMoneyText:SetTextColor(0, 0, 0);
			SetMoneyFrameColor("UberQuest_Details_ScrollChild_RequiredMoneyFrame", 1.0, 0.1, 0.1);
		else
			TitanQuests_Details_ScrollChild_RequiredMoneyText:SetTextColor(0.2, 0.2, 0.2);
			SetMoneyFrameColor("UberQuest_Details_ScrollChild_RequiredMoneyFrame", 1.0, 1.0, 1.0);
		end
		TitanQuests_Details_ScrollChild_RequiredMoneyText:Show();
		TitanQuests_Details_ScrollChild_RequiredMoneyFrame:Show();
	else
		TitanQuests_Details_ScrollChild_RequiredMoneyText:Hide();
		TitanQuests_Details_ScrollChild_RequiredMoneyFrame:Hide();
	end
	
	if ( GetQuestLogRequiredMoney() > 0 ) then
                TitanQuests_Details_ScrollChild_DescriptionTitle:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_RequiredMoneyText", "BOTTOMLEFT", 0, -10);
        elseif ( numObjectives > 0 ) then
                TitanQuests_Details_ScrollChild_DescriptionTitle:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_Objective"..numObjectives, "BOTTOMLEFT", 0, -10);
        else
                if ( questTimer ) then
                        TitanQuests_Details_ScrollChild_DescriptionTitle:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_TimerText", "BOTTOMLEFT", 0, -10);
                else
                        TitanQuests_Details_ScrollChild_DescriptionTitle:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_ObjectivesText", "BOTTOMLEFT", 0, -10);
                end
        end

	if ( questDescription ) then
                TitanQuests_Details_ScrollChild_QuestDescription:SetText(questDescription);
                QuestFrame_SetAsLastShown(TitanQuests_Details_ScrollChild_QuestDescription,TitanQuests_Details_ScrollChild_SpacerFrame);
        end

	local numRewards = GetNumQuestLogRewards();
        local numChoices = GetNumQuestLogChoices();
        local money = GetQuestLogRewardMoney();

        if ( (numRewards + numChoices + money) > 0 ) then
                TitanQuests_Details_ScrollChild_RewardTitleText:Show();
                QuestFrame_SetAsLastShown(TitanQuests_Details_ScrollChild_RewardTitleText,TitanQuests_Details_ScrollChild_SpacerFrame);
        else
                TitanQuests_Details_ScrollChild_RewardTitleText:Hide();
        end

        TitanQuests_Items_Update("TitanQuests_Details_ScrollChild_");
        TitanQuests_Details_ScrollScrollBar:SetValue(0);
        TitanQuests_Details_Scroll:UpdateScrollChildRect();

	TitanQuests_Details_AbandonButton:SetText(ABANDON_QUEST);
	
	if ( GetQuestLogPushable() ) then
		TitanQuests_Details_ShareButton:Enable();
		TitanQuests_Details_ShareButton:SetText(TITAN_QUESTS_DETAILS_SHARE_BUTTON_TEXT);
	else
		TitanQuests_Details_ShareButton:Disable();
		TitanQuests_Details_ShareButton:SetText(TITAN_QUESTS_DETAILS_SHARE_BUTTON_TEXT);
	end

	-- Corgi: ATTN
	if ( GetNumQuestLeaderBoards(this.value[2]) > 0)  then
		if ( IsQuestWatched(this.value[2]) ) then
			TitanQuests_Details_WatchButton:Disable();
			
		elseif ( GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS ) then
			TitanQuests_Details_WatchButton:Disable();
			
		else
			TitanQuests_Details_WatchButton:Enable();
			
		end
		
		TitanQuests_Details_WatchButton:SetText(TITAN_QUESTS_DETAILS_WATCH_BUTTON_TEXT);
	else
		TitanQuests_Details_WatchButton:Disable();
		TitanQuests_Details_WatchButton:SetText(TITAN_QUESTS_DETAILS_WATCH_BUTTON_TEXT);
	end
	-- Corgi: end ATTN

	TitanQuests_Details_CloseButton2:SetText(EXIT);

	-- Corgi: temp disable of abandon, share, watch buttons
	TitanQuests_Details_AbandonButton:Hide();
	TitanQuests_Details_ShareButton:Hide();
	TitanQuests_Details_WatchButton:Hide();
	TitanQuests_Details_CloseButton2:Hide();
	-- Corgi: end temp disable

        TitanQuests_Details:Show();

end

function TitanQuests_Items_Update(questState)
	local isQuestLog = 0;
	if ( questState == "TitanQuests_Details_ScrollChild_" ) then -- that's one change
		isQuestLog = 1;
	end
	local numQuestRewards;
	local numQuestChoices;
	local numQuestSpellRewards = 0;
	local money;
	local spacerFrame;
	if ( isQuestLog == 1 ) then
		numQuestRewards = GetNumQuestLogRewards();
		numQuestChoices = GetNumQuestLogChoices();
		if ( GetQuestLogRewardSpell() ) then
			numQuestSpellRewards = 1;
		end
		money = GetQuestLogRewardMoney();
		spacerFrame = TitanQuests_Details_ScrollChild_SpacerFrame; -- that's two!
		-- All this crap copied for TWO changes.
	else
		numQuestRewards = GetNumQuestRewards();
		numQuestChoices = GetNumQuestChoices();
		if ( GetRewardSpell() ) then
			numQuestSpellRewards = 1;
		end
		money = GetRewardMoney();
		spacerFrame = QuestSpacerFrame;
	end

	local totalRewards = numQuestRewards + numQuestChoices + numQuestSpellRewards;
	local questItemName = questState.."Item";
	local material = QuestFrame_GetMaterial();
	local  questItemReceiveText = getglobal(questState.."ItemReceiveText")
	if ( totalRewards == 0 and money == 0 ) then
		getglobal(questState.."RewardTitleText"):Hide();
	else
		getglobal(questState.."RewardTitleText"):Show();
		QuestFrame_SetTitleTextColor(getglobal(questState.."RewardTitleText"), material);
		QuestFrame_SetAsLastShown(getglobal(questState.."RewardTitleText"), spacerFrame);
	end
	if ( money == 0 ) then
		getglobal(questState.."MoneyFrame"):Hide();
	else
		getglobal(questState.."MoneyFrame"):Show();
		QuestFrame_SetAsLastShown(getglobal(questState.."MoneyFrame"), spacerFrame);
		MoneyFrame_Update(questState.."MoneyFrame", money);
	end
	
	for i=totalRewards + 1, MAX_NUM_ITEMS, 1 do
		getglobal(questItemName..i):Hide();
	end
	local questItem, name, texture, quality, isUsable, numItems = 1;
	if ( numQuestChoices > 0 ) then
		getglobal(questState.."ItemChooseText"):Show();
		QuestFrame_SetTextColor(getglobal(questState.."ItemChooseText"), material);
		QuestFrame_SetAsLastShown(getglobal(questState.."ItemChooseText"), spacerFrame);
		for i=1, numQuestChoices, 1 do	
			questItem = getglobal(questItemName..i);
			questItem.type = "choice";
			numItems = 1;
			if ( isQuestLog == 1 ) then
				name, texture, numItems, quality, isUsable = GetQuestLogChoiceInfo(i);
			else
				name, texture, numItems, quality, isUsable = GetQuestItemInfo(questItem.type, i);
			end
			questItem:SetID(i)
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "item"
			QuestFrame_SetAsLastShown(questItem, spacerFrame);
			getglobal(questItemName..i.."Name"):SetText(name);
			SetItemButtonCount(questItem, numItems);
			SetItemButtonTexture(questItem, texture);
			if ( isUsable ) then
				SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
			else
				SetItemButtonTextureVertexColor(questItem, 0.9, 0, 0);
				SetItemButtonNameFrameVertexColor(questItem, 0.9, 0, 0);
			end
			if ( i > 1 ) then
				if ( mod(i,2) == 1 ) then
					questItem:SetPoint("TOPLEFT", questItemName..(i - 2), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..(i - 1), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questState.."ItemChooseText", "BOTTOMLEFT", -3, -5);
			end
			
		end
	else
		getglobal(questState.."ItemChooseText"):Hide();
	end
	local rewardsCount = 0;
	if ( numQuestRewards > 0 or money > 0 or numQuestSpellRewards > 0) then
		QuestFrame_SetTextColor(questItemReceiveText, material);
		-- Anchor the reward text differently if there are choosable rewards
		if ( numQuestChoices > 0  ) then
			questItemReceiveText:SetText(TEXT(REWARD_ITEMS));
			local index = numQuestChoices;
			if ( mod(index, 2) == 0 ) then
				index = index - 1;
			end
			questItemReceiveText:SetPoint("TOPLEFT", questItemName..index, "BOTTOMLEFT", 3, -5);
		else 
			questItemReceiveText:SetText(TEXT(REWARD_ITEMS_ONLY));
			questItemReceiveText:SetPoint("TOPLEFT", questState.."RewardTitleText", "BOTTOMLEFT", 3, -5);
		end
		questItemReceiveText:Show();
		QuestFrame_SetAsLastShown(questItemReceiveText, spacerFrame);
		-- Setup mandatory rewards
		for i=1, numQuestRewards, 1 do
			questItem = getglobal(questItemName..(i + numQuestChoices));
			questItem.type = "reward";
			numItems = 1;
			if ( isQuestLog == 1 ) then
				name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i);
			else
				name, texture, numItems, quality, isUsable = GetQuestItemInfo(questItem.type, i);
			end
			questItem:SetID(i)
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "item";
			QuestFrame_SetAsLastShown(questItem, spacerFrame);
			getglobal(questItemName..(i + numQuestChoices).."Name"):SetText(name);
			SetItemButtonCount(questItem, numItems);
			SetItemButtonTexture(questItem, texture);
			if ( isUsable ) then
				SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
			else
				SetItemButtonTextureVertexColor(questItem, 0.5, 0, 0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 0, 0);
			end
			
			if ( i > 1 ) then
				if ( mod(i,2) == 1 ) then
					questItem:SetPoint("TOPLEFT", questItemName..((i + numQuestChoices) - 2), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..((i + numQuestChoices) - 1), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questState.."ItemReceiveText", "BOTTOMLEFT", -3, -5);
			end
			rewardsCount = rewardsCount + 1;
		end
		-- Setup spell reward
		if ( numQuestSpellRewards > 0 ) then
			if ( isQuestLog == 1 ) then
				texture, name = GetQuestLogRewardSpell();
			else
				texture, name = GetRewardSpell();
			end
			questItem = getglobal(questItemName..(rewardsCount + numQuestChoices + 1));
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "spell";
			SetItemButtonCount(questItem, 0);
			SetItemButtonTexture(questItem, texture);
			getglobal(questItemName..(rewardsCount + numQuestChoices + 1).."Name"):SetText(name);
			if ( rewardsCount > 0 ) then
				if ( mod(rewardsCount,2) == 0 ) then
					questItem:SetPoint("TOPLEFT", questItemName..((rewardsCount + numQuestChoices) - 1), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..((rewardsCount + numQuestChoices)), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questState.."ItemReceiveText", "BOTTOMLEFT", -3, -5);
			end
		end
	else	
		questItemReceiveText:Hide();
	end
	if ( questState == "QuestReward" ) then
		QuestFrameCompleteQuestButton:Enable();
		QuestFrameRewardPanel.itemChoice = 0;
		QuestRewardItemHighlight:Hide();
	end
end

function TitanQuests_Details_Update()
	local questID = GetQuestLogSelection();
	local questTitle = GetQuestLogTitle(questID);
	if ( not questTitle ) then
		questTitle = "";
	end
	if ( IsCurrentQuestFailed() ) then
		questTitle = questTitle.." - ("..TEXT(FAILED)..")";
	end
	TitanQuests_Details_ScrollChild_QuestTitle:SetText(questTitle);

	local questDescription;
	local questObjectives;
	questDescription, questObjectives = GetQuestLogQuestText();
	TitanQuests_Details_ScrollChild_ObjectivesText:SetText(questObjectives);

	
	questTitle, questLevel, questTag, questisHeader, questisCollapsed, questisComplete = GetQuestLogTitle(questID);

	if ( questTag == ELITE ) then
		useTag = "+"
	elseif ( questTag == TITAN_QUESTS_DUNGEON ) then
		useTag = "d";
	elseif ( questTag == TITAN_QUESTS_RAID ) then
		useTag = "r";
	elseif ( questTag == TITAN_QUESTS_PVP ) then
		useTag = "p";
	else
		useTag = "";
	end 

	if ( questisComplete ) then
		--useTag = "C";
		completeTag = "("..COMPLETE..")";
	else 
		completeTag = "";
	end

	diff = GetDifficultyColor(questLevel);

        -- find location
	local qid = 0;

	local questLocation = "";

	qid = questID - 1;

	for k = qid, 1, -1 do
		local qtitle, qlevel, qtag, qisheader, qiscollapsed, qiscomplete = GetQuestLogTitle(k);
		if ( qlevel == 0 ) then
			questLocation = qtitle;
			break;
		end
	end			
	-- end find location

	local newquestTitle = TitanUtils_GetColoredText("["..questLevel..useTag.."]",diff)..TitanUtils_GetHighlightText(questTitle);

	TitanQuests_Details_Title:SetText(newquestTitle);

	if ( IsCurrentQuestFailed() ) then
                questTitle = questTitle.." - ("..TEXT(FAILED)..")";
        end
	TitanQuests_Details_ScrollChild_QuestTitle:SetText(questTitle);

	local newquestObjectives = LOCATION_COLON.." "..questLocation.."\n\n"..questObjectives;
	TitanQuests_Details_ScrollChild_ObjectivesText:SetText(newquestObjectives);

	local questTimer = GetQuestLogTimeLeft();
	if ( questTimer ) then
		TitanQuests_Details.hasTimer = 1;
		TitanQuests_Details.timePassed = 0;
		TitanQuests_Details_ScrollChild_TimerText:Show();
		TitanQuests_Details_ScrollChild_TimerText:SetText(TEXT(TIME_REMAINING).." "..SecondsToTime(questTimer));
		TitanQuests_Details_ScrollChild_Objective1:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_TimerText", "BOTTOMLEFT", 0, -10);
	else
		TitanQuests_Details.hasTimer = nil;
		TitanQuests_Details_ScrollChild_TimerText:Hide();
		TitanQuests_Details_ScrollChild_Objective1:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_ObjectivesText", "BOTTOMLEFT", 0, -10);
	end
	
	local numObjectives = GetNumQuestLeaderBoards();
	for i=1, numObjectives, 1 do
		local string = getglobal("TitanQuests_Details_ScrollChild_Objective"..i);
		local text;
		local type;
		local finished;
		text, type, finished = GetQuestLogLeaderBoard(i);
		if ( not text or strlen(text) == 0 ) then
			text = type;
		end
		if ( finished ) then
			string:SetTextColor(0.2, 0.2, 0.2);
			text = text.." ("..TEXT(COMPLETE)..")";
		else
			string:SetTextColor(0, 0, 0);
		end
		string:SetText(text);
		string:Show();
		QuestFrame_SetAsLastShown(string,TitanQuests_Details_ScrollChild_SpacerFrame);
	end

	for i=numObjectives + 1, MAX_OBJECTIVES, 1 do
		getglobal("TitanQuests_Details_ScrollChild_Objective"..i):Hide();
	end
	
	-- If there's money required then anchor and display it
	if ( GetQuestLogRequiredMoney() > 0 ) then
		if ( numObjectives > 0 ) then
			TitanQuests_Details_ScrollChild_RequiredMoneyText:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_Objective"..numObjectives, "BOTTOMLEFT", 0, -4);
		else
			TitanQuests_Details_ScrollChild_RequiredMoneyText:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_ObjectivesText", "BOTTOMLEFT", 0, -10);
		end
		
		MoneyFrame_Update("TitanQuests_Details_ScrollChild_RequiredMoneyFrame", GetQuestLogRequiredMoney());
		
		if ( GetQuestLogRequiredMoney() > GetMoney() ) then
			-- Not enough money
			TitanQuests_Details_ScrollChild_RequiredMoneyText:SetTextColor(0, 0, 0);
			SetMoneyFrameColor("TitanQuests_Details_ScrollChild_RequiredMoneyFrame", 1.0, 0.1, 0.1);
		else
			TitanQuests_Details_ScrollChild_RequiredMoneyText:SetTextColor(0.2, 0.2, 0.2);
			SetMoneyFrameColor("TitanQuests_Details_ScrollChild_RequiredMoneyFrame", 1.0, 1.0, 1.0);
		end
		TitanQuests_Details_ScrollChild_RequiredMoneyText:Show();
		TitanQuests_Details_ScrollChild_RequiredMoneyFrame:Show();
	else
		TitanQuests_Details_ScrollChild_RequiredMoneyText:Hide();
		TitanQuests_Details_ScrollChild_RequiredMoneyFrame:Hide();
	end

	if ( GetQuestLogRequiredMoney() > 0 ) then
		TitanQuests_Details_ScrollChild_DescriptionTitle:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_RequiredMoneyText", "BOTTOMLEFT", 0, -10);
	elseif ( numObjectives > 0 ) then
		TitanQuests_Details_ScrollChild_DescriptionTitle:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_Objective"..numObjectives, "BOTTOMLEFT", 0, -10);
	else
		if ( questTimer ) then
			TitanQuests_Details_ScrollChild_DescriptionTitle:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_TimerText", "BOTTOMLEFT", 0, -10);
		else
			TitanQuests_Details_ScrollChild_DescriptionTitle:SetPoint("TOPLEFT", "TitanQuests_Details_ScrollChild_ObjectivesText", "BOTTOMLEFT", 0, -10);
		end
	end
	if ( questDescription ) then
		TitanQuests_Details_ScrollChild_QuestDescription:SetText(questDescription);
		 QuestFrame_SetAsLastShown(TitanQuests_Details_ScrollChild_QuestDescription,TitanQuests_Details_ScrollChild_SpacerFrame);
	end
	local numRewards = GetNumQuestLogRewards();
	local numChoices = GetNumQuestLogChoices();
	local money = GetQuestLogRewardMoney();

	if ( (numRewards + numChoices + money) > 0 ) then
		TitanQuests_Details_ScrollChild_RewardTitleText:Show();
		QuestFrame_SetAsLastShown(TitanQuests_Details_ScrollChild_RewardTitleText,TitanQuests_Details_ScrollChild_SpacerFrame);
	else
		TitanQuests_Details_ScrollChild_RewardTitleText:Hide();
	end

	TitanQuests_Items_Update("TitanQuests_Details_ScrollChild_");
	TitanQuests_Details_ScrollScrollBar:SetValue(0);
	TitanQuests_Details_Scroll:UpdateScrollChildRect();

	if ( GetNumQuestLeaderBoards(questID) > 0)  then
		if ( IsQuestWatched(questID) ) then
			TitanQuests_Details_WatchButton:Disable();
			
		elseif ( GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS ) then
			TitanQuests_Details_WatchButton:Disable();
			
		else
			TitanQuests_Details_WatchButton:Enable();
			
		end
		
		TitanQuests_Details_WatchButton:SetText(TITAN_QUESTS_DETAILS_WATCH_BUTTON_TEXT);
	else
		TitanQuests_Details_WatchButton:Disable();
		TitanQuests_Details_WatchButton:SetText(TITAN_QUESTS_DETAILS_WATCH_BUTTON_TEXT);
	end

	-- Corgi: temp disable of abandon, share, watch buttons
	TitanQuests_Details_AbandonButton:Hide();
	TitanQuests_Details_ShareButton:Hide();
	TitanQuests_Details_WatchButton:Hide();
	TitanQuests_Details_CloseButton2:Hide();
	-- Corgi: end temp disable
end

--
-- toggle quest details window
--
function TitanQuests_DetailsShowHide() 
        if ( TitanQuests_Details:IsVisible() ) then
                TitanQuests_Details:Hide();
        else
                TitanQuests_Details:Show();
                TitanQuests_Details_Update();
				TitanPanelQuests_DisplayQuest();
        end
end

--
-- toggle MonkeyQuest
--
function TitanPanelQuests_ToggleMonkeyQuest()
	if ( MonkeyQuestFrame:IsVisible() ) then
		HideUIPanel(MonkeyQuestFrame);
	else
		ShowUIPanel(MonkeyQuestFrame);
	end
end

--
-- blue text
--
function TitanPanelQuests_BlueText(text)
	if (text) then
		local redColorCode = format("%02x", 0);		
		local greenColorCode = format("%02x", 0);
		local blueColorCode = format("%02x", 255);		
		local colorCode = "|cff"..redColorCode..greenColorCode..blueColorCode;
		return colorCode..text..FONT_COLOR_CODE_CLOSE;
	end
end

--
-- debug
--
function TitanPanelQuests_ChatPrint(msg)
        DEFAULT_CHAT_FRAME:AddMessage(msg);
end