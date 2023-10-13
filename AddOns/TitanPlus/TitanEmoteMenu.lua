TITAN_EMOTEMENU_ID = "EmoteMenu";
TITAN_EMOTEMENURIGHT_ID = "EmoteMenuRight";
TITAN_EMOTEMENU_ICON = "Interface\\Icons\\Ability_Hunter_Pet_WindSerpent"

TITAN_EMOTEMENU_VERSION = "1.0";

--[[
		TitanEmoteMenu v1.0
		by Dsanai
		
		Special thanks to Tekkub for the borrowed code from TitanModMenu
		
		Version 1.0, Initial Release
		
		This mod is meant to give the player a quickly-accessible list of emotes, organized by the 'feeling' behind them.
		For instance, if you're feeling cranky, something in the Unhappy category will likely work. If you're Alliance and
		run into a Horde character, the Hostile category is rife with choices.
		
		I've designed this mod to allow emotes to sort to more than one category, where necessary.
		
		If the end user wishes to change these categories, simply edit EmoteData.lua in a text editor (such as Notepad),
		locate this part within the Emote record you wish to change: ["types"] = {0,2},
		And simply list all the categories you want it to sort to, separated by commas.
		A list of the numbers, and what categories they represent, is found at the top of EmoteData.lua.
]]

--------------------------------------------
--              onFunctions               --
--------------------------------------------

function TitanPanelEmoteMenuButton_OnLoad()
	this.registry = { 
		id = TITAN_EMOTEMENU_ID,
		menuText = TITAN_EMOTEMENU_MENU_TEXT, 
		buttonTextFunction = "TitanPanelEmoteMenuButton_GetButtonText", 
		icon = TITAN_EMOTEMENU_ICON,	
		iconWidth = 16,
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
		}
	};
end

function TitanPanelEmoteMenuRightButton_OnLoad()
	this.registry = { 
		id = TITAN_EMOTEMENURIGHT_ID,
		menuText = TITAN_EMOTEMENU_MENU_TEXTRIGHT, 
		buttonTextFunction = "TitanPanelEmoteMenuButton_GetButtonText", 
		icon = TITAN_EMOTEMENU_ICON,	
		iconWidth = 16,
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
		}
	};
end

function TitanPanelEmoteMenuButton_OnEvent()
end

--------------------------------------------
--             Mod Functions              --
--------------------------------------------

function TitanPanelEmoteMenu_ToggleFrame(f)
	local fram = getglobal(f);
	if (not fram) then fram = getglobal(this.value); end
	DropDownList1:Hide();
	if (fram:IsVisible()) then
		HideUIPanel(fram, true);
	else 
		ShowUIPanel(fram, true);
	end
end

function TitanPanelEmoteMenu_PassSlashCmd(c)
	local cmd = c;
	if (not cmd) then cmd = "/"..this.value; end
	DropDownList1:Hide();
	TitanPanelEmoteMenuEditBox:SetText(cmd);
	ChatEdit_SendText(TitanPanelEmoteMenuEditBox);
end

function TitanPanelEmoteMenu_CallFunction(f)
	local funct = f;
	if (not funct) then funct = this.value; end
	DropDownList1:Hide();
	local func = getglobal(funct);
	func();
end

function TitanPanelEmoteMenu_RegisterMenu(addon, infoarray)
	TitanEmoteMenu_MenuItems[addon] = infoarray;
end

--------------------------------------------
--            Titan Functions             --
--------------------------------------------

function TitanPanelEmoteMenuButton_GetButtonText(id)
	return TITAN_EMOTEMENU_MENU_BARTEXT, "";
end

function TitanPanelEmoteMenu_ToggleIconText()
	if (TitanGetVar(TITAN_EMOTEMENU_ID, "ShowIcon") == TitanGetVar(TITAN_EMOTEMENU_ID, "ShowLabelText")) then
			TitanToggleVar(TITAN_EMOTEMENU_ID, "ShowLabelText");
	else
		TitanToggleVar(TITAN_EMOTEMENU_ID, "ShowIcon");
		TitanToggleVar(TITAN_EMOTEMENU_ID, "ShowLabelText");
	end
	TitanPanelButton_UpdateButton(TITAN_EMOTEMENU_ID, 1);
end

function TitanPanelEmoteMenu_ToggleIcon()
	if ((TitanGetVar(TITAN_EMOTEMENU_ID, "ShowIcon")) and (not TitanGetVar(TITAN_EMOTEMENU_ID, "ShowLabelText"))) then
		TitanToggleVar(TITAN_EMOTEMENU_ID, "ShowLabelText");
	end
	TitanToggleVar(TITAN_EMOTEMENU_ID, "ShowIcon");
	TitanPanelButton_UpdateButton(TITAN_EMOTEMENU_ID, 1);
end

function TitanPanelEmoteMenu_ToggleText()
	if ((not TitanGetVar(TITAN_EMOTEMENU_ID, "ShowIcon")) and (TitanGetVar(TITAN_EMOTEMENU_ID, "ShowLabelText"))) then
		TitanToggleVar(TITAN_EMOTEMENU_ID, "ShowIcon");
	end
	TitanToggleVar(TITAN_EMOTEMENU_ID, "ShowLabelText");
	TitanPanelButton_UpdateButton(TITAN_EMOTEMENU_ID, 1);
end

function TitanPanelEmoteMenu_Hide()
	TitanPanel_RemoveButton(TITAN_EMOTEMENU_ID);
end

function TitanPanelEmoteMenuRight_Hide()
	TitanPanel_RemoveButton(TITAN_EMOTEMENURIGHT_ID);
end

function TitanPanelRightClickMenu_PrepareEmoteMenuMenu(level)
	if (level == 1) then 
		TitanPanelEmoteMenu_BuildRootMenu(TITAN_EMOTEMENU_ID); 
	end
	if (level == 2) then 
		TitanPanelEmoteMenu_BuildCatMenu(TITAN_EMOTEMENU_ID); 
	end
end

function TitanPanelRightClickMenu_PrepareEmoteMenuRightMenu(level)
	if (level == 1) then 
		TitanPanelEmoteMenu_BuildRootMenu(TITAN_EMOTEMENURIGHT_ID);
	end
	if (level == 2) then
		TitanPanelEmoteMenu_BuildCatMenu(TITAN_EMOTEMENURIGHT_ID);
	end
end

function TitanPanelEmoteMenu_BuildRootMenu(id)
	local level = 1;
	
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[id].menuText, level);
	TitanPanelRightClickMenu_AddSpacer(level);
	
	for key, value in EL_Types do
		local info = {};
		info.text = value;
		info.value = key;
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info, level);
	end
	
end

function TitanPanelEmoteMenu_BuildCatMenu()
	local level = 2;
	local elType = UIDROPDOWNMENU_MENU_VALUE;
	local hasTarget = UnitName("target");
	local genderCode = UnitSex("player");
	local genderHe = nil;
	local genderHis = nil;
	local genderhe = nil;
	local genderhis = nil;
	if (genderCode==0) then -- male
		genderHe = "He";
		genderhe = "he";
		genderHis = "His";
		genderhis = "his";
	else -- female (we hope)
		genderHe = "She";
		genderhe = "she";
		genderHis = "Her";
		genderhis = "her";
	end
	
	for key, value in EL_Emotes do
		for key2, value2 in value.types do
			if (elType == value2) then
				local info = {};
				if (hasTarget) then
					info.text = TitanPanelEmoteMenu_GetOnDemandText(value,true);
					info.text = string.gsub(info.text,"<Target>",hasTarget);
				else
					info.text = TitanPanelEmoteMenu_GetOnDemandText(value,false);
				end
				info.value = key;
				info.func = TitanPanelEmoteMenu_HandleModClick;
				
				info.text = string.gsub(info.text,"<He>",genderHe);
				info.text = string.gsub(info.text,"<His>",genderHis);
				info.text = string.gsub(info.text,"<he>",genderhe);
				info.text = string.gsub(info.text,"<his>",genderhis);
				
				UIDropDownMenu_AddButton(info, level);
			end		
		end
	end
end

function TitanPanelEmoteMenu_HandleModClick()
	if (this.value) then
		if (EL_Types[EL_Emotes[this.value]["types"][1]] and EL_Types[EL_Emotes[this.value]["types"][1]]=="Custom") then -- Custom emote
			local emoteText;
			local hasTarget = UnitName("target");
			local genderCode = UnitSex("player");
			local genderHe = nil;
			local genderHis = nil;
			local genderhe = nil;
			local genderhis = nil;
			if (genderCode==0) then -- male
				genderHe = "He";
				genderhe = "he";
				genderHis = "His";
				genderhis = "his";
			else -- female (we hope)
				genderHe = "She";
				genderhe = "she";
				genderHis = "Her";
				genderhis = "her";
			end
			
			if (hasTarget) then
				emoteText = EL_Emotes[this.value].target;
				emoteText = string.gsub(emoteText,"<Target>",hasTarget);
			else
				emoteText = EL_Emotes[this.value].none;
			end
			emoteText = string.gsub(emoteText,"<He>",genderHe);
			emoteText = string.gsub(emoteText,"<His>",genderHis);
			emoteText = string.gsub(emoteText,"<he>",genderhe);
			emoteText = string.gsub(emoteText,"<his>",genderhis);
			SendChatMessage(emoteText,"EMOTE");
		else
			TitanPanelEmoteMenu_PassSlashCmd("/"..this.value);
		end
	end
end

function TitanPanelEmoteMenu_GetOnDemandText(value,hasTarget)
	local color;
	local flag = nil;
	local returnCode;
	local emoteText;
	
	if (hasTarget) then emoteText = value.target; else emoteText = value.none; end
	
	if (EL_Types[value["types"][1]] and EL_Types[value["types"][1]]=="Custom") then
		emoteText = UnitName("player").." "..emoteText; -- custom emote
	end
	
	if (EL_React[value.react] == "") then 		-- None (text only) White
		color = "fffefefe";
	elseif (EL_React[value.react] == "A") then 	-- Animated - Purple
		color = "ffa335ee";
		flag = "动作";
	elseif (EL_React[value.react] == "V") then	-- Voice - Orange
		color = "ffff8000";
		flag = "声音";
	elseif (EL_React[value.react] == "AV") then -- Both - Green
		color = "ff1eff00";
		flag = "动作+声音";
	else 										-- Grey (Unknown)
		color = "ff9d9d9d";
	end	

	returnCode = "|c" .. color .. emoteText .. FONT_COLOR_CODE_CLOSE;
	if (flag) then returnCode = returnCode.." ["..flag.."]"; end
	return returnCode;
end
