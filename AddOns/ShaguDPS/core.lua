ShaguDPS = {}

-- 初始化默认设置对话框
StaticPopupDialogs["SHAGUMETER_QUESTION"] = {
  button1 = YES,
  button2 = NO,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1,
}

-- 可用状态栏纹理列表
local textures = {
  "Interface\\AddOns\\ShaguDPS\\Textures\\Banto",
  "Interface\\AddOns\\ShaguDPS\\Textures\\Button",
  "Interface\\AddOns\\ShaguDPS\\Textures\\Charcoal",
  "Interface\\AddOns\\ShaguDPS\\Textures\\Cilo",
  "Interface\\AddOns\\ShaguDPS\\Textures\\Luna",
  "Interface\\AddOns\\ShaguDPS\\Textures\\Otravi",
  "Interface\\AddOns\\ShaguDPS\\Textures\\Smooth",
  "Interface\\AddOns\\ShaguDPS\\Textures\\Smoothv2",
  "Interface\\BUTTONS\\WHITE8X8",
  "Interface\\TargetingFrame\\UI-StatusBar",
  "Interface\\Tooltips\\UI-Tooltip-Background",
  "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar"
}

-- 一个基本的舍入函数
local function round(input, places)
  if not places then places = 0 end
  if type(input) == "number" and type(places) == "number" then
    local pow = 1
    for i = 1, places do pow = pow * 10 end
    return floor(input * pow + 0.5) / pow
  end
end

--检测客户端版本
local function expansion()
  local _, _, _, client = GetBuildInfo()
  client = client or 11200
  if client >= 20000 and client <= 20400 then
    return "tbc"
  elseif client >= 30000 and client <= 30300 then
    return "wotlk"
  else
    return "vanilla"
  end
end

-- 共享变量
local data = {
  damage = {
    [0] = {}, -- overall 总体的
    [1] = {}, -- current 当前的
  },

  heal = {
    [0] = {}, -- overall 总体的
    [1] = {}, -- current 当前的
  },

  classes = {},
}

local dmg_table = {}
local view_dmg_all = {}
local view_dps_all = {}
local playerClasses = {}

-- 默认配置
local config = {
  -- size 尺寸
  width = 180,
  height = 15,
  bars = 8, -- 可见性
  spacing = 0, -- 间距

  -- tracking 追踪
  track_all_units = 0, -- 追踪所有单位
  merge_pets = 1, -- 计算宠物伤害

  -- appearance 外观
  visible = 1, -- 是否可见
  texture = 4, -- 纹理
  pastel = 0, -- 淡色

  -- window 窗口
  backdrop = 1, -- 显示窗口背景
  view = 1, -- 模式 1=平均伤害 2=当前伤害
}

local internals = {
  ["_sum"] = true,
  ["_ctime"] = true,
  ["_tick"] = true,
  ["_esum"] = true,
  ["_effective"] = true,
}

-- create core component frames
local window = CreateFrame("Frame", "ShaguDPSWindow", UIParent)
local settings = CreateFrame("Frame")
local parser = CreateFrame("Frame")

-- make everything public
ShaguDPS.data = data
ShaguDPS.config = config
ShaguDPS.textures = textures
ShaguDPS.window = window
ShaguDPS.settings = settings
ShaguDPS.internals = internals
ShaguDPS.parser = parser
ShaguDPS.round = round
ShaguDPS.expansion = expansion
