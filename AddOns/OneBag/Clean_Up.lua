-- Repository: https://github.com/shirsig/Clean_Up-lib
-- Usage: Clean_Up(containers [, reverse])
-- containers - 'bags' or 'bank'
-- reverse - boolean

if Clean_Up then return end
local _G, _M = getfenv(0), {}
setfenv(1, setmetatable(_M, {__index=_G}))

CreateFrame('GameTooltip', 'SortBagsTooltip', nil, 'GameTooltipTemplate')

function _G.Clean_Up(containers, reverse)
	if containers == 'bags' then
		CONTAINERS = {0, 1, 2, 3, 4}
	elseif containers == 'bank' then
		CONTAINERS = {-1, 5, 6, 7, 8, 9, 10}
	else
		error()
	end
	REVERSE = reverse
	Start()
end

local function set(...)
	local t = {}
	for i = 1, arg.n do
		t[arg[i]] = true
	end
	return t
end

local function union(...)
	local t = {}
	for i = 1, arg.n do
		for k in arg[i] do
			t[k] = true
		end
	end
	return t
end

--返回类型
--1武器,2护甲,3容器,4消耗品,5商品,6弹药,7箭袋,8配方,9材料,10其他
local ITEM_TYPES = {GetAuctionItemClasses()}

--特殊物品
local SPECIAL = set(5462, 13347, 17056, 9173, 11511)

--道具(如祖尔法拉克之锤)
local KEYS = set(9240, 17191, 13544, 12324, 16309, 12384, 20402)

--工具(如剥皮刀)
local TOOLS = set(6218, 6339, 11130, 11145, 16207, 5060, 7005, 12709, 19727, 5956, 2901, 6219, 10498, 9149, 15846, 6256, 6365, 6366, 6367, 12225, 19022, 19970)

--附魔
local ENCHANTING_MATERIALS = set(
	-- dust 魔尘
	10940, 11083, 11137, 11176, 16204,
	-- essence 精华
	10938, 10939, 10998, 11082, 11134, 11135, 11174, 11175, 16202, 16203,
	-- shard 碎片
	10978, 11084, 11138, 11139, 11177, 11178, 14343, 14344,
	-- crystal 连结水晶
	20725
)

--草药
local HERBS = set(765, 785, 2447, 2449, 2450, 2452, 2453, 3355, 3356, 3357, 3358, 3369, 3818, 3819, 3820, 3821, 4625, 8153, 8831, 8836, 8838, 8839, 8845, 8846, 13463, 13464, 13465, 13466, 13467, 13468)

--种子
local SEEDS = set(17034, 17035, 17036, 17037, 17038)

--容器
local CLASSES = {
	-- arrow 箭袋
	{
		containers = {2101, 5439, 7278, 11362, 3573, 3605, 7371, 8217, 2662, 19319, 18714},
		items = set(2512, 2515, 3030, 3464, 9399, 11285, 12654, 18042, 19316),
	},
	-- bullet 弹药包
	{
		containers = {2102, 5441, 7279, 11363, 3574, 3604, 7372, 8218, 2663, 19320},
		items = set(2516, 2519, 3033, 3465, 4960, 5568, 8067, 8068, 8069, 10512, 10513, 11284, 11630, 13377, 15997, 19317),
	},
	-- soul 灵魂袋
	{
		containers = {22243, 22244, 21340, 21341, 21342},
		items = set(6265),
	},
	-- ench 附魔包
	{
		containers = {22246, 22248, 22249},
		items = union(
			ENCHANTING_MATERIALS,
			-- rods 附魔棒
			set(6218, 6339, 11130, 11145, 16207)
		),
	},
	-- herb 草药袋
	{
		containers = {22250, 22251, 22252},
		items = union(HERBS, SEEDS)
	},
}

local model, itemStacks, itemClasses, itemSortKeys

do
	local f = CreateFrame'Frame'
	f:Hide()
	
	local timeout
	function Start()
		if f:IsShown() then return end
		Initialize()
		timeout = GetTime() + 6
		f:Show()
	end

	local delay = 0
	f:SetScript('OnUpdate', function()
		delay = delay - arg1
		if delay <= 0 then
			delay = 1.2

			local complete = Sort()
			if complete or GetTime() > timeout then
				f:Hide()
				return
			end
			Stack()
		end
	end)
end

do
	local function key(table, value)
		for k, v in table do
			if v == value then
				return k
			end
		end
	end

	function ItemTypeKey(itemClass)
		return key(ITEM_TYPES, itemClass) or 0
	end
	
	--返回物品子类
	function ItemSubTypeKey(itemClass, itemSubClass)
		return key({GetAuctionItemSubClasses(ItemTypeKey(itemClass))}, itemClass) or 0
	end

	function ItemInvTypeKey(itemClass, itemSubClass, itemSlot)
		return key({GetAuctionInvTypes(ItemTypeKey(itemClass), ItemSubTypeKey(itemSubClass))}, itemSlot) or 0
	end
end

function LT(a, b)
	local i = 1
	while true do
		if a[i] and b[i] and a[i] ~= b[i] then
			return a[i] < b[i]
		elseif not a[i] and b[i] then
			return true
		elseif not b[i] then
			return false
		end
		i = i + 1
	end
end

function Move(src, dst)
    local texture, _, srcLocked = GetContainerItemInfo(src.container, src.position)
    local _, _, dstLocked = GetContainerItemInfo(dst.container, dst.position)

	if texture and not srcLocked and not dstLocked then
		ClearCursor()
       	PickupContainerItem(src.container, src.position)
		PickupContainerItem(dst.container, dst.position)

		if src.item == dst.item then
			local count = min(src.count, itemStacks[dst.item] - dst.count)
			src.count = src.count - count
			dst.count = dst.count + count
			if src.count == 0 then
				src.item = nil
			end
		else
			src.item, dst.item = dst.item, src.item
			src.count, dst.count = dst.count, src.count
		end

		return true
    end
end

function TooltipInfo(container, position)
	local chargesPattern = '^' .. gsub(gsub(ITEM_SPELL_CHARGES_P1, '%%d', '(%%d+)'), '%%%d+%$d', '(%%d+)') .. '$'
	
	SetScanTooltip(container, position)

	local charges, usable, soulbound, quest, conjured, mount
	for i = 1, SortBagsTooltip:NumLines() do
		local text = getglobal('SortBagsTooltipTextLeft' .. i):GetText()

		local _, _, chargeString = strfind(text, chargesPattern)
		if chargeString then
			charges = tonumber(chargeString)
		elseif strfind(text, '^' .. ITEM_SPELL_TRIGGER_ONUSE) then
			usable = true
		elseif text == ITEM_SOULBOUND then
			soulbound = true
		elseif text == ITEM_BIND_QUEST then
			quest = true
		elseif text == ITEM_CONJURED then
			conjured = true
		elseif strfind(text, "需要骑术") then
			mount = true
		end
	end

	return charges or 1, usable, soulbound, quest, conjured, mount
end

function SetScanTooltip(container, position)
	SortBagsTooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	SortBagsTooltip:ClearLines()

	if container == BANK_CONTAINER then
		SortBagsTooltip:SetInventoryItem('player', BankButtonIDToInvSlotID(position))
	else
		SortBagsTooltip:SetBagItem(container, position)
	end
end

function Sort()
	local complete = true

	for _, dst in ipairs(model) do
		if dst.targetItem and (dst.item ~= dst.targetItem or dst.count < dst.targetCount) then
			complete = false

			local sources, rank = {}, {}

			for _, src in ipairs(model) do
				if src.item == dst.targetItem
					and src ~= dst
					and not (dst.item and src.class and src.class ~= itemClasses[dst.item])
					and not (src.targetItem and src.item == src.targetItem and src.count <= src.targetCount)
				then
					rank[src] = abs(src.count - dst.targetCount + (dst.item == dst.targetItem and dst.count or 0))
					tinsert(sources, src)
				end
			end

			sort(sources, function(a, b) return rank[a] < rank[b] end)

			for _, src in ipairs(sources) do
				if Move(src, dst) then
					break
				end
			end
		end
	end

	return complete
end

--自动堆叠
function Stack()
	for _, src in ipairs(model) do
		if src.item and src.count < itemStacks[src.item] and src.item ~= src.targetItem then
			for _, dst in ipairs(model) do
				if dst ~= src and dst.item and dst.item == src.item and dst.count < itemStacks[dst.item] and dst.item ~= dst.targetItem then
					if Move(dst, src) then
						return
					end
				end
			end
		end
	end
end

do
	local counts

	local function insert(t, v)
		if REVERSE then
			tinsert(t, v)
		else
			tinsert(t, 1, v)
		end
	end

	local function assign(slot, item)
		if counts[item] > 0 then
			local count
			if REVERSE and mod(counts[item], itemStacks[item]) ~= 0 then
				count = mod(counts[item], itemStacks[item])
			else
				count = min(counts[item], itemStacks[item])
			end
			slot.targetItem = item
			slot.targetCount = count
			counts[item] = counts[item] - count
			return true
		end
	end

	function Initialize()
		model, counts, itemStacks, itemClasses, itemSortKeys = {}, {}, {}, {}, {}

		for _, container in ipairs(CONTAINERS) do
			local class = ContainerClass(container)
			for position = 1, GetContainerNumSlots(container) do
				local slot = {container=container, position=position, class=class}
				local item = Item(container, position)
				if item then
					local _, count, locked = GetContainerItemInfo(container, position)
					if locked then
						return false
					end
					slot.item = item
					slot.count = count
					counts[item] = (counts[item] or 0) + count
				end
				insert(model, slot)
			end
		end

		local free = {}
		for item, count in pairs(counts) do
			local stacks = ceil(count / itemStacks[item])
			free[item] = stacks
			if itemClasses[item] then
				free[itemClasses[item]] = (free[itemClasses[item]] or 0) + stacks
			end
		end
		for _, slot in ipairs(model) do
			if slot.class and free[slot.class] then
				free[slot.class] = free[slot.class] - 1
			end
		end

		local items = {}
		for item in pairs(counts) do
			tinsert(items, item)
		end
		sort(items, function(a, b) return LT(itemSortKeys[a], itemSortKeys[b]) end)

		for _, slot in ipairs(model) do
			if slot.class then
				for _, item in ipairs(items) do
					if itemClasses[item] == slot.class and assign(slot, item) then
						break
					end
				end
			else
				for _, item in ipairs(items) do
					if (not itemClasses[item] or free[itemClasses[item]] > 0) and assign(slot, item) then
						if itemClasses[item] then
							free[itemClasses[item]] = free[itemClasses[item]] - 1
						end
						break
					end
				end
			end
		end
		return true
	end
end

function ContainerClass(container)
	if container ~= 0 and container ~= BANK_CONTAINER then
		local name = GetBagName(container)
		if name then		
			for class, info in pairs(CLASSES) do
				for _, itemID in pairs(info.containers) do
					if name == GetItemInfo(itemID) then
						return class
					end
				end	
			end
		end
	end
end

function Item(container, position)
	local link = GetContainerItemLink(container, position)
	if link then
		local _, _, itemID, enchantID, suffixID, uniqueID = strfind(link, 'item:(%d+):(%d*):(%d*):(%d*)')
		itemID = tonumber(itemID)
		local _, _, quality, _, itemType, subType, stack, invType = GetItemInfo('item:' .. itemID)
		local charges, usable, soulbound, quest, conjured, mount = TooltipInfo(container, position)
		--local _, itemCount = GetContainerItemInfo(container, position)
		
		local sortKey = {}

		-- hearthstone 炉石
		if itemID == 6948 then
			tinsert(sortKey, 1)

		-- mounts 坐骑
		elseif mount then
			tinsert(sortKey, 2)

		-- special items 特殊物品
		elseif SPECIAL[itemID] then
			tinsert(sortKey, 3)

		-- key items 道具(如祖尔法拉克之锤)
		elseif KEYS[itemID] then
			tinsert(sortKey, 4)

		-- tools 工具(如剥皮刀)
		elseif TOOLS[itemID] then
			tinsert(sortKey, 5)

		-- soul shards 灵魂石
		elseif itemID == 6265 then
			tinsert(sortKey, 14)

		-- conjured items 魔法制造的物品
		elseif conjured then
			tinsert(sortKey, 15)

		-- soulbound items 灵魂绑定物品
		elseif soulbound then
			tinsert(sortKey, 6)

		-- reagents 材料
		elseif itemType == ITEM_TYPES[9] then
			tinsert(sortKey, 7)

		-- quest items 任务物品
		elseif quest then
			tinsert(sortKey, 9)

		-- consumables 消耗品
		elseif usable and itemType ~= ITEM_TYPES[1] and itemType ~= ITEM_TYPES[2] and itemType ~= ITEM_TYPES[8] or itemType == ITEM_TYPES[4] then
			tinsert(sortKey, 8)

		-- enchanting materials 附魔物品
		elseif ENCHANTING_MATERIALS[itemID] then
			tinsert(sortKey, 10)

		-- herbs 草药
		elseif HERBS[itemID] then
			tinsert(sortKey, 12)

		-- higher quality 蓝色、紫色等高质量物品
		elseif quality > 1 then
			tinsert(sortKey, 11)

		-- common quality 白色物品
		elseif quality == 1 then
			tinsert(sortKey, 13)

		-- junk 灰色物品
		elseif quality == 0 then
			tinsert(sortKey, 14)
		end
		
		tinsert(sortKey, ItemTypeKey(itemType))
		tinsert(sortKey, ItemInvTypeKey(itemType, subType, invType))
		tinsert(sortKey, ItemSubTypeKey(itemType, subType))
		tinsert(sortKey, -quality)
		tinsert(sortKey, itemID)
		tinsert(sortKey, (REVERSE and 1 or -1) * charges)
		tinsert(sortKey, suffixID)
		tinsert(sortKey, enchantID)
		tinsert(sortKey, uniqueID)

		local key = format('%s:%s:%s:%s:%s:%s', itemID, enchantID, suffixID, uniqueID, charges, (soulbound and 1 or 0))

		itemStacks[key] = stack
		itemSortKeys[key] = sortKey

		for class, info in CLASSES do
			if info.items[itemID] then
				itemClasses[key] = class
				break
			end
		end

		return key
	end
end