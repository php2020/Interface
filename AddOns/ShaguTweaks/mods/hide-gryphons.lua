local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "隐藏鹰头狮",
  description = "[hide-gryphons]\n隐藏系统底部左右两侧的鹰头狮。",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  enabled = nil,
})

module.enable = function(self)
  MainMenuBarLeftEndCap:Hide()
  MainMenuBarRightEndCap:Hide()
end
