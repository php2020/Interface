-- Purge entrys not seen since X weeks
-- 修改by狗血编剧男 2020.3.29
SCCN_PURGEWEEKS = 4;

-------------------------------------------------
-- DEFAULT VARIABLES
-------------------------------------------------
	if( not SCCN_storage ) then SCCN_storage = { Skyhawk = { c=7, t=123} }; end;
	if( not SCCN_mousescroll ) then SCCN_mousescroll   = 1; end;
	if( not SCCN_hidechanname ) then SCCN_hidechanname = 0; end;
	if( not SCCN_shortchanname ) then SCCN_shortchanname = 1; end;
	if( not SCCN_colornicks ) then SCCN_colornicks   = 1; end;
	if( not SCCN_topeditbox ) then SCCN_topeditbox   = 0; end;
	if( not SCCN_timestamp ) then SCCN_timestamp     = 1; end;
	if( not SCCN_hyperlinker )  then SCCN_hyperlinker = 1; end;
	if( not SCCN_selfhighlight )  then SCCN_selfhighlight = 1; end;
	if( not SCCN_clickinvite )  then SCCN_clickinvite = 1; end;
	if( not SCCN_editboxkeys )  then SCCN_editboxkeys = 1; end;
	if( not SCCN_chatstring )  then SCCN_chatstring = 1; end;
	if( not SCCN_selfhighlightmsg )  then SCCN_selfhighlightmsg = 1; end;
	if( not SCCN_SHOWLEVEL )  then SCCN_SHOWLEVEL = 1; end;
	if( not SCCN_Highlight_Text ) then SCCN_Highlight_Text = {}; end;
	if( not SCCN_Highlight ) then SCCN_Highlight = 0; end;
	if( not SCCN_AutoBGMap ) then SCCN_AutoBGMap = 0; end;
	----------------------------- 以下新增 -----------------------------------
	if( not SCCN_AutoSendWho ) then SCCN_AutoSendWho = 1; end;					-- 自动查询未知职业
	if( not SCCN_HC ) then SCCN_HC = 1; end;									-- HC播报信息汉化
	if( not SCCN_SENDWHOMESSAGE_SHOW ) then SCCN_SENDWHOMESSAGE_SHOW = 1; end;	-- 屏蔽查询信息
	----------------------------- 以上新增 -----------------------------------
	if( not SCCN_Chan_Replace ) then SCCN_Chan_Replace = {
	[1] = "公会",
	[2] = "小队",
	[3] = "官员",
	[4] = "团队",
	[5] = "World",
	[6] = "China",
	[7] = "",
	[8] = "",
	[9] = "",
	}; end;
	if( not SCCN_Chan_ReplaceWith ) then SCCN_Chan_ReplaceWith = {
	[1] = "会",
	[2] = "队",
	[3] = "官",
	[4] = "团",
	[5] = "世",
	[6] = "中",
	[7] = "",
	[8] = "",
	[9] = "",	
	}; end;
	if( not SCCN_chatsound ) then SCCN_chatsound = {[1] = 1,[2] = 2,[3] = 3,[4] = 4,[5] = 5,} end
	if( not SCCN_InChatHighlight ) then SCCN_InChatHighlight = 1; end;	
	if( not SCCN_AllSticky ) then SCCN_AllSticky = 1; end;
	if( not SCCN_NOFADE ) then SCCN_NOFADE = 0; end;
	if( not SCCN_disablewhocheck ) then SCCN_disablewhocheck = 1; end;

	SCCN_IGNORE_HNAMES = {
	"ist",
	"with",
	"duel",
	"gm",
	"fight",
	"unkown",
	"stimme",
	"won",
	"core",
	"done",
	"quest",
	"general",
    "defense",
    "party",
    "raid",
    "battleground",
    "gruppe",
    "gilde"     
	}
	
	
	-- misc
	
	ChatMOD_Loaded = true;
	SCCN_OutsideBG = 1;
	SCCNOnScreenMessage = "";
	local ChatFrame_OnEvent_Org;
	local ORG_AddMessage = nil;
	SCCN_EntrysConverted = 0;
	SCCN_INVITEFOUND = nil;
	

	SCCN_CHATPATTERN1 = "(.-)%s-: (.- .-) ([^<%-]*) ";
	SCCN_WHO_RESULTS_PATTERN = "共计%d+个玩家";
	local Hardcore = {
            --mrbcat-20230723 添加系统消息中文显示
            ['A tragedy has occurred. Hardcore character (.+) has fallen to (.+) %(level (.+)%) at level (.+). May this sacrifice not be forgotten.']    = '|cfff86256[HC]|r %4级的%1被%3级的%2成功返厂！',
            ['(.+) has reached level (.+) in Hardcore mode! Their ascendance towards immortality continues, however, so do the dangers they will face.'] = '|cfff86256[HC]|r %1克服万难成功晋升到%2级,飞升不要太简单！',
            ['A tragedy has occurred. Hardcore character (.+) has fallen in PvP to (.+) at level (.+). May this sacrifice not be forgotten.']            = '|cfff86256[PVP&HC]|r %3级的%1被%2成功送去投胎！',
            ['A tragedy has occurred. Hardcore character (.+) died of (.+) at level (.+). May this sacrifice not be forgotten.']                         = '|cfff86256[HC]|r %3级的%1错把毒药当饮料,已经噶了！',
            ['(.+) has transcended death and reached level 60 on Hardcore mode without dying once! (.+) shall henceforth be known as the lmmortal!']     = "|cfff86256[HC] %1 完成硬核挑战成功满级，成就仙人！",
            ['(.+) has transcended death and reached level 60 on Hardcore mode without dying once! (.+) shall henceforth be known as the Immortal!']     = '|cfff86256[HC] %1 完成硬核挑战成功满级，成就仙人！',
            ['Server Time: (.+)']                                                                                                                        = '服务器时间：%1',
            ['XP gain is ON']                                                                                                                            = "经验获取：开启",

    };

-- because RAID_CLASS_COLORS is not working always as intended (dont figured out why exactly) I using this.
	local SCCN_RAID_COLORS = {
		HUNTER = "|cffABD473",
		WARLOCK = "|cff9482C9",
		PRIEST = "|cffFFFFFF",
		PALADIN = "|cffF58CBA",
		MAGE = "|cff69CCFF",
		ROGUE = "|cffFFF569",
		DRUID = "|cffFF7D0A",
		SHAMAN = "|cff2773FF",
		WARRIOR = "|cffC79C6E",
		DEFAULT = "|cffa0a0a0"};
-- Some Colors
	local COLOR = { 
		RED     = "|cffff0000",
		GREEN   = "|cff10ff10",
		BLUE    = "|cff0000ff",
		MAGENTA = "|cffff00ff",
		YELLOW  = "|cffffff00",
		ORANGE  = "|cffff9c00",
		CYAN    = "|cff00ffff",
		WHITE   = "|cffffffff",
		SILVER  = "|ca0a0a0a0"
	};
	local whoTimestamp = 0;
-------------------------------------------------
-- DEFAULT FUNCTIONS
-------------------------------------------------
function solColorChatNicks_OnLoad()
	-- Register Events
		this:RegisterEvent("VARIABLES_LOADED");
		this:RegisterEvent("FRIENDLIST_UPDATE");
		this:RegisterEvent("RAID_ROSTER_UPDATE");
		this:RegisterEvent("GUILD_ROSTER_UPDATE");
		this:RegisterEvent("PARTY_MEMBERS_CHANGED");
		this:RegisterEvent("UPDATE_WORLD_STATES"); 
		this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
		this:RegisterEvent("GOSSIP_SHOW");
		this:RegisterEvent("CHAT_MSG_GUILD");
		this:RegisterEvent("CHAT_MSG_WHISPER");
		this:RegisterEvent("CHAT_MSG_OFFICER");
		this:RegisterEvent("CHAT_MSG_PARTY");
		this:RegisterEvent("CHAT_MSG_RAID");
		this:RegisterEvent("CHAT_MSG_RAID_LEADER");
		this:RegisterEvent("UNIT_FOCUS");
		this:RegisterEvent("PLAYER_TARGET_CHANGED");
		if SCCN_disablewhocheck == 1 then this:RegisterEvent("WHO_LIST_UPDATE") end;
		this:RegisterEvent("CHAT_MSG_SYSTEM");
	-- Setting Slash commands  
		SlashCmdList["SCCN"] = solColorChatNicks_SlashCommand;
		SLASH_SCCN1 = "/chatmod";
		SLASH_SCCN2 = "/sccn";
		SlashCmdList["TT"] = SCCN_CMD_TT;
		SLASH_TT1 = "/wt";  
		SlashCmdList["clear"] = SCCNclearChat;
		SLASH_clear1 = "/cls";
		SLASH_clear2 = "/clear";
		table.insert(UISpecialFrames, "SCCNConfigForm")
	--聊天框初始默认位置
		for i=1, NUM_CHAT_WINDOWS do
			FCF_DockUpdate()
		end
		ChatFrame1:ClearAllPoints();
		ChatFrame1:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 5, 30);
		ChatFrame1:SetWidth(300);
		ChatFrame1:SetHeight(120);
		ChatFrame1:SetUserPlaced(1)
	--屏蔽红字
	    ErrorRedirect_IsEnabled = true;
	    ErrorRedirect_Frame = "";

	    ErrorRedirect_Org_AddMessage = UIErrorsFrame.AddMessage;
	    UIErrorsFrame.AddMessage = ErrorRedirect_AddMessage;
----------------------------- 以下新增 -----------------------------------
	--避免查询窗口弹出
		FriendsFrame_OnEvent_Org = FriendsFrame_OnEvent;
		FriendsFrame_OnEvent = SCCN_FriendsFrame_OnEvent;
----------------------------- 以上新增 -----------------------------------
end

function solColorChatNicks_OnEvent(event)
 if strsub(event, 1, 16) == "VARIABLES_LOADED" then
		-- Fade controll
		if SCCN_NOFADE == 1 then
			SCCNnofade();
		end
		-- confab compatibility
		if ( CONFAB_VERSION ) then
			SCCN_write(SCCN_CONFAB);
			SCCN_topeditbox   = 9;
		else
			-- top editbox
			SCCN_EditBox(SCCN_topeditbox);
		end

        if SendChatMessage_Org == nil then
            SendChatMessage_Org = SendChatMessage
            SendChatMessage = ChatMOD_SendChatMessage
        end

		if ChatFrame_OnEvent_Org == nil then
			ChatFrame_OnEvent_Org = ChatFrame_OnEvent;
			ChatFrame_OnEvent = solColorChatNicks_ChatFrame_OnEvent;
		  	-- Sticky 
			ChatMOD_sticky(SCCN_AllSticky);
		end
		if( SCCN_hyperlinker == 1 ) then
		  -- catches URL's
			SCCN_Org_SetItemRef = SetItemRef;
			SetItemRef = SCCN_SetItemRef;
		end
		if Chronos == nil then
			-- no chronos, direct purge
			SCCN_write(" ");
			-- doing auto purge event
			solColorChatNicks_PurgeDB();
			-- DKP Table MOD Workaround.. Need Chronos
			if( DKPT_ChatFrame_OnEvent ~= nil ) then
				SCCN_write("Incompatible DKP_Table Addon found!\nYou need to install TimeX or Chronos to let ChatMod still work!!!!");
			end			
		else
			Chronos.schedule(3,SCCN_write," ");
			-- doing auto purge event 30 sec delayed
			Chronos.schedule(5,solColorChatNicks_PurgeDB);
			-- DKP Table MOD Workaround.. Need Chronos
			if( DKPT_ChatFrame_OnEvent ~= nil ) then
				SCCN_write("DKP_Table Addon found! Starting Workaround Fix in 20 sec... (This needs Chronos)");
				Chronos.schedule(20,SCCN_DKPTABLE_WORKAROUND);
			end		
		end
		-- refill
		if IsInGuild() then GuildRoster(); end
		if GetNumFriends() > 0 then ShowFriends(); end
		-- store original chat Editbox history buffer size
		SCCN_EditBoxKeysToggle(SCCN_editboxkeys);
		-- replacing chat some customized strings
		SCCN_CustomizeChatString(SCCN_chatstring);
		-- config dialog fillin
		SCCN_Config_OnLoad();
		-- Sound dialog setup
		SCCN_CHATSOUND_ONLOAD();
 elseif ( event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_OFFICER" or event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER") then
		local msgtype = string.sub (event, 10)
		if SCCN_chatsound then
			if ( SCCN_chatsound[1] or SCCN_chatsound[2] or SCCN_chatsound[3] or SCCN_chatsound[4] or SCCN_chatsound[5] ) then
				if msgtype then
						if( SCCN_chatsound[5] > 0 and msgtype == "WHISPER" ) then
							SCCN_PLAYSOUND(SCCN_chatsound[5]);
						elseif( SCCN_chatsound[4] > 0 and msgtype == "RAID" ) then
							SCCN_PLAYSOUND(SCCN_chatsound[4]);
						elseif( SCCN_chatsound[3] > 0 and msgtype == "PARTY" ) then
							SCCN_PLAYSOUND(SCCN_chatsound[3]);
						elseif( SCCN_chatsound[2] > 0 and msgtype == "OFFICER" ) then
							SCCN_PLAYSOUND(SCCN_chatsound[2]);
						elseif( SCCN_chatsound[1] > 0 and msgtype == "GUILD" ) then
							SCCN_PLAYSOUND(SCCN_chatsound[1]);
						end
				end
			end
		end
 elseif strsub(event, 1, 17) == "FRIENDLIST_UPDATE" then
	solColorChatNicks_InsertFriends();	
 elseif strsub(event, 1, 19) == "GUILD_ROSTER_UPDATE" then
	solColorChatNicks_InsertGuildMembers();
 elseif strsub(event, 1, 21) == "ZONE_CHANGED_NEW_AREA" then
	SCCN_BG_AutoMap();
 elseif event == "UNIT_FOCUS" or event == "PLAYER_TARGET_CHANGED" then
		solColorChatNicks_InsertTarget();
 elseif event == "WHO_LIST_UPDATE" and SCCN_disablewhocheck == 1 then
		solColorChatNicks_InsertWhoList();
 elseif event == "CHAT_MSG_SYSTEM" and SCCN_disablewhocheck == 1 then
		solColorChatNicks_InsertWhoText(arg1);
 end
end

function SCCN_DKPTABLE_WORKAROUND() 
	ChatFrame_OnEvent_Org = DKPT_ChatFrame_OnEvent;
	ChatFrame_OnEvent = solColorChatNicks_ChatFrame_OnEvent;
	SCCN_write("DKP_Table fix applied.");
end


function solColorChatNicks_PurgeDB()
	SCCN_purged = 0;
	SCCN_keept  = 0;
	SCCN_EntrysConverted = 0;
	SCCN_OldStorage = SCCN_storage;
	SCCN_storage = nil;
	SCCN_storage = {};
	table.foreach(SCCN_OldStorage, solColorChatNicks_PurgeEntry);
	if( SCCN_EntrysConverted > 0 ) then
		SCCN_write("Purged: "..SCCN_purged..", Keept: "..SCCN_keept.." Converted to ".." :"..SCCN_EntrysConverted);
		SCCN_EntrysConverted = nil;
	else
		SCCN_write("|CFF00FF00ChatMOD");
	end	
	SCCN_OldStorage = nil;
	SCCN_purged = nil;
	SCCN_keept  = nil;
end

function solColorChatNicks_PurgeEntry(k,v)
		if( (SCCN_OldStorage[k]["t"] + (3600*24*7*SCCN_PURGEWEEKS) ) < time() ) then 
			SCCN_purged = SCCN_purged + 1;
		else
			local keyName = ChatMOD_prepName(k);
			SCCN_storage[keyName] = { t=SCCN_OldStorage[k]["t"], c=SCCN_OldStorage[k]["c"], l=SCCN_OldStorage[k]["l"] }
			SCCN_keept = SCCN_keept + 1;
		end
end

function ChatMOD_prepName(name)
	if name then 
		return string.lower(name)
	end
end

function SCCN_write(msg)
	if( msg ~= nil ) then
		DEFAULT_CHAT_FRAME:AddMessage(" "..msg);
	end
end

function ChatMOD_sticky(state)
			if state == 1 then
				ChatTypeInfo["SAY"].sticky 		= 1;
				ChatTypeInfo["PARTY"].sticky 	= 1;
				ChatTypeInfo["GUILD"].sticky 	= 1;
				ChatTypeInfo["WHISPER"].sticky 	= 0; -- Use the 'R' key ;p 
				ChatTypeInfo["RAID"].sticky 	= 1;
				ChatTypeInfo["OFFICER"].sticky 	= 1;
				ChatTypeInfo["CHANNEL"].sticky 	= 1;
				ChatTypeInfo["CHANNEL1"].sticky 	= 1;
				ChatTypeInfo["CHANNEL2"].sticky 	= 1;
				ChatTypeInfo["CHANNEL3"].sticky 	= 1;
				ChatTypeInfo["CHANNEL4"].sticky 	= 1;
				ChatTypeInfo["CHANNEL5"].sticky 	= 1;
				ChatTypeInfo["CHANNEL6"].sticky 	= 1;
				ChatTypeInfo["CHANNEL7"].sticky 	= 1;
				ChatTypeInfo["CHANNEL8"].sticky 	= 1;
				ChatTypeInfo["CHANNEL9"].sticky 	= 1;
			else
				-- blizzards default stiky behavior
				ChatTypeInfo["SAY"].sticky 		= 1;
				ChatTypeInfo["PARTY"].sticky 	= 1;
				ChatTypeInfo["GUILD"].sticky 	= 1;
				ChatTypeInfo["WHISPER"].sticky 	= 0;
				ChatTypeInfo["RAID"].sticky 	= 1;
				ChatTypeInfo["OFFICER"].sticky 	= 0;
				ChatTypeInfo["CHANNEL"].sticky 	= 0;
				ChatTypeInfo["CHANNEL1"].sticky 	= 0;
				ChatTypeInfo["CHANNEL2"].sticky 	= 0;
				ChatTypeInfo["CHANNEL3"].sticky 	= 0;
				ChatTypeInfo["CHANNEL4"].sticky 	= 0;
				ChatTypeInfo["CHANNEL5"].sticky 	= 0;
				ChatTypeInfo["CHANNEL6"].sticky 	= 0;
				ChatTypeInfo["CHANNEL7"].sticky 	= 0;
				ChatTypeInfo["CHANNEL8"].sticky 	= 0;
				ChatTypeInfo["CHANNEL9"].sticky 	= 0;
			end	
end

-------------------------------------------------
-- CHAT FRAME MANIPULATION FUNCTIONS
-------------------------------------------------
function SCCNclearChat()
	local chatFrame;
	for i = 1, 7 do
		chatFrame = getglobal("ChatFrame"..i);
		if( (chatFrame ~= nil) and chatFrame:IsVisible() ) then
			chatFrame:Clear();
		end
	end
end

function SCCNnofade()
	if SCCN_NOFADE == 1 then
		for i=1,7 do
			local frame = getglobal("ChatFrame"..i)
			frame:SetFading(0)
			frame:SetTimeVisible(3600)
		end
	else
		for i=1,7 do
			local frame = getglobal("ChatFrame"..i)
			frame:SetFading(1)
			frame:SetTimeVisible(300)
		end	
	end
end

----------------------------- 以下新增 -----------------------------------
function SCCN_FriendsFrame_OnEvent()
	-- suppress pop up of who window if to many results if we send the who request
	if not (event == "WHO_LIST_UPDATE" and (GetTime() - whoTimestamp) < 3) then
	  	FriendsFrame_OnEvent_Org();
	end
end
----------------------------- 以上新增 -----------------------------------

function solColorChatNicks_ChatFrame_OnEvent(event)
		if( not this.ORG_AddMessage ) then
			this.ORG_AddMessage = this.AddMessage
			this.AddMessage = S_AddMessage
		end;
		if SCCN_colornicks == 1 then 
			this.solColorChatNicks_Name = arg2;
		end
		-- Strip channel name
		if arg9 and event ~= nil and event ~= "CHAT_MSG_CHANNEL_NOTICE" then
			local _, _, strippedChannelName = string.find(arg9, "(.-)%s.*");
			this.solColorChatNicks_Channelname = strippedChannelName;
		end
	 -- Call original handler
----------------------------- 以下新增 -----------------------------------
	if (SCCN_SENDWHOMESSAGE_SHOW == 1) then
		if not ( event == "CHAT_MSG_SYSTEM" 
			and (GetTime() - whoTimestamp) < 3 
			and (string.find(arg1, SCCN_CHATPATTERN1) or string.find(arg1, SCCN_WHO_RESULTS_PATTERN)) ) then
				ChatFrame_OnEvent_Org(event);
		end
	else
----------------------------- 以上新增 -----------------------------------
		if event and ChatFrame_OnEvent_Org then ChatFrame_OnEvent_Org(event); end;
	end
end


function S_AddMessage(this,text,r,g,b,id)
	
	if text and event and string.find(event,"CHAT_MSG") then
		-- Check to Ignore / Hide spam of GEM and CTRA / CastParty
		-- this:ORG_AddMessage(text,r,g,b,id);
		local SkipMessage = false;
		if text then
			if string.find(text, "<GEM%d*%p%d*>") 	then SkipMessage = true end;   	-- Guild Event Manager
			if string.find(text, "SYNCE_") 			then SkipMessage = true end;	-- Damage Meters
			if string.find(text, "SYNC_") 			then SkipMessage = true end;	-- Damage Meters
			if string.find(text, "<HA%d>%d*") 		then SkipMessage = true end;	-- Heal Assist
			if string.find(text, "RN%s%d*%s%d*%s%d*") 		then SkipMessage = true end;	-- RA
			if string.find(text, "KLHTM%s")			then SkipMessage = true end; 	-- KLH Threat Meter
			if string.find(text, "%s<CECB>%s") 		then SkipMessage = true end;   	-- CECB
		end
		if text == nil or SkipMessage == true then
			-- this:ORG_AddMessage(text,r,g,b,id);
			SkipMessage = false;
			return false;
		end
		-- ChatLink Support
    	-- if string.find(text, "CLINK") then
	--	  text = string.gsub (text, "{CLINK:(%x+):(%d-):(%d-):(%d-):(%d-):([^}]-)}", "|c%1|Hitem:%2:%3:%4:%5|h[%6]|h|r")
	--  end
	----------------------------- 以下新增 -----------------------------------
        if(SCCN_HC == 1 and text ~= nil) then
			SCCN_HC_CHARACTER = nil;
			for k,v in pairs(Hardcore) do
				text = string.gsub(text, k, v);
			end
		end
	----------------------------- 以上新增 -----------------------------------
		-- URL detection
		if( SCCN_hyperlinker == 1 and text ~= nil ) then
			-- local tmptext = text;
			SCCN_URLFOUND = nil;
			-- numeric IP's 123.123.123.123:12345
			if SCCN_URLFOUND == nil then text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)", SCCN_GetURL); end;
			-- TeamSpeak like IP's sub.domain.org:12345 or domain.de:123
			if SCCN_URLFOUND == nil then text = string.gsub(text, "(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)", SCCN_GetURL); end;
			-- complete http urls
			if SCCN_URLFOUND == nil then text = string.gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", SCCN_GetURL); end;
			-- www.URL.de
			if SCCN_URLFOUND == nil then text = string.gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", SCCN_GetURL); end;
			-- test@test.de
			if SCCN_URLFOUND == nil then text = string.gsub(text, "(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)", SCCN_GetURL); end;
		end	  
		-- clickinvite
		if( SCCN_clickinvite == 1 and text ~= nil and arg2 ~= nil ) then
		 SCCN_INVITEFOUND = nil; 
		 -- invite
		 if SCCN_INVITEFOUND == nil then text = string.gsub(text, "%s+(invite)(.?)", SCCN_ClickInvite,1); end
		 if SCCN_INVITEFOUND == nil then text = string.gsub(text, "%s+(inv)(.?)", SCCN_ClickInvite,1); end
		 if SCCN_INVITEFOUND == nil and SCCN_CUSTOM_INV ~= nil then
				-- custom invite word in localization
			for i=0, table.getn(SCCN_CUSTOM_INV) do
				if SCCN_INVITEFOUND == nil then text = string.gsub(text, "%s+("..SCCN_CUSTOM_INV[i]..")(.?)", SCCN_ClickInvite,1); end
			end
		 end
		end		

		-- Name Highlight
		if text and SCCN_InChatHighlight == 1 and arg8 ~= 3 and arg8 ~= 4 and SCCN_URLFOUND == nil and SCCN_INVITEFOUND == nil then
			local rWord = "";
			for rWord in string.gfind(text, "%a+") do
				if string.len(rWord) > 3 and string.find(rWord,"^%x*$") == nil and string.find(rWord,"^%a*$") ~= nil then
					if SCCN_selfhighlight == 1 and ( rWord == UnitName("player") or rWord == string.lower(UnitName("player")) )then
					-- blub
					else
						-- check if name blacklisted if yes skip this name
						local temp = string.lower(rWord);
						if SCCN_IGNORE_HNAMES[temp] ~= 1 then
							local xName = SCCN_ForgottenChatNickName(rWord);
							if (string.len(xName)-string.len(rWord)) > 3 then
								xName = "|Hplayer:"..rWord.."|h"..xName.."|h";
								text = string.gsub(text,"%s"..rWord.."([^%]%d%a])"," "..xName.."|r%1");
							end
						end
					end
				end
			end
		end	  
			  
		if SCCN_hidechanname == 1 and this.solColorChatNicks_Channelname then
			-- Remove channel name	
			text = string.gsub(text, ".%s" .. this.solColorChatNicks_Channelname, "", 1);
			this.solColorChatNicks_Channelname = nil;	  
		end
		if ( (SCCN_hidechanname == 1) and text ~= nil ) then  
			-- Strip custom Channels
			local text_new = string.gsub(text,"%[(%d*)%p%s(%a*)%]%s",SCCN_STRIPCHANNAMEFUNC_NEW);
			if text_new ~= nil and text ~= text_new then
				text = text_new;
			else
				--remove Guild, Party, Raid from chat channel name  
				for i=1, table.getn(SCCN_STRIPCHAN) do
					text = string.gsub(text, "(%[)(%d?)(.?%s?"..SCCN_STRIPCHAN[i].."%s?)(%])(%s?)", SCCN_STRIPCHANNAMEFUNC,1);
				end
			end
		elseif ( SCCN_shortchanname == 1 ) then
			-- Short Channel Names
			local temp = nil;
			if text ~= nil then
				for i = 1, 9 do
					if SCCN_Chan_Replace[i] ~= nil and SCCN_Chan_ReplaceWith[i] ~= nil then
						temp = string.gsub(text, SCCN_Chan_Replace[i].."]%s", SCCN_Chan_ReplaceWith[i].."]", 1)
						if temp ~= text then
							text = temp;
							temp = nil;
							break;
						end
					end		
				end
			end
		end
			
		-- color self in text
		if( SCCN_selfhighlight == 1 and text ~= nil ) then
			if( arg8 ~= 3 and arg8 ~= 4 ) then
				if( arg2 ~= nil and arg2 ~= UnitName("player") and UnitName("player") ~= nil and string.len(text) >= string.len(UnitName("player")) ) then
					if string.find(string.lower(text), string.lower(UnitName("player"))) then
						text = string.gsub(text, "[^:^%[]".."(" .. UnitName("player") ..")" , " "..COLOR["YELLOW"]..">"..COLOR["RED"].." %1 "..COLOR["YELLOW"].."<|r");
						text = string.gsub(text, "[^:^%[]".."(" .. string.lower(UnitName("player")) ..")" , " "..COLOR["YELLOW"]..">"..COLOR["RED"].." %1 "..COLOR["YELLOW"].."<|r");
						-- On Screen Msg
						if( SCCN_selfhighlightmsg == 1 ) then
							if SCCNOnScreenMessage ~= text then
								-- anti spam, twice line output fix
								SCCNOnScreenMessage = text;
								UIErrorsFrame:AddMessage(text, 1, 1, 1, 1.0, UIERRORS_HOLD_TIME);
								PlaySound("FriendJoinGame");
							end
						end
					end
				end
			end
		end

		-- Custom Highlight /SCCN highlight
		SCCN_Custom_Highlighted = false;
		if SCCN_Custom_Highlighted == false then text = SCCN_CustomHighlightProcessor(text,SCCN_Highlight_Text[1]); end;
		if SCCN_Custom_Highlighted == false then text = SCCN_CustomHighlightProcessor(text,SCCN_Highlight_Text[2]); end;
		if SCCN_Custom_Highlighted == false then text = SCCN_CustomHighlightProcessor(text,SCCN_Highlight_Text[3]); end;
		if SCCN_Custom_Highlighted == false then text = SCCN_CustomHighlightProcessor(text,SCCN_Highlight_Text[4]); end;
		if SCCN_Custom_Highlighted == false then text = SCCN_CustomHighlightProcessor(text,SCCN_Highlight_Text[5]); end;
		-- color nick's
		if this.solColorChatNicks_Name and string.len(this.solColorChatNicks_Name) > 2 and text ~= nil and arg2 ~= nil then
			local outputName = this.solColorChatNicks_Name;
			if( SCCN_SHOWLEVEL == 1 ) then
				local LOWname = ChatMOD_prepName(this.solColorChatNicks_Name);
				local level = nil;
				if( LOWname ~= nil and string.len(LOWname) > 2 ) then
				----------------------------- 以下新增 -----------------------------------
					if ( SCCN_storage[LOWname] ~= nil ) then
						level = tonumber(SCCN_storage[LOWname]["l"]);
					elseif( SCCN_AutoSendWho == 1) then
						local Name = string.gsub(text, ".*|Hplayer:(.-)|h.*", "%1")
						if (Name ~= text) then
							SendWho(Name)
							whoTimestamp = GetTime();
						end
					end;
				----------------------------- 以下新增 -----------------------------------	
					if ( level ~= nil and SCCN_SHOWLEVEL == 1 ) then	-- and level < 60
						outputName = level.." "..this.solColorChatNicks_Name;
					end
				end;
			end;
			local temp = string.lower(this.solColorChatNicks_Name);
			if SCCN_IGNORE_HNAMES[temp] ~= 1 then
                if string.len(solColorChatNicks_GetColorFor(this.solColorChatNicks_Name)) > 3	 then
			       text = string.gsub(text, "(.-)"..this.solColorChatNicks_Name .. "([%]%s].*)", "%1|r"..solColorChatNicks_GetColorFor(this.solColorChatNicks_Name)..outputName.."|r%2", 1);
				end;
			end
		end
		this.solColorChatNicks_Name = nil;
		-- Timestamp
		if( SCCN_timestamp == 1 and text ~= nil ) then
			local time = date("%H:%M");
			timestamp = "|Hezc:"..UnlinkMessage(text).."|h["..time.."]|h ";
			text = "|CFF33CCFF"..timestamp.."|r"..text;
		end
	end	
	-- output
	if (this.ORG_AddMessage ~= nil) then
		this:ORG_AddMessage(text,r,g,b,id);
	end
end

function UnlinkMessage(linkedmessage)
	local message = linkedmessage;
	local part1 = "";
	local part2 = "";
	local part3 = "";
	local pos   = 0;
	local lenbef= strlen(message);
	if (strfind(message,"|c")~=nil) then
		local done = false;
		message = gsub(message,"|r","");
		repeat
			part1 = message;
			pos   = strfind(message,"|c");
			part2 = strsub (part1,pos+10);
			part1 = strsub (part1,1,pos-1);
			message=part1..part2;
			if (strfind(message,"|c") == nil) then
				done = true;
			end
		until (done == true);
	end
	if (strfind(message,"|H")~=nil) then
		local done = false;
		repeat
			part1 = message;
			pos   = strfind(part1,"|H");
			part2 = strsub (part1,pos+2);
			part1 = strsub (part1,1,pos-1);
			pos   = strfind(part2,"|h");
			part2 = strsub (part2,pos+2);
			pos   = strfind(part2,"|h");
			part3 = strsub (part2,pos+2);
			part2 = strsub (part2,1,pos-1);
			message=part1..part2..part3;
			if (strfind(message,"|H") == nil) then
				done = true;
			end
		until (done == true);
	end
	message=gsub(message,"/","/1");
	message=gsub(message,"|","/2");
	return message;
end

function SCCN_CustomHighlightProcessor(text,SCCN_Custom_Highlight_Word)
	if SCCN_Custom_Highlight_Word and text and SCCN_Highlight == 1 then
		if ( string.len(text) >= string.len(SCCN_Custom_Highlight_Word) and string.len(SCCN_Custom_Highlight_Word) > 2 ) then 
			if ( string.find(string.lower(text),string.lower(SCCN_Custom_Highlight_Word)) or string.find(text,SCCN_Custom_Highlight_Word) ) then
				if( text ~= string.gsub(text, "([^:^%[]"..SCCN_Custom_Highlight_Word..")" , "")) then
					text = string.gsub(text, "([^:^%[])"..SCCN_Custom_Highlight_Word, "%1"..COLOR["YELLOW"]..">|r"..COLOR["RED"]..SCCN_Custom_Highlight_Word.."|r"..COLOR["YELLOW"].."<|r");
					
				else
					text = string.gsub(text, "([^:^%[])"..string.lower(SCCN_Custom_Highlight_Word), "%1"..COLOR["YELLOW"]..">|r"..COLOR["RED"]..string.lower(SCCN_Custom_Highlight_Word).."|r"..COLOR["YELLOW"].."<|r");
				end
				-- On Screen Msg
				if( SCCN_selfhighlightmsg == 1 ) then	
					-- NO CTRA and NO DMSYNC
					name = string.gsub(text, ".*|Hplayer:(.-)|h.*", "%1")
					if name ~= nil then 
						LOWname = ChatMOD_prepName(name);
						outputName = LOWname;
						-- Check if unit name exists in storage
						if( SCCN_storage[LOWname] ~= nil ) then
							level = tonumber(SCCN_storage[LOWname]["l"]);
							if ( level ~= nil and SCCN_SHOWLEVEL == 1 ) then	-- and level < 60
								outputName = level.." ".. LOWname;
							end
							color = solColorChatNicks_GetClassColor(SCCN_storage[LOWname]["c"]);
							-- print("------------------ * * * * * ------------------");
							print("*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  * ");
							text = string.gsub(text, "(.-)"..name .. "([%]%s].*)", "%1|r"..solColorChatNicks_GetColorFor(name) .. outputName .. "|r%2", 1);
						end

					end
					
					UIErrorsFrame:AddMessage(text, 1, 1, 1, 1.0, UIERRORS_HOLD_TIME);
					PlaySound("FriendJoinGame");
				end
				-- set already highlighted = True
				SCCN_Custom_Highlighted = true;
			end
		end
		return text;
	else
		return text;
	end
end

function SCCN_OnMouseWheel(chatframe, value)
  if( SCCN_mousescroll == 1 ) then
	if IsShiftKeyDown()  then
		-- shift key pressed (Fast scroll)  
		if ( value > 0 ) then
			for i = 1,5 do chatframe:ScrollUp(); end;
		elseif ( value < 0 ) then
			for i = 1,5 do chatframe:ScrollDown(); end;
		end
	elseif IsControlKeyDown() then
		-- to top / to bottom
		if ( value > 0 ) then
			chatframe:ScrollToTop();
		elseif ( value < 0 ) then
			chatframe:ScrollToBottom();
		end		
	else
		-- Normal Scroll without shift key  
		if ( value > 0 ) then
			chatframe:ScrollUp();
		elseif ( value < 0 ) then
			chatframe:ScrollDown();
		end
    end 
  end
end  

function ChatMOD_SendChatMessage (msg, ...)
	-- Pass along to original function.
	SendChatMessage_Org (msg, unpack (arg))
 end


function SCCN_EditBox(where)
	if(where == 1) then
		-- top
		ChatFrameEditBox:ClearAllPoints();
		ChatFrameEditBox:SetPoint("BOTTOMLEFT", "ChatFrame1", "TOPLEFT", -5, 20);
		ChatFrameEditBox:SetPoint("BOTTOMRIGHT", "ChatFrame1", "TOPRIGHT", -5, 20);
	elseif(where == 0) then
		-- bottom
		-- ChatFrameEditBox:ClearAllPoints();
		ChatFrameEditBox:SetPoint("BOTTOMLEFT", "ChatFrame1", "BOTTOMLEFT", -5, -30);
		ChatFrameEditBox:SetPoint("BOTTOMRIGHT", "ChatFrame1", "BOTTOMRIGHT", -5, -30);
	end
end

function SCCN_CustomizeChatString(status)
	if OLD_CHAT_WHISPER_GET == nil then OLD_CHAT_WHISPER_GET = CHAT_WHISPER_GET; end
	if OLD_CHAT_WHISPER_INFORM_GET == nil then OLD_CHAT_WHISPER_INFORM_GET = CHAT_WHISPER_INFORM_GET; end;
	if( status == 1 ) then
		CHAT_WHISPER_GET = SCCN_CUSTOM_CHT_FROM.." ";
		CHAT_WHISPER_INFORM_GET = SCCN_CUSTOM_CHT_TO.." ";
	else
		-- restore original
		CHAT_WHISPER_GET = OLD_CHAT_WHISPER_GET;
		CHAT_WHISPER_INFORM_GET = OLD_CHAT_WHISPER_INFORM_GET;
	end
end

function SCCN_EditBoxKeysToggle(status)
	if SCCN_OrgHistoryLines == nil then SCCN_OrgHistoryLines = ChatFrameEditBox:GetHistoryLines(); end
	if( status == 1 ) then
		ChatFrameEditBox:SetHistoryLines(250);
		ChatFrameEditBox:SetAltArrowKeyMode(false);
	else
		-- restore original
		ChatFrameEditBox:SetHistoryLines(16);
		ChatFrameEditBox:SetHistoryLines(SCCN_OrgHistoryLines);
		ChatFrameEditBox:SetAltArrowKeyMode(true);
	end		
end

function SCCN_STRIPCHANNAMEFUNC(a,b,c,d,e)
	-- a = (%[)
	-- b = (%d?)
	-- c = (.?%s?"..SCCN_STRIPCHAN[i].."%]%s?)
	-- d = (%])
	-- e = (%s?)
	if(SCCN_hidechanname == 1) then 
		if(c ~= nil and string.find(c,"%.") ) then
			return a..b..d..e;
		else
			return;
		end
	end
	--getglobal("SCCNConfigForm".."ver1".."Label"):SetText(COLOR["RED"].."A["..COLOR["WHITE"]..a..COLOR["RED"].."] B["..COLOR["WHITE"]..b..COLOR["RED"].."] C["..COLOR["WHITE"]..c..COLOR["RED"].."] D["..COLOR["WHITE"]..d..COLOR["RED"].."]");
end

function SCCN_STRIPCHANNAMEFUNC_NEW(Num,Name)
	return "|Hscn:["..Num.."] = ["..Num..". "..Name.."]|h["..Num.."]|h ";
end

-- 聊天框标签材质清除
-- hooksecurefunc("FCF_SetTabPosition", function(f, x)
-- 	local tab = _G[f:GetName()..'Tab']
-- 	local a, b, c = tab:GetRegions()
-- 	local d = _G[f:GetName()..'TabFlash']:GetRegions()
	
-- 	for _, v in pairs({a, b, c}) do 
-- 		v:Hide()
-- 		v:SetWidth(5)
-- 	end

-- 	d:SetTexture()
-- 	tab:GetHighlightTexture():SetTexture()
-- end)

function SCCN_ChatFrame_OnUpdate()
   local frame3 = this:GetParent():GetName().."BottomButton";
   local frame4 = this:GetParent():GetName();
	   if ( (getglobal(frame4)):AtBottom() ) then
	   if (getglobal(frame3)):IsVisible() then
			getglobal(frame3):Hide();
   end
       else
		getglobal(frame3):Show()
   end
	
   local DownButton	= getglobal(this:GetParent():GetName().."DownButton");
   local UpButton	= getglobal(this:GetParent():GetName().."UpButton");
   DownButton:Hide()
   UpButton:Hide()
end

--渐隐按钮
function EnableAutohide(frame, timeout)
	if not frame then return end

	frame.hover = frame.hover or CreateFrame("Frame", frame:GetName() .. "Autohide", frame)
	frame.hover:SetParent(frame)
	frame.hover:SetAllPoints(frame)
	frame.hover.parent = frame
	frame.hover:Show()

	local timeout = timeout
	frame.hover:SetScript("OnUpdate", function()
		if MouseIsOver(this, 50, -50, -50, 50) then
			this.activeTo = GetTime() + timeout
			this.parent:SetAlpha(1)
		elseif this.activeTo then
			if this.activeTo < GetTime() and this.parent:GetAlpha() > 0 then
				this.parent:SetAlpha(this.parent:GetAlpha() - 0.1)
			end
		else
			this.activeTo = GetTime() + timeout
		end
	end)
end

function SCCN_ChatFrame_OnLoad()
	--“到最底部”按钮的位置
	local frame1 = this:GetParent():GetName().."BottomButton"
	local frame2 = this:GetParent():GetName()
	getglobal(frame1):SetPoint("RIGHT", getglobal(frame2), "RIGHT", 0, 0)
	getglobal(frame1):SetPoint("LEFT", getglobal(frame2), "RIGHT", -25, 0)
	getglobal(frame1):SetPoint("TOP", getglobal(frame2), "BOTTOM", 0, 20)
	getglobal(frame1):SetPoint("BOTTOM", getglobal(frame2), "BOTTOM", 0, 0)
	
	--“菜单”按钮的位置
	ChatFrameMenuButton:ClearAllPoints() 
	ChatFrameMenuButton:SetPoint('BOTTOMRIGHT', ChatFrame1, 'TOPRIGHT', 5, 0)
	ChatFrameMenuButton:SetScale(.85)
	EnableAutohide(ChatFrameMenuButton, 0.5)
end

function SCCN_KeyBinding_ChatFrameEditBox(kommando)
	if (not ChatFrameEditBox:IsVisible()) then
		ChatFrame_OpenChat(kommando);
	else
		ChatFrameEditBox:SetText(kommando);
	end;
	ChatFrameEditBox:Show();
	ChatEdit_ParseText(ChatFrame1.editBox,0);
end

function SCCN_SET_CHAT_TO(prefix)
		prefix = "/"..prefix.." "
    	if ChatFrameEditBox:IsVisible() then
    		ChatFrameEditBox:SetText(prefix);
        else
            ChatFrame_OpenChat(prefix);
        end;
        ChatEdit_ParseText(ChatFrame1.editBox, 0);
end

-------------------------------------------------
-- MOD INTERFACE FOR 3rd PARTY MODS
-------------------------------------------------
function SCCN_ForgottenChatNickName(Name)
	if Name then
		local FCcolor = solColorChatNicks_GetColorFor(Name);
		if( FCcolor ~= nil ) then
			return solColorChatNicks_GetColorFor(Name)..Name.."|r";
		else
			return Name;
		end
	end
end

-------------------------------------------------
-- INFORMATION GATHERING FUNCTIONS
-------------------------------------------------
-- Color management
function solColorChatNicks_GetColorFor(name)
	-- Default color
	local color = "";
	-- lowercase
	local LOWname = ChatMOD_prepName(name);
	-- Check if unit name exists in storage
	if( SCCN_storage[LOWname] ~= nil ) then
		color = solColorChatNicks_GetClassColor(SCCN_storage[LOWname]["c"]);
	elseif( name == UnitName("player") ) then
	 -- You are the person. That's easy
		local _, class = UnitClass("player");
		local class = solColorChatNicks_ClassToNum(class);
		local level = UnitLevel("player")
		color = solColorChatNicks_GetClassColor(class);
		SCCN_storage[LOWname] = { c = class, t=time(), l = level  };
	end
   
	return color;
end
		
function solColorChatNicks_InsertFriends()
  -- add current online friends
  for i = 1, GetNumFriends() do
    local name, level, class = GetFriendInfo(i);
	local LOWname = ChatMOD_prepName(name);
	local class = solColorChatNicks_ClassToNum(class);
	if( class ~= nil and name ~= nil and class > 0 ) then
		SCCN_storage[LOWname] = { c = class, t=time(), l = level };
	end
  end
end	

function solColorChatNicks_InsertGuildMembers()
  -- add current online guild members
  for i = 1, GetNumGuildMembers() do
	local name,_,_,level,class = GetGuildRosterInfo(i);
	local LOWname = ChatMOD_prepName(name);
	local class = solColorChatNicks_ClassToNum(class);
	if( class ~= nil and name ~= nil and class > 0 ) then
		SCCN_storage[LOWname] = { c = class, t=time(), l = level };
	end
  end
end

function solColorChatNicks_InsertRaidMembers()
  for i = 1, GetNumRaidMembers() do
    local name, _, _, level, class = GetRaidRosterInfo(i);
	local LOWname = ChatMOD_prepName(name);
	local class = solColorChatNicks_ClassToNum(class);
	if( class ~= nil and name ~= nil and class > 0 ) then
		SCCN_storage[LOWname] = { c = class, t=time(), l = level };
	end
  end	
end

function solColorChatNicks_InsertPartyMembers()
  for i = 1, GetNumPartyMembers() do
    local unit = "party" .. i;
	local level = UnitLevel(unit)
    local _, class = UnitClass(unit);
	local name     = UnitName(unit);
	local LOWname = ChatMOD_prepName(name);
 	local class    = solColorChatNicks_ClassToNum(class);
	if( class ~= nil and name ~= nil and class > 0) then
		SCCN_storage[LOWname] = { c = class, t=time(), l = level  };
	end   
  end	
end

function solColorChatNicks_InsertTarget()
	local _, classname = UnitClass("target");
	local name = UnitName("target");
	local level = UnitLevel("target");
	local LOWname = ChatMOD_prepName(name);
	local class = solColorChatNicks_ClassToNum(classname);
	if( class ~= nil and name ~= nil and UnitIsPlayer("target") and class > 0) then
		SCCN_storage[LOWname] = { c = class, t=time(), l = level };
	end
end

function solColorChatNicks_InsertWhoList()
	local numWhoResults = GetNumWhoResults();
	for i = 1, numWhoResults, 1 do
		local name, _, level, _, classname = GetWhoInfo(i);
		local LOWname = ChatMOD_prepName(name);
		local classname = string.upper(classname);
		local class = solColorChatNicks_ClassToNum(classname);
		if( class ~= nil and name ~= nil and classname ~= nil) then
			SCCN_storage[LOWname] = { c = class, t=time(), l = level  };
		end
	end
end

function solColorChatNicks_InsertWhoText(arg)
	for name, regA, regB in string.gfind(arg, "%[(.-)%].+ (%d+) .- (.-) (.-) .+") do
		-- if string.find(regB,"-") or string.find(regB,"<") then
		-- 	classname = string.upper(regA)
		-- else
		local level = regA;
		local classname = string.upper(regB)
		
		-- end
		-- if string.find(classname,"%[") then
		-- 	return false;
		-- end
		local class = solColorChatNicks_ClassToNum(classname);
		local LOWname = ChatMOD_prepName(name);
		SCCN_storage[LOWname] = { c = class, t=time(), l = level };
	end
end


-------------------------------------------------
-- CONVERTER / GET FROM ARRAY   FUNCTIONS
-------------------------------------------------
function solColorChatNicks_ClassToNum(class)
	if(class == "WARLOCK" or class == SCCN_LOCAL_CLASS["WARLOCK"]) then
		return 1;
	elseif(class == "HUNTER" or class == SCCN_LOCAL_CLASS["HUNTER"]) then
		return 2;
	elseif(class == "PRIEST" or class == SCCN_LOCAL_CLASS["PRIEST"]) then
		return 3;
	elseif(class == "PALADIN" or class == SCCN_LOCAL_CLASS["PALADIN"]) then		
		return 4;
	elseif(class == "MAGE" or class == SCCN_LOCAL_CLASS["MAGE"]) then	
		return 5;
	elseif(class == "ROGUE" or class == SCCN_LOCAL_CLASS["ROGUE"]) then
		return 6;
	elseif(class == "DRUID" or class == SCCN_LOCAL_CLASS["DRUID"]) then
		return 7;
	elseif(class == "SHAMAN" or class == SCCN_LOCAL_CLASS["SHAMAN"]) then
		return 8;
	elseif(class == "WARRIOR" or class == SCCN_LOCAL_CLASS["WARRIOR"]) then
		return 9;
	end
	return 0;
end

function solColorChatNicks_ClassNumToRGB(classnum)
	if(classnum == 1) then return {r=100,g=0,b=112}
	elseif(classnum == 2) then return {r=81,g=140,b=11}
	elseif(classnum == 3) then return {r=1,g=1,b=1}
	elseif(classnum == 4) then return {r=255,g=0,b=255}
	elseif(classnum == 5) then return {r=0,g=180,b=240}
	elseif(classnum == 6) then return {r=220,g=200,b=0}
	elseif(classnum == 7) then return {r=240,g=136,b=0}
	elseif(classnum == 8) then return {r=255,g=0,b=255}
	elseif(classnum == 9) then return {r=147,g=112,b=67}
	else return {r=0,g=0,b=0}; end
end

function solColorChatNicks_GetClassColor(class)
	if(class == 1) 		then return SCCN_RAID_COLORS["WARLOCK"];
	elseif(class == 2) 	then return SCCN_RAID_COLORS["HUNTER"];
	elseif(class == 3) 	then return SCCN_RAID_COLORS["PRIEST"];
	elseif(class == 4) 	then return SCCN_RAID_COLORS["PALADIN"];
	elseif(class == 5) 	then return SCCN_RAID_COLORS["MAGE"];
	elseif(class == 6) 	then return SCCN_RAID_COLORS["ROGUE"];
	elseif(class == 7) 	then return SCCN_RAID_COLORS["DRUID"];
	elseif(class == 8) 	then return SCCN_RAID_COLORS["SHAMAN"];
	elseif(class == 9) 	then return SCCN_RAID_COLORS["WARRIOR"];
	end
	return SCCN_RAID_COLORS["DEFAULT"];
end

function SCCN_BG_AutoMap(event)
	if( SCCN_AutoBGMap == 1 ) then
	local zone_text = GetZoneText()
		if (zone_text == SCCN_LOCAL_ZONE["alterac"] or zone_text == SCCN_LOCAL_ZONE["warsong"] or zone_text == SCCN_LOCAL_ZONE["arathi"]) then
			SCCN_write("Zone change into '"..zone_text.."' detected. AutoToggle BGMiniMap...");
			if (SCCN_OutsideBG == 1) then
				ToggleBattlefieldMinimap();
			end
			SCCN_OutsideBG = 0;
		else
			SCCN_OutsideBG = 1;
		end
	end
end


--------------------------------------------------
-- Hyperlink and make clickable in chat Stuff
--------------------------------------------------
function SCCN_HyperlinkWindow(url)
	if( url ~= nil ) then
		EasyCopyText:SetText(url)
		EasyCopy:Show()
	end
end

function SCCN_GetURL(before, URL, after)
	SCCN_URLFOUND = 1;
	return before.."|cff".."9999EE".. "|Href:" .. URL .. "|h[".. URL .."]|h|r" ..  after;
end

function SCCN_SetItemRef(link, text, button)
	if (string.sub(link, 1 , 3) == "ref") then
		SCCN_HyperlinkWindow(string.sub(link,5));
		return;
	elseif (string.sub(link, 1 , 3) == "inv") then 
		InviteByName(string.sub(link,5));
	elseif (string.sub(link, 1 , 3) == "scn") then 
		SCCN_write(string.sub(link,5));	
	elseif (string.sub(link, 1 , 3) == "ezc") then 
		EasyCopyText:SetText(gsub(gsub(strsub(link,5),"/2","|"),"/1","/"));	
		EasyCopy:Show();
	else
		SCCN_Org_SetItemRef(link, text, button);
	end
end

function SCCN_ChanRewrite(before, msg, after)
	-- maybe doing something special herein later
	-- my Idea is to switch from highlighting to hiding or shortening
	
--	after = string.gsub(after , "]", "");
	return before..after;
end

function SCCN_ClickInvite(msg,trail)
	if (trail == nil or trail == " " or trail == "") and arg2 ~= UnitName("player") and event ~= "CHAT_MSG_RAID" and event ~= "CHAT_MSG_RAID_LEADER" and event ~= "CHAT_MSG_RAID_WARNING" then
		SCCN_INVITEFOUND = true;
		return " |Hinv:" .. arg2 .. "|h[|cffffff00"..msg.."|r]|h".." ";
	else
		return " "..msg..trail;
	end
end

--------------------------------------------------
-- Slash Command handlers
--------------------------------------------------
function SCCN_CMD_TT(msg)
	if( UnitName("target") == nil ) then
		SCCN_write("No Target for /tt");
		return false;
	end
	if( msg ~= nil and string.len(msg) > 1 ) then	
		-- send a whisper to your target
		SendChatMessage(msg, "WHISPER", this.language, UnitName("target"));
	else
		SCCN_write("Use: /tt This is a example!");
	end
end

function solColorChatNicks_SlashCommand(cmd)
	-- This function handle the Help and general Option calls
	local cmd = string.lower(cmd);
	if    ( cmd == "hidechanname") then
		if SCCN_hidechanname == 0 then 
			SCCN_hidechanname = 1;
			SCCN_write(SCCN_CMDSTATUS[1].."|cff00ff00".." ON");
		else 
			SCCN_hidechanname = 0; 
			SCCN_write(SCCN_CMDSTATUS[1].."|cffff0000".." OFF");
		end;
	elseif( cmd == "colornicks") then
		if SCCN_colornicks == 0 then 
			SCCN_colornicks = 1;
			SCCN_write(SCCN_CMDSTATUS[2].."|cff00ff00".." ON");
		else 
			SCCN_colornicks = 0; 
			SCCN_write(SCCN_CMDSTATUS[2].."|cffff0000".." OFF");
		end;
	elseif( cmd == "mousescroll") then
		if SCCN_mousescroll == 0 then 
			SCCN_mousescroll = 1;
			SCCN_write(SCCN_CMDSTATUS[3].."|cff00ff00".." ON");
		else 
			SCCN_mousescroll = 0; 
			SCCN_write(SCCN_CMDSTATUS[3].."|cffff0000".." OFF");
		end;
	elseif( cmd == "topeditbox") then
		if( CONFAB_VERSION ) then SCCN_write(SCCN_CONFAB); return false; end;
  	    if( SCCN_topeditbox == 1 ) then
			SCCN_topeditbox = 0;
			SCCN_EditBox(0);
			SCCN_write(SCCN_CMDSTATUS[4].."|cffff0000".." OFF");
		else
			SCCN_topeditbox = 1;
			SCCN_EditBox(1);
			SCCN_write(SCCN_CMDSTATUS[4].."|cff00ff00".." ON");
		end	
	elseif( strsub(cmd, 1, 9) == "timestamp") then
		if not (string.len(cmd) > 9) then
			if SCCN_timestamp == 0 then 
				SCCN_timestamp = 1;
				SCCN_write(SCCN_CMDSTATUS[5].."|cff00ff00".." ON");
			else 
				SCCN_timestamp = 0; 
				SCCN_write(SCCN_CMDSTATUS[5].."|cffff0000".." OFF");
			end;
		end
	elseif( cmd == "selfhighlight") then
		if SCCN_selfhighlight == 0 then 
			SCCN_selfhighlight = 1;
			SCCN_write(SCCN_CMDSTATUS[8].."|cff00ff00".." ON");
		else 
			SCCN_selfhighlight = 0; 
			SCCN_write(SCCN_CMDSTATUS[8].."|cffff0000".." OFF");
		end;
	elseif( cmd == "clickinvite") then
		if SCCN_clickinvite == 0 then 
			SCCN_clickinvite = 1;
			SCCN_write(SCCN_CMDSTATUS[9].."|cff00ff00".." ON");
		else 
			SCCN_clickinvite = 0; 
			SCCN_write(SCCN_CMDSTATUS[9].."|cffff0000".." OFF");
		end;
	elseif( cmd == "editboxkeys") then
		if SCCN_editboxkeys == 0 then
			SCCN_EditBoxKeysToggle(1);
			SCCN_editboxkeys = 1;
			SCCN_write(SCCN_CMDSTATUS[10].."|cff00ff00".." ON");
		else 
			SCCN_EditBoxKeysToggle(0);
			SCCN_editboxkeys = 0; 
			SCCN_write(SCCN_CMDSTATUS[10].."|cffff0000".." OFF");
		end;
	elseif( cmd == "selfhighlightmsg") then
		if SCCN_selfhighlightmsg == 0 then 
			SCCN_selfhighlightmsg = 1;
			SCCN_write(SCCN_CMDSTATUS[12].."|cff00ff00".." ON");
		else 
			SCCN_selfhighlightmsg = 0; 
			SCCN_write(SCCN_CMDSTATUS[12].."|cffff0000".." OFF");
		end;		
	elseif( cmd == "chatstring") then
		if SCCN_chatstring == 0 then 
			SCCN_chatstring = 1;
			SCCN_write(SCCN_CMDSTATUS[11].."|cff00ff00".." ON");
			SCCN_CustomizeChatString(1);
		else 
			SCCN_chatstring = 0; 
			SCCN_write(SCCN_CMDSTATUS[11].."|cffff0000".." OFF");
			SCCN_CustomizeChatString(0);
		end;	
	elseif( cmd == "hyperlink") then
		if SCCN_hyperlinker == 0 then 
			SCCN_hyperlinker = 1;
			SCCN_write(SCCN_CMDSTATUS[7].."|cff00ff00".." ON");
			SCCN_Org_SetItemRef = SetItemRef;
			SetItemRef = SCCN_SetItemRef;			
		else
			SCCN_hyperlinker = 0; 
			SCCN_write(SCCN_CMDSTATUS[7].."|cffff0000".." OFF");
			if( SCCN_Org_SetItemRef ) then
				SetItemRef = SCCN_Org_SetItemRef;
			end
		end;		
	elseif( cmd == "purge" ) then 
		solColorChatNicks_PurgeDB();
	elseif( cmd == "showlevel" ) then
		if(SCCN_SHOWLEVEL == 1) then
			SCCN_SHOWLEVEL = 0;
			SCCN_write(SCCN_CMDSTATUS[13].."|cffff0000".." OFF");
		else
			SCCN_SHOWLEVEL = 1;
			SCCN_write(SCCN_CMDSTATUS[13].."|cff00ff00".." ON");
		end
	elseif( cmd == "killdb" ) then
		SCCN_write("Whiped complete Database.");
		SCCN_storage = {};
		SCCN_OldStorage = {};
		solColorChatNicks_PurgeDB();
	elseif( cmd == "disablewho" ) then
		if(SCCN_disablewhocheck == 1) then
			SCCN_disablewhocheck = 0;
			SCCN_write("Disable Who Check:".."|cffff0000".." OFF");
			this:RegisterEvent("WHO_LIST_UPDATE")
		else
			SCCN_disablewhocheck = 1;
			SCCN_write("Disable Who Check:".."|cff00ff00".." ON");
			this:UnregisterEvent("WHO_LIST_UPDATE")
		end		
	elseif( cmd == "highlight" ) then
		if(SCCN_Highlight == 1) then
			SCCN_Highlight = 0;
			SCCN_write(SCCN_CMDSTATUS[15].."|cffff0000".." OFF");
		else
			SCCN_Highlight = 1;
			SCCN_write(SCCN_CMDSTATUS[15].."|cff00ff00".." ON");
		end		
	elseif( cmd == "autobgmap" ) then 
		if(SCCN_AutoBGMap == 1) then
			SCCN_AutoBGMap = 0;
			SCCN_write(SCCN_CMDSTATUS[14].."|cffff0000".." OFF");
		else
			SCCN_AutoBGMap = 1;
			SCCN_write(SCCN_CMDSTATUS[14].."|cff00ff00".." ON");
		end		
	elseif( cmd == "shortchanname" ) then 
		if(SCCN_shortchanname == 1) then
			SCCN_shortchanname = 0;
			SCCN_write(SCCN_CMDSTATUS[16].."|cffff0000".." OFF");
		else
			SCCN_shortchanname = 1;
			SCCN_write(SCCN_CMDSTATUS[16].."|cff00ff00".." ON");
		end
	elseif( cmd == "about" ) then
		SCCN_WELCOMESCREEN:Show();
	elseif( cmd == "inchathighlight" ) then
		if(SCCN_InChatHighlight == 1) then
			SCCN_InChatHighlight = 0;
			SCCN_write(SCCN_CMDSTATUS[19].."|cffff0000".." OFF");
		else
			SCCN_InChatHighlight = 1;
			SCCN_write(SCCN_CMDSTATUS[19].."|cff00ff00".." ON");
		end
elseif( cmd == "nofade" ) then
		if(SCCN_NOFADE == 1) then
			SCCN_NOFADE = 0;
			SCCN_write(SCCN_CMDSTATUS[21].."|cffff0000".." OFF");
		else
			SCCN_NOFADE = 1;
			SCCN_write(SCCN_CMDSTATUS[21].."|cff00ff00".." ON");
		end
		SCCNnofade();
elseif( cmd == "sticky" ) then
		if(SCCN_AllSticky == 1) then
			SCCN_AllSticky = 0;
			ChatMOD_sticky(0);
			SCCN_write(SCCN_CMDSTATUS[20].."|cffff0000".." OFF");
		else
			SCCN_AllSticky = 1;
			ChatMOD_sticky(1);
			SCCN_write(SCCN_CMDSTATUS[20].."|cff00ff00".." ON");
		end
elseif( cmd == "autosendwho" ) then
		if(SCCN_AutoSendWho == 1) then
			SCCN_AutoSendWho = 0;
			SCCN_write(SCCN_CMDSTATUS[22].."|cffff0000".." OFF");
		else
			SCCN_AutoSendWho = 1;
			SCCN_write(SCCN_CMDSTATUS[22].."|cffff0000".." ON");
		end
	elseif( cmd == "help" or cmd == "?" ) then
		SCCN_write(SCCN_HELP[1]);
		SCCN_write(SCCN_HELP[4]);
		SCCN_write(SCCN_HELP[5]);
		SCCN_write(SCCN_HELP[8]);
		SCCN_write(SCCN_HELP[14]);
		SCCN_write(SCCN_HELP[24]);
		SCCN_write(SCCN_HELP[26]);
		SCCN_write(SCCN_HELP[99]);	
	elseif( cmd == "status" ) then
		SCCN_write("|cff006CFF ---[ChatMOD Status]---");
		if( SCCN_colornicks == 1) then 	SCCN_write(SCCN_CMDSTATUS[2].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[2].."|cffff0000".." OFF"); end;
		if( SCCN_hidechanname == 1) then 	SCCN_write(SCCN_CMDSTATUS[1].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[1].."|cffff0000".." OFF"); end;
		if( SCCN_mousescroll == 1) then 	SCCN_write(SCCN_CMDSTATUS[3].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[3].."|cffff0000".." OFF"); end;	
		if( SCCN_topeditbox == 1) then 	SCCN_write(SCCN_CMDSTATUS[4].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[4].."|cffff0000".." OFF"); end;			
		if( SCCN_timestamp == 1) then 	SCCN_write(SCCN_CMDSTATUS[5].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[5].."|cffff0000".." OFF"); end;
		if( SCCN_hyperlinker == 1) then 	SCCN_write(SCCN_CMDSTATUS[7].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[7].."|cffff0000".." OFF"); end;
		if( SCCN_selfhighlight == 1) then 	SCCN_write(SCCN_CMDSTATUS[8].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[8].."|cffff0000".." OFF"); end;		
		if( SCCN_clickinvite == 1) then 	SCCN_write(SCCN_CMDSTATUS[9].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[9].."|cffff0000".." OFF"); end;		
		if( SCCN_editboxkeys == 1) then 	SCCN_write(SCCN_CMDSTATUS[10].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[10].."|cffff0000".." OFF"); end;
		if( SCCN_chatstring == 1) then 	SCCN_write(SCCN_CMDSTATUS[11].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[11].."|cffff0000".." OFF"); end;
		if( SCCN_selfhighlightmsg == 1) then 	SCCN_write(SCCN_CMDSTATUS[12].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[12].."|cffff0000".." OFF"); end;
		if( SCCN_SHOWLEVEL == 1) then 	SCCN_write(SCCN_CMDSTATUS[13].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[13].."|cffff0000".." OFF"); end;
		if( SCCN_AutoBGMap == 1) then 	SCCN_write(SCCN_CMDSTATUS[14].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[14].."|cffff0000".." OFF"); end;
		if( SCCN_shortchanname == 1) then 	SCCN_write(SCCN_CMDSTATUS[16].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[16].."|cffff0000".." OFF"); end;
		if( SCCN_AutoSendWho == 1) then 	SCCN_write(SCCN_CMDSTATUS[22].."|cff00ff00".." ON");
		else		SCCN_write(SCCN_CMDSTATUS[22].."|cffff0000".." OFF"); end;
		if( SCCN_disablewhocheck == 1) then 	SCCN_write("Disable Who Check:".."|cff00ff00".." ON");
		else		SCCN_write("Disable Who Check:".."|cffff0000".." OFF"); end;
else
		SCCNConfigForm:Show();
	end
end

-----------------------------------------------
-- SCCN Config GUI Stuff
-----------------------------------------------
function SCCN_Config_OnLoad()
	-- Setzen der UI Eigenschaften
	-- * Button Config auslesen und setzen
	SCCN_Config_SetButtonState(SCCN_hidechanname,1);
	SCCN_Config_SetButtonState(SCCN_shortchanname,7);
	SCCN_Config_SetButtonState(SCCN_colornicks,2);
	SCCN_Config_SetButtonState(SCCN_mousescroll,3);
	SCCN_Config_SetButtonState(SCCN_topeditbox,4);
	SCCN_Config_SetButtonState(SCCN_timestamp,5);
	SCCN_Config_SetButtonState(SCCN_hyperlinker,6);
	--SCCN_Config_SetButtonState(SCCN_selfhighlight,7);
	SCCN_Config_SetButtonState(SCCN_clickinvite,8);
	SCCN_Config_SetButtonState(SCCN_editboxkeys,9);
	SCCN_Config_SetButtonState(SCCN_SHOWLEVEL,11);
	SCCN_Config_SetButtonState(SCCN_AllSticky,14);
	SCCN_Config_SetButtonState(SCCN_NOFADE,15);
	SCCN_Config_SetButtonState(SCCN_AutoSendWho,16);
	SCCN_Config_SetButtonState(SCCN_Highlight,100);
	SCCN_Config_SetButtonState(SCCN_selfhighlight,101);
	SCCN_Config_SetButtonState(SCCN_selfhighlightmsg,102);
	SCCN_Config_SetButtonState(SCCN_InChatHighlight,103);	
end 

function SCCN_Config_SetButtonState(val,buttonnr)
	if(val == 0 or val == false or val == nil) then
		getglobal( "SCCN_CONF_CHK"..buttonnr ):SetChecked(0);
	else
		getglobal( "SCCN_CONF_CHK"..buttonnr ):SetChecked(1);
	end
end

function SCCN_CHATSOUND_ONLOAD()
	for i=1,5 do
		local slider = getglobal("SND_SLIDER"..i);
		if SCCN_chatsound[i] == nil then SCCN_chatsound[i] = 0; end;
		slider:SetValue(SCCN_chatsound[i]);
		local label = getglobal("SND_LABEL"..i.."Label");
		if SCCN_chatsound[i] == 0 then 
			v_name = "OFF"; 
		else
			v_name = SCCN_chatsound[i];
		end		
		label:SetText(v_name);
		local label = getglobal("SND_DIZ"..i.."Label");
		label:SetText(SCCN_TRANSLATE[i]);
	end
end

function SCCN_CHATSOUND_SAVE()
	for i=1,5 do
		local slider = getglobal("SND_SLIDER"..i);
		local value  = slider:GetValue();
		if value == nil then value = 0; end
		SCCN_chatsound[i] = value;
		--SCCN_write(i.."="..SCCN_chatsound[i])
	end
	SCCN_CHATSOUND_ONLOAD();
end

function SCCN_CHATSOUND_VALUECHANGED(id)
	if(id > 0 and id < 6) then
		value = this:GetValue();
		if value == nil then value = 0; end
		if value == 0 then 
			v_name = "OFF"; 
		else
			v_name = value;
		end
		if(SND_LABEL2 == nil) then return 0; end;
		-- Status label updaten:
		if 		id == 1	then	getglobal(SND_LABEL1:GetName() .. "Label"):SetText(v_name);
		elseif	id == 2	then	getglobal(SND_LABEL2:GetName() .. "Label"):SetText(v_name);
		elseif 	id == 3	then	getglobal(SND_LABEL3:GetName() .. "Label"):SetText(v_name);
		elseif 	id == 4	then	getglobal(SND_LABEL4:GetName() .. "Label"):SetText(v_name);
		elseif 	id == 5	then	getglobal(SND_LABEL5:GetName() .. "Label"):SetText(v_name);
		end
	end
end

function SCCN_PLAYSOUND(id)
	if id >= 0 and id <= 5 then
		--SCCN_write("PlaySound: "..id);
		PlaySoundFile("Interface\\AddOns\\ChatMOD\\audio\\"..id..".//mp3");
		-- PlaySound(SoundName);
	end
end

--hook AddMessage
function ErrorRedirect_AddMessage(objData, msg, r, g, b, a, holdTime)
  if ErrorRedirect_IsEnabled and Error_List[msg] then
    if getglobal(ErrorRedirect_Frame) then
      getglobal(ErrorRedirect_Frame):AddMessage(msg, r, g, b, a)
    end
  else
    ErrorRedirect_Org_AddMessage(objData, msg, r, g, b, a, holdTime);
  end
end