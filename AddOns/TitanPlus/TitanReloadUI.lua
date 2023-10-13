TITAN_RELOADUI_ID = "ReloadUI";

function TitanPanelReloadUIButton_OnLoad()
	this.registry = {
		id = TITAN_RELOADUI_ID,
		builtIn_ss = 1,
		menuText = TITAN_RELOADUI_MENU_TEXT, 
		tooltipTitle = TITAN_RELOADUI_TOOLTIP, 
		tooltipTextFunction = "TitanPanelReloadUIButton_GetTooltipText", 
		icon = TITANRELOAD_ARTWORK_PATH.."TitanReload",
	};
end

function TitanPanelReloadUIButton_GetTooltipText()
	return ""..
		TitanUtils_GetGreenText(TITAN_RELOADUI_TOOLTIP_HINT1);
end

function TitanPanelReloadUIButton_OnClick(button)
	if ( button == "LeftButton" ) then
		ReloadUI();
	else
		GameTooltip:Hide();
		TitanPanelRightClickMenu_Toggle();
	end
end

function TitanPanelRightClickMenu_PrepareReloadUIMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_RELOADUI_ID].menuText);
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_RELOADUI_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end
