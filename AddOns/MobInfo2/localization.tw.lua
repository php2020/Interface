--   
-- Localisation for MobInfo2
--




if ( GetLocale() == "zhCN" ) then

MI_DESCRIPTION = "增加怪物的详细相关信息到提示讯息视窗，并且在目标状态栏显示估计的生命/法力资料";

MI2_SpellSchools = { ["奥术"]="ar", ["火焰"]="fi", ["冰霜"]="fr", ["暗影"]="sh", ["神圣"]="ho", ["自然"]="na" } 


MI_TXT_GOLD   = "金";
MI_TXT_SILVER = "银";
MI_TXT_COPPER = "铜";

MI_TXT_CONFIG_TITLE		= "MobInfo 2 选项";
MI_TXT_WELCOME          = "欢迎使用 MobInfo 2！";
MI_TXT_OPEN				= "开启";
MI_TXT_CLASS			= "职业";
MI_TXT_HEALTH			= "生命值";
MI_TXT_MANA				= "法力值";
MI_TXT_XP				= "经验";
MI_TXT_KILLS			= "杀死数";
MI_TXT_DAMAGE			= "伤害 + [DPS]";
MI_TXT_TIMES_LOOTED		= "拾取次数";
MI_TXT_EMPTY_LOOTS		= "空身取数";
MI_TXT_TO_LEVEL			= "升级还需 # 个";
MI_TXT_QUALITY			= "质量";
MI_TXT_CLOTH_DROP      = "布料掉落";
MI_TXT_COIN_DROP       = "平均金钱掉落";
MI_TEXT_ITEM_VALUE     = "平均物品价值";
MI_TXT_MOB_VALUE       = "怪物总价值";
MI_TXT_COMBINED			= "已合并等级：";
MI_TXT_MOB_DB_SIZE		= "MobInfo数据库大小：";
MI_TXT_HEALTH_DB_SIZE	= "生命值数据库大小：";
MI_TXT_PLAYER_DB_SIZE	= "玩家生命值数据库大小：";
MI_TXT_ITEM_DB_SIZE		= "物品数据库大小：";
MI_TXT_CUR_TARGET		= "目前目标：";
MI_TXT_MH_DISABLED		= "MobInfo 警告：发现MobHealth插件. 本插件内建的MobHealth功能已停用，请删除独立的MobHealth插件以启用本插件的全部功能。";
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n 单独停用MobHealth并不会失去资料。\n\n好处是：血量/魔法位置可调整，并可调整显示字体和大小");
MI_TXT_CLR_ALL_CONFIRM	= "你确认要执行以下删除动作吗？";
MI_TXT_SEARCH_LEVEL		= "怪物等级：";
MI_TXT_SEARCH_MOBTYPE	= "怪物类型：";
MI_TXT_SEARCH_LOOTS		= "怪物已拾取：";
MI_TXT_TRIM_DOWN_CONFIRM = "警告：这是一个直接永久性的资料删除动作。你真的想删除没有被选取到的那些资料吗？"
MI_TXT_CLAM_MEAT		= "蚌肉"
MI_TXT_SHOWING			= "显示列表："
MI_TXT_DROPPED_BY		= "掉落："
MI_TXT_LOCATION			= "地点: "
MI_TXT_DEL_SEARCH_CONFIRM = "你是否真的要自数据库中，删除搜寻结果中的 %d 笔怪物的资料？"
MI_TXT_WRONG_LOC		= "错误：MobInfo数据库的语系和WOW程序本身的语系不一致。在解决这问题之前，MobInfo数据库是没有用的。"
MI_TXT_STATUS = "现状: "
MI_TXT_STATUS_ALREADY = "现状: <已导入的数据"
MI_TXT_STATUS_OLD = "现状: <导入数据库太旧，不能导入>"
MI_TXT_STATUS_WRONG = "现状: <导入数据库有错误的语言（地区）>"
MI_TXT_STATUS_AVAILABLE = " 可用于导入"
MI_TXT_STATUS_NOIMPORT = "现状: <没有导入数据>"
MI_TXT_MOBS = " 怪物"
MI_TXT_MOBS_1 = " 怪物:"
MI_TXT_HP_VALUES = " HP值"
MI_TXT_MANA = " 法力值"
MI_TXT_HP = "血量    "
MI_TXT_LEVEL = " 等级"
MI_TXT_XP = "经验    "
MI_TXT_KTL = " 升级    "
MI_TXT_DMG = "伤害 "
MI_TXT_DPS = " 秒伤   "
MI_TXT_KILLS = "击杀  "
MI_TXT_LOOTS = " 战利品"
MI_TXT_CL = "CL     "
MI_TXT_EL = " EL      "
MI_TXT_VAL = "价值    "
MI_TXT_COINS = " 金币"
MI_TXT_Q = "掉落品质      "
MI_TXT_DEBUG_INFO = "--------------  调试信息  --------------"
MI_TXT_DEBUG_DBG = "[DBG] "
MI_TXT_DEBUG_BI = "bi(基本信息)"
MI_TXT_DEBUG_QI = "qi(品质信息)"
MI_TXT_DEBUG_ML = "ml(怪物地点)"
MI_TXT_DEBUG_IL = "il(物品列表)"
MI_TXT_DEBUG_RE = "re(抗性)"
MI_TXT_DEBUG_CHAR_DATA = "(人物数据)"
MI_TXT_DEBUG_HP = "hp(血量数据)"
MI_TXT_IMMUN = "免疫:"
MI_TXT_RESIST = "抗性:"
MI_TXT_NEW_CORPSE = "存储新的尸体ID"
MI_TXT_LOOT_SLOT = "拾取: 槽"
MI_TXT_Q_NAME = "名字"
MI_TXT_Q_ID = "ID"
MI_TXT_Q_q = "q"
MI_TXT_REC_NEW_DPS = "记录新的dps: idx"
MI_TXT_NEW_DPS = "新的dps"
MI_TXT_REC_NEW_MIN_DMG = "记录新的最低伤害 "
MI_TXT_REC_NEW_DMG_FOR = " 为 "
MI_TXT_REC_NEW_DMG_OLD = "旧的"
MI_TXT_REC_NEW_MAX_DMG = "记录新的最高伤害 "
MI_TXT_REC_KILL_MOB = "记录新的击杀: 怪物"
MI_TXT_REC_KILL_MOB_KILLS = "击杀"
MI_TXT_REC_KILL_MOB_XP = "经验"
MI_TXT_REC_LOC = "记录地点"
MI_TXT_SLASH_VER = "v"
MI_TXT_SLASH_DAT_TARGET = "数据目标 "
MI_TXT_SLASH_DAT_DEL = " 已被删除"
MI_TXT_SLASH_DAT_DB_DEL = "数据库删除: "
MI_TXT_SLASH_DB_IMPORT = " 启动外部数据库导入 ...."
MI_TXT_SLASH_IMPORTED = " 导入 "
MI_TXT_SLASH_NEW_MOBS = " 新的怪物"
MI_TXT_SLASH_NEW_HP_VAL = " 新的血量值"
MI_TXT_SLASH_NEW_ITEMS = " 新的战利品"
MI_TXT_SLASH_UPD_DATA = " 更新数据 "
MI_TXT_SLASH_EXS_MOBS = " 现有的怪物"
MI_TXT_SLASH_NOT_UPD = " 没有更新数据 "
MI_TXT_SLASH_VERSION = " MobInfo-2 版本 "
MI_TXT_SLASH_USAGE = " 用法: 输入 /mobinfo2 或 /mi2 打开插件"
MI_TXT_SLASH_HELP = " 用于插件的帮助 "
MI_TXT_SLASH_OFF = "-关-"
MI_TXT_SLASH_ON = "-开-"
MI_TXT_SEARCH_DEL = "搜索结果中删除 : "
MI_TXT_SEARCH_MOBS = " 怪物"
MI_TXT_SEARCH_LVL = "  等级"
MI_TXT_EVENTS_NEW_TARGET = "新的目标: id"
MI_TXT_EVENTS_LAST = "最后的"
MI_TXT_EVENTS_NON_MOB = "非怪物拾取事件: action"
MI_TXT_EVENTS_TYPE = "类型"
MI_TXT_EVENTS_NO_XP = "无经验击杀: 怪物"
MI_TXT_EVENTS_KILL_XP = "有经验击杀事件: 怪物"
MI_TXT_EVENTS_XP = "经验"
MI_TXT_EVENTS_MI_VER = "MobInfo-2  v"
MI_TXT_EVENTS_MI_LOADED = "  已加载, 输入 /mi2 或 /mobinfo2 打开插件"
MI_TXT_CONVDROPRATE_CONVERTER = "掉落率转换: "
MI_TXT_CONVDROPRATE_MOBSFOUND = " 发现怪物掉落率数据,"
MI_TXT_CONVDROPRATE_NEWMOBSFOUND = " 添加到数据库中的新怪物,"
MI_TXT_CONVDROPRATE_EXISTINGMOBS = " 扩展现有的怪物,"
MI_TXT_CONVDROPRATE_PARTIALMOBS = " 怪物部分转换,"
MI_TXT_CONVDROPRATE_SKIPPEDITEMS = " 未知物品已跳过,"
MI_TXT_CONVDROPRATE_ADDEDITEMS = " 物品已添加到数据库,"
MI_TXT_CONVDROPRATE_CONVERSTART = "掉落率转换开始 ..."
MI_TXT_CONVDROPRATE_NOTFOUND = "掉落率数据库未发现"

MI2_CHATMSG_MONSTEREMOTE = "attempts to run away"

BINDING_HEADER_MI2HEADER	= "MobInfo 2"
BINDING_NAME_MI2CONFIG	= "开启MobInfo2选项"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipOptions"]     = "怪物提示讯息内容"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]      = "怪物血量选项"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]    = "数据库选项"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"] = "生命值"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]    = "法力值"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "搜寻选项"
MI2_FRAME_TEXTS["MI2_FrmSearchLevel"]		= "怪物等级"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "物品提示讯息选项"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "汇入外部资料"

--
-- This section defines all buttons in the options dialog
--   text : the text displayed on the button
--  help : the (short) one line help text for the button
--   info : additional multi line info text for button
--      info is displayed in the help tooltip below the "help" line
--      info is optional and can be omitted if not required
--

MI2_OPTIONS = {};

MI2_OPTIONS["MI2_OptSearchMinLevel"] = 
	{ text = "最小"; help = "搜寻怪物时的最小等级限制"; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] = 
	{ text = "最大"; help = "搜寻怪物时的最大等级限制(必须< 66)"; }

MI2_OPTIONS["MI2_OptSearchNormal"] = 
	{ text = "普通"; help = "在搜寻结果中包含普通怪物"; }

MI2_OPTIONS["MI2_OptSearchElite"] = 
	{ text = "精英"; help = "在搜寻结果中包含精英怪物"; }

MI2_OPTIONS["MI2_OptSearchBoss"] = 
	{ text = "首领"; help = "在搜寻结果中包含首领级别的怪物"; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] = 
	{ text = "最小"; help = "搜寻结果中的怪物必须被拾取的最小次数"; }

MI2_OPTIONS["MI2_OptSearchMobName"] = 
	{ text = "怪物名称"; help = "想要搜寻的怪物部分或者完整名称";
	info = '留空时不限定查找特定怪物\n输入"*"搜寻全部怪物'; }  

MI2_OPTIONS["MI2_OptSearchItemName"] = 
	{ text = "物品名称"; help = "想要搜寻的物品部分或者完整名称";
	info = '留空时搜寻所有物品名称'; }	

MI2_OPTIONS["MI2_OptSortByValue"] = 
	{ text = "按数值分类"; help = "分类搜寻结果按怪物值";
	info = '按你能够造成怪物伤害的值分类查找它们。'; }

MI2_OPTIONS["MI2_OptSortByItem"] = 
	{ text = "按物品数分类"; help = "分类搜寻结果按物品数列表";
	info = '按怪物掉落指定物品的多少分类查找到的怪物。'; }

MI2_OPTIONS["MI2_OptItemTooltip"] = 
	{ text = "物品信息栏显示掉落怪物"; help = "在物品的提示信息中，显示掉落该物品的怪物名称";
	info = "在提示信息中显示可掉落鼠标所指物品的所有怪物。\n每行显示该怪物掉落的物品数量及占总数的百分比。" }

MI2_OPTIONS["MI2_OptCompactMode"] = 
	{ text = "简洁模式"; help = "启动怪物提示信息的简洁模式，每行显示二个值";
	info = "简洁模式使用英文简写来显示相关信息。\n要禁止某行信息显示，需要同时禁止该行显示的所有信息。" }

MI2_OPTIONS["MI2_OptDisableMobInfo"] = 
	{ text = "停用怪物提示信息"; help = "停止在提示信息显示怪物信息";
	info = "停止所有MobInfo2插件提供的附加信息，包括怪物的相关信息和物品的相关信息。" }

MI2_OPTIONS["MI2_OptShowClass"] = 
  { text = "显示类型"; help = "显示怪物的类型信息"; }

MI2_OPTIONS["MI2_OptShowHealth"] = 
  { text = "生命值"; help = "显示怪物的生命值 (目前/最大)"; }

MI2_OPTIONS["MI2_OptShowMana"] = 
	{ text = "法力值"; help = "显示怪物的法力/狂暴/精力值(目前/最大)"; }

MI2_OPTIONS["MI2_OptShowXp"] = 
{ text = "经验"; help = "显示此怪物可得的经验值";
info = "这是最后打死此怪物时，给你的实际经验值。\n(灰色的怪物将不显示此数值)" }

MI2_OPTIONS["MI2_OptShowNo2lev"] = 
{ text = "升级所需数量"; help = "显示要杀几只此种怪物才能升级";
info = "计算还要杀几只同样的怪物可升级\n(灰色的怪物不显示此数字)" }

MI2_OPTIONS["MI2_OptShowDamage"] = 
  { text = "伤害/DPS"; help = "显示怪物的伤害值范围 (最小/最大)和DPS (每秒伤害值)"; 
    info = "伤害值范围和DPS是按每个玩家角色\n来单独计算和存储的.\nDPS信息更新较慢但是会随着每次战斗而增加." }

MI2_OPTIONS["MI2_OptShowCombined"] = 
  { text = "合并信息"; help = "在提示信息里面显示组合信息";
    info = "在提示信息里面显示一个信息\n显示合并模式已启动并显示\n不同等级中同一种怪的统计资料." }

MI2_OPTIONS["MI2_OptShowKills"] = 
  { text = "杀死数"; help = "显示你杀了多少个这样的怪物";
    info = "怪物杀死计数是按每个玩家角\n色来单独计算和存储的." }

MI2_OPTIONS["MI2_OptShowLoots"] = 
  { text = "拾取总数"; help = "显示怪物被拾取了多少次"; }

MI2_OPTIONS["MI2_OptShowCloth"] = 
  { text = "布掉落率"; help = "显示怪物的布料掉率"; }

MI2_OPTIONS["MI2_OptShowEmpty"] = 
  { text = "空拾取数"; help = "显示发现空身尸体的次数(次数/百分比)";
    info = "当你打开一个尸体但是没有任何\n战利品的时候这个数目会增加." }

MI2_OPTIONS["MI2_OptShowTotal"] = 
  { text = "怪物总值"; help = "显示怪物的平均总价值";
    info = "这个数值等于平均金钱数值+平均物\n品价值之和" }

MI2_OPTIONS["MI2_OptShowCoin"] = 
  { text = "平均金钱"; help = "显示每个该种怪物平均掉落的金钱数目";
    info = "掉落的金钱总数除以拾取\n次数，如果为0则不显示" }

MI2_OPTIONS["MI2_OptShowIV"] = 
  { text = "平均物品价值"; help = "显示每个该种怪物掉落物品的平均价值";
    info = "掉落物品的价值总量除以\n拾取次数，如果为0则不显示" }

MI2_OPTIONS["MI2_OptShowQuality"] = 
  { text = "战利品质量"; help = "显示战利品总数和粗劣度百分比";
    info = "按掉落物品的质量，来显示杀死怪物获得的战利品数目。\n没有掉落过物品的类别将不显示。\n百分比表示：该类物品从该怪物掉落的机率。" }

MI2_OPTIONS["MI2_OptShowLocation"] = 
{ text = "显示地点"; help = "显示在哪里可以找到此种怪物";
info = "要使本功能能运作，必需开启记录地点的选项。"; }

MI2_OPTIONS["MI2_OptShowItems"] = 
	{ text = "显示拾取物品详细信息"; help = "显示所有拾取物品名称和数量";
	info = "要使这个选项起作用，必须开启记录拾取物品资料选项"; }

MI2_OPTIONS["MI2_OptShowClothSkin"] = 
{ text = "布和皮舍取记录"; help = "显示布和皮的名称和数量";
info = "记录舍取物品的选项必须开启，此功能才能运作"; }

MI2_OPTIONS["MI2_OptShowBlankLines"] = 
  { text = "显示空行"; help = "在提示信息里面显示一条空行";
    info = "在提示信息里面通过显示\n空行来分段，以提高可读性" }
    
MI2_OPTIONS["MI2_OptShowResists"] = 
{ text = "抵抗和免疫"; help = "在提示中显示抵抗和免疫";
info = "在提示中，显示目标怪物已记录对各种类型的法术的抵抗和免疫之相关资料。" }    

MI2_OPTIONS["MI2_OptCombinedMode"] = 
  { text = "整合相同怪物"; help = "对同样名字的怪物进行整合";
    info = "整合模式会计算相同名字但不同等级的怪物.\n启用后将在提示信息中显示一个标志" }

MI2_OPTIONS["MI2_OptKeypressMode"] = 
  { text = "按住ALT显示怪物信息"; help = "只有按下ALT才会在提示框显示怪物信息"; }

MI2_OPTIONS["MI2_OptItemFilter"] = 
	{ text = "拾取物品过滤"; help = "设置提示信息里显示的拾取物品的过滤条件";
	info = "只在提示信息中显示那些包含过滤文本的物品。\n例如输入'布'将只显示物品名称包含'布'的物品。\n不输入任何文字查看所有物品。" }

MI2_OPTIONS["MI2_OptSavePlayerHp"] = 
  { text = "永久储存玩家生命值"; help = "永久储存在PVP战斗中获得的玩家生命值资料。";
    info = "一般情况下PVP战斗结束\n后玩家生命值资料将被丢弃，这\n个选项允许你记录该资料。" }

MI2_OPTIONS["MI2_OptAllOn"] = 
  { text = "显示全开"; help = "将所有的显示选项打开"; }

MI2_OPTIONS["MI2_OptAllOff"] = 
  { text = "显示全关"; help = "将所有的显示选项关闭"; }

MI2_OPTIONS["MI2_OptMinimal"] = 
  { text = "最少讯息"; help = "显示最少量但最有用的怪物信息"; }

MI2_OPTIONS["MI2_OptDefault"] = 
  { text = "预设"; help = "显示预设的怪物信息"; }

MI2_OPTIONS["MI2_OptBtnDone"] = 
  { text = "完成"; help = "关闭 MobInfo 选项对话方块"; }

MI2_OPTIONS["MI2_OptStableMax"] = 
  { text = "显示稳定的生命最大值"; help = "在目标框显示稳定的最大生命值";
    info = "此选项开启以后，在一场\n战斗中怪物的估计最大生命值不\n会变化，新估计的数值将在\n下一场战斗时显示出来"; }

MI2_OPTIONS["MI2_OptTargetHealth"] = 
  { text = "显示生命值"; help = "在目标框显示生命值"; }

MI2_OPTIONS["MI2_OptTargetMana"] = 
  { text = "显示法力值"; help = "在目标框显示法力值"; }

MI2_OPTIONS["MI2_OptHealthPercent"] = 
  { text = "显示百分比"; help = "在目标框显示生命值百分比"; }

MI2_OPTIONS["MI2_OptManaPercent"] = 
  { text = "显示百分比"; help = "在目标框显示法力值百分比"; }

MI2_OPTIONS["MI2_OptHealthPosX"] = 
  { text = "水平位置"; help = "调整生命值的水平位置"; }

MI2_OPTIONS["MI2_OptHealthPosY"] = 
  { text = "垂直位置"; help = "调整生命值的垂直位置"; }

MI2_OPTIONS["MI2_OptManaPosX"] = 
  { text = "水平位置"; help = "调整法力值的水平位置"; }

MI2_OPTIONS["MI2_OptManaPosY"] = 
  { text = "垂直位置"; help = "调整法力值的垂直位置"; }

MI2_OPTIONS["MI2_OptTargetFont"] = 
	{ text = "字体"; help = "设定生命/法力值的显示字体";
	  choice1= "数值字体"; choice2="游戏字体"; choice3="物品信息字体" }

MI2_OPTIONS["MI2_OptTargetFontSize"] = 
	{ text = "字体大小"; help = "设定生命/法力值的显示字体大小。"; }

MI2_OPTIONS["MI2_OptClearTarget"] = 
  { text = "清除目前目标资料"; help = "清除目前目标的资料。"; }

MI2_OPTIONS["MI2_OptClearMobDb"] = 
	{ text = "清除怪物资料"; help = "清除全部怪物信息资料。"; }

MI2_OPTIONS["MI2_OptClearHealthDb"] = 
	{ text = "清除生命值资料"; help = "清除全部怪物生命值资料。"; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] = 
	{ text = "清除玩家资料"; help = "清除全部玩家生命值资料。"; }

MI2_OPTIONS["MI2_OptSaveItems"] = 
	{ text = "记录以下质量的掉落物品资料:"; help = "开启后记录所有MobInfo2所能记的怪物相关资料。";
	info = "你可以选择想记录的物品的质量等级。"; }

MI2_OPTIONS["MI2_OptSaveBasicInfo"] = 
	{ text = "记录基本怪物信息"; help = "记录基本怪物的相关信息。";
	info = "基本怪物信息包括：经验值、怪物类型、计算：拾取、空拾取、布、金钱、物品的价值"; }

MI2_OPTIONS["MI2_OptSaveCharData"] = 
	{ text = "记录角色相关的怪物资料"; help = "开启后记录所有和玩家角色有关的怪物信息。";
	info = "开启或关闭保存以下资料：\n击杀次数、最大／最小伤害、DPS (每秒伤害值)\n\n这些资料将依玩家角色分开储存。\n这几个资料只能同时设定为『储存』或『不储存』。"; }

MI2_OPTIONS["MI2_OptSaveLocation"] = 
{ text = "记录地点资料"; help = "记录在哪些区域地点和坐标可以找到怪物。" }

MI2_OPTIONS["MI2_OptSaveResist"] = 
{ text = "记录抵抗和免疫资料"; help = "记录怪物对各种性质的法术的抵抗和免疫的资料。";
info = "记录怪物对各种属性法术的抵抗和免疫的统计资料。"; }

MI2_OPTIONS["MI2_OptItemsQuality"] = 
	{ text = ""; cmnd = "itemsquality";  help = "记录指定质量(含)更好的物品详细信息。";
	  choice1 = "灰色以及更好"; choice2="白色以及更好"; choice3="绿色以及更好" }

MI2_OPTIONS["MI2_OptTrimDownMobData"] = 
	{ text = "最佳化怪物数据库大小"; help = "移除过剩的资料最佳化怪物数据库大小。";
	  info = "过剩的资料是指数据库里未被设定为需要记录的全部资料。"; }

MI2_OPTIONS["MI2_OptImportMobData"] = 
{ text = "开始汇入"; help = "汇入外部资料到你自己的怪物数据库";
info = "注意：请仔细详读汇入步骤的指示！\n一定要在汇入前，先备份自己的数据库，以免造成资料永久遗失！"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] = 
{ text = "删除"; help = "自数据库中，删除所有在搜寻结果中的怪物资料。";
info = "警告：本步骤是没办法复原的，\n使用前请小心！\n建议在删除这些资料前，先备份自己的数据库。"; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] = 
{ text = "只汇入目前还未知的怪物资料"; help = "汇入目前在你的数据库中，还没有记录的资料";
info = "开启这个选项可以预防现在已存在的资料被修改覆盖掉，\n只有目前未知(新的)资料会汇入数据库。\n如此可以确保原资料的一致性。"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab1"] = 
	{ text = "提示信息选项"; help = "设置在提示信息里面显示的怪物信息选项"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab2"] = 
	{ text = "生命/法力值"; help = "设置目标框中显示 生命/法力值 的选项"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab3"] = 
	{ text = "数据库"; help = "数据库管理选项"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab4"] = 
	{ text = "搜寻"; help = "搜寻数据库"; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] = 
	{ text = "怪物列表"; help = ""; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] = 
	{ text = "物品列表"; help = ""; }


end;

