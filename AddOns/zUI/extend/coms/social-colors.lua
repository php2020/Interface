zUI:RegisterComponent("social_colors", function()
  if C.quality.clean_up=="1" then
  zUI.social_colors = CreateFrame("Frame", "social_colors", UIParent);
  zUI_playerDB = zUI_playerDB or {}
  

  local playerdb = zUI_playerDB
  local _G = zUI.api.GetGlobalEnv()

  local gfind = string.gmatch or zUI.api.gfind
  local GetUnitData = GetUnitData
  local hooksecurefunc = zUI.api.hooksecurefunc
  local GetExpansion = zUI.api.GetExpansion
  local cmatch = zUI.api.cmatch
  local rgbhex = zUI.api.rgbhex
  local strsplit = zUI.api.strsplit
  local friendinfo = gsub(gsub(FRIENDS_LEVEL_TEMPLATE, "%%s", "%%s %%s"), "%%d", "%%s")
  local CLEANCHAT_HEX = { [0] = "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" };
  --添加函数，来自cleachat,随机颜色用的
  local function CleanChat_HashString(name)
    local hash = 17;
    for i = 1, string.len(name) do
      hash = hash * 37 * string.byte(name, i);
    end
    return hash;
  end
  --添加函数，来自cleachat,随机颜色用的
  local function CleanChat_ToHex(number)
    if number <= 0 then
      return "00";
    end
    if number >= 255 then
      return "ff";
    end
    if math.fmod then
      return CLEANCHAT_HEX[math.floor(number / 16)] .. CLEANCHAT_HEX[math.fmod(number, 16)];
    end
    return CLEANCHAT_HEX[math.floor(number / 16)] .. CLEANCHAT_HEX[math.mod(number, 16)];
  end
  --添加函数，来自cleachat,随机颜色用的
  local function CleanChat_GetReadableColor(name)
    local hash = CleanChat_HashString(name);
    local fg_r = 0;
    local fg_g = 0;
    local fg_b = 0;

    if math.fmod then
      fg_r = math.floor(math.fmod(hash / 97, 255));
      fg_g = math.floor(math.fmod(hash / 17, 255));
      fg_b = math.floor(math.fmod(hash / 227, 255));
    else
      fg_r = math.floor(math.mod(hash / 97, 255));
      fg_g = math.floor(math.mod(hash / 17, 255));
      fg_b = math.floor(math.mod(hash / 227, 255));
    end

    -- if contrast below XX then invert rgb values.
    -- max value value to check against is 127.
    -- if 127 used, color is always brightest possible for that name
    -- (255 / 2 = 127.5, thus if below 127 and inverting rgb the result is > 127).
    if ((fg_r * 299 + fg_g * 587 + fg_b * 114) / 1000) < 105 then
      fg_r = math.abs(fg_r - 255);
      fg_g = math.abs(fg_g - 255);
      fg_b = math.abs(fg_b - 255);
    end
    return { fg_r, fg_g, fg_b };
  end



  local function NewColor(name)
    local rgb = CleanChat_GetReadableColor(name);

    local color = string.format("|cff%s%s%s", CleanChat_ToHex(rgb[1]), CleanChat_ToHex(rgb[2]), CleanChat_ToHex(rgb[3]));


    color = string.format("|cff%s%s%s", CleanChat_ToHex(rgb[1]), CleanChat_ToHex(rgb[2]), CleanChat_ToHex(rgb[3]));


    return color;
  end

  do -- add class colors to chat
    for i = 1, NUM_CHAT_WINDOWS do
  
      if _G["ChatFrame" .. i] and not _G["ChatFrame" .. i].HookAddMessageColor and not Prat then
        _G["ChatFrame" .. i].HookAddMessageColor = _G["ChatFrame" .. i].AddMessage
        _G["ChatFrame" .. i].AddMessage = function(frame, text, a1, a2, a3, a4, a5)
          if text then
            for name in gfind(text, "|Hplayer:(.-)|h") do
              local real, _ = strsplit(":", name)
        
              local color = NewColor(name)
              local class, level, _, _ = GetUnitData(name)
              local clevel
              if class and class ~= UNKNOWN then
                color = rgbhex(RAID_CLASS_COLORS[class])
                
              end
              clevel=""

              if playerdb[name] and C.quality.showlevel == "1" then
                level =playerdb[name].level
                local lcolor = GetDifficultyColor(tonumber(level)) or { 1, 1, 1 }
                clevel =" "..rgbhex(lcolor) .. level .. "|r"             
              end
              
                text =string.gsub(text, "|Hplayer:" .. name .."|h%[" .. real .. "%]|h(.-:-)",
              "|r[".. color .. "|Hplayer:" .. name .."|h" .. color .. real .. "|h|r" ..clevel.. "]|r" .. "%1%1")
              
              

             
             
              
            end
          end

          _G["ChatFrame" .. i].HookAddMessageColor(frame, text, a1, a2, a3, a4, a5)
        end
      end
    end
  end
  
  local socialmod = CreateFrame("Frame", "zUISocialMod", UIParent)
  socialmod:RegisterEvent("CHAT_MSG_SYSTEM")
  socialmod:SetScript("OnEvent", function()
    local name = cmatch(arg1, _G.ERR_FRIEND_ONLINE_SS)
    name = cmatch(arg1, _G.ERR_FRIEND_OFFLINE_S)
    if name and playerdb[name] and playerdb[name].cname then
      playerdb[name].lastseen = date("%a %d-%b-%Y")
    end
  end)

  do -- add colors to guild list
    hooksecurefunc("GuildStatus_Update", function()
      local playerzone = GetRealZoneText()
      local off = FauxScrollFrame_GetOffset(GuildListScrollFrame)
      for i = 1, GUILDMEMBERS_TO_DISPLAY, 1 do
        local name, _, _, level, class, zone, _, _, online = GetGuildRosterInfo(off + i)
        class = L["class"][class]

        if name then
          if class then
            local color = RAID_CLASS_COLORS[class]
            if online then
              _G["GuildFrameButton" .. i .. "Name"]:SetTextColor(color.r, color.g, color.b, 1)
              _G["GuildFrameButton" .. i .. "Class"]:SetTextColor(color.r, color.g, color.b, 1)
            else
              _G["GuildFrameButton" .. i .. "Name"]:SetTextColor(color.r, color.g, color.b, .5)
              _G["GuildFrameButton" .. i .. "Class"]:SetTextColor(color.r, color.g, color.b, .5)
            end
          end

          if level then
            local color = GetDifficultyColor(level)
            if online then
              _G["GuildFrameButton" .. i .. "Level"]:SetTextColor(color.r + .2, color.g + .2, color.b + .2, 1)
            else
              _G["GuildFrameButton" .. i .. "Level"]:SetTextColor(color.r + .2, color.g + .2, color.b + .2, .5)
            end
          end

          if zone and zone == playerzone then
            if online then
              _G["GuildFrameButton" .. i .. "Zone"]:SetTextColor(.5, 1, 1, 1)
            else
              _G["GuildFrameButton" .. i .. "Zone"]:SetTextColor(.5, 1, 1, .5)
            end
          end
        end
      end
    end, true)
  end

  do -- add colors to friend list
    local FRIENDS_NAME_LOCATION = GetExpansion() == "vanilla" and "ButtonTextNameLocation" or "ButtonTextLocation"
    hooksecurefunc("FriendsList_Update", function()
      if GetNumFriends() == 0 then return end

      local playerzone = GetRealZoneText()
      local off        = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame)

      for i = 1, FRIENDS_TO_DISPLAY do
        local name, level, class, zone, connected, status = GetFriendInfo(off + i)
        if not name or name == _G.UNKNOWN then break end
        local friendName = _G["FriendsFrameFriendButton" .. i .. "ButtonTextName"]
        local friendLoc = _G["FriendsFrameFriendButton" .. i .. FRIENDS_NAME_LOCATION]
        local friendInfo = _G["FriendsFrameFriendButton" .. i .. "ButtonTextInfo"]
        local caption = friendName or friendLoc

        if connected then
          if not class or class == _G.UNKNOWN then break end

          local ccolor = RAID_CLASS_COLORS[L["class"][class]] or { 1, 1, 1 }
          local lcolor = GetDifficultyColor(tonumber(level)) or { 1, 1, 1 }

          zone = (zone == playerzone and "|cffffffff" or "|cffcccccc") .. zone .. "|r"
          local cname = "|c" .. ccolor.colorStr .. name .. "|r"
          local clevel = rgbhex(lcolor) .. level .. "|r"

          if playerdb[name] then
            playerdb[name].lastseen = date("%a %d-%b-%Y")
            playerdb[name].cname = cname
            playerdb[name].clevel = clevel
            playerdb[name].cclass = ccolor
          end

          if friendName then
            friendName:SetText(cname)
            friendLoc:SetText(format(TEXT(FRIENDS_LIST_TEMPLATE), zone, status))
          else
            friendLoc:SetText(format(TEXT(FRIENDS_LIST_TEMPLATE), cname, zone, status))
          end

          friendInfo:SetText(format(TEXT(friendinfo), clevel, class, ""))
          caption:SetVertexColor(1, 1, 1, .9)
          friendInfo:SetVertexColor(1, 1, 1, .9)
        else
          if playerdb[name] and playerdb[name].cname and playerdb[name].clevel and playerdb[name].lastseen then
            caption:SetText(format(TEXT(FRIENDS_LIST_OFFLINE_TEMPLATE), playerdb[name].cname))
            friendInfo:SetText(format(TEXT(friendinfo), playerdb[name].clevel, playerdb[name].lastseen, ""))
          else
            caption:SetText(format(TEXT(FRIENDS_LIST_OFFLINE_TEMPLATE), name .. "|r"))
            friendInfo:SetText(TEXT(UNKNOWN))
          end

          caption:SetVertexColor(1, 1, 1, .4)
          friendInfo:SetVertexColor(1, 1, 1, .4)
        end
      end
    end, true)
  end

  do -- add colors to who list
    hooksecurefunc("WhoList_Update", function()
      local num, max    = GetNumWhoResults()
      local off         = FauxScrollFrame_GetOffset(WhoListScrollFrame)

      local playerzone  = GetRealZoneText()
      local playerrace  = UnitRace("player")
      local playerguild = GetGuildInfo("player")

      for i = 1, WHOS_TO_DISPLAY do
        local name, guild, level, race, class, zone = GetWhoInfo(off + i)
        local displayedText = ""

        if num + 1 >= MAX_WHOS_FROM_SERVER then
          displayedText = format(WHO_FRAME_SHOWN_TEMPLATE, MAX_WHOS_FROM_SERVER)
          WhoFrameTotals:SetText("|cffffffff" ..
            format(GetText("WHO_FRAME_TOTAL_TEMPLATE", nil, num), max) .. "  |cffaaaaaa" .. displayedText)
        else
          displayedText = format(WHO_FRAME_SHOWN_TEMPLATE, num)
          WhoFrameTotals:SetText("|cffffffff" ..
            format(GetText("WHO_FRAME_TOTAL_TEMPLATE", nil, num), num) .. "  |cffaaaaaa" .. displayedText)
        end
        --zPrint(class)

        class = L["class"][class]

        _G["WhoFrameButton" .. i .. "Name"]:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

        if (UIDropDownMenu_GetSelectedID(WhoFrameDropDown) == 1) then
          if (zone == playerzone) then
            _G["WhoFrameButton" .. i .. "Variable"]:SetTextColor(.5, 1, 1)
          else
            _G["WhoFrameButton" .. i .. "Variable"]:SetTextColor(1, 1, 1)
          end
        elseif (UIDropDownMenu_GetSelectedID(WhoFrameDropDown) == 2) then
          if (guild == playerguild) then
            _G["WhoFrameButton" .. i .. "Variable"]:SetTextColor(.5, 1, 1)
          else
            _G["WhoFrameButton" .. i .. "Variable"]:SetTextColor(1, 1, 1)
          end
        elseif (UIDropDownMenu_GetSelectedID(WhoFrameDropDown) == 3) then
          if (race == playerrace) then
            _G["WhoFrameButton" .. i .. "Variable"]:SetTextColor(.5, 1, 1)
          else
            _G["WhoFrameButton" .. i .. "Variable"]:SetTextColor(1, 1, 1)
          end
        end

        if class then
          local color = RAID_CLASS_COLORS[class]
          _G["WhoFrameButton" .. i .. "Class"]:SetTextColor(color.r, color.g, color.b, 1)
          _G["WhoFrameButton" .. i .. "Name"]:SetTextColor(color.r, color.g, color.b, 1)
        end

        local color = GetDifficultyColor(level)
        _G["WhoFrameButton" .. i .. "Level"]:SetTextColor(color.r, color.g, color.b)
      end
    end, true)
  end
end
end)
--("%d|TInterface\\MoneyFrame\\UI-GoldIcon:0|t%d|TInterface\\MoneyFrame\\UI-SilverIcon:0|t"):format(gold, silver)
