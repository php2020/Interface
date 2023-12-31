local L = AceLibrary("AceLocale-2.2"):new("Interruptor")

L:RegisterTranslations("enUS", function() return {
  ["1 = Party only, 2 = Raid only, 3 = Both"] = true,
  [">>Interrupt Used!<<"] = true,
  ["Activate/Suspend 'Interruptor'"] = true,
  ["Active"] = true,
  ["Announce Text"] = true,
  ["Announce"] = true,
  ["Channel"] = true,
  ["Disabling"] = true,
  ["Group Type"] = true,
  ["Hide minimap icon"] = true,
  ["Interrupt Announce Channel"] = true,
  ["Interruptor"] = true,
  ["Party Only"] = true,
  ["Party/Raid"] = true,
  ["Raid Only"] = true,
  ["Suspended"] = true,
  ["Whisper a player"] = true,
  ["Whisper"] = true,
  ["%s\n|cffFFA500Click:|r Cycle Group Mode|r\n|cffFFA500Right-Click:|r Options"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
  ["1 = Party only, 2 = Raid only, 3 = Both"] = "1 = 只在队伍, 2 = 只在团队, 3 = 两者",
  [">>Interrupt Used!<<"] = ">>打断技已用!<<",
  ["Activate/Suspend 'Interruptor'"] = "启动/停止 'Interruptor' 插件",
  ["Active"] = "启用",
  ["Announce Text"] = "通告文本",
  ["Announce"] = "通告",
  ["Channel"] = "频道",
  ["Disabling"] = "禁用",
  ["Group Type"] = "队伍类型",
  ["Hide minimap icon"] = "隐藏小地图图标",
  ["Interrupt Announce Channel"] = "打断通报频道",
  ["Interruptor"] = "打断通告",
  ["Party Only"] = "只在队伍",
  ["Party/Raid"] = "队伍/团队",
  ["Raid Only"] = "只在团队",
  ["Suspended"] = "暂停",
  ["Whisper a player"] = "密语玩家",
  ["Whisper"] = "密语",
  ["%s\n|cffFFA500Click:|r Cycle Group Mode|r\n|cffFFA500Right-Click:|r Options"] = "%s\n|cffFFA500点击:|r 转换队伍模式|r\n|cffFFA500右键:|r 选项",
} end)


