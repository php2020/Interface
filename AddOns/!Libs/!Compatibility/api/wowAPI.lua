--Cache global variables
local _G = _G
local date = date
local error = error
local pairs = pairs
local select = select
local tonumber = tonumber
local type = type
local unpack = unpack
local find, format, gmatch, gsub, len, lower, match, upper, sub = string.find, string.format, string.gmatch, string.gsub, string.len, string.lower, string.match, string.upper, string.sub
local getn = table.getn
--WoW API
local debugstack = debugstack
local GetContainerItemInfo = GetContainerItemInfo
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetInventoryItemTexture = GetInventoryItemTexture
local GetItemInfo = GetItemInfo
local GetQuestGreenRange = GetQuestGreenRange
local UnitLevel = UnitLevel
--WoW Variables
local NUM_BAG_FRAMES = NUM_BAG_FRAMES

CLASS_ICON_TCOORDS = {
	["WARRIOR"] = {0, 0.25, 0, 0.25},
	["MAGE"] = {0.25, 0.49609375, 0, 0.25},
	["ROGUE"] = {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"] = {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"] = {0, 0.25, 0.25, 0.5},
	["SHAMAN"] = {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"] = {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"] = {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"] = {0, 0.25, 0.5, 0.75}
}

--更新RAID_CLASS_COLORS表
local UpClassColor = CreateFrame("Frame", nil, UIParent)
UpClassColor:RegisterEvent("ADDON_LOADED")
local function UpdateColors()
	RAID_CLASS_COLORS = {
		["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, colorStr = "ffc79c6e" },
		["MAGE"]    = { r = 0.41, g = 0.8,  b = 0.94, colorStr = "ff69ccf0" },
		["ROGUE"]   = { r = 1,    g = 0.96, b = 0.41, colorStr = "fffff569" },
		["DRUID"]   = { r = 1,    g = 0.49, b = 0.04, colorStr = "ffff7d0a" },
		["HUNTER"]  = { r = 0.67, g = 0.83, b = 0.45, colorStr = "ffabd473" },
		["SHAMAN"]  = { r = 0.14, g = 0.35, b = 1.0,  colorStr = "ff0070de" },
		["PRIEST"]  = { r = 1,    g = 1,    b = 1,    colorStr = "ffffffff" },
		["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, colorStr = "ff9482c9" },
		["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, colorStr = "fff58cba" },
	}

	RAID_CLASS_COLORS = setmetatable(RAID_CLASS_COLORS, { __index = function(tab,key)
		return { r = 0.6,  g = 0.6,  b = 0.6,  colorStr = "ff999999" }
	end})
end

UpClassColor:SetScript("OnEvent", function()
	UpdateColors()
end)

function HookScript(frame, scriptName, handler)
	if not (type(frame) == "table" and frame.GetScript and type(scriptName) == "string" and type(handler) == "function") then
		error("Usage: HookScript(frame, \"type\", function)", 2)
	end

	local original_scipt = frame:GetScript(scriptName)
	if original_scipt then
		frame:SetScript(scriptName, function()
			original_scipt(this)
			handler(this)
		end)
	else
		frame:SetScript(scriptName, handler)
	end
end

--用于界面UI框架的Hook
--举例HookAddonOrVariable("Blizzard_InspectUI", function() xxx end)
function HookAddonOrVariable(addon, func)
  local lurker = CreateFrame("Frame", nil)
  lurker.func = func
  lurker:RegisterEvent("ADDON_LOADED")
  lurker:RegisterEvent("VARIABLES_LOADED")
  lurker:RegisterEvent("PLAYER_ENTERING_WORLD")
  lurker:SetScript("OnEvent",function()
    -- only run when config is available
    if event == "ADDON_LOADED" and not this.foundConfig then
      return
    elseif event == "VARIABLES_LOADED" then
      this.foundConfig = true
    end

    if IsAddOnLoaded(addon) or _G[addon] then
      this:func()
      this:UnregisterAllEvents()
    end
  end)
end

function hooksecurefunc(a1, a2, a3)
	local isMethod = type(a1) == "table" and type(a2) == "string" and type(a1[a2]) == "function" and type(a3) == "function"
	if not (isMethod or (type(a1) == "string" and type(_G[a1]) == "function" and type(a2) == "function")) then
		error("Usage: hooksecurefunc([table,] \"functionName\", hookfunc)", 2)
	end

	if not isMethod then
		a1, a2, a3 = _G, a1, a2
	end

	local original_func = a1[a2]

	a1[a2] = function(...)
		local original_return = {original_func(unpack(arg))}
		a3(unpack(arg))

		return unpack(original_return)
	end
end

local secureFunctions = {
	["CameraOrSelectOrMoveStop"] = true,
	["MoveBackwardStop"] = true,
	["MoveForwardStop"] = true,
	["PitchDownStop"] = true,
	["PitchUpStop"] = true,
	["StrafeLeftStart"] = true,
	["StrafeRightStart"] = true,
	["ToggleMouseMove"] = true,
	["TurnLeftStart"] = true,
	["TurnOrActionStop"] = true,
	["TurnRightStart"] = true,
	["CameraOrSelectOrMoveStart"] = true,
	["Jump"] = true,
	["MoveBackwardStart"] = true,
	["MoveForwardStart"] = true,
	["PitchDownStart"] = true,
	["PitchUpStart"] = true,
	["StrafeLeftStop"] = true,
	["StrafeRightStop"] = true,
	["ToggleRun"] = true,
	["TurnLeftStop"] = true,
	["TurnOrActionStart"] = true,
	["TurnRightStop"] = true
}
local secureScripts = {}
function issecurevariable(a1, a2)
--	local isMethod = type(a1) == "table" and type(a2) == "string" and type(a1[a2]) == "function"
--	if not (isMethod or (type(a1) == "string" and type(_G[a1]) == "function") then
--		error("Usage: issecurevariable([table,] \"variable\")", 2)
--	end
--
--	local isSecure
--	if isMethod then
--		isSecure = secureScripts[a2] and 1
--	else
--		isSecure = secureFunctions[a1] and 1
--	end
--
--	return isSecure

	if type(a1) == "table" then return end

	if type(a1) ~= "string" then
		error("Usage: issecurevariable([table,] \"variable\")", 2)
	end

	return secureFunctions[a1] and 1
end

function issecure()
	return
end

function securecall(f, ...)
	if arg.n > 0 then
		_G[f](unpack(arg))
	else
		_G[f]()
	end
end

function tContains(table, item)
	local index = 1

	while table[index] do
		if item == table[index] then
			return 1
		end
		index = index + 1
	end

	return
end

function difftime(time2, time1)
	if type(time2) ~= "number" then
		error(format("bad argument #1 to 'difftime' (number expected, got %s)", time2 and type(time2) or "no value"), 2)
	elseif time1 and type(time1) ~= "number" then
		error(format("bad argument #2 to 'difftime' (number expected, got %s)", time1 and type(time1) or "no value"), 2)
	end

	return time1 and time2 - time1 or time2
end

function BetterDate(formatString, timeVal)
	local dateTable = date("*t", timeVal)
	local amString = (dateTable.hour >= 12) and "PM" or "AM"

	--First, we'll replace %p with the appropriate AM or PM.
	formatString = gsub(formatString, "^%%p", amString)	--Replaces %p at the beginning of the string with the am/pm token
	formatString = gsub(formatString, "([^%%])%%p", "%1"..amString) -- Replaces %p anywhere else in the string, but doesn't replace %%p (since the first % escapes the second)

	return date(formatString, timeVal)
end

--返回任务等级难度对应的颜色
QuestDifficultyColors = {
	["impossible"] = {r = 1.00, g = 0.10, b = 0.10},
	["verydifficult"] = {r = 1.00, g = 0.50, b = 0.25},
	["difficult"] = {r = 1.00, g = 1.00, b = 0.00},
	["standard"] = {r = 0.25, g = 0.75, b = 0.25},
	["trivial"] = {r = 0.50, g = 0.50, b = 0.50},
	["header"] = {r = 0.70, g = 0.70, b = 0.70}
}

function GetQuestDifficultyColor(level)
	local levelDiff = level - UnitLevel("player")
	if levelDiff >= 5 then
		return QuestDifficultyColors["impossible"]
	elseif levelDiff >= 3 then
		return QuestDifficultyColors["verydifficult"]
	elseif levelDiff >= -2 then
		return QuestDifficultyColors["difficult"]
	elseif -levelDiff <= GetQuestGreenRange() then
		return QuestDifficultyColors["standard"]
	else
		return QuestDifficultyColors["trivial"]
	end
end

function GetMapNameByID(id)
	if not (type(id) == "string" or type(id) == "number") then
		error(format("Bad argument #1 to \"GetMapNameByID\" (number expected, got %s)", id and type(id) or "no value"), 2)
	end

	return mapByID[tonumber(id)]
end

--框架开/关
function ToggleFrame(frame)
	if frame:IsShown() then
		HideUIPanel(frame)
	else
		ShowUIPanel(frame)
	end
end

local function OnOrientationChanged(self, orientation)
	self.texturePointer.verticalOrientation = orientation == "VERTICAL"

	if self.texturePointer.verticalOrientation then
		self.texturePointer:SetPoint("BOTTOMLEFT", self)
	else
		self.texturePointer:SetPoint("LEFT", self)
	end
end

local function OnSizeChanged()
	local width, height = this:GetWidth(), this:GetHeight()

	this.texturePointer.width = width
	this.texturePointer.height = height
	this.texturePointer:SetWidth(width)
	this.texturePointer:SetHeight(height)
end

local function OnValueChanged()
	local _, max = this:GetMinMaxValues()

	if this.texturePointer.verticalOrientation then
		this.texturePointer:SetHeight(this.texturePointer.height * (arg1 / max))
	else
		this.texturePointer:SetWidth(this.texturePointer.width * (arg1 / max))
	end
end

function CreateStatusBarTexturePointer(statusbar)
	if type(statusbar) ~= "table" then
		error(format("Bad argument #1 to \"CreateStatusBarTexturePointer\" (table expected, got %s)", statusbar and type(statusbar) or "no value"), 2)
	elseif not (statusbar.GetObjectType and statusbar:GetObjectType() == "StatusBar") then
		error("Bad argument #1 to \"CreateStatusBarTexturePointer\" (statusbar object expected)", 2)
	end

	local f = statusbar:CreateTexture()
	f.width = statusbar:GetWidth()
	f.height = statusbar:GetHeight()
	f.vertical = statusbar:GetOrientation() == "VERTICAL"
	f:SetWidth(f.width)
	f:SetHeight(f.height)

	if f.verticalOrientation then
		f:SetPoint("BOTTOMLEFT", statusbar)
	else
		f:SetPoint("LEFT", statusbar)
	end

	statusbar.texturePointer = f

	statusbar:SetScript("OnSizeChanged", OnSizeChanged)
	statusbar:SetScript("OnValueChanged", OnValueChanged)

	hooksecurefunc(statusbar, "SetOrientation", OnOrientationChanged)

	return f
end

local function removeScript(self, script)
	local func = self:GetScript(script)

	if func then
		self:SetScript(script, nil)
	end

	return func
end

local nbsp = string.char(255)
function EditBoxGetCursorPosition(self)
	if self == WowLuaFrameEditBox or self == WowLuaFrameCommandEditBox then return 0 end

	if self:GetText() == "" then return 0 end

	local occ = removeScript(self, "OnCursorChanged")
	local otc = removeScript(self, "OnTextChanged")
	local ots = removeScript(self, "OnTextSet")

	self:Insert(nbsp)

	local pos = find(self:GetText(), nbsp)
	if not pos then
		pos = len(self:GetText())
		print(format("CursorPosition position for `%s` not found!", self.GetName and self:GetName() or tostring(self)))
	else
		self:HighlightText(pos - 1, pos)
		self:Insert("")
	end

	if occ then self:SetScript("OnCursorChanged", occ) end
	if otc then self:SetScript("OnTextChanged", otc) end
	if ots then self:SetScript("OnTextSet", ots) end

	return pos - 1
end

function EditBoxSetCursorPosition(self, pos)
	if self == WowLuaFrameEditBox or self == WowLuaFrameCommandEditBox then return end

	if self:GetText() == "" then return end

	local occ = removeScript(self, "OnCursorChanged")
	local otc = removeScript(self, "OnTextChanged")
	local ots = removeScript(self, "OnTextSet")

	local text = self:GetText()
	local size = len(text)

	if pos < 0 then
		pos = 0
	elseif pos > size then
		pos = size
	end

	if pos == 0 then
		text = sub(text, 0, 1)
		self:HighlightText(0, 1)
		self:Insert(nbsp)
		self:Insert(text)
		self:HighlightText(0, 1)
		self:Insert("")
	else
		text = sub(text, pos, pos)
		self:HighlightText(pos - 1, pos)
		self:Insert(text)
	end

	if occ then self:SetScript("OnCursorChanged", occ) end
	if otc then self:SetScript("OnTextChanged", otc) end
	if ots then self:SetScript("OnTextSet", ots) end
end

--仇恨染色
local threatColors = {
	[0] = {0, 1, 0},
	[1] = {1, 1, 0},
	[2] = {1, 0.5, 0},
	[3] = {1, 0, 0}
}

function GetThreatStatusColor(statusIndex)
	if not (type(statusIndex) == "number" and statusIndex >= 0 and statusIndex < 4) then
		statusIndex = 0
	end

	return threatColors[statusIndex][1], threatColors[statusIndex][2], threatColors[statusIndex][3]
end

function GetThreatStatus(currentThreat, maxThreat)
	if type(currentThreat) ~= "number" or type(maxThreat) ~= "number" then
		error("Usage: GetThreatStatus(currentThreat, maxThreat)", 2)
	end

	if not currentThreat or currentThreat == nil then
		currentThreat = 0
	end
		
	if not maxThreat or maxThreat == 0 then
		currentThreat = 0
		maxThreat = 1
	end

	local threatPercent = currentThreat / maxThreat * 100
	if threatPercent > 100 then threatPercent = 100 end
	
	if threatPercent >= 90 then
		return 3, threatPercent
	elseif threatPercent >= 70 then
		return 2, threatPercent
	elseif threatPercent >= 50 then
		return 1, threatPercent
	else
		return 0, threatPercent
	end
end

--获取物品ID
function GetItemID(item)
	if type(item) == "number" then
		return item
	elseif type(item) == "string" then
		local _, _, id = string.find(item, "item:(%d+):%d+:%d+:%d+")
		if id then
			return tonumber(id)
		end
	end
end

function ItemLinkToName(link)
	if ( link ) then
		return gsub(link,"^.*%[(.*)%].*$","%1")
	end
end

--获取背包内物品信息
function FindItemInfo(item)
	if ( not item ) then return end
	item = lower(ItemLinkToName(item))
	local link
	for i = 1,23 do
		link = GetInventoryItemLink("player",i)
		if ( link ) then
			if ( item == lower(ItemLinkToName(link)) )then
				return i, nil, GetInventoryItemTexture('player', i), GetInventoryItemCount('player', i)
			end
		end
	end
	local bag, slot, texture, totalcount
	local count = 0
	local totalcount = 0
	for i = 0,NUM_BAG_FRAMES do
		for j = 1,MAX_CONTAINER_ITEMS do
			link = GetContainerItemLink(i,j)
			if ( link ) then
				if ( item == lower(ItemLinkToName(link))) then
					bag, slot = i, j
					texture, count = GetContainerItemInfo(i,j)
					totalcount = totalcount + count
				end
			end
		end
	end
	return bag, slot, texture, count, totalcount
end

--返回带词缀物品的ID
local LAST_ITEM_ID = 24283
local itemInfoDB = {}

function GetItemInfoByName(itemName)
	if type(itemName) ~= "string" then
		error("Usage: GetItemInfoByName(itemName)", 2)
	end

	if find(itemName, "之") then
		-- random enchantments
		itemName = gsub(itemName, "雄鹰之", "")
		itemName = gsub(itemName, "灵猴之", "")
		itemName = gsub(itemName, "野熊之", "")
		itemName = gsub(itemName, "巨猿之", "")
		itemName = gsub(itemName, "猎鹰之", "")
		itemName = gsub(itemName, "野猪之", "")
		itemName = gsub(itemName, "夜枭之", "")
		itemName = gsub(itemName, "巨鲸之", "")
		itemName = gsub(itemName, "孤狼之", "")
		itemName = gsub(itemName, "猛虎之", "")
		itemName = gsub(itemName, "耐力之", "")
		itemName = gsub(itemName, "敏捷之", "")
		itemName = gsub(itemName, "智力之", "")
		itemName = gsub(itemName, "精神之", "")
		itemName = gsub(itemName, "力量之", "")
		itemName = gsub(itemName, "治疗之", "")
		itemName = gsub(itemName, "防御之", "")
		itemName = gsub(itemName, "能量之", "")
		itemName = gsub(itemName, "闪避之", "")
		itemName = gsub(itemName, "再生之", "")
		itemName = gsub(itemName, "专注之", "")
		itemName = gsub(itemName, "精准之", "")
		itemName = gsub(itemName, "巫术之", "")
		itemName = gsub(itemName, "坚韧之", "")
		itemName = gsub(itemName, "自然惩戒之", "")
		itemName = gsub(itemName, "冰霜惩戒之", "")
		itemName = gsub(itemName, "奥法惩戒之", "")
		itemName = gsub(itemName, "暗影惩戒之", "")
		itemName = gsub(itemName, "火焰惩戒之", "")
		itemName = gsub(itemName, "自然抗性之", "")
		itemName = gsub(itemName, "奥术抗性之", "")
		itemName = gsub(itemName, "暗影抗性之", "")
		itemName = gsub(itemName, "火焰抗性之", "")
		itemName = gsub(itemName, "冰霜抗性之", "")
	end

	if not itemInfoDB[itemName] then
		local name
		for itemID = 1, LAST_ITEM_ID do
			name = GetItemInfo(itemID)

			if name ~= nil and name ~= "" then
				itemInfoDB[name] = itemID

				if name == itemName then
					break
				end
			end
		end
	end

	if not itemInfoDB[itemName] then return end

	return GetItemInfo(itemInfoDB[itemName])
end

--新增
-- [ GetSpellMaxRank ]
-- Returns the maximum rank of a players spell.
-- 'name'       [string]            spellname to query
-- return:      [string],[number]   maximum rank in characters and the number
--                                  e.g "Rank 1" and "1"
local spellmaxrank = {}
function GetSpellMaxRank(name)
  local cache = spellmaxrank[name]
  if cache then return cache[1], cache[2] end
  local name = lower(name)

  local rank = { 0, nil}
  for i = 1, GetNumSpellTabs() do
    local _, _, offset, num = GetSpellTabInfo(i)
    local bookType = BOOKTYPE_SPELL
    for id = offset + 1, offset + num do
      local spellName, spellRank = GetSpellName(id, bookType)
      if name == lower(spellName) then
        if not rank[2] then rank[2] = spellRank end

        local _, _, numRank = find(spellRank, " (%d+)$")
        if numRank and tonumber(numRank) > rank[1] then
          rank = { tonumber(numRank), spellRank}
        end
      end
    end
  end

  spellmaxrank[name] = { rank[2], rank[1] }
  return rank[2], rank[1]
end

-- [ GetSpellIndex ]
-- Returns the spellbook index and bookid of the given spell.
-- 'name'       [string]            spellname to query
-- 'rank'       [string]            rank to query (optional)
-- return:      [number],[string]   spell index and spellbook id
local spellindex = {}
function GetSpellIndex(name, rank)
  local cache = spellindex[name..(rank or "")]
  if cache then return cache[1], cache[2] end

  if not rank then rank = GetSpellMaxRank(name) end

  for i = 1, GetNumSpellTabs() do
    local _, _, offset, num = GetSpellTabInfo(i)
    local bookType = BOOKTYPE_SPELL
    for id = offset + 1, offset + num do
      local spellName, spellRank = GetSpellName(id, bookType)
      if rank and rank == spellRank and name == spellName then
        spellindex[name..rank] = { id, bookType }
        return id, bookType
      elseif not rank and name == spellName then
        spellindex[name] = { id, bookType }
        return id, bookType
      end
    end
  end
  spellindex[name..(rank or "")] = { nil }
  return nil
end

-- [ GetSpellInfo ]
-- Returns several information about a spell.
-- 'index'      [string/number]     Spellname or Index of a spell in the spellbook
-- 'bookType'   [string]            Type of spellbook (optional)
-- return:
--              [string]            Name of the spell
--              [string]            Secondary text associated with the spell
--                                  (e.g."Rank 5", "Racial", etc.)
--              [string]            Path to an icon texture for the spell
--              [number]            Casting time of the spell in milliseconds
--              [number]            Minimum range from the target required to cast the spell
--              [number]            Maximum range from the target at which you can cast the spell
local spellinfo = {}
function GetSpellInfo(index, bookType)
  local cache = spellinfo[index]
  if cache then return cache[1], cache[2], cache[3] end

  local name, rank, id
  local icon = ""

  if type(index) == "string" then
    local _, _, sname, srank = find(index, '(.+)%((.+)%)')
    name = sname or index
    rank = srank or GetSpellMaxRank(name)
    id, bookType = GetSpellIndex(name, rank)

	-- correct name in case of wrong upper/lower cases
    if id and bookType then
      name = GetSpellName(id, bookType)
    end
  else
    name, rank = GetSpellName(index, bookType)
    id, bookType = GetSpellIndex(name, rank)
  end

  if name and id then
    icon = GetSpellTexture(id, bookType)
  end

  spellinfo[index] = { name, rank, icon }
  return name, rank, icon
end

-- [ 延迟函数 ]
-- 将函数添加到FIFO（先进先出）队列，以便在短暂延迟后执行。
-- '...'        [vararg]        function, [arguments]
local timer
function QueueFunction(a1,a2,a3,a4,a5,a6,a7,a8,a9)
  if not timer then
    timer = CreateFrame("Frame")
    timer.queue = {}
    timer.interval = TOOLTIP_UPDATE_TIME
    timer.DeQueue = function()
      local item = table.remove(timer.queue,1)
      if item then
        item[1](item[2],item[3],item[4],item[5],item[6],item[7],item[8],item[9])
      end
      if table.getn(timer.queue) == 0 then
        timer:Hide() -- no need to run the OnUpdate when the queue is empty
      end
    end
    timer:SetScript("OnUpdate",function()
      this.sinceLast = (this.sinceLast or 0) + arg1
      while (this.sinceLast > this.interval) do
        this.DeQueue()
        this.sinceLast = this.sinceLast - this.interval
      end
    end)
  end
  table.insert(timer.queue,{a1,a2,a3,a4,a5,a6,a7,a8,a9})
  timer:Show() -- start the OnUpdate
end

--单位颜色
local getreactioncolour = function(u)
	if UnitIsPlayer(u) then
		local colour = RAID_CLASS_COLORS[select(2, UnitClass(u))]
		if not colour then return end
		
		r = colour.r
		g = colour.g
		b = colour.b
	else
		if UnitPlayerControlled(u) then
			if UnitCanAttack(u, "player") then
				if not UnitCanAttack("player", u) then
					r = 0.0
					g = 0.0
					b = 1.0
				else
					r = UnitReactionColor[2].r
					g = UnitReactionColor[2].g
					b = UnitReactionColor[2].b
				end
			elseif UnitCanAttack("player", u) then
				r = UnitReactionColor[4].r
				g = UnitReactionColor[4].g
				b = UnitReactionColor[4].b
			elseif UnitIsPVP(u) then
				r = UnitReactionColor[6].r
				g = UnitReactionColor[6].g
				b = UnitReactionColor[6].b
			else
				r = 0.0
				g = 1.0
				b = 0.0
			end
		elseif UnitIsTapped(u) and not UnitIsTappedByPlayer(u) then
			r = 0.5
			g = 0.5
			b = 0.5
		else
			local reaction = UnitReaction(u, "player")
			if reaction then
				r = UnitReactionColor[reaction].r
				g = UnitReactionColor[reaction].g
				b = UnitReactionColor[reaction].b
			else
				r = 0
				g = 0
				b = 1.0
			end
		end
	end
	return r, g, b
end

local checkfaction2 = function(u)
	if not UnitExists(u) then return 0.5, 0.5, 0.5 end
	
	return getreactioncolour(u)
end

local checkmouseover = function()
	local frame = GetMouseFocus() and GetMouseFocus():GetName()
	
	local frames = {
		['PlayerFrame']='player',
		['PetFrame']='pet',
		['TargetFrame']='target',
		['TargetofTargetFrame']='targettarget',
		['PartyMemberFrame1']='party1',
		['PartyMemberFrame1PetFrame']='partypet1',
		['PartyMemberFrame2']='party2',
		['PartyMemberFrame2PetFrame']='partypet2',
		['PartyMemberFrame3']='party3',
		['PartyMemberFrame3PetFrame']='partypet3',
		['PartyMemberFrame4']='party4',
		['PartyMemberFrame4PetFrame']='partypet4',
	}
	
	for f, u in pairs(frames) do
		if frame and f and strfind(frame, f) then
			return checkfaction2(u)
		end
	end

	return 0,1,0
end

function UnitColor(u)
	if not UnitExists(u) then return checkmouseover() end
	
	return getreactioncolour(u)
end

--百分比颜色
local inf = 1/0
function SetPercentColor(quality, worst, worse, normal, better, best)
	if quality ~= quality or quality == inf or quality == -inf then
		return 1, 1, 1
	end
	if not best then
		worst = 0
		worse = 0.25
		normal = 0.5
		better = 0.75
		best = 1
	end
	
	if worst < best then
		if (worse == better and quality == worse) or (worst == best and quality == worst) then
			return 1, 1, 0
		elseif quality <= worst then
			return 1, 0, 0
		elseif quality <= worse then
			return 1, 0.5 * (quality - worst) / (worse - worst), 0
		elseif quality <= normal then
			return 1, 0.5 + 0.5 * (quality - worse) / (normal - worse), 0
		elseif quality <= better then
			return 1 - 0.5 * (quality - normal) / (better - normal), 1, 0
		elseif quality <= best then
			return 0.5 - 0.5 * (quality - better) / (best - better), 1, 0
		else
			return 0, 1, 0
		end
	else
		if (worse == better and quality == worse) or (worst == best and quality == worst) then
			return 1, 1, 0
		elseif quality >= worst then
			return 1, 0, 0
		elseif quality >= worse then
			return 1, 0.5 - 0.5 * (quality - worse) / (worst - worse), 0
		elseif quality >= normal then
			return 1, 1 - 0.5 * (quality - normal) / (worse - normal), 0
		elseif quality >= better then
			return 0.5 + 0.5 * (quality - better) / (normal - better), 1, 0
		elseif quality >= best then
			return 0.5 * (quality - best) / (better - best), 1, 0
		else
			return 0, 1, 0
		end
	end
end

--以"万"显示计数
function Over1E3toW(v)
	if type(v) ~= "number" then return end
	if v > 1E4 then
		text = format("%0.1f万", v/1E4)
	else
		text =  v 
	end
	return text
end

--以"万"显示计数
function BarTextValuetoK(cur, max)
	if cur>1E4 and max>1E4 then
		text = format("%0.1f万/%0.1f万", cur/1E4, max/1E4)
	elseif cur<1E4 and max>1E4 then
		text = format("%d/%0.1f万", cur, max/1E4)
	else
		text = format("%d/%d", cur, max)
	end
	return text
end

--设置宽、高
function SetSize(frame, w, h)
	if not frame then return end
	frame:SetWidth(w)
	frame:SetHeight(h)
end

--渐隐按钮
function EnableAutohide(frame, timeout)
	if not frame then return end

	frame.hover = frame.hover or CreateFrame("Frame", frame:GetName() .. "Autohide", frame)
	frame.hover:SetParent(frame)
	frame.hover:SetAllPoints(frame)
	frame.hover.parent = frame
	frame.hover:Show()

	local timeout = timeout
	frame.hover:SetScript("OnUpdate", function()
		if MouseIsOver(this, 50, -50, -50, 50) then
			this.activeTo = GetTime() + timeout
			this.parent:SetAlpha(1)
		elseif this.activeTo then
			if this.activeTo < GetTime() and this.parent:GetAlpha() > 0 then
				this.parent:SetAlpha(this.parent:GetAlpha() - 0.1)
			end
		else
			this.activeTo = GetTime() + timeout
		end
	end)
end