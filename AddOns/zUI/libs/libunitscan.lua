-- Credits to Shagu, pfUI
setfenv(1, zUI:GetEnvironment())

--[[ libunitscan ]]--
-- A pfUI library that detects and saves all kind of unit related informations.
-- Such as level, class, elite-state and playertype. Each query causes the library
-- to automatically scan for the target if not already existing. Player-data is
-- persisted within the pfUI_playerDB where the mob data is a throw-away table.
-- The automatic target scanner is only working for vanilla due to client limitations
-- on further expansions.
--
-- External functions:
--   GetUnitData(name, active)
--     Returns information of the given unitname. Returns nil if no match is found.
--     When nothing is found and the active flag is set, the autoscanner will
--     automatically pick it up and try to fill the missing entry by targetting the unit.
--
--     class[String] - The class of the unit
--     level[Number] - The level of the unit
--     elite[String] - The elite state of the unit (See UnitClassification())
--     player[Boolean] - Returns true if unit is a player
--
-- Internal functions:
--   libcast:AddData(db, name, class, level, elite)
--     Adds unit data to a given db. Where db should be either "players" or "mobs"
--

-- return instantly when another librange is already active
if zUI.api.libunitscan then return end

local units = { players = {}, mobs = {} }
local queue = { }

function GetUnitData(name, active)
  if units["players"][name] then
    local ret = units["players"][name]
    return ret.class, ret.level, ret.elite, ret.guild, true
  elseif units["mobs"][name] then
    local ret = units["mobs"][name]
    return ret.class, ret.level, ret.elite, nil, nil
  elseif active then
    queue[name] = true
    libunitscan:Show()
  end
end

local function AddData(db, name, class, level, guild, elite)
  if not name then return end
  units[db][name] = units[db][name] or {}
  units[db][name].class = class or units[db][name].class
  units[db][name].level = level or units[db][name].level
  units[db][name].elite = elite or units[db][name].elite
  units[db][name].guild = guild or units[db][name].guild
  queue[name] = nil
end

local libunitscan = CreateFrame("Frame", "zUnitScan", UIParent)
libunitscan:RegisterEvent("PLAYER_ENTERING_WORLD")
libunitscan:RegisterEvent("FRIENDLIST_UPDATE")
libunitscan:RegisterEvent("GUILD_ROSTER_UPDATE")
libunitscan:RegisterEvent("RAID_ROSTER_UPDATE")
libunitscan:RegisterEvent("PARTY_MEMBERS_CHANGED")
libunitscan:RegisterEvent("PLAYER_TARGET_CHANGED")
libunitscan:RegisterEvent("WHO_LIST_UPDATE")
libunitscan:RegisterEvent("CHAT_MSG_SYSTEM")
libunitscan:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
libunitscan:SetScript("OnEvent", function()
  
  -- 进入世界
  if event == "PLAYER_ENTERING_WORLD" then

    -- load zUI_playerDB
    units.players = zUI_playerDB

    -- update own character details
    local name = UnitName("player")
    local _, class = UnitClass("player")
    local level = UnitLevel("player")
    local elite = nil
    local guild, _, _ = GetGuildInfo("player")

    AddData("players", name, class, level, elite, guild)

    -- 好友更新
  elseif event == "FRIENDLIST_UPDATE" then
    local name, class, level, guild
    for i = 1, GetNumFriends() do
      name, level, class = GetFriendInfo(i)
      class = L["class"][class] or nil
      guild, _, _ = GetGuildInfo(name)
      AddData("players", name, class, level, guild)
    end

    --公会成员更新
  elseif event == "GUILD_ROSTER_UPDATE" then
    local name, class, level, guild, _
    for i = 1, GetNumGuildMembers() do
      name, _, _, level, class = GetGuildRosterInfo(i)
      class = L["class"][class] or nil
      guild, _, _ = GetGuildInfo(name)
      AddData("players", name, class, level, guild)
    end

    -- 团队成员更新
  elseif event == "RAID_ROSTER_UPDATE" then
    local name, class, SubGroup, level, _
    for i = 1, GetNumRaidMembers() do
      name, _, SubGroup, level, class = GetRaidRosterInfo(i)
      class = L["class"][class] or nil
      local guild, _, _ = GetGuildInfo("player")
      AddData("players", name, class, level, guild)
    end

    -- 小队成员更新
  elseif event == "PARTY_MEMBERS_CHANGED" then
    local name, class, level, unit, guild, _
    for i = 1, GetNumPartyMembers() do
      unit = "party" .. i
      _, class = UnitClass(unit)
      name = UnitName(unit)
      level = UnitLevel(unit)
      guild, _, _ = GetGuildInfo(unit)
      AddData("players", name, class, level, guild)
    end

  elseif event == "WHO_LIST_UPDATE" or event == "CHAT_MSG_SYSTEM" then
    local name, class, level, guild, _
    for i = 1, GetNumWhoResults() do
      name, guild, level, _, class, _  = GetWhoInfo(i)
      class = L["class"][class] or nil
      guild, _, _ = GetGuildInfo(name)
      AddData("players", name, class, level, guild)
    end

  elseif event == "UPDATE_MOUSEOVER_UNIT" or event == "PLAYER_TARGET_CHANGED" then
    local scan = event == "PLAYER_TARGET_CHANGED" and "target" or "mouseover"
    local name, class, level, elite, guild, _
    if UnitIsPlayer(scan) then
      _, class = UnitClass(scan)
      level = UnitLevel(scan)
      name = UnitName(scan)
      guild, _, _ = GetGuildInfo(scan)
      AddData("players", name, class, level, guild)
    else
      _, class = UnitClass(scan)
      elite = UnitClassification(scan)
      level = UnitLevel(scan)
      name = UnitName(scan)
      AddData("mobs", name, class, level, nil, elite)
    end
  end
end)

-- since TargetByName can only be triggered within vanilla,
-- we can't auto-scan targets on further expansions.
if zUI.client <= 11200 then
  libunitscan:SetScript("OnUpdate", function()
    -- don't scan when another unit is in target
    if UnitExists("target") or UnitName("target") then return end

    local name = next(queue)
    if name then
      -- try to target the unknown unit
      TargetByName(name, true)
      ClearTarget()
      queue[name] = nil
    end

    this:Hide()
  end)
end

zUI.api.libunitscan = libunitscan
