zFont= CreateFrame("Frame")
local CF_SCALE = 1
function zFont:ApplySystemFonts()
	local default, unit, combat

	default = "Fonts\\FZXHLJW.TTF"
	combat = "Fonts\\FZJZJW.ttf"
	unit = "Fonts\\FZXHLJW.TTF"


	zUI.font_default      = default


	STANDARD_TEXT_FONT    = default
	DAMAGE_TEXT_FONT      = combat
	NAMEPLATE_FONT        = default
	UNIT_NAME_FONT        = unit
end
zFont:SetScript("OnEvent",
	function()
		if (event == "ADDON_LOADED") then
			zFont:ApplySystemFonts()
		end
	end);
   zFont:RegisterEvent("ADDON_LOADED");

   zFont:ApplySystemFonts();
-----------------------------------------------------
local function CanSetFont(object) 
	return (type(object)=="table" and object.SetFont and object.IsObjectType and not object:IsObjectType("SimpleHTML")); 
end



   UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12 * CF_SCALE;
--------------
   if (CanSetFont(SystemFont)) then	SystemFont:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(MasterFont)) then	MasterFont:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
-------------------------------------------------------
   if (CanSetFont(GameFontNormal)) then		GameFontNormal:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontHighlight)) then	GameFontHighlight:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end

   if (CanSetFont(GameFontDisable)) then	GameFontDisable:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontDisable)) then	GameFontDisable:SetTextColor(0.6, 0.6, 0.6); end

   if (CanSetFont(GameFontGreen)) then 		GameFontGreen:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontRed)) then 		GameFontRed:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontWhite)) then 		GameFontWhite:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontBlack)) then 		GameFontBlack:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE); end
---------------------------------------------
   if (CanSetFont(GameFontNormalSmall)) then 		GameFontNormalSmall:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end

   if (CanSetFont(GameFontDisableSmall)) then 		GameFontDisableSmall:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontDisableSmall)) then 		GameFontDisableSmall:SetTextColor(0.6, 0.6, 0.6); end

   if (CanSetFont(GameFontDarkGraySmall)) then 		GameFontDarkGraySmall:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontDarkGraySmall)) then 		GameFontDarkGraySmall:SetTextColor(0.4, 0.4, 0.4); end

   if (CanSetFont(GameFontGreenSmall)) then 		GameFontGreenSmall:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontRedSmall)) then 		GameFontRedSmall:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontHighlightSmall)) then 	GameFontHighlightSmall:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontHighlightSmallOutline)) then GameFontHighlightSmallOutline:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE, "OUTLINE"); end
---------------------------
   if (CanSetFont(GameFontNormalLarge)) then 		GameFontNormalLarge:SetFont(STANDARD_TEXT_FONT, 18 * CF_SCALE); end
   if (CanSetFont(GameFontHighlightLarge)) then 	GameFontHighlightLarge:SetFont(STANDARD_TEXT_FONT, 18 * CF_SCALE); end

   if (CanSetFont(GameFontDisableLarge)) then 		GameFontDisableLarge:SetFont(STANDARD_TEXT_FONT, 18 * CF_SCALE); end
   if (CanSetFont(GameFontDisableLarge)) then 		GameFontDisableLarge:SetTextColor(0.6, 0.6, 0.6); end

   if (CanSetFont(GameFontGreenLarge)) then 		GameFontGreenLarge:SetFont(STANDARD_TEXT_FONT, 18 * CF_SCALE); end
   if (CanSetFont(GameFontRedLarge)) then 		GameFontRedLarge:SetFont(STANDARD_TEXT_FONT, 18 * CF_SCALE); end
---------------------------------

   if (CanSetFont(GameFontNormalHuge)) then 		GameFontNormalHuge:SetFont(STANDARD_TEXT_FONT, 21 * CF_SCALE); end
------------------------------------------------------

   if (CanSetFont(CombatTextFont)) then 			CombatTextFont:SetFont(DAMAGE_TEXT_FONT, 24 * CF_SCALE,"OUTLINE"); end
------------------------------------------------------------------------------

   if (CanSetFont(NumberFontNormal)) then 		NumberFontNormal:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalYellow)) then 	NumberFontNormalYellow:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalSmall)) then 		NumberFontNormalSmall:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalSmallGray)) then 	NumberFontNormalSmallGray:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalLarge)) then 		NumberFontNormalLarge:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE, "OUTLINE"); end

   if (CanSetFont(NumberFontNormalHuge)) then 		NumberFontNormalHuge:SetFont(STANDARD_TEXT_FONT, 20 * CF_SCALE, "THICKOUTLINE"); end
   if (CanSetFont(NumberFontNormalHuge)) then 		NumberFontNormalHuge:SetAlpha(30); end
--------------------------------------------------

   if (CanSetFont(ChatFontNormal)) then 			ChatFontNormal:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end

   CHAT_FONT_HEIGHTS = {
      [1] = 7,
      [2] = 8,
      [3] = 9,
      [4] = 10,
      [5] = 11,
      [6] = 12,
      [7] = 13,
      [8] = 14,
      [9] = 15,
      [10] = 16,
      [11] = 17,
      [12] = 18,
      [13] = 19,
      [14] = 20,
      [15] = 21,
      [16] = 22,
      [17] = 23,
      [18] = 24
   };
----------------------------------------------------

   if (CanSetFont(QuestTitleFont)) then 			QuestTitleFont:SetFont(STANDARD_TEXT_FONT, 18 * CF_SCALE); end
   if (CanSetFont(QuestTitleFont)) then 			QuestTitleFont:SetShadowColor(0.54, 0.4, 0.1); end

   if (CanSetFont(QuestFont)) then 		   		QuestFont:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(QuestFont)) then 		   		QuestFont:SetTextColor(0.15, 0.09, 0.04); end

   if (CanSetFont(QuestFontNormalSmall)) then 		QuestFontNormalSmall:SetFont(STANDARD_TEXT_FONT, 12 * CF_SCALE); end
   if (CanSetFont(QuestFontNormalSmall)) then 		QuestFontNormalSmall:SetShadowColor(0.54, 0.4, 0.1); end

   if (CanSetFont(QuestFontHighlight)) then 		QuestFontHighlight:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
---------------------------------

   if (CanSetFont(DialogButtonNormalText)) then 	DialogButtonNormalText:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(DialogButtonHighlightText)) then 	DialogButtonHighlightText:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
-------------------------------------------------------------

   if (CanSetFont(ErrorFont)) then 	   			ErrorFont:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE); end
   if (CanSetFont(ErrorFont)) then 	   			ErrorFont:SetAlpha(60); end
-------------------------------------

   if (CanSetFont(ItemTextFontNormal)) then 	   	ItemTextFontNormal:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE); end
--------------------------------------------------------------

   if (CanSetFont(MailTextFontNormal)) then 	   	MailTextFontNormal:SetFont(STANDARD_TEXT_FONT, 16 * CF_SCALE); end
   if (CanSetFont(MailTextFontNormal)) then 	   	MailTextFontNormal:SetTextColor(0.15, 0.09, 0.04); end
   if (CanSetFont(MailTextFontNormal)) then 	   	MailTextFontNormal:SetShadowColor(0.54, 0.4, 0.1); end
   if (CanSetFont(MailTextFontNormal)) then 	   	MailTextFontNormal:SetShadowOffset(1, -1); end

   if (CanSetFont(InvoiceTextFontNormal)) then 	   	InvoiceTextFontNormal:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(InvoiceTextFontNormal)) then 	   	InvoiceTextFontNormal:SetTextColor(0.15, 0.09, 0.04); end

   if (CanSetFont(InvoiceTextFontSmall)) then 	   	InvoiceTextFontSmall:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(InvoiceTextFontSmall)) then 	   	InvoiceTextFontSmall:SetTextColor(0.15, 0.09, 0.04); end
--------------------------------

   if (CanSetFont(SubSpellFont)) then 	   		SubSpellFont:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
---------------------------------------------------------

   if (CanSetFont(TextStatusBarText)) then 	   	TextStatusBarText:SetFont(STANDARD_TEXT_FONT ,14 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(TextStatusBarTextSmall)) then 	TextStatusBarTextSmall:SetFont(STANDARD_TEXT_FONT, 13); end

   if (CanSetFont(GameTooltipText)) then 	   		GameTooltipText:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameTooltipTextSmall)) then 	   	GameTooltipTextSmall:SetFont(STANDARD_TEXT_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameTooltipHeaderText)) then 	   	GameTooltipHeaderText:SetFont(STANDARD_TEXT_FONT, 18 * CF_SCALE); end

   if (CanSetFont(WorldMapTextFont)) then 	   	WorldMapTextFont:SetFont(STANDARD_TEXT_FONT, 110 * CF_SCALE, "THICKOUTLINE"); end
   if (CanSetFont(WorldMapTextFont)) then 	   	WorldMapTextFont:SetShadowColor(0, 0, 0); end
   if (CanSetFont(WorldMapTextFont)) then 	   	WorldMapTextFont:SetShadowOffset(1, -1); end
   if (CanSetFont(WorldMapTextFont)) then 	   	WorldMapTextFont:SetAlpha(40); end

   if (CanSetFont(ZoneTextFont)) then 	   		ZoneTextFont:SetFont(STANDARD_TEXT_FONT, 180 * CF_SCALE, "THICKOUTLINE"); end
   if (CanSetFont(ZoneTextFont)) then 	   		ZoneTextFont:SetShadowColor(0, 0, 0); end
   if (CanSetFont(ZoneTextFont)) then 	   		ZoneTextFont:SetShadowOffset(1, -1); end

   if (CanSetFont(SubZoneTextFont)) then 	   		SubZoneTextFont:SetFont(STANDARD_TEXT_FONT, 26 * CF_SCALE, "THICKOUTLINE"); end
---------------------------------------------------

   if (CanSetFont(CombatLogFont)) then 			CombatLogFont:SetFont(DAMAGE_TEXT_FONT, 24 * CF_SCALE,"OUTLINE"); end




