local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "世界地图职业着色",
  description = "[worldmap-colors]\n在世界和战场地图上显示职业颜色的圆点。",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = "世界地图&小地图",
  enabled = true,
})

local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in pairs(tocs) do
  local current = string.format("ShaguTweaks%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

local function SetAllPointsOffset(frame, parent, offset)
  frame:SetPoint("TOPLEFT", parent, "TOPLEFT", offset, -offset)
  frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -offset, offset)
end

local function UpdateWorldMapColors()
  -- throttle to to one item per .1 second
  if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + .1 end

  local frame, icon

  -- initialize all button names
  if not this.buttons then
    this.buttons = {}

    for i = 1, 4 do
      icon = string.format("WorldMapParty%d", i)
      this.buttons[icon] = string.format("party%d", i)
    end

    for i = 1, 4 do
      icon = string.format("BattlefieldMinimapParty%d", i)
      this.buttons[icon] = string.format("party%d", i)
    end

    for i = 1, 40 do
      icon = string.format("BattlefieldMinimapRaid%d", i)
      this.buttons[icon] = string.format("raid%d", i)
    end

    for i = 1, 40 do
      icon = string.format("WorldMapRaid%d", i)
      this.buttons[icon] = string.format("raid%d", i)
    end
  end

  -- update all available buttons
  local ingroup
  for name, unitstr in pairs(this.buttons) do
    frame = _G[name]

    if frame and UnitExists(unitstr) then
      icon = _G[name.."Icon"]
      icon:SetTexture()

      -- create icon if not yet existing
      if not frame.texture then
        frame.texture = frame:CreateTexture(nil, "OVERLAY")
        SetAllPointsOffset(frame.texture, frame, 12, 12)
      end

      -- check if unit is in same group
      ingroup = nil
      for i=1,5 do -- check if unit is in group
        if UnitName(string.format("party%d", i)) == UnitName(unitstr) then
          ingroup = true
        end
      end

      -- 根据raid/group状态更新纹理 加入图标大小 16
      local size = 16;
      if ingroup and frame.texture.ingroup ~= "PARTY" then
        frame.texture:SetTexture(addonpath .. "\\img\\circleparty")
        frame.texture:SetWidth(size)
	      frame.texture:SetHeight(size)
        frame.texture.ingroup = "PARTY"
      elseif not ingroup and frame.texture.ingroup ~= "RAID" then
        frame.texture:SetTexture(addonpath .. "\\img\\circleraid")
        frame.texture:SetWidth(size)
	      frame.texture:SetHeight(size)
        frame.texture.ingroup = "RAID"
      end

      -- detect unit class and set color
      local _, class = UnitClass(unitstr)
      local color = RAID_CLASS_COLORS[class]
      if color then
        frame.texture:SetVertexColor(color.r, color.g, color.b)
      else
        frame.texture:SetVertexColor(.5,1,.5)
      end
    end
  end
end

local mapcolors = CreateFrame("Frame", nil, UIParent)

module.enable = function(self)
  mapcolors:SetScript("OnUpdate", UpdateWorldMapColors)
end
