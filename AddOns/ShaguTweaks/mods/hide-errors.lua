local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "隐藏插件Lua错误",
  description = "[hide-errors]\n彻底隐藏由插件产生的所有Lua错误，不会有任何提示或信息出现。",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  enabled = nil,
})

module.enable = function(self)
  error = function() return end
  seterrorhandler(error)
end
