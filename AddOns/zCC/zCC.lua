zShineTextures = {
	"Interface\\Cooldown\\star4",
	"Interface\\Cooldown\\ping4",
	"Interface\\Cooldown\\starburst",
	"Interface\\Addons\\zCC\\heart",
}
zCC = {
	font = "Fonts\\FZLBJW.TTF",
	size = 20,
	min = 3,
	texture = zShineTextures[1],
	scale = 256,
	speed = 0.92,
	NoShine = nil,
	NoPet = nil,
}
----------------------------------------
local tmp
--[[
	Local functions
--]]
local function zGetFormattedTime(time)
	if (time <= 0.2) then
		return "", 1, 1, 1, 1
	elseif (time < 9) then
		local t = time - math.floor(time)
		if t > 0.5 then t = 0.12 else t = 0.82 end
		----这个调整<10秒字体大小
		return math.floor(time + 1), 1, 1.0,t,0.12--in 10 second
	elseif (time < 60) then
		return math.floor(time + 1), 1.0, 1.0,0.82,0.0--second
	elseif (time < 600) then
		return ( math.floor(time / 60 + 1).."m"), 0.85, 1.0, 0.8, 0.0--in 10 minute
	elseif (time < 3600) then
		return ( math.floor(time / 60 + 1).."m"), 0.7, 0.8, 0.6, 0.0--minute
	elseif (time < 86400) then
		return ( math.floor(time / 3600 + 1).."h"), 0.6, 0.6, 0.4, 0.0--hour
	else
		return ( math.floor(time / 86400 + 1).."d"), 0.6, 0.4, 0.4, 0.4--day
	end
end
local function zFloatAlpha(alpha)
	if ( alpha > 0.1 ) then
		alpha = alpha * (zCC.speed)
	else 
		alpha = alpha -0.02
	end
	return alpha
end
local function zCCUpdate()
	
	-- update shine
	tmp = this.zCCShine
	if tmp:IsVisible() then
		local alpha = zFloatAlpha(tmp:GetAlpha())
		if (alpha <= 0) then
			this.timer = nil
			tmp:Hide()
			tmp:SetAlpha(1)
			if this.cd.stopping == 1 then
				this:Hide()
			end
			return
		end
		tmp:SetHeight(alpha*zCC.scale)
		tmp:SetWidth(alpha*zCC.scale)
		tmp:SetAlpha(alpha)
		return
	end
	
	-- check visible
	if not this.cd:IsVisible() or this.cd.stopping ~= 0
	  or this.cd.duration <= zCC.min then
		if this.zCCText:GetText() then
			this.zCCText:SetText()
			this.zCCText.time = nil
		end
		return
	end
	
	-- timer
	if not this.timer then
		this.timer = -1
	else
		this.timer = this.timer - arg1
		if this.timer < 0  then
			-- 每秒大约刷新8、9次
			this.timer = 0.1
		else
			-- 每秒大约跳过10次刷新
			return
		end
	end
	
	-- update alpha ( for dab alpha buttons )
	local alpha = this.cd:GetAlpha()
	if alpha ~= this:GetAlpha() then
		this:SetAlpha(alpha)
	end

	-- get time text
	tmp = this.cd.start + this.cd.duration - GetTime()
	local time, scale, r, g, b = zGetFormattedTime(tmp)
	
	-- we are shining!
	if time == "" and not zCC.NoShine then
		this.zCCText:SetText("")
		tmp = this.zCCShine
		if (tmp:GetTexture() ~= zCC.texture) then
			tmp:SetTexture(zCC.texture)
		end
		tmp:SetHeight(zCC.scale)
		tmp:SetWidth(zCC.scale)
		tmp:Show()
		return
	end

	tmp = this.zCCText
	if tmp.time == time and tmp.g == g then return end
	
	-- update text
	local font, size = tmp:GetFont()
	if tmp.scale ~= scale or font ~= zCC.font or size ~= zCC.size then
		tmp:SetFont(zCC.font , zCC.size * scale, "OUTLINE")
		tmp.scale = scale
	end
	if tmp.time ~= time then
		tmp:SetText(time)
		tmp.time = time
	end
	if tmp.g ~= g then
		tmp:SetTextColor(r, g, b)
		tmp.g = g
	end
	
end
local function zCreateFrames(cdFrame)

	local button = cdFrame:GetParent()
	
	-- create a frame to contain cd text and shine texture
	tmp = CreateFrame("Frame", nil, button)
	tmp:SetAllPoints(button)
	tmp:SetFrameLevel(button:GetFrameLevel() + 10)
	
	-- create cooldown text string
	tmp.zCCText = tmp:CreateFontString(nil, "OVERLAY")
	tmp.zCCText:SetPoint("CENTER", button, "CENTER", 0, 0)
	tmp.zCCText:SetJustifyH("CENTER")
	tmp.zCCText:SetFont(zCC.font , zCC.size , "OUTLINE")

	-- create a shine texture on button
	tmp.zCCShine = tmp:CreateTexture(nil, "OVERLAY")
	tmp.zCCShine:SetPoint("CENTER" , button, "CENTER", 0, 0)
	tmp.zCCShine:SetHeight(zCC.scale)
	tmp.zCCShine:SetWidth(zCC.scale)
	tmp.zCCShine:SetTexture(zCC.texture)
	tmp.zCCShine:SetBlendMode("ADD")
	tmp.zCCShine:Hide()
	
	-- set update
	tmp.cd = cdFrame
	tmp:SetScript("OnUpdate", zCCUpdate)
	
	cdFrame.zCCFrame = tmp
end

--[[ Override Cooldown Functions ]]
-- this overriden is not indispensable, only for compatibility to some strange cases
CooldownFrame_SetTimer = function(this, start, duration, enable)
	if ( start > 0 and duration > 0 and enable > 0) then
		this.start = start
		this.duration = duration
		this.stopping = 0
		this:SetSequence(0)
		this:Show()
		
		--update cooldown count
		if this.duration > zCC.min then
			if zCC.NoPet and getglobal(this:GetParent():GetName().."AutoCast") then
				if this.zCCFrame then this.zCCFrame:Hide() end
				this.zCCFrame = nil
				return
			end
			if this.zCCFrame then
				this.zCCFrame:Show()
				this.zCCFrame.timer = -1
			else
				zCreateFrames(this)
				this.zCCTested = true
			end
		end
	else
		this:Hide()
	end
end
local zOld_CooldownFrame_OnUpdateModel = CooldownFrame_OnUpdateModel
function CooldownFrame_OnUpdateModel()
	zOld_CooldownFrame_OnUpdateModel()
	
	if this.zCCTested then return end
	
	if zCC.NoPet and getglobal(this:GetParent():GetName().."AutoCast") then
		this.zCCTested = true
		return
	end
	
	if this.stopping == 0 and this.duration > zCC.min then
		zCreateFrames(this)
		this.zCCTested = true
	end
end
