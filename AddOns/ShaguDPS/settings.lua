-- load public variables into local
local settings = ShaguDPS.settings
local window = ShaguDPS.window
local parser = ShaguDPS.parser

local config = ShaguDPS.config
local textures = ShaguDPS.textures
local playerClasses = ShaguDPS.playerClasses

-- Load settings on Login
settings:RegisterEvent("PLAYER_ENTERING_WORLD")
settings:SetScript("OnEvent", function()
  if ShaguDPS_Config then
    for k, v in pairs(ShaguDPS_Config) do
      config[k] = v
    end
  end

  ShaguDPS_Config = config
  window.Refresh(true)
end)

-- Provide Slash Commands
SLASH_SHAGUMETER1, SLASH_SHAGUMETER2, SLASH_SHAGUMETER3 = "/shagudps", "/sdps", "/sd"
SlashCmdList["SHAGUMETER"] = function(msg, editbox)

  local function p(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
  end

  if (msg == "" or msg == nil) then
    p("|cffffcc00Shagu|cffffffffDPS:")
    p("  /sdps visible " .. config.visible .. " |cffcccccc- 显示主窗口")
    p("  /sdps width " .. config.width .. " |cffcccccc- 宽度")
    p("  /sdps height " .. config.height .. " |cffcccccc- 高度")
    p("  /sdps spacing " .. config.spacing .. " |cffcccccc- 间距")
    p("  /sdps bars " .. config.bars .. " |cffcccccc- 可见性")
    p("  /sdps trackall " .. config.track_all_units .. " |cffcccccc- 追踪所有单位")
    p("  /sdps mergepet " .. config.merge_pets .. " |cffcccccc- 计算宠物伤害")
    p("  /sdps texture " .. config.texture .. " |cffcccccc- 纹理")
    p("  /sdps pastel " .. config.pastel .. " |cffcccccc- 使用柔和颜色")
    p("  /sdps backdrop " .. config.backdrop .. " |cffcccccc- 显示窗口背景和边框")
    p("  /sdps toggle |cffcccccc- 切换窗口")
    return
  end

  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

  if strlower(cmd) == "visible" then
    if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
      config.visible = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)
      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 透明度： " .. config.visible)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 可以输入（0-1）")
    end
  elseif strlower(cmd) == "toggle" then
    config.visible = config.visible == 1 and 0 or 1
    ShaguDPS_Config = config
    window.Refresh(true)
    p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 透明度： " .. config.visible)
  elseif strlower(cmd) == "width" then
    if tonumber(args) then
      config.width = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)

      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 宽度: " .. config.width)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 可以输入（1-999）")
    end
  elseif strlower(cmd) == "height" then
    if tonumber(args) then
      config.height = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)

      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 高度: " .. config.height)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 可以输入（1-999）")
    end
  elseif strlower(cmd) == "spacing" then
    if tonumber(args) then
      config.spacing = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)

      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 间距: " .. config.spacing)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 设置 0-" .. config.height)
    end
  elseif strlower(cmd) == "bars" then
    if tonumber(args) then
      config.bars = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)

      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 数据条透明度: " .. config.bars)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 可以输入（1-999）")
    end
  elseif strlower(cmd) == "trackall" then
    if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
      config.track_all_units = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)

      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 追踪全部单位: " .. config.track_all_units)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 可以输入（0-1）")
    end
  elseif strlower(cmd) == "mergepet" then
    if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
      config.merge_pets = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)

      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 计算宠物: " .. config.merge_pets)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 可以输入（0-1）")
    end
  elseif strlower(cmd) == "texture" then
    if tonumber(args) and textures[tonumber(args)] then
      config.texture = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)

      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 材质纹理: " .. config.texture)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 设置 1-" .. table.getn(textures))
    end
  elseif strlower(cmd) == "pastel" then
    if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
      config.pastel = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)
      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 使用柔和颜色: " .. config.pastel)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 可以输入（0-1）")
    end
  elseif strlower(cmd) == "backdrop" then
    if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
      config.backdrop = tonumber(args)
      ShaguDPS_Config = config
      window.Refresh(true)

      p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 显示窗口背景: " .. config.backdrop)
    else
      p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 可以输入（0-1）  ")
    end
  end
end
