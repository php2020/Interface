--------------------------------------------------------------------------------------------------------------------------------------------
--
--		Localisations and Local Data
--		============================
--
--------------------------------------------------------------------------------------------------------------------------------------------

local authorLocale;
local addonName, addonTitle = "Trainer";

local abs = math.abs
local atan = math.atan
local cos = math.cos
local find = string.find
local gmatch = string.gmatch or string.gfind		-- LUA 5.0 -> 5.1 renamed gfind to gmatch. This in case 5.0 is used
local lower = string.lower
local pi = math.pi
local rad = math.rad
local sin = math.sin
local sqrt = math.sqrt
local sub = string.sub

local CreateFrame = CreateFrame
local GetAddOnMetadata = GetAddOnMetadata
local GetCursorPosition = GetCursorPosition
local GetPlayerMapPosition = GetPlayerMapPosition
local GetSubZoneText = GetSubZoneText
local GetTime = GetTime
local IsIndoors = IsIndoors							-- From Patch 2.01 onwards. I.e. Use only in TBC+ zones

-- In addition to GetPlayerMapPosition, these are required to get the player (X,Y) World Map coordinates. See the OnUpdate handler
local GetMapInfo = GetMapInfo
local SetMapToCurrentZone = SetMapToCurrentZone

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		Local Functions
--		===============
--
--------------------------------------------------------------------------------------------------------------------------------------------

local function round( num, places )
	-- round to nearest integer, ties round AWAY from zero, as they should. LUA 5.0 does NOT have modf
	-- A similar round() was added to the API in WotLK but this is preferred
	local mult = 10 ^ ( places or 0 )
	return floor( num * mult + ( ( num < 0 and -1 ) or 1 ) * 0.5 ) / mult
end

local root2 = sqrt( 2 )

local function RotationCorners( angle )

	-- My days of linear algebra / matrices are long behind me but thanks to Wikipedia I am sure I got it right

	local r45, r135, r225, rM45 = rad( angle + 45 ), rad( angle + 135 ), rad( angle + 225 ), rad( angle - 45 )
	return 0.5 + cos( r225 ) / root2, 0.5 + sin( r225 ) / root2, 0.5 + cos( r135 ) / root2, 0.5 + sin( r135 ) / root2, 
		0.5 + cos( rM45 ) / root2, 0.5 + sin( rM45 ) / root2, 0.5 + cos( r45 ) / root2, 0.5 + sin( r45 ) / root2
end

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		Build / Version Setup
--		=====================
--
--------------------------------------------------------------------------------------------------------------------------------------------

local buildVersion = GetBuildInfo()
local vanilla, tbc, booleanTrue = false, false;
local _, _, buildVersionMajor, buildVersionMinor, _ = find( buildVersion, "(%d+).(%d+)" )
local _, _, luaVersionMinor = find( (_VERSION or "Lua 5.0"), "%d+.(%d+)" )
if ( buildVersionMajor == "1" ) then
	vanilla = true
	booleanTrue = 1
elseif ( buildVersionMajor == "2" ) then
	tbc = true
	booleanTrue = 1
else
	booleanTrue = true
end

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		Colour Printing - Purple Theme
--		===============
--
--------------------------------------------------------------------------------------------------------------------------------------------

local pc_colour_Prefix		= "\124cFF8258FA"
local pc_colour_Highlight	= "\124cFFB19EFF"
local pc_colour_PlainText	= "\124cFF819FF7"

local function printPC( message )
	if message then
		DEFAULT_CHAT_FRAME:AddMessage( pc_colour_Prefix.. ( addonTitle or addonName ).. ": ".. pc_colour_PlainText.. message.. "\124r" )
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		Language Localisation
--		=====================
-- It is possible that not all genders are used but rather than test for use, I just included them
-- Some gender differentiation goes beyond that performed by Blizzard
-- Where genders were too difficult/general I defer/default to the male gender
-- Traditional Chinese is a direct Google Translate from the Simple Chinese but this should be 100% okay
-- Some translations from English by Blizzard are completely different to an expected translation and are retained
-- Sometimes Blizzard used inconsistent translations, especially for professions. I tried to homogenise these translations
--
--------------------------------------------------------------------------------------------------------------------------------------------

local locale = authorLocale or GetLocale()

local L, F, M, G = {}, {}, {}, {}

-- The L table, used throughout, should have its entries listed below. Exceptions are for languages which use the English
-- The F table is used in the class and prof tables for each city. It denotes that the NPC is female. The "npc" table also uses the F table
-- but it has no programmatic effect. Not noting an NPC as female in the NPC table will not actually matter. The F usage was retained in the
-- NPC table purely as a notation/convenience for the programmer
-- The M table is used in the class and prof tables for each city as a replacement for the L table. It denotes that the NPC was no longer a
-- trainer after Vanilla 
-- The G table is used in the class and prof tables for each city as a replacement for the F table. It denotes that the NPC was no longer a
-- trainer after Vanilla

setmetatable( L, { __index = function( L, key) return key end } )
setmetatable( F, { __index = function( F, key) return L[key] end } )
setmetatable( M, { __index = function( M, key) if ( tbc == false ) then return L[key] end end } )
setmetatable( G, { __index = function( G, key) if ( tbc == false ) then return F[key] end end } )

--------------------
-- Chat Command Menu
--------------------

if locale == "zhCN" then
	L["Commands"] = "命令"
	L["Icon size"] = "图标大小"
	L["10 to 50"] = "10到50"
	L["Class icons"] = "职业的图标"
	L["Toggle"] = "开关"
	L["Profession icons"] = "专业的图标"
	L["World Map icons"] = "世界地图的图标"
	L["Minimap icons"] = "迷你地图的图标"
	L["Show the version number"] = "显示版本号"
	L["Requires The Burning Crusade (2.4.3) or lower"] = "需要The Burning Crusade（2.4.3）或更低"
	L["Default"] = "默认"
	L["Hide"] = "隐藏"
	L["Show"] = "显示"
	L["Version: "] = "版: "
end

----------------------
-- Locations and Signs
----------------------

-- The indented table keys are for translations I could not definitvely source. Typically  DE, ES, FR, RU, and mostly limited to signs and
-- shop names. Often times I have "had a go" based upon similar names or just tried to resort to an intelligent use of Google Translate

if locale == "zhCN" then
	L["Above the Seer's Library"] = "在先知的图书馆之上"
	L["Alchemy Needs"] = "炼金材料店"
	L["Amberstill Ranch"] = "冻石农场"
	L["Anchorites' Sanctum"] = "主教的圣所"
	L["Arms of Legend"] = "传说中的装备"
	L["Aska's Kitchen"] = "阿丝卡的厨房"
	L["Bena's Alchemy"] = "本娜的炼金店"
	L["Berryfizz's Potions and Mixed Drinks"] = "苏雷的药水饮料店"
	L["Bloodhoof Village"] = "血蹄村"
	L["Borstan's Firepit"] = "博斯坦的火坑"
	L["Cathedral of Light"] = "圣光大教堂"
	L["Command Centre"] = "指挥中心"
	L["Darkbriar Lodge"] = "黑石南小屋"
	L["Darkfire Enclave"] = "暗火营地"
	L["Dawnstrider Enchanters"] = "附魔店"
	L["Deep Mountain Mining Guild"] = "深山矿工协会"
	L["Duncan's Textiles"] = "邓肯布料店"
	L["Dwarven District"] = "矮人区"
	L["East of the main entrance"] = "正门入口处"
	L["Eastvale Logging Camp"] = "东谷伐木场"
	L["Enchantment"] = "附魔"
	L["Entrance"] = "入口"
	L["Finespindle's Leather Goods"] = "皮甲用品店"
	L["Go up and on the far right"] = "上去并在最右边"
	L["Go up two rope ramps then\ndescend one flight of stairs"] = "走上两条绳索斜坡，然后下降一段楼梯"
	L["Godan's Runeworks"] = "古丹的符文工艺店"
	L["Grommash Hold"] = "格罗玛什要塞"
	L["Hall of Elders"] = "长者大厅"
	L["Hall of Spirits"] = "灵魂大厅"
	L["Hall of the Brave"] = "勇者大厅"
	L["Hall of the Mystics"] = "神秘主义大厅"
	L["Herbalist"] = "草药师"
	L["Hunter's Hall"] = "猎手大厅"
	L["Hunters' Sanctum"] = "猎人的圣所"
	L["Ironforge Physician"] = "铁炉堡医师协会"
	L["Jandi's Arboretum"] = "加迪植物园"
	L["Kodohide Leatherworkers"] = "科多兽皮工店"
	L["Larson Clothiers"] = "拉尔森服装店"
	L["Leather Work"] = "皮工"
	L["Lumak's Fishing"] = "鲁玛克渔具店"
	L["Magar's Cloth Goods"] = "玛加尔布品店"
	L["Mezzanine level"] = "夹层的水平"
	L["Mining & Smithing"] = "采矿和锻造"
	L["Mountaintop Bait & Tackle"] = "山顶渔具店"
	L["Nogg's Machine Shop"] = "诺格机械店"
	L["Pig and Whistle Tavern"] = "猪和哨声旅店"
	L["Red Canyon Mining"] = "红石谷矿业工会"
	L["Ring of Arms"] = "戒指"
	L["Royal Quarter"] = "皇家区"
	L["Ruins of Lordaeron"] = "洛丹伦废墟"
	L["Seer's Library"] = "先知的图书馆"
	L["Sen'jin Village"] = "森金村"
	L["Shadowswift Brotherhood"] = "迅影兄弟会"
	L["Shattrath Infirmary"] = "沙塔斯疗养院"
	L["Spirit Lodge"] = "灵魂小屋"
	L["Spiritual Healing"] = "精神治疗"
	L["Springspindle's Gadgets"] = "宾斯匹德器具店"
	L["Steelgrill's Depot"] = "钢架补给站"
	L["Stonebrow's Clothier"] = "石眉布衣店"
	L["Stonehoof Geology"] = "石蹄地质学会"
	L["Tailor"] = "裁缝"
	L["Temple of the Moon"] = "月神殿"
	L["The Bronze Kettle"] = "铜壶铁罐"
	L["The Burning Anvil"] = "燃烧的铁砧"
	L["The Pools of Vision"] = "预见之池" -- Covering Tieche../Tiechen..
	L["The Protective Hide"] = "护体皮甲"
	L["The Sanctum"] = "密室"
	L["The Slaughtered Lamb"] = "已宰的羔羊"
	L["Thistlefuzz Arcanery"] = "草须魔法用品店"
	L["Thunder Bluff Armorers"] = "雷霆崖防具店"
	L["Thunder Bluff Weapons"] = "雷霆崖武器店"
	L["Thuron's Livery"] = "苏伦的养殖场"
	L["Timberline Arms"] = "密林武器店"
	L["Traveling Fisherman"] = "旅行渔具店"
	L["Upstairs"] = "楼上"
	L["Valaar's Berth"] = "瓦拉尔港口"
	L["Vindicators' Sanctum"] = "维护者的圣殿"
	L["Weller's Arsenal"] = "维勒武器店"
	L["Wizard's Sanctum"] = "巫师圣殿"
	L["Yelmak's Alchemy and Potions"] = "耶尔玛克药剂店"
		L["Above the Seer's Library"] = "在先知的圖書館之上"
	L["Amberstill Ranch"] = "凍石農場"
		L["Anchorites' Sanctum"] = "主教的聖所"
	L["Bloodhoof Village"] = "血蹄村"
	L["Brill"] = "布瑞爾"
	L["Cathedral of Light"] = "光大教堂"
	L["Command Centre"] = "指揮中心"
	L["Deep Mountain Mining Guild"] = "深山礦工協會" -- Mountain Miners Association
	L["Dwarven District"] = "矮人區"
		L["East of the main entrance"] = "正門入口處"
	L["Eastvale Logging Camp"] = "東谷伐木場"
	L["Enchantment"] = "魅力"
	L["Entrance"] = "入口"
		L["Go up and on the far right"] = "上去並在最右邊"
		L["Go up two rope ramps then\ndescend one flight of stairs"] = "走上兩條繩索斜坡，然後下降一段樓梯"
	L["Grommash Hold"] = "格羅瑪什要塞"
		L["Hall of the Mystics"] = "神秘主義大廳"
	L["Herbalist"] = "中醫"
		L["Hunters' Sanctum"] = "獵人的聖所"
	L["Mezzanine level"] = "夾層的水平"
	L["Mining & Smithing"] = "採礦和鍛造"
	L["Nogg's Machine Shop"] = "諾格的機械商店"
	L["Ogrimmar"] = "奧格瑞瑪"
	L["Pig and Whistle Tavern"] = "的豬和哨聲旅店"
		L["Ring of Arms"] = "戒指"
	L["Royal Quarter"] = "皇家區的"
	L["Ruins of Lordaeron"] = "洛丹倫廢墟"
	L["Seer's Library"] = "先知的圖書館"
	L["Sen'jin Village"] = "森金村"
		L["Shattrath Infirmary"] = "沙塔斯療養院"
	L["Tailor"] = "裁縫"
	L["Temple of the Moon"] = "月神殿"
	L["The Pools of Vision"] = "預見之池" -- partial match"
		L["The Sanctum"] = "聖所"
	L["The Slaughtered Lamb"] = "宰的羔羊旅店"
	L["Thuron's Livery"] = "蘇倫的養殖場"
	L["Upstairs"] = "樓上"
	L["Valaar's Berth"] = "瓦拉爾港口"
		L["Vindicators' Sanctum"] = "維護者的聖殿"
	L["Wizard's Sanctum"] = "巫师圣殿" -- Blizz also uses 巫师的殿
end

--------------------------
-- Professions and Classes
--------------------------

-- Some professions do not have official Blizzard translations due to having been removed prior to that language's adoption
-- Some professions/classes just defy direct translation from an English perspective. I suppose players understand the intended meaning

if locale == "zhCN" then
	L["Alchemy"] = "炼金术"
	L["Alchemy Trainer"] = "炼金术训练师"
	L["Apprentice Alchemist"] = "初级炼金师"
	L["Apprentice Blacksmith"] = "初级铁匠"
	L["Apprentice Enchanter"] = "初级附魔师"
	L["Apprentice Engineer"] = "初级技师"
	L["Apprentice Leatherworker"] = "初级制皮师"
	L["Apprentice Tailor"] = "初级裁缝"
	L["Armorsmith"] = "防具锻造"
	L["Armorsmith Trainer"] = "装甲制造练师"
	L["Blacksmithing"] = "锻造"
	L["Blacksmithing Trainer"] = "锻造训练师"
	L["Cooking"] = "烹饪"
	L["Cooking Trainer"] = "烹饪训练师"
	L["Demon Trainer"] = "恶魔训练师"
	L["Druid"] = "德鲁伊"
	L["Druid Trainer"] = "德鲁伊训练师"
	L["Enchanting"] = "附魔"
	L["Enchanting Trainer"] = "附魔训练师"
	L["Engineering"] = "工程学"
	L["Engineering Trainer"] = "工程学训练师"
	L["First Aid"] = "急救"
	L["First Aid Trainer"] = "急救训练师"
	L["Fishing"] = "钓鱼"
	L["Fishing Trainer"] = "钓鱼训练师"
 	L["Herbalism"] = "草药学"
	L["Herbalism Trainer"] = "草药学训练师"
	L["Hunter"] = "猎人"
	L["Hunter Trainer"] = "猎人训练师"
	L["Jewelcrafting"] = "珠宝加工"
	L["Jewelcrafting Trainer"] = "珠宝加工训练师"
	L["Leatherworking"] = "制皮"
	L["Leatherworking Trainer"] = "制皮训练师"
	L["Mage"] = "法师"
	L["Mage Trainer"] = "法师训练师"
	L["Master Alchemy Trainer"] = "高阶炼金术训练师"
	L["Master Leatherworking Trainer"] = "高阶炼制皮训练师"
	L["Master Mage"] = "高阶法师"
	L["Master Shadoweave Tailor"] = "暗纹裁缝大师"
	L["Master Skinning Trainer"] = "高阶炼剥皮训练师"
	L["Mining"] = "采矿"
	L["Mining Trainer"] = "采矿训练师"
	L["Paladin"] = "圣骑士"
	L["Paladin Trainer"] = "圣骑士训练师"
	L["Pet Trainer"] = "宠物训练师"
	L["Portal Trainer"] = "传送门训练师"
	L["Priest"] = "牧师"
	L["Priest Trainer"] = "牧师训练师"
	L["Riding"] = "骑术"
	L["Riding Trainer"] = "骑术训练师"
	L["Rogue"] = "盗贼"
	L["Rogue Trainer"] = "盗贼训练师"
	L["Shaman"] = "萨满祭司"
	L["Shaman Trainer"] = "萨满祭司训练师"
	L["Skinning"] = "剥皮"
	L["Skinning Trainer"] = "剥皮训练师"
	L["Tailoring"] = "裁缝"
	L["Tailoring Trainer"] = "裁缝训练师"
	L["Warlock"] = "术士"
	L["Warlock Trainer"] = "术士训练师"
	L["Warrior"] = "战士"
	L["Warrior Trainer"] = "战士训练师"
	L["Weapon Master"] = "武器大师"
	L["Weapon Skills"] = "武器技能"
	L["Weaponsmith"] = "武器锻造"
	L["Weaponsmith Trainer"] = "武器锻造练师"
	L["Alchemy"] = "煉金術"
	L["Alchemy Trainer"] = "煉金術訓練師"
	L["Apprentice Alchemist"] = "初級煉金師"
	L["Apprentice Blacksmith"] = "初級鐵匠"
	L["Apprentice Enchanter"] = "初級附魔師"
	L["Apprentice Engineer"] = "初級技師"
	L["Apprentice Leatherworker"] = "初級制皮師"
	L["Apprentice Tailor"] = "初級裁縫"
	L["Armorsmith"] = "防具鍛造"
	L["Armorsmith Trainer"] = "裝甲製造練師"
	L["Blacksmithing"] = "鍛造"
	L["Blacksmithing Trainer"] = "鍛造訓練師"
	L["Cooking"] = "烹飪"
	L["Cooking Trainer"] = "烹飪訓練師"
	L["Demon Trainer"] = "惡魔訓練師"
	L["Druid"] = "德魯伊"
	L["Druid Trainer"] = "德魯伊訓練師"
	L["Enchanting"] = "附魔"
	L["Enchanting Trainer"] = "附魔訓練師"
	L["Engineering"] = "工程學"
	L["Engineering Trainer"] = "工程學訓練師"
	L["First Aid"] = "急救"
	L["First Aid Trainer"] = "急救訓練師"
	L["Fishing"] = "釣魚"
	L["Fishing Trainer"] = "釣魚訓練師"
	L["Herbalism"] = "草藥學"
	L["Herbalism Trainer"] = "草藥學訓練師"
	L["Hunter"] = "獵人"
	L["Hunter Trainer"] = "獵人訓練師"
	L["Jewelcrafting"] = "珠寶加工"
	L["Jewelcrafting Trainer"] = "珠寶加工訓練師"
	L["Leatherworking"] = "制皮"
	L["Leatherworking Trainer"] = "制皮訓練師"
	L["Mage"] = "法師"
	L["Mage Trainer"] = "法師訓練師"
	L["Master Alchemy Trainer"] = "高階煉金術訓練師"
	L["Master Leatherworking Trainer"] = "高階煉製皮訓練師"
	L["Master Mage"] = "高階法師"
	L["Master Shadoweave Tailor"] = "暗紋裁縫大師"
	L["Master Skinning Trainer"] = "高階煉剝皮訓練師"
	L["Mining"] = "採礦"
	L["Mining Trainer"] = "採礦訓練師"
	L["Paladin"] = "聖騎士"
	L["Paladin Trainer"] = "聖騎士訓練師"
	L["Pet Trainer"] = "寵物訓練師"
	L["Portal Trainer"] = "傳送門訓練師"
	L["Priest"] = "牧師"
	L["Priest Trainer"] = "牧師訓練師"
	L["Riding"] = "騎術"
	L["Riding Trainer"] = "騎術訓練師"
	L["Rogue"] = "潛行者"
	L["Rogue Trainer"] = "潛行者訓練師"
	L["Shaman"] = "薩滿祭司"
	L["Shaman Trainer"] = "薩滿祭司訓練師"
	L["Skinning"] = "剝皮"
	L["Skinning Trainer"] = "剝皮訓練師"
	L["Tailoring"] = "裁縫"
	L["Tailoring Trainer"] = "裁縫訓練師"
	L["Warlock"] = "術士"
	L["Warlock Trainer"] = "術士訓練師"
	L["Warrior"] = "戰士"
	L["Warrior Trainer"] = "戰士訓練師"
	L["Weapon Master"] = "武器大師"
	L["Weapon Skills"] = "武器技能"
	L["Weaponsmith"] = "武器鍛造"
	L["Weaponsmith Trainer"] = "武器鍛造練師"
end

--------------------
-- People of Azeroth
--------------------

-- Some NPCs do not have official Blizzard translations due to having been removed prior to that language's adoption

if locale == "zhCN" then
	L["Aalun"] = "埃亚伦"
	L["Aelthalyste"] = "艾萨莱斯特"
	L["Ahonan"] = "安霍纳"
	L["Ainethil"] = "安尼希尔"
	L["Akham"] = "阿克汉姆"
	L["Alamma"] = "奥拉玛"
	L["Aldrae"] = "奥德兰"
	L["Alegorn"] = "阿雷贡"
	L["Alestus"] = "埃雷图斯"
	L["Alexander Calder"] = "亚历山大·考德尔"
	L["Anastasia Hartwell"] = "安娜斯塔西娅·哈特威尔"
	L["Ander Germaine"] = "安德尔·杰曼"
	L["Angela Curthas"] = "安吉拉·科萨斯"
	L["Anishar"] = "安妮莎尔"
	L["Ansekhwa"] = "安塞瓦"
	L["Archibald"] = "阿基巴德"
	L["Archmage Shymm"] = "大法师山姆"
	L["Arias'ta Bladesinger"] = "阿雷亚斯塔·刃歌"
	L["Armand Cromwell"] = "阿曼德·克伦威尔"
	L["Arnok"] = "阿诺克"
	L["Arnold Leland"] = "阿诺德·利兰"
	L["Arthur Moore"] = "亚瑟·摩尔"
	L["Arthur the Faithful"] = "虔诚的亚瑟"
	L["Aska Mistrunner"] = "阿丝卡·迷雾行者"
	L["Astaia"] = "阿斯坦娅"
	L["Astarii Starseeker"] = "阿斯塔利·逐星"
	L["Baatun"] = "巴图恩"
	L["Balthus Stoneflayer"] = "巴尔萨斯·裂石"
	L["Baltus Fowler"] = "巴尔图斯·弗勒"
	L["Basil Frye"] = "巴兹尔·弗莱伊"
	L["Bati"] = "巴蒂"
	L["Behomat"] = "贝霍玛特"
	L["Beldruk Doombrow"] = "贝尔杜克·凝眉"
	L["Belestra"] = "贝蕾丝特拉"
	L["Belia Thundergranite"] = "贝莉亚·雷岩"
	L["Belil"] = "比利尔"
	L["Bemarrin"] = "波玛尔"
	L["Bena Winterhoof"] = "本娜·冰蹄"
	L["Bengus Deepforge"] = "本古斯·深炉"
	L["Beram Skychaser"] = "博拉姆·逐星"
	L["Betty Quin"] = "贝蒂·奎恩"
	L["Bilban Tosslespanner"] = "比尔班·飞钳"
	L["Binjy Featherwhistle"] = "宾吉·羽哨"
	L["Bink"] = "彬克"
	L["Birgitte Cranston"] = "比尔吉特·克兰斯顿"
	L["Bixi Wobblebonk"] = "比克斯"
	L["Borgosh Corebender"] = "伯古什"
	L["Borgus Steelhand"] = "博古斯·钢拳"
	L["Botanist Nathera"] = "植物学家娜萨兰"
	L["Braenna Flintcrag"] = "布莱纳·火崖"
	L["Brandur Ironhammer"] = "布兰度尔·铁锤"
	L["Brek Stonehoof"] = "布瑞克·石蹄"
	L["Briarthorn"] = "布瑞尔索恩"
	L["Brom Killian"] = "布罗姆·基里安"
	L["Brother Benjamin"] = "本杰明修士"
	L["Brother Joshua"] = "乔舒修士"
	L["Buliwyf Stonehand"] = "布里维夫·石拳"
	L["Caedmos"] = "凯德莫斯"
	L["Camberon"] = "卡博隆"
	L["Carolyn Ward"] = "卡罗琳·瓦德"
	L["Cemmorhan"] = "塞摩尔汉"
	L["Champion Bachi"] = "勇士巴卡希"
	L["Champion Cyssa Dawnrose"] = "塞希娅·黎明玫瑰"
	L["Christoph Walker"] = "克里斯托弗·沃克"
	L["Daera Brightspear"] = "戴拉·锐矛"
	L["Dan Golthas"] = "丹·戈萨斯"
	L["Dane Lindgren"] = "丹恩·林德雷"
	L["Dannelor"] = "丹纳罗尔"
	L["Danwe"] = "丹文"
	L["Darianna"] = "达丽亚娜"
	L["Darmari"] = "達爾瑪里"
	L["Darnath Bladesinger"] = "达纳斯·刃歌"
	L["Daryl Riknussun"] = "达瑞尔·瑞克努索"
	L["Deino"] = "迪诺"
	L["Demisette Cloyce"] = "德米赛特·克劳斯"
	L["Denatharion"] = "德纳萨里安"
	L["Derek the Undying"] = "不死者德尔勒克"
	L["Deremiis"] = "德雷米斯"
	L["Deriz"] = "迪里兹"
	L["Dink"] = "丁克"
	L["Doctor Herbert Halsey"] = "赫伯特·哈尔希医生"
	L["Doctor Marsh"] = "马尔什医生"
	L["Doctor Martin Felben"] = "马丁·费尔本"
	L["Dorion"] = "多利安"
	L["Drathen"] = "德拉森"
	L["Edirah"] = "伊迪拉恩"
	L["Edrem"] = "埃德雷姆"
	L["Einris Brightspear"] = "恩瑞斯·锐矛"
	L["Eladriel"] = "艾拉迪尔"
	L["Elara"] = "艾尔兰拉"
	L["Elissa Dumas"] = "埃莉萨·杜马斯"
	L["Elsharin"] = "艾尔莎林"
	L["Enchantress Volali"] = "附魔师沃拉莉"
	L["Enyo"] = "恩尤"
	L["Erion Shadewhisper"] = "艾瑞安·影语"
	L["Erett"] = "伊雷特"
	L["Eunice Burch"] = "尤奈斯·伯奇"
	L["Faldron"] = "法多恩"
	L["Fallat"] = "法尔拉特"
	L["Farii"] = "法里"
	L["Farseer Javad"] = "先知亚瓦德"
	L["Farseer Umbrua"] = "先知安布洛尔"
	L["Father Cobb"] = "柯布神父"
	L["Father Lankester"] = "兰克斯特神父"
	L["Father Lazarus"] = "拉扎鲁斯神父"
	L["Fenthwick"] = "芬斯维克"
	L["Feruul"] = "费卢尔"
	L["Fimble Finespindle"] = "费布·钢轴"
	L["Firodren Mooncaller"] = "菲罗迪恩·唤月"
	L["Franklin Lloyd"] = "弗兰克林·洛伊德"
	L["Fylerian Nightwing"] = "菲勒里亚·夜翼"
	L["Ganaar"] = "甘纳尔"
	L["Gelman Stonehand"] = "吉尔曼·石手"
	L["Geofram Bouldertoe"] = "吉尔弗拉姆·石趾"
	L["Georgio Bolero"] = "乔吉奥·波利罗"
	L["Gest"] = "盖斯特"
	L["Ghermas"] = "基尔玛斯"
	L["Gimble Thistlefuzz"] = "吉布·草须"
	L["Godan"] = "古丹"
	L["Graham Van Talen"] = "格拉哈姆·范·塔伦"
	L["Gregory Charles"] = "格雷戈·查尔斯"
	L["Gretta Finespindle"] = "格雷塔"
	L["Grezz Ragefist"] = "格雷兹·怒拳"
	L["Grimnur Stonebrand"] = "格瑞诺尔·石印"
	L["Grol'dar"] = "格罗达尔"
	L["Groum Stonebeard"] = "格鲁姆·石须"
	L["Grumnus Steelshaper"] = "格鲁努斯·削钢"
	L["Gurrag"] = "古尔拉格"
	L["Halthenis"] = "哈森尼斯"
	L["Hamanar"] = "哈曼纳尔"
	L["Hanashi"] = "哈纳什"
	L["Handiir"] = "韩迪尔"
	L["Harene Plainwalker"] = "哈雷尼·平原行者"
	L["Harnan"] = "哈尔南"
	L["Hesuwa Thunderhorn"] = "赫苏瓦·雷角"
	L["High Enchanter Bardolan"] = "高阶附魔师巴尔杜兰"
	L["High Priest Rohan"] = "高阶牧师洛汉"
	L["High Priestess Laurena"] = "高阶牧师劳瑞娜"
	L["Hobahken"] = "霍巴肯"
	L["Holt Thunderhorn"] = "浩特·雷角"
	L["Hulfdan Blackbeard"] = "霍夫丹·黑须"
	L["Ileda"] = "伊蕾达"
	L["Ilsa Corbin"] = "伊尔萨·考宾"
	L["Ilyenia Moonfire"] = "伊琳尼雅·月火"
	L["Inethven"] = "伊尼文"
	L["Iorioa"] = "艾欧莉娅"
	L["Ironus Coldsteel"] = "埃隆努斯·冷钢"
	L["Ithelis"] = "伊瑟里斯"
	L["Izmir"] = "伊兹米尔"
	L["Jack Trapper"] = "杰克·塔博尔"
	L["Jalane Ayrole"] = "嘉莱恩·艾罗"
	L["James Van Brunt"] = "詹姆斯·范·布朗特"
	L["Jandi"] = "加迪"
	L["Jandria"] = "贾德莉亚"
	L["Jartsam"] = "贾萨姆"
	L["Jeen'ra Nightrunner"] = "吉恩拉"
	L["Jemma Quikswitch"] = "耶玛"
	L["Jennea Cannon"] = "詹妮亚·坎农"
	L["Jhag"] = "夏格"
	L["Jocaste"] = "祖卡斯特"
	L["Jol"] = "约尔"
	L["Jormund Stonebrow"] = "约莫德·石眉"
	L["Josef Gregorian"] = "乔瑟夫·格里高利"
	L["Josephine Lister"] = "约瑟芬·李斯特"
	L["Jubahl Corpseseeker"] = "寻尸者祖贝尔"
	L["Juli Stormkettle"] = "朱莉·雷线"
	L["Kaal Soulreaper"] = "卡尔·噬灵"
	L["Kaelystia Hatebringer"] = "凯利斯蒂亚"
	L["Kah Mistrunner"] = "卡尔·迷雾行者"
	L["Kalinda"] = "卡琳达"
	L["Kamari"] = "卡玛瑞"
	L["Kardris Dreamseeker"] = "卡德里斯"
	L["Kar Stormsinger"] = "卡尔·雷歌"
	L["Karn Stonehoof"] = "卡恩·石蹄"
	L["Karolek"] = "卡洛雷克"
	L["Karrina Mekenda"] = "卡瑞娜·麦肯达"
	L["Kary Thunderhorn"] = "卡瑞·雷角"
	L["Katherine the Pure"] = "纯洁的凯瑟琳"
	L["Kavaan"] = "卡维恩"
	L["Kayaart"] = "卡亚特"
	L["Kazi"] = "卡兹"
	L["Keelen Sheets"] = "基伦·希斯"
	L["Kelgruk Bloodaxe"] = "克尔格鲁克·血斧"
	L["Kelstrum Stonebreaker"] = "克斯塔姆·碎石"
	L["Kelv Sternhammer"] = "凯夫·重锤"
	L["Ker Ragetotem"] = "科尔·暴怒图腾"
	L["Kildar"] = "基尔达"
	L["Killac"] = "基尔拉克"
	L["Killian Hagey"] = "基里安·哈根"
	L["Komin Winterhoof"] = "克米恩·冰蹄"
	L["Kradu Grimblade"] = "克拉度·利刃"
	L["Kray"] = "克瑞"
	L["Kudrii"] = "库德里恩"
	L["Kurgul"] = "库古尔"
	L["Kylene"] = "凯蕾妮"
	L["Kym Wildmane"] = "凯姆·蛮鬃"
	L["Lalina Summermoon"] = "拉琳娜·夏月"
	L["Lariia"] = "拉瑞亚"
	L["Larimaine Purdue"] = "拉瑞麦尼·普尔度"
	L["Lavinia Crowe"] = "拉文尼亚·克洛文"
	L["Lawrence Schneider"] = "劳伦斯·瑟尼德"
	L["Lexington Mortaim"] = "莱克斯顿·莫泰姆"
	L["Lilliam Sparkspindle"] = "利廉姆·火轴"
	L["Lilyssia Nightbreeze"] = "莉琳希亚·夜风"
	L["Lotheolan"] = "洛塞兰"
	L["Lord Grayson Shadowbreaker"] = "格雷森·沙东布瑞克公爵"
	L["Lord Tony Romano"] = "托尼·罗曼诺"
	L["Lorokeem"] = "罗罗基姆"
	L["Lucan Cordell"] = "鲁坎·考迪尔"
	L["Lucc"] = "鲁克"
	L["Lumak"] = "鲁玛克"
	L["Lunaraa"] = "鲁纳尔兰"
	L["Luther Pickman"] = "卢瑟·匹克曼"
	L["Lynalis"] = "莱纳里斯"
	L["Magar"] = "玛加尔"
	L["Maginor Dumas"] = "彬克"
	L["Mak"] = "马克"
	L["Makaru"] = "马卡鲁"
	L["Malakai Cross"] = "马拉凯·克罗斯"
	L["Malcomb Wynn"] = "玛考布·维恩"
	L["Maldryn"] = "玛尔德利恩"
	L["Maris Granger"] = "马瑞斯·格兰治"
	L["Martha Alliestar"] = "马尔萨·奥列斯塔"
	L["Martha Strain"] = "马尔萨·斯坦恩"
	L["Mary Edras"] = "玛丽·艾塔斯"
	L["Master Pyreanor"] = "派雷亚诺"
	L["Mathrengyl Bearwalker"] = "玛斯雷·驭熊者"
	L["Me'lynn"] = "迈里恩"
	L["Miall"] = "米阿尔"
	L["Mi'irku Farstep"] = "米尔卡·远步"
	L["Mildred Fletcher"] = "米尔蕾·弗莱彻尔"
	L["Miles Dexter"] = "迈尔斯·迪克斯特"
	L["Miles Welsh"] = "麦尔斯·威尔什"
	L["Milla Fairancora"] = "米拉·法拉科纳"
	L["Milstaff Stormeye"] = "贝尔斯塔弗·风暴之眼"
	L["Mirket"] = "米尔科特"
	L["Mooranta"] = "莫兰塔"
	L["Mot Dawnstrider"] = "莫特·晨行者"
	L["Muaat"] = "穆亚特"
	L["Mumman"] = "穆曼"
	L["Nahogg"] = "纳霍加"
	L["Nara Meideros"] = "娜拉·梅德隆"
	L["Narinth"] = "纳林斯"
	L["Nerisen"] = "奈里森"
	L["Nissa Firestone"] = "尼莎·火石"
	L["Nittlebur Sparkfizzle"] = "尼特布尔·火花"
	L["Nogg"] = "诺格"
	L["Nus"] = "努丝"
	L["Ockil"] = "奥克基尔"
	L["Okothos Ironrager"] = "奥克索斯·铁怒"
	L["Olmin Burningbeard"] = "奥尔明·燃须"
	L["Oninath"] = "欧尼纳斯"
	L["Ormak Grimshot"] = "奥玛克"
	L["Ormok"] = "奥莫克"
	L["Ormyr Flinteye"] = "奥米尔·火眼"
	L["Osborne the Night Man"] = "夜行者奥斯伯"
	L["Osselan"] = "欧塞兰"
	L["Pand Stonebinder"] = "潘德·缚石"
	L["Pephredo"] = "皮菲瑞多"
	L["Perascamin"] = "佩拉斯卡米"
	L["Pierce Shackleton"] = "皮尔斯·沙克尔顿"
	L["Priestess Alathea"] = "女祭司阿兰希雅"
	L["Quithas"] = "奎恩萨斯"
	L["Randal Hunter"] = "兰达尔·亨特"
	L["Randal Worth"] = "兰达尔·沃斯"
	L["Refik"] = "雷菲克"
	L["Regnus Thundergranite"] = "雷格努斯·雷石"
	L["Remere"] = "雷米勒"
	L["Reyna Stonebranch"] = "雷纳·石枝"
	L["Rhiannon Davis"] = "雷安诺·戴维斯"
	L["Richard Kerwin"] = "理查德·科尔文"
	L["Rotgath Stonebeard"] = "洛特加斯·石须"
	L["Roxxik"] = "罗克希克"
	L["Sagorne Crestrider"] = "萨格尼"
	L["Sandahl"] = "山达尔"
	L["Sark Ragetotem"] = "萨尔克·暴怒图腾"
	L["Saru Steelfury"] = "萨鲁·钢怒"
	L["Sayoc"] = "塞尤克"
	L["Sedana"] = "瑟丹娜"
	L["Sellandus"] = "塞拉多斯"
	L["Seymour"] = "塞莫尔"
	L["Shaina Fuller"] = "珊娜·弗勒"
	L["Shalannius"] = "沙兰尤斯"
	L["Shayis Steelfury"] = "莎伊斯·钢怒"
	L["Sheal Runetotem"] = "希尔·符文图腾"
	L["Sheldras Moontree"] = "沙德拉斯·月树"
	L["Shenthul"] = "申苏尔"
	L["Shylamiir"] = "莎拉米尔"
	L["Sian'dur"] = "萨杜尔"
	L["Sian'tsu"] = "萨祖"
	L["Sildanair"] = "希达奈尔"
	L["Siln Skychaser"] = "希恩·逐星"
	L["Silvaria"] = "西尔瓦莉雅"
	L["Simon Tanner"] = "西蒙·坦纳尔"
	L["Snang"] = "斯诺恩"
	L["Snarl"] = "斯纳尔"
	L["Sorek"] = "索瑞克"
	L["Spackle Thornberry"] = "斯巴克尔"
	L["Springspindle Fizzlegear"] = "宾斯匹德"
	L["Sprite Jumpsprocket"] = "斯普莱特"
	L["Stephen Ryback"] = "斯蒂芬·雷百克"
	L["Sulaa"] = "苏兰"
	L["Sylann"] = "塞莱恩"
	L["Syurna"] = "塞尤娜"
	L["Taladan"] = "塔兰丹"
	L["Talionia"] = "塔莱尼娅"
	L["Tally Berryfizz"] = "塔雷·浆泡"
	L["Tana"] = "塔纳"
	L["Tannysa"] = "塔尼莎"
	L["Teg Dawnstrider"] = "泰戈·晨行者"
	L["Tel'Athir"] = "泰兰希尔"
	L["Telonis"] = "泰龙尼斯"
	L["Tepa"] = "坦帕"
	L["Theodrus Frostbeard"] = "塞欧杜斯·霜须"
	L["Theridran"] = "塞瑞德兰"
	L["Therum Deepforge"] = "瑟鲁姆·深炉"
	L["Thistleheart"] = "瑟斯哈特"
	L["Thonys Pillarstone"] = "索恩斯·火石"
	L["Thorfin Stoneshield"] = "索尔芬·石盾"
	L["Thrag Stonehoof"] = "瑟拉格·石蹄"
	L["Thund"] = "桑德"
	L["Thurston Xane"] = "瑟斯顿·科萨恩"
	L["Thuul"] = "索乌"
	L["Thuwd"] = "苏尔德"
	L["Tigor Skychaser"] = "提戈尔·逐星"
	L["Toldren Deepiron"] = "托德雷·铁矿"
	L["Torm Ragetotem"] = "托姆·暴怒图腾"
	L["Trianna"] = "蒂安娜"
	L["Trixie Quikswitch"] = "特里克希"
	L["Turak Runetotem"] = "图拉克·符文图腾"
	L["Tyn"] = "提恩"
	L["Ug'thok"] = "乌格索克"
	L["Ulfir Ironbeard"] = "奥菲尔·铁须"
	L["Ultham Ironhorn"] = "奥萨姆·铁角"
	L["Una"] = "犹纳"
	L["Urek Thunderhorn"] = "乌瑞克·雷角"
	L["Ur'kyo"] = "乌尔库"
	L["Ursula Deline"] = "厄苏拉·德林"
	L["Ursyn Ghull"] = "奥松·格鲁尔"
	L["Uthel'nay"] = "尤塞尔奈"
	L["Uthrar Threx"] = "阿斯拉·瑞克斯"
	L["Valgar Highforge"] = "瓦尔加·高炉"
	L["Velma Warnam"] = "维尔玛·瓦纳姆"
	L["Vhan"] = "范恩"
	L["Victor Ward"] = "维克多·瓦德"
	L["Vord"] = "沃尔德"
	L["Vosur Brakthel"] = "沃萨·布拉克塞尔"
	L["Whuut"] = "伍特"
	L["Woo Ping"] = "吴平"
	L["Wu Shen"] = "武神"
	L["Yelmak"] = "耶尔玛克"
	L["Xao'tsu"] = "肖祖"
	L["Xar'Ti"] = "克萨尔迪"
	L["Xor'juul"] = "科索祖尔"
	L["X'yera"] = "克塞拉"
	L["Zaedana"] = "塞伊丹纳"
	L["Zamja"] = "扎姆沙"
	L["Zandine"] = "桑迪恩"
	--L["Zanien"] "萨尼恩"
	L["Zayus"] = "萨尤斯"
	L["Zelanis"] = "瑟兰尼斯"
	L["Zel'mak"] = "泽尔玛克"
	L["Zevrost"] = "泽弗洛斯特"
	L["Zula Slagfury"] = "祖拉·熔怒"

	L["Aalun"] = "埃亞倫"
	L["Aelthalyste"] = "艾薩萊斯特"
	L["Ahonan"] = "安霍納"
	L["Ainethil"] = "安尼希爾"
	L["Akham"] = "阿克漢姆"
	L["Alamma"] = "奧拉瑪"
	L["Aldrae"] = "奧德蘭"
	L["Alegorn"] = "阿雷貢"
	L["Alestus"] = "埃雷圖斯"
	L["Alexander Calder"] = "亞歷山大·考德爾"
	L["Anastasia Hartwell"] = "安娜斯塔西婭·哈特威爾"
	L["Ander Germaine"] = "安德爾·傑曼"
	L["Angela Curthas"] = "安吉拉·科薩斯"
	L["Anishar"] = "安妮莎爾"
	L["Ansekhwa"] = "安塞瓦"
	L["Archibald"] = "阿基巴德"
	L["Archmage Shymm"] = "大法師山姆"
	L["Arias'ta Bladesinger"] = "阿雷亞斯塔·刃歌"
	L["Armand Cromwell"] = "阿曼德·克倫威爾"
	L["Arnok"] = "阿諾克"
	L["Arnold Leland"] = "阿諾德·利蘭"
	L["Arthur Moore"] = "亞瑟·摩爾"
	L["Arthur the Faithful"] = "虔誠的亞瑟"
	L["Aska Mistrunner"] = "阿絲卡·迷霧行者"
	L["Astaia"] = "阿斯坦婭"
	L["Astarii Starseeker"] = "阿斯塔利·逐星"
	L["Baatun"] = "巴圖恩"
	L["Balthus Stoneflayer"] = "巴爾薩斯·裂石"
	L["Baltus Fowler"] = "巴爾圖斯·弗勒"
	L["Basil Frye"] = "巴爾圖斯·弗勒"
	L["Bati"] = "巴蒂"
	L["Behomat"] = "貝霍瑪特"
	L["Beldruk Doombrow"] = "貝爾杜克·凝眉"
	L["Belestra"] = "貝蕾絲特拉"
	L["Belia Thundergranite"] = "貝莉亞·雷岩"
	L["Belil"] = "比利爾"
	L["Bemarrin"] = "波瑪爾"
	L["Bena Winterhoof"] = "本娜·冰蹄"
	L["Bengus Deepforge"] = "本古斯·深爐"
	L["Beram Skychaser"] = "博拉姆·逐星"
	L["Betty Quin"] = "貝蒂·奎恩"
	L["Bilban Tosslespanner"] = "比爾班·飛鉗"
	L["Binjy Featherwhistle"] = "賓吉·羽哨"
	L["Bink"] = "彬克"
	L["Birgitte Cranston"] = "比爾吉特·克蘭斯頓"
	L["Bixi Wobblebonk"] = "比克斯"
	L["Borgosh Corebender"] = "伯古什"
	L["Borgus Steelhand"] = "博古斯·鋼拳"
	L["Botanist Nathera"] = "植物學家娜薩蘭"
	L["Braenna Flintcrag"] = "布萊納·火崖"
	L["Brandur Ironhammer"] = "布蘭度爾·鐵鎚"
	L["Brek Stonehoof"] = "布瑞克·石蹄"
	L["Briarthorn"] = "布瑞爾索恩"
	L["Brom Killian"] = "布羅姆·基里安"
	L["Brother Benjamin"] = "本傑明修士"
	L["Brother Joshua"] = "喬舒修士"
	L["Buliwyf Stonehand"] = "布里維夫·石拳"
	L["Caedmos"] = "凱德莫斯"
	L["Camberon"] = "卡博隆"
	L["Carolyn Ward"] = "卡羅琳·瓦德"
	L["Cemmorhan"] = "塞摩爾漢"
	L["Champion Bachi"] = "勇士巴卡希"
	L["Champion Cyssa Dawnrose"] = "塞希婭·黎明玫瑰"
	L["Christoph Walker"] = "克里斯托弗·沃克"
	L["Daera Brightspear"] = "戴拉·銳矛"
	L["Dan Golthas"] = "丹·戈薩斯"
	L["Dane Lindgren"] = "丹恩·林德雷"
	L["Dannelor"] = "丹納羅爾"
	L["Danwe"] = "丹文"
	L["Darianna"] = "達麗亞娜"
	L["Darnath Bladesinger"] = "達納斯·刃歌"
	L["Daryl Riknussun"] = "達瑞爾·瑞克努索"
	L["Deino"] = "迪諾"
	L["Demisette Cloyce"] = "德米賽特·克勞斯"
	L["Denatharion"] = "德納薩里安"
	L["Derek the Undying"] = "不死者德爾勒克"
	L["Deremiis"] = "德雷米斯"
	L["Deriz"] = "迪里茲"
	L["Dink"] = "丁克"
	L["Doctor Herbert Halsey"] = "赫伯特·哈爾希醫生"
	L["Doctor Marsh"] = "馬爾什醫生"
	L["Doctor Martin Felben"] = "馬丁·費爾本"
	L["Dorion"] = "多利安"
	L["Drathen"] = "德拉森"
	L["Edirah"] = "伊迪拉恩"
	L["Edrem"] = "埃德雷姆"
	L["Einris Brightspear"] = "恩瑞斯·銳矛"
	L["Eladriel"] = "艾拉迪爾"
	L["Elara"] = "艾爾蘭拉"
	L["Elissa Dumas"] = "埃莉薩·杜馬斯"
	L["Elsharin"] = "艾爾莎林"
	L["Enchantress Volali"] = "附魔師沃拉莉"
	L["Enyo"] = "恩尤"
	L["Erion Shadewhisper"] = "艾瑞安·影語"
	L["Erett"] = "依蕾特"
	L["Eunice Burch"] = "尤奈斯·伯奇"
	L["Faldron"] = "法多恩"
	L["Fallat"] = "法爾拉特"
	L["Farii"] = "法裡"
	L["Farseer Javad"] = "先知亞瓦德"
	L["Farseer Umbrua"] = "先知安布洛爾"
	L["Father Cobb"] = "柯布神父"
	L["Father Lankester"] = "蘭克斯特神父"
	L["Father Lazarus"] = "拉扎魯斯神父"
	L["Fenthwick"] = "芬斯維克"
	L["Feruul"] = "費盧爾"
	L["Fimble Finespindle"] = "費布·鋼軸"
	L["Firodren Mooncaller"] = "菲羅迪恩·喚月"
	L["Franklin Lloyd"] = "弗蘭克林·洛伊德"
	L["Fylerian Nightwing"] = "菲勒里亞·夜翼"
	L["Ganaar"] = "甘納爾"
	L["Gelman Stonehand"] = "吉爾曼·石手"
	L["Geofram Bouldertoe"] = "吉爾弗拉姆·石趾"
	L["Georgio Bolero"] = "喬吉奧·波利羅"
	L["Gest"] = "蓋斯特"
	L["Ghermas"] = "基爾瑪斯"
	L["Gimble Thistlefuzz"] = "吉布·草須"
	L["Godan"] = "古丹"
	L["Graham Van Talen"] = "格拉哈姆·範·塔倫"
	L["Gregory Charles"] = "格雷戈·查爾斯"
	L["Gretta Finespindle"] = "格雷塔"
	L["Grezz Ragefist"] = "格雷茲·怒拳"
	L["Grimnur Stonebrand"] = "格瑞諾爾·石印"
	L["Grol'dar"] = "格羅達爾"
	L["Groum Stonebeard"] = "格魯姆·石須"
	L["Grumnus Steelshaper"] = "格魯努斯·削鋼"
	L["Gurrag"] = "古爾拉格"
	L["Halthenis"] = "哈森尼斯"
	L["Hamanar"] = "哈曼納爾"
	L["Hanashi"] = "哈納什"
	L["Handiir"] = "韓迪爾"
	L["Harene Plainwalker"] = "哈雷尼·平原行者"
	L["Harnan"] = "哈爾南"
	L["Hesuwa Thunderhorn"] = "赫蘇瓦·雷角"
	L["High Enchanter Bardolan"] = "高階附魔師巴爾杜蘭"
	L["High Priest Rohan"] = "高階牧師洛漢"
	L["High Priestess Laurena"] = "高階牧師勞瑞娜"
	L["Hobahken"] = "霍巴肯"
	L["Holt Thunderhorn"] = "浩特·雷角"
	L["Hulfdan Blackbeard"] = "霍夫丹·黑須"
	L["Ileda"] = "伊蕾達"
	L["Ilsa Corbin"] = "伊爾薩·考賓"
	L["Ilyenia Moonfire"] = "伊琳尼雅·月火"
	L["Inethven"] = "伊尼文"
	L["Iorioa"] = "艾歐莉婭"
	L["Ironus Coldsteel"] = "埃隆努斯·冷鋼"
	L["Ithelis"] = "伊瑟里斯"
	L["Izmir"] = "伊茲米爾"
	L["Jack Trapper"] = "傑克·塔博爾"
	L["Jalane Ayrole"] = "嘉萊恩·艾羅"
	L["James Van Brunt"] = "詹姆斯·範·布朗特"
	L["Jandi"] = "加迪"
	L["Jandria"] = "賈德莉亞"
	L["Jartsam"] = "賈薩姆"
	L["Jeen'ra Nightrunner"] = "吉恩拉"
	L["Jemma Quikswitch"] = "耶瑪"
	L["Jennea Cannon"] = "詹妮亞·坎農"
	L["Jhag"] = "夏格"
	L["Jocaste"] = "祖卡斯特"
	L["Jol"] = "約爾"
	L["Jormund Stonebrow"] = "約莫德·石眉"
	L["Josef Gregorian"] = "喬瑟夫·格里高利"
	L["Josephine Lister"] = "約瑟芬·李斯特"
	L["Jubahl Corpseseeker"] = "尋尸者祖貝爾"
	L["Juli Stormkettle"] = "朱莉·雷線"
	L["Kaal Soulreaper"] = "卡爾·噬靈"
	L["Kaelystia Hatebringer"] = "凱利斯蒂亞"
	L["Kah Mistrunner"] = "卡爾·迷霧行者"
	L["Kalinda"] = "卡琳達"
	L["Kamari"] = "卡瑪瑞"
	L["Kardris Dreamseeker"] = "卡德里斯"
	L["Kar Stormsinger"] = "卡爾·雷歌"
	L["Karn Stonehoof"] = "卡恩·石蹄"
	L["Karolek"] = "卡洛雷克"
	L["Karrina Mekenda"] = "卡瑞娜·麥肯達"
	L["Kary Thunderhorn"] = "卡瑞·雷角"
	L["Katherine the Pure"] = "純潔的凱瑟琳"
	L["Kavaan"] = "卡維恩"
	L["Kayaart"] = "卡亞特"
	L["Kazi"] = "卡茲"
	L["Keelen Sheets"] = "基倫·希斯"
	L["Kelgruk Bloodaxe"] = "克爾格魯克·血斧"
	L["Kelstrum Stonebreaker"] = "克斯塔姆·碎石"
	L["Kelv Sternhammer"] = "凱夫·重錘"
	L["Ker Ragetotem"] = "科爾·暴怒圖騰"
	L["Kildar"] = "基爾達"
	L["Killac"] = "基爾拉克"
	L["Killian Hagey"] = "基里安·哈根"
	L["Komin Winterhoof"] = "克米恩·冰蹄"
	L["Kradu Grimblade"] = "克拉度·利刃"
	L["Kray"] = "克瑞"
	L["Kudrii"] = "庫德里恩"
	L["Kurgul"] = "庫古爾"
	L["Kylene"] = "凱蕾妮"
	L["Kym Wildmane"] = "凱姆·蠻鬃"
	L["Lalina Summermoon"] = "拉琳娜·夏月"
	L["Lariia"] = "拉瑞亞"
	L["Larimaine Purdue"] = "拉瑞麥尼·普爾度"
	L["Lavinia Crowe"] = "拉文尼亞·克洛文"
	L["Lawrence Schneider"] = "勞倫斯·瑟尼德"
	L["Lexington Mortaim"] = "萊克斯頓·莫泰姆"
	L["Lilliam Sparkspindle"] = "利廉姆·火軸"
	L["Lilyssia Nightbreeze"] = "莉琳希亞·夜風"
	L["Lotheolan"] = "洛塞蘭"
	L["Lord Grayson Shadowbreaker"] = "格雷森·沙東布瑞克公爵"
	L["Lord Tony Romano"] = "托尼·羅曼諾"
	L["Lorokeem"] = "羅羅基姆"
	L["Lucan Cordell"] = "魯坎·考迪爾"
	L["Lucc"] = "魯克"
	L["Lumak"] = "魯瑪克"
	L["Lunaraa"] = "魯納爾蘭"
	L["Luther Pickman"] = "盧瑟·匹克曼"
	L["Lynalis"] = "萊納里斯"
	L["Magar"] = "瑪加爾"
	L["Maginor Dumas"] = "彬克"
	L["Mak"] = "馬克"
	L["Makaru"] = "馬卡魯"
	L["Malakai Cross"] = "馬拉凱·克羅斯"
	L["Malcomb Wynn"] = "瑪考布·維恩"
	L["Maldryn"] = "瑪爾德利恩"
	L["Maris Granger"] = "馬瑞斯·格蘭治"
	L["Martha Alliestar"] = "馬爾薩·奧列斯塔"
	L["Martha Strain"] = "馬爾薩·斯坦恩"
	L["Mary Edras"] = "瑪麗·艾塔斯"
	L["Master Pyreanor"] = "派雷亞諾"
	L["Mathrengyl Bearwalker"] = "瑪斯雷·馭熊者"
	L["Me'lynn"] = "邁里恩"
	L["Miall"] = "米阿爾"
	L["Mi'irku Farstep"] = "米爾卡·遠步"
	L["Mildred Fletcher"] = "米爾蕾·弗萊徹爾"
	L["Miles Dexter"] = "邁爾斯·迪克斯特"
	L["Miles Welsh"] = "麥爾斯·威爾什"
	L["Milla Fairancora"] = "米拉·法拉科納"
	L["Milstaff Stormeye"] = "貝爾斯塔弗·風暴之眼"
	L["Mirket"] = "米爾科特"
	L["Mooranta"] = "莫蘭塔"
	L["Mot Dawnstrider"] = "莫特·晨行者"
	L["Muaat"] = "穆亞特"
	L["Mumman"] = "穆曼"
	L["Nahogg"] = "納霍加"
	L["Nara Meideros"] = "娜拉·梅德隆"
	L["Narinth"] = "納林斯"
	L["Nerisen"] = "奈里森"
	L["Nissa Firestone"] = "尼莎·火石"
	L["Nittlebur Sparkfizzle"] = "尼特布爾·火花"
	L["Nogg"] = "諾格"
	L["Nus"] = "努絲"
	L["Ockil"] = "奧克基爾"
	L["Okothos Ironrager"] = "奧克索斯·鐵怒"
	L["Olmin Burningbeard"] = "奧爾明·燃須"
	L["Oninath"] = "歐尼納斯"
	L["Ormak Grimshot"] = "奧瑪克"
	L["Ormok"] = "奧莫克"
	L["Ormyr Flinteye"] = "奧米爾·火眼"
	L["Osborne the Night Man"] = "夜行者奧斯伯"
	L["Osselan"] = "歐塞蘭"
	L["Pand Stonebinder"] = "潘德·縛石"
	L["Pephredo"] = "皮菲瑞多"
	L["Perascamin"] = "佩拉斯卡米"
	L["Pierce Shackleton"] = "皮爾斯·沙克爾頓"
	L["Priestess Alathea"] = "女祭司阿蘭希雅"
	L["Quithas"] = "奎恩薩斯"
	L["Randal Hunter"] = "蘭達爾·亨特"
	L["Randal Worth"] = "蘭達爾·沃斯"
	L["Refik"] = "雷菲克"
	L["Regnus Thundergranite"] = "雷格努斯·雷石"
	L["Remere"] = "雷米勒"
	L["Reyna Stonebranch"] = "雷納·石枝"
	L["Rhiannon Davis"] = "雷安諾·戴維斯"
	L["Richard Kerwin"] = "理查德·科爾文"
	L["Rotgath Stonebeard"] = "洛特加斯·石須"
	L["Roxxik"] = "羅克希克"
	L["Sagorne Crestrider"] = "薩格尼"
	L["Sandahl"] = "山达尔"
	L["Sark Ragetotem"] = "薩爾克·暴怒圖騰"
	L["Saru Steelfury"] = "薩魯·鋼怒"
	L["Sayoc"] = "塞尤克"
	L["Sedana"] = "瑟丹娜"
	L["Sellandus"] = "塞拉多斯"
	L["Seymour"] = "塞莫爾"
	L["Shaina Fuller"] = "珊娜·弗勒"
	L["Shalannius"] = "沙蘭尤斯"
	L["Shayis Steelfury"] = "莎伊斯·鋼怒"
	L["Sheal Runetotem"] = "希爾·符文圖騰"
	L["Sheldras Moontree"] = "沙德拉斯·月樹"
	L["Shenthul"] = "申蘇爾"
	L["Shylamiir"] = "莎拉米爾"
	L["Sian'dur"] = "薩杜爾"
	L["Sian'tsu"] = "薩祖"
	L["Sildanair"] = "希達奈爾"
	L["Siln Skychaser"] = "希恩·逐星"
	L["Silvaria"] = "西爾瓦莉雅"
	L["Simon Tanner"] = "西蒙·坦納爾"
	L["Snang"] = "斯諾恩"
	L["Snarl"] = "斯納爾"
	L["Sorek"] = "索瑞克"
	L["Spackle Thornberry"] = "斯巴克爾"
	L["Springspindle Fizzlegear"] = "賓斯匹德"
	L["Sprite Jumpsprocket"] = "斯普萊特"
	L["Stephen Ryback"] = "斯蒂芬·雷百克"
	L["Sulaa"] = "蘇蘭"
	L["Sylann"] = "塞萊恩"
	L["Syurna"] = "塞尤娜"
	L["Taladan"] = "塔蘭丹"
	L["Talionia"] = "塔萊尼婭"
	L["Tally Berryfizz"] = "塔雷·漿泡"
	L["Tana"] = "塔納"
	L["Tannysa"] = "塔尼莎"
	L["Teg Dawnstrider"] = "泰戈·晨行者"
	L["Tel'Athir"] = "泰蘭希爾"
	L["Telonis"] = "泰龍尼斯"
	L["Tepa"] = "坦帕"
	L["Theodrus Frostbeard"] = "塞歐杜斯·霜須"
	L["Theridran"] = "塞瑞德蘭"
	L["Therum Deepforge"] = "瑟魯姆·深爐"
	L["Thistleheart"] = "瑟斯哈特"
	L["Thonys Pillarstone"] = "索恩斯·火石"
	L["Thorfin Stoneshield"] = "索爾芬·石盾"
	L["Thrag Stonehoof"] = "瑟拉格·石蹄"
	L["Thund"] = "桑德"
	L["Thurston Xane"] = "瑟斯頓·科薩恩"
	L["Thuul"] = "索烏"
	L["Thuwd"] = "蘇爾德"
	L["Tigor Skychaser"] = "提戈爾·逐星"
	L["Toldren Deepiron"] = "托德雷·鐵礦"
	L["Torm Ragetotem"] = "托姆·暴怒圖騰"
	L["Trianna"] = "蒂安娜"
	L["Trixie Quikswitch"] = "特里克希"
	L["Turak Runetotem"] = "圖拉克·符文圖騰"
	L["Tyn"] = "提恩"
	L["Ug'thok"] = "烏格索克"
	L["Ulfir Ironbeard"] = "奧菲爾·鐵須"
	L["Ultham Ironhorn"] = "奧薩姆·鐵角"
	L["Una"] = "猶納"
	L["Urek Thunderhorn"] = "烏瑞克·雷角"
	L["Ur'kyo"] = "烏爾庫"
	L["Ursula Deline"] = "厄蘇拉·德林"
	L["Ursyn Ghull"] = "奧松·格魯爾"
	L["Uthel'nay"] = "尤塞爾奈"
	L["Uthrar Threx"] = "阿斯拉·瑞克斯"
	L["Valgar Highforge"] = "瓦爾加·高爐"
	L["Velma Warnam"] = "維爾瑪·瓦納姆"
	L["Vhan"] = "范恩"
	L["Victor Ward"] = "維克多·瓦德"
	L["Vord"] = "沃爾德"
	L["Vosur Brakthel"] = "沃薩·布拉克塞爾"
	L["Whuut"] = "伍特"
	L["Woo Ping"] = "吳平"
	L["Wu Shen"] = "武神"
	L["Yelmak"] = "耶爾瑪克"
	L["Xao'tsu"] = "肖祖"
	L["Xar'Ti"] = "克薩爾迪"
	L["Xor'juul"] = "科索祖爾"
	L["X'yera"] = "克塞拉"
	L["Zaedana"] = "塞伊丹納"
	L["Zamja"] = "扎姆沙"
	L["Zandine"] = "桑迪恩"
	L["Zanien"] "薩尼恩"
	L["Zayus"] = "薩尤斯"
	L["Zelanis"] = "瑟蘭尼斯"
	L["Zel'mak"] = "澤爾瑪克"
	L["Zevrost"] = "澤弗洛斯特"
	L["Zula Slagfury"] = "祖拉·熔怒"
end

--------------------------------------------------------------------------------------------------------------------------------------------

-- The determinant of an NPC's gender is decided in the coding of the mapClass and mapProf tables. It is NOT decided here, despite the
-- usage of the F[...] tables. This is just left over from an earlier schema I was going to adopt. I retained the code as it had value for
-- testing. The F[...] drops immediately through to the L[...] by way of LUA metatable, thus overhead is minimal

local npc = { 
	["aalun"] = F["Aalun"], ["aelthalyste"] = F["Aelthalyste"], ["ainethil"] = F["Ainethil"], ["ahonan"] = L["Ahonan"], 
	["akham"] = L["Akham"], ["alamma"] = L["Alamma"], ["alathea"] = F["Priestess Alathea"], ["aldrae"] = L["Aldrae"],
	["alegorn"] = L["Alegorn"], ["alestus"] = L["Alestus"], ["alexander"] = L["Alexander Calder"], ["anastasia"] = F["Anastasia Hartwell"],
	["germaine"] = L["Ander Germaine"], ["angela"] = F["Angela Curthas"], ["anishar"] = L["Anishar"], ["ansekhwa"] = L["Ansekhwa"], 
	["archibald"] = L["Archibald"], ["ariasta"] = F["Arias'ta Bladesinger"], ["armand"] = L["Armand Cromwell"], ["arnok"] = L["Arnok"], 
	["arnold"] = L["Arnold Leland"], ["arthurf"] = L["Arthur the Faithful"], ["arthurm"] = L["Arthur Moore"], 
	["aska"] = F["Aska Mistrunner"], ["astaia"] = F["Astaia"], ["astarii"] = F["Astarii Starseeker"], 

	["baatun"] = L["Baatun"], ["bachi"] = L["Champion Bachi"], ["balthus"] = L["Balthus Stoneflayer"], ["baltus"] = L["Baltus Fowler"], 
	["bardolan"] = L["High Enchanter Bardolan"], ["basil"] = L["Basil Frye"], ["bati"] = F["Bati"], ["behomat"] = L["Behomat"],
	["beldruk"] = L["Beldruk Doombrow"], ["belestra"] = F["Belestra"], ["belia"] = F["Belia Thundergranite"], ["belil"] = L["Belil"], 
	["bemarrin"] = L["Bemarrin"], ["bena"] = F["Bena Winterhoof"], ["bengus"] = L["Bengus Deepforge"], ["beram"] = L["Beram Skychaser"], 
	["betty"] = F["Betty Quin"], ["bilban"] = L["Bilban Tosslespanner"], ["binjy"] = L["Binjy Featherwhistle"], ["bink"] = F["Bink"], 
	["birgitte"] = F["Birgitte Cranston"], ["bixi"] = F["Bixi Wobblebonk"], ["borgosh"] = L["Borgosh Corebender"], 
	["borgus"] = L["Borgus Steelhand"], ["braenna"] = F["Braenna Flintcrag"], ["brandur"] = L["Brandur Ironhammer"], 
	["brek"] = L["Brek Stonehoof"], ["briarthorn"] = L["Briarthorn"], ["brom"] = L["Brom Killian"], ["benjamin"] = L["Brother Benjamin"], 
	["joshua"] = L["Brother Joshua"], ["buliwyf"] = L["Buliwyf Stonehand"], 

	["caedmos"] = L["Caedmos"], ["camberon"] = L["Camberon"], ["carolyn"] = F["Carolyn Ward"], ["cemmorhan"] = L["Cemmorhan"], 
	["christoph"] = L["Christoph Walker"], ["cobb"] = L["Father Cobb"], ["cyssa"] = F["Champion Cyssa Dawnrose"],

	["daera"] = F["Daera Brightspear"], ["dan"] = L["Dan Golthas"], ["dane"] = L["Dane Lindgren"], ["dannelor"] = L["Dannelor"],
	["danwe"] = F["Danwe"], ["darianna"] = F["Darianna"], ["darmari"] = F["Darmari"], ["darnath"] = L["Darnath Bladesinger"], 
	["daryl"] = L["Daryl Riknussun"], ["deino"] = F["Deino"], ["demisette"] = F["Demisette Cloyce"], ["denatharion"] = L["Denatharion"], 
	["derek"] = L["Derek the Undying"], ["deremiis"] = L["Deremiis"], ["deriz"] = L["Deriz"], ["dink"] = L["Dink"], 
	["doctorh"] = L["Doctor Herbert Halsey"], ["doctorm"] = L["Doctor Martin Felben"], ["doctormarsh"] = L["Doctor Marsh"], 
	["dorion"] = L["Dorion"], ["drathen"] = L["Drathen"],

	["edirah"] = F["Edirah"], ["edrem"] = L["Edrem"], ["einris"] = F["Einris Brightspear"], ["eladriel"] = F["Eladriel"], 
	["elara"] = F["Elara"], ["elissa"] = F["Elissa Dumas"], ["elsharin"] = F["Elsharin"], ["enyo"] = F["Enyo"], 
	["erion"] = L["Erion Shadewhisper"], ["erett"] = F["Erett"], ["eunice"] = F["Eunice Burch"], 

	["faldron"] = L["Faldron"], ["fallat"] = L["Fallat"], ["farii"] = F["Farii"], ["fatherlank"] = L["Father Lankester"], 
	["fatherlaz"] = L["Father Lazarus"], ["fenthwick"] = L["Fenthwick"], ["feruul"] = L["Feruul"], ["fimble"] = L["Fimble Finespindle"], 
	["firodren"] = L["Firodren Mooncaller"], ["franklin"] = L["Franklin Lloyd"], ["fylerian"] = L["Fylerian Nightwing"], 

	["ganaar"] = L["Ganaar"], ["gelman"] = L["Gelman Stonehand"], ["geofram"] = L["Geofram Bouldertoe"], ["georgio"] = L["Georgio Bolero"], 
	["gest"] = L["Gest"], ["ghermas"] = F["Ghermas"], ["gimble"] = L["Gimble Thistlefuzz"], ["godan"] = L["Godan"], 
	["graham"] = L["Graham Van Talen"], ["gregory"] = L["Gregory Charles"], ["gretta"] = F["Gretta Finespindle"], 
	["grezz"] = L["Grezz Ragefist"], ["grimnur"] = L["Grimnur Stonebrand"], ["groldar"] = L["Grol'dar"], ["groum"] = L["Groum Stonebeard"],
	["grumnus"] = L["Grumnus Steelshaper"], ["gurrag"] = L["Gurrag"],

	["halthenis"] = L["Halthenis"], ["hamanar"] = L["Hamanar"], ["hanashi"] = L["Hanashi"], ["handiir"] = L["Handiir"], 
	["harene"] = F["Harene Plainwalker"], ["harnan"] = L["Harnan"], ["hesuwa"] = L["Hesuwa Thunderhorn"], 
	["highpriestr"] = L["High Priest Rohan"], ["hobahken"] = L["Hobahken"], ["holt"] = L["Holt Thunderhorn"], 
	["hulfdan"] = L["Hulfdan Blackbeard"], 

	["ileda"] = F["Ileda"], ["ilsa"] = F["Ilsa Corbin"], ["ilyenia"] = F["Ilyenia Moonfire"], ["iorioa"] = F["Iorioa"], 
	["inethven"] = L["Inethven"], ["ironus"] = L["Ironus Coldsteel"], ["ithelis"] = L["Ithelis"], ["izmir"] = L["Izmir"],

	["jacktrapper"] = L["Jack Trapper"], ["jalane"] = F["Jalane Ayrole"], ["james"] = L["James Van Brunt"], ["jandi"] = F["Jandi"], 
	["jandria"] = F["Jandria"], ["jartsam"] = L["Jartsam"], ["javad"] = L["Farseer Javad"], ["jeenra"] = F["Jeen'ra Nightrunner"], 
	["jemma"] = F["Jemma Quikswitch"], ["jennea"] = F["Jennea Cannon"], ["jhag"] = L["Jhag"], ["jocaste"] = F["Jocaste"], 
	["jol"] = F["Jol"], ["jormund"] = L["Jormund Stonebrow"], ["josef"] = L["Josef Gregorian"], ["josephine"] = F["Josephine Lister"], 
	["jubahl"] = L["Jubahl Corpseseeker"], ["juli"] = F["Juli Stormkettle"], 

	["kaal"] = L["Kaal Soulreaper"], ["kaelystia"] = F["Kaelystia Hatebringer"], ["kah"] = L["Kah Mistrunner"], ["kalinda"] = F["Kalinda"], 
	["kamari"] = F["Kamari"], ["kardris"] = F["Kardris Dreamseeker"], ["kar"] = L["Kar Stormsinger"], ["karn"] = L["Karn Stonehoof"], 
	["karolek"] = L["Karolek"], ["karrina"] = F["Karrina Mekenda"], ["kary"] = F["Kary Thunderhorn"], 
	["katherine"] = F["Katherine the Pure"], ["kavaan"] = L["Kavaan"], ["kayaart"] = F["Kayaart"], ["kazi"] = F["Kazi"], 
	["keelen"] = L["Keelen Sheets"], ["kelgruk"] = L["Kelgruk Bloodaxe"], ["kelstrum"] = L["Kelstrum Stonebreaker"], 
	["kelv"] = L["Kelv Sternhammer"], ["ker"] = F["Ker Ragetotem"], ["kildar"] = L["Kildar"], ["killac"] = L["Killac"], 
	["killian"] = L["Killian Hagey"], ["komin"] = L["Komin Winterhoof"], ["kradu"] = L["Kradu Grimblade"], ["kray"] = L["Kray"], 
	["kudrii"] = F["Kudrii"], ["kurgul"] = L["Kurgul"], ["kylene"] = F["Kylene"], ["kym"] = F["Kym Wildmane"], 

	["lalina"] = F["Lalina Summermoon"], ["lariia"] = F["Lariia"], ["larimaine"] = F["Larimaine Purdue"], 
	["laurena"] = F["High Priestess Laurena"], ["lavinia"] = F["Lavinia Crowe"], ["lawrence"] = L["Lawrence Schneider"], 
	["lexington"] = L["Lexington Mortaim"], ["lilliam"] = F["Lilliam Sparkspindle"], ["lilyssia"] = F["Lilyssia Nightbreeze"], 
	["lorokeem"] = L["Lorokeem"], ["lotheolan"] = L["Lotheolan"], ["grayson"] = L["Lord Grayson Shadowbreaker"], 
	["lucan"] = L["Lucan Cordell"], ["lucc"] = L["Lucc"], ["lumak"] = L["Lumak"], ["lunaraa"] = F["Lunaraa"], 
	["luther"] = L["Luther Pickman"], ["lynalis"] = F["Lynalis"],

	["magar"] = L["Magar"], ["maginor"] = L["Maginor Dumas"], ["mak"] = L["Mak"], ["makaru"] = L["Makaru"], 
	["malakai"] = L["Malakai Cross"], ["malcomb"] = L["Malcomb Wynn"], ["maldryn"] = L["Maldryn"], ["maris"] = F["Maris Granger"], 
	["marthaa"] = F["Martha Alliestar"], ["marthas"] = F["Martha Strain"], ["mary"] = F["Mary Edras"], 
	["mathrengyl"] = L["Mathrengyl Bearwalker"], ["melynn"] = F["Me'lynn"], ["miall"] = F["Miall"], ["miirku"] = F["Mi'irku Farstep"], 
	["mildred"] = F["Mildred Fletcher"], ["milesd"] = L["Miles Dexter"], ["milesw"] = L["Miles Welsh"], ["milla"] = F["Milla Fairancora"], 
	["milstaff"] = L["Milstaff Stormeye"], ["mirket"] = F["Mirket"], ["mooranta"] = F["Mooranta"], ["mot"] = L["Mot Dawnstrider"], 
	["muaat"] = L["Muaat"], ["mumman"] = F["Mumman"],

	["nahogg"] = L["Nahogg"], ["nara"] = F["Nara Meideros"], ["narinth"] = F["Narinth"], ["nathera"] = F["Botanist Nathera"],
	["nerisen"] = L["Nerisen"], ["nissa"] = F["Nissa Firestone"], ["nittlebur"] = L["Nittlebur Sparkfizzle"], ["nogg"] = L["Nogg"],
	["nus"] = F["Nus"],

	["ockil"] = L["Ockil"], ["okothos"] = L["Okothos Ironrager"], ["olmin"] = L["Olmin Burningbeard"], ["oninath"] = L["Oninath"], 
	["ormak"] = L["Ormak Grimshot"], ["ormok"] = L["Ormok"], ["ormyr"] = L["Ormyr Flinteye"], ["osborne"] = L["Osborne the Night Man"], 
	["osselan"] = L["Osselan"],

	["pand"] = L["Pand Stonebinder"], ["pephredo"] = F["Pephredo"], ["perascamin"] = L["Perascamin"], ["pierce"] = L["Pierce Shackleton"],
	["pyreanor"] = L["Master Pyreanor"],

	["quithas"] = L["Quithas"],

	["randalhunter"] = L["Randal Hunter"], ["randalworth"] = L["Randal Worth"], ["refik"] = L["Refik"], 
	["regnus"] = L["Regnus Thundergranite"], ["remere"] = F["Remere"], ["reyna"] = F["Reyna Stonebranch"], 
	["rhiannon"] = F["Rhiannon Davis"], ["richard"] = L["Richard Kerwin"], ["romano"] = L["Lord Tony Romano"], 
	["rotgath"] = L["Rotgath Stonebeard"], ["roxxik"] = L["Roxxik"], 

	["sagorne"] = L["Sagorne Crestrider"], ["sandahl"] = L["Sandahl"], ["sark"] = L["Sark Ragetotem"], ["saru"] = L["Saru Steelfury"], 
	["sayoc"] = L["Sayoc"], ["sedana"] = F["Sedana"], ["sellandus"] = L["Sellandus"], ["seymour"] = L["Seymour"], 
	["shaina"] = F["Shaina Fuller"], ["shalannius"] = L["Shalannius"], ["shayis"] = F["Shayis Steelfury"], ["sheal"] = F["Sheal Runetotem"],
	["sheldras"] = L["Sheldras Moontree"], ["shenthul"] = L["Shenthul"], ["shylamiir"] = F["Shylamiir"], ["shymm"] = L["Archmage Shymm"], 
	["siandur"] = F["Sian'dur"], ["siantsu"] = F["Sian'tsu"], ["sildanair"] = F["Sildanair"], ["siln"] = F["Siln Skychaser"], 
	["silvaria"] = F["Silvaria"], ["simon"] = L["Simon Tanner"], ["snang"] = L["Snang"], ["snarl"] = L["Snarl"], ["sorek"] = L["Sorek"], 
	["spackle"] = L["Spackle Thornberry"], ["springspindle"] = L["Springspindle Fizzlegear"], ["sprite"] = F["Sprite Jumpsprocket"], 
	["ryback"] = L["Stephen Ryback"], ["sulaa"] = F["Sulaa"], ["sylann"] = F["Sylann"], ["syurna"] = F["Syurna"], 

	["taladan"] = L["Taladan"], ["talionia"] = F["Talionia"], ["tally"] = F["Tally Berryfizz"], ["tana"] = F["Tana"], 
	["tannysa"] = F["Tannysa"], ["teg"] = L["Teg Dawnstrider"], ["telathir"] = L["Tel'Athir"], ["telonis"] = L["Telonis"], 
	["tepa"] = F["Tepa"], ["theodrus"] = L["Theodrus Frostbeard"], ["theridran"] = L["Theridran"], ["therum"] = L["Therum Deepforge"], 
	["thistleheart"] = L["Thistleheart"], ["thonys"] = L["Thonys Pillarstone"], ["thorfin"] = L["Thorfin Stoneshield"], 
	["thrag"] = L["Thrag Stonehoof"], ["thund"] = L["Thund"], ["thurston"] = L["Thurston Xane"], ["thuul"] = L["Thuul"], 
	["thuwd"] = L["Thuwd"], ["tigor"] = L["Tigor Skychaser"], ["toldren"] = L["Toldren Deepiron"], ["torm"] = L["Torm Ragetotem"], 
	["trianna"] = F["Trianna"], ["trixie"] = F["Trixie Quikswitch"], ["turak"] = L["Turak Runetotem"], ["tyn"] = F["Tyn"],

	["ugthok"] = L["Ug'thok"], ["ulfir"] = L["Ulfir Ironbeard"], ["ultham"] = L["Ultham Ironhorn"], ["umbrua"] = F["Farseer Umbrua"], 
	["una"] = F["Una"], ["urek"] = L["Urek Thunderhorn"], ["urkyo"] = L["Ur'kyo"], ["ursula"] = F["Ursula Deline"], 
	["ursyn"] = F["Ursyn Ghull"], ["uthelnay"] = L["Uthel'nay"], ["uthrar"] = L["Uthrar Threx"], 

	["valgar"] = L["Valgar Highforge"], ["velma"] = F["Velma Warnam"], ["vhan"] = L["Vhan"], ["victor"] = L["Victor Ward"], 
	["volali"] = F["Enchantress Volali"], ["vord"] = L["Vord"], ["vosur"] = L["Vosur Brakthel"], 

	["whuut"] = L["Whuut"], ["wooping"] = L["Woo Ping"], ["wushen"] = L["Wu Shen"], 

	["xaotsu"] = L["Xao'tsu"], ["xarti"] = F["Xar'Ti"], ["xorjuul"] = L["Xor'juul"], ["xyera"] = L["X'yera"], 

	["yelmak"] = L["Yelmak"], 

	["zaedana"] = F["Zaedana"], ["zamja"] = F["Zamja"], ["zandine"] = F["Zandine"], ["zanien"] = L["Zanien"], ["zayus"] = L["Zayus"], 
	["zelanis"] = L["Zelanis"], ["zelmak"] = L["Zel'mak"], ["zevrost"]= L["Zevrost"], ["zula"] = L["Zula Slagfury"]
}

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		Map Setup
--		=========
--
--------------------------------------------------------------------------------------------------------------------------------------------

-- I have had to deal with the game engine spelling for Orgrimmar and Darnassus etc as return values from GetMapInfo() for the World Map.
-- Thankfully these do not need localising as they are meant to be internal file names or some such. The minimap version, GetZoneText(), IS 
-- localised and returns different values anyhow even when in English. So two separate sources, one of which needs translating, must point 
-- to a single table entry, which will be the World Map name

-- For the mapProf and mapClass tables the "tbc" TABLE FLAG works thus: If Vanilla and the flag is present and true then DON't show. If TBC 
-- and the flag is present and false then DON'T show. Otherwise show. This applies to all trainers for that entry. This is necessary to
-- prevent icons with no trainers from appearing

-- This mechanism is in addition to the M and G table metatable mechanism. Both require the TBC PATCH VARIABLE to be false to allow drop 
-- through to L and F by way of the null entry metatable mechanism

------------
-- Map Names
------------

-- I need to do this because when I setup the Minimap, I only have the localised Minimap zone text to use
-- "The "City of Ironforge" might be my undoing here. No idea how to translate that reliably. Hoping Blizzard used plain old "Ironforge"

if locale == "zhCN" then
	L["达纳苏斯"] = "Darnassis"
	L["铁炉堡"] = "Ironforge"
	L["奥格瑞玛"] = "Ogrimmar"
	L["沙塔斯城"] = "ShattrathCity"
	L["银月城"] = "SilvermoonCity"
	L["暴风城"] = "Stormwind"
	L["埃索达"] = "TheExodar"
	L["雷霆崖"] = "ThunderBluff"
	L["幽暗城"] = "Undercity"
else
	L["Darnassus"] = "Darnassis"
	L["City of Ironforge"] = "Ironforge"		-- A worry as I don't have translations for this one
	L["Ironforge"] = "Ironforge"
	L["Orgrimmar"] = "Ogrimmar"
	L["Shattrath City"] = "ShattrathCity"
	L["Silvermoon City"] = "SilvermoonCity"
	L["Stormwind City"] = "Stormwind"
	L["The Exodar"] = "TheExodar"
	L["Thunder Bluff"] = "ThunderBluff"
	L["Undercity"] = "Undercity"
end

----------
-- Classes
----------

local classCoords = { 
	["Warrior"] = { 0, 0.25, 0, 0.25}, ["Mage"] = { 0.25, 0.5, 0, 0.25}, ["Rogue"] = { 0.495, 0.745, 0, 0.25}, 
	["Druid"] = { 0.75, 1, 0, 0.25}, ["Hunter"] = { 0, 0.25, 0.25, 0.5}, ["Shaman"] = { 0.25, 0.5, 0.25, 0.5}, 
	["Priest"] = { 0.5, 0.75, 0.25, 0.5}, ["Warlock"] = { 0.75, 1, 0.25, 0.5}, ["Paladin"] = { 0, 0.25, 0.5, 0.75},
	}

local mapClass = { 
	["Darnassis"] = {
			["1"] = { ["x"] = 37.90, ["y"] = 82.73, ["class"] = "Priest", ["title"] = L["Priest"], ["mhr"] = 1, 
				["trainers"] = { ["jandria"] = F["Priest Trainer"], } },
			["2"] = { ["x"] = 38.94, ["y"] = 81.07, ["class"] = "Priest", ["title"] = L["Priest"], ["mhr"] = 1, ["note"] = 
				L["Upstairs"], ["trainers"] = { ["alathea"] = F["Priest Trainer"], ["astarii"] = F["Priest Trainer"], } },
			["3"] = { ["x"] = 40.34, ["y"] = 88.66, ["class"] = "Priest", ["title"] = L["Priest"], ["mhr"] = 1, 
				["trainers"] = { ["lariia"] = F["Priest Trainer"], } },
			["4"] = { ["x"] = 40.59, ["y"] = 82.13, ["class"] = "Mage", ["title"] = L["Mage"], ["mhr"] = 1, 
				["trainers"] = { ["elissa"] = F["Portal Trainer"], } },
			["5"] = { ["x"] = 40.48, ["y"] = 91.57, ["mhr"] = 1, ["rotateDegrees"] = 125, ["title"] = L["Priest"], 
				["note"] = L["Upstairs"], },
			["6"] = { ["x"] = 39.4, ["y"] = 75.93, ["mhr"] = 1, ["rotateDegrees"] = 180, ["title"] = L["Priest"].. " / ".. 
				L["Portal Trainer"], ["note"] = L["Entrance"], },
			["7"] = { ["x"] = 61.78, ["y"] = 42.20, ["class"] = "Warrior", ["title"] = L["Warrior"], 
				["trainers"] = { ["sildanair"] = F["Warrior Trainer"], } },
			["8"] = { ["x"] = 58.82, ["y"] = 35.12, ["class"] = "Warrior", ["title"] = L["Warrior"], 
				["trainers"] = { ["ariasta"] = F["Warrior Trainer"], ["darnath"] = L["Warrior Trainer"], } },
			["9"] = { ["x"] = 39.72, ["y"] = 5.40, ["class"] = "Hunter", ["title"] = L["Hunter"], ["note"] = L["Upstairs"], 
				["trainers"] = { ["jeenra"] = F["Hunter Trainer"], } },
			["10"] = { ["x"] = 42.34, ["y"] = 8.22, ["class"] = "Hunter", ["title"] = L["Hunter"], ["note"] = L["Upstairs"], 
				["trainers"] = { ["dorion"] = L["Hunter Trainer"], ["silvaria"] = F["Pet Trainer"], } },
			["11"] = { ["x"] = 40.36, ["y"] = 14.59, ["class"] = "Hunter", ["title"] = L["Hunter"], 
				["trainers"] = { ["jocaste"] = F["Hunter Trainer"], } },
			["12"] = { ["x"] = 35.37, ["y"] = 8.41, ["class"] = "Druid", ["title"] = L["Druid"], 
				["note"] = L["Upstairs"], ["trainers"] = { ["mathrengyl"] = L["Druid Trainer"], } },
			["13"] = { ["x"] = 36.38, ["y"] = 12.11, ["class"] = "Druid", ["title"] = L["Druid"], 
				["trainers"] = { ["denatharion"] = L["Druid Trainer"], ["fylerian"] = L["Druid Trainer"], } },
			["14"] = { ["x"] = 33.11, ["y"] = 16.13, ["class"] = "Rogue", ["title"] = L["Rogue"], ["trainers"] = { ["erion"] = 
				L["Rogue Trainer"], ["anishar"] = L["Rogue Trainer"], ["syurna"] = F["Rogue Trainer"], } },
	},
	["Ironforge"] = {
			["1"] = { ["x"] = 53.14, ["y"] = 8.30, ["class"] = "Warlock", ["title"] = L["Warlock"], 
				["trainers"] = { ["jubahl"] = M["Demon Trainer"], } },
			["2"] = { ["x"] = 52.89, ["y"] = 11.41, ["class"] = "Rogue", ["title"] = L["Rogue"], 
				["trainers"] = { ["hulfdan"] = L["Rogue Trainer"], ["ormyr"] = L["Rogue Trainer"], 
				["fenthwick"] = L["Rogue Trainer"], } },
			["3"] = { ["x"] = 51.24, ["y"] = 9.91, ["class"] = "Warlock", ["title"] = L["Warlock"], 
				["trainers"] = { ["alexander"] = L["Warlock Trainer"], ["briarthorn"] = L["Warlock Trainer"], 
				["thistleheart"] = L["Warlock Trainer"], } },
			["4"] = { ["x"] = 28.55, ["y"] = 13.80, ["rotateDegrees"] = 43, ["title"] = L["Mage"].. " / ".. L["Paladin"].. 
				" / ".. L["Priest"], ["note"] = L["Entrance"], },
			["5"] = { ["x"] = 26.72, ["y"] = 7.16, ["class"] = "Mage", ["title"] = L["Mage"], 
				["trainers"] = { ["nittlebur"] = L["Mage Trainer"], ["juli"] = L["Mage Trainer"], 
				["bink"] = F["Mage Trainer"], ["dink"] = F["Mage Trainer"], ["milstaff"] = L["Portal Trainer"], } },
			["6"] = { ["x"] = 24.51, ["y"] = 9.99, ["class"] = "Priest", ["title"] = L["Priest"], 
				["trainers"] = { ["theodrus"] = L["Priest Trainer"], ["highpriestr"] = F["Priest Trainer"], 
				["braenna"] = F["Priest Trainer"], ["toldren"] = L["Priest Trainer"], } },
			["7"] = { ["x"] = 24.01, ["y"] = 5.70, ["class"] = "Paladin", ["title"] = L["Paladin"], 
				["trainers"] = { ["valgar"] = L["Paladin Trainer"], ["brandur"] = L["Paladin Trainer"], 
				["beldruk"] = L["Paladin Trainer"], } },
			["8"] = { ["x"] = 26.28, ["y"] = 2.56, ["rotateDegrees"] = 70, ["title"] = L["Mage"].. " / ".. L["Paladin"].. 
				" / ".. L["Priest"], ["note"] = L["Upstairs"], },
			["9"] = { ["x"] = 65.22, ["y"] = 80.27, ["rotateDegrees"] = 220, ["title"] = L["Hunter"].. " / ".. L["Warrior"], 
				["shop"] = L["Hall of Arms"], ["note"] = L["Entrance"], },
			["10"] = { ["x"] = 67.11, ["y"] = 87.39, ["class"] = "Warrior", ["title"] = L["Warrior"], 
				["shop"] = L["Hall of Arms"], ["trainers"] = { ["kelstrum"] = L["Warrior Trainer"], 
				["bilban"] = L["Warrior Trainer"], ["kelv"] = L["Warrior Trainer"], } }, 
			["11"] = { ["x"] = 69.45, ["y"] = 84.53, ["class"] = "Hunter", ["title"] = L["Hunter"], ["shop"] = L["Hall of Arms"], 
				["trainers"] = { ["daera"] = F["Hunter Trainer"], ["olmin"] = L["Hunter Trainer"], 
				["regnus"] = L["Hunter Trainer"], ["belia"] = F["Pet Trainer"], } },
			["12"] = { ["x"] = 54.87, ["y"] = 30.60, ["class"] = "Shaman", ["title"] = L["Shaman"], 
				["trainers"] = { ["javad"] = L["Shaman Trainer"], }, ["tbc"] = true,  },
	},
	["Ogrimmar"] = {
			["1"] = { ["x"] = 36.01, ["y"] = 85.43, ["class"] = "Priest", ["title"] = L["Priest"], ["shop"] = L["Spirit Lodge"], 
				["trainers"] = { ["xyera"] = L["Priest Trainer"], ["urkyo"] = L["Priest Trainer"], } },
			["2"] = { ["x"] = 38.18, ["y"] = 81.02, ["class"] = "Mage", ["title"] = L["Mage"], ["shop"] = L["Darkbriar Lodge"], 
				["trainers"] = { ["pephredo"] = F["Mage Trainer"], ["enyo"] = F["Mage Trainer"], 
				["deino"] = F["Mage Trainer"], ["uthelnay"] = L["Mage Trainer"], ["thuul"] = L["Portal Trainer"], } },
			["3"] = { ["x"] = 39.54, ["y"] = 52.57, ["rotateDegrees"] = 210, ["title"] = L["Rogue"], ["note"] = L["Entrance"], },
			["4"] = { ["x"] = 38.31, ["y"] = 36.17, ["class"] = "Shaman", ["title"] = L["Shaman"], 
				["shop"] = L["Grommash Hold"], ["trainers"] = { ["sagorne"] = L["Shaman Trainer"], ["kardris"] = F["Shaman Trainer"], 
				["siantsu"] = F["Shaman Trainer"], } },
			["5"] = { ["x"] = 43.67, ["y"] = 52.74, ["class"] = "Rogue", ["title"] = L["Rogue"], ["shop"] = 
				L["Shadowswift Brotherhood"], ["trainers"] = { ["shenthul"] = L["Rogue Trainer"], ["gest"] = 
				L["Rogue Trainer"], ["ormok"] = L["Rogue Trainer"], } },
			["6"] = { ["x"] = 48.00, ["y"] = 47.18, ["class"] = "Warlock", ["title"] = L["Warlock"], ["shop"] = 
				L["Darkfire Enclave"], ["trainers"] = { ["groldar"] = L["Warlock Trainer"], ["zevrost"] = 
				L["Warlock Trainer"], ["mirket"] = F["Warlock Trainer"], ["kurgul"] = M["Demon Trainer"], } },
			["7"] = { ["x"] = 56.48, ["y"] = 41.28, ["rotateDegrees"] = 80, ["title"] = L["Warlock"], ["note"] = L["Entrance"], },
			["8"] = { ["x"] = 66.57, ["y"] = 22.88, ["class"] = "Hunter", ["title"] = L["Hunter"], ["trainers"] = { ["ormak"] = 
				L["Hunter Trainer"], ["xorjuul"] = L["Hunter Trainer"], ["siandur"] = F["Hunter Trainer"], 
				["xaotsu"] = L["Pet Trainer"], } },
			["9"] = { ["x"] = 67.96, ["y"] = 14.25, ["class"] = "Hunter", ["title"] = L["Hunter"], 
				["trainers"] = { ["ormak"] = L["Hunter Trainer"], ["xorjuul"] = L["Hunter Trainer"], 
				["siandur"] = F["Hunter Trainer"], ["xaotsu"] = L["Pet Trainer"], } },
			["10"] = { ["x"] = 75.68, ["y"] = 33.38, ["class"] = "Warrior", ["title"] = L["Warrior"], ["shop"] = 
				L["Hall of the Brave"], ["trainers"] = { ["grezz"] = L["Warrior Trainer"], ["sorek"] = 
				L["Warrior Trainer"], ["zelmak"] = L["Warrior Trainer"], } },
			["11"] = { ["x"] = 32.28, ["y"] = 35.73, ["class"] = "Paladin", ["title"] = L["Paladin"], ["shop"] = L["Grommash Hold"],
				["trainers"] = { ["pyreanor"] = L["Paladin Trainer"], }, ["tbc"] = true, },
	},
	["ShattrathCity"] = {
			["1"] = { ["x"] = 44.08, ["y"] = 89.18, ["class"] = "Mage", ["title"] = L["Mage"], ["trainers"] = { ["miirku"] = 
				F["Portal Trainer"], }, ["note"] = L["Above the Seer's Library"], ["mhr"] = 4 },
			["2"] = { ["x"] = 58.75, ["y"] = 47.16, ["class"] = "Mage", ["title"] = L["Mage"], ["trainers"] = { ["iorioa"] = 
				F["Portal Trainer"], }, ["mhr"] = 4 },
	},
	["SilvermoonCity"] = {
			["1"] = { ["x"] = 91.63, ["y"] = 37.52, ["class"] = "Paladin", ["title"] = L["Paladin"], ["trainers"] = {  ["bachi"] = 
				L["Paladin Trainer"], ["ithelis"] = L["Paladin Trainer"], ["osselan"] = L["Paladin Trainer"], } },
			["2"] = { ["x"] = 83.45, ["y"] = 30.45, ["class"] = "Hunter", ["title"] = L["Hunter"],
				["trainers"] = { ["zandine"] = F["Hunter Trainer"], ["oninath"] = L["Hunter Trainer"], 
				["tana"] = F["Hunter Trainer"], ["halthenis"] = L["Pet Trainer"], } },
			["3"] = { ["x"] = 75.15, ["y"] = 44.65, ["class"] = "Warlock", ["title"] = L["Warlock"], ["shop"] = L["The Sanctum"], 
				["trainers"] = { ["zanien"] = L["Warlock Trainer"], ["alamma"] = L["Warlock Trainer"], 
				["talionia"] = F["Warlock Trainer"], } },
			["4"] = { ["x"] = 77.55, ["y"] = 52.14, ["class"] = "Rogue", ["title"] = L["Rogue"], ["trainers"] = 
				{ ["zelanis"] = L["Rogue Trainer"], ["elara"] = F["Rogue Trainer"], ["nerisen"] = L["Rogue Trainer"], } },
			["5"] = { ["x"] = 57.11, ["y"] = 21.40, ["class"] = "Mage", ["title"] = L["Mage"], ["trainers"] = { ["inethven"] = 
				L["Mage Trainer"], ["quithas"] = L["Mage Trainer"], ["zaedana"] = F["Mage Trainer"], ["narinth"] = F["Portal Trainer"], } },
			["6"] = { ["x"] = 55.37, ["y"] = 24.74, ["class"] = "Priest", ["title"] = L["Priest"], ["trainers"] = { ["aldrae"] = 
				L["Priest Trainer"], ["lotheolan"] = L["Priest Trainer"], ["belestra"] = F["Priest Trainer"], } },
			["7"] = { ["x"] = 71.06, ["y"] = 55.44, ["class"] = "Druid", ["title"] = L["Druid"],
				["trainers"] = { ["harene"] = F["Druid Trainer"], } },
	},
	["Stormwind"] = {
			["1"] = { ["x"] = 78.00, ["y"] = 69.00, ["class"] = "Rogue", ["title"] = L["Rogue"], ["trainers"] = 
				{ ["osborne"] = L["Rogue Trainer"], } },
			["2"] = { ["x"] = 80.00, ["y"] = 69.00, ["class"] = "Rogue", ["title"] = L["Rogue"],
				["trainers"] = { ["romano"] = L["Rogue Trainer"], } },
			["3"] = { ["x"] = 80.00, ["y"] = 59.00, ["class"] = "Warrior", ["title"] = L["Warrior"], 
				["shop"] = L["Command Centre"], ["trainers"] = { ["germaine"] = L["Warrior Trainer"], 
				["wushen"] = L["Warrior Trainer"], ["ilsa"] = F["Warrior Trainer"], } },
			["4"] = { ["x"] = 67.00, ["y"] = 36.00, ["class"] = "Hunter", ["title"] = L["Hunter"], 
				["trainers"] = { ["einris"] = F["Hunter Trainer"], ["thorfin"] = L["Hunter Trainer"], 
				["ulfir"] = L["Hunter Trainer"], ["karrina"] = F["Pet Trainer"], } },
			["5"] = { ["x"] = 40.00, ["y"] = 86.50, ["class"] = "Warlock", ["title"] = L["Warlock"], 
				["shop"] = L["The Slaughtered Lamb"], ["trainers"] = { ["demisette"] = F["Warlock Trainer"], 
				["sandahl"] = L["Warlock Trainer"], ["ursula"] = F["Warlock Trainer"], ["spackle"] = M["Demon Trainer"], } },
			["6"] = { ["x"] = 49.00, ["y"] = 87.00, ["class"] = "Mage", ["title"] = L["Mage"], 
				["shop"] = L["Wizard's Sanctum"], ["trainers"] = { ["maginor"] = L["Master Mage"], 
				["elsharin"] = F["Mage Trainer"], ["jennea"] = F["Mage Trainer"], ["larimaine"] = F["Portal Trainer"], } },
			["7"] = { ["x"] = 35.00, ["y"] = 68.10, ["class"] = "Druid", ["title"] = L["Druid"], 
				["trainers"] = { ["sheldras"] = L["Druid Trainer"], } },
			["8"] = { ["x"] = 34.08, ["y"] = 66.02, ["class"] = "Druid", ["title"] = L["Druid"], 
				["trainers"] = { ["maldryn"] = L["Druid Trainer"], } },
			["9"] = { ["x"] = 36.24, ["y"] = 64.08, ["class"] = "Druid", ["title"] = L["Druid"],
				["trainers"] = { ["theridran"] = L["Druid Trainer"], } },
			["10"] = { ["x"] = 52.30, ["y"] = 47.36, ["class"] = "Priest", ["title"] = L["Priest"],
				["shop"] = L["Cathedral of Light"], ["trainers"] = { ["laurena"] = F["Priest Trainer"], 
				["joshua"] = L["Priest Trainer"], ["benjamin"] = L["Priest Trainer"], } },
			["11"] = { ["x"] = 35.09, ["y"] = 64.11, ["class"] = "Priest", ["title"] = L["Priest"], 
				["trainers"] = {  ["nara"] = F["Priest Trainer"], } },
			["12"] = { ["x"] = 48.04, ["y"] = 49.09, ["class"] = "Paladin", ["title"] = L["Paladin"], 
				["shop"] = L["Cathedral of Light"], ["trainers"] = {  ["grayson"] = L["Paladin Trainer"], 
				["katherine"] = F["Paladin Trainer"], ["arthurf"] = L["Paladin Trainer"], } },
			["13"] = { ["x"] = 57.00, ["y"] = 60.38, ["rotateDegrees"] = 40, ["title"] = L["Priest"].. " / ".. 
				L["Paladin"], ["note"] = L["Entrance"], },
			["14"] = { ["x"] = 61.83, ["y"] = 83.98, ["class"] = "Shaman", ["title"] = L["Shaman"], 
				["trainers"] = { ["umbrua"] = F["Shaman Trainer"], }, ["tbc"] = true,  },
	},
	["TheExodar"] = {
			["1"] = { ["x"] = 56.04, ["y"] = 59.05, ["rotateDegrees"] = 95, ["title"] = L["Hunter"].. " /".. L["Warrior"].. " / ".. 
				L["Weapon Skills"], ["shop"] = L["Hunters' Sanctum"].. " / ".. L["Ring of Arms"], ["note"] = L["Upstairs"], },
			["2"] = { ["x"] = 46.99, ["y"] = 87.87, ["class"] = "Hunter", ["title"] = L["Hunter"], ["shop"] = L["Hunters' Sanctum"], 
				["trainers"] = { ["vord"] = L["Hunter Trainer"], ["deremiis"] = L["Hunter Trainer"], 
				["killac"] = L["Hunter Trainer"], ["ganaar"] = L["Pet Trainer"], } },
			["3"] = { ["x"] = 50.15, ["y"] = 81.50, ["rotateDegrees"] = 310, ["title"] = L["Warrior"].. " / ".. L["Weapon Skills"], 
				["shop"] = L["Ring of Arms"], ["note"] = L["Upstairs"], },
			["4"] = { ["x"] = 56.05, ["y"] = 83.53, ["class"] = "Warrior", ["title"] = L["Warrior"], ["trainers"] = { ["behomat"] = 
				L["Warrior Trainer"], ["kazi"] = F["Warrior Trainer"], ["ahonan"] = L["Warrior Trainer"], } },
			["5"] = { ["x"] = 46.57, ["y"] = 62.37, ["class"] = "Mage", ["title"] = L["Mage"], 
				["shop"] = L["Hall of the Mystics"], ["trainers"] = { ["edirah"] = L["Mage Trainer"], 
				["harnan"] = L["Mage Trainer"], ["bati"] = F["Mage Trainer"], ["lunaraa"] = F["Portal Trainer"], } },
			["6"] = { ["x"] = 38.79, ["y"] = 80.00, ["class"] = "Paladin", ["title"] = L["Paladin"], 
				["shop"] = L["Vindicators' Sanctum"], ["trainers"] = {  ["baatun"] = L["Paladin Trainer"], 
				["jol"] = F["Paladin Trainer"], ["kavaan"] = L["Paladin Trainer"], } },
			["7"] = { ["x"] = 40.89, ["y"] = 53.04, ["class"] = "Priest", ["title"] = L["Priest"], ["shop"] = L["Anchorites' Sanctum"], 
				["trainers"] = { ["caedmos"] = F["Priest Trainer"], ["fallat"] = L["Priest Trainer"], ["izmir"] = L["Priest Trainer"], } },
			["8"] = { ["x"] = 24.28, ["y"] = 39.66, ["class"] = "Shaman", ["title"] = L["Shaman"], 
				["trainers"] = { ["gurrag"] = L["Shaman Trainer"], } },
			["9"] = { ["x"] = 35.05, ["y"] = 7.94, ["class"] = "Shaman", ["title"] = L["Shaman"], 
				["trainers"] = { ["hobahken"] = L["Shaman Trainer"], } },
			["10"] = { ["x"] = 32.80, ["y"] = 24.12, ["class"] = "Shaman", ["title"] = L["Shaman"], 
				["trainers"] = { ["sulaa"] = F["Shaman Trainer"], } },
			["11"] = { ["x"] = 35.26, ["y"] = 74.83, ["rotateDegrees"] = 50, ["title"] = L["Druid"], ["note"] = 
				L["Valaar's Berth"].. " @ ".. "24.45,54.57", ["trainers"] = { ["shalannius"] = L["Druid Trainer"], }},
	},
	["ThunderBluff"] = {
			["1"] = { ["x"] = 54.08, ["y"] = 84.00, ["class"] = "Hunter", ["title"] = L["Hunter"], ["shop"] = L["Hunter's Hall"], 
				["trainers"] = { ["hesuwa"] = L["Pet Trainer"], } },
			["2"] = { ["x"] = 60.05, ["y"] = 86.98, ["class"] = "Hunter", ["title"] = L["Hunter"], ["mhr"] = 3, 
				["shop"] = L["Hunter's Hall"], ["trainers"] = { ["holt"] = L["Hunter Trainer"], ["kary"] = F["Hunter Trainer"], 
				["urek"] = L["Hunter Trainer"], } },
			["3"] = { ["x"] = 57.19, ["y"] = 84.97, ["class"] = "Warrior", ["title"] = L["Warrior"], ["mhr"] = 3, 
				["shop"] = L["Hunter's Hall"], ["trainers"] = { ["sark"] = L["Warrior Trainer"], ["torm"] = L["Warrior Trainer"], 
				["ker"] = F["Warrior Trainer"], } },
			["4"] = { ["x"] = 73.49, ["y"] = 30.01, ["class"] = "Druid", ["title"] = L["Druid"], ["shop"] = L["Hall of Elders"], 
				["trainers"] = { ["sheal"] = F["Druid Trainer"], ["turak"] = L["Druid Trainer"], ["kym"] = F["Druid Trainer"], } },
			["5"] = { ["x"] = 25.93, ["y"] = 22.04, ["class"] = "Shaman", ["title"] = L["Shaman"], 
				["shop"] = L["Hall of Spirits"], ["trainers"] = { ["beram"] = L["Shaman Trainer"], ["siln"] = 
				F["Shaman Trainer"], ["tigor"] = L["Shaman Trainer"], } },
			["6"] = { ["x"] = 24.54, ["y"] = 22.58, ["class"] = "Priest", ["title"] = L["Priest"], ["mhr"] = 2, 
				["shop"] = L["The Pools of Vision"], ["trainers"] = {  ["malakai"] = L["Priest Trainer"], } },
			["7"] = { ["x"] = 22.49, ["y"] = 16.91, ["class"] = "Mage", ["title"] = L["Mage"], ["mhr"] = 2, 
				["shop"] = L["The Pools of Vision"], ["trainers"] = { ["birgitte"] = F["Portal Trainer"], } },
			["8"] = { ["x"] = 22.79, ["y"] = 14.48, ["class"] = "Mage", ["title"] = L["Mage"], ["mhr"] = 2, 
				["shop"] = L["The Pools of Vision"], ["trainers"] = { ["shymm"] = L["Mage Trainer"], } },
			["9"] = { ["x"] = 25.70, ["y"] = 14.20, ["class"] = "Mage", ["title"] = L["Mage"], ["mhr"] = 2, 
				["shop"] = L["The Pools of Vision"], ["trainers"] = { ["ursyn"] = F["Mage Trainer"], } },
			["10"] = { ["x"] = 25.33, ["y"] = 15.25, ["class"] = "Priest", ["title"] = L["Priest"], ["mhr"] = 2, 
				["shop"] = L["The Pools of Vision"], ["trainers"] = {  ["milesw"] = L["Priest Trainer"], } },
			["11"] = { ["x"] = 25.15, ["y"] = 20.96, ["class"] = "Mage", ["title"] = L["Mage"], ["mhr"] = 2, 
				["shop"] = L["The Pools of Vision"], ["trainers"] = { ["thurston"] = L["Mage Trainer"], } },
			["12"] = { ["x"] = 25,65, ["y"] = 20.68, ["class"] = "Priest", ["title"] = L["Priest"], ["mhr"] = 2, 
				["shop"] = L["The Pools of Vision"], ["trainers"] = {  ["cobb"] = L["Priest Trainer"], } },
			["13"] = { ["x"] = 30.68, ["y"] = 30.12, ["rotateDegrees"] = 80, ["title"] = L["Mage"].. " / ".. L["Priest"], 
				["shop"] = L["The Pools of Vision"], ["note"] = L["Entrance"], },
	},
	["Undercity"] = {
			["1"] = { ["x"] = 84.67, ["y"] = 72.41, ["class"] = "Rogue", ["title"] = L["Rogue"], ["trainers"] = 
				{ ["gregory"] = L["Rogue Trainer"], ["milesd"] = L["Rogue Trainer"], ["carolyn"] = F["Rogue Trainer"], } },
			["2"] = { ["x"] = 88.92, ["y"] = 15.85, ["class"] = "Warlock", ["title"] = L["Warlock"], 
				["note"] = L["Upstairs"], ["trainers"] = { ["richard"] = L["Warlock Trainer"], } },
			["3"] = { ["x"] = 85.14, ["y"] = 10.03, ["class"] = "Mage", ["title"] = L["Mage"],
				["note"] = L["Upstairs"], ["trainers"] = { ["anastasia"] = F["Mage Trainer"], } },
			["4"] = { ["x"] = 84.21, ["y"] = 15.56, ["class"] = "Mage", ["title"] = L["Mage"],
				["note"] = L["Upstairs"], ["trainers"] = { ["lexington"] = L["Portal Trainer"], } },
			["5"] = { ["x"] = 86.19, ["y"] = 15.95, ["class"] = "Warlock", ["title"] = L["Warlock"], ["trainers"] = { ["kaal"] = 
				L["Warlock Trainer"], ["luther"] = L["Warlock Trainer"], ["marthas"] = G["Demon Trainer"], } },
			["6"] = { ["x"] = 84.99, ["y"] = 14.03, ["class"] = "Mage", ["title"] = L["Mage"],
				["trainers"] = { ["kaelystia"] = F["Mage Trainer"], ["pierce"] = L["Mage Trainer"], } },
			["7"] = { ["x"] = 49.12, ["y"] = 14.62, ["class"] = "Priest", ["title"] = L["Priest"],  
				["trainers"] = {  ["fatherlank"] = L["Priest Trainer"], } },
			["8"] = { ["x"] = 49.26, ["y"] = 17.15, ["class"] = "Priest", ["title"] = L["Priest"],  
				["trainers"] = {  ["aelthalyste"] = F["Priest Trainer"], } },
			["9"] = { ["x"] = 47.55, ["y"] = 18.88, ["class"] = "Priest", ["title"] = L["Priest"],  
				["trainers"] = {  ["fatherlaz"] = L["Priest Trainer"], } },
			["10"] = { ["x"] = 47.39, ["y"] = 15.93, ["class"] = "Warrior", ["title"] = L["Warrior"], ["trainers"] = { ["christoph"] = 
				L["Warrior Trainer"], ["angela"] = F["Warrior Trainer"], ["baltus"] = L["Warrior Trainer"], } },
			["11"] = { ["x"] = 56.28, ["y"] = 16.35, ["class"] = "Mage", ["title"] = L["Mage"],
				["trainers"] = { ["derek"] = L["Mage Trainer"], }, ["tbc"] = true, },
			["12"] = { ["x"] = 58.00, ["y"] = 90.44, ["class"] = "Paladin", ["title"] = L["Paladin"], 
				["shop"] = L["Royal Quarter"], ["trainers"] = {  ["cyssa"] = F["Paladin Trainer"], }, ["tbc"] = true, },
	},
}

local numMapClass = {
	["Darnassis"] = 14,
	["Ironforge"] = 12,
	["Ogrimmar"] = 11,
	["ShattrathCity"] = 2,
	["SilvermoonCity"] = 7,
	["Stormwind"] = 14,
	["TheExodar"] = 11,
	["ThunderBluff"] = 13,
	["Undercity"] = 12,
}
local mapClassFrame, miniClassFrame, maxMiniClass = {}, {}, 0

--------------
-- Professions
--------------

local profCoords = { 
	["riding"] = { 0, 0.25, 0, 0.25}, ["cooking"] = { 0.25, 0.5, 0, 0.25}, ["skinning"] = { 0.5, 0.75, 0, 0.25}, 
	["firstaid"] = { 0.75, 1, 0, 0.25}, ["alchemy"] = { 0, 0.25, 0.25, 0.5}, ["blacksmithing"] = { 0.25, 0.5, 0.25, 0.5}, 
	["engineering"] = { 0.5, 0.75, 0.25, 0.5}, ["enchanting"] = { 0.75, 1, 0.25, 0.5}, ["fishing"] = { 0, 0.25, 0.5, 0.75}, 
	["herbalism"] = { 0.25, 0.5, 0.5, 0.75}, ["leatherworking"] = { 0.5, 0.75, 0.5, 0.75}, ["mining"] = { 0.75, 1, 0.5, 0.75}, 
	["tailoring"] = { 0, 0.25, 0.75, 1}, ["weapon"] = { 0.25, 0.5, 0.75, 1}, ["jewelcrafting"] = { 0.5, 0.75, 0.75, 1}, 
	}

local mapProf = {
	["Darnassis"] = {
			["1"] = { ["x"] = 47.88, ["y"] = 56.66, ["prof"] = "fishing", ["title"] = L["Fishing"], 
				["trainers"] = { ["astaia"] = F["Fishing Trainer"], } },
			["2"] = { ["x"] = 46.57, ["y"] = 71.99, ["prof"] = "herbalism", ["title"] = L["Herbalism"], 
				["trainers"] = { ["firodren"] = L["Herbalism Trainer"], } },
			["3"] = { ["x"] = 57.56, ["y"] = 46.72, ["prof"] = "weapon", ["title"] = L["Weapon Skills"], 
				["trainers"] = { ["ilyenia"] = F["Weapon Master"], } },
			["4"] = { ["x"] = 61.11, ["y"] = 23.43, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["Tailoring"], ["trainers"] = { ["melynn"] = F["Tailoring Trainer"], 
				["trianna"] = G["Apprentice Tailor"], } },
			["5"] = { ["x"] = 55.63, ["y"] = 20.48, ["prof"] = "alchemy", ["title"] = L["Alchemy"], 
				["shop"] = L["Alchemy"], ["trainers"] = { ["ainethil"] = F["Alchemy Trainer"], 
				["milla"] = G["Apprentice Alchemist"], } },
			["6"] = { ["x"] = 61.12, ["y"] = 10.49, ["prof"] = "enchanting", ["title"] = L["Enchanting"], 
				["shop"] = L["Enchanting"], ["trainers"] = { ["taladan"] = L["Enchanting Trainer"], 
				["lalina"] = G["Apprentice Enchanter"], } },
			["7"] = { ["x"] = 50.80, ["y"] = 20.54, ["prof"] = "cooking", ["title"] = L["Cooking"], 
				["shop"] = L["Cooking"], ["trainers"] = { ["alegorn"] = L["Cooking Trainer"], } },
			["8"] = { ["x"] = 51.96, ["y"] = 15.99, ["prof"] = "firstaid", ["title"] = L["First Aid"],
				["shop"] = L["First Aid"], ["trainers"] = { ["dannelor"] = L["First Aid Trainer"], } },
			["9"] = { ["x"] = 38.69, ["y"] = 15.85, ["prof"] = "riding", ["title"] = L["Riding"], 
				["trainers"] = { ["jartsam"] = L["Riding Trainer"], } },
			["10"] = { ["x"] = 64.35, ["y"] = 21.62, ["prof"] = "leatherworking", ["title"] = L["Skinning"].. " / ".. 
				L["Leatherworking"], ["trainers"] = { ["telonis"] = L["Leatherworking Trainer"], ["faldron"] = 
				M["Apprentice Leatherworker"], ["darianna"] = G["Apprentice Leatherworker"], 
				["eladriel"] = F["Skinning Trainer"], } },
			["11"] = { ["x"] = 62.34, ["y"] = 21.08, ["rotateDegrees"] = 300, ["title"] = L["Skinning"].. " / ".. 
				L["Leatherworking"], ["note"] = L["Upstairs"], },
	},
	["Ironforge"] = {
			["1"] = { ["x"] = 67.95, ["y"] = 53.15, ["prof"] = "alchemy", ["title"] = L["Alchemy"], 
				["shop"] = L["Berryfizz's Potions and Mixed Drinks"],
				["trainers"] = { ["tally"] = F["Alchemy Trainer"], ["vosur"] = M["Apprentice Alchemist"], } },
			["2"] = { ["x"] = 68.72, ["y"] = 45.03, ["prof"] = "engineering", ["title"] = L["Engineering"], 
				["shop"] = L["Springspindle's Gadgets"], ["trainers"] = { ["springspindle"] = L["Engineering Trainer"], 
				["trixie"] = G["Apprentice Engineer"], ["jemma"] = G["Apprentice Engineer"],} },
			["3"] = { ["x"] = 48.42, ["y"] = 9.89, ["prof"] = "fishing", ["title"] = L["Fishing"], 
				["shop"] = L["Traveling Fisherman"], ["trainers"] = { ["grimnur"] = L["Fishing Trainer"], } },
			["4"] = { ["x"] = 61.37, ["y"] = 85.17, ["prof"] = "weapon", ["title"] = L["Weapon Skills"], 
				["shop"] = L["Timberline Arms"], ["trainers"] = { ["bixi"] = F["Weapon Master"], 
				["buliwyf"] = L["Weapon Master"], } },
			["5"] = { ["x"] = 53.63, ["y"] = 55.62, ["prof"] = "herbalism", ["title"] = L["Herbalism"], 
				["shop"] = L["Ironforge Physician"], ["trainers"] = { ["reyna"] = F["Herbalism Trainer"], } },
			["6"] = { ["x"] = 55.78, ["y"] = 60.08, ["prof"] = "firstaid", ["title"] = L["First Aid"], 
				["shop"] = L["Ironforge Physician"], ["trainers"] = { ["nissa"] = F["First Aid Trainer"], } },
			["7"] = { ["x"] = 58.04, ["y"] = 45.34, ["prof"] = "enchanting", ["title"] = L["Enchanting"], 
				["shop"] = L["Thistlefuzz Arcanery"], ["trainers"] = { ["gimble"] = L["Enchanting Trainer"], 
				["thonys"] = M["Apprentice Enchanter"], } },
			["8"] = { ["x"] = 57.42, ["y"] = 37.56, ["prof"] = "cooking", ["title"] = L["Cooking"],
				["shop"] = L["The Bronze Kettle"], ["trainers"] = { ["daryl"] = L["Cooking Trainer"], } },
			["9"] = { ["x"] = 52.07, ["y"] = 29.68, ["prof"] = "mining", ["title"] = L["Mining"], 
				["shop"] = L["Deep Mountain Mining Guild"], ["trainers"] = { ["geofram"] = L["Mining Trainer"], } },
			["10"] = { ["x"] = 44.38, ["y"] = 31.56, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["Stonebrow's Clothier"], ["trainers"] = { ["jormund"] = L["Tailoring Trainer"], 
				["uthrar"] = M["Apprentice Tailor"], } },
			["11"] = { ["x"] = 42.04, ["y"] = 33.22, ["prof"] = "leatherworking", ["shop"] = L["Finespindle's Leather Goods"],
				["title"] = L["Skinning"].. " / ".. L["Leatherworking"], 
				["trainers"] = { ["fimble"] = L["Leatherworking Trainer"], ["gretta"] = G["Apprentice Leatherworker"], } },
			["12"] = { ["x"] = 18,61, ["y"] = 86.25, ["rotateDegrees"] = 265, ["title"] = L["Riding"], ["note"] = 
				L["Amberstill Ranch"].. " @ ".. "63.94,50.10", ["trainers"] = { ["ultham"] = L["Riding Trainer"], }},
			["13"] = { ["x"] = 15.53, ["y"] = 80.55, ["rotateDegrees"] = 170, ["title"] = L["Riding"], ["note"] = 
				L["Steelgrill's Depot"].. " @ ".. "49.15,48.13", ["trainers"] = { ["binjy"] = L["Riding Trainer"], }},
			["14"] = { ["x"] = 52.45, ["y"] = 41.99, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"], 
				["trainers"] = { ["bengus"] = L["Blacksmithing Trainer"], ["rotgath"] = M["Apprentice Blacksmith"], 
				["groum"] = M["Apprentice Blacksmith"], } },
			["15"] = { ["x"] = 50.14, ["y"] = 43.16, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"], 
				["trainers"] = { ["grumnus"] = M["Armorsmith"], ["ironus"] = M["Weaponsmith"], }, ["tbc"] = false },
			["16"] = { ["x"] = 39.86, ["y"] = 32.51, ["prof"] = "skinning", ["title"] = L["Skinning"], 
				["shop"] = L["Finespindle's Leather Goods"], ["trainers"] = { ["balthus"] = L["Skinning Trainer"], } },
	},
	["Ogrimmar"] = {
			["1"] = { ["x"] = 33.42, ["y"] = 84.43, ["prof"] = "firstaid", ["title"] = L["First Aid"],
				["shop"] = L["Survival of the Fittest"], ["trainers"] = { ["arnok"] = L["First Aid Trainer"], } },
			["2"] = { ["x"] = 80.81, ["y"] = 20.23, ["prof"] = "weapon", ["title"] = L["Weapon Skills"], 
				["shop"] = L["Arms of Legend"], ["trainers"] = { ["sayoc"] = L["Weapon Master"], 
				["hanashi"] = L["Weapon Master"], } },
			["3"] = { ["x"] = 69.80, ["y"] = 29.21, ["prof"] = "fishing", ["title"] = L["Fishing"], 
				["shop"] = L["Lumak's Fishing"], ["trainers"] = { ["lumak"] = L["Fishing Trainer"], } },
			["4"] = { ["x"] = 74.73, ["y"] = 24.32, ["prof"] = "engineering", ["title"] = L["Engineering"], 
				["shop"] = L["Nogg's Machine Shop"], ["trainers"] = { ["roxxik"] = L["Engineering Trainer"], 
				["nogg"] = M["Apprentice Engineer"], ["thund"] = M["Apprentice Engineer"], } },
			["5"] = { ["x"] = 56.47, ["y"] = 35.78, ["prof"] = "alchemy", ["title"] = L["Alchemy"], ["shop"] = 
				L["Yelmak's Alchemy and Potions"], ["trainers"] = { ["yelmak"] = L["Alchemy Trainer"], 
				["whuut"] = M["Apprentice Alchemist"], } },
			["6"] = { ["x"] = 53.23, ["y"] = 36.27, ["prof"] = "enchanting", ["title"] = L["Enchanting"], 
				["shop"] = L["Godan's Runeworks"], ["trainers"] = { ["godan"] = L["Enchanting Trainer"], ["jhag"] = 
				M["Apprentice Enchanter"], } },
			["7"] = { ["x"] = 54.52, ["y"] = 40.98, ["prof"] = "herbalism", ["title"] = L["Herbalism"], 
				["shop"] = L["Jandi's Arboretum"], ["trainers"] = { ["jandi"] = F["Herbalism Trainer"], } },
			["8"] = { ["x"] = 58.51, ["y"] = 53.64, ["prof"] = "cooking", ["title"] = L["Cooking"], 
				["shop"] = L["Borstan's Firepit"], ["trainers"] = { ["zamja"] = F["Cooking Trainer"], } },
			["9"] = { ["x"] = 60.96, ["y"] = 50.41, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["Magar's Cloth Goods"], ["trainers"] = { ["magar"] = L["Tailoring Trainer"], ["snang"] = 
				M["Apprentice Tailor"], } },
			["10"] = { ["x"] = 61.82, ["y"] = 46.06, ["prof"] = "leatherworking", ["shop"] = L["Kodohide Leatherworkers"],
				["title"] = L["Skinning"].. " / ".. L["Leatherworking"], ["trainers"] = { ["karolek"] = 
				L["Leatherworking Trainer"], ["kamari"] = G["Apprentice Leatherworker"], ["thuwd"] = L["Skinning Trainer"], } },
			["11"] = { ["x"] = 72.93, ["y"] = 28.01, ["prof"] = "mining", ["title"] = L["Mining"], 
				["shop"] = L["Red Canyon Mining"], ["trainers"] = { ["makaru"] = L["Mining Trainer"], } },
			["12"] = { ["x"] = 80.03, ["y"] = 23.83, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"], ["trainers"] = 
				{ ["shayis"] = F["Armorsmith Trainer"], ["okothos"] = L["Armorsmith"], ["borgosh"] = L["Weaponsmith"], 
				["snarl"] = M["Apprentice Blacksmith"], ["ugthok"] = M["Apprentice Blacksmith"], } },
			["13"] = { ["x"] = 81.24, ["y"] = 22.52, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"], 
				["shop"] = L["The Burning Anvil"], ["trainers"] = { ["saru"] = L["Blacksmithing Trainer"], } },
			["14"] = { ["x"] = 69.15, ["y"] = 13.42, ["prof"] = "riding", ["title"] = L["Riding"], 
				["trainers"] = { ["kildar"] = L["Riding Trainer"], } },
			["15"] = { ["x"] = 81.95, ["y"] = 18.02, ["prof"] = "blacksmithing", ["title"] = L["BlackSmithing"], 
				["shop"] = L["Arms of Legend"], ["trainers"] = { ["kelgruk"] = L["Weaponsmith Trainer"], } },
			["16"] = { ["x"] = 51.95, ["y"] = 82.93, ["rotateDegrees"] = 195, ["title"] = L["Riding"], ["note"] = 
				L["Sen'jin Village"].. " @ ".. "55.2,75.4", ["trainers"] = { ["xarti"] = F["Riding Trainer"], } },
	},
	["ShattrathCity"] = {
			["1"] = { ["x"] = 45.60, ["y"] = 21.48, ["prof"] = "alchemy", ["title"] = L["Alchemy"],
				["trainers"] = { ["lorokeem"] = L["Master Alchemy Trainer"], }, ["mhr"] = 4 },
			["2"] = { ["x"] = 56.61, ["y"] = 16.24, ["rotateDegrees"] = 90, ["title"] = L["Alchemy"], 
				["note"] = L["Go up two rope ramps then\ndescend one flight of stairs"], ["mhr"] = 4},
			["3"] = { ["x"] = 76.54, ["y"] = 33.67, ["prof"] = "cooking", ["title"] = L["Cooking"], 
				["shop"] = L["World's End Tavern"], ["trainers"] = { ["kylene"] = F["Cooking Trainer"], }, ["mhr"] = 4 },
			["4"] = { ["x"] = 69.53, ["y"] = 42.44, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"], ["trainers"] = 
				{ ["zula"] = F["Armorsmith Trainer"], ["kradu"] = L["Weaponsmith Trainer"], }, ["mhr"] = 4 },
			["5"] = { ["x"] = 67.26, ["y"] = 67.41, ["prof"] = "leatherworking", ["title"] = L["Leatherworking"], 
				["trainers"] = { ["darmari"] = F["Master Leatherworking Trainer"], }, ["mhr"] = 4 },
			["6"] = { ["x"] = 63.96, ["y"] = 65.93, ["prof"] = "skinning", ["title"] = L["Skinning"], 
				["trainers"] = { ["seymour"] = L["Master Skinning Trainer"], }, ["mhr"] = 4 },
			["7"] = { ["x"] = 62.67, ["y"] = 68.15, ["prof"] = "cooking", ["title"] = L["Cooking"], 
				["trainers"] = { ["jacktrapper"] = L["Cooking Trainer"], }, ["mhr"] = 4 },
			["8"] = { ["x"] = 66.72, ["y"] = 13.56, ["prof"] = "firstaid", ["title"] = L["First Aid"], 
				["shop"] = L["Shattrath Infirmary"], ["trainers"] = { ["mildred"] = F["Physician"], }, ["mhr"] = 4 },
			["9"] = { ["x"] = 64.00, ["y"] = 16.97, ["rotateDegrees"] = 350, ["title"] = L["First Aid"], 
				["note"] = L["Go up and on the far right"], ["mhr"] = 4 },
			["10"] = { ["x"] = 43.35, ["y"] = 92.35, ["prof"] = "enchanting", ["title"] = L["Enchanting"], 
				["shop"] = L["Seer's Library"], ["trainers"] = { ["bardolan"] = L["Enchanting Trainer"], ["volali"] = 
				F["Enchanting Trainer"], }, ["mhr"] = 4 },
			["11"] = { ["x"] = 33.73, ["y"] = 22.56, ["prof"] = "jewelcrafting", ["title"] = L["Jewelcrafting"], 
				["trainers"] = { ["hamanar"] = L["Jewelcrafting Trainer"], }, ["mhr"] = 4 },
	},
	["SilvermoonCity"] = {
			["1"] = { ["x"] = 57.38, ["y"] = 50.08, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["trainers"] = { ["keelen"] = L["Tailoring Trainer"], } },
			["2"] = { ["x"] = 85.04, ["y"] = 80.58, ["prof"] = "leatherworking", ["title"] = L["Leatherworking"], 
				["trainers"] = { ["lynalis"] = F["Leatherworking Trainer"], } },
			["3"] = { ["x"] = 85.23, ["y"] = 78.52, ["prof"] = "skinning", ["title"] = L["Skinning"],
				["trainers"] = { ["tyn"] = F["Skinning Trainer"], } },
			["4"] = { ["x"] = 69.65, ["y"] = 71.58, ["prof"] = "cooking", ["title"] = L["Cooking"], 
				["trainers"] = { ["sylann"] = F["Cooking Trainer"], }, ["note"] = L["Upstairs"],  },
			["5"] = { ["x"] = 90.33, ["y"] = 73.83, ["prof"] = "jewelcrafting", ["title"] = L["Jewelcrafting"], 
				["trainers"] = { ["kalinda"] = F["Jewelcrafting Trainer"], } },
			["6"] = { ["x"] = 77.81, ["y"] = 71.07, ["prof"] = "firstaid", ["title"] = L["First Aid"],
				["trainers"] = { ["alestus"] = L["First Aid Trainer"], } },
			["7"] = { ["x"] = 76.24, ["y"] = 67.76, ["prof"] = "fishing", ["title"] = L["Fishing"], 
				["trainers"] = { ["drathen"] = L["Fishing Trainer"], } },
			["8"] = { ["x"] = 91.24, ["y"] = 38.75, ["prof"] = "weapon", ["title"] = L["Weapon Skills"], 
				["trainers"] = { ["ileda"] = F["Weapon Master"], } },
			["9"] = { ["x"] = 79.38, ["y"] = 38.62, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"], 
				["trainers"] = { ["bemarrin"] = L["Blacksmithing Trainer"], } },
			["10"] = { ["x"] = 78.89, ["y"] = 43.23, ["prof"] = "mining", ["title"] = L["Mining"], 
				["trainers"] = { ["belil"] = L["Mining Trainer"], } },
			["11"] = { ["x"] = 76.97, ["y"] = 41.10, ["prof"] = "engineering", ["title"] = L["Engineering"], 
				["trainers"] = { ["danwe"] = F["Engineering Trainer"], } },
			["12"] = { ["x"] = 69.88, ["y"] = 23.69, ["prof"] = "enchanting", ["title"] = L["Enchanting"], 
				["trainers"] = { ["sedana"] = F["Enchanting Trainer"], } },
			["13"] = { ["x"] = 67.43, ["y"] = 18.39, ["prof"] = "herbalism", ["title"] = L["Herbalism"], 
				["trainers"] = { ["nathera"] = F["Herbalism Trainer"], } },
			["14"] = { ["x"] = 66.73, ["y"] = 16.79, ["prof"] = "alchemy", ["title"] = L["Alchemy"],
				["trainers"] = { ["camberon"] = L["Alchemy Trainer"], } },
			["15"] = { ["x"] = 72.41, ["y"] = 90.68, ["rotateDegrees"] = 245, ["title"] = L["Riding"], ["note"] = 
				L["Thuron's Livery"].. " @ ".. "61.38,53.98", ["trainers"] = { ["perascamin"] = L["Riding Trainer"], } },
	},
	["Stormwind"] = {
			["1"] = { ["x"] = 71.04, ["y"] = 62.01, ["prof"] = "leatherworking", ["shop"] = L["The Protective Hide"], 
				["title"] = L["Skinning"].. " / ".. L["Leatherworking"], 
				["trainers"] = { ["simon"] = L["Leatherworking Trainer"], ["randalworth"] = M["Apprentice Leatherworker"], 
				["maris"] = F["Skinning Trainer"], } },
			["2"] = { ["x"] = 78.18, ["y"] = 53.04, ["prof"] = "cooking", ["title"] = L["Cooking"],
				["shop"] = L["Pig and Whistle Tavern"], ["trainers"] = { ["ryback"] = L["Cooking Trainer"], } },
			["3"] = { ["x"] = 61.31, ["y"] = 30.01, ["prof"] = "engineering", ["title"] = L["Engineering"], 
				["trainers"] = { ["lilliam"] = F["Engineering Trainer"], ["sprite"] = G["Apprentice Engineer"], } },
			["4"] = { ["x"] = 59.06, ["y"] = 33.09, ["prof"] = "blacksmithing",  ["title"] = L["Blacksmithing"],
				["trainers"] = { ["borgus"] = M["Weaponsmith"], }, ["tbc"] = false },
			["5"] = { ["x"] = 59.02, ["y"] = 38.01, ["prof"] = "mining", ["title"] = L["Mining"], 
				["trainers"] = { ["gelman"] = L["Mining Trainer"], } },
			["6"] = { ["x"] = 64.04, ["y"] = 36.00, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"],
				["trainers"] = { ["therum"] = L["Blacksmithing Trainer"], ["dane"] = M["Apprentice Blacksmith"], } },
			["7"] = { ["x"] = 55.04, ["y"] = 69.02, ["prof"] = "fishing", ["title"] = L["Fishing"], 
				["trainers"] = { ["arnold"] = L["Fishing Trainer"], } },
			["8"] = { ["x"] = 64.08, ["y"] = 69.02, ["prof"] = "weapon", ["title"] = L["Weapon Skills"], 
				["shop"] = L["Weller's Arsenal"], ["trainers"] = { ["wooping"] = L["Weapon Master"], } },
			["9"] = { ["x"] = 53.09, ["y"] = 81.01, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["Duncan's Textiles"], ["trainers"] = { ["georgio"] = L["Tailoring Trainer"], 
				["lawrence"] = M["Apprentice Tailor"], } },
			["10"] = { ["x"] = 55.04, ["y"] = 86.07, ["prof"] = "alchemy", ["title"] = L["Alchemy"], ["shop"] = L["Alchemy Needs"], 
				["trainers"] = { ["lilyssia"] = F["Alchemy Trainer"], ["telathir"] = M["Apprentice Alchemist"], } },
			["11"] = { ["x"] = 54.03, ["y"] = 84.01, ["prof"] = "herbalism", ["title"] = L["Herbalism"], 
				["trainers"] = { ["tannysa"] = F["Herbalism Trainer"], } },
			["12"] = { ["x"] = 51.15, ["y"] = 83.08, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["Larson Clothiers"], ["trainers"] = { ["sellandus"] = M["Apprentice Tailor"], }, ["tbc"] = false },
			["13"] = { ["x"] = 39.08, ["y"] = 84.06, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["The Slaughtered Lamb"], ["trainers"] = { ["jalane"] = F["Master Shadoweave Tailor"], } },
			["14"] = { ["x"] = 36.06, ["y"] = 62.11, ["prof"] = "herbalism", ["title"] = L["Herbalism"], 
				["trainers"] = { ["shylamiir"] = F["Herbalism Trainer"], } },
			["15"] = { ["x"] = 53.00, ["y"] = 45.10, ["prof"] = "firstaid", ["title"] = L["First Aid"], 
				["shop"] = L["Cathedral of Light"], ["trainers"] = { ["shaina"] = F["First Aid Trainer"], } },
			["16"] = { ["x"] = 56.08, ["y"] = 59.01, ["rotateDegrees"] = 40, ["title"] = L["First Aid"], 
				["note"] = L["Entrance"], },
			["17"] = { ["x"] = 52.14, ["y"] = 74.01, ["prof"] = "enchanting", ["title"] = L["Enchanting"], 
				["trainers"] = { ["lucan"] = L["Enchanting Trainer"], ["betty"] = G["Apprentice Enchanter"], } },
			["18"] = { ["x"] = 75.00, ["y"] = 94.00, ["rotateDegrees"] = 265, ["title"] = L["Riding"], ["note"] = 
				L["Eastvale Logging Camp"].. " @ ".. "84.32,64.87", ["trainers"] = { ["randalhunter"] = L["Riding Trainer"], }},
	},
	["TheExodar"] = {
			["1"] = { ["x"] = 64.43, ["y"] = 68.49, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["Tailoring"], ["trainers"] = { ["refik"] = L["Tailoring Trainer"], 
				["kayaart"] = F["Apprentice Tailor"], } },
			["2"] = { ["x"] = 63.89, ["y"] = 76.36, ["prof"] = "leatherworking", ["title"] = L["Skinning"].. " / ".. 
				L["Leatherworking"], ["shop"] = L["Leatherworking"].. " & ".. L["Skinning"], 
				["trainers"] = { ["akham"] = L["Leatherworking Trainer"], ["feruul"] = L["Apprentice Leatherworker"], 
				["remere"] = F["Skinning Trainer"], } },
			["3"] = { ["x"] = 54.22, ["y"] = 92.36, ["prof"] = "engineering", ["title"] = L["Engineering"], 
				["trainers"] = { ["ockil"] = L["Engineering Trainer"], ["ghermas"] = F["Apprentice Engineer"], } },
			["4"] = { ["x"] = 60.05, ["y"] = 88.99, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"], 
				["shop"] = L["Mining & Smithing"], ["trainers"] = { ["miall"] = F["Blacksmithing Trainer"], 
				["edrem"] = L["Apprentice Blacksmith"], } },
			["5"] = { ["x"] = 59.69, ["y"] = 87.76, ["prof"] = "mining", ["title"] = L["Mining"], 
				["shop"] = L["Mining & Smithing"], ["trainers"] = { ["muaat"] = L["Mining Trainer"], } },
			["6"] = { ["x"] = 53.36, ["y"] = 85.75, ["prof"] = "weapon", ["title"] = L["Weapon Skills"], 
				["shop"] = L["Ring of Arms"], ["trainers"] = { ["handiir"] = L["Weapon Master"], } },
			["7"] = { ["x"] = 27.46, ["y"] = 62.85, ["prof"] = "herbalism", ["title"] = L["Herbalism"], 
				["shop"] = L["Alchemy"].. " & ".. L["Herbalism"], ["trainers"] = { ["cemmorhan"] = L["Herbalism Trainer"], } },
			["8"] = { ["x"] = 28.12, ["y"] = 61.00, ["prof"] = "alchemy", ["title"] = L["Alchemy"],
				["shop"] = L["Alchemy"].. " & ".. L["Herbalism"], ["trainers"] = { ["lucc"] = L["Alchemy Trainer"],
				["deriz"] = L["Apprentice Alchemist"], } },
			["9"] = { ["x"] = 40.34, ["y"] = 39.16, ["prof"] = "enchanting", ["title"] = L["Enchanting"], 
				["shop"] = L["Enchanting"], ["trainers"] = { ["nahogg"] = L["Enchanting Trainer"], 
				["kudrii"] = F["Apprentice Enchanter"], } },
			["10"] = { ["x"] = 45.23, ["y"] = 24.50, ["prof"] = "jewelcrafting", ["title"] = L["Jewelcrafting"], 
				["shop"] = L["Jewelcrafting"], ["trainers"] = { ["farii"] = F["Jewelcrafting Trainer"], } },
			["11"] = { ["x"] = 39.32, ["y"] = 22.19, ["prof"] = "firstaid", ["title"] = L["First Aid"],
				["trainers"] = { ["nus"] = F["First Aid Trainer"], } },
			["12"] = { ["x"] = 29.76, ["y"] = 19.96, ["prof"] = "fishing", ["title"] = L["Fishing"], 
				["trainers"] = { ["erett"] = F["Fishing Trainer"], } },
			["13"] = { ["x"] = 55.74, ["y"] = 26.72, ["prof"] = "cooking", ["title"] = L["Cooking"], 
				["shop"] = L["Cooking"], ["trainers"] = { ["mumman"] = F["Cooking Trainer"], } },
			["14"] = { ["x"] = 63.84, ["y"] = 36.38, ["rotateDegrees"] = 305, ["title"] = L["Riding"], ["note"] = 
				L["East of the main entrance"].. " @ ".. "81.33,52.63", ["trainers"] = { ["aalun"] = F["Riding Trainer"], } },
	},
	["ThunderBluff"] = {
			["1"] = { ["x"] = 40.93, ["y"] = 62.73, ["prof"] = "weapon", ["title"] = L["Weapon Skills"], 
				["shop"] = L["Thunder Bluff Weapons"], ["trainers"] = { ["ansekhwa"] = L["Weapon Master"], } },
			["2"] = { ["x"] = 36.50, ["y"] = 57.26, ["prof"] = "mining", ["title"] = L["Mining"], 
				["shop"] = L["Stonehoof Geology"], ["trainers"] = { ["brek"] = L["Mining Trainer"], } },
			["3"] = { ["x"] = 39.41, ["y"] = 55.89, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"],
				["trainers"] = { ["karn"] = L["Blacksmithing Trainer"], ["thrag"] = M["Apprentice Blacksmith"], } },
			["4"] = { ["x"] = 56.15, ["y"] = 46.38, ["prof"] = "fishing", ["title"] = L["Fishing"], 
				["shop"] = L["Mountaintop Bait & Tackle"], ["trainers"] = { ["kah"] = L["Fishing Trainer"], } },
			["5"] = { ["x"] = 50.72, ["y"] = 53.11, ["prof"] = "cooking", ["title"] = L["Cooking"],
				["shop"] = L["Aska's Kitchen"], ["trainers"] = { ["aska"] = F["Cooking Trainer"], } },
			["6"] = { ["x"] = 29.69, ["y"] = 21.18, ["prof"] = "firstaid", ["title"] = L["First Aid"], 
				["shop"] = L["Spiritual Healing"], ["trainers"] = { ["pand"] = L["First Aid Trainer"], } },
			["7"] = { ["x"] = 45.24, ["y"] = 38.40, ["prof"] = "enchanting", ["title"] = L["Enchanting"], 
				["shop"] = L["Dawnstrider Enchanters"], ["trainers"] = { ["teg"] = L["Enchanting Trainer"], 
				["mot"] = M["Apprentice Enchanter"], } },
			["8"] = { ["x"] = 47.89, ["y"] = 36.18, ["prof"] = "alchemy", ["title"] = L["Alchemy"], ["shop"] = 
				L["Bena's Alchemy"], ["trainers"] = { ["bena"] = F["Alchemy Trainer"], ["kray"] = 
				M["Apprentice Alchemist"], } },
			["9"] = { ["x"] = 49.96, ["y"] = 40.42, ["prof"] = "herbalism", ["title"] = L["Herbalism"], 
				["trainers"] = { ["komin"] = L["Herbalism Trainer"], } },
			["10"] = { ["x"] = 44.40, ["y"] = 44.84, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["Thunder Bluff Armorers"], ["trainers"] = { ["tepa"] = F["Tailoring Trainer"], 
				["vhan"] = M["Apprentice Tailor"], } },
			["11"] = { ["x"] = 41.73, ["y"] = 42.97, ["prof"] = "leatherworking", ["title"] = L["Leatherworking"],  
				["shop"] = L["Thunder Bluff Armorers"], ["trainers"] = { ["una"] = F["Leatherworking Trainer"], 
				["mak"] = M["Apprentice Leatherworker"], } },
			["12"] = { ["x"] = 44.45, ["y"] = 43.14, ["prof"] = "skinning", ["title"] = L["Skinning"],  
				["trainers"] = { ["mooranta"] = F["Skinning Trainer"], } },
			["13"] = { ["x"] = 35.09, ["y"] = 63.32, ["rotateDegrees"] = 220, ["title"] = L["Riding"], ["note"] = 
				L["Bloodhoof Village"].. " @ ".. "47.64,58.47", ["trainers"] = { ["kar"] = L["Riding Trainer"], }},
	},
	["Undercity"] = {
			["1"] = { ["x"] = 63.27, ["y"] = 44.06, ["prof"] = "cooking", ["title"] = L["Cooking"],
				["shop"] = L["Cooking"], ["note"] = L["Mezzanine level"], ["trainers"] = { 
				["eunice"] = F["Cooking Trainer"], } },
			["2"] = { ["x"] = 73.84, ["y"] = 56.06, ["prof"] = "firstaid", ["title"] = L["First Aid"], 
				["shop"] = L["First Aid"], ["trainers"] = { ["mary"] = F["First Aid Trainer"], } },
			["3"] = { ["x"] = 66.13, ["y"] = 6.99, ["rotateDegrees"] = 10, ["title"] = L["Riding"], ["note"] = 
				L["Brill"].. " @ ".. "60.08,52.57", ["trainers"] = { ["velma"] = F["Riding Trainer"], }},
			["4"] = { ["x"] = 70.73, ["y"] = 59.31, ["prof"] = "leatherworking", ["title"] = L["Skinning"].. " / ".. 
				L["Leatherworking"], ["shop"] = L["Leather Work"], ["trainers"] = { ["arthurm"] = L["Leatherworking Trainer"], 
				["dan"] = M["Apprentice Leatherworker"], ["killian"] = L["Skinning Trainer"], } },
			["5"] = { ["x"] = 61.10, ["y"] = 60.21, ["prof"] = "enchanting", ["title"] = L["Enchanting"], 
				["shop"] = L["Enchantment"], ["trainers"] = { ["lavinia"] = F["Enchanting Trainer"], 
				["malcomb"] = M["Apprentice Enchanter"], } },
			["6"] = { ["x"] = 54.02, ["y"] = 49.56, ["prof"] = "herbalism", ["title"] = L["Herbalism"], 
				["shop"] = L["Herbalist"], ["trainers"] = { ["marthaa"] = F["Herbalism Trainer"], } },
			["7"] = { ["x"] = 56.03, ["y"] = 37.47, ["prof"] = "mining", ["title"] = L["Mining"], 
				["shop"] = L["Mining"], ["trainers"] = { ["brom"] = L["Mining Trainer"], } },
			["8"] = { ["x"] = 57.31, ["y"] = 32.78, ["prof"] = "weapon", ["title"] = L["Weapon Skills"], 
				["trainers"] = { ["archibald"] = L["Weapon Master"], } },
			["9"] = { ["x"] = 61.11, ["y"] = 28.74, ["prof"] = "blacksmithing", ["title"] = L["Blacksmithing"],
				["trainers"] = { ["james"] = L["Blacksmithing Trainer"], ["basil"] = M["Apprentice Blacksmith"], } },
			["10"] = { ["x"] = 70.90, ["y"] = 28.94, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["Tailor"], ["trainers"] = { ["josef"] = L["Tailoring Trainer"], 
				["rhiannon"] = G["Apprentice Tailor"], ["victor"] = M["Apprentice Tailor"], } },
			["11"] = { ["x"] = 75.74, ["y"] = 73.63, ["prof"] = "engineering", ["title"] = L["Engineering"], 
				["trainers"] = { ["franklin"] = L["Engineering Trainer"], ["graham"] = M["Apprentice Engineer"], } },
			["12"] = { ["x"] = 80.69, ["y"] = 31.27, ["prof"] = "fishing", ["title"] = L["Fishing"], 
				["trainers"] = { ["armand"] = L["Fishing Trainer"], } },
			["13"] = { ["x"] = 86.66, ["y"] = 22.09, ["prof"] = "tailoring", ["title"] = L["Tailoring"], 
				["shop"] = L["Tailor"], ["trainers"] = { ["josephine"] = F["Master Shadoweave Tailor"], } },
			["14"] = { ["x"] = 47.75, ["y"] = 73.36, ["prof"] = "alchemy", ["title"] = L["Alchemy"], ["shop"] = 
				L["Alchemist"], ["trainers"] = { ["doctorh"] = L["Alchemy Trainer"], ["doctorm"] = 
				M["Apprentice Alchemist"], } },
			["15"] = { ["x"] = 50.92, ["y"] = 74.55, ["prof"] = "alchemy", ["title"] = L["Alchemy"], ["tbc"] = false,
				["shop"] = L["Alchemist"], ["trainers"] = { ["doctormarsh"] = M["Apprentice Alchemist"], } },
	},
}

local numMapProf = {
	["Darnassis"] = 11,
	["Ironforge"] = 16,
	["Ogrimmar"] = 16,
	["ShattrathCity"] = 11,
	["SilvermoonCity"] = 15,
	["Stormwind"] = 18,
	["TheExodar"] = 14,
	["ThunderBluff"] = 13,
	["Undercity"] = 15,
}
local mapProfFrame, miniProfFrame, maxMiniProf = {}, {}, 0

--------------
-- Map Scaling
--------------

-- The Minimap in WoW is never consistently scaled to the World Map. Additionally, there are six zoom levels to accommodate
-- The calibrations here are based purely upon eye judgment. There is no known way of automating this

local mapScales = {                 -- max out                           max in            max out                           max in
	["Darnassis"] = 		{ ["x"] = {0.188, 0.190, 0.190, 0.189, 0.188, 0.191}, ["y"] = {0.286, 0.279, 0.285, 0.280, 0.283, 0.284}, },
	["Inside"] = 			{ ["x"] = {0.120, 0.115, 0.102, 0.0844, 0.076, 0.071}, ["y"] = {0.185, 0.168, 0.153, 0.128, 0.113, 0.105}, },
	["Ironforge"] = 		{ ["x"] = {0.163, 0.150, 0.138, 0.114, 0.101, 0.095}, ["y"] = {0.230, 0.225, 0.204, 0.170, 0.150, 0.142}, },
	["Ogrimmar"] =  		{ ["x"] = {0.093, 0.086, 0.078, 0.064, 0.056, 0.054}, ["y"] = {0.138, 0.128, 0.117, 0.096, 0.085, 0.080}, },
	["ShattrathCity"] = 	{ ["x"] = {0.150, 0.150, 0.150, 0.150, 0.150, 0.150}, ["y"] = {0.230, 0.230, 0.230, 0.230, 0.230, 0.230}, },
	["SilvermoonCity"] = 	{ ["x"] = {0.107, 0.0995, 0.0895, 0.0745, 0.066, 0.061}, ["y"] = {0.161, 0.151, 0.131, 0.112, 0.098, 0.095}, },
	["Stormwind"] = 		{ ["x"] = {0.096, 0.086, 0.078, 0.066, 0.060, 0.055}, ["y"] = {0.142, 0.134, 0.121, 0.099, 0.087, 0.085}, },
	["TerraceOfLight"] = 	{ ["x"] = {0.100, 0.100, 0.100, 0.100, 0.100, 0.100}, ["y"] = {0.150, 0.150, 0.150, 0.150, 0.150, 0.150}, },
	["TheExodar"] = 		{ ["x"] = {0.120, 0.115, 0.102, 0.0844, 0.076, 0.071}, ["y"] = {0.185, 0.168, 0.153, 0.128, 0.113, 0.105}, },
	["ThunderBluff"] = 		{ ["x"] = {0.190, 0.194, 0.194, 0.196, 0.192, 0.193}, ["y"] = {0.287, 0.288, 0.282, 0.270, 0.280, 0.290}, },
	["Undercity"] = 		{ ["x"] = {0.138, 0.125, 0.114, 0.094, 0.086, 0.077}, ["y"] = {0.201, 0.187, 0.169, 0.140, 0.125, 0.115}, },
}

local textures = {
			class = "Interface\\AddOns\\".. addonName.. "\\Ringed-Classes",
			prof = "Interface\\AddOns\\".. addonName.. "\\Ringed-Professions",
			arrow = "Interface\\Minimap\\Rotating-MinimapArrow"
}

--------------------------------
-- Mini holds a few flags/fields
--------------------------------

-- WoW has severe limitations on the number of local variables and upvalues, especially for Vanilla. Grouping variables into tables is one
-- way to work around this limitation

local mini = { radii = { 233 + 1/3, 200, 166 + 2/3, 133 + 1/3, 100, 66 + 2/3 },	-- Units: game yards
		zoom = 0, width = 0, height = 0, entered = false, xPlayer = 0, yPlayer = 0, tooltipShowing = false,
		size = 0,
}

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		World Map Specific
--		==================
--
--------------------------------------------------------------------------------------------------------------------------------------------

local function WorldMapTooltipOnEnter( icon )

	if ( TrainerDB.hideWorldMapIcons == "y" ) then return end

	WorldMapTooltip:SetOwner( icon, ANCHOR_LEFT )
	if ( icon.type == "C" ) then
		WorldMapTooltip:SetText( pc_colour_Prefix.. mapClass[ icon.map ][ icon.index ].title )
		if mapClass[ icon.map ][ icon.index ].shop then
			WorldMapTooltip:AddLine( pc_colour_Highlight.. mapClass[ icon.map ][ icon.index ].shop )
		end
		if mapClass[ icon.map ][ icon.index ].trainers then
			for k,v in pairs( mapClass[ icon.map ][ icon.index ].trainers ) do
				WorldMapTooltip:AddDoubleLine( pc_colour_PlainText.. npc[ k ], pc_colour_PlainText.. v )
			end
		end
		if mapClass[ icon.map ][ icon.index ].note then
			WorldMapTooltip:AddLine( pc_colour_Highlight.. mapClass[ icon.map ][ icon.index ].note )
		end
	else
		WorldMapTooltip:SetText( pc_colour_Prefix.. mapProf[ icon.map ][ icon.index ].title )
		if mapProf[ icon.map ][ icon.index ].shop then
			WorldMapTooltip:AddLine( pc_colour_Highlight.. mapProf[ icon.map ][ icon.index ].shop )
		end
		if mapProf[ icon.map ][ icon.index ].trainers then
			for k,v in pairs( mapProf[ icon.map ][ icon.index ].trainers ) do
				WorldMapTooltip:AddDoubleLine( pc_colour_PlainText.. npc[ k ], pc_colour_PlainText.. v )
			end
		end
		if mapProf[ icon.map ][ icon.index ].note then
			WorldMapTooltip:AddLine( pc_colour_Highlight.. mapProf[ icon.map ][ icon.index ].note )
		end
	end
	WorldMapTooltip:Show()
end

local function HideOnWorldMap()

	-- In some situations the server uses smoke and mirrors. Example. In SW/IF and have opened WorldMap. Go to Deeprun Tram with WorldMap 
	-- CLOSED. Open the WorldMap. Icons from SW/IF are still visible even though the Azeroth map is visible. Icons, when tested are not 
	-- visible, nor respond to mouseovers. They seem painted on. Solution is to pre-hook the WorldMap "OnHide" script and make the icons 
	-- hide before the WorldMap gets hidden.
	-- Gets invoked 2x for a single close of the WorldMap in the Deeprun Tram, 3x elsewhere so keep it lean.
	-- Does NOT fix the case where player runs into the Deeprun Tram with the WorldMap OPEN. See specific code in ShowOnWorldMap for fix

	mini.prevX, mini.prevY = 0, 0
	-- Necessary to force a Minimap update

	-- Following code fixes: ReloadUI() -> Show map with icons -> Close map -> Enter instance, esp. RFC -> Open World Map -> Icons showing
	-- It appears the server is snapshotting the WorldMap?

	for k,v in pairs( numMapClass ) do
		for i = 1, numMapClass[ k ] do
			mapClassFrame[ k ][ i ]:Hide()
		end
		for i = 1, numMapProf[ k ] do
			mapProfFrame[ k ][ i ]:Hide()
		end
	end
end

local function ShowOnWorldMap()

	if not WorldMapFrame:IsVisible() then return end

	-- In Vanilla the Minimap is NOT visible when the WorldMap is shown as the WorldMap is full screen. BUT in one situation when tested, 
	-- namely showing the WorldMap at the same time as running from SW/IF into the Deeprun Tram, the MiniMap will continue to erroneously 
	-- display the AddOn icons when the WorldMap is later closed. This code solves the problem

	for i = 1, maxMiniClass do
		miniClassFrame[ i ]:SetAlpha( 0 )
	end
	for i = 1, maxMiniProf do
		miniProfFrame[ i ]:SetAlpha( 0 )
	end

	-- mapName is an internal "file name" so doesn't need translating. Class and prof tables are built around these values of mapName
	local mapName = GetMapInfo()	

	-- This is the SHOWING World Map and not necessarily the PLAYER LOCATION World Map
	-- Result may be null but the following code can handle that

	for k,v in pairs( numMapClass ) do

		-- Note: Assuming that for every k in mapClassFrame there is a corresponding k in mapProfFrame

		-- For efficiency, testing the first in the table for visibility worked until I added TBC. Then I had to allow for entirely empty
		-- icons due to all the trainers no longer being trainers in TBC as well as the new Jewelcrafting profession

		if ( mapName == k ) then
			if ( TrainerDB.hideClassIcons == "y" ) or ( TrainerDB.hideWorldMapIcons == "y" ) then
				for i = 1, v do
					mapClassFrame[ k ][ i ]:Hide()
				end
			else
				for i = 1, v do
					if ( mapClassFrame[ k ][ i ].tbc ~= nil ) then
											if ( ( vanilla == true ) and ( mapClassFrame[ k ][ i ].tbc == false ) ) or
								( ( tbc == true ) and ( mapClassFrame[ k ][ i ].tbc == true ) ) then
							mapClassFrame[ k ][ i ]:Show()
						else
							mapClassFrame[ k ][ i ]:Hide()
						end
					else
						mapClassFrame[ k ][ i ]:Show()
					end
				end
			end
			if ( TrainerDB.hideProfIcons == "y" ) or ( TrainerDB.hideWorldMapIcons == "y" ) then 
				for i = 1, numMapProf[ k ] do
					mapProfFrame[ k ][ i ]:Hide()
				end
			else
				for i = 1, numMapProf[ k ] do
					if ( mapProfFrame[ k ][ i ].tbc ~= nil ) then
						if ( ( vanilla == true ) and ( mapProfFrame[ k ][ i ].tbc == false ) ) or
								( ( tbc == true ) and ( mapProfFrame[ k ][ i ].tbc == true ) ) then
							mapProfFrame[ k ][ i ]:Show()
						else
							mapProfFrame[ k ][ i ]:Hide()
						end
					else
						mapProfFrame[ k ][ i ]:Show()
					end	
				end
			end
		else

			-- We come here for every city NOT being displayed. Large number of icons to hide.
			-- If this kills the client I'll need to do as I did with the minimap

			for i = 1, v do
				mapClassFrame[ k ][ i ]:Hide()
			end
			for i = 1, numMapProf[ k ] do
				mapProfFrame[ k ][ i ]:Hide()
			end
		end
	end
end

local function CreateWorldMapIcon( pinData, x, y )

	local icon = CreateFrame( "Button", nil, WorldMapButton )
	icon:SetPoint( "CENTER", WorldMapButton, "CENTER", x, y )
	icon:SetScript( "OnEnter", function() WorldMapTooltipOnEnter( icon ) end )
	icon:SetScript( "OnLeave", function() WorldMapTooltip:Hide() end )
	local iconTexture = icon:CreateTexture( nil, "OVERLAY" )
	if pinData.prof then
		iconTexture:SetTexture( textures.prof )
	elseif pinData.class then
		iconTexture:SetTexture( textures.class )
	else
		iconTexture:SetTexture( textures.arrow )
	end
	if pinData.class then
		iconTexture:SetTexCoord( unpack( classCoords[ pinData.class ] ) )
		icon:SetHeight( TrainerDB.iconSize )
		icon:SetWidth( TrainerDB.iconSize )
	elseif pinData.prof then
		iconTexture:SetTexCoord( unpack( profCoords[ pinData.prof ] ) )
		icon:SetHeight( TrainerDB.iconSize )
		icon:SetWidth( TrainerDB.iconSize )
	elseif pinData.rotateDegrees then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = RotationCorners( pinData.rotateDegrees )
		iconTexture:SetTexCoord( ULx, ULy, LLx, LLy, URx, URy, LRx, LRy )
		icon:SetHeight( TrainerDB.iconSize * 1.8 )
		icon:SetWidth( TrainerDB.iconSize * 1.8 )
	else
		icon:SetHeight( TrainerDB.iconSize )
		icon:SetWidth( TrainerDB.iconSize )
	end
	iconTexture:SetAllPoints()
	icon.iconTexture = texture
	icon:Hide()
	return icon
end

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		MiniMap Specific
--		================
--
--------------------------------------------------------------------------------------------------------------------------------------------

local function MinimapHacksToMakeThingsWork( k )

	-- return: 0 = SetAlpha(1), -1 = SetAlpha(0) for all k, >= 1 = Special cases
	-- m = (y1-y2)/(x1-x2) and y = m(x-x1) + y1 = m * mini.xPlayer + ( y1 - m * x1 ) with all x and y in the range 0-1

	local calcY, hypotenuse, subzone = 0, 0;

	if ( k == "Darnassis" ) then

		-- There are several "indoor" areas upon the trainer platforms in the city where the minimap scale changes.
		-- A future update, which would be a lot of work for Vanilla as it cannot test for IsIndoors(), could resolve this

		subzone = GetSubZoneText()
		if find( subzone, L["Temple of the Moon"], 1, true ) then
			-- The Temple has a special scale. Unlike Stormwind's Valley of the Heroes, this one can't be avoided.
			-- When in the TotM, external icons will be suppressed
			return 1
		end

		-- The Cenarion Enclave has Rogue trainers located UNDER it AND they have a uniquely scaled minimap.
		-- To avoid floating minimap icons we need to remove them for rogues. IsIndoors() is a TBC+ API feature, sadly.
		-- Where the above ground icons are not unduly compromised, the below ground icons will be excluded. Not a perfect solution

		if find( subzone, L["Cenarion Enclave"], 1, true ) then

			if ( tbc == true ) then
				if ( IsIndoors() == booleanTrue ) then
					return -1
				end
			end

			-- The following test has a false positive when the player is in close proximity of the lamp at the foot of the ramp up to
			-- the poison vendor and one nook at the base of the tree at approximately (33.71,18.25). Quite good enough!

			hypotenuse = sqrt( ( mini.xPlayer * 100 - 32.28 )^2 + ( mini.yPlayer * 100 - 17.73 )^2 )
			if hypotenuse < 1.574 then
				return -1
			end

			-- Druids have their own specially scaled minimap interiors ABOVE the Cenarion Enclave. This is easier to deal with.
			-- The following successfully excludes the Druid trainer tree interiors. A false positive on the ground in a nook at
			-- (36.03,8.15) and a section against the tree near Jenal are the only problems here

			hypotenuse = sqrt( ( mini.xPlayer * 100 - 34.33 )^2 + ( mini.yPlayer * 100 - 8.56 )^2 )
			if hypotenuse < 2.1 then
				return -1
			end

			-- Sadly, that's it for Vanilla. Floating icons while visiting rogues as the rogue area cuts right under common player
			-- walking paths
		end

	elseif ( k == "Ironforge" ) then
	
		-- Deeprun Tram fix as per notes for Stormwind above.

		calcY = -9.58824 * mini.xPlayer + 7.49891			-- end closest to Tinker Town
		if ( calcY < mini.yPlayer ) then
			calcY = 0.23571 * mini.xPlayer + 0.322311		-- Northern side of the tunnel
			if ( calcY < mini.yPlayer ) then
				calcY = 0.237209 * mini.xPlayer + 0.338122	-- Southern side of the tunnel
				if ( calcY > mini.yPlayer ) then
					return -1
				end
			end
		end

	elseif ( k == "Ogrimmar" ) then

		-- Same as with Stormwind, Orgrimmar's Ragefire Chasm instance also needs to be gated

		calcY = 3.923077 * mini.xPlayer - 1.54441				-- (51.86,49.01) and (52.12,50.03)
		if ( calcY > mini.yPlayer ) then
			calcY = -0.325843 * mini.xPlayer + 0.654926			-- (52.61,48.35) and (51.72,48.64)
			if ( calcY < mini.yPlayer ) then
				calcY = -1.276596 * mini.xPlayer + 1.173489		-- (53.07,49.6) and (52.13,50.8)
				if ( calcY > mini.yPlayer ) then
					calcY = -3.5 * mini.xPlayer - 1.357775	-- (52.65,48.5) & (52.95,49.55)
					if ( calcY < mini.yPlayer ) then
						return -1
					end
				end
			end
		end

	elseif ( k == "ShattrathCity" ) then
	
		-- The interior of the Terrace of Light has its own scale. The problem is identifying this. The wide circumferential promenade
		-- outside of the dome-like structure is also regarded as the Terrace of Light as is the space above. Both of these areas use the
		-- normal Shatttrath City scaling. The interior IS a flying zone and returns false for IsIndoors(). I also have no z-axis but
		-- thankfully have IsFlying() (from Patch 2.0.1). Additionally, the Terrace of Light is an ellipse, with exits along the axiis.
		
		subzone = GetSubZoneText()
		if find( subzone, L["Terrace of Light"], 1, true ) then
			
			-- The four points of the ellipse are, thankfully, the terrace/promenade level exits
			local ellipse = { ["a1"] = { ["x"] = 51.89, ["y"] = 38.43}, ["a2"] = { ["x"] = 56.09, ["y"] = 51.08}, 
							["b1"] = { ["x"] = 49.82, ["y"] = 47.87}, ["b2"] = { ["x"] = 58.16, ["y"] = 41.64}, }
			-- m = (y1-y2)/(x1-x2) and y = m(x-x1) + y1 = m*x + c, where c = y1 - m*x1
			local mMajor = ( ellipse.a1.y - ellipse.a2.y ) / ( ellipse.a1.x - ellipse.a2.x )
			local cMajor = ( ellipse.a1.y - mMajor * ellipse.a1.x )
			local mMinor = ( ellipse.b1.y - ellipse.b2.y ) / ( ellipse.b1.x - ellipse.b2.x )
			local cMinor = ( ellipse.b1.y - mMinor * ellipse.b1.x )
			-- Using the "intersection of two lines" formula
			local xCentre = ( cMinor - cMajor ) / ( mMajor - mMinor )
			-- Substitute x into one of the two line formulas
			local yCentre = mMajor * xCentre + cMajor
			-- Basic geometry x^2 + y^2 = hypotenuse^2
			local aRadius = sqrt( ( ellipse.a1.x - ellipse.a2.x ) ^ 2 + ( ellipse.a1.y - ellipse.a2.y ) ^ 2 ) / 2
			local bRadius = sqrt( ( ellipse.b1.x - ellipse.b2.x ) ^ 2 + ( ellipse.b1.y - ellipse.b2.y ) ^ 2 ) / 2
			-- angle in degrees
			local theta = atan( mMajor ) * 180 / pi
			-- translate and rotate player X,Y coordinates
			local xPlayerRot = ( mini.xPlayer * 100 - xCentre ) * cos( theta ) + ( mini.yPlayer * 100 - yCentre ) * sin( theta )
			local yPlayerRot = ( mini.xPlayer * 100 - xCentre ) * sin( theta ) - ( mini.yPlayer * 100 - yCentre ) * cos( theta )
			
			if ( xPlayerRot / bRadius ) ^ 2 + ( yPlayerRot / aRadius ) ^ 2 < 1 then
				-- The player might be ABOVE the dome. No z-axis. IsFlying() works EXCEPT if the player is flying INSIDE the dome :(
				-- So this is the best we can do
				if not IsFlying() then			
					return 4
				end
			end
		end

		-- The Lower city passageways to Terrokar Forest have their own minimap. Easier to not display icons when in the passageways.
		-- The passageways are not regarded as indoors so must use coordinates. Anticlockwise from the Scryer's Tier.
		-- Note the passageway connecting the Aldor Rise to Nagrand's High Path does not require icon removal
		
		calcY = -1.588235 * mini.xPlayer + 1.774182				-- (69.85,66.48) and (69.17,67.56)
		if ( calcY < mini.yPlayer ) then
			calcY = 1.39665 * mini.xPlayer - 0.3171				-- (69.96,66.00) and (75.33,73.5)
			if ( calcY < mini.yPlayer ) then
				calcY = 1.6014 * mini.xPlayer - 0.4282			-- (69.20,68.00) and (74.82,77.00)
				if ( calcY > mini.yPlayer ) then
					return -1
				end
			end
		end

		calcY = -21.571429 * mini.xPlayer + 17.332629			-- (78.37,42.71) and (78.30,44.22)
		if ( calcY < mini.yPlayer ) then
			calcY = 0.03425 * mini.xPlayer + 0.3991				-- (78.57,42.6) and (84.41,42.8)
			if ( calcY < mini.yPlayer ) then
				calcY = 0.18916 * mini.xPlayer + 0.29646		-- (78.53,44.5) and (86.46,46.0)
				if ( calcY > mini.yPlayer ) then
					return -1
				end
			end
		end
		
		calcY = mini.xPlayer - 0.5264							-- (71.80,19.16) and (72.62,19.98) (i.e. m = 1)
		if ( calcY > mini.yPlayer ) then
			calcY = -2.2335 * mini.xPlayer + 1.78813			-- (73.03,15.7) and (75.00,11.3)
			if ( calcY < mini.yPlayer ) then
				calcY = -2 * mini.xPlayer + 1.6554				-- (72.77,20.0) and (77.32,10.9)
				if ( calcY > mini.yPlayer ) then
					return -1
				end
			end
		end

		-- Several indoor areas, such as the Banks, Orphanage, World's End Tavern, etc have their own Minimap and scaling
		
		if ( IsIndoors() == booleanTrue ) then
			return -1
		end

	elseif ( k == "Stormwind" ) then

		-- The Stormwind Valley of Heroes has a different scale. So hide icons rather than a special rescale
		-- Use a straight line at the entrance to the tunnel leading into the Trade District

		calcY = -1.18987 * mini.xPlayer + 1.455795
		if calcY < mini.yPlayer then
			-- Extra check to include all of SI:7 HQ as parts are beyond the line
			-- Numbers are very approximate as I kept finding wall jump exceptions so I allowed generous provision
			calcY = 6.54 * mini.xPlayer - 4.3	
			if calcY < mini.yPlayer then
				return -1
			end
		end

		-- Blizzard used smoke and mirrors for the Minimap on entering the Deeprun Tram. It appears they took a snapshot with the
		-- consequence for this AddOn being that despite setting alpha to zero, the icons appear on the Minimap background. Solution
		-- is to establish a rectangular zone near the entrance where the AddOn has already set alpha to zero while still in SW.
		-- Need to disable the Minimap icons prior to entry. A "dead zone" established at the entrance area. Complication: The Royal
		-- Gallery of Stormwind Keep shares some of this rectangle. Thus must also check the sub-zone. Note: This code still breaks 
		-- when running into the Deeprun Tram with the WorldMap open. The "OnHide" hook fixes that

		calcY = 1.897436 * mini.xPlayer - 1.070926
		if ( calcY > mini.yPlayer ) and ( calcY < 0.1478 ) then
			-- Maybe in the tunnel but the line crosses through Stormwind Keep and the future Royal Bank of Stormwind
			calcY = -1.20904 * mini.xPlayer + 0.848566
			if calcY < mini.yPlayer then
				-- Within the northern tunnel side line so not in the unused bank building
				calcY = -1.20904 * mini.xPlayer + 0.860681
				if calcY > mini.yPlayer then	
					-- Within the southern tunnel side line so Stormwind Keep MOSTLY excluded
					subzone = GetSubZoneText()
					if find( subzone, L["Dwarven District"], 1, true ) then
						return -1
					end
				end
			end
		end

		-- And the Stormwind Stockade also needs to be gated. Sadly, the floor directly above the descending ramp will also have no
		-- Minimap icons. Can't be avoided

		calcY = -1.09524 * mini.xPlayer + 0.989162
		if ( calcY > mini.yPlayer ) then
			calcY = -1.09524 * mini.xPlayer + 0.9754	-- As close to the portal as is reliable
			if ( calcY < mini.yPlayer ) then
				-- it now remains to fence off the sides of the ramp
				calcY = 1.875 * mini.xPlayer - 0.194775
				if calcY > mini.yPlayer then	
					calcY = 1.9 * mini.xPlayer - 0.22266
					if calcY < mini.yPlayer then
						return -1
					end
				end
			end
		end

	elseif ( k == "TheExodar" ) then

		if ( IsIndoors() ~= booleanTrue ) then
			return -1
		end

	elseif ( k == "ThunderBluff" ) then

		subzone = GetSubZoneText()
		if find( subzone, L["Pools of Vision"], 1, true ) then
			-- The Pools have their own scaled map. It is also directly below the Spirit Rise
			-- When in the TPoV, external icons will be suppressed
			return 2
		end

		-- The large central spiraling ramp has its own scale and display. Better to remove. It is far from an easy cylinder
		-- shape, with various exits and thick walls. The test covers the exits around the Wind Rider Master, where players
		-- are more likely to linger and does a passable job covering the Minimap transition for the other exits.
		-- Further tests for the other exits were found to impact the player when standing at the top

		hypotenuse = sqrt( ( mini.xPlayer * 100 - 46.55 )^2 + ( mini.yPlayer * 100 - 49.8 )^2 )
		if hypotenuse < 1.8 then
			return -1
		end

		-- The Hunter's Hall has the "Inside" scale. It has no unique SubZone text so must resort to setting up an oblique 
		-- rectangle. It was impossible to exactly match the changeover between maps as the game engine varied depending upon the 
		-- player's speed and placement - stuttering along the sides delayed things somewhat. The rectangle is approximate. A couple 
		-- of false positives along the sides will not be noticed but larger areas either side of the entrance might be noticed

		calcY = 0.879699 * mini.xPlayer + 0.301852				-- (58.48,81.63) and (61.14,83.97)
		if ( calcY < mini.yPlayer ) then
			calcY = -3.102564 * mini.xPlayer + 2.617128			-- (57.26,84.060) and (55.7,88.9)
			if ( calcY < mini.yPlayer ) then
				calcY = -2.466856 * mini.xPlayer + 2.347720		-- (60.312,85.99) and (58.2,91.2)
				if ( calcY > mini.yPlayer ) then
					calcY = 0.893333 * mini.xPlayer + 0.393967	-- (55.75,89.2) & (58.0,91.21)
					if ( calcY > mini.yPlayer ) then
						return 3
					end
				end
			end
		end
		
	elseif ( k == "Undercity" ) then

		subzone = GetSubZoneText()
		if find( subzone, L["Ruins of Lordaeron"], 1, true ) then
			return -1
		end

		-- Sigh. There is a small zone right at the entrance to the ruins and which triggers the "Undercity" subzone.
		-- Produces an annoying "flash" of icons as the player steps through. Right on the top edge of the map so easy to test

		if mini.yPlayer < 0.013 then
			return -1
		end
	end

	return 0
end

local function AdjustMinimapCoordinates( x, y, radiusByScaleX, radiusByScaleY )

	local scaledX = ( mini.xPlayer - x / 100 ) * 100 / radiusByScaleX
	local scaledY = ( mini.yPlayer - y / 100 ) * 100 / radiusByScaleY

	-- Allow to float on border and not exceed border
	local pointRadiusSquared = scaledX^2 + scaledY^2
	if pointRadiusSquared > 0.2025 then
		local reductionRatio = 0.45 / sqrt( pointRadiusSquared )
		scaledX, scaledY = scaledX * reductionRatio, scaledY * reductionRatio
	end

	return -scaledX * mini.width, scaledY * mini.height
end

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		Events
--		======
--
--------------------------------------------------------------------------------------------------------------------------------------------

-- On a fresh login we get VARIABLES_LOADED -> PLAYER_ENTERING_WORLD -> WORLD_MAP_UPDATE x 2 -> ZONE_CHANGED_NEW_AREA -> WORLD_MAP_UPDATE
-- On a ReloadUI we get VARIABLES_LOADED -> PLAYER_ENTERING_WORLD
-- On opening the World map we get a WORLD_MAP_UPDATE and zooming or selecting different maps also triggers this
-- On changing zone we get 2 x ZONE_CHANGED_NEW_AREA, one immediately, and the second after a short delay of 1 or 2 seconds

-- TBC:
-- On a fresh login we get WORLD_MAP_UPDATE -> VARIABLES_LOADED -> PLAYER_ENTERING_WORLD -> WORLD_MAP_UPDATE x 3/2 ->
--		ZONE_CHANGED_NEW_AREA -> WORLD_MAP_UPDATE x 3/4
-- On a ReloadUI we get WORLD_MAP_UPDATE -> VARIABLES_LOADED -> then occasionally: PLAYER_ENTERING_WORLD -> WORLD_MAP_UPDATE 
-- On opening the World map we get PLAYER_ENTERING_WORLD -> WORLD_MAP_UPDATE x 3 then WORLD_MAP_UPDATE x 2 for each subsequent activity

local function OnEventHandler( frame, theEvent, arg )

	-- Prior to Patch 4.0.1, the globals "event", "arg1", etc were automagically setup by Blizzard. No variables were passed
	-- From Patch 4.0.1 "self", "event", and varag "args" are passed. Renamed here from normal conventions to avoid conflicts

	if ( theEvent == "VARIABLES_LOADED" ) or ( event == "VARIABLES_LOADED" ) then

		if not TrainerDB then TrainerDB = {} end
		local iconSize = TrainerDB.iconSize or 15
		local hideClassIcons = TrainerDB.hideClassIcons or "n"
		local hideProfIcons = TrainerDB.hideProfIcons or "n"
		local hideWorldMapIcons = TrainerDB.hideWorldMapIcons or "n"
		local hideMinimapIcons = TrainerDB.hideMinimapIcons or "n"
		TrainerDB = {}
		TrainerDB.iconSize = iconSize
		TrainerDB.hideClassIcons = hideClassIcons
		TrainerDB.hideProfIcons = hideProfIcons
		TrainerDB.hideWorldMapIcons = hideWorldMapIcons
		TrainerDB.hideMinimapIcons = hideMinimapIcons

		if locale == "zhCN" then
			addonTitle = GetAddOnMetadata( addonName, "Title-zhCN" )
		else
			addonTitle = GetAddOnMetadata( addonName, "Title" )
		end

 		local worldmapWidth, worldmapHeight = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
		maxMiniClass, maxMiniProf = 0, 0
		
		if ( buildVersionMajor > "2" ) then return end

		-- Creating buttons for every city but only one city will ever be visible. WorldMap should cope with this

		for k,v in pairs( numMapClass ) do
			mapClassFrame[ k ] = {}
			for i = 1, v do	
				local pointerClass = mapClass[ k ][ tostring( i ) ]		
				mapClassFrame[ k ][ i ] = CreateWorldMapIcon( pointerClass, ( pointerClass.x - 50 ) * worldmapWidth / 100, 
								( worldmapHeight / 2 ) - ( worldmapHeight * pointerClass.y / 100 )  )
				mapClassFrame[ k ][ i ].type = "C"
				mapClassFrame[ k ][ i ].index = tostring( i )
				mapClassFrame[ k ][ i ].map = k
				if ( pointerClass.tbc ~= nil ) then mapClassFrame[ k ][ i ].tbc = pointerClass.tbc end
			end
			if v > maxMiniClass then maxMiniClass = v end
		end

		for k,v in pairs( numMapProf ) do
			mapProfFrame[ k ] = {}
			for i = 1, v do			
				local pointerProf = mapProf[ k ][ tostring( i ) ]		
				mapProfFrame[ k ][ i ] = CreateWorldMapIcon( pointerProf, ( pointerProf.x - 50 ) * worldmapWidth / 100, 
								( worldmapHeight / 2 ) - ( worldmapHeight * pointerProf.y / 100 )  )
				mapProfFrame[ k ][ i ].type = "P"
				mapProfFrame[ k ][ i ].index = tostring( i )
				mapProfFrame[ k ][ i ].map = k
				if ( pointerProf.tbc ~= nil ) then mapProfFrame[ k ][ i ].tbc = pointerProf.tbc end
			end
			if v > maxMiniProf then maxMiniProf = v end
		end

		-- The Minimap is more easily stressed from too many textures. So we create only sufficient for the busiest map

		for i = 1, maxMiniClass do				
			miniClassFrame[ i ] = Minimap:CreateTexture( nil, "OVERLAY" )
			miniClassFrame[ i ]:SetAllPoints()
			miniClassFrame[ i ]:SetAlpha( 0 )
		end
		for i = 1, maxMiniProf do				
			miniProfFrame[ i ] = Minimap:CreateTexture( nil, "OVERLAY" )
			miniProfFrame[ i ]:SetAllPoints()
			miniProfFrame[ i ]:SetAlpha( 0 )
		end

		-- Cannot use Minimap:Hookscript() for Vanilla. TBC implementation is patchy
		local CurrentOnEnterScript = Minimap:GetScript( "OnEnter" )
		if currentOnEnterScript then
			Minimap:SetScript( "OnEnter", function() mini.entered = true CurrentOnEnterScript() end )
		else
			Minimap:SetScript( "OnEnter", function() mini.entered = true end )
		end
		local CurrentOnLeaveScript = Minimap:GetScript( "OnLeave" )
		if currentOnLeaveScript then
			Minimap:SetScript( "OnLeave", function() mini.entered = false CurrentOnLeaveScript() end )
		else
			Minimap:SetScript( "OnLeave", function() mini.entered = false end )
		end

		-- See notes in the function as to why this hooking was even necessary
		local origWorldMapOnHideScript = WorldMapFrame:GetScript("OnHide")
		WorldMapFrame:SetScript( "OnHide", function() HideOnWorldMap() origWorldMapOnHideScript() end )

	elseif ( theEvent == "WORLD_MAP_UPDATE" ) or ( event == "WORLD_MAP_UPDATE" ) then
		if ( buildVersionMajor <= "2" ) then ShowOnWorldMap() end

	end
end

local eventFrame = CreateFrame( "Frame" )
eventFrame:RegisterEvent( "WORLD_MAP_UPDATE" )
eventFrame:RegisterEvent( "VARIABLES_LOADED" )
eventFrame:SetScript( "OnEvent", OnEventHandler )

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		OnUpdate Handler
--		================
--
--------------------------------------------------------------------------------------------------------------------------------------------

local timeSinceLastUpdate = 0

local function OnUpdateHandler()

	-- From a certain patch/update the timeElapsed was passed as a value. But this block should work across all versions of WoW.
	-- Actually timeElapsed ignores the time elapsed while looking at a loading screen or a cinematic. GetTime is better

	local curTime = GetTime()
	if curTime - timeSinceLastUpdate <= 0.05 then return end
	timeSinceLastUpdate = curTime

	-- The AddOn only includes Vanilla/TBC trainers, currently
	if ( buildVersionMajor > "2" ) or WorldMapFrame:IsShown() then return end
	if ( ( TrainerDB.hideClassIcons == "y" ) and ( TrainerDB.hideProfIcons == "y" ) ) 
				or ( TrainerDB.hideMinimapIcons == "y" ) or not MinimapCluster:IsShown() then
		return
	end

	-- To here if we want the icons and the Minimap is being shown. Noting also that we need to be okay with patches Vanilla -> present.
	-- Need the (X,Y) player coordinates so that the Minimap can be setup. (X,Y) coordinates are provided by the server's World Map API, 
	-- which is separate from the Minimap frame. To make this work I insist that the World Map NOT be currently shown. As the World Map is
	-- full screen in Vanilla and TBC then this is not really a problem

	SetMapToCurrentZone()
	mini.xPlayer, mini.yPlayer = GetPlayerMapPosition( "player" )
	local mapFileName = GetMapInfo()

	local validArea = false
	mini.zoneText = GetZoneText()		-- Localised data
	mini.zoneText = L[ mini.zoneText ]	-- Change into the mapName based tables
	mini.zoom = Minimap:GetZoom()
	mini.width, mini.height = Minimap:GetWidth(), Minimap:GetHeight()
	mini.size = round( TrainerDB.iconSize * 0.75, 2 )
	
	-- Unlike in my Netherwing Eggs AddOn, we can't clear the Minimap and abort right now if we are not in a zone.
	-- We need to test, drop through, and cleanup at the end
	
	local mapHackResult, numberOfIconsInZone = -1, 0
	
	if ( TrainerDB.hideClassIcons ~= "y" ) then
		for k,v in pairs( numMapClass ) do
			local radiusByScaleXC, radiusByScaleYC = 0, 0
			if ( mini.zoneText == L[ k ] ) then
				mapHackResult = MinimapHacksToMakeThingsWork( k )
				if ( mapHackResult < 0 ) then 
					break
				elseif ( mapHackResult > 0 ) then
					if ( mapHackResult == 4 ) then
						radiusByScaleXC =  mini.radii[ mini.zoom + 1 ] * mapScales[ "TerraceOfLight" ][ "x" ][ mini.zoom + 1 ]
						radiusByScaleYC =  mini.radii[ mini.zoom + 1 ] * mapScales[ "TerraceOfLight" ][ "y" ][ mini.zoom + 1 ]
					else
						radiusByScaleXC =  mini.radii[ mini.zoom + 1 ] * mapScales[ "Inside" ][ "x" ][ mini.zoom + 1 ]
						radiusByScaleYC =  mini.radii[ mini.zoom + 1 ] * mapScales[ "Inside" ][ "y" ][ mini.zoom + 1 ]
					end
				else
					radiusByScaleXC =  mini.radii[ mini.zoom + 1 ] * mapScales[ k ][ "x" ][ mini.zoom + 1 ]
					radiusByScaleYC =  mini.radii[ mini.zoom + 1 ] * mapScales[ k ][ "y" ][ mini.zoom + 1 ]
				end
				for i = 1, v do
					local pointerClass, doClass = mapClass[ k ][ tostring( i ) ], false
					miniClassFrame[ i ]:ClearAllPoints()
					if ( mapHackResult > 0 ) then 
						if pointerClass.mhr and ( pointerClass.mhr == mapHackResult ) then
							doClass = true
						end
					else
						doClass = true
					end
					if ( doClass == true ) then
						if ( pointerClass.tbc ~= nil ) then
							if ( ( vanilla == true ) and ( pointerClass.tbc == true ) ) or
									( ( tbc == true ) and ( pointerClass.tbc == false ) ) then
								doClass = false
							end
						end
					end
					if ( doClass == true ) then
						miniClassFrame[ i ]:SetPoint( "CENTER", Minimap, "CENTER", AdjustMinimapCoordinates( 
										pointerClass.x, pointerClass.y, radiusByScaleXC, radiusByScaleYC ) )
						if pointerClass.class then
							miniClassFrame[ i ]:SetTexture( textures.class )
							miniClassFrame[ i ]:SetTexCoord( unpack( classCoords[ pointerClass.class ] ) )
							miniClassFrame[ i ]:SetHeight( mini.size )
							miniClassFrame[ i ]:SetWidth( mini.size )
						else
							miniClassFrame[ i ]:SetTexture( textures.arrow )
							local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = RotationCorners( pointerClass.rotateDegrees )
							miniClassFrame[ i ]:SetTexCoord( ULx, ULy, LLx, LLy, URx, URy, LRx, LRy )
							miniClassFrame[ i ]:SetHeight( mini.size * 1.8 )
							miniClassFrame[ i ]:SetWidth( mini.size * 1.8 )
						end
						miniClassFrame[ i ]:SetAlpha( 1 )
						validArea = true
					else
						miniClassFrame[ i ]:SetAlpha(0)
					end
				end
				numberOfIconsInZone = v
				break
			end
		end
	end

	if ( mapHackResult < 0 ) or ( numberOfIconsInZone == 0 ) then 
		for i = 1, maxMiniClass do
			miniClassFrame[ i ]:ClearAllPoints()		-- not clickable / no tooltips
			miniClassFrame[ i ]:SetAlpha( 0 )			-- hide the icons
		end
	elseif ( numberOfIconsInZone < maxMiniClass ) then 
		for i = numberOfIconsInZone + 1, maxMiniClass do
			miniClassFrame[ i ]:ClearAllPoints()		-- not clickable / no tooltips
			miniClassFrame[ i ]:SetAlpha( 0 )			-- hide the icons
		end
	end
	
	numberOfIconsInZone = 0
	
	if ( mapHackResult >= 0 ) and ( TrainerDB.hideProfIcons ~= "y" ) then
		radiusByScaleXC, radiusByScaleYC = 0, 0
		for k,v in pairs( numMapProf ) do
			local radiusByScaleXP, radiusByScaleYP = 0, 0
			if ( mini.zoneText == L[ k ] ) then
				if ( mapHackResult > 0 ) then
					if ( mapHackResult == 4 ) then
						radiusByScaleXP =  mini.radii[ mini.zoom + 1 ] * mapScales[ "TerraceOfLight" ][ "x" ][ mini.zoom + 1 ]
						radiusByScaleYP =  mini.radii[ mini.zoom + 1 ] * mapScales[ "TerraceOfLight" ][ "y" ][ mini.zoom + 1 ]
					else
						radiusByScaleXP =  mini.radii[ mini.zoom + 1 ] * mapScales[ "Inside" ][ "x" ][ mini.zoom + 1 ]
						radiusByScaleYP =  mini.radii[ mini.zoom + 1 ] * mapScales[ "Inside" ][ "y" ][ mini.zoom + 1 ]
					end
				else
					radiusByScaleXP =  mini.radii[ mini.zoom + 1 ] * mapScales[ k ][ "x" ][ mini.zoom + 1 ]
					radiusByScaleYP =  mini.radii[ mini.zoom + 1 ] * mapScales[ k ][ "y" ][ mini.zoom + 1 ]
				end
				for i = 1, v do
					local pointerProf, doProf = mapProf[ k ][ tostring( i ) ], false
					miniProfFrame[ i ]:ClearAllPoints()
					if ( mapHackResult > 0 ) then 
						if pointerProf.mhr and ( pointerProf.mhr == mapHackResult ) then
							doProf = true
						end
					else
						doProf = true
					end
					if ( doProf == true ) then
						if ( pointerProf.tbc ~= nil ) then
							if ( ( vanilla == true ) and ( pointerProf.tbc == true ) ) or
									( ( tbc == true ) and ( pointerProf.tbc == false ) ) then
								doProf = false
							end
						end
					end
					if ( doProf == true ) then
						miniProfFrame[ i ]:SetPoint( "CENTER", Minimap, "CENTER", AdjustMinimapCoordinates( 
										pointerProf.x, pointerProf.y, radiusByScaleXP, radiusByScaleYP ) )
						if pointerProf.prof ~= nil then
							miniProfFrame[ i ]:SetTexture( textures.prof )
							miniProfFrame[ i ]:SetTexCoord( unpack( profCoords[ pointerProf.prof ] ) )
							miniProfFrame[ i ]:SetHeight( mini.size )
							miniProfFrame[ i ]:SetWidth( mini.size )
						else
							miniProfFrame[ i ]:SetTexture( textures.arrow )
							local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = RotationCorners( pointerProf.rotateDegrees )
							miniProfFrame[ i ]:SetTexCoord( ULx, ULy, LLx, LLy, URx, URy, LRx, LRy )
							miniProfFrame[ i ]:SetHeight( mini.size * 1.8 )
							miniProfFrame[ i ]:SetWidth( mini.size * 1.8 )
						end
						miniProfFrame[ i ]:SetAlpha( 1 )
						validArea = true
					else
						miniProfFrame[ i ]:SetAlpha(0)
					end
				end
				numberOfIconsInZone = v
				break
			end
		end
	end

	if ( mapHackResult < 0 ) or ( numberOfIconsInZone == 0 ) then 
		for i = 1, maxMiniProf do
			miniProfFrame[ i ]:ClearAllPoints()			-- not clickable / no tooltips
			miniProfFrame[ i ]:SetAlpha( 0 )			-- hide the icons
		end
	elseif ( numberOfIconsInZone < maxMiniProf ) then 
		for i = numberOfIconsInZone + 1, maxMiniProf do
			miniProfFrame[ i ]:ClearAllPoints()			-- not clickable / no tooltips
			miniProfFrame[ i ]:SetAlpha( 0 )			-- hide the icons
		end
	end
	
	-- Minimap Tooltips	

	local mouseOver = false

	if ( mini.entered == true ) and ( validArea == true ) then

		-- In testing I noticed that the player arrow is not exactly centred. x = 2.22, y = 4.95 seemed approximate fudge factors
		-- The icon's (0,0) point seems to be the TOPRIGHT. Ultimately, player position was not relevant here. Just noting

		local scale = Minimap:GetEffectiveScale()
		local cursorX, cursorY = GetCursorPosition()
		cursorX, cursorY = cursorX / scale - Minimap:GetLeft() - mini.width / 2, cursorY / scale - mini.height / 2 - Minimap:GetBottom()
		local pixels = 7.5 * TrainerDB.iconSize / 21.5				-- Seems about right, even if ever so slightly off the visible centre
		
		for k,v in pairs( numMapClass ) do
			if ( mini.zoneText == L[ k ] ) then
				for i = 1, v do
					local _,_,_,iconX,iconY = miniClassFrame[ i ]:GetPoint()
					if iconX and iconY then
						local hypotenuse = sqrt( ( iconX - cursorX )^2 + ( iconY - cursorY )^2 )
						if hypotenuse < pixels then
							GameTooltip:SetOwner( UIParent, "ANCHOR_CURSOR" )
							local pointerClass = mapClass[ k ][ tostring( i ) ]
							GameTooltip:SetText( pc_colour_Prefix.. pointerClass.title )
							if pointerClass.shop then
								GameTooltip:AddLine( pc_colour_Highlight.. pointerClass.shop )
							end
							if pointerClass.trainers then
								for m,n in pairs( pointerClass.trainers ) do
									GameTooltip:AddDoubleLine( pc_colour_PlainText.. npc[ m ], pc_colour_PlainText.. n )
								end
							end
							if pointerClass.note then
								GameTooltip:AddLine( pc_colour_Highlight.. pointerClass.note )
							end
							GameTooltip:Show()
							mouseOver, mini.tooltipShowing = true, true
							break
						end
					end
				end
				break
			end
		end

		if ( mouseOver == true ) then return end

		for k,v in pairs( numMapProf ) do
			if ( mini.zoneText == L[ k ] ) then
				for i = 1, v do
					local _,_,_,iconX,iconY = miniProfFrame[ i ]:GetPoint()
					if iconX and iconY then
						local hypotenuse = sqrt( ( iconX - cursorX )^2 + ( iconY - cursorY )^2 )
						if hypotenuse < pixels then
							GameTooltip:SetOwner( UIParent, "ANCHOR_CURSOR" )
							local pointerProf = mapProf[ k ][ tostring( i ) ]
							GameTooltip:SetText( pc_colour_Prefix.. pointerProf.title )
							if pointerProf.shop then
								GameTooltip:AddLine( pc_colour_Highlight.. pointerProf.shop )
							end
							if pointerProf.trainers then
								for m,n in pairs( pointerProf.trainers ) do
									GameTooltip:AddDoubleLine( pc_colour_PlainText.. npc[ m ], pc_colour_PlainText.. n )
								end
							end
							if pointerProf.note then
								GameTooltip:AddLine( pc_colour_Highlight.. pointerProf.note )
							end
							GameTooltip:Show()
							mouseOver, mini.tooltipShowing = true, true
							break
						end
					end
				end
				break
			end
		end
	end

	if ( mouseOver == false ) and ( mini.tooltipShowing == true ) then
		GameTooltip:Hide()
		mini.tooltipShowing = false
	end
end

eventFrame:SetScript( "OnUpdate", OnUpdateHandler )

--------------------------------------------------------------------------------------------------------------------------------------------
--
--		Slash Commands
--		==============
--
--------------------------------------------------------------------------------------------------------------------------------------------

SLASH_Trainer1, SLASH_Trainer2, SLASH_Trainer3 = "/trainer", "/choochoo", "/chugga"

SlashCmdList[ "Trainer" ] = function( options )

	local options1, secondParm;
	for v in gmatch( options, "(%S+)" ) do
		v = lower( v )
		if not options1 then
			options1 = sub( v,1,1 )
		else
			secondParm = sub( v,1,2 )
			break
		end
	end
	
	if ( buildVersionMajor > "2" ) and ( options1 ~= "v") then options1 = nil end

	if not options1 or ( options1 == "?" ) then
		printPC( pc_colour_Highlight .. L["Commands"].. ":\n"..
			pc_colour_Highlight.. "s n".. pc_colour_PlainText.. " = ".. L["Icon size"].. ". ".. L["10 to 50"].. "\n"..
			pc_colour_Highlight.. "c".. pc_colour_PlainText.. " = ".. L["Class icons"].. ". (".. L["Toggle"].. ")\n"..
			pc_colour_Highlight.. "p".. pc_colour_PlainText.. " = ".. L["Profession icons"].. ". (".. L["Toggle"].. ")\n"..
			pc_colour_Highlight.. "w".. pc_colour_PlainText.. " = ".. L["World Map icons"].. ". (".. L["Toggle"].. ")\n"..
			pc_colour_Highlight.. "m".. pc_colour_PlainText.. " = ".. L["Minimap icons"].. ". (".. L["Toggle"].. ")\n"..
			pc_colour_Highlight.. "v".. pc_colour_PlainText.. " = ".. L["Show the version number"].. "\n")
		if ( buildVersionMajor > "2" ) then
			printPC( pc_colour_Highlight.. L["Requires The Burning Crusade (2.4.3) or lower"] )
		end

	elseif ( options1 == "s" ) then
		local parm = tonumber( secondParm )
		if parm then
			if ( parm >= 10 ) and ( parm <= 50 ) then
				TrainerDB.iconSize = parm
				for k,v in pairs( numMapClass ) do
					for i = 1, v do	
						if mapClass[ k ][ tostring( i ) ].class then
							mapClassFrame[ k ][ i ]:SetHeight( TrainerDB.iconSize )
							mapClassFrame[ k ][ i ]:SetWidth( TrainerDB.iconSize )
						elseif mapClass[ k ][ tostring( i ) ].rotateDegrees then
							mapClassFrame[ k ][ i ]:SetHeight( TrainerDB.iconSize * 1.8 )
							mapClassFrame[ k ][ i ]:SetWidth( TrainerDB.iconSize * 1.8 )
						end
					end
				end
				for k,v in pairs( numMapProf ) do
					for i = 1, v do	
						if mapProf[ k ][ tostring( i ) ].prof then
							mapProfFrame[ k ][ i ]:SetHeight( TrainerDB.iconSize )
							mapProfFrame[ k ][ i ]:SetWidth( TrainerDB.iconSize )
						elseif mapProf[ k ][ tostring( i ) ].rotateDegrees then
							mapProfFrame[ k ][ i ]:SetHeight( TrainerDB.iconSize * 1.8 )
							mapProfFrame[ k ][ i ]:SetWidth( TrainerDB.iconSize * 1.8 )
						end
					end
				end
			end
		end
		printPC( "/trainer s = ".. pc_colour_Highlight.. TrainerDB.iconSize )
		if secondParm and ( secondParm == "?" ) then
			printPC( "("..L["Default"].. " = 15)" )
		end

	elseif ( options1 == "c" ) then
		if not secondParm then
			TrainerDB.hideClassIcons = ( TrainerDB.hideClassIcons == "y" ) and "n" or "y"
			if ( TrainerDB.hideClassIcons == "y" ) then
				for i = 1, maxMiniClass do
					miniClassFrame[ i ]:ClearAllPoints()		-- not clickable / no tooltips
					miniClassFrame[ i ]:SetAlpha( 0 )			-- hide the icons
				end
			end
		end
		printPC( "/trainer c = ".. pc_colour_Highlight.. ( ( TrainerDB.hideClassIcons == "y" ) and L["Hide"] or L["Show"] ) )
		if secondParm then
			printPC( "("..L["Default"].. " = ".. L["Show"].. ")" )
		end
		ShowOnWorldMap()

	elseif ( options1 == "p" ) then
		if not secondParm then
			TrainerDB.hideProfIcons = ( TrainerDB.hideProfIcons == "y" ) and "n" or "y"
			if ( TrainerDB.hideProfIcons == "y" ) then
				for i = 1, maxMiniProf do
					miniProfFrame[ i ]:ClearAllPoints()			-- not clickable / no tooltips
					miniProfFrame[ i ]:SetAlpha( 0 )			-- hide the icons
				end
			end
		end
		printPC( "/trainer p = ".. pc_colour_Highlight.. ( ( TrainerDB.hideProfIcons == "y" ) and L["Hide"] or L["Show"] ) )
		if secondParm then
			printPC( "("..L["Default"].. " = ".. L["Show"].. ")" )
		end
		ShowOnWorldMap()

	elseif ( options1 == "w" ) then
		if not secondParm then
			TrainerDB.hideWorldMapIcons = ( TrainerDB.hideWorldMapIcons == "y" ) and "n" or "y"
		end
		printPC( "/trainer w = ".. pc_colour_Highlight.. ( ( TrainerDB.hideWorldMapIcons == "y" ) and L["Hide"] or L["Show"] ) )
		if secondParm then
			printPC( "("..L["Default"].. " = ".. L["Show"].. ")" )
		end
		ShowOnWorldMap()

	elseif ( options1 == "m" ) then
		if not secondParm then
			TrainerDB.hideMinimapIcons = ( TrainerDB.hideMinimapIcons == "y" ) and "n" or "y"
			if ( TrainerDB.hideMinimapIcons == "y" ) then
				for i = 1, maxMiniClass do
					miniClassFrame[ i ]:ClearAllPoints()		-- not clickable / no tooltips
					miniClassFrame[ i ]:SetAlpha( 0 )			-- hide the icons
				end
				for i = 1, maxMiniProf do
					miniProfFrame[ i ]:ClearAllPoints()			-- not clickable / no tooltips
					miniProfFrame[ i ]:SetAlpha( 0 )			-- hide the icons
				end
			end
		end
		printPC( "/trainer m = ".. pc_colour_Highlight.. ( ( TrainerDB.hideMinimapIcons == "y" ) and L["Hide"] or L["Show"] ) )
		if secondParm then
			printPC( "("..L["Default"].. " = ".. L["Show"].. ")" )
		end
		ShowOnWorldMap()

	elseif ( options1 == "v" ) then
		local version = GetAddOnMetadata( addonName, "Version" )
		printPC( L["Version: "].. pc_colour_Highlight.. version )

	-- Easter Eggs. Enjoy!

	elseif ( options1 == "z" ) then
		DEFAULT_CHAT_FRAME:AddMessage( "\124cFFFF0000Lord Victor Nefarius yells: In this world where time is your enemy, it is "..
			"my greatest ally. This grand game of life that you think you play in fact plays you. To that I say... Let the "..
			"games begin!" )
		PlaySoundFile( "Sound\\Creature\\LordVictorNefarius\\LordVictorNefariusGames.wav" )
	end
end