TITAN_CLEANMINIMAP_ID = "CleanMinimap";

function TitanPanelCleanMinimapButton_OnLoad()
	this.registry = {
		id = TITAN_CLEANMINIMAP_ID,
		builtIn_ss = 1,
		menuText = TITAN_CLEANMINIMAP_MENU_TEXT, 
		tooltipTitle = TITAN_CLEANMINIMAP_MENU_TEXT,
        tooltipTextFunction = "TitanPanelCleanMinimapButton_GetTooltipText",
	};
end

function TitanPanelCleanMinimapButton_OnShow()
	TitanPanelCleanMinimapButton_SetIcon();
end

function TitanPanelCleanMinimapButton_OnClick(button)
	if (button == "LeftButton") then
        TitanPanelCleanMinimap_ToggleMinimap();
	end
end

function TitanPanelCleanMinimapButton_SetIcon()
	local icon = TitanPanelCleanMinimapButtonIcon;
	if (MinimapCluster:IsVisible()) then
        icon:SetTexture(TITAN_CLEANMINIMAP_ARTWORK_PATH.."CleanMinimapShow");
	else
        icon:SetTexture(TITAN_CLEANMINIMAP_ARTWORK_PATH.."CleanMinimapHide");
	end	
end

function TitanPanelCleanMinimap_ToggleCleanMinimap()
    if (CleanMinimap_IsOn()) then
        CleanMinimap_Slash("off");
    else
        CleanMinimap_Slash("on");
    end
end

function TitanPanelCleanMinimap_ToggleClock()
    CleanMinimap_Slash("clock");
end

function TitanPanelCleanMinimap_ToggleZoom()
    CleanMinimap_Slash("zoom");
end

function TitanPanelCleanMinimap_ToggleTitle()
    CleanMinimap_Slash("title");
end

function TitanPanelCleanMinimap_ToggleNsew()
    CleanMinimap_Slash("nsew");
end

function TitanPanelCleanMinimap_MoveMinimap()
    CleanMinimap_Slash("move");
end

function TitanPanelCleanMinimap_ResizeMinimap()
    CleanMinimap_Slash("resize");
end

function TitanPanelCleanMinimap_GetAlpha(alpha)
    return floor(100 * alpha + 0.5);
end

function TitanPanelCleanMinimap_GetAlphaText(alpha)
    return tostring(TitanPanelCleanMinimap_GetAlpha(alpha)) .. "%";
end

function TitanPanelCleanMinimap_SetAlpha(alpha)
    if (alpha > 100) then 
        alpha = 100;
    end
    if (alpha < 1) then 
        alpha = 1;
    end
    CleanMinimap_Slash("alpha "..alpha);
end

function TitanPanelRightClickMenu_PrepareCleanMinimapMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_CLEANMINIMAP_ID].menuText);
    local info = {};

    info = {};
    info.text = TITAN_CLEANMINIMAP_MENU_ENABLE_MM;
    info.func = TitanPanelCleanMinimap_ToggleMinimap;
    info.checked = MinimapCluster:IsVisible();
    UIDropDownMenu_AddButton(info);

    if (Minimap:IsVisible()) then    
        info = {};
        info.text = TITAN_CLEANMINIMAP_MENU_ENABLE_CMM;
        info.func = TitanPanelCleanMinimap_ToggleCleanMinimap;
        info.checked = CleanMinimap_IsOn();
        UIDropDownMenu_AddButton(info);

        TitanPanelRightClickMenu_AddSpacer();

        if (CleanMinimap_IsOn()) then 

            info = {};
            info.text = TITAN_CLEANMINIMAP_MENU_SHOW_CLOCK;
            info.func = TitanPanelCleanMinimap_ToggleClock;
            info.checked = CleanMinimap_GetClock();
            UIDropDownMenu_AddButton(info);

            info = {};
            info.text = TITAN_CLEANMINIMAP_MENU_SHOW_ZOOM;
            info.func = TitanPanelCleanMinimap_ToggleZoom;
            info.checked = CleanMinimap_GetZoom();
            UIDropDownMenu_AddButton(info);

            info = {};
            info.text = TITAN_CLEANMINIMAP_MENU_SHOW_TITLE;
            info.func = TitanPanelCleanMinimap_ToggleTitle;
            info.checked = CleanMinimap_GetTitle();
            UIDropDownMenu_AddButton(info);

            info = {};
            info.text = TITAN_CLEANMINIMAP_MENU_SHOW_NSEW;
            info.func = TitanPanelCleanMinimap_ToggleNsew;
            info.checked = CleanMinimap_GetNsew();
            UIDropDownMenu_AddButton(info);

            TitanPanelRightClickMenu_AddSpacer();

            info = {};
            info.text = TITAN_CLEANMINIMAP_MENU_MOVE;
            info.func = TitanPanelCleanMinimap_MoveMinimap;
            UIDropDownMenu_AddButton(info);
        end
    end
    TitanPanelRightClickMenu_AddSpacer();
    
        
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_CLEANMINIMAP_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

function TitanPanelCleanMinimap_ToggleMinimap()
    if (MinimapCluster:IsVisible()) then
        MinimapCluster:Hide();
    else
        MinimapCluster:Show();
    end
    TitanPanelCleanMinimapButton_SetIcon();
end

function TitanPanelCleanMinimapButton_GetTooltipText()
    local alphaText = TitanPanelCleanMinimap_GetAlphaText(CleanMinimap_GetAlpha());
    local legend = "";
    if (Minimap:IsVisible()) then
        legend = TITAN_CLEANMINIMAP_TOOLTIP_STATUS.."\t"..TitanUtils_GetGreenText("on").."\n";
    else
        legend = TITAN_CLEANMINIMAP_TOOLTIP_STATUS.."\t"..TitanUtils_GetRedText("off").."\n";
    end
    
    if (CleanMinimap_IsOn() and Minimap:IsVisible()) then
        legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS.."\t"..TitanUtils_GetGreenText("on").."\n\n";
        legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_ALPHA_VALUE.."\t"..TitanUtils_GetHighlightText(alphaText).."\n\n";
        if (CleanMinimap_GetTitle()) then
            legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_TITLE.."\t"..TitanUtils_GetGreenText("on").."\n";
        else
            legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_TITLE.."\t"..TitanUtils_GetRedText("off").."\n";
        end
        if (CleanMinimap_GetClock()) then
            legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_CLOCK.."\t"..TitanUtils_GetGreenText("on").."\n";
        else
            legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_CLOCK.."\t"..TitanUtils_GetRedText("off").."\n";
        end
        if (CleanMinimap_GetZoom()) then
            legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_ZOOM.."\t"..TitanUtils_GetGreenText("on").."\n";
        else
            legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_ZOOM.."\t"..TitanUtils_GetRedText("off").."\n";
        end
        if (CleanMinimap_GetNsew()) then
            legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_NSEW.."\t"..TitanUtils_GetGreenText("on").."\n";
        else
            legend = legend..TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_NSEW.."\t"..TitanUtils_GetRedText("off").."\n";
        end
    end
    
    return ""..
        legend.."\n"..
        TitanUtils_GetGreenText(TITAN_CLEANMINIMAP_TOOLTIP_HINT1).."\n"..
        TitanUtils_GetGreenText(TITAN_CLEANMINIMAP_TOOLTIP_HINT2).."\n\n"..
        TitanUtils_GetHighlightText(TITAN_CLEANMINIMAP_TOOLTIP_HINT3).."\n"..
        TitanUtils_GetHighlightText(TITAN_CLEANMINIMAP_TOOLTIP_HINT4).."\n"..
        TitanUtils_GetHighlightText(TITAN_CLEANMINIMAP_TOOLTIP_HINT5).."\n"..
        TitanUtils_GetHighlightText(TITAN_CLEANMINIMAP_TOOLTIP_HINT6).."\n\n";
end
