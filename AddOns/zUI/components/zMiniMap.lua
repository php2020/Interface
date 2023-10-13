zUI:RegisterComponent("小地图增强", function () 

--zUI.zMiniMap = CreateFrame("Frame", nil, UIParent);
--zUI.zMiniMap:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE") -- register events to listen to

--zUI.zMiniMap:SetScript( "OnEvent", function() 
	-- do something
--end)

GameTimeFrame:Hide()
if (C.global.darkmode == "1") then
	MinimapBorder:SetTexture("Interface\\Addons\\zUI\\img\\MiniMapDark.tga");
else
	MinimapBorder:SetTexture("Interface\\Addons\\zUI\\img\\MiniMapLight.tga");
end

MinimapBorderTop:SetTexture("Interface\\Addons\\zUI\\img\\MiniMapZoneFlag.tga");
MinimapBorderTop:SetWidth(256);
MinimapBorderTop:SetTexCoord(1, 0, 0, 1)
MinimapBorderTop:ClearAllPoints()
MinimapBorderTop:SetPoint('TOP', Minimap, 0, 23)

if not C.position["zMinimapSquared"] then
	C.position["zMinimapSquared"] = { alpha = 1.0, scale = 1.0 }
end
local modZoom = function()
    if not arg1 then return end

	if (arg1 > 0 and Minimap:GetZoom() < 5) then
        Minimap:SetZoom(Minimap:GetZoom() + 1)
    elseif arg1 < 0 and Minimap:GetZoom() > 0 then
        Minimap:SetZoom(Minimap:GetZoom() - 1)
    end
end

local f = CreateFrame('Frame', nil, Minimap)
f:EnableMouse(false)
f:SetPoint('TOPLEFT', Minimap)
f:SetPoint('BOTTOMRIGHT', Minimap)
f:EnableMouseWheel(true)
f:SetScript('OnMouseWheel', modZoom)

for _, v in pairs({
    --MinimapBorderTop,
    MinimapToggleButton,
    MinimapZoomIn,
	MinimapZoomOut
}) do
    v:Hide()
end

MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint('TOPRIGHT', 0, -10)

MinimapZoneText:ClearAllPoints()
MinimapZoneText:SetPoint('TOP', Minimap, 0, 17)
MinimapZoneText:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')

zUI.zClock = CreateFrame("Frame", nil, UIParent); -- MonkeyClock inspired
zClockText = zUI.zClock:CreateFontString("zClockText", "BACKGROUND");
zClockText:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE');
--TODO: let user set clock text color.
--zClockText:SetTextColor(1,0.8196079,0); -- yellow wow default
zClockText:SetTextColor(1,1,1);

zClockText:SetPoint('BOTTOM', Minimap, -2, -8)
local zdeltaTime = 6;

--zClockText:SetText("1:11"); --test
zUI.zClock:SetScript("OnUpdate", function()
	local elapsed = arg1;
	zdeltaTime = zdeltaTime + elapsed;

	if(zdeltaTime >= 6.0) then -- updates only every 6 seconds, I dont care for exact time atm
		--zClockText:SetText(zClock_GetTimeText());
		zClockText:SetText(date("%H:%M"));	--options needed
		zdeltaTime = 0;
	end
	
end)

function zClock_GetTimeText()
	local iHour, iMinute = GetGameTime() -- server time..
	local time = date("%I:%M %p"); -- local time with AM or PM

	-- fix up the hours and mins
	if (iMinute > 59) then
		iMinute = iMinute - 60
		iHour = iHour + 1
	elseif (iMinute < 0) then
		iMinute = 60 + iMinute
		iHour = iHour - 1
	end
	if (iHour > 23) then
		iHour = iHour - 24
	elseif (iHour < 0) then
		iHour = 24 + iHour
	end

	return format(TIME_TWENTYFOURHOURS, iHour, iMinute)

end

if (C.minimap.square == "1") then
	MinimapBorder:SetTexture(nil);

	Minimap:SetPoint("CENTER", MinimapCluster, "TOP", 9, -98)
	Minimap:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")
  
	Minimap.border = CreateFrame("Frame", nil, Minimap)
	Minimap.border:SetFrameStrata("BACKGROUND")
	Minimap.border:SetFrameLevel(1)
	Minimap.border:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -3, 3)
	Minimap.border:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 3, -3)
	Minimap.border:SetBackdrop({
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	  tile = true, tileSize = 8, edgeSize = 16,
	  insets = { left = 3, right = 3, top = 3, bottom = 3 }})
  
	Minimap.border:SetBackdropBorderColor(.9,.8,.5,1)
	Minimap.border:SetBackdropColor(.4,.4,.4,1)
else
	Minimap:SetMaskTexture("Interface\\Addons\\zUI\\img\\RoundMask5");
	
end
end)