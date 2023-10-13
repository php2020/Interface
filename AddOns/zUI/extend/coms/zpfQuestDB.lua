--移植凡人插件S_WorldMap
zUI:RegisterComponent("大地图矿点草药飞点显示按钮", function()
	--如果选择框没有打开，择关闭这个功能
	if C.minimap.zpfQueset_btn == "1" then
		
		local function CreatepfQuestButton(name, anchor, parent, relativeTo, x, y, text)
			local Button = CreateFrame("Button", name, WorldMapFrame, "UIPanelButtonTemplate")
			zUI.api.SetSize(Button, 35, 20)
			Button:SetFont(STANDARD_TEXT_FONT, 14)
			Button:SetPoint(anchor, parent, relativeTo, x, y)
			Button:SetText(text)
		end

		local function pfQuestButtonClick(frame, cmd)
			frame:SetScript("OnMouseDown", function()
				SlashCmdList["PFDB"](cmd)
			end)
		end

		local function pfQuestButtonOnEnter(frame, text)
			frame:SetScript("OnEnter", function()
				GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
				GameTooltip:ClearLines()
				GameTooltip:AddLine(text)
				GameTooltip:Show()
			end)
		end

		local function pfQuestButtonOnLeave(frame)
			frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		end

		local function pfQuestButton(frame, cmd, text)
			pfQuestButtonClick(frame, cmd)
			pfQuestButtonOnEnter(frame, text)
			pfQuestButtonOnLeave(frame)
		end
	
		if zUI then
			CreatepfQuestButton("pfQuestMines", "TOPLEFT", WorldMapFrame, "TOPLEFT", 200, -16, "矿物")
			CreatepfQuestButton("pfQuestherbs", "LEFT", "pfQuestMines", "RIGHT", 0, 0, "草药")
			CreatepfQuestButton("pfQuestchests", "LEFT", "pfQuestherbs", "RIGHT", 0, 0, "宝箱")
			CreatepfQuestButton("pfQuestrares", "LEFT", "pfQuestchests", "RIGHT", 0, 0, "稀有")
			CreatepfQuestButton("pfQuesttaxi", "LEFT", "pfQuestrares", "RIGHT", 0, 0, "鸟点")
			CreatepfQuestButton("pfQuestSerach", "LEFT", "pfQuesttaxi", "RIGHT", 0, 0, "搜索")
			CreatepfQuestButton("pfQuestclean", "LEFT", "pfQuestSerach", "RIGHT", 0, 0, "清除")
			
			pfQuestButton(pfQuestMines, "mines auto", "显示当前采矿等级范围内的矿石")
			pfQuestButton(pfQuestherbs, "herbs auto", "显示当前采药等级范围内的草药")
			pfQuestButton(pfQuestchests, "chests", "显示所有宝箱")
			pfQuestButton(pfQuestrares, "rares", "显示符合当前等级范围内的稀有精英")
			pfQuestButton(pfQuesttaxi, "taxi", "显示本阵营所有鸟点")
			pfQuestButton(pfQuestSerach, "show", "显示pfQuest浏览器")
			pfQuestButton(pfQuestclean, "clean", "清除地图标记")
		end
	end
end)
