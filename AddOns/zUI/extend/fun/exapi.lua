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