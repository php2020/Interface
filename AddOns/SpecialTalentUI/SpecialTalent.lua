


SPECIAL_TALENT = "天赋模拟器";
TALENT_POINTS = "天赋点";
UNSPENT_POINTS = "未分配天赋点";
TALENTS_LEARNED = "已学会";
TALENTS_PLANNED = "模拟天赋";
RESET_PLANNED_TEMPLATE = "重置模拟器";
PLANNED_RANK = "模拟等级%d/%d";
LEARNED_RANK = "学会等级%d/%d";
function SpecialTalentFrame_LoadUI()
	UIParentLoadAddOn("SpecialTalentUI");
end

function ToggleTalentFrame()
	SpecialTalentFrame_LoadUI();
	if ( SpecialTalentFrame_Toggle ) then
		SpecialTalentFrame_Toggle();
	else
		TalentFrame_LoadUI();
		if ( TalentFrame_Toggle ) then
			TalentFrame_Toggle();
		end
	end
end

-- function UpdateMicroButtons()

-- 	if ( (SpecialTalentFrame and SpecialTalentFrame:IsVisible()) or (TalentFrame and TalentFrame:IsVisible()) ) then
-- 		HideUIPanel(SpecialTalentFrame)
-- 		HideUIPanel(GameMenuFrame)
-- 	end
-- end







function UpdateMicroButtons()

	if ( (SpecialTalentFrame and SpecialTalentFrame:IsVisible()) or (TalentFrame and TalentFrame:IsVisible()) ) then
		TalentMicroButton:SetButtonState("PUSHED", 1);
	else
		TalentMicroButton:SetButtonState("NORMAL");
	end
end