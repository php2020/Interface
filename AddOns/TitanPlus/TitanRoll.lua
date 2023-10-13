----
--	TitanPanel[Roll]
----
--[[

	author: QuippeR

	many thanks for code from:
			LootHog by Chompers
			ToggleMe by Taii

description:

This Titan Panel plugin catches dice rolls from the chat system. It displays the last roll 
(performers name and roll value) in Titan Panel, and hovering the plugin brings up a list 
of the latest catched rolls.
Dice rolls with the range of 1-100 are displayed in green, others in red with the minimum 
and maximum of the roll after the actual value.
Clicking on the text displayed performs a roll.

]]--


TITAN_ROLL_ID = "Roll"

TITANROLL_TIMEOUTS = { 10, 20, 30, 60, 120, 180, -1};

function TitanPanelRollButton_OnLoad()
	this.registry = {
		id = TITAN_ROLL_ID,
		builtIn_o = 1,
		menuText = TITANROLL_MENUTEXT,
		buttonTextFunction = "TitanPanelRollButton_GetButtonText",
		tooltipTitle = TITANROLL_TOOLTIP,
		tooltipTextFunction = "TitanPanelRollButton_GetTooltipText",
		icon = "Interface\\PvPRankBadges\\PvPRank10",
		iconWidth = 16,
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			ShowWinner = 1,
			ReplaceBadRolls = 1,
			SortList = 0,
			HighlightParty = 0,
			PerformedRoll = "1-100",
			ListLength = 10,
			Timeout = 20,
		}
	};

	this:RegisterEvent("CHAT_MSG_SYSTEM");

	TitanRolls = {};
	TimedOut = 0;

end

function TitanPanelRollButton_OnClick(button)
	local i;
	if (( button == "LeftButton" ) and IsShiftKeyDown()) then
		TitanPanelRollButton_ResetSession();
	elseif (( button == "LeftButton" ) and IsAltKeyDown()) then
		if (TitanRollsCount) then
			for i = 1, TitanRollsCount do
				TitanRolls[i] = TitanRolls[i+1];
			end
			TitanRollsCount = TitanRollsCount - 1;
			if (TimedOut ~= 0) then
				TimedOut = TimedOut - 1;
			end
			if (TitanRollsCount == 0) then
				TitanRollsCount = nil;
			end
		TitanPanelButton_UpdateButton(TITAN_ROLL_ID);
		end
	elseif ( button ==  "LeftButton" ) then
		TitanRoll_EditBox:SetText("/rnd "..TitanGetVar(TITAN_ROLL_ID, "PerformedRoll"));
		ChatEdit_SendText(TitanRoll_EditBox);
	end
end


-- Special thanks to LootHog author Chompers !

function TitanPanelRollButton_OnEvent()
	local msg = arg1;
	local pattern = TITANROLL_SEARCHPATTERN;
	local player, roll, min_roll, max_roll, report;
	_, _, player, roll, min_roll, max_roll = string.find(msg, pattern);
	if (player) then
		TitanPanelRollButton_ProcessRoll(player, roll, min_roll, max_roll);
	end
end

function TitanPanelRollButton_ProcessRoll(player, roll, min_roll, max_roll)
	local rollOK = true;
	local deleted = 0;
	local rolltime = GetTime();
	min_roll = tonumber(min_roll);
	max_roll = tonumber(max_roll);
	roll = tonumber(roll);
	_, _, rolltime, _ = string.find(rolltime, "(%d+).(%d+)");
	rolltime = tonumber(rolltime);
	if (min_roll ~=1) or (max_roll~=100) then
		rollOK = false;
	end
	if (TitanRollsCount) then
		if (TitanGetVar(TITAN_ROLL_ID, "ReplaceBadRolls")) then
			for i = 1, TitanRollsCount do
				if ((TitanRolls[i-deleted].name == player) and (not (TitanRolls[i-deleted].onetohundred)) and rollOK) then
					for j = i-deleted, TitanRollsCount do
						TitanRolls[j] = TitanRolls[j+1];
					end
					TitanRollsCount = TitanRollsCount - 1;
					if (TimedOut >= (i-deleted)) then
						TimedOut = TimedOut - 1;
					end
					deleted = deleted + 1;
				end
			end
		end
		for i = TitanRollsCount, 1, -1 do
			TitanRolls[i+1] = TitanRolls[i];
		end
		if (TitanRollsCount < TitanGetVar(TITAN_ROLL_ID, "ListLength")) then
			TitanRollsCount = TitanRollsCount + 1;
		end
		if (TimedOut < TitanGetVar(TITAN_ROLL_ID, "ListLength")) then
			TimedOut = TimedOut + 1;
		end
	else
		TitanRollsCount = 1;
		TimedOut = 1;
	end
	if (rollOK) then
		TitanRolls[1] = {name = player,
				 rolled = roll,
				 onetohundred = rollOK,
				 since = rolltime};
	else
		TitanRolls[1] = {name = player,
				 rolled = roll,
				 onetohundred = rollOK,
				 since = rolltime,
				 base = min_roll,
				 top = max_roll};
	end
	TitanPanelButton_UpdateButton(TITAN_ROLL_ID);
	TitanPanelButton_SetTooltip(TITAN_ROLL_ID);

end

function TitanPanelRollButton_OnUpdate()
	local secNow;
	if (TimedOut > 0) and (TitanGetVar(TITAN_ROLL_ID, "Timeout") > 0) then
		secNow = GetTime();
		_, _, secNow, _ = string.find(secNow, "(%d+).(%d+)");
		if ((secNow - TitanRolls[TimedOut].since) > TitanGetVar(TITAN_ROLL_ID, "Timeout")) then
			TimedOut = TimedOut - 1;
			TitanPanelButton_UpdateButton(TITAN_ROLL_ID);
			TitanPanelButton_UpdateTooltip();
		end
	elseif (TitanGetVar(TITAN_ROLL_ID, "Timeout") == -1) then
		TimedOut = TitanRollsCount or 0;
		TitanPanelButton_UpdateButton(TITAN_ROLL_ID);
		TitanPanelButton_UpdateTooltip();
	else
		-- I don't want it to be negative no way
		TimedOut = 0;
	end
end


function TitanPanelRollButton_GetButtonText()
	local buttonText = "";
	local max = -1;
	local maxloc = 0;
	local i;
	local hasBadRoll = false;

	if (TitanRollsCount) then
		if not (TitanGetVar(TITAN_ROLL_ID, "ShowWinner")) then
			buttonText = buttonText..TitanRolls[1].name.." ";
			if (TitanRolls[1].onetohundred) then
				buttonText = buttonText..TitanUtils_GetGreenText(TitanRolls[1].rolled);
			else
				buttonText = buttonText..TitanUtils_GetRedText(TitanRolls[1].rolled);
			end
		else
			for i = 1, TitanRollsCount do
				if (TitanRolls[i].rolled > max) and (i <= TimedOut) then
					max = tonumber(TitanRolls[i].rolled);
					maxloc = i;
				end
				if not (TitanRolls[i].onetohundred) and (i <= TimedOut) then
					hasBadRoll = true;
				end
			end
			if (maxloc > 0) then
				if hasBadRoll then
					buttonText = buttonText..TitanUtils_GetRedText(TitanRolls[maxloc].name.." ");
				else
					buttonText = buttonText..TitanRolls[maxloc].name.." ";
				end
				if (TitanRolls[maxloc].onetohundred) then
					buttonText = buttonText..TitanUtils_GetGreenText(TitanRolls[maxloc].rolled);
				else
					buttonText = buttonText..TitanUtils_GetRedText(TitanRolls[maxloc].rolled)
				end
			else
				buttonText = "-";
			end
		end
	else
		buttonText = buttonText.."-";
	end
	if not (TitanGetVar(TITAN_ROLL_ID, "ShowWinner")) then
		return TITANROLL_LABELTEXT, buttonText;
	else
		return TITANROLL_LABELWINNER, buttonText;
	end
end

function TitanPanelRollButton_GetTooltipText()
	local tooltipText = "";
	local i, j, k;
	local sortedList = {};
	if (TitanRollsCount) then
		if (TitanGetVar(TITAN_ROLL_ID, "SortList")) then
			for i = 1, TitanRollsCount do
				if (sortedList) then
					if (i <= TimedOut) then
						j = 1;
						while (j<i) and (sortedList[j].rolled > TitanRolls[i].rolled) do
							j = j + 1;
						end
						for k = i-1, j, -1 do
							sortedList[k+1] = sortedList[k];
						end
						sortedList[j] = TitanRolls[i];
					else
						sortedList[i] = TitanRolls[i];
					end
				else
					sortedList[i] = TitanRolls[i];
				end
			end
			tooltipText = TitanPanelRollButton_PrintTooltipText(sortedList)
		else
			tooltipText = TitanPanelRollButton_PrintTooltipText(TitanRolls)
		end
	else
		tooltipText = tooltipText..TitanUtils_GetNormalText(TITANROLL_NOROLL).."\n";
	end
	tooltipText = tooltipText..TitanUtils_GetGreenText(TITANROLL_HINT);
	return tooltipText;
end

function UnitInPartyByName(name)
	if (UnitName("player") == name) or (UnitName("party1") == name) or 
			(UnitName("party2") == name) or (UnitName("party3") == name) or (UnitName("party4") == name) then
		return true;
	else
		return false;
	end
end

function TitanPanelRollButton_PrintTooltipText(array)
	local i;
	local tooltipText = "";
	for i = 1, TitanRollsCount do
		if (i <= TimedOut) then
			if (UnitInPartyByName(array[i].name) and TitanGetVar(TITAN_ROLL_ID, "HighlightParty")) then
				tooltipText = tooltipText..TitanUtils_GetHighlightText(array[i].name).."\t";
			else
				tooltipText = tooltipText..TitanUtils_GetGreenText(array[i].name).."\t";
			end
		else
			tooltipText = tooltipText..array[i].name.."\t";
		end
		if (i <= TimedOut) then
			if (array[i].onetohundred) then
				if (UnitInPartyByName(array[i].name) and TitanGetVar(TITAN_ROLL_ID, "HighlightParty")) then
					tooltipText = tooltipText..TitanUtils_GetHighlightText(array[i].rolled).."\n";
				else
					tooltipText = tooltipText..TitanUtils_GetGreenText(array[i].rolled).."\n";
				end
			else
				tooltipText = tooltipText..TitanUtils_GetRedText(array[i].rolled.." ("..array[i].base.."-"..array[i].top..")").."\n";
			end
		else
			if (array[i].onetohundred) then
					tooltipText = tooltipText..array[i].rolled.."\n";
			else
					tooltipText = tooltipText..array[i].rolled.." ("..array[i].base.."-"..array[i].top..")\n";		
			end
		end
	end
	return tooltipText;
end

function TitanPanelRollButton_ResetSession()
	TitanRollsCount = nil;
	TitanRolls = {};
	TimedOut = 0;
	TitanPanelButton_UpdateButton(TITAN_ROLL_ID);
end

function TitanPanelRollButton_ChangeAction()
	StaticPopupDialogs["TITANROLL_CHANGEACTION"]={
		text=TEXT(TITANROLL_CURRENTACTION..TitanGetVar(TITAN_ROLL_ID, "PerformedRoll")),
		button1=TEXT(ACCEPT),
		button2=TEXT(CANCEL),
		hasEditBox=1,
		maxLetters=30,
		OnAccept=function()
			local editBox=getglobal(this:GetParent():GetName().."EditBox")
			TitanSetVar(TITAN_ROLL_ID, "PerformedRoll", editBox:GetText());
		end,
		EditBoxOnEnterPressed=function()
			local editBox=getglobal(this:GetParent():GetName().."EditBox")
			TitanSetVar(TITAN_ROLL_ID, "PerformedRoll", editBox:GetText());
		end,
		timeout=0,
		exclusive=1
	}
	StaticPopup_Show("TITANROLL_CHANGEACTION")

end

function TitanPanelRollButton_SetListLength()
	local i;
	local length = this.value;
	TitanSetVar(TITAN_ROLL_ID, "ListLength", length);
	if (TitanRollsCount) and (TitanRollsCount > length) then
		for i = length+1, TitanRollsCount do
			TitanRolls[i] = nil;
		end
		TitanRollsCount = length;
	end
	if (TimedOut > length) then
		TimedOut = length;
	end
	TitanPanelButton_UpdateButton(TITAN_ROLL_ID);
end

function TitanPanelRollButton_SetTimeout()
	TitanSetVar(TITAN_ROLL_ID, "Timeout", TITANROLL_TIMEOUTS[this.value]);
	if (TitanRollsCount) then
		TimedOut = TitanRollsCount;
	else
		TimedOut = 0;
	end
	TitanPanelButton_UpdateButton(TITAN_ROLL_ID);
	TitanPanelButton_UpdateTooltip();
end

function TitanPanelRightClickMenu_PrepareRollMenu()
	local i;

	if (UIDROPDOWNMENU_MENU_LEVEL == 1) then

		TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_ROLL_ID].menuText);
		TitanPanelRightClickMenu_AddToggleIcon(TITAN_ROLL_ID);
		TitanPanelRightClickMenu_AddToggleLabelText(TITAN_ROLL_ID);

		TitanPanelRightClickMenu_AddSpacer();
		TitanPanelRightClickMenu_AddToggleVar(TITANROLL_TOGWINNER, TITAN_ROLL_ID, "ShowWinner");	
		TitanPanelRightClickMenu_AddToggleVar(TITANROLL_TOGREPLACE, TITAN_ROLL_ID, "ReplaceBadRolls");
		TitanPanelRightClickMenu_AddToggleVar(TITANROLL_TOGSORTLIST, TITAN_ROLL_ID, "SortList");
		TitanPanelRightClickMenu_AddToggleVar(TITANROLL_TOGHIGHLIGHT, TITAN_ROLL_ID, "HighlightParty");
	
		info = {};
		info.text = TITANROLL_CHANGELENGTH;
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info = {};
		info.text = TITANROLL_SETTIMEOUT;
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		TitanPanelRightClickMenu_AddSpacer();
		TitanPanelRightClickMenu_AddCommand(TITANROLL_PERFORMED, TITAN_ROLL_ID, "TitanPanelRollButton_ChangeAction")
		TitanPanelRightClickMenu_AddCommand(TITANROLL_ERASELIST, TITAN_ROLL_ID, "TitanPanelRollButton_ResetSession");

		TitanPanelRightClickMenu_AddSpacer();
		TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_ROLL_ID, TITAN_PANEL_MENU_FUNC_HIDE);

	elseif (UIDROPDOWNMENU_MENU_LEVEL == 2) then
	
		if (UIDROPDOWNMENU_MENU_VALUE == TITANROLL_CHANGELENGTH) then
			TitanPanelRightClickMenu_AddTitle(TITANROLL_CHANGELENGTH, UIDROPDOWNMENU_MENU_LEVEL);
			for i = 5, 25, 5 do
				info = {};
				info.text = i;
				info.func = TitanPanelRollButton_SetListLength;
				info.checked = (i == TitanGetVar(TITAN_ROLL_ID, "ListLength"))
				info.value = i;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);	
			end 
		elseif (UIDROPDOWNMENU_MENU_VALUE == TITANROLL_SETTIMEOUT) then
			TitanPanelRightClickMenu_AddTitle(TITANROLL_SETTIMEOUT, UIDROPDOWNMENU_MENU_LEVEL);
			for i = 1, 7 do
				info = {}
				info.text = TITANROLL_TIMEOUTS_TEXT[i];
				info.func = TitanPanelRollButton_SetTimeout;
				info.checked = (TITANROLL_TIMEOUTS[i] == TitanGetVar(TITAN_ROLL_ID, "Timeout"))
				info.value = i;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);	
			end
		end
	end
end
