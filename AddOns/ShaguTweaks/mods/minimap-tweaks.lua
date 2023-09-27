local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "小地图增强",
  description = "[minimap-tweaks]\n隐藏不必要的迷你地图按钮，并允许使用鼠标滚轮进行缩放。",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = "世界地图&小地图",
  enabled = true,
})

module.enable = function(self)
  -- hide daytime circle
  GameTimeFrame:Hide()
  GameTimeFrame:SetScript("OnShow", function() this:Hide() end)

  -- hide minimap zone background
  MinimapBorderTop:Hide()
  MinimapToggleButton:Hide()
  MinimapZoneTextButton:SetPoint("CENTER", 7, 85)

  -- hide zoom buttons and enable mousewheel
  MinimapZoomIn:Hide()
  MinimapZoomOut:Hide()
  Minimap:EnableMouseWheel(true)
  Minimap:SetScript("OnMouseWheel", function()
    if(arg1 > 0) then Minimap_ZoomIn() else Minimap_ZoomOut() end
  end)
end
