zUI.api.rgbhex = function(r, g, b, a)
    if type(r) == "table" then
        if r.r then
            _r, _g, _b, _a = r.r, r.g, r.b, (r.a or 1)
        elseif table.getn(r) >= 3 then
            _r, _g, _b, _a = r[1], r[2], r[3], (r[4] or 1)
        end
    elseif tonumber(r) then
        _r, _g, _b, _a = r, g, b, (a or 1)
    end

    if _r and _g and _b and _a then
        -- limit values to 0-1
        _r = _r + 0 > 1 and 1 or _r + 0
        _g = _g + 0 > 1 and 1 or _g + 0
        _b = _b + 0 > 1 and 1 or _b + 0
        _a = _a + 0 > 1 and 1 or _a + 0
        return string.format("|c%02x%02x%02x%02x", _a * 255, _r * 255, _g * 255, _b * 255)
    end

    return ""
end


function zUI.api.ToggleFrame(frame)
	if frame:IsShown() then
		HideUIPanel(frame)
	else
		ShowUIPanel(frame)
	end
end
function zUI.api.hide(frame, texture)
    if not frame then return end

    if texture and texture == 1 and frame.SetTexture then
      frame:SetTexture("")
    elseif texture and texture == 2 and frame.SetNormalTexture then
      frame:SetNormalTexture("")
    else
      frame:ClearAllPoints()
      frame.Show = function() return end
      frame:Hide()
    end
  end
function zUI.api.setGoldString(amt, sep)
    local STATUS_COLOR = "|c000066FF";
    local SILVER = "|c00C0C0C0";
    local COPPER = "|c00CC9900";
    local GOLD = "|c00FFFF66";
    local str = "";
    local gold, silver, copper;

    if (amt == 0) then
        str = COPPER .. zUI.mlocals["0 Copper"] .. STATUS_COLOR;
        return str;
    end
    if (not sep) then sep = " " end
    ;

    copper = mod(floor(amt + .5), 100);
    silver = mod(floor(amt / 100), 100);
    gold   = mod(floor(amt / (100 * 100)), 100);

    if (gold > 0) then str = GOLD .. gold .. "金" end
    ;
    if (silver > 0) then
        if (str ~= "") then str = str .. sep end
        ;
        str = str .. SILVER .. silver .. "银";
    end
    ;
    if (copper > 0) then
        if (str ~= "") then str = str .. sep end
        ;
        str = str .. COPPER .. copper .. "铜";
    end
    ;

    str = str .. STATUS_COLOR;
    return str;
end

zUI.api.GetExpansion = function()
    local _, _, _, client = GetBuildInfo()
    client = client or 11200

    -- detect client expansion
    if client >= 20000 and client <= 20400 then
        return "tbc"
    elseif client >= 30000 and client <= 30300 then
        return "wotlk"
    else
        return "vanilla"
    end
end
zUI.api.GetGlobalEnv = function()
    if zUI.api.GetExpansion() == 'vanilla' then
        return getfenv(0)
    else
        return _G or getfenv(0)
    end
end

local MAXN = 2147483647
local function toInt(x)
    if x == floor(x) then return x end

    if x > 0 then
        x = floor(x + 0.5)
    else
        x = ceil(x - 0.5)
    end

    return x
end
function GetTimeFrompoints(str, func)
    local PointtoTime = {}
    local i, j, combatpoint, duration 
    i, j, combatpoint, duration = string.find(str, func) 
    while (i and j) do 
         PointtoTime[tonumber(combatpoint)] = tonumber(duration) 
     i, j, combatpoint, duration = string.find(str, func, j) 
    end 
    return PointtoTime 
end 
function GetTrapTime(str, func)
    local PointtoTime = {}
    local i, j
    i, j, PointtoTime[1] = string.find(str, func[1])
    if (i and j) then
        i, j, PointtoTime[2] = string.find(str, func[2])
        if (i and j) then	     
               PointtoTime[2] = tostring(tonumber(PointtoTime[2])*60)	            
            return PointtoTime 
        end 
    end 
end 
function zUI.api.select(n, ...)
    if not (type(n) == "number" or (type(n) == "string" and n == "#")) then
        error(format("bad argument #1 to 'select' (number expected, got %s)", n and type(n) or "no value"), 2)
    end

    if n == "#" then
        return arg.n
    elseif n == 0 or n > MAXN then
        error("bad argument #1 to 'select' (index out of range)", 2)
    elseif n == 1 then
        return unpack(arg)
    end

    if n < 0 then
        n = arg.n + n + 1
    end
    n = toInt(n)

    for i = 1, n - 1 do
        tremove(arg, 1)
    end

    return unpack(arg)
end
function zUI.api.SetSize(f, w, h)
    if not f then return end
    f:SetWidth(w)
    f:SetHeight(h)
end
function zUI.api.SetPercentColor(min, max)
	local r = 0
	local g = 1
	local b = 0
	if (min and max) then
		local v =  tonumber(min) / tonumber(max)
		if (v >= 0 and v <= 1) then
			if (v > 0.5) then
				r = (1.0 - v) * 2
				g = 1.0
			else
				r = 1.0
				g = v * 2
			end
		end
	end
	if r < 0 then
		r = 0
	elseif r > 1 then
		r = 1
	end
	if g < 0 then
		g = 0
	elseif g > 1 then
		g = 1
	end

	return r, g, b
end

--以"万"显示计数
function zUI.api.Over1E3toK(v)
	if type(v) ~= "number" then return end
	if v > 1E4 then
		text = format("%0.1f万", v/1E4)
	else
		text =  v 
	end
	return text
end
function zUI.api.HexColors(r, g, b)
	-- 未定义则白色
	if not r then return "|cffFFFFFF" end
	
	if type(r) == "table" then
		if(r.r) then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end
	
	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end
--四色五人
function zUI.api.Round(input, places)
    if not places then places = 0 end
    if type(input) == "number" and type(places) == "number" then
        local pow = 1
        for i = 1, places do pow = pow * 10 end
        return floor(input * pow + 0.5) / pow
    end
end
--渐隐按钮
function zUI.api.EnableAutohide(frame, timeout)
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