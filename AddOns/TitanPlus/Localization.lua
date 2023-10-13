-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- |TitanPanel增强插件
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Copy Right Belong To UI's Authors
-- Translate&Improved by wangmars
-- updated by Windrunner

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding TitanEmoteMenu v1.0
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_EMOTEMENU_MENU_BARTEXT = "表情库";
TITAN_EMOTEMENU_MENU_TEXT = "表情";
TITAN_EMOTEMENU_MENU_TEXTRIGHT = "表情(右侧)";
	
TITAN_EMOTEMENU_CAT_FRIENDLY = "Friendly Emotes";
TITAN_EMOTEMENU_CAT_AGGRESSIVE = "Aggressive Emotes";
TITAN_EMOTEMENU_CAT_NEUTRAL = "Neutral Emotes";
TITAN_EMOTEMENU_CAT_OTHER = "Other Emotes";

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan ExitGame v0.04
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎

TITANEXITGAME_ARTWORK_PATH = "Interface\\AddOns\\TitanPlus\\Artwork\\";

TITAN_EXITGAME_TOOLTIP = "离开游戏";
TITAN_EXITGAME_TOOLTIP_HINT1 = "左键点击打开离开游戏/登出服务器菜单";
TITAN_EXITGAME_MENU_TEXT = "离开游戏(Titan ExitGame)";
LOG_OUT = "返回人物界面";
EXIT_MENU = "取消";

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan ReLoadUI v1.02
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎

TITANRELOAD_ARTWORK_PATH = "Interface\\AddOns\\TitanPlus\\Artwork\\";
TITAN_RELOADUI_TOOLTIP = "插件重载控制";
TITAN_RELOADUI_TOOLTIP_HINT1 = "提示: 左键点击重新载入所有插件！";
TITAN_RELOADUI_MENU_TEXT = "UI重载";

--◎◎◎◎◎◎◎◎◎◎◎◎
--Adding TitanSkills v0.07
--◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_SKILLS_VERSION = "0.07";

TITAN_SKILLS_MENU_TEXT = "技能";
TITAN_SKILLS_RIGHT_MENU_TEXT = "技能 (右侧)";
TITAN_SKILLS_BUTTON_LABEL = "技能";
TITAN_SKILLS_BUTTON_TEXT = "%s";
TITAN_SKILLS_TOOLTIP = "技能信息";

TITAN_SKILLS_ABOUT_TEXT = "关于";
TITAN_SKILLS_ABOUT_POPUP_TEXT = TitanUtils_GetGreenText("技能信息").."\n"..TitanUtils_GetNormalText("版本: ")..TitanUtils_GetHighlightText(TITAN_SKILLS_VERSION).."\n"..TitanUtils_GetNormalText("作者: ")..TitanUtils_GetHighlightText("Corgi");

TITAN_SKILLS_SECONDARY_TEXT = "辅助技能";
TITAN_SKILLS_WEAPON_TEXT = "武器技能";
TITAN_SKILLS_CLASS_TEXT = "专业";

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding TitanDurability v1.05
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_DURABILITY_MENU_TEXT = "耐久";
TITAN_DURABILITY_MENU_ITEMS = "显示物品详情";
TITAN_DURABILITY_MENU_GUY = "隐藏耐久图样";
TITAN_DURABILITY_NUDE = "你全身赤裸！";

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding TitanItemBonuses v0.9
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎
-- general
TITAN_ITEMBONUSES_TEXT = "装备属性";
TITAN_ITEMBONUSES_DISPLAY_NONE = "关闭状态栏显示";
TITAN_ITEMBONUSES_SHORTDISPLAY = "显示缩写";
		
TITAN_ITEMBONUSES_CAT_ATT = "属性";
TITAN_ITEMBONUSES_CAT_RES = "抗性";
TITAN_ITEMBONUSES_CAT_SKILL = "技能";
TITAN_ITEMBONUSES_CAT_BON = "近战/远程";
TITAN_ITEMBONUSES_CAT_SBON = "法术";
TITAN_ITEMBONUSES_CAT_OBON = "生命/法力";
			
-- bonus names
TITAN_ITEMBONUSES_STR = "力量";
TITAN_ITEMBONUSES_AGI = "敏捷";
TITAN_ITEMBONUSES_STA = "耐力";
TITAN_ITEMBONUSES_INT = "智力";
TITAN_ITEMBONUSES_SPI = "精神";
TITAN_ITEMBONUSES_ARMOR = "护甲";
		
TITAN_ITEMBONUSES_ARCANERES = "奥术抗性";	
TITAN_ITEMBONUSES_FIRERES	= "火焰抗性";
TITAN_ITEMBONUSES_NATURERES = "自然抗性";
TITAN_ITEMBONUSES_FROSTRES	= "冰霜抗性";
TITAN_ITEMBONUSES_SHADOWRES	= "阴影抗性";
		
TITAN_ITEMBONUSES_FISHING	= "钓鱼";
TITAN_ITEMBONUSES_MINING	= "采矿";
TITAN_ITEMBONUSES_HERBALISM	= "草药";
TITAN_ITEMBONUSES_SKINNING	= "剥皮";
TITAN_ITEMBONUSES_DEFENSE	= "防御";
			
TITAN_ITEMBONUSES_BLOCK = "格挡";
TITAN_ITEMBONUSES_DODGE = "躲闪";
TITAN_ITEMBONUSES_PARRY = "招架";
TITAN_ITEMBONUSES_ATTACKPOWER = "攻击强度";
TITAN_ITEMBONUSES_CRIT = "致命一击";
TITAN_ITEMBONUSES_RANGEDATTACKPOWER = "远程攻击强度";
TITAN_ITEMBONUSES_RANGEDCRIT = "远程致命一击";
TITAN_ITEMBONUSES_TOHIT = "命中率";
TITAN_ITEMBONUSES_DMG = "法术伤害";
TITAN_ITEMBONUSES_ARCANEDMG = "奥术伤害";
TITAN_ITEMBONUSES_FIREDMG = "火焰伤害";
TITAN_ITEMBONUSES_FROSTDMG = "冰霜伤害";
TITAN_ITEMBONUSES_HOLYDMG = "神圣伤害";
TITAN_ITEMBONUSES_NATUREDMG = "自然伤害";
TITAN_ITEMBONUSES_SHADOWDMG = "暗影伤害";
TITAN_ITEMBONUSES_SPELLCRIT = "法术致命一击";
TITAN_ITEMBONUSES_SPELLTOHIT = "法术命中率";
TITAN_ITEMBONUSES_HEAL = "治疗效果";
TITAN_ITEMBONUSES_HOLYCRIT = "神圣法术致命一击";
TITAN_ITEMBONUSES_HEALTHREG = "生命恢复";
TITAN_ITEMBONUSES_MANAREG = "法力恢复";
TITAN_ITEMBONUSES_HEALTH = "生命值";
TITAN_ITEMBONUSES_MANA = "法力值";	
		
-- equip and set bonus patterns:
TITAN_ITEMBONUSES_EQUIP_PREFIX = "装备：";
TITAN_ITEMBONUSES_SET_PREFIX = "套装：";
		
TITAN_ITEMBONUSES_EQUIP_PATTERNS = {
	{ pattern = "+(%d+) 远程攻击强度。", effect = "RANGEDATTACKPOWER" },
	{ pattern = "+(%d+) 攻击强度。", effect = "ATTACKPOWER" },
	{ pattern = "使你用盾牌格挡攻击的几率提高(%d+)%%。", effect = "BLOCK" },
	{ pattern = "使你躲闪攻击的几率提高(%d+)%%。", effect = "DODGE" },
	{ pattern = "使你招架攻击的几率提高(%d+)%%。", effect = "PARRY" },
	{ pattern = "使你的法术造成致命一击的几率提高(%d+)%%。", effect = "SPELLCRIT" },
	{ pattern = "使你的神圣法术造成致命一击的几率提高(%d+)%%。", effect = "HOLYCRIT" },
	{ pattern = "使你的神圣系法术打出致命一击效果的几率提高(%d+)%%。", effect = "HOLYCRIT" },
	{ pattern = "使你造成致命一击的几率提高(%d+)%%。", effect = "CRIT" },
	{ pattern = "使你的远程武器造成致命一击的几率提高(%d+)%%。", effect = "RANGEDCRIT" },
	{ pattern = "提高奥术法术和效果所造成的伤害，最多(%d+)点。", effect = "ARCANEDMG" },
	{ pattern = "提高火焰法术和效果所造成的伤害，最多(%d+)点。", effect = "FIREDMG" },
	{ pattern = "提高冰霜法术和效果所造成的伤害，最多(%d+)点。", effect = "FROSTDMG" },
	{ pattern = "提高神圣法术和效果所造成的伤害，最多(%d+)点。", effect = "HOLYDMG" },
	{ pattern = "提高自然法术和效果所造成的伤害，最多(%d+)点。", effect = "NATUREDMG" },
	{ pattern = "提高暗影法术和效果所造成的伤害，最多(%d+)点。", effect = "SHADOWDMG" },
	{ pattern = "提高法术所造成的治疗效果，最多(%d+)点。", effect = "HEAL" },
	{ pattern = "提高所有法术和魔法效果所造成的伤害和治疗效果，最多(%d+)点。", effect = {"HEAL", "DMG"} },
	{ pattern = "每5秒恢复(%d+)点生命值。", effect = "HEALTHREG" },
	{ pattern = "每5秒恢复(%d+)点法力值。", effect = "MANAREG" },
	{ pattern = "使你击中目标的几率提高(%d+)%%。", effect = "TOHIT" },
	{ pattern = "使你的法术击中敌人的几率提高(%d+)%%。", effect = "SPELLTOHIT" },
	{ pattern = "钓鱼技能提高(%d+)点。", effect = "FISHING" },
	{ pattern = "防御技能提高(%d+)点。", effect = "DEFENSE" },
	{ pattern = "剥皮技能提高([s]%d+)点。", effect = "SKINNING" }
};
		
TITAN_ITEMBONUSES_S1 = {
	{ pattern = "奥术", 	effect = "ARCANE" },	
	{ pattern = "火焰", 	effect = "FIRE" },	
	{ pattern = "冰霜", 	effect = "FROST" },	
	{ pattern = "神圣", 	effect = "HOLY" },	
	{ pattern = "阴影",	effect = "SHADOW" },	
	{ pattern = "自然", 	effect = "NATURE" }
}; 	
		
TITAN_ITEMBONUSES_S2 = {
	{ pattern = "抗性", 	effect = "RES" },	
	{ pattern = "伤害", 	effect = "DMG" },
	{ pattern = "效果", 	effect = "DMG" },
}; 	
			
TITAN_ITEMBONUSES_TOKEN_EFFECT = {
	["所有属性"] 			= {"STR", "AGI", "STA", "INT", "SPI"},
	["力量"]			= "STR",
	["敏捷"]			= "AGI",
	["耐力"]			= "STA",
	["智力"]			= "INT",
	["精神"] 			= "SPI",
		
	["所有抗性"] 			= { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES"},
		
	["钓鱼"]			= "FISHING",
	["鱼饵"]			= "FISHING",
	["采矿"]			= "MINING",
	["草药"]			= "HERBALISM",
	["剥皮"]			= "SKINNING",
	["防御"]			= "DEFENSE",
		
	["攻击强度"] 			= "ATTACKPOWER",
	["躲闪"] 			= "DODGE",
	["命中"] 			= "TOHIT",
	["法术命中"]			= "SPELLTOHIT",
	["格挡"]			= "BLOCK",
	["远程攻击强度"]		= "RANGEDATTACKPOWER",
	["每5秒回复生命"]		 = "HEALTHREG",
    ["治疗法术"] 			= "HEAL",
	["提高治疗"] 	    = "HEAL",
	["治疗效果和法术伤害"] = {"HEAL", "DMG"},
	["每5秒恢复法力"] 	 = "MANAREG",
	["法力恢复"] 			= "MANAREG",
	["法术伤害"] 		= "DMG",
	["致命"] 			= "CRIT",
	["致命一击"] 		= "CRIT",
	["伤害"] 			= "DMG",
	["生命"]			= "HEALTH",
	["生命值"]			= "HEALTH",
	["法力值"]			= "MANA",
	["护甲"]			= "ARMOR",
	["强化护甲"]			= "ARMOR",
};	
		
TITAN_ITEMBONUSES_OTHER_PATTERNS = {
	{ pattern = "每5秒恢复(%d+)点法力值。", effect = "MANAREG" },
	{ pattern = "赞达拉力量徽记", effect = "ATTACKPOWER", value = 30 },
	{ pattern = "赞达拉魔法徽记", effect = {"DMG", "HEAL"}, value = 18 },
	{ pattern = "赞达拉宁静徽记", effect = "HEAL", value = 33 }
};

--◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan Friends R9
--◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_FRIENDS_MENU_TEXT = "好友";
TITAN_FRIENDS_BUTTON_LABEL = "好友: ";
TITAN_FRIENDS_BUTTON_TEXT = "%s"..TitanUtils_GetHighlightText("/").."%s";
TITAN_FRIENDS_TOOLTIP = "好友信息";
TITAN_FRIENDS_MENU_WHISPER = "发送密语";
TITAN_FRIENDS_MENU_INVITE = "邀请组队";

--◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan Guild v2.5
--◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_GUILD_MENU_TEXT = "工会";
TITAN_GUILD_BUTTON_LABEL = "工会成员: ";
TITAN_GUILD_TOOLTIP = "工会信息";
TITAN_GUILD_GUILD_CHAT = "工会聊天";
TITAN_GUILD_GUILD_OFFICER_CHAT = "工会官员聊天";
TITAN_GUILD_SHOWOFFLINE = "显示不在线会员";
TITAN_GUILD_NOT_IN_GUILD = "非工会成员";
TITAN_GUILD_MENU_SHOWADVANCED_TEXT = "显示高级菜单";
TITAN_GUILD_MENU_ADVANCED_INVITE_TEXT = "邀请";
TITAN_GUILD_MENU_ADVANCED_WHISPER_TEXT = "密语";
TITAN_GUILD_MENU_ADVANCED_WHO_TEXT = "查询";
TITAN_GUILD_MENU_ADVANCED_FRIEND_TEXT = "好友";
TITAN_GUILD_MENU_CHAT_TEXT = "聊天";
TITAN_GUILD_MENU_SORT_TEXT = "排序";
TITAN_GUILD_MENU_FILTER_TEXT = "筛选";
TITAN_GUILD_MENU_TOOLTIP_TEXT = "提示";
TITAN_GUILD_TOOLTIP_HINT_TEXT = "提示: 左键点击开关工会窗口";
TITAN_GUILD_MENU_PLEASE_WAIT_TEXT = "请等待……刷新中";
TITAN_GUILD_MENU_HIDE_OPTIONS_TEXT = "隐藏选项";
TITAN_GUILD_MENU_SHOW_OPTIONS_TEXT = "显示选项";
TITAN_GUILD_MENU_HIDE = "|cff999999"..TITAN_PANEL_MENU_HIDE.."|r";
TITAN_GUILD_MENU_FILTER_MYZONE = "我所在区域";
TITAN_GUILD_MENU_FILTER_MYLEVEL = "我所在等级";
TITAN_GUILD_MENU_FILTER_CLASS = "职业";
TITAN_GUILD_MENU_FORWARD_TEXT = "下一页";
TITAN_GUILD_MENU_BACKWARD_TEXT = "上一页";
TITAN_GUILD_TOOLTIP_WARNING = "成员过多只列出部分！";
TITAN_GUILD_MENU_DISABLE_UPDATE_TEXT = "禁止自动刷新成员列表";

-- format
TITAN_GUILD_BUTTON_TEXT = "%s"..TitanUtils_GetHighlightText("/").."%s";
TITAN_GUILD_BUTTON_TEXT_FILTERED = "%s"..TitanUtils_GetHighlightText("/").."%s"..TitanUtils_GetHighlightText("/").."%s";
TITAN_GUILD_BUTTON_TEXT_ONLINEONLY_FORMAT = "%s";

-- sort options
sortChoicesValues = {"Name","Zone","Rank","Note","Level","Class"};
sortChoicesLabels = {};

-- init sortChoices
sortChoicesLabels = {"名字","地区","官阶","记录","等级","职业"};

-- class filter options
hordeClassValues = {"所有", "战士", "法师", "盗贼", "德鲁伊", "猎人", "牧师", "术士", "萨满祭司"};
allianceClassValues = {"所有", "战士", "法师", "盗贼", "德鲁伊", "猎人", "牧师", "术士", "圣骑士"};

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan Factions v0.11
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_FACTIONS_VERSION = "0.11";

TITAN_FACTIONS_MENU_TEXT = "声望";
TITAN_FACTIONS_BUTTON_LABEL = "声望";
TITAN_FACTIONS_BUTTON_TEXT = "%s";
TITAN_FACTIONS_TOOLTIP = "声望信息";

TITAN_FACTIONS_UNKNOWN_TEXT = "未知";
TITAN_FACTIONS_EXALTED_TEXT = "尊敬";

TITAN_FACTIONS_SHOW_RAW = "显示数值";

TITAN_FACTIONS_ABOUT_TEXT = "关于";
TITAN_FACTIONS_ABOUT_POPUP_TEXT = TitanUtils_GetGreenText("Titan Panel声望显示").."\n"..TitanUtils_GetNormalText("版本: ")..TitanUtils_GetHighlightText(TITAN_FACTIONS_VERSION).."\n"..TitanUtils_GetNormalText("作者: ")..TitanUtils_GetHighlightText("Corgi");

TITAN_FACTIONS_MONITOR = "追踪器";
TITAN_FACTIONS_MONITOR_TOGGLE_TEXT = "追踪器 On/Off";

-- Faction Text Color
FactionTextHated = " |cff8b0000"..FACTION_STANDING_LABEL1.."|r";
FactionTextHostile = " |cffff0000"..FACTION_STANDING_LABEL2.."|r";
FactionTextUnfriendly = " |cffff8C00"..FACTION_STANDING_LABEL3.."|r";
FactionTextNeutral = " |cffc0c0c0"..FACTION_STANDING_LABEL4.."|r";
FactionTextFriendly = " |cffffffff"..FACTION_STANDING_LABEL5.."|r";
FactionTextHonored = " |cff00ff00"..FACTION_STANDING_LABEL6.."|r";
FactionTextRevered = " |cff4169e1"..FACTION_STANDING_LABEL7.."|r";
FactionTextExalted = " |cff9932cc"..FACTION_STANDING_LABEL8.."|r";

--◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan BGInfo v0.5
--◎◎◎◎◎◎◎◎◎◎◎◎
TITAN_BGINFO_VERSION = "0.05";

TITAN_BGINFO_MENU_TEXT = "战场";
TITAN_BGINFO_BUTTON_LABEL = "战场信息";
TITAN_BGINFO_BUTTON_TEXT = "%s";
TITAN_BGINFO_TOOLTIP = "战场信息";

TITAN_BGINFO_ABOUT_TEXT = "关于";
TITAN_BGINFO_ABOUT_POPUP_TEXT = TitanUtils_GetGreenText("Titan Panel 战场信息").."\n"..TitanUtils_GetNormalText("版本: ")..TitanUtils_GetHighlightText(TITAN_BGINFO_VERSION).."\n"..TitanUtils_GetNormalText("作者: ")..TitanUtils_GetHighlightText("Corgi");

TITAN_BGINFO_HINT_TEXT = "提示：右键点击显示选项";

TITAN_BGINFO_NOTIN_TEXT = "你未在战场中";

TITAN_BGINFO_CONFIRM_TEXT = " 确认";

TITAN_BGINFO_BONUS_HONOR_TEXT = "荣誉点数";

-- BG objectives
TITAN_BGINFO_FLAGS_CAPTURED_TEXT = "夺取旗帜";
TITAN_BGINFO_FLAGS_RETURNED_TEXT = "夺回旗帜";

TITAN_BGINFO_GRAVEYARDS_ASSAULTED_TEXT = "墓地被攻击";
TITAN_BGINFO_GRAVEYARDS_DEFENDED_TEXT = "墓地已防御";

TITAN_BGINFO_TOWERS_ASSAULTED_TEXT = "堡垒被攻击";
TITAN_BGINFO_TOWERS_DEFENDED_TEXT = "堡垒已防御";

TITAN_BGINFO_MINES_CAPTURED_TEXT = "资源被夺取";

TITAN_BGINFO_LEADERS_KILLED_TEXT = "首领被杀";

TITAN_BGINFO_SECONDARY_OBJECTIVES_TEXT = "次要目标";

TITAN_BGINFO_BASES_ASSAULTED_TEXT = "基地被攻击";
TITAN_BGINFO_BASES_DEFENDED_TEXT = "基地已防御";

-- toggle
TITAN_BGINFO_TOGGLE_SCORES_TEXT = "打开/关闭记分版";
TITAN_BGINFO_TOGGLE_MINIMAP_TEXT = "打开/关闭迷你地图图标";

TITAN_BGINFO_AV_FULL_TEXT = "奥特兰克山谷";
TITAN_BGINFO_WG_FULL_TEXT = "战歌峡谷";
TITAN_BGINFO_AB_FULL_TEXT = "阿拉希盆地";

TITAN_BGINFO_AV_TEXT = "奥谷";
TITAN_BGINFO_WG_TEXT = "战歌";
TITAN_BGINFO_AB_TEXT = "阿拉希";

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan CombatInfo v1.5
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎

--<< General Variables >>--
TITAN_COMBATINFO_ID = "CombatInfo";
TITAN_COMBATINFO_BUTTON_TEXT="%s";
TITAN_COMBATINFO_BUTTON_ICON="Interface\\Icons\\Ability_Rogue_FeignDeath.blp";
TITAN_COMBATINFO_TEXT="%d";
TITAN_COMBATINFO_RANGESPEED="%.3g";
TITAN_COMBATINFO_RANGEDMG="%d-%d";
TITAN_COMBATINFO_RANGEAVGDMG="%.2f";
TITAN_COMBATINFO_ARMOR="%.3g";
TITAN_COMBATINFO_ARMOR_ICON="";
TITAN_COMBATINFO_BLOCK="%.2f%%";
TITAN_COMBATINFO_BLOCK_ICON="Interface\\Icons\\Ability_Defend.blp";
TITAN_COMBATINFO_CRIT="%.2f%%";
TITAN_COMBATINFO_CRIT_ICON="Interface\\Icons\\Ability_CriticalStrike.blp";
TITAN_COMBATINFO_DODGE="%.2f%%";
TITAN_COMBATINFO_DODGE_ICON="Interface\\Icons\\Spell_Nature_Invisibilty.blp";
TITAN_COMBATINFO_PARRY="%.2f%%";
TITAN_COMBATINFO_PARRY_ICON="Interface\\Icons\\Ability_Parry.blp";
TITAN_COMBATINFO_MELEE_MAINSPEED="%.3g";
TITAN_COMBATINFO_MELEE_MAINAVGDMG="%.3g";
TITAN_COMBATINFO_MELEE_MAINDMG="%d-%d";
TITAN_COMBATINFO_MELEE_OFFHANDSPEED="%.3g";
TITAN_COMBATINFO_MELEE_OFFAVGDMG="%.3g";
TITAN_COMBATINFO_MELEE_OFFHANDDMG="%d-%d";

--<< Info format >>--
TITAN_COMBATINFO_BUTTON_LABEL="战斗力信息";
TITAN_COMBATINFO_TOOLTIP="战斗力信息";
TITAN_COMBATINFO_MENU_TEXT="战斗力";
TITAN_COMBATINFO_RANGE_TEXT="远程攻击";
TITAN_COMBATINFO_RANGEDMG_TEXT="伤害:";
TITAN_COMBATINFO_RANGEPWR_TEXT="强度:";
TITAN_COMBATINFO_RANGEPWR="%d (基础远程强度 %d)";
TITAN_COMBATINFO_RANGEATTACKSPEED="攻击速度(秒):";
TITAN_COMBATINFO_RANGEAVGDMG_TEXT="平均每秒伤害:";
TITAN_COMBATINFO_ARMOR_TEXT="护甲";
TITAN_COMBATINFO_BLOCK_TEXT="格挡几率: ";
TITAN_COMBATINFO_CRIT_ATTACKTEXT="攻击";
TITAN_COMBATINFO_CRIT_TEXT="致命一击率: ";
TITAN_COMBATINFO_DODGE_TEXT="躲闪几率: ";
TITAN_COMBATINFO_PARRY_TEXT="招架几率: "
TITAN_COMBATINFO_MELEE_TEXT="近战攻击";
TITAN_COMBATINFO_MELEE_MAINSPEED_TEXT="主手武器速度(秒): ";
TITAN_COMBATINFO_MELEE_MAINAVGDMG_TEXT="主手武器每秒伤害: ";
TITAN_COMBATINFO_MELEE_MAINDMG_TEXT="主手武器伤害: ";
TITAN_COMBATINFO_MELEE_OFFHANDSPEED_TEXT="副手武器速度(秒): ";
TITAN_COMBATINFO_MELEE_OFFAVGDMG_TEXT="副手武器每秒伤害: ";
TITAN_COMBATINFO_MELEE_OFFHANDDMG_TEXT="副手武器伤害: ";
TITAN_COMBATINFO_MELEE_POWER_TEXT="近战强度:";
TITAN_COMBATINFO_MELEE_POWER="%d (基础近战强度 %d)";
TITAN_COMBATINFO_OPTIONS_SHOWBLOCK_TEXT="显示格挡百分比";
TITAN_COMBATINFO_OPTIONS_SHOWCRIT_TEXT="显示重击百分比";
TITAN_COMBATINFO_OPTIONS_SHOWDODGE_TEXT="显示躲避百分比";
TITAN_COMBATINFO_OPTIONS_SHOWPARRY_TEXT="显示招架百分比";
TITAN_COMBATINFO_OPTIONS_SHOWSTATLABEL_TEXT = "显示状态标签";

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding AnkhCooldownTimer v1.2
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎

CLASSNAME_SHAMAN = "萨满祭司"
IMPROVED_REINC = "复生"
ANKHNAME = "十字章"

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan Class Track v2.6
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_CLASSTRACKER_MENU_TEXT="职业计数器";
TITAN_CLASSTRACKER_BUTTON_TEXT="职业计数器";
TITAN_CLASSTRACKER_TOOLTIP_NA="无关注物品";
TITAN_CLASSTRACKER_TOOLTIP_CLICK = "右键点击配置";
TITAN_CLASSTRACKER_TOOLTIP = "正在计数";
TITAN_CLASSTRACKER_BUTTON_TINY="计数:";
TITAN_CT_MENU_SHOW_TITLE = "显示职业名称";
TITAN_CT_MENU_SHOW_TRACKER = "显示计数";

TITAN_WARRIOR_TITLE = "战士计数器";
TITAN_HUNTER_TITLE = "猎人计数器";

TITAN_WARLOCK_TITLE = "术士计数器";
TITAN_WARLOCK_BUTTON_LABEL="灵魂碎片: ";
TITAN_WARLOCK_BUTTON_TEXTSHARDS="%s";
TITAN_WARLOCK_TOOLTIP_SHARDS = "灵魂碎片: %s";
TITAN_WARLOCK_TOOLTIP_HEALTH = "治疗石: %s";
TITAN_WARLOCK_TOOLTIP_SOUL = "灵魂石: %s";
TITAN_WARLOCK_TOOLTIP_SPELL = "魔法石: %s";
TITAN_WARLOCK_TOOLTIP_FIRE = "火焰石: %s";

TITAN_SHAMAN_TITLE = "萨满计数器";
TITAN_SHAMAN_BUTTON_LABEL="十字章: ";
TITAN_SHAMAN_BUTTON_TEXTANKHS="%s";
TITAN_SHAMAN_TOOLTIP_ANKHS = "十字章: %s";
TITAN_SHAMAN_TOOLTIP_SCALES = "闪亮的鱼鳞: %s";
TITAN_SHAMAN_TOOLTIP_OIL = "鱼油: %s";

TITAN_MAGE_TITLE = "法师计数器";
TITAN_MAGE_BUTTON_LABELTELE="传送符文: ";
TITAN_MAGE_BUTTON_LABELPORTAL="传送门符文: ";
TITAN_MAGE_BUTTON_TEXTTELE="%s";
TITAN_MAGE_BUTTON_TEXTPORTAL="%s";
TITAN_MAGE_TOOLTIP_TELE = "传送符文: %s";
TITAN_MAGE_TOOLTIP_PORTAL = "传送门符文: %s";
TITAN_MAGE_TOOLTIP_ARCANE = "魔粉: %s";
TITAN_MAGE_TOOLTIP_FEATHER = "轻羽毛: %s";

TITAN_ROGUE_TITLE = "盗贼计数器";
TITAN_ROGUE_BUTTON_LABELFLASH="闪光粉: ";
TITAN_ROGUE_BUTTON_LABELBLIND="致盲粉: ";
TITAN_ROGUE_BUTTON_LABELPOISONS="毒: ";
TITAN_ROGUE_BUTTON_TEXTFLASH="%s";
TITAN_ROGUE_BUTTON_TEXTBLIND="%s";
TITAN_ROGUE_BUTTON_TEXTPOISONS="%s";
TITAN_ROGUE_TOOLTIP_FLASH = "闪光粉: %s";
TITAN_ROGUE_TOOLTIP_BLIND = "致盲粉: %s";
TITAN_ROGUE_TOOLTIP_THISTLE = "菊花茶: %s";
TITAN_ROGUE_TOOLTIP_INSTANT = "速效毒药: %s";
TITAN_ROGUE_TOOLTIP_DEADLY = "致命毒药: %s";
TITAN_ROGUE_TOOLTIP_CRIPPLING = "致残毒药: %s";
TITAN_ROGUE_TOOLTIP_MINDNUMB = "麻痹毒药: %s";
TITAN_ROGUE_TOOLTIP_WOUND = "致伤毒药: %s";

TITAN_DRUID_TITLE = "德鲁伊计数器";
TITAN_DRUID_BUTTON_LABELSEEDS="种子: ";
TITAN_DRUID_BUTTON_LABELWILD="野生植物: ";
TITAN_DRUID_BUTTON_TEXTSEEDS="%s";
TITAN_DRUID_BUTTON_TEXTWILD="%s";
TITAN_DRUID_TOOLTIP_MSEED = "枫树种子: %s";
TITAN_DRUID_TOOLTIP_SSEED = "荆棘种子: %s";
TITAN_DRUID_TOOLTIP_ASEED = "灰木种子: %s";
TITAN_DRUID_TOOLTIP_HSEED = "角树种子: %s";
TITAN_DRUID_TOOLTIP_ISEED = "铁木种子: %s";
TITAN_DRUID_TOOLTIP_BERRIES = "野生浆果: %s";
TITAN_DRUID_TOOLTIP_THORNROOT = "野生棘根草: %s";

TITAN_PRIEST_TITLE = "牧师计数器";
TITAN_PRIEST_BUTTON_LABELFEATHERS="羽毛: ";
TITAN_PRIEST_BUTTON_LABELCANDLES="蜡烛: ";
TITAN_PRIEST_BUTTON_TEXTFEATHER="%s";
TITAN_PRIEST_BUTTON_TEXTCANDLES="%s";
TITAN_PRIEST_TOOLTIP_FEATHER = "轻羽毛: %s";
TITAN_PRIEST_TOOLTIP_HCANDLE = "圣洁蜡烛: %s";
TITAN_PRIEST_TOOLTIP_SCANDLE = "神圣蜡烛: %s";

TITAN_PALADIN_TITLE = "圣骑士计数器";
TITAN_PALADIN_BUTTON_LABELSYMBOL="符印: ";
TITAN_PALADIN_BUTTON_TEXTSYMBOL="%s";
TITAN_PALADIN_TOOLTIP_SYMBOL = "神圣符印: %s";

--◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan Quest v0.13
--◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_QUESTS_VERSION = "0.13";
TITAN_QUESTS_MENU_TEXT = "任务";
TITAN_QUESTS_BUTTON_LABEL = "任务: ";
TITAN_QUESTS_BUTTON_TEXT = "%s"..TitanUtils_GetHighlightText("/").."%s";
TITAN_QUESTS_TOOLTIP = "任务信息";
TITAN_QUESTS_OPTIONS_TEXT = "选项";
TITAN_QUESTS_LEVEL_TEXT = "等级 ";
TITAN_QUESTS_ABOUT_VERSION_TEXT = "版本";
TITAN_QUESTS_ABOUT_AUTHOR_TEXT = "作者";
TITAN_QUESTS_ABOUT_POPUP_TEXT = TitanUtils_GetGreenText("Titan Panel任务插件").."\n"..TitanUtils_GetNormalText(TITAN_QUESTS_ABOUT_VERSION_TEXT..": ")..TitanUtils_GetHighlightText(TITAN_QUESTS_VERSION).."\n"..TitanUtils_GetNormalText(TITAN_QUESTS_ABOUT_AUTHOR_TEXT..":")..TitanUtils_GetHighlightText("Corgi");
TITAN_QUESTS_ARTWORK_PATH = "Interface\\AddOns\\TitanPlus\\Artwork\\";

TITAN_QUESTS_SORT_TEXT = "排序";
TITAN_QUESTS_SORT_LOCATION_TEXT = "按照地点(默认)";
TITAN_QUESTS_SORT_LEVEL_TEXT = "按照等级";
TITAN_QUESTS_SORT_TITLE_TEXT = "按照名称";

TITAN_QUESTS_SHOW_TEXT = "任务显示";
TITAN_QUESTS_SHOW_ELITE_TEXT = "仅精英级别";
TITAN_QUESTS_SHOW_DUNGEON_TEXT = "仅副本级别";
TITAN_QUESTS_SHOW_RAID_TEXT = "仅团队级别";
TITAN_QUESTS_SHOW_PVP_TEXT = "仅PvP级别";
TITAN_QUESTS_SHOW_REGULAR_TEXT = "仅普通级别";
TITAN_QUESTS_SHOW_COMPLETED_TEXT = "仅已完成任务";
TITAN_QUESTS_SHOW_INCOMPLETE_TEXT = "仅未完成";
TITAN_QUESTS_SHOW_ALL_TEXT = "所有(默认)";

TITAN_QUESTS_TOGGLE_TEXT = "显示文字标签";
TITAN_QUESTS_CLICK_BEHAVIOR_TEXT = "左键点击观看任务日志";
TITAN_QUESTS_GROUP_BEHAVIOR_TEXT = "按组排列任务";

TITAN_QUESTS_QUESTLOG_TRUNCATED_TEXT = "任务描述被缩减了……";
TITAN_QUESTS_OPEN_QUESTLOG_TEXT = "打开任务日志";
TITAN_QUESTS_CLOSE_QUESTLOG_TEXT = "关闭任务日志";
TITAN_QUESTS_OPEN_MONKEYQUEST_TEXT = "打开MonkeyQuest";
TITAN_QUESTS_CLOSE_MONKEYQUEST_TEXT = "关闭MonkeyQuest";
TITAN_QUESTS_OPEN_QUESTION_TEXT = "打开QuestIon";
TITAN_QUESTS_CLOSE_QUESTION_TEXT = "关闭QuestIon";
TITAN_QUESTS_OPEN_PARTYQUESTS_TEXT = "打开PartyQuests";
TITAN_QUESTS_CLOSE_PARTYQUESTS_TEXT = "关闭PartyQuests";
TITAN_QUESTS_OPEN_QUESTHISTORY_TEXT = "打开QuestHistory";
TITAN_QUESTS_CLOSE_QUESTHISTORY_TEXT = "关闭QuestHistory";
TITAN_QUESTS_OPEN_QUESTBANK_TEXT = "打开QuestBank";
TITAN_QUESTS_CLOSE_QUESTBANK_TEXT = "关闭QuestBank";
TITAN_QUESTS_ABOUT_TEXT = "关于";

TITAN_QUESTS_OBJECTIVESTXT_LONG_TEXT = TitanUtils_GetRedText("描述文字过长,\n点击任务了解详细信息。");
TITAN_QUESTS_REMOVE_FROM_WATCHER_TEXT = "从关注列表移处";
TITAN_QUESTS_ADD_TO_WATCHER_TEXT = "加入关注列表";
TITAN_QUESTS_ABANDON_QUEST_TEXT = "放弃任务";
TITAN_QUESTS_QUEST_DETAILS_TEXT = "详细任务描述";
TITAN_QUESTS_QUEST_DETAILS_OPTIONS_TEXT = "任务选项";
TITAN_QUESTS_LINK_QUEST_TEXT = "连接任务";
TITAN_QUESTS_DETAILS_SHARE_BUTTON_TEXT = "共享";
TITAN_QUESTS_DETAILS_WATCH_BUTTON_TEXT = "关注";
TITAN_QUESTS_NEWBIE_TOOLTIP_WATCHQUEST = "从任务关注列表中 添加/删除";

TITAN_QUESTS_TOOLTIP_QUESTS_TEXT = "全部任务数目: ";
TITAN_QUESTS_TOOLTIP_ELITE_TEXT = "精英任务数目: ";
TITAN_QUESTS_TOOLTIP_DUNGEON_TEXT = "副本任务数目: ";
TITAN_QUESTS_TOOLTIP_RAID_TEXT = "团队任务数目: ";
TITAN_QUESTS_TOOLTIP_PVP_TEXT = "PvP任务数目: ";
TITAN_QUESTS_TOOLTIP_REGULAR_TEXT = "普通任务数目: ";
TITAN_QUESTS_TOOLTIP_COMPLETED_TEXT = "已完成任务数目: ";
TITAN_QUESTS_TOOLTIP_INCOMPLETE_TEXT = "未完成任务数目: ";
TITAN_QUESTS_TOOLTIP_HINT_TEXT = "提示: 右键点击获得任务列表";

-- quest labels 
TITAN_QUESTS_DUNGEON = "地下城";
TITAN_QUESTS_RAID = "团队";
TITAN_QUESTS_PVP = "PvP";

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding TitanMail Notifier v1.07
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_MAIL_MENU_TEXT = "信件";
TITAN_MAILRIGHT_MENU_TEXT = "信件(右侧)";
TITAN_MAIL_BUTTON_TEXT_NOMAIL = "无信件";
TITAN_MAIL_BUTTON_TEXT_MAIL = "有信件";
TITAN_MAIL_BUTTON_TEXT_ALERT = "拍卖所警告！";
TITAN_MAIL_CHAT_NEW = "你有新信件！";

TITAN_MAIL_TOOLTIP = "信件";
TITAN_MAIL_TOOLTIP_NEW = "新邮件物品\n";
TITAN_MAIL_TOOLTIP_TOTAL = "所有邮件物品";
TITAN_MAIL_TOOLTIP_OUTBID = "出价被超过: ";
TITAN_MAIL_TOOLTIP_WON = "赢取: ";
TITAN_MAIL_TOOLTIP_EXPIRED = "拍卖到期: ";
TITAN_MAIL_TOOLTIP_CANCELLED = "拍卖取消: ";
TITAN_MAIL_TOOLTIP_SOLD = "卖出: ";

TITAN_MAIL_MENU_HIDEMM = "隐藏迷你地图信件图标";
TITAN_MAIL_MENU_COMPACT = "简洁模式";
TITAN_MAIL_MENU_CHAT = "聊天窗口警告";
TITAN_MAIL_MENU_SOUND = "声音警告";



--◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan PvPInfo v0.42
--◎◎◎◎◎◎◎◎◎◎◎◎◎
TITAN_PVPINFO_MENU_TEXT = "PvP信息";
TITAN_PVPINFO_BUTTON_TEXT = "PvP: ";
TITAN_PVPINFO_TOOLTIP = "PvP信息";
TITAN_PVPINFO_TOOLTIP_STATUS = "PvP状态: %s";
TITAN_PVPINFO_TOOLTIP_AREA = "区域: %s";
TITAN_PVPINFO_STATE_ACTIVE = "激活";
TITAN_PVPINFO_STATE_INACTIVE = "未激活";
TITAN_PVPINFO_STATE_ON = "打开";
TITAN_PVPINFO_STATE_OFF = "关闭";
TITAN_PVPINFO_FLAG_ON = "打开";
TITAN_PVPINFO_FLAG_OFF = "关闭";
TITAN_PVPINFO_REMAINING = "剩余时间(秒): %s";
TITAN_PVPINFO_PVPTIME = "PvP时间: %s";
TITAN_PVPINFO_PVPSESSION = "本次连接PvP数: %s";
TITAN_PVPINFO_TOGGLE_TEXT = "点击打开/关闭PVP";
TITAN_PVPINFO_FRIENDLY = "友方";
TITAN_PVPINFO_HOSTILE = "敌对";
TITAN_PVPINFO_CONTESTED = "中立";
TITAN_PVPINFO_PVPFLAG_TEXT = "PvP标志: %s";
TITAN_PVPINFO_MENU_COLLAPSE = "未打开PVP时不显示";
TITAN_PVPINFO_MENU_THREATCOLOUR = "颜色设置: ";
TITAN_PVPINFO_MENU_STATUSPREF = "显示状态为: ";
TITAN_PVPINFO_MENU_TIMERCOLOUR_TEXT = "显示冷却时间在:";
TITAN_PVPINFO_MENU_REDTEXT = "红色";
TITAN_PVPINFO_MENU_YELLOWTEXT = "黄色";
TITAN_PVPINFO_MENU_WHITETEXT = "白色";
TITAN_PVPINFO_MENU_GREENTEXT = "绿色";
TITAN_PVPINFO_MENU_WAITINGTEXT = " (等候PvP时间结束)";     -- 还没有想到什么好词儿……(作者语，非译者)
TITAN_PVPINFO_ON_SEARCH = "未标志为PvP";
TITAN_PVPINFO_OFF_SEARCH = "不能标志为PvP" ;

--◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan Tracker v0.07
--◎◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_TRACKER_VERSION = "0.07";
TITAN_TRACKER_MENU_TEXT = "追踪系统(Titan Tracker)";
TITAN_TRACKER_BUTTON_LABEL = "追踪系统";
TITAN_TRACKER_BUTTON_TEXT = "%s";
TITAN_TRACKER_TOOLTIP = "追踪系统";
TITAN_TRACKER_TOOLTIP_TEXT = "提示: 右键点击选择追踪技能开关";

TITAN_TRACKER_ABOUT_TEXT = "关于";
TITAN_TRACKER_ABOUT_POPUP_TEXT = TitanUtils_GetGreenText("Titan Panel追踪系统").."\n"..TitanUtils_GetNormalText("版本: ")..TitanUtils_GetHighlightText(TITAN_TRACKER_VERSION).."\n"..TitanUtils_GetNormalText("作者: ")..TitanUtils_GetHighlightText("Corgi");

-- Header Types
TITAN_TRACKER_SPELL_TYPE_FIND  = "寻宝技能(商业技能)";
TITAN_TRACKER_SPELL_TYPE_TRACK = "追踪技能(追踪敌人)";
TITAN_TRACKER_SPELL_TYPE_SENSE = "感知技能(圣骑士技能)";

-- Object tracking
TITAN_TRACKER_SPELL_FIND_HERBS    = "寻找草药";
TITAN_TRACKER_SPELL_FIND_MINERALS = "寻找矿物";
TITAN_TRACKER_SPELL_FIND_TREASURE = "寻找财宝";

-- Standard creature tracking
TITAN_TRACKER_SPELL_TRACK_BEASTS     = "追踪野兽";
TITAN_TRACKER_SPELL_TRACK_HUMANOIDS  = "追踪人型生物";
TITAN_TRACKER_SPELL_TRACK_HIDDEN     = "追踪隐藏生物";
TITAN_TRACKER_SPELL_TRACK_ELEMENTALS = "追踪元素生物";
TITAN_TRACKER_SPELL_TRACK_UNDEAD     = "追踪亡灵";
TITAN_TRACKER_SPELL_TRACK_DEMONS     = "追踪恶魔";
TITAN_TRACKER_SPELL_TRACK_GIANTS     = "追踪巨人";
TITAN_TRACKER_SPELL_TRACK_DRAGONKIN  = "追踪龙类";

-- Class specific tracking
TITAN_TRACKER_SPELL_SENSE_UNDEAD = "感知亡灵";
TITAN_TRACKER_SPELL_SENSE_DEMONS = "感知恶魔";

-- Icon textures
TITAN_TRACKER_ICON_FIND_HERBS = "Interface\\Icons\\INV_Misc_Flower_02";
TITAN_TRACKER_ICON_FIND_MINERALS = "Interface\\Icons\\Spell_Nature_Earthquake";
TITAN_TRACKER_ICON_FIND_TREASURE = "Interface\\Icons\\Racial_Dwarf_FindTreasure";
TITAN_TRACKER_ICON_TRACK_BEASTS = "Interface\\Icons\\Ability_Tracking";
TITAN_TRACKER_ICON_TRACK_HUMANOIDS = "Interface\\Icons\\Spell_Holy_PrayerOfHealing";
TITAN_TRACKER_ICON_TRACK_HIDDEN = "Interface\\Icons\\Ability_Stealth"
TITAN_TRACKER_ICON_TRACK_ELEMENTALS = "Interface\\Icons\\Spell_Frost_SummonWaterElemental";
TITAN_TRACKER_ICON_TRACK_UNDEAD = "Interface\\Icons\\Spell_Shadow_DarkSummoning";
TITAN_TRACKER_ICON_TRACK_DEMONS = "Interface\\Icons\\Spell_Shadow_SummonFelHunter";
TITAN_TRACKER_ICON_TRACK_GIANTS = "Interface\\Icons\\Ability_Racial_Avatar";
TITAN_TRACKER_ICON_TRACK_DRAGONKIN = "Interface\\Icons\\INV_Misc_Head_Dragon_01";
TITAN_TRACKER_ICON_SENSE_UNDEAD = "Interface\\Icons\\Spell_Holy_SenseUndead";
TITAN_TRACKER_ICON_SENSE_DEMONS = "Interface\\Icons\\Spell_Shadow_Metamorphosis";

TITAN_TRACKER_NOTHING_TEXT = "无可追踪对象";
TITAN_TRACKER_STOP_TRACKING = "停止追踪";
TITAN_TRACKER_HIDE_MINIMAP = "隐藏迷你地图的追踪图标";

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan MonkeySpeed v1.02
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎
TITAN_SPEED_ID="Speed";
TITAN_SPEED_FREQUENCY=30;

TITAN_SPEED_BUTTON_SPEED = "速度: %s";
TITAN_SPEED_BUTTON_SPEED_PERC = "速度(%%): %s";
TITAN_SPEED_BUTTON_DISTANCE = "距离: %s";

TITAN_SPEED_MENUTEXT = "速度(TitanSpeed)";
TITAN_SPEED_MENU_TITLE = "显示选项";
TITAN_SPEED_MENU_SHOW_SPEED = "显示速度";
TITAN_SPEED_MENU_SHOW_SPEED_PERC = "显示速度百分比";
TITAN_SPEED_MENU_SHOW_DISTANCE = "显示与目标距离";

TITAN_SPEED_NO_SPEED = "停止";

--◎◎◎◎◎◎◎◎◎◎
--Adding TitanLookFor
--◎◎◎◎◎◎◎◎◎◎

TITAN_LookFor_MENU_TEXT = "寻找系统(Titan LookFor)";
TITAN_LookFor_BUTTON_TEXT = "寻找: ";
TITAN_LookFor_TOOLTIP = "寻找：寻找特定的怪物/物品(当鼠标指向之时)";
TITAN_LookFor_FREQUENCY = 1;
LookFor_FRAME_TITLE = "敲入需要寻找的怪物/物品的名称";

--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎
--Adding TitanClearMiniMap v1.0a
--◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎

TITAN_CLEANMINIMAP_MENU_TEXT = "迷你地图管理(Clean Minimap)";
TITAN_CLEANMINIMAP_ARTWORK_PATH = "Interface\\AddOns\\TitanPlus\\Artwork\\";

TITAN_CLEANMINIMAP_TOOLTIP_HINT1 = "提示: 左键点击切换是否显示";
TITAN_CLEANMINIMAP_TOOLTIP_HINT2 = "迷你地图";
TITAN_CLEANMINIMAP_TOOLTIP_HINT3 = "提示: 改变迷你地图的透明度";
TITAN_CLEANMINIMAP_TOOLTIP_HINT4 = "当鼠标悬停时";
TITAN_CLEANMINIMAP_TOOLTIP_HINT5 = "按下Shift键";
TITAN_CLEANMINIMAP_TOOLTIP_HINT6 = "同时滚动鼠标滚轮";

TITAN_CLEANMINIMAP_TOOLTIP_ALPHA_VALUE = "迷你地图透明度: ";
TITAN_CLEANMINIMAP_TOOLTIP_SIZE_VALUE = "迷你地图尺寸: ";
TITAN_CLEANMINIMAP_TOOLTIP_STATUS = "迷你地图状态: ";
TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS = "清理迷你地图状态: ";
TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_TITLE = "地名标题栏状态: ";
TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_CLOCK = "白天/黑夜按钮状态: ";
TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_ZOOM = "缩放按钮状态: ";
TITAN_CLEANMINIMAP_TOOLTIP_CMMSTATUS_NSEW = "方位指示器状态: ";

TITAN_CLEANMINIMAP_MENU_ENABLE_MM = "打开迷你地图";
TITAN_CLEANMINIMAP_MENU_ENABLE_CMM = "打开清理迷你地图";
TITAN_CLEANMINIMAP_MENU_SHOW_CLOCK = "显示白天/黑夜按钮";
TITAN_CLEANMINIMAP_MENU_SHOW_TITLE = "显示地名标题栏";
TITAN_CLEANMINIMAP_MENU_SHOW_ZOOM = "显示缩放按钮";
TITAN_CLEANMINIMAP_MENU_SHOW_NSEW = "显示方位指示器";
TITAN_CLEANMINIMAP_MENU_MOVE = "移动迷你地图";

--◎◎◎◎◎◎◎◎◎◎◎
--Adding Titan Roll v0.3
--◎◎◎◎◎◎◎◎◎◎◎

TITANROLL_NAME		= "Titan Panel点数记录"
TITANROLL_VERSION 	= "0.3"
TITANROLL_NAMEVERSION	= TITANROLL_NAME.." v"..TITANROLL_VERSION

TITANROLL_MENUTEXT	= "点数记录(Roll)"
TITANROLL_LABELTEXT	= "上次投点: "
TITANROLL_LABELWINNER	= "胜利者: "
TITANROLL_TOOLTIP	= "最近投掷点数"
TITANROLL_NOROLL	= "尚未投点!"
TITANROLL_HINT		= "提示: 左键点击显示投点数"

TITANROLL_TOGWINNER	= "在bar上显示胜利者名字";
TITANROLL_TOGREPLACE	= "重新投点时替换掉无效投点"
TITANROLL_TOGSORTLIST	= "按照数值排列投点记录"
TITANROLL_TOGHIGHLIGHT	= "高亮显示队友所投点数"
TITANROLL_ERASELIST	= "清除列表"

TITANROLL_PERFORMED	= "改变已完成投点"
TITANROLL_CHANGELENGTH	= "改变列表长度"
TITANROLL_SETTIMEOUT	= "设置超时"
TITANROLL_CURRENTACTION = "当前范围: "

TITANROLL_SEARCHPATTERN	= "(.+)掷出(%d+) %((%d+)%-(%d+)%)"

TITANROLL_TIMEOUTS_TEXT = {
	"10秒",
	"20秒",
	"30秒",
	"1分",
	"2分",
	"3分",
	"无"
	}