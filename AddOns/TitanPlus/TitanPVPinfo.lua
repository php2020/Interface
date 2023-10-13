TITAN_PVPINFO_ID = "PVPinfo";
TITAN_PVPINFO_STATE = TITAN_PVPINFO_STATE_INACTIVE;
TITAN_PVPINFO_STATE_TEXT = TITAN_PVPINFO_STATE_INACTIVE;
TITAN_PVPINFO_PVP_FLAG = TITAN_PVPINFO_FLAG_OFF;
TITAN_PVPINFO_JUSTACTIVE = nil;

TITAN_PVPINFO_PVP_FLAG_TIME = 0;
TITAN_PVPINFO_COOLDOWN_TIME = 300;
TITAN_PVPINFO_REMAINING_TIME = 0;
TITAN_PVPINFO_ELAPSED_TIME = 0;
TITAN_PVPINFO_SESSION_TIME = 0;
TITAN_PVPINFO_ACTIVATE_TIME = 0;
TITAN_PVPINFO_FREQUENCY = 1;

TITAN_PVPINFO_STATE_ACTIVERED = TitanUtils_GetRedText(TITAN_PVPINFO_STATE_ACTIVE)
TITAN_PVPINFO_STATE_ACTIVEGREEN = TitanUtils_GetGreenText(TITAN_PVPINFO_STATE_ACTIVE)
TITAN_PVPINFO_STATE_ACTIVEWHITE = TitanUtils_GetHighlightText(TITAN_PVPINFO_STATE_ACTIVE)
TITAN_PVPINFO_STATE_INACTIVERED = TitanUtils_GetRedText(TITAN_PVPINFO_STATE_INACTIVE)
TITAN_PVPINFO_STATE_INACTIVEGREEN = TitanUtils_GetGreenText(TITAN_PVPINFO_STATE_INACTIVE)
TITAN_PVPINFO_STATE_INACTIVEWHITE = TitanUtils_GetHighlightText(TITAN_PVPINFO_STATE_INACTIVE)
TITAN_PVPINFO_STATE_INACTIVEYELLOW = TitanUtils_GetNormalText(TITAN_PVPINFO_STATE_INACTIVE)
TITAN_PVPINFO_STATE_ONRED = TitanUtils_GetRedText(TITAN_PVPINFO_STATE_ON)
TITAN_PVPINFO_STATE_ONGREEN = TitanUtils_GetGreenText(TITAN_PVPINFO_STATE_ON)
TITAN_PVPINFO_STATE_ONWHITE = TitanUtils_GetHighlightText(TITAN_PVPINFO_STATE_ON)
TITAN_PVPINFO_STATE_OFFRED = TitanUtils_GetRedText(TITAN_PVPINFO_STATE_OFF)
TITAN_PVPINFO_STATE_OFFGREEN = TitanUtils_GetGreenText(TITAN_PVPINFO_STATE_OFF)
TITAN_PVPINFO_STATE_OFFWHITE = TitanUtils_GetHighlightText(TITAN_PVPINFO_STATE_OFF)
TITAN_PVPINFO_STATE_OFFYELLOW = TitanUtils_GetNormalText(TITAN_PVPINFO_STATE_OFF)

TITAN_PVPINFO_DEBUGCOUNT = 1;

function TitanPanelPVPinfoButton_OnLoad()
	this.registry = { 
		id = TITAN_PVPINFO_ID,
		builtIn_c = 1,
		menuText = TITAN_PVPINFO_MENU_TEXT, 
		buttonTextFunction = "TitanPanelPVPinfoButton_GetButtonText", 
		tooltipTitle = TITAN_PVPINFO_TOOLTIP,
		tooltipTextFunction = "TitanPanelPVPinfoButton_GetTooltipText",
		frequency = TITAN_PVPINFO_FREQUENCY,
		savedVariables = {
			PVPActivateTime = 0,
			PVPInCooldown = 0,
			PVPTimerColour = TITAN_NIL,
			PVPStateColour = TITAN_NIL,
			PVPShortTxt = TITAN_NIL,
			PVPCollapse = TITAN_NIL,
			PVPShiftClick = TITAN_NIL,
			ShowLabelText = 1,
		}
	};
	
	this:RegisterEvent("UNIT_PVP_UPDATE");
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	
	if (UnitIsPVP("player")==1) then
		TITAN_PVPINFO_STATE=TITAN_PVPINFO_STATE_ACTIVE;
	end
end

function TitanPanelPVPinfoButton_OnEvent(event)
	if (event == "UNIT_PVP_UPDATE") then
		if (arg1 == "player") then
			if UnitIsPVP("player") then
				TitanPanelPVPinfoButton_PVPActivate();
				if ((UnitIsPVP("target")) and (UnitFactionGroup("target")~=UnitFactionGroup("player"))) then
					TitanPanelPVPinfoButton_PVPCooldownStart();
				end
			else
				TitanPanelPVPinfoButton_PVPDeactivate();
			end
		end
	elseif ((event == "CHAT_MSG_SYSTEM") and (string.find(arg1, TITAN_PVPINFO_OFF_SEARCH))) then
		TitanPanelPVPinfoButton_PVPCooldownStart();
	elseif ((event == "CHAT_MSG_SYSTEM") and (string.find(arg1, TITAN_PVPINFO_ON_SEARCH))) then
		TitanPanelPVPinfoButton_PVPRestart();
	end
end

function TitanPanelPVPinfoButton_PVPActivate()
	TITAN_PVPINFO_STATE=TITAN_PVPINFO_STATE_ACTIVE;
	TITAN_PVPINFO_PVP_FLAG=TITAN_PVPINFO_FLAG_OFF;
	TITAN_PVPINFO_REMAINING_TIME = 0;
	TITAN_PVPINFO_ELAPSED_TIME = 0;
	TITAN_PVPINFO_ACTIVATE_TIME = TitanUtils_GetTotalTime();
	if (TITAN_PVPINFO_ACTIVATE_TIME) then
		TitanSetVar(TITAN_PVPINFO_ID, "PVPActivateTime", TITAN_PVPINFO_ACTIVATE_TIME);
	end
end

function TitanPanelPVPinfoButton_PVPCooldownStart()
	if (TITAN_PVPINFO_STATE == TITAN_PVPINFO_STATE_ACTIVE) then
		TITAN_PVPINFO_PVP_FLAG = TITAN_PVPINFO_FLAG_ON;
		TITAN_PVPINFO_REMAINING_TIME = TITAN_PVPINFO_COOLDOWN_TIME;
		TITAN_PVPINFO_PVP_FLAG_TIME = TitanUtils_GetTotalTime();
		TitanSetVar(TITAN_PVPINFO_ID, "PVPInCooldown", TITAN_PVPINFO_PVP_FLAG_TIME);
		TitanSetVar(TITAN_PVPINFO_ID, "PVPActivateTime", TITAN_PVPINFO_ACTIVATE_TIME);
	end
end

function TitanPanelPVPinfoButton_PVPRestart()
	TITAN_PVPINFO_STATE=TITAN_PVPINFO_STATE_ACTIVE;
	TITAN_PVPINFO_PVP_FLAG=TITAN_PVPINFO_FLAG_OFF;
	TITAN_PVPINFO_REMAINING_TIME = 0;
	TitanSetVar(TITAN_PVPINFO_ID, "PVPInCooldown", nil);
end
	
	
function TitanPanelPVPinfoButton_PVPDeactivate()
	TITAN_PVPINFO_STATE=TITAN_PVPINFO_STATE_INACTIVE;
	TITAN_PVPINFO_PVP_FLAG=TITAN_PVPINFO_FLAG_OFF;
	TITAN_PVPINFO_REMAINING_TIME = 0;
	TITAN_PVPINFO_SESSION_TIME = TITAN_PVPINFO_SESSION_TIME + TITAN_PVPINFO_ELAPSED_TIME;
	TITAN_PVPINFO_ELAPSED_TIME = 0;
	TITAN_PVPINFO_ACTIVATE_TIME = 0;
	TitanSetVar(TITAN_PVPINFO_ID, "PVPActivateTime", nil);
	TitanSetVar(TITAN_PVPINFO_ID, "PVPInCooldown", nil);
end


function TitanPanelPVPinfoButton_OnUpdate()
	if (UnitIsPVP("player")==1) then
		TITAN_PVPINFO_STATE=TITAN_PVPINFO_STATE_ACTIVE;
	end

	if TitanGetVar(TITAN_PVPINFO_ID, "PVPInCooldown") then
		TITAN_PVPINFO_PVP_FLAG_TIME = TitanGetVar(TITAN_PVPINFO_ID, "PVPInCooldown");
		TITAN_PVPINFO_PVP_FLAG = TITAN_PVPINFO_FLAG_ON;
		TITAN_PVPINFO_ACTIVATE_TIME = TitanGetVar(TITAN_PVPINFO_ID, "PVPActivateTime");
	end

	if (TitanUtils_GetTotalTime() and TitanGetVar(TITAN_PVPINFO_ID, "PVPActivateTime")) then
		if (TITAN_PVPINFO_PVP_FLAG == TITAN_PVPINFO_FLAG_ON) then
			TITAN_PVPINFO_REMAINING_TIME = TITAN_PVPINFO_COOLDOWN_TIME - (TitanUtils_GetTotalTime() - TITAN_PVPINFO_PVP_FLAG_TIME);
			if (TITAN_PVPINFO_REMAINING_TIME < 0) then
				TITAN_PVPINFO_REMAINING_TIME = 0;
			end
		end
		if (TITAN_PVPINFO_STATE == TITAN_PVPINFO_STATE_ACTIVE) then
			TITAN_PVPINFO_ELAPSED_TIME = TitanUtils_GetTotalTime() - TitanGetVar(TITAN_PVPINFO_ID, "PVPActivateTime");
		end
	end
end

function TitanPanelPVPinfoButton_OnLeftClick(button)
	if TitanGetVar(TITAN_PVPINFO_ID, "PVPShiftClick") then
		if (IsShiftKeyDown()) then
			TogglePVP();
		end
	else
		TogglePVP();
	end
end

function TitanPanelPVPinfoButton_debug(msg)
	DEFAULT_CHAT_FRAME:AddMessage("Titan[PVPinfo]debug-------> ".. msg);
end

function TitanPanelPVPinfoButton_ConvertTime(time)
	local hTemp = 0;
	local mTemp = 0;
	local sTemp = 0;
	if (time > 3599) then
		hTemp = floor(time/3600);
		mTemp = floor((time/60) - (hTemp*60))
		sTemp = (time - (hTemp*3600) - (mTemp*60));
		if (mTemp < 10) then
			mTemp = "0"..mTemp;
		end
		if (sTemp < 10) then
			sTemp = "0"..sTemp;
		end
		return hTemp..":"..mTemp..":"..sTemp;
	else
		mTemp = floor(time/60);
		sTemp = (time - (mTemp*60));
		if (sTemp < 10) then
			sTemp = "0"..sTemp;
		end
		return mTemp..":"..sTemp;
	end
end

function TitanPanelPVPinfoButton_GetButtonText(id)
	local button, id = TitanUtils_GetButton(id, true);
	local buttonRichText;
	
	if (TITAN_PVPINFO_PVP_FLAG == TITAN_PVPINFO_FLAG_ON) then
		PVPINFO_TIME=TitanPanelPVPinfoButton_ConvertTime(ceil(TITAN_PVPINFO_REMAINING_TIME));
		if (TitanGetVar(TITAN_PVPINFO_ID, "PVPTimerColour")=="Green") then
			buttonRichText = TitanUtils_GetGreenText(PVPINFO_TIME);
		elseif (TitanGetVar(TITAN_PVPINFO_ID, "PVPTimerColour")=="White") then
			buttonRichText = TitanUtils_GetHighlightText(PVPINFO_TIME);
		elseif (TitanGetVar(TITAN_PVPINFO_ID, "PVPTimerColour")=="Yellow") then
			buttonRichText = TitanUtils_GetNormalText(PVPINFO_TIME);
		else
			buttonRichText = TitanUtils_GetRedText(PVPINFO_TIME);
		end
	else
		if (UnitIsPVP("player")==1) then
			TITAN_PVPINFO_STATE=TITAN_PVPINFO_STATE_ACTIVE;
			if TitanGetVar(TITAN_PVPINFO_ID, "PVPShortTxt") then
				TITAN_PVPINFO_STATE_TEXT=TITAN_PVPINFO_STATE_ON;
			else
				TITAN_PVPINFO_STATE_TEXT=TITAN_PVPINFO_STATE_ACTIVE;
			end
				if (TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="greenyellow") then
					buttonRichText = TitanUtils_GetGreenText(TITAN_PVPINFO_STATE_TEXT);
				elseif (TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="redgreen") then
					buttonRichText = TitanUtils_GetRedText(TITAN_PVPINFO_STATE_TEXT);
				else -- TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="whitegreen" or "whitewhite"
					buttonRichText = TitanUtils_GetHighlightText(TITAN_PVPINFO_STATE_TEXT);
				end
		else
			TITAN_PVPINFO_STATE=TITAN_PVPINFO_STATE_INACTIVE;
			TitanSetVar(TITAN_PVPINFO_ID, "PVPInCooldown", nil);
			if TitanGetVar(TITAN_PVPINFO_ID, "PVPCollapse") then
				return "o";
			else
				if TitanGetVar(TITAN_PVPINFO_ID, "PVPShortTxt") then
					TITAN_PVPINFO_STATE_TEXT=TITAN_PVPINFO_STATE_OFF;
				else
					TITAN_PVPINFO_STATE_TEXT=TITAN_PVPINFO_STATE_INACTIVE;
				end
				if (TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="greenyellow") then
					buttonRichText = TitanUtils_GetNormalText(TITAN_PVPINFO_STATE_TEXT);
				elseif (TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="whitewhite") then
					buttonRichText = TitanUtils_GetHighlightText(TITAN_PVPINFO_STATE_TEXT);
				else     -- TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="redgreen" or "whitegreen"
					buttonRichText = TitanUtils_GetGreenText(TITAN_PVPINFO_STATE_TEXT);
				end
			end
		end
	end
	return TITAN_PVPINFO_BUTTON_TEXT, buttonRichText;
end

function TitanPanelRightClickMenu_PreparePVPinfoMenu()
	local id=TITAN_PVPINFO_ID;
	local info;
	
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[id].menuText)
	if (not TitanGetVar(TITAN_PVPINFO_ID, "PVPTimerColour")) then
		TitanSetVar(TITAN_PVPINFO_ID, "PVPTimerColour", "Red");
	end
	if (not TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")) then
		TitanSetVar(TITAN_PVPINFO_ID, "PVPStateColour", "redgreen");
	end
	if (not TitanGetVar(TITAN_PVPINFO_ID, "PVPShortTxt")) then
	-- display long text
	end
	
	info={}
	info.text=TITAN_PVPINFO_MENU_COLLAPSE;
	info.func=function()
		TitanToggleVar(TITAN_PVPINFO_ID, "PVPCollapse");
		TitanPanelButton_UpdateButton("PVPinfo");
	end
	info.checked=TitanGetVar(TITAN_PVPINFO_ID, "PVPCollapse")
	UIDropDownMenu_AddButton(info)
	
	TitanPanelRightClickMenu_AddSpacer();
		
	info={}
	info.text="Shift-"..TITAN_PVPINFO_TOGGLE_TEXT;
	info.func=function()
		TitanToggleVar(TITAN_PVPINFO_ID, "PVPShiftClick");
		TitanPanelButton_UpdateButton("PVPinfo");
	end
	info.checked=TitanGetVar(TITAN_PVPINFO_ID, "PVPShiftClick")
	UIDropDownMenu_AddButton(info)
	
	TitanPanelRightClickMenu_AddSpacer();
	
	info={}
	info.text=TitanUtils_GetNormalText(TITAN_PVPINFO_MENU_THREATCOLOUR);
	UIDropDownMenu_AddButton(info);
	
	info={}
	if (not TitanGetVar(TITAN_PVPINFO_ID, "PVPShortTxt")) then
		info.text="  "..TITAN_PVPINFO_STATE_ACTIVERED.."/"..TITAN_PVPINFO_STATE_INACTIVEGREEN;
	else
		info.text="  "..TITAN_PVPINFO_STATE_ONRED.."/"..TITAN_PVPINFO_STATE_OFFGREEN;
	end
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPStateColour", "redgreen");
		TitanPanelButton_UpdateButton("PVPinfo");
	end
	info.checked=(TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="redgreen");
	UIDropDownMenu_AddButton(info)
	
	info={}
	if (not TitanGetVar(TITAN_PVPINFO_ID, "PVPShortTxt")) then
		info.text="  "..TITAN_PVPINFO_STATE_ACTIVEGREEN.."/"..TITAN_PVPINFO_STATE_INACTIVEYELLOW;
	else
		info.text="  "..TITAN_PVPINFO_STATE_ONGREEN.."/"..TITAN_PVPINFO_STATE_OFFYELLOW;
	end
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPStateColour", "greenyellow");
		TitanPanelButton_UpdateButton("PVPinfo")
	end
	info.checked=(TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="greenyellow");
	UIDropDownMenu_AddButton(info)
	
	info={}
	if (not TitanGetVar(TITAN_PVPINFO_ID, "PVPShortTxt")) then
		info.text="  "..TITAN_PVPINFO_STATE_ACTIVEWHITE.."/"..TITAN_PVPINFO_STATE_INACTIVEGREEN;
	else
		info.text="  "..TITAN_PVPINFO_STATE_ONWHITE.."/"..TITAN_PVPINFO_STATE_OFFGREEN;
	end
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPStateColour", "whitegreen");
		TitanPanelButton_UpdateButton("PVPinfo")
	end
	info.checked=(TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="whitegreen");
	UIDropDownMenu_AddButton(info)
	
	info={}
	if (not TitanGetVar(TITAN_PVPINFO_ID, "PVPShortTxt")) then
		info.text="  "..TITAN_PVPINFO_STATE_ACTIVEWHITE.."/"..TITAN_PVPINFO_STATE_INACTIVEWHITE;
	else
		info.text="  "..TITAN_PVPINFO_STATE_ONWHITE.."/"..TITAN_PVPINFO_STATE_OFFWHITE;
	end
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPStateColour", "whitewhite");
		TitanPanelButton_UpdateButton("PVPinfo")
	end
	info.checked=(TitanGetVar(TITAN_PVPINFO_ID, "PVPStateColour")=="whitewhite");
	UIDropDownMenu_AddButton(info)
	
	TitanPanelRightClickMenu_AddSpacer()
	
	info={}
	info.text=TitanUtils_GetNormalText(TITAN_PVPINFO_MENU_STATUSPREF);
	UIDropDownMenu_AddButton(info)
	
	info={}
	info.text="  "..TITAN_PVPINFO_STATE_ACTIVE.."/"..TITAN_PVPINFO_STATE_INACTIVE;
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPShortTxt", nil);
		TitanPanelButton_UpdateButton("PVPinfo")
	end
	info.checked=not TitanGetVar(TITAN_PVPINFO_ID, "PVPShortTxt");
	UIDropDownMenu_AddButton(info)
	
	info={}
	info.text="  "..TITAN_PVPINFO_STATE_ON.."/"..TITAN_PVPINFO_STATE_OFF;
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPShortTxt", 1);
		TitanPanelButton_UpdateButton("PVPinfo")
	end
	info.checked=TitanGetVar(TITAN_PVPINFO_ID, "PVPShortTxt");
	UIDropDownMenu_AddButton(info)
	
	TitanPanelRightClickMenu_AddSpacer()
	
	info={}
	info.text=TitanUtils_GetNormalText(TITAN_PVPINFO_MENU_TIMERCOLOUR_TEXT);
	UIDropDownMenu_AddButton(info)
	
	info={}
	info.text="  "..TitanUtils_GetRedText(TITAN_PVPINFO_MENU_REDTEXT);
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPTimerColour", "Red");
		TitanPanelButton_UpdateButton("PVPinfo")
	end
	info.checked=(TitanGetVar(TITAN_PVPINFO_ID, "PVPTimerColour") == "Red");
	UIDropDownMenu_AddButton(info)
	
	info={}
	info.text="  "..TitanUtils_GetNormalText(TITAN_PVPINFO_MENU_YELLOWTEXT);
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPTimerColour", "Yellow");
		TitanPanelButton_UpdateButton("PVPinfo")
	end
	info.checked=(TitanGetVar(TITAN_PVPINFO_ID, "PVPTimerColour") == "Yellow");
	UIDropDownMenu_AddButton(info)
	
	info={}
	info.text="  "..TitanUtils_GetGreenText(TITAN_PVPINFO_MENU_GREENTEXT);
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPTimerColour", "Green");
		TitanPanelButton_UpdateButton("PVPinfo")
	end
	info.checked=(TitanGetVar(TITAN_PVPINFO_ID, "PVPTimerColour") == "Green");
	UIDropDownMenu_AddButton(info)
	
	info={}
	info.text="  "..TitanUtils_GetHighlightText(TITAN_PVPINFO_MENU_WHITETEXT);
	info.func=function()
		TitanSetVar(TITAN_PVPINFO_ID, "PVPTimerColour", "White");
		TitanPanelButton_UpdateButton("PVPinfo")
	end
	info.checked=(TitanGetVar(TITAN_PVPINFO_ID, "PVPTimerColour") == "White");
	UIDropDownMenu_AddButton(info)
	
	TitanPanelRightClickMenu_AddSpacer()
	
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_PVPINFO_ID);
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_PVPINFO_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

function TitanPanelPVPinfoButton_GetTooltipText()
	local line1, line2, line3, line4, line5, line6
	local pvpInfoArea = GetZonePVPInfo("pvpType");
	if (GetZonePVPInfo("pvpType") == "contested") then
		line2 = format(TITAN_PVPINFO_TOOLTIP_AREA,TitanUtils_GetHighlightText(TITAN_PVPINFO_CONTESTED)).."\n";
	elseif (GetZonePVPInfo("pvpType") == "hostile") then
		line2 = format(TITAN_PVPINFO_TOOLTIP_AREA,TitanUtils_GetRedText(TITAN_PVPINFO_HOSTILE)).."\n";
	else
		line2 = format(TITAN_PVPINFO_TOOLTIP_AREA,TitanUtils_GetGreenText(TITAN_PVPINFO_FRIENDLY)).."\n";
	end
	if (TITAN_PVPINFO_PVP_FLAG == TITAN_PVPINFO_FLAG_ON) then
		line1 = format(TITAN_PVPINFO_TOOLTIP_STATUS, TitanUtils_GetHighlightText(TITAN_PVPINFO_STATE_TEXT..TITAN_PVPINFO_MENU_WAITINGTEXT)).."\n";
	else 
		line1 = format(TITAN_PVPINFO_TOOLTIP_STATUS, TitanUtils_GetHighlightText(TITAN_PVPINFO_STATE_TEXT)).."\n";
	end
--	line3 = format("PVP Flag : %s", TitanUtils_GetHighlightText(TITAN_PVPINFO_PVP_FLAG)).."\n";
	line3 = format(TITAN_PVPINFO_REMAINING, TitanUtils_GetHighlightText(TitanPanelPVPinfoButton_ConvertTime(ceil(TITAN_PVPINFO_REMAINING_TIME)))).."\n";
	line4 = format(TITAN_PVPINFO_PVPTIME, TitanUtils_GetHighlightText(TitanPanelPVPinfoButton_ConvertTime(ceil(TITAN_PVPINFO_ELAPSED_TIME)))).."\n";
	line5 = format(TITAN_PVPINFO_PVPSESSION, TitanUtils_GetHighlightText(TitanPanelPVPinfoButton_ConvertTime(ceil(TITAN_PVPINFO_SESSION_TIME+TITAN_PVPINFO_ELAPSED_TIME))));
	line6 = format(TITAN_PVPINFO_TOGGLE_TEXT).."\n".."\n";
	if TitanGetVar(TITAN_PVPINFO_ID, "PVPShiftClick") then
		line6 = format("Shift-")..line6;
	end
	if (TITAN_PVPINFO_STATE == TITAN_PVPINFO_STATE_ACTIVE) then
		if (TITAN_PVPINFO_PVP_FLAG == TITAN_PVPINFO_FLAG_ON) then
			return line6..line1..line2..line3..line4..line5;
		else
			return line6..line1..line2..line4..line5;
		end
	else
		return line6..line1..line2..line5;
	end
end
