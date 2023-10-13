--GLOBAL UTILITIES--
-- The purpose of this file is to consolidate all my misc functions
-- like RichText coloring, InstantDialogs, etc.
-- This file is used in many of my mods

----------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------

function U_DEBUG(message)
	if (DEBUG) then
		DEFAULT_CHAT_FRAME:AddMessage("DEBUG: "..message);
	end
end

function U_DisplayDialog(message)
	GameTooltip:SetText(message);
	GameTooltip:Show();
end

----------------------------------------------------------------
-- RICH TEXT MARKUPS
----------------------------------------------------------------
function U_HEADERTEXT(msg) --Gold
	return "|cff00f100"..msg.."|cff00f100|r";
end
function U_SUBHEADERTEXT(msg)--??
	return "|cffff44ff"..msg.."|cffff44ff|r";
end
function U_BODYTEXT(msg) --white
	return "|cffffffff"..msg.."|cffffffff|r";
end
function U_HIGHLIGHTTEXT(msg) -- ???
	return "|cff00d0ff"..msg.."|cff00d0ff|r";
end
function U_HINTTEXT(msg) --Green
	return "|c0000ff00"..msg.."|c0000ff00|r";
end
function U_REDTEXT(msg) --Green
	return "|cffff0000"..msg.."|cffff0000|r";
end