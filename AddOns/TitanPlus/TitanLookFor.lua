--[[
	Please read the README file first. 
	It contains important information you'd like to know before coding TitanPlugin
]]--

function TitanPanelLookForButton_OnLoad()
	this.registry = { 
		id = "LookFor",
		builtIn_t = 1,
		menuText = TITAN_LookFor_MENU_TEXT, 
		buttonTextFunction = "TitanPanelLookForButton_GetButtonText", 
		tooltipTitle = TITAN_LookFor_TOOLTIP,
		tooltipTextFunction = "TitanPanelLookForButton_GetTooltipText", 
		frequency = TITAN_LookFor_FREQUENCY, 
	};
end

function TitanPanelLookForButton_GetButtonText(id)
	local buttonRichText = format(TITAN_LookFor_BUTTON_TEXT .. TitanUtils_GetGreenText("ON"));	
	return buttonRichText;
end

function TitanPanelLookForButton_GetTooltipText()
	local tooltipRichText = format(TitanUtils_GetGreenText(" LeftClick To Use  /  Type Help In EditBox For Commands"));	
	return tooltipRichText;
end

function TitanPanelRightClickMenu_PrepareLookForMenu()
	local id = "LookFor";
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[id].menuText);

	info = {};
	info.text = "testing menus";
--	info.func = ShowUIPanel(TITAN_LookFor_Options);
--	info.checked = TitanSettings.Panel.Latency.ShowColoredText;
	UIDropDownMenu_AddButton(info);
--[[
	TitanPanelRightClickMenu_Addspacer();
	TitanPanelRightClickMenu_AddCommand();
	TitanPanelRightClickMenu_AddCommand();	
]]--
end

function LookFor_Submit()
	msg = LookForFrameEdit:GetText();
	LookFor_CommandHandler(msg)
	if (LookForFrame:IsVisible() ) then
		HideUIPanel(LookForFrame);
	end
end

function TitanPanelLookForButton_OnClick()
	ShowUIPanel(LookForFrame);
end

-- KeyBinding Function
function LookFor_Toggle()
	if(LookForFrame:IsVisible()) then
		HideUIPanel(LookForFrame);
	else
		ShowUIPanel(LookForFrame);
	end
end