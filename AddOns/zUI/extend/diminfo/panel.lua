--来自EK的diminfo，1.12修改by狗血编剧男
local MediaFolder = "Interface\\AddOns\\zUI\\extend\\diminfo\\Media\\"		
	
--创建框架
local CreatePanel = function(anchor, parent, relativeTo, x, y, w, h, a)
	local panel = CreateFrame("Frame", "diminfopanel", parent)
	local framelvl = parent:GetFrameLevel()

	--中间
    panel:SetWidth(w)
	panel:SetHeight(h)
	panel:ClearAllPoints()
	panel:SetPoint(anchor, parent, relativeTo, x, y)
	panel:SetFrameStrata("BACKGROUND")
	panel:SetFrameLevel(framelvl == 0 and 0 or framelvl-1)

	panel:SetBackdropColor(.1, .1, .1, a)
	panel:SetBackdropBorderColor(0, 0, 0)
	panel.bg = panel:CreateTexture(nil, "BACKGROUND")
	panel.bg:SetAllPoints(panel)
	panel.bg:SetTexture(MediaFolder.."bar")
	panel.bg:SetVertexColor(.1, .1, .1, a)

	--左侧渐变
	local left = CreateFrame("Frame", nil, parent)
	left:SetWidth(50)
	left:SetHeight(h)		
	left:ClearAllPoints()
	left:SetPoint("RIGHT", panel, "LEFT", 0, 0)
	left:SetFrameStrata("BACKGROUND")
	left:SetFrameLevel(framelvl == 0 and 0 or framelvl-1)
	
	left.bg = left:CreateTexture(nil, "BACKGROUND")
	left.bg:SetAllPoints(left)
	left.bg:SetTexture(MediaFolder.."bar")
	left.bg:SetGradientAlpha("HORIZONTAL", .1, .1, .1, 0, .1, .1, .1, a)
		
	--右侧渐变
	local right = CreateFrame("Frame", nil, parent)
	right:SetWidth(50)
	right:SetHeight(h)
	right:ClearAllPoints()
	right:SetPoint("LEFT", panel, "RIGHT", 0, 0)
	right:SetFrameStrata("BACKGROUND")
	right:SetFrameLevel(framelvl == 0 and 0 or framelvl-1)
	
	right.bg = right:CreateTexture(nil, "BACKGROUND")
	right.bg:SetAllPoints(right)
	right.bg:SetTexture(MediaFolder.."bar")
	right.bg:SetGradientAlpha("HORIZONTAL", .1, .1, .1, a, .1, .1, .1, 0)
	
	return panel
end

--锚点, 父级框架, 依靠, X, Y, 宽, 高, 透明
CreatePanel("CENTER", UIParent, "TOP", 0, -10, 520, 22, 0.8)