local L = AceLibrary("AceLocale-2.2"):new("QuestAnnouncer")
local CHATTYPE ="SAY"
local EPA_TestPatterns =
{
	FQ_EPA_PATTERN1,
	FQ_EPA_PATTERN2,
	FQ_EPA_PATTERN3,
	FQ_EPA_PATTERN4,
	FQ_EPA_PATTERN5,
	FQ_EPA_PATTERN6,
	FQ_EPA_PATTERN7,
};

local options = {
	type = 'group',
	args = {
		debug = {
			type = 'toggle',
			name = L["OPT_SHOWDEBUG_NAME"],
			desc = L["OPT_SHOWDEBUG_DESC"],
			get = "IsShowDebug",
			set = "ToggleShowDebug",
		},
		announce = {
			type = 'text',
			name = L["OPT_ANNOUNCE_NAME"],
			desc = L["OPT_ANNOUNCE_DESC"],
			get = "GetAnnounceType",
			set = "SetAnnounceType",
			validate = { "addon", "chat", "both", "none" },
		},
		display = {
			type = 'text',
			name = L["OPT_DISPLAY_NAME"],
			desc = L["OPT_DISPLAY_DESC"],
			get = "GetDisplayType",
			set = "SetDisplayType",
			validate = { "ui", "chat", "both", "none" },
		},
	},
}

QuestAnnouncer = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0", "AceDB-2.0" )
QuestAnnouncer:RegisterChatCommand( {L["SLASHCMD_LONG"], L["SLASHCMD_SHORT"]}, options )
QuestAnnouncer:RegisterDB( "QuestAnnouncerDB", "QuestAnnouncerDBPC" )
QuestAnnouncer:RegisterDefaults( "profile", {
	showDebug = false,
	announcet = "chat",
	displayt = "chat",
} )

function QuestAnnouncer:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("UI_INFO_MESSAGE")
	QuestAnnouncer:RegisterEvent("CHAT_MSG_SYSTEM")
end

function QuestAnnouncer:CHAT_MSG_ADDON( prefix, message, mode, sender )
	if (prefix == L["ADDON_PREFIX"]) and (message ~= nil) and (mode == "PARTY") and (sender ~= UnitName("player")) then
		if (self:GetDisplayType() == "ui") or (self:GetDisplayType() == "both") then
			UIErrorsFrame:AddMessage(sender..": "..message,0.75,1.0,0.5,1.0,UIERRORS_HOLD_TIME)
		end
		if (self:GetDisplayType() == "chat") or (self:GetDisplayType() == "both") then
			self:Print(sender..": "..message)
		end
	end
end

function QuestAnnouncer:CHAT_MSG_SYSTEM( message )
    if (GetNumPartyMembers()==0) then
        CHATTYPE = "SAY"
    else
        CHATTYPE = "PARTY"
    end

    for index, value in EPA_TestPatterns do
		if ( string.find(message, value) ) then
			SendChatMessage(message, CHATTYPE);
			break;
		end
	end
end

function QuestAnnouncer:UI_INFO_MESSAGE( message )
    if (GetNumPartyMembers()==0) then
        CHATTYPE = "SAY"
    else
        CHATTYPE = "PARTY"
    end
	
		if self:IsShowDebug() then
			self:Print(message)
		end
		if (self:GetAnnounceType() == "chat") or (self:GetAnnounceType() == "both") then
			SendChatMessage(message, CHATTYPE)
		end

end

function QuestAnnouncer:IsShowDebug()
	return self.db.profile.showDebug
end

function QuestAnnouncer:ToggleShowDebug()
	self.db.profile.showDebug = not self.db.profile.showDebug
	if self.db.profile.showDebug then
		self:Print(L["OPT_SHOWDEBUG_ON"])
	else
		self:Print(L["OPT_SHOWDEBUG_OFF"])
	end
end

function QuestAnnouncer:GetAnnounceType()
	return self.db.profile.announcet
end

function QuestAnnouncer:SetAnnounceType(name)
	self.db.profile.announcet = name
	if name == "addon" then
		self:Print(L["OPT_ANNOUNCE_ADDON"])
	elseif name == "chat" then
		self:Print(L["OPT_ANNOUNCE_CHAT"])
	elseif name == "both" then
		self:Print(L["OPT_ANNOUNCE_BOTH"])
	elseif name == "none" then
		self:Print("无通告发表")
	end
end

function QuestAnnouncer:GetDisplayType()
	return self.db.profile.displayt
end

function QuestAnnouncer:SetDisplayType(name)
	self.db.profile.displayt = name
	if name == "ui" then
		self:Print(L["OPT_DISPLAY_UI"])
	elseif name == "chat" then
		self:Print(L["OPT_DISPLAY_CHAT"])
	elseif name == "both" then
		self:Print(L["OPT_DISPLAY_BOTH"])
	elseif name == "none" then
		self:Print(L["OPT_DISPLAY_NONE"])
	end
end

