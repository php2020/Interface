TITAN_MAIL_ID = "Mail";
TITAN_MAILRIGHT_ID = "MailRight";
TITAN_MAIL_FREQUENCY = 1;
TITAN_MAIL_ICON_NOMAIL = "Interface\\Icons\\Ability_Vanish";
--TITAN_MAIL_ICON_NEW = "Interface\\Icons\\Spell_Arcane_TeleportIronForge";
TITAN_MAIL_ICON_NEW = "Interface\\Icons\\INV_Letter_15";
TITAN_MAIL_ICON_AH = "Interface\\Icons\\Spell_Holy_RighteousFury";

-- Local variables
TitanMail_sound = "Interface\\AddOns\\TitanPlus\\Artwork\\mail.wav";
TitanMail_AHalerts = nil;
TitanMail_numNew = 0;
TitanMail_numTotal = 0;
TitanMail_ignorenext = false;
TitanMail_checkedmail = false;

function TitanPanelMailButton_OnLoad()
	this.registry = { 
		id = TITAN_MAIL_ID,
		builtIn_t = 1,
		menuText = TITAN_MAIL_MENU_TEXT, 
		buttonTextFunction = "TitanPanelMailButton_GetButtonText", 
		tooltipTitle = TITAN_MAIL_TOOLTIP,
		tooltipTextFunction = "TitanPanelMailButton_GetTooltipText", 
		icon = TITAN_MAIL_ICON_NEW,	
		iconWidth = 16,
--		frequency = TITAN_MAIL_FREQUENCY, 
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			compact = 1,
			hidemm = "Titan Nil",
			new = 0,
			total = 0,
			sound = 1,
			chat = 1,
		}
	};
	
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("MAIL_SHOW");
	this:RegisterEvent("MAIL_INBOX_UPDATE");
	this:RegisterEvent("UPDATE_PENDING_MAIL");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function TitanPanelMailRightButton_OnLoad()
	this.registry = { 
		id = TITAN_MAILRIGHT_ID,
		builtIn_ss = 1,
		menuText = TITAN_MAILRIGHT_MENU_TEXT, 
		buttonTextFunction = "TitanPanelMailButton_GetButtonText", 
		tooltipTitle = TITAN_MAIL_TOOLTIP,
		tooltipTextFunction = "TitanPanelMailButton_GetTooltipText", 
		icon = TITAN_MAIL_ICON_NEW,	
		iconWidth = 16,
--		frequency = TITAN_MAIL_FREQUENCY, 
	};
end

function TitanPanelMailButton_UpdateIcon()
	local hidemm = TitanGetVar(TITAN_MAIL_ID, "hidemm");
	local total = TitanGetVar(TITAN_MAIL_ID, "total");

	if (hidemm and MiniMapMailFrame:IsVisible()) then 
		MiniMapMailFrame:Hide(); 
	end

	local button = TitanUtils_GetButton(TITAN_MAIL_ID, true);
	local buttonR = TitanUtils_GetButton(TITAN_MAILRIGHT_ID, true);
	
	if TitanMail_AHalerts then
		button.registry.icon = TITAN_MAIL_ICON_AH;
		buttonR.registry.icon = TITAN_MAIL_ICON_AH;
	elseif (total and (total > 0)) or (HasNewMail()) then
		button.registry.icon = TITAN_MAIL_ICON_NEW;
		buttonR.registry.icon = TITAN_MAIL_ICON_NEW;
	else
		button.registry.icon = TITAN_MAIL_ICON_NOMAIL;
		buttonR.registry.icon = TITAN_MAIL_ICON_NOMAIL;
	end
	TitanPanelButton_UpdateButton(TITAN_MAIL_ID);
	TitanPanelButton_UpdateButton(TITAN_MAILRIGHT_ID);
end

function TitanPanelMailButton_GetButtonText(id)
	local compact = TitanGetVar(TITAN_MAIL_ID, "compact");
	local new = TitanGetVar(TITAN_MAIL_ID, "new");
	local total = TitanGetVar(TITAN_MAIL_ID, "total");

	if (not total) then return; end

	local buttonRichText = "";
	
	local numtxt = "(".. new.. "/".. total.. ")";
	
	if (compact) then
		if TitanMail_AHalerts then
			buttonRichText = TitanUtils_GetRedText(numtxt);
		elseif (total > 0) or (HasNewMail()) then
			buttonRichText = TitanUtils_GetGreenText(numtxt);	
		else
			buttonRichText = TitanUtils_GetNormalText(numtxt);
		end
	else
		if TitanMail_AHalerts then
			buttonRichText = TitanUtils_GetRedText(TITAN_MAIL_BUTTON_TEXT_ALERT.. numtxt);
		elseif (total > 0) or (HasNewMail()) then
			buttonRichText = TitanUtils_GetGreenText(TITAN_MAIL_BUTTON_TEXT_MAIL.. numtxt);	
		else
			buttonRichText = TitanUtils_GetNormalText(TITAN_MAIL_BUTTON_TEXT_NOMAIL.. numtxt);
		end
	end
	return buttonRichText, "";
end

function TitanPanelMailButton_GetTooltipText()
	local retstr = "";
	local new = TitanGetVar(TITAN_MAIL_ID, "new");
	local total = TitanGetVar(TITAN_MAIL_ID, "total");
	
	if (total > 0) or (HasNewMail()) then
		retstr = retstr.. TITAN_MAIL_BUTTON_TEXT_MAIL.. "\n\n";	
		retstr = retstr.. TitanUtils_GetGreenText(new.. TITAN_MAIL_TOOLTIP_NEW);
		retstr = retstr.. TitanUtils_GetNormalText(total.. TITAN_MAIL_TOOLTIP_TOTAL)
		
	else
		retstr = TITAN_MAIL_BUTTON_TEXT_NOMAIL;	
	end

	if TitanMail_AHalerts then
		retstr = retstr.. "\n";
		for i=1,table.getn(TitanMail_AHalerts) do
			retstr = retstr.. "\n".. TitanMail_AHalerts[i];
		end
	end
	
	return retstr;	
end

function TitanPanelMailButton_OnEvent()

	if (event == "VARIABLES_LOADED") then
		TitanPanelMailButton_UpdateIcon();
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		TitanMail_ignorenext = true;
	end
	if (event == "CHAT_MSG_SYSTEM") then
		TitanPanelMailButton_getmessage(arg1);
		TitanPanelMailButton_UpdateIcon();
	end
	if (event == "MAIL_SHOW") then
		TitanMail_checkedmail = true;
		TitanMail_AHalerts = nil;
		TitanPanelMailButton_UpdateIcon();
	end
	if ( event == "MAIL_INBOX_UPDATE" ) then
		if (GetInboxNumItems() < TitanGetVar(TITAN_MAIL_ID, "total")) then
			TitanMail_ignorenext = true;
		end
		TitanSetVar(TITAN_MAIL_ID, "new", 0);
		TitanSetVar(TITAN_MAIL_ID, "total", GetInboxNumItems());
		TitanPanelMailButton_UpdateIcon();
	end
	if ( event == "UPDATE_PENDING_MAIL" ) then
		TitanPanelMail_IncNew()
		TitanPanelMailButton_UpdateIcon();
	end
end

function TitanPanelMail_IncNew()		
	if (TitanMail_ignorenext) then
		TitanMail_ignorenext = false;
	else
		local new = TitanGetVar(TITAN_MAIL_ID, "new") + 1;
		local total = TitanGetVar(TITAN_MAIL_ID, "total") + 1;
		
		if (TitanMail_checkedmail) then
			total = GetInboxNumItems() + new;
		end
			
		TitanSetVar(TITAN_MAIL_ID, "new", new)
		TitanSetVar(TITAN_MAIL_ID, "total", total)
		
		if (TitanGetVar(TITAN_MAIL_ID, "sound")) then
	    PlaySoundFile(TitanMail_sound);
		end
		
		if (TitanGetVar(TITAN_MAIL_ID, "chat")) then
			DEFAULT_CHAT_FRAME:AddMessage(TITAN_MAIL_CHAT_NEW.."("..new.."/"..total..")");
		end
	end
end

function TitanPanelMailButton_getmessage(msg)

	local strset = {
		{ERR_AUCTION_WON_S, TITAN_MAIL_TOOLTIP_WON},
		{ERR_AUCTION_SOLD_S, TITAN_MAIL_TOOLTIP_SOLD},
		{ERR_AUCTION_OUTBID_S, TITAN_MAIL_TOOLTIP_OUTBID},
		{ERR_AUCTION_EXPIRED_S, TITAN_MAIL_TOOLTIP_EXPIRED},
		{ERR_AUCTION_REMOVED_S, TITAN_MAIL_TOOLTIP_CANCELLED},
	};
	
	for i,arr in strset do
		local searchstr = string.gsub(arr[1], "%%[^%s]+", "(.+)")
		local _, _, item = string.find(msg, searchstr)
		if (item) then 
			if (not TitanMail_AHalerts) then
				TitanMail_AHalerts = {};
			end
			table.insert(TitanMail_AHalerts, arr[2].. item);
		end
	end

	local searchstr = string.gsub(ERR_AUCTION_OUTBID_S, "%%s", "(.+)")
	local _, _, item = string.find(msg, searchstr)
	if (item) then 
		TitanPanelMail_IncNew();
	end
end

function TitanPanelRightClickMenu_PrepareMailRightMenu()
	TitanPanelMail_PrepareMenu()
	TitanPanelRightClickMenu_AddSpacer();		
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_MAILRIGHT_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

function TitanPanelRightClickMenu_PrepareMailMenu()
	TitanPanelMail_PrepareMenu()
	TitanPanelRightClickMenu_AddSpacer();		
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_MAIL_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

function TitanPanelMail_PrepareMenu()
	local info;
	
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_MAIL_ID].menuText);
	TitanPanelRightClickMenu_AddSpacer();		

	TitanPanelRightClickMenu_AddToggleIcon(TITAN_MAIL_ID);
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_MAIL_ID);

	info = {};
	info.text = TITAN_MAIL_MENU_COMPACT;
	info.value = "compact";
	info.func = TitanPanelMailButton_Toggle;
	info.checked = TitanGetVar(TITAN_MAIL_ID, "compact");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_MAIL_MENU_HIDEMM;
	info.value = "hidemm";
	info.func = TitanPanelMailButton_Toggle;
	info.checked = TitanGetVar(TITAN_MAIL_ID, "hidemm");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_MAIL_MENU_SOUND;
	info.value = "sound";
	info.func = TitanPanelMailButton_Toggle;
	info.checked = TitanGetVar(TITAN_MAIL_ID, "sound");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_MAIL_MENU_CHAT;
	info.value = "chat";
	info.func = TitanPanelMailButton_Toggle;
	info.checked = TitanGetVar(TITAN_MAIL_ID, "chat");
	UIDropDownMenu_AddButton(info);
end

function TitanPanelMailButton_Toggle()
	TitanToggleVar(TITAN_MAIL_ID, this.value);
	TitanPanelButton_UpdateButton(TITAN_MAIL_ID);
end

