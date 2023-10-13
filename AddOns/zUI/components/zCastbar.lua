-- Credits to Shagu, pfUI
zUI:RegisterComponent("施法条", function()
	--local font = C.castbar.use_unitfonts == "1" and zUI.font_unit or zUI.font_default
	--local font_size = C.castbar.use_unitfonts == "1" and C.global.font_unit_size or C.global.font_size
	local font = STANDARD_TEXT_FONT
	local font_size = C.global.font_size
	local dir = "Interface\\Icons\\"
	local zSkin = zUI.api.zSkin
	local zSkinColor = zUI.api.zSkinColor
	--local BS = AceLibrary("Babble-Spell-2.2")
	local function CreateCastbar(name, parent, unitstr, unitname)
		local cb = CreateFrame("Frame", name, parent or UIParent)

		--CreateBackdrop(cb, default_border)

		--cb:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		--			edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true,
		--			tileSize = 16, edgeSize = 8, insets = { left = 4, right = 4, top = 4, bottom = 4 }})
		zSkin(cb, 0); -- square
		zSkinColor(cb, 0.4, 0.4, 0.4);
		--一DefaultIcons 来自凡人插件
		local DefaultIcons = {
			["采集草药"] = "spell_nature_naturetouchgrow",
			["Herb Gathering"] = "spell_nature_naturetouchgrow",
			["采矿"] = "trade_mining",
			["Mining"] = "trade_mining",
			["剥皮"] = "inv_misc_pelt_wolf_01",
			["Skinning"] = "inv_misc_pelt_wolf_01",
			["开锁"] = "INV_Misc_Gear_03",
			["火炮"] = "INV_Ammo_Bullet_01",
			["打开"] = "Spell_Nature_MoonKey",
			["Opening"] = "Spell_Nature_MoonKey",

		}
		--施法条高度
		cb:SetHeight(font_size * 1.4)
		cb:SetFrameStrata("MEDIUM")

		cb.unitstr = unitstr
		cb.unitname = unitname

		-- statusbar
		cb.bar = CreateFrame("StatusBar", nil, cb)

		if (C.castbar.flat_texture == "1") then
			--this.healthbar:SetStatusBarTexture(ZUI_FLAT_TEXTURE);
			cb.bar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
		else
			--this.healthbar:SetStatusBarTexture();
			cb.bar:SetStatusBarTexture(ZUI_ORIG_TEXTURE)
		end
		--C.castbar, "flat_texture"

		cb.bar:ClearAllPoints()
		cb.bar:SetAllPoints(cb)
		cb.bar:SetMinMaxValues(0, 100)
		cb.bar:SetValue(20)
		cb.bar:SetFrameStrata("LOW")
		--local r,g,b,a = strsplit(",", C.appearance.castbar.castbarcolor)
		--cb.bar:SetStatusBarColor(r,g,b,a)
		--cb.bar:SetStatusBarColor(1,0.4,0.1,.95) -- nice orange = 1,0.4,0.2,0.85,  blue = 0,0.56,1,.8
		cb.bar:SetStatusBarColor(1, 1, 0, 1) -- yellow

		cb.bar.bg = cb.bar:CreateTexture(nil, "BACKGROUND")
		cb.bar.bg:SetTexture(0, 0, 0, .8)
		cb.bar.bg:ClearAllPoints()
		cb.bar.bg:SetAllPoints(cb)
		--cb.bar.bg:SetPoint("CENTER", cb.bar, "CENTER", 0, 0)
		--this.healthbar.bgtarget:SetWidth(this.healthbar:GetWidth() + 5)
		--this.healthbar.bgtarget:SetHeight(this.healthbar:GetHeight() + 5)

		-- text left
		cb.bar.left = cb.bar:CreateFontString("Status", "DIALOG", "GameFontNormal")
		cb.bar.left:ClearAllPoints()
		cb.bar.left:SetPoint("TOPLEFT", cb.bar, "TOPLEFT", 5, -2)
		cb.bar.left:SetNonSpaceWrap(false)
		cb.bar.left:SetFontObject(GameFontNormal)
		cb.bar.left:SetTextColor(1, 1, 1, 1)
		cb.bar.left:SetFont(font, font_size, "OUTLINE")
		cb.bar.left:SetText("left")
		cb.bar.left:SetJustifyH("left")

		-- text right
		cb.bar.right = cb.bar:CreateFontString("Status", "DIALOG", "GameFontNormal")
		cb.bar.right:ClearAllPoints()
		cb.bar.right:SetPoint("TOPRIGHT", cb.bar, "TOPRIGHT", -3, -2)
		cb.bar.right:SetNonSpaceWrap(false)
		cb.bar.right:SetFontObject(GameFontNormal)
		cb.bar.right:SetTextColor(1, 1, 1, 1)
		cb.bar.right:SetFont(font, font_size + 1.5, "OUTLINE")
		cb.bar.right:SetText("right")
		cb.bar.right:SetJustifyH("right")


		cb:SetScript("OnUpdate", function()
			-- FOR MOVING HELP BOX
			--if this.drag and this.drag:IsShown() then
			--	this:SetAlpha(1)
			--	return
			--end
			local spellico
			
			if not UnitExists(this.unitstr) then
				this:SetAlpha(0)
			end

			if this.fadeout and this:GetAlpha() > 0 then
				if this:GetAlpha() == 0 then
					this.fadeout = nil
				end
				this:SetAlpha(this:GetAlpha() - 0.05)
			end

			local name = this.unitstr and UnitName(this.unitstr) or this.unitname
			if not name then return end

			local cast, _, _, _, startTime, endTime, _ = UnitCastingInfo(name)
	
			if name == UnitName("player") then
				spellicon = zUI.api.GetSpellIcon(cast)

				if not spellicon then
					spellicon = zUI.ICON
				end
			end


			if not cast then
				-- scan for channel spells if no cast was found
				cast, _, _, _, startTime, endTime, _ = UnitChannelInfo(name)
				if name == UnitName("player") then
				spellicon = zUI.api.GetSpellIcon(cast)

				if not spellicon then
					spellicon = zUI.ICON
				end
				end
			end


			if cast then
				local duration = endTime - startTime
				local channel = UnitChannelInfo(name)
				local max = duration / 1000
				local cur = GetTime() - startTime / 1000


				--zPrint(cast)
				--mrbcat20230603创建当前施法图标对象
				if C.castbar.player.above == '0' and C.castbar.player.hide_zUI == "0" then
					local reseth = 80

					--如果姿态栏显示，那么施法条+45高度
					if ShapeshiftBarFrame:IsShown() then
						reseth = reseth + 35
					end
					if PetActionBarFrame:IsShown() then
						reseth = reseth + 35
					end


					-- if MultiBarBottomRight:IsShown() then
					-- 	zUI.castbar.player:SetPoint("BOTTOM", UIParent, "CENTER", 13, 70+reseth)
					-- elseif MultiBarBottomLeft:IsShown() then
					-- 	zUI.castbar.player:SetPoint("TOP", MultiBarBottomLeft, "BOTTOM", 13, 70+reseth)
					-- else
					-- 	zUI.castbar.player:SetPoint("BOTTOM", UIParent, "BOTTOM", 23, 90+reseth)
					-- end
					if MultiBarBottomRight:IsShown() then
						reseth = reseth + 45
					end
					if MultiBarBottomLeft:IsShown() then
						reseth = reseth + 45
					end
					zUI.castbar.player:ClearAllPoints()
					zUI.castbar.player:SetPoint("CENTER", UIParent, "BOTTOM", 15, reseth)


					local castbaricon = zUI.castbar.player.Icon

					if cast == "" then
						cast = "探索发现"
						spellicon = "Interface\\addons\\zUI\\texture\\temp"
					end

					if DefaultIcons[cast] then
						spellicon = dir .. DefaultIcons[cast]
					end
					castbaricon.Texture:SetTexture(spellicon)
					if spellicon and zUI.castbar.player:IsShown() then
						castbaricon:Show()
					end
				else
					--zUI.castbar.player:SetWidth(160)
				end
				this:SetAlpha(1)

				if this.endTime ~= endTime then
					this.bar:SetStatusBarColor(strsplit(",",
						C.appearance.castbar[(channel and "channelcolor" or "castbarcolor")]))

					this.bar:SetMinMaxValues(0, duration / 1000)

					this.bar.left:SetText(cast)
					this.fadeout = nil
					this.endTime = endTime
				end

				if channel then
					cur = max + startTime / 1000 - GetTime()
				end

				cur = cur > max and max or cur
				cur = cur < 0 and 0 or cur

				this.bar:SetValue(cur)

				if this.delay and this.delay > 0 then
					local delay = "|cffffaaaa" .. (channel and "-" or "+") .. round(this.delay, 1) .. " |r "
					this.bar.right:SetText(delay .. string.format("%.1f", cur) .. " / " .. round(max, 1))
				else
					this.bar.right:SetText(string.format("%.1f", cur) .. " / " .. round(max, 1))
				end

				this.fadeout = nil
			else
				this.bar:SetMinMaxValues(1, 100)
				this.bar:SetValue(100)
				this.fadeout = 1
				this.delay = 0
			end
		end)
		zUI.ICON = nil
		-- register for spell delay
		cb:RegisterEvent("SPELLCAST_DELAYED")  -- CASTBAR_EVENT_CAST_DELAY -- for tbc compat
		cb:RegisterEvent("SPELLCAST_CHANNEL_UPDATE") -- CASTBAR_EVENT_CHANNEL_DELAY -- for tbc compat

		cb:SetScript("OnEvent", function()
			if not UnitIsUnit(this.unitstr, "player") then return end

			if event == ("SPELLCAST_DELAYED") then   -- CASTBAR_EVENT_CAST_DELAY -- for tbc compat
				this.delay = (this.delay or 0) + arg1 / 1000
			elseif event == ("SPELLCAST_CHANNEL_UPDATE") then -- CASTBAR_EVENT_CHANNEL_DELAY -- for tbc compat
				this.delay = (this.delay or 0) + this.bar:GetValue() - arg1 / 1000
			end
		end)

		cb:SetAlpha(0)
		return cb
	end




	zUI.castbar = CreateFrame("Frame", "zCastBar", UIParent)


	-- hide blizzard


	-- [[ zPlayerCastbar ]] --
	if C.castbar.player.hide_zUI == "0" then
		--去除关闭暴雪施法条选项
		CastingBarFrame:UnregisterAllEvents()
		CastingBarFrame:Hide()
		zUI.castbar.player = CreateCastbar("zPlayerCastbar", UIParent, "player")
		-- WIDTH player castbar
		local width = (C.castbar.player.width ~= "-1" or 160)


		if (C.castbar.player.above == "1") then
			-- Over
			zUI.castbar.player:SetPoint('TOPLEFT', PlayerFrame, 60, 15)
		else
			-- Under
			--mrbcat20230603创建当前施法图标对象
			--mrbcat20230727整合顶部显示或者屏幕显示

			zUI.castbar.player.Icon = CreateFrame("Button", nil, zUI.castbar.player)
			zUI.castbar.player.Icon:SetPoint('LEFT', zUI.castbar.player, 'LEFT', -25, 0)
			zUI.castbar.player.Icon.Texture = zUI.castbar.player.Icon:CreateTexture("curSpellIcon", "ARTWORK");
			zUI.castbar.player.Icon.Texture:SetTexCoord(.1, .9, .1, .9);
			zUI.castbar.player.Icon.Texture:SetAllPoints();
			zUI.castbar.player.Icon:SetWidth(C.global.font_size * 1.7);
			zUI.castbar.player.Icon:SetHeight(C.global.font_size * 1.7);
			zUI.castbar.player.Icon.Texture:SetTexture("Interface\\Icons\\Ability_Gouge");
			zSkin(zUI.castbar.player.Icon, 0);
			zSkinColor(zUI.castbar.player.Icon, 0, 0, 150);
			zUI.castbar.player.Icon:Hide()
			--底部显示的时候施放条长度为180，默认长度160
			width = 180
		end


		zUI.castbar.player:SetWidth(width)

		if C.castbar.player.height ~= "-1" then
			zUI.castbar.player:SetHeight(C.castbar.player.height)
		end

		UpdateMovable(zUI.castbar.player)
	end

	-- [[ zTargetCastbar ]] --
	if C.castbar.target.hide_zUI == "0" then
		zUI.castbar.target = CreateCastbar("zTargetCastbar", UIParent, "target")

		-- WIDTH target castbar
		local width = C.castbar.target.width ~= "-1" and C.castbar.target.width or 160
		-- TODO: make cast bar movable and user placed

		if (C.castbar.target.above == "1") then
			-- Over
			zUI.castbar.target:SetPoint('TOPRIGHT', TargetFrame, -60, 15)
		else
			-- Under
			zUI.castbar.target:SetPoint('BOTTOMRIGHT', TargetFrame, -60, -30);
		end

		zUI.castbar.target:SetWidth(width)

		if C.castbar.target.height ~= "-1" then
			zUI.castbar.target:SetHeight(C.castbar.target.height)
		end

		UpdateMovable(zUI.castbar.target)
	end
end)
