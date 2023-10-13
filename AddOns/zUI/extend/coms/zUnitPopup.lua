--重置框架、副本
UnitPopupButtons["RESET_INSTANCES_FIX"] = { text = "|CFF00FFFF重置副本|R", dist = 0 }
local realmname = GetRealmName()
local a = string.find(realmname,"Everlook");
local TW_XPFrameData = CreateFrame("Frame")
TW_XPFrameData:RegisterEvent("CHAT_MSG_SYSTEM")
TW_XPFrameData.xp = true
if a then
	UnitPopupMenus["SELF"] = { "LOOT_METHOD", "LOOT_THRESHOLD", "LOOT_PROMOTE", "LEAVE", "RAID_TARGET_ICON","RESET_INSTANCES_FIX", "CANCEL" }
else
	UnitPopupMenus["SELF"] = { "LOOT_METHOD", "LOOT_THRESHOLD", "LOOT_PROMOTE", "LEAVE", "XP","RAID_TARGET_ICON","RESET_INSTANCES_FIX", "CANCEL" }

end	
	TW_XPFrameData:SetScript("OnEvent", function()
		if event then
			if event == "CHAT_MSG_SYSTEM" and not a then
				if arg1 == "XP gain is ON" or arg1 == "XP gain is now ON" then
					TW_XPFrameData.xp = true
					UnitPopupButtons["XP"] = { text = "经验值获取：开启", dist = 0 };
				end
				if arg1 == "XP gain is OFF" or arg1 == "XP gain is now OFF" then
					TW_XPFrameData.xp = false
					UnitPopupButtons["XP"] = { text = "经验值获取：关闭", dist = 0 };
				end
			end
		end
	end)
	

zUI.api.hooksecurefunc("UnitPopup_OnClick", function()
	local button = this.value
    if button == "RESET_INSTANCES_FIX" then
		StaticPopup_Show("CONFIRM_RESET_INSTANCES")
	end
end)