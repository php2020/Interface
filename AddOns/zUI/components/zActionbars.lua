zUI:RegisterComponent("zActionbars-动作条", function ()
	
	UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = {baseY = 70, bottomEither = 50, pet = 50, reputation = 19}; -- {baseY = 60, bottomEither = 40, pet = 40, reputation = 9};

	zUI.zBars = CreateFrame("Frame", nil, UIParent);
	local xpbarwidth,setpoint,leftbar1h,rightbar1h,petbarh,petleftbarh,Reputbar,Reputbarh=542,0,-6,38,51,5,530,4
	-- BFA
	local function LoadActionBarBFA()
		----------------------==[ zUI.zBars.ActionBarArtSmall-Frame ]==----------------------------------------------->
		zUI.zBars.ActionBarArtSmall = CreateFrame("Frame","zActionBarArtSmall",MainMenuBar)
		zUI.zBars.ActionBarArtSmall:SetFrameStrata("MEDIUM")
		zUI.zBars.ActionBarArtSmall:SetWidth(512)
		zUI.zBars.ActionBarArtSmall:SetHeight(128)
		zUI.zBars.ActionBarArtSmall:SetPoint("BOTTOM",-237,-11)
		-- Due to the texture being 1024x128 I had to split it in two too support Vanilla (max 512)
		-- Left split of the art.
		zUI.zBars.ActionBarArtSmall.left = zUI.zBars.ActionBarArtSmall:CreateTexture("zActionBarArtSmallLeft","BACKGROUND")
		zUI.zBars.ActionBarArtSmall.left:SetPoint("BOTTOMLEFT", zUI.zBars.ActionBarArtSmall, "BOTTOMLEFT", -256, 0);
		zUI.zBars.ActionBarArtSmall.left:SetWidth(512);
		zUI.zBars.ActionBarArtSmall.left:SetHeight(128);
		-- Right split of the art.
		zUI.zBars.ActionBarArtSmall.right = zUI.zBars.ActionBarArtSmall:CreateTexture("zActionBarArtSmallRight","BACKGROUND")
		zUI.zBars.ActionBarArtSmall.right:SetPoint("BOTTOMLEFT", zUI.zBars.ActionBarArtSmall, "BOTTOMLEFT", 256, 0);
		zUI.zBars.ActionBarArtSmall.right:SetWidth(512);
		zUI.zBars.ActionBarArtSmall.right:SetHeight(128);
		zUI.zBars.ActionBarArtSmall:Hide();

		--C.actionbars.endcap == "0" 的时候是隐藏
		if (C.actionbars.endcap == "1") then
			zUI.zBars.ActionBarArtSmall.left:SetTexture("Interface\\Addons\\zUI\\img\\ActionBarArtSmallLeft")
			zUI.zBars.ActionBarArtSmall.right:SetTexture("Interface\\Addons\\zUI\\img\\ActionBarArtSmallRight")
		--mrbcat 20230727 把剩下的动作条背景也隐藏了
		else
			xpbarwidth,setpoint,leftbar1h,rightbar1h,petbarh,petleftbarh,Reputbar,Reputbarh=503,0,-10,32,41,0,503,0

		end
		----------------------==[ XPBarBackground-Frame ]==------------------------------------------------->
		zUI.zBars.xpbg = CreateFrame("Frame", nil, MainMenuBar)
		zUI.zBars.xpbg:SetFrameStrata("BACKGROUND")
		zUI.zBars.xpbg:SetWidth(542)
		zUI.zBars.xpbg:SetHeight(10)
		zUI.zBars.xpbg:SetPoint("BOTTOMLEFT",MainMenuBar,5,-11)
		-- xp backdrop 
		zUI.zBars.xpbg.t = zUI.zBars.xpbg:CreateTexture(nil,"BACKGROUND")
		--zUI.zBars.xpbg.t:SetTexture("Interface/ChatFrame/ChatFrameBackground")
		zUI.zBars.xpbg.t:SetAllPoints(zUI.zBars.xpbg)
		zUI.zBars.xpbg.t:SetTexture(0,0,0,0.85);
		
		if C.actionbars.endcap == "0" then
			zUI.zBars.xpbg.t:Hide()
			
		end
		
--添加双倍经验显示 五、禁止闲扯发无关图片链接

			-----------------------==[[ ExhaustionTick_Update ]]==---------------------------------------BFA------->
		function zExhaustionTick_Update()
			local playerCurrXP = UnitXP("player");
			local playerMaxXP = UnitXPMax("player");
			local exhaustionThreshold = GetXPExhaustion();
			local exhaustionStateID;
			exhaustionStateID, _, _ = GetRestState();
			if (exhaustionStateID and exhaustionStateID >= 3) then
				ExhaustionTick:SetPoint("CENTER", "MainMenuExpBar", "RIGHT", 0, 0);
			end

			if (not exhaustionThreshold) then
				ExhaustionTick:Hide();
				ExhaustionLevelFillBar:Hide();
			else
				local exhaustionTickSet = max(((playerCurrXP + exhaustionThreshold) / playerMaxXP) * MainMenuExpBar:GetWidth(), 0);
					--local exhaustionTotalXP = playerCurrXP + (exhaustionMaxXP - exhaustionCurrXP);
					--local exhaustionTickSet = (exhaustionTotalXP / playerMaxXP) * MainMenuExpBar:GetWidth();
				ExhaustionTick:ClearAllPoints();
				if (exhaustionTickSet > MainMenuExpBar:GetWidth() or MainMenuBarMaxLevelBar:IsShown()) then
					ExhaustionTick:Hide();
					ExhaustionLevelFillBar:Hide();
					-- Saving this code in case we want to always leave the exhaustion tick onscreen
						--ExhaustionTick:SetPoint("CENTER", "MainMenuExpBar", "RIGHT", 0, 0);
						--ExhaustionLevelFillBar:SetPoint("TOPRIGHT", "MainMenuExpBar", "TOPRIGHT", 0, 0);
				else
					ExhaustionTick:Show();
					ExhaustionTick:SetPoint("CENTER", "MainMenuExpBar", "LEFT", exhaustionTickSet, 0);
					ExhaustionLevelFillBar:Show();
					ExhaustionLevelFillBar:SetPoint("TOPRIGHT", "MainMenuExpBar", "TOPLEFT", exhaustionTickSet, 0);
				end
			end
			-- Hide exhaustion tick if player is max level and the reputation watch bar is shown
			if  UnitLevel("player") == MAX_PLAYER_LEVEL  then
				ExhaustionTick:Hide();
			end
		
			local exhaustionStateID = GetRestState();
			if (exhaustionStateID == 1) then
				MainMenuExpBar:SetStatusBarColor(0.0, 0.39, 0.88, 1.0);
				ExhaustionLevelFillBar:SetVertexColor(0.0, 0.39, 0.88, 0.15);
				ExhaustionTickHighlight:SetVertexColor(0.0, 0.39, 0.88);
			elseif (exhaustionStateID == 2) then
				MainMenuExpBar:SetStatusBarColor(0.58, 0.0, 0.55, 1.0);
				ExhaustionLevelFillBar:SetVertexColor(0.58, 0.0, 0.55, 0.15);
				ExhaustionTickHighlight:SetVertexColor(0.58, 0.0, 0.55);
			end

			if ( ReputationWatchBar:IsShown() and not MainMenuExpBar:IsShown() ) then
				ExhaustionTick:Hide();
			end
		end

		--------------------==[ DELETE AND DISABLE FRAMES ]==-----------------------------------
		local function null()
			-- I do nothing (for a reason)
		end

		--efficiant way to remove frames (does not work on textures)
		local function Kill(frame)
			if type(frame) == 'table' and frame.SetScript then
				frame:UnregisterAllEvents()
				frame:SetScript('OnEvent',nil)
				frame:SetScript('OnUpdate',nil)
				frame:SetScript('OnHide',nil)
				frame:Hide()
				frame.SetScript = null
				frame.RegisterEvent = null
				frame.RegisterAllEvents = null
				frame.Show = null
			end
		end

		--如果隐藏狮鹫为真
		if C.actionbars.endcap == "0" and C.global.hide_xpbar=="1" then
			--如果隐藏经验条为真		
				Kill(MainMenuExpBar)
		end	
		Kill(MainMenuBarMaxLevelBar) --Fixed visual bug when unequipping artifact weapon at max level
		if C.global.hide_shift=="1" then
			Kill(ShapeshiftBarFrame)	
		end
		--隐藏声望栏(不可恢复，会导致很多界面问题)
		Kill(ReputationWatchStatusBar)
		--------------------==[ XP BAR ]==------------------------------------------------------------------>
		--隐藏经验条材质
		for i = 0, 3 do --for loop, hides MainMenuXPBarDiv (0-3)
		   _G["MainMenuXPBarTexture" .. i]:Hide()
		end
		-- --------------------==[ ReputationWatchStatusBar BAR ]==------------------------------------------------------------------>
		-- for i = 0, 3 do --for loop, hides MainMenuXPBarDiv (0-3)
		-- 	_G["ReputationWatchBarTexture" .. i]:Hide()
		-- end
		MainMenuExpBar:SetFrameStrata("LOW")
		ExhaustionTick:SetFrameStrata("HIGH")

		MainMenuBarExpText:ClearAllPoints()
		MainMenuBarExpText:SetPoint("CENTER",MainMenuExpBar,0,1)
		MainMenuBarOverlayFrame:SetFrameStrata("MEDIUM") --changes xp bar text strata
		
		--------------------==[ ACTIONBARS/BUTTONS POSITIONING AND SCALING ]==-----------------------------------
		--Only needs to be run once:
		
		local function Initial_ActionBarLayoutBFA()
			
			MainMenuBarLeftEndCap:Hide()
			MainMenuBarRightEndCap:Hide()
			ReputationWatchBar:Hide()
			
			--reposition bottom left actionbuttons隐藏狮鹫的时候y=-12,否则为-6
			MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT",MultiBarBottomLeft,0,leftbar1h)

			--reposition bottom right actionbar 右下动作条
			--MultiBarBottomRight:SetPoint("LEFT",MultiBarBottomLeft,"RIGHT",43,-6)
			MultiBarBottomRight:SetPoint("LEFT",MultiBarBottomLeft,0,rightbar1h)

			--reposition right bottom
			MultiBarLeftButton1:SetPoint("TOPRIGHT",MultiBarLeft,41,11)

			--reposition pet actionbuttons
			--宠物技能动作条背景位置移动到屏幕外，达到隐藏效果
			SlidingActionBarTexture0:SetPoint("TOPLEFT",PetActionBarFrame,1,-200) 
			PetActionButton1:ClearAllPoints()
			PetActionButton1:SetPoint("TOP",PetActionBarFrame,"LEFT",51,4)

			-- Named ShapeshiftBarFrame in Vanilla!!
			ShapeshiftBarLeft:SetPoint("BOTTOMLEFT",ShapeshiftBarFrame,0,-5) --stance bar texture for when Bottom Left Bar is hidden
			ShapeshiftButton1:ClearAllPoints()

		end
		local f=CreateFrame("Frame")
		f:RegisterEvent("PLAYER_LOGIN")
		f:SetScript("OnEvent", Initial_ActionBarLayoutBFA)
		----------------==[ BFA Style ]==------------------------------------->
		--mrbcat2023082 修改经验条宽度
		local function ActivateShortBar()
			
			--zUI.zBars.ActionBarArtLarge:Hide()
			zUI.zBars.ActionBarArtSmall:Show()

			--arrows and page number
			ActionBarUpButton:SetPoint("CENTER",MainMenuBarArtFrame,"TOPLEFT",521,-23)
			ActionBarDownButton:SetPoint("CENTER",MainMenuBarArtFrame,"TOPLEFT",521,-42)
			MainMenuBarPageNumber:SetPoint("CENTER",MainMenuBarArtFrame,27,-5)
			--exp bar sizing and positioning
			MainMenuExpBar_Update();
			MainMenuExpBar:ClearAllPoints()
			--MainMenuExpBar:SetWidth(542); MainMenuExpBar:SetHeight(10); 
			--当隐藏狮鹫的时候经验条宽503，否者是542
			MainMenuExpBar:SetWidth(xpbarwidth); MainMenuExpBar:SetHeight(10); 
			MainMenuExpBar:SetPoint("BOTTOMLEFT",MainMenuBar,5,-11)
			--主动作条的位置，直接影响动作条的位置，默认底部居中，271是动作条一半的宽度值，
			MainMenuBar:SetPoint("BOTTOM",UIParent,256,11)
			if ExhaustionTick:IsShown() then
				zExhaustionTick_Update();
			end
		end
		
		local function Update_ActionBarsBFA()
			
			--如果右下动作条激活
			if MultiBarBottomRight:IsShown() and MultiBarBottomLeft:IsShown() then
				PetActionButton1:SetPoint("TOP",PetActionBarFrame,"LEFT",50,petbarh)
				MultiBarBottomRight:SetPoint("BOTTOMLEFT",MultiBarBottomLeft,0,rightbar1h)

				--姿态栏
				ShapeshiftButton1:SetPoint("LEFT",ShapeshiftBarFrame,2,38)
			elseif MultiBarBottomRight:IsShown() and not MultiBarBottomLeft:IsShown() then
				PetActionButton1:SetPoint("TOP",PetActionBarFrame,"LEFT",50,petleftbarh)
				MultiBarBottomRight:SetPoint("BOTTOMLEFT",MultiBarBottomLeft,0,leftbar1h)
				--姿态栏
				ShapeshiftButton1:SetPoint("LEFT",ShapeshiftBarFrame,2,41)
			--如果左下动作条激活
			elseif MultiBarBottomLeft:IsShown() then
				PetActionButton1:SetPoint("TOP",PetActionBarFrame,"LEFT",50,petleftbarh)
				--姿态栏
				ShapeshiftButton1:SetPoint("LEFT",ShapeshiftBarFrame,2,-4)
			else
				--宠物动作
				PetActionButton1:SetPoint("TOP",PetActionBarFrame,"LEFT",50,7)
				--姿态栏
				ShapeshiftButton1:SetPoint("LEFT",ShapeshiftBarFrame,12,-2)
			end
			--Right Bar:
			if MultiBarRight:IsShown() then
				--do
			else
			end
			--Right Bar 2:
			if MultiBarLeft:IsShown() then
				--make MultiBarRight smaller (original size)
				MultiBarLeft:SetScale(.795)
				MultiBarRight:SetScale(.795)
				--MultiBarRightButton1:SetPoint("TOPRIGHT",MultiBarRight,-2,534)
				MultiBarRightButton1:SetPoint("TOPRIGHT",MultiBarRight,-44,11)
			else
				--make MultiBarRight bigger and vertically more centered, maybe also move objective frame
				MultiBarLeft:SetScale(1)
				MultiBarRight:SetScale(1)
				MultiBarRightButton1:SetPoint("TOPRIGHT",MultiBarRight,-2,64)
			end
			
			ActivateShortBar()
			-- end
		end
		
		--UIParent_ManageFramePositions(); -- better to hook??

		zUI.api.HookScript(MultiBarBottomLeft,'OnShow', Update_ActionBarsBFA)
		zUI.api.HookScript(MultiBarBottomLeft,'OnHide', Update_ActionBarsBFA)
		zUI.api.HookScript(MultiBarBottomRight,'OnShow', Update_ActionBarsBFA)
		zUI.api.HookScript(MultiBarBottomRight,'OnHide', Update_ActionBarsBFA)
		zUI.api.HookScript(MultiBarRight,'OnShow', Update_ActionBarsBFA)
		zUI.api.HookScript(MultiBarRight,'OnHide', Update_ActionBarsBFA)
		zUI.api.HookScript(MultiBarLeft,'OnShow', Update_ActionBarsBFA)
		zUI.api.HookScript(MultiBarLeft,'OnHide', Update_ActionBarsBFA)
	
		local f=CreateFrame("Frame")
		f:RegisterEvent("PLAYER_LOGIN") --Required to check bar visibility on load
		f:SetScript("OnEvent", function()
			Update_ActionBarsBFA();
			f:UnregisterEvent("PLAYER_LOGIN"); --only run once, well feels good man to be safe. MODIFIED
		end)
	
	end

	----------------------==[ MicroMenuArt-Frame ]==---------------------------------------------------->

	zUI.zBars.mma = CreateFrame("Frame", nil, UIParent)
	zUI.zBars.mma:SetFrameStrata("MEDIUM")
	zUI.zBars.mma:SetWidth(512)
	zUI.zBars.mma:SetHeight(128)
	zUI.zBars.mma:SetPoint("BOTTOMRIGHT",0,0)
	zUI.zBars.mma.t = zUI.zBars.mma:CreateTexture(nil,"BACKGROUND")
	zUI.zBars.mma.t:SetTexture("Interface\\Addons\\zUI\\img\\MicroMenuArt8Slot")
	zUI.zBars.mma.t:SetAllPoints(zUI.zBars.mma)
	if (C.global.darkmode == "1") then zUI.zBars.mma.t:SetVertexColor(0.2, 0.2, 0.2) end

	if (C.global.microbuttons_auto_hide == "1") then
		zUI.zBars.Enter = CreateFrame("Frame", "MicroEnter", UIParent);
		MicroEnter:SetFrameStrata("MEDIUM")
		MicroEnter:SetPoint("BOTTOMRIGHT", UIParent, 0, 0);
		MicroEnter:SetWidth(200);
		MicroEnter:SetHeight(70);
		--MicroEnter.tex = MicroEnter:CreateTexture(nil,"ARTWORK");
		--MicroEnter.tex:SetAllPoints(MicroEnter);
		--MicroEnter.tex:SetTexture(0,1,0,0.6);
		MicroEnter:EnableMouse(true);
		MicroEnter:SetScript("OnEnter", function() 
			--zPrint("Enter");
			zUI.zBars.mma:SetPoint("BOTTOMRIGHT",0,0)
			MicroLeave:Show();
		end)

		zUI.zBars.Leave = CreateFrame("Frame", "MicroLeave", UIParent);
		MicroLeave:SetFrameStrata("BACKGROUND");
		MicroLeave:SetAllPoints(UIParent);
		MicroLeave:EnableMouse(true);
		MicroLeave:SetScript("OnEnter", function() 
			--zPrint("Leave");
			zUI.zBars.mma:SetPoint("BOTTOMRIGHT",196,0)
			this:Hide();
		end)
		MicroLeave:Hide();
		zUI.zBars.mma:SetPoint("BOTTOMRIGHT",196,0);
		
	end

	--------------------==[ MICRO MENU MOVEMENT, POSITIONING AND SIZING ]==----------------------------------

	function MoveMicroButtonsToBottomRight()
		CharacterMicroButton:SetScale(0.9);
		SpellbookMicroButton:SetScale(0.9);
		TalentMicroButton:SetScale(0.9);
		QuestLogMicroButton:SetScale(0.9);
		SocialsMicroButton:SetScale(0.9);
		WorldMapMicroButton:SetScale(0.9);
		MainMenuMicroButton:SetScale(0.9);
		HelpMicroButton:SetScale(0.9);
		CharacterMicroButton:ClearAllPoints();
		CharacterMicroButton:SetPoint("BOTTOMRIGHT",zUI.zBars.mma,-192,1)
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT",zUI.zBars.mma,-7,52)
		MainMenuBarBackpackButton:SetScale(.76)
		CharacterBag0Slot:SetScale(.76);
		CharacterBag1Slot:SetScale(.76);
		CharacterBag2Slot:SetScale(.76);
		CharacterBag3Slot:SetScale(.76);
		MainMenuBarPerformanceBarFrame:ClearAllPoints();
		MainMenuBarPerformanceBarFrame:SetWidth(12);
		MainMenuBarPerformanceBarFrame:SetHeight(44);
		MainMenuBarPerformanceBarFrame:SetPoint("TOPLEFT",HelpMicroButton,"TOPLEFT",22,-13)
		MainMenuBarPerformanceBarFrame:SetFrameStrata"HIGH"

		for _, v in pairs({MainMenuBarPerformanceBarFrame:GetRegions()}) do
			v:ClearAllPoints();
			v:SetWidth(12);
			v:SetHeight(44);
			v:SetPoint("TOPLEFT",HelpMicroButton,"TOPLEFT",22,-13)
		end

		MainMenuBarPerformanceBarFrameButton:ClearAllPoints();
		MainMenuBarPerformanceBarFrameButton:SetWidth(14);
		MainMenuBarPerformanceBarFrameButton:SetHeight(44);
		MainMenuBarPerformanceBarFrameButton:SetPoint("TOPLEFT",HelpMicroButton,"TOPLEFT",20,-13)
		KeyRingButton:SetScale(0.9);
	end

	local f=CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function()
		MoveMicroButtonsToBottomRight();
		f:UnregisterEvent("PLAYER_ENTERING_WORLD"); 
	end)
	
	--------------------==[ BLIZZARD TEXTURES ]==-----------------------------------
	--隐藏主动作条背景
	for i = 0, 3 do --for loop, hides MainMenuBarTexture (0-3)
	   _G["MainMenuBarTexture" .. i]:Hide()
	end
	--ReputationXPBarTexture0
	--隐藏声望条材质
	for i = 0, 3 do --for loop, hides MainMenuBarTexture (0-3)
		_G["ReputationXPBarTexture" .. i]:Hide()
	 end
	--隐藏姿态栏背景材质
	local actionbarpaging = {
-- actionbar paging
		MainMenuBarPageNumber, ActionBarUpButton, ActionBarDownButton,
	}

	if  UnitLevel("player") == MAX_PLAYER_LEVEL  then
		ReputationWatchBar:ClearAllPoints()
		ReputationWatchBar:SetPoint("BOTTOMLEFT",MainMenuBar,5,Reputbarh)
	end
	local frames = {
		
		-- xp and reputation bar
		MainMenuXPBarTexture2, MainMenuXPBarTexture3,
		ReputationWatchBarTexture2, ReputationWatchBarTexture3,
		-- actionbar backgrounds
		MainMenuBarTexture2, MainMenuBarTexture3,
		MainMenuMaxLevelBar2, MainMenuMaxLevelBar3,
		ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
	  }
	local normtextures = {
		ShapeshiftButton1, ShapeshiftButton2,
		ShapeshiftButton3, ShapeshiftButton4,
		ShapeshiftButton5, ShapeshiftButton6,
	  }
	--隐藏一些背景材质
		   -- clear textures
	for id, frame in pairs(frames) do zUI.api.hide(frame) end
	--显示隐藏动作条翻页
	if C.global.hide_paging=="1" then
		for id, frame in pairs(actionbarpaging) do zUI.api.hide(frame) end
	end
	--隐藏姿态栏背景材质
	for id, frame in pairs(normtextures) do zUI.api.hide(frame, 2) end
	
	

	
	LoadActionBarBFA();
	
end)