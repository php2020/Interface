local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "自动下马",
  description = "[auto-dismount]\n提示“你正在骑乘状态”时，自动取消坐骑",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  enabled = true,
})

module.enable = function(self)
  local dismount = CreateFrame("Frame")

  -- mount tooltip texts
  dismount.strings = {
    -- deDE
    "^Erhöht Tempo um (.+)%%",
    -- enUS
    "^Increases speed by (.+)%%",
    -- esES
    "^Aumenta la velocidad en un (.+)%%",
    -- frFR
    "^Augmente la vitesse de (.+)%%",
    -- ruRU
    "^Скорость увеличена на (.+)%%",
    -- koKR
    "^이동 속도 (.+)%%만큼 증가",
    -- zhCN
    "^速度提高(.+)%%",

    -- turtle-wow
    "speed based on",
    "Slow and steady...",
    "Riding"
  }

  -- shapeshift buff icons
  dismount.shapeshifts = {
    '_mount_', '_qirajicrystal_', 'ability_bullrush', 'ability_druid_aquaticform', 'ability_druid_catform', 'ability_druid_travelform',
    'ability_hunter_pet_turtle', 'ability_racial_bearform', 'inv_misc_head_dragon_black', 'inv_pet_speedy', 'spell_nature_forceofnature',
    'spell_nature_spiritwolf', 'spell_nature_swiftness'
  }

  -- errors that indicate mount/shapeshift
  dismount.errors = { SPELL_FAILED_NOT_MOUNTED, ERR_ATTACK_MOUNTED, ERR_TAXIPLAYERALREADYMOUNTED,
    SPELL_FAILED_NOT_SHAPESHIFT, SPELL_FAILED_NO_ITEMS_WHILE_SHAPESHIFTED, SPELL_NOT_SHAPESHIFTED,
    SPELL_NOT_SHAPESHIFTED_NOSPACE, ERR_CANT_INTERACT_SHAPESHIFTED, ERR_NOT_WHILE_SHAPESHIFTED,
    ERR_NO_ITEMS_WHILE_SHAPESHIFTED, ERR_TAXIPLAYERSHAPESHIFTED,ERR_MOUNT_SHAPESHIFTED }

  dismount.scanner = ShaguTweaks.libtipscan:GetScanner("dismount")

  dismount:RegisterEvent("UI_ERROR_MESSAGE")
  dismount:SetScript("OnEvent", function()
    -- stand up
    if arg1 == SPELL_FAILED_NOT_STANDING then
      SitOrStand()
      return
    end

    -- scan through buffs and cancel shapeshift/mount
    for id, errorstring in pairs(dismount.errors) do
      if arg1 == errorstring then
        for i=0, 31 do
          -- detect mounts based on tooltip text
          dismount.scanner:SetPlayerBuff(i)
          for _, str in pairs(dismount.strings) do
            if dismount.scanner:Find(str) then
              CancelPlayerBuff(i)
              return
            end
          end

          -- detect shapeshift based on texture
          local buff = GetPlayerBuffTexture(i)
          if buff then
            for id, bufftype in pairs(dismount.shapeshifts) do
              if string.find(string.lower(buff), bufftype) then
                CancelPlayerBuff(i)
                return
              end
            end
          end
        end
      end
    end
  end)
end
