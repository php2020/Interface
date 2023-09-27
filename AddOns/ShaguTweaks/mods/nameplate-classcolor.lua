local _G = ShaguTweaks.GetGlobalEnv()
local GetUnitData = ShaguTweaks.GetUnitData

local module = ShaguTweaks:register({
  title = "姓名版职业着色",
  description = "[nameplate-classcolor]\n姓名版颜色更改为职业颜色。",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = "姓名版",
  enabled = true,
})

module.enable = function(self)
  if ShaguPlates then return end

  table.insert(ShaguTweaks.libnameplate.OnUpdate, function()
    local name = this.name:GetText()
    local class, _, elite, player = GetUnitData(name, true)
    if class and player then
      local color = RAID_CLASS_COLORS[class] or { r = .5, g = .5, b = .5, a = 1 }
      this.healthbar:SetStatusBarColor(color.r, color.g, color.b, 1)
    end
  end)
end
