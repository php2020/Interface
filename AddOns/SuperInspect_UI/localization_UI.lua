
SI_IB_CATEGORIES = {'ATT', 'BON', 'SBON', 'RES', 'SKILL', 'OBON', 'COH'};
SI_IB_YELLOW = "|cffffff00";

--ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
--ITEM_SPELL_TRIGGER_ONPROC = "Chance on hit:";
--ITEM_SPELL_TRIGGER_ONUSE = "Use:";
-- equip and set bonus patterns:
SI_IB_EQUIP_PREFIX = ITEM_SPELL_TRIGGER_ONEQUIP.." ";
SI_IB_COH_PREFIX = ITEM_SPELL_TRIGGER_ONPROC.." ";
SI_IB_USE_PREFIX = ITEM_SPELL_TRIGGER_ONUSE.." ";


--Language Localization-----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--TO ADD:
--Chance on hit: blah blah
--Balanced weapon?


--Chinese--------------------------------------------------
-----------------------------------------------------------
if (GetLocale() == "zhCN") then
	SI_DURABILITY = "耐久度";

	SI_COMPARE_TOOLTIP = "将当前目标的属性加成信息\n复制到比较窗口中,\n以便于同其他玩家进行比较。";

	-- general
	SI_IB_TEXT = "装备属性加成";
	SI_IB_TEXT_MISSINGDATA = "走进10码范围来获取更好的属性加成扫描";
	--SI_TEXT_CACHEPLAYER = "缓存玩家";
	--SI_TEXT_CACHEPLAYERCACHED = "玩家物品列表缓存。";
	--SI_TEXT_CACHEPLAYERFROMCACHE = "玩家物品份缓存载入。";

	SI_IB_CAT_ATT = "属性";
	SI_IB_CAT_RES = "抗性";
	SI_IB_CAT_SKILL = "技能";
	SI_IB_CAT_BON = "战斗";
	SI_IB_CAT_SBON = "法术";
	SI_IB_CAT_OBON = "生命值和法力值";
	SI_IB_CAT_COH = "命中率";
		
	-- bonus names
	SI_IB_ARMOR 	= "强化护甲";

	SI_IB_FISHING	= "钓鱼";
	SI_IB_MINING	= "采矿";
	SI_IB_HERBALISM	= "草药学";
	SI_IB_SKINNING	= "剥皮";
	SI_IB_DEFENSE	= "防御技能";
		
	SI_IB_HIT_WOUND = "重伤目标";      --SI_IB_HIT_WOUND = "Wound Target for";
	SI_IB_HIT_SHADOW = "暗影箭攻击";       --SI_IB_HIT_SHADOW = "Shadowy Bolt";

	SI_IB_BLOCK = "格挡几率";
	SI_IB_DODGE = "躲避几率";
	SI_IB_PARRY = "招架几率";
	SI_IB_CRIT = "近战致命";
	SI_IB_RANGEDCRIT = "远程致命";
	SI_IB_TOHIT = "命中率";
	SI_IB_WEPDMG = "武器伤害";
	SI_IB_XTRAHIT = "额外攻击";      --SI_IB_XTRAHIT = "Extra Hit Chance";
	SI_IB_RANDMG = "远程伤害";
	SI_IB_DMG = "法术伤害";
	SI_IB_ARCANEDMG = "奥术伤害";
	SI_IB_FIREDMG = "火焰伤害";
	SI_IB_FROSTDMG = "冰霜伤害";
	SI_IB_HOLYDMG = "神圣伤害";
	SI_IB_NATUREDMG = "自然伤害";
	SI_IB_SHADOWDMG = "暗影伤害";
	SI_IB_SPELLCRIT = "法术致命";
	SI_IB_SPELLTOHIT = "法术命中";
	SI_IB_HOLYCRIT = "神圣暴击";
	
	SI_IB_HEAL = "治疗量";
	SI_IB_HEALCRIT = "极效治疗";
	SI_IB_HEALTHREG = "生命回复";
	SI_IB_MANAREG = "法力回复";
	SI_IB_HEALTH = "生命值";
	SI_IB_MANA = "法力值";

	-- set bonus patterns:
	SI_IB_SET_PREFIX = "套装：";

	SI_IB_EQUIP_PATTERNS = {
		{ pattern = "钓鱼技能提高(%d+)点。", effect = "FISHING" },
		{ pattern = "+(%d+)点护甲值。", effect = "ARMOR" },
		{ pattern = "+(%d+) 攻击强度。", effect = "ATTACKPOWER" },
		{ pattern = "+(%d+) 远程攻击强度。", effect = "RANGEDATTACKPOWER" },
		{ pattern = "使你用盾牌格挡攻击的几率提高(%d+)%%。", effect = "BLOCK" },
		{ pattern = "使你躲闪攻击的几率提高(%d+)%%。", effect = "DODGE" },
		{ pattern = "使你招架攻击的几率提高(%d+)%%。", effect = "PARRY" },
		{ pattern = "使你的法术造成致命一击的几率提高(%d+)%%。", effect = "SPELLCRIT" },
		{ pattern = "使你造成致命一击的几率提高(%d+)%%。", effect = "CRIT" },
		{ pattern = "使你的远程武器造成致命一击的几率提高(%d+)%%。", effect = "RANGEDCRIT" },
		{ pattern = "使你的神圣系法术的致命一击和极效治疗几率提高(%d+)%%。", effect = "HEALCRIT" },
		{ pattern = "提高奥术法术和效果所造成的伤害，最多(%d+)点。", effect = "ARCANEDMG" },
		{ pattern = "提高火焰法术和效果所造成的伤害，最多(%d+)点。", effect = "FIREDMG" },
		{ pattern = "提高冰霜法术和效果所造成的伤害，最多(%d+)点。", effect = "FROSTDMG" },
		{ pattern = "提高神圣法术和效果所造成的伤害，最多(%d+)点。", effect = "HOLYDMG" },
		{ pattern = "提高自然法术和效果所造成的伤害，最多(%d+)点。", effect = "NATUREDMG" },
		{ pattern = "提高暗影法术和效果所造成的伤害，最多(%d+)点。", effect = "SHADOWDMG" },
		{ pattern = "使治疗法术和效果所回复的生命值提高(%d+)点。", effect = "HEAL" },
		{ pattern = "提高法术所造成的治疗效果，最多(%d+)点。", effect = "HEAL" },
		{ pattern = "提高所有法术和魔法效果所造成的伤害和治疗效果，最多(%d+)点。", effect = "HEAL" },
		{ pattern = "提高所有法术和魔法效果所造成的伤害和治疗效果，最多(%d+)点。", effect = "DMG" },
		{ pattern = "每+%d+秒恢复(%d+)点生命值。", effect = "HEALTHREG" },
		{ pattern = "每+%d+秒回复(%d+)点生命值。", effect = "HEALTHREG" },
		{ pattern = "每+%d+秒恢复(%d+)点法力值。", effect = "MANAREG" },
		{ pattern = "每+%d+秒回复(%d+)点法力值。", effect = "MANAREG" },
		{ pattern = "使你击中目标的几率提高(%d+)%%。", effect = "TOHIT" },
		{ pattern = "使你的生命值和法力值回复提高(%d+)点", effect = {"HEALTHREG", "MANAREG"} },
		{ pattern = "防御技能提高(%d+)点。", effect = "DEFENSE" },
		{ pattern = "防御提高(%d+)点。", effect = "DEFENSE" },
		{ pattern = "使你的法术击中敌人的几率提高(%d+)%%。", effect = "SPELLTOHIT" },
		{ pattern = "使你的盾牌的格挡值提高(%d+)点。", effect = "BLOCKAMT" },
		{ pattern = "击中目标后有(%d+)%%的机率获得1次额外的攻击机会。", effect = "XTRAHIT" },
		{ pattern = "使目标遭到重创，对其造成(%d+)点伤害。", effect = "HIT_WOUND" },
		{ pattern = "向目标射出一支暗影箭，对其造成%d+到(%d+)点暗影伤害。", effect = "HIT_SHADOW" },
		{ pattern = "向敌人发射一支暗影箭，对其造成(%d+)点暗影伤害。", effect = "HIT_SHADOW" },
	};


	SI_IB_S1 = {
		{ pattern = "奥术", 	effect = "ARCANE" },	
		{ pattern = "火焰", 	effect = "FIRE" },	
		{ pattern = "冰霜", 	effect = "FROST" },	
		{ pattern = "神圣", 	effect = "HOLY" },	
		{ pattern = "暗影",	effect = "SHADOW" },	
		{ pattern = "自然", 	effect = "NATURE" },
	}; 	

	SI_IB_S2 = {
		{ pattern = "抗性", 	effect = "RES" },	
		{ pattern = "伤害", 	effect = "DMG" },
		{ pattern = "效果", 	effect = "DMG" },
	}; 	
		
	SI_IB_TOKEN_EFFECT = {
		["所有属性"] 			= {"STR", "AGI", "STA", "INT", "SPI"},
		["力量"]			= "STR",
		["敏捷"]				= "AGI",
		["耐力"]				= "STA",
		["智力"]			= "INT",
		["精神"] 				= "SPI",

		["所有抗性"] 	= { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES"},
		["所有魔法抗性"] 	= { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES"},
		["钓鱼技能"]				= "FISHING",
		["鱼饵"]		= "FISHING", --new
		["提高钓鱼"]	= "FISHING", --new
		["采矿"]				= "MINING",
		["草药学"]			= "HERBALISM",
		["剥皮"]			= "SKINNING",
		["防御"]				= "DEFENSE",

		["攻击强度"] 		= "ATTACKPOWER",
		["躲避"] 				= "DODGE",
		["格挡"]				= "BLOCK",
		["盾牌格挡"]				= "BLOCKAMT", --new
		["躲闪"]			= "BLOCK",
		["命中"] 				= "TOHIT",
		["法术命中"] 				= "SPELLTOHIT",
		["远程攻击强度"] = "RANGEDATTACKPOWER",
		["生命值每+%d+秒"] = "HEALTHREG",
		["治疗法术"] 		= "HEAL", --new
		["提高治疗"] 	= "HEAL", --new
		["治疗和法术伤害"] = {"HEAL", "DMG"}, --new
		["伤害和治疗法术"] = {"HEAL", "DMG"}, --new
		["法术治疗和伤害"] = {"HEAL", "DMG"}, --new
		["法术伤害和治疗"] = {"HEAL", "DMG"},	--new
		["法力值每+%d+秒"] 	= "MANAREG",
		["法力回复"] 	= "MANAREG",
		["法术伤害"] 	= "DMG",
		["致命"] 			= "CRIT", --new
		["致命一击"] 		= "CRIT",
		["伤害"] 	= "DMG",
		["生命值"]	= "HEALTH",
		["HP"]				= "HEALTH", --new
		["法力值"]	= "MANA",
		["护甲"]				= "ARMOR",
		["强化护甲"]	= "ARMOR",
		["武器伤害"]	= "WEPDMG",

		--Scope (+X Damage) 
	};	

	SI_IB_OTHER_PATTERNS = {
		{ pattern = "每5秒恢复(%d+)点法力值。", effect = "MANAREG" },
		{ pattern = "每5秒回复(%d+)点法力值。", effect = "MANAREG" },
		{ pattern = "鱼饵 %+(%d+)（%d分钟）", effect = "FISHING" },
		{ pattern = "每%d秒回复(%d+)点生命值。", effect = "HEALTHREG" },
		{ pattern = "每%d秒恢复(%d+)点生命值。", effect = "HEALTHREG" },
		{ pattern = "赞达拉力量徽章", effect = "ATTACKPOWER", value = 30 },
		{ pattern = "赞达拉魔力徽章", effect = {"DMG", "HEAL"}, value = 18 },
		{ pattern = "赞达拉宁静徽章", effect = "HEAL", value = 33 },
		
		{ pattern = "初级巫师之油", effect = {"DMG", "HEAL"}, value = 8 },
		{ pattern = "次级巫师之油", effect = {"DMG", "HEAL"}, value = 16 },
		{ pattern = "巫师之油", effect = {"DMG", "HEAL"}, value = 24 },
		{ pattern = "卓越巫师之油", effect = {"DMG", "HEAL", "SPELLCRIT"}, value = {36, 36, 1} },

		{ pattern = "初级法力之油", effect = "MANAREG", value = 4 },
		{ pattern = "次级法力之油", effect = "MANAREG", value = 8 },
		{ pattern = "卓越法力之油", effect = { "MANAREG", "HEAL"}, value = {12, 25} },
		{ pattern = "瞄准镜（%+(%d+) 伤害）", effect = "RANDMG" },

	};

	--TRANSLATE ME
	SI_BONUSWINDOWTITLE = "装备属性加成";
	SI_ITEMSHIDE = "隐藏物品";
	SI_ITEMSSHOW = "显示物品";
	SI_ITEMBUTTON_TOOLTIP = "显示/隐藏目标的装备";
	SI_HONORHIDE = "隐藏荣誉";
	SI_HONORSHOW = "显示荣誉";
	SI_HONORBUTTON_TOOLTIP = "显示/隐藏目标的荣誉信息";
	SI_BONUSESHIDE = "隐藏属性加成";
	SI_BONUSESSHOW = "显示属性加成";
	SI_BONUSESBUTTON_TOOLTIP = "显示/隐藏目标装备的属性加成";
	SI_MOBINFOHIDE = "隐藏怪物信息";
	SI_MOBINFOSHOW = "显示怪物信息";
	SI_MOBINFOBUTTON_TOOLTIP = "显示/隐藏已知的怪物信息";
	SI_LEVEL = "等级";
	SI_NOTARGET = "你必须选定一个目标";
	SI_REQUESTHONOR = "读取荣誉信息...";
	SI_REQUESTHONORFAILED = "读取失败！(可能距离过远)";
	SI_SETS = "套装信息";
	SI_RAREELITE = ITEM_QUALITY3_DESC..ELITE;
end

--English--------------------------------------------------
-----------------------------------------------------------
if (GetLocale() == "enUS") then
	SI_DURABILITY = "Durability";

	SI_COMPARE_TOOLTIP = "Click to copy this item bonus\nto the compare window to\ncompare with another player";

	-- general
	SI_IB_TEXT = "Item Bonuses";
	SI_IB_TEXT_MISSINGDATA = "You must go to 10 Yards range to get a better bonus scan.";
	SI_TEXT_CACHEPLAYER = "Caching Player";
	SI_TEXT_CACHEPLAYERCACHED = "Player itemlist cached.";
	SI_TEXT_CACHEPLAYERFROMCACHE = "Playeritems loaded from cache.";

	SI_IB_CAT_ATT = "Attributes";
	SI_IB_CAT_RES = "Resistance";
	SI_IB_CAT_SKILL = "Skills";
	SI_IB_CAT_BON = "Combat";
	SI_IB_CAT_SBON = "Spells";
	SI_IB_CAT_OBON = "Health and Mana";
	SI_IB_CAT_COH = "Chance on Hit";
		
	-- bonus names
	SI_IB_ARMOR 	= "Reinforced Armor";

	SI_IB_FISHING	= "Fishing";
	SI_IB_MINING	= "Mining";
	SI_IB_HERBALISM	= "Herbalism";
	SI_IB_SKINNING	= "Skinning";
	SI_IB_DEFENSE	= "Defense";
		
	SI_IB_HIT_WOUND = "Wound Target for";
	SI_IB_HIT_SHADOW = "Shadowy Bolt";

	SI_IB_BLOCK = "Block Chance";
	SI_IB_DODGE = "Dodge Chance";
	SI_IB_PARRY = "Parry Chance";
	SI_IB_CRIT = "Crit. Strike";
	SI_IB_RANGEDCRIT = "Crit. Ranged";
	SI_IB_TOHIT = "Hit Chance";
	SI_IB_WEPDMG = "Weapon Damage";
	SI_IB_XTRAHIT = "Extra Hit Chance";
	SI_IB_RANDMG = "Ranged Damage";
	SI_IB_DMG = "Spell Damage";
	SI_IB_ARCANEDMG = "Arcane Damage";
	SI_IB_FIREDMG = "Fire Damage";
	SI_IB_FROSTDMG = "Frost Damage";
	SI_IB_HOLYDMG = "Holy Damage";
	SI_IB_NATUREDMG = "Nature Damage";
	SI_IB_SHADOWDMG = "Shadow Damage";
	SI_IB_SPELLCRIT = "Crit. Spell";
	SI_IB_SPELLTOHIT 	= "Spell Hit Chance";
	SI_IB_HOLYCRIT 	= "Crit. Holy Spell";
	
	SI_IB_HEAL = "Healing";
	SI_IB_HEALCRIT = "Crit. Healing";
	SI_IB_HEALTHREG = "Health Regen";
	SI_IB_MANAREG = "Mana Regen";
	SI_IB_HEALTH = "Health Points";
	SI_IB_MANA = "Mana Points";	

	-- set bonus patterns:
	SI_IB_SET_PREFIX = "Set: ";

	SI_IB_EQUIP_PATTERNS = {
		{ pattern = "+(%d+) Attack Power%.", effect = "ATTACKPOWER" },
		{ pattern = "+(%d+) ranged Attack Power%.", effect = "RANGEDATTACKPOWER" },
		{ pattern = "Increases your chance to block .+ by (%d+)%%%.", effect = "BLOCK" },
		{ pattern = "Increases your chance to dodge an attack by (%d+)%%%.", effect = "DODGE" },
		{ pattern = "Increases your chance to parry an attack by (%d+)%%%.", effect = "PARRY" },
		{ pattern = "Improves your chance to get a critical strike with spells by (%d+)%%%.", effect = "SPELLCRIT" },
		{ pattern = "Improves your chance to get a critical strike by (%d+)%%%.", effect = "CRIT" },
		{ pattern = "Improves your chance to get a critical strike with missile weapons by (%d+)%%%.", effect = "RANGEDCRIT" },
		{ pattern = "Increases the critical effect chance of your Holy spells by (%d+)%%%.", effect = "HEALCRIT" },
		{ pattern = "Increases damage done by Arcane spells and effects by up to (%d+)%.", effect = "ARCANEDMG" },
		{ pattern = "Increases damage done by Fire spells and effects by up to (%d+)%.", effect = "FIREDMG" },
		{ pattern = "Increases damage done by Frost spells and effects by up to (%d+)%.", effect = "FROSTDMG" },
		{ pattern = "Increases damage done by Holy spells and effects by up to (%d+)%.", effect = "HOLYDMG" },
		{ pattern = "Increases damage done by Nature spells and effects by up to (%d+)%.", effect = "NATUREDMG" },
		{ pattern = "Increases damage done by Shadow spells and effects by up to (%d+)%.", effect = "SHADOWDMG" },
		{ pattern = "Increases healing done by spells and effects by up to (%d+)%.", effect = "HEAL" },
		{ pattern = "Increases damage and healing done by magical spells and effects by up to (%d+)%.", effect = "HEAL" },
		{ pattern = "Increases damage and healing done by magical spells and effects by up to (%d+)%.", effect = "DMG" },
		{ pattern = "Restores (%d+) health .+ %d+ sec", effect = "HEALTHREG" },
		{ pattern = "Restores (%d+) mana .+ %d+ sec", effect = "MANAREG" },
		{ pattern = "Improves your chance to hit by (%d+)%%%.", effect = "TOHIT" },
		{ pattern = "Increases your normal health and mana regeneration by (%d+)", effect = {"HEALTHREG", "MANAREG"} },
		{ pattern = "Increased Defense %+(%d+)", effect = "DEFENSE" },
		{ pattern = "Improves your chance to hit with spells by (%d+)%%%.", effect = "SPELLTOHIT" },
		{ pattern = "Increases the block value of your shield by (%d+)", effect = "BLOCKAMT" },
		{ pattern = "(%d+)%% chance on hit to gain 1 extra attack", effect = "XTRAHIT" },
		{ pattern = "Wounds the target for (%d+) damage.", effect = "HIT_WOUND" },
		{ pattern = "Send a shadowy bolt at the enemy causing %d+ to (%d+) Shadow damage.", effect = "HIT_SHADOW" },
	};


	SI_IB_S1 = {
		{ pattern = "Arcane", 	effect = "ARCANE" },	
		{ pattern = "Fire", 	effect = "FIRE" },	
		{ pattern = "Frost", 	effect = "FROST" },	
		{ pattern = "Holy", 	effect = "HOLY" },	
		{ pattern = "Shadow",	effect = "SHADOW" },	
		{ pattern = "Nature", 	effect = "NATURE" }
	}; 	

	SI_IB_S2 = {
		{ pattern = "Resist", 	effect = "RES" },	
		{ pattern = "Damage", 	effect = "DMG" },
		{ pattern = "Effects", 	effect = "DMG" },
	}; 	
		
	SI_IB_TOKEN_EFFECT = {
		["All Stats"] 			= {"STR", "AGI", "STA", "INT", "SPI"},
		["Strength"]			= "STR",
		["Agility"]				= "AGI",
		["Stamina"]				= "STA",
		["Intellect"]			= "INT",
		["Spirit"] 				= "SPI",

		["All Resistances"] 	= { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES"},

		["Fishing"]				= "FISHING",
		["Fishing Lure"]		= "FISHING", --new
		["Increased Fishing"]	= "FISHING", --new
		["Mining"]				= "MINING",
		["Herbalism"]			= "HERBALISM",
		["Skinning"]			= "SKINNING",
		["Defense"]				= "DEFENSE",

		["Attack Power"] 		= "ATTACKPOWER",
		["Dodge"] 				= "DODGE",
		["Block"]				= "BLOCK",
		["Shield Block Value"]				= "BLOCKAMT", --new
		["Blocking"]			= "BLOCK",
		["Hit"] 				= "TOHIT",
		["Spell Hit"]			= "SPELLTOHIT",
		["Ranged Attack Power"] = "RANGEDATTACKPOWER",
		["health every %d sec"] = "HEALTHREG",
		["Healing Spells"] 		= "HEAL", --new
		["Increases Healing"] 	= "HEAL", --new
		["Healing and Spell Damage"] = {"HEAL", "DMG"}, --new
		["Damage and Healing Spells"] = {"HEAL", "DMG"}, --new
		["Spell Damage and Healing"] = {"HEAL", "DMG"},	--new
		["mana every %d sec"] 	= "MANAREG",
		["Mana Regen"] 	= "MANAREG",
		["Spell Damage"] 		= "DMG",
		["Critical"] 			= "CRIT", --new
		["Critical Hit"] 		= "CRIT",
		["Damage"] 				= "DMG",
		["Health"]				= "HEALTH",
		["HP"]				= "HEALTH", --new
		["Mana"]				= "MANA",
		["Armor"]				= "ARMOR",
		["Reinforced Armor"]	= "ARMOR",
		["Weapon Damage"]	= "WEPDMG",

		--Scope (+X Damage) 
	};	

	SI_IB_OTHER_PATTERNS = {
		{ pattern = "Mana Regen (%d+) per 5 sec%.", effect = "MANAREG" },
		{ pattern = "Zandalar Signet of Might", effect = "ATTACKPOWER", value = 30 },
		{ pattern = "Zandalar Signet of Mojo", effect = {"DMG", "HEAL"}, value = 18 },
		{ pattern = "Zandalar Signet of Serenity", effect = "HEAL", value = 33 },
		
		{ pattern = "Minor Wizard Oil", effect = {"DMG", "HEAL"}, value = 8 },
		{ pattern = "Lesser Wizard Oil", effect = {"DMG", "HEAL"}, value = 16 },
		{ pattern = "Wizard Oil", effect = {"DMG", "HEAL"}, value = 24 },
		{ pattern = "Brilliant Wizard Oil", effect = {"DMG", "HEAL", "SPELLCRIT"}, value = {36, 36, 1} },

		{ pattern = "Minor Mana Oil", effect = "MANAREG", value = 4 },
		{ pattern = "Lesser Mana Oil", effect = "MANAREG", value = 8 },
		{ pattern = "Brilliant Mana Oil", effect = { "MANAREG", "HEAL"}, value = {12, 25} },
		{ pattern = "Scope %(%+(%d+) Damage%)", effect = "RANDMG" },

	};

	--TRANSLATE ME
	SI_BONUSWINDOWTITLE = "Item Bonus Summary";
	SI_ITEMSHIDE = "Hide Items";
	SI_ITEMSSHOW = "Show Items";
	SI_ITEMBUTTON_TOOLTIP = "Toggle the display of target's inventory";
	SI_HONORHIDE = "Hide Honor";
	SI_HONORSHOW = "Show Honor";
	SI_HONORBUTTON_TOOLTIP = "Toggle the display of target's honor";
	SI_BONUSESHIDE = "Hide Bonuses";
	SI_BONUSESSHOW = "Show Bonuses";
	SI_BONUSESBUTTON_TOOLTIP = "Toggle the display of target's item bonuses";
	SI_MOBINFOHIDE = "Hide MobInfo";
	SI_MOBINFOSHOW = "Show MobInfo";
	SI_MOBINFOBUTTON_TOOLTIP = "Toggle targeted mob's information gathered";
	SI_LEVEL = "Level";
	SI_NOTARGET = "You must have a target selected";
	SI_REQUESTHONOR = "Requesting Honor Data...";
	SI_REQUESTHONORFAILED = "Request Failed\n(your target may be too far away)";
	SI_SETS = "Sets";
	SI_RAREELITE = ITEM_QUALITY3_DESC..ELITE;
end

-------------------------------
-------------------------------

SI_DURABILITYPATTERN = "^"..SI_DURABILITY.."%s(%d+)%s?/%s?(%d+)";

SI_IB_SETNAME_PATTERN = "^(.*)（%d/(%d)）$";

SI_IB_MULTISET_PREFIX = "%((%d*)%).*"..SI_IB_SET_PREFIX;

SI_IB_PREFIX_PATTERN = "^%+(%d+)%%?(.+)$";
SI_IB_SUFFIX_PATTERN = "^(.+)%+(%d+)%%?$";
SI_ITEMLINK_PATTERN = "|cff(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r";
SI_IB_EFFECTS = {
	{ effect = "STR",			name = SPELL_STAT0_NAME,		 	format = "+%d",			cat = "ATT" },
	{ effect = "AGI",			name = SPELL_STAT1_NAME, 			format = "+%d",			cat = "ATT" },
	{ effect = "STA",			name = SPELL_STAT2_NAME, 			format = "+%d",			cat = "ATT" },
	{ effect = "INT",			name = SPELL_STAT3_NAME, 			format = "+%d",			cat = "ATT" },
	{ effect = "SPI",			name = SPELL_STAT4_NAME,			format = "+%d",			cat = "ATT" },
	{ effect = "ARMOR",			name = SI_IB_ARMOR,				format = "+%d",			cat = "ATT" },

	{ effect = "ARCANERES",			name = RESISTANCE6_NAME,		format = GREEN_FONT_COLOR_CODE.."+%d",			cat = "RES" },
	{ effect = "FIRERES",			name = RESISTANCE2_NAME, 			format = GREEN_FONT_COLOR_CODE.."+%d",			cat = "RES" },
	{ effect = "NATURERES", 		name = RESISTANCE3_NAME, 		format = GREEN_FONT_COLOR_CODE.."+%d",			cat = "RES" },
	{ effect = "FROSTRES",			name = RESISTANCE4_NAME, 		format = GREEN_FONT_COLOR_CODE.."+%d",			cat = "RES" },
	{ effect = "SHADOWRES",			name = RESISTANCE5_NAME,		format = GREEN_FONT_COLOR_CODE.."+%d",			cat = "RES" },

	{ effect = "DEFENSE",			name = SI_IB_DEFENSE, 			format = "+%d",			cat = "SKILL" },
	{ effect = "MINING",			name = SI_IB_MINING,			format = "+%d",			cat = "SKILL" },
	{ effect = "HERBALISM",			name = SI_IB_HERBALISM, 		format = "+%d",			cat = "SKILL" },
	{ effect = "SKINNING", 			name = SI_IB_SKINNING, 		format = "+%d",			cat = "SKILL" },
	{ effect = "FISHING",			name = SI_IB_FISHING,			format = "+%d",			cat = "SKILL" },

	{ effect = "ATTACKPOWER", 		name = ATTACK_POWER_TOOLTIP, 		format = "+%d",			cat = "BON" },
	{ effect = "WEPDMG", 			name = SI_IB_WEPDMG, 			format = "+%d",			cat = "BON" },
	{ effect = "CRIT",			name = SI_IB_CRIT, 			format = "+%d%%",		cat = "BON" },
	{ effect = "BLOCK",			name = SI_IB_BLOCK, 			format = "+%d%%",		cat = "BON" },
	{ effect = "BLOCKAMT",			name = BLOCK, 			format = "+%d",		cat = "BON" },
	{ effect = "DODGE",			name = SI_IB_DODGE, 			format = "+%d%%",		cat = "BON" },
	{ effect = "PARRY", 			name = SI_IB_PARRY, 			format = "+%d%%",		cat = "BON" },
	{ effect = "TOHIT", 			name = SI_IB_TOHIT, 			format = "+%d%%",		cat = "BON" },
	{ effect = "XTRAHIT", 			name = SI_IB_XTRAHIT, 			format = "+%d%%",		cat = "BON" },
	{ effect = "RANDMG", 			name = SI_IB_RANDMG, 			format = "+%d",			cat = "BON" },
	{ effect = "RANGEDATTACKPOWER",		name = RANGED_ATTACK_POWER,	format = "+%d",			cat = "BON" },
	{ effect = "RANGEDCRIT",		name = SI_IB_RANGEDCRIT,		format = "+%d%%",		cat = "BON" },

	{ effect = "DMG",			name = SI_IB_DMG, 			format = "+%d",			cat = "SBON" },
	{ effect = "HEAL",			name = SI_IB_HEAL, 			format = "+%d",			cat = "SBON"},
	{ effect = "SPELLCRIT", 		name = SI_IB_SPELLCRIT,		format = "+%d%%",		cat = "SBON" },
	{ effect = "SPELLTOHIT", 		name = SI_IB_SPELLTOHIT,		format = "+%d%%",		cat = "SBON" },
	{ effect = "ARCANEDMG", 		name = SI_IB_ARCANEDMG, 		format = "+%d",			cat = "SBON" },
	{ effect = "FIREDMG", 			name = SI_IB_FIREDMG, 			format = "+%d",			cat = "SBON" },
	{ effect = "FROSTDMG",			name = SI_IB_FROSTDMG, 		format = "+%d",			cat = "SBON" },
	{ effect = "HOLYDMG",			name = SI_IB_HOLYDMG, 			format = "+%d",			cat = "SBON" },
	{ effect = "NATUREDMG",			name = SI_IB_NATUREDMG, 		format = "+%d",			cat = "SBON" },
	{ effect = "SHADOWDMG",			name = SI_IB_SHADOWDMG, 		format = "+%d",			cat = "SBON" },

	{ effect = "HEALTH",			name = SI_IB_HEALTH,			format = "+%d",			cat = "OBON" },
	{ effect = "HEALTHREG",			name = SI_IB_HEALTHREG,		format = "%d HP/5s",		cat = "OBON" },
	{ effect = "MANA",			name = SI_IB_MANA, 			format = "+%d",			cat = "OBON" },
	{ effect = "MANAREG",			name = SI_IB_MANAREG, 			format = "%d MP/5s",		cat = "OBON" },

	{ effect = "HIT_SHADOW",		name = SI_IB_HIT_SHADOW, 			format = "%d",		cat = "COH" },
	{ effect = "HIT_WOUND",			name = SI_IB_HIT_WOUND, 			format = "%d",		cat = "COH" },
};