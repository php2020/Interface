local LunaUF = LunaUF
local Cast = CreateFrame("Frame")
local L = LunaUF.L
local BS = LunaUF.BS
local CL = LunaUF.CL
LunaUF:RegisterModule(Cast, "castBar", L["Cast bar"], true)

local CasterDB = {}
local berserkValue = 0
local buffed = false
local _,playerRace = UnitRace("player")
local _,playerClass = UnitClass("player")

local DisabledZones = {
	[L["Shadow Wing Lair"]] = true,
	[L["Halls of Strife"]] = true,
}

local CHAT_PATTERNS = {
	["gains"] = {
				[1] = string.gsub(string.gsub(AURAADDEDOTHERHELPFUL,"%d%$",""), "%%s", "(.+)"),
				},								-- "(.+) gains (.+)."
	["casts"] = {
				[1] = string.gsub(string.gsub(SPELLCASTOTHERSTART,"%d%$",""), "%%s", "(.+)"), -- "(.+) begins to cast (.+)."
				[2] = string.gsub(string.gsub(SPELLPERFORMOTHERSTART,"%d%$",""), "%%s", "(.+)"), -- "(.+) begins to perform (.+)."
				},
	["afflicted"] = {
				[1] = string.gsub(string.gsub(AURAADDEDOTHERHARMFUL,"%d%$",""), "%%s", "(.+)") -- "(.+) is afflicted by (.+)."
				},
	["selfinterrupt"] = {
				[1] = string.gsub(string.gsub(string.gsub(SPELLLOGSELFOTHER,"%d%$",""),"%%d","%%d+"),"%%s","(.+)"), -- "Your (.+) hits (.+) for %d+\."
				[2] = string.gsub(string.gsub(string.gsub(SPELLLOGCRITSELFOTHER,"%d%$",""),"%%d","%%d+"),"%%s","(.+)"), -- "Your (.+) crits (.+) for %d+\."
				--[3] = string.gsub(string.gsub(SPELLINTERRUPTSELFOTHER,"%d%$",""), "%%s", "(.+)"), -- "You interrupt %s's %s."
				},
	["interrupt"] = {
				[1] = string.gsub(string.gsub(string.gsub(SPELLLOGOTHEROTHER,"%d%$",""), "%%s", "(.+)"), "%%d", "%%d+"), -- "%a+'s (.+) hits (.+) for %d+\."
				[2] = string.gsub(string.gsub(string.gsub(SPELLLOGCRITOTHEROTHER,"%d%$",""), "%%s", "(.+)"), "%%d", "%%d+"), -- "%a+'s (.+) crits (.+) for %d+\."
				--[3] = string.gsub(string.gsub(SPELLINTERRUPTOTHEROTHER,"%d%$",""), "%%s", "(.+)"), -- "%s interrupts %s's %s."
				},
}

local PFSpells = {
  ['"Plucky" Resumes Chicken Form'] = {t=1000, icon="Ability_Racial_BearForm" },
  ['憎恶喷吐'] = {t=2500, icon="Spell_Nature_CorrosiveBreath" },
  ['哈卡酸液'] = {t=1000, icon="Spell_Nature_Acid_01" },
  ['酸液喷射'] = {t=3000, icon="Spell_Nature_Acid_01" },
  ['酸液溅射'] = {t=1000, icon="INV_Drink_06" },
  ['酸液喷涌'] = {t=2000, icon="Spell_Nature_Acid_01" },
  ['激活防御'] = {t=5000, icon="Temp" },
  ['调整态度'] = {t=2000, icon="INV_Gizmo_01" },
  ['瞄准射击'] = {t=3000, icon="INV_Spear_07" },
  ['伤害增效'] = {t=2000, icon="Spell_Nature_AbolishMagic" },
  ['火焰增效'] = {t=1000, icon="Spell_Fire_Fireball" },
  ['先祖之魂'] = {t=10000, icon="Spell_Nature_Regenerate" },
  ['反魔法盾'] = {t=2000, icon="Spell_Shadow_AntiMagicShell" },
  ['使用药膏'] = {t=1300, icon="Temp" },
  ['使用诱引激素'] = {t=2500, icon="INV_Misc_Bowl_01" },
  ['放置诱饵'] = {t=4000, icon="Temp" },
  ['水下诱鱼器'] = {t=5000, icon="INV_Misc_Orb_03" },
  ['水下鱼珠'] = {t=5000, icon="INV_Misc_Spyglass_01" },
  ['Aqual Quintessence - Dowse Molten Core Rune'] = {t=1000, icon="Temp" },
  ['奥术箭'] = {t=1000, icon="Spell_Arcane_StarFire" },
  ['奥术炸弹'] = {t=1500, icon="Spell_Holy_Silence" },
  ['魔爆术'] = {t=1500, icon="Spell_Nature_WispSplode" },
  ['秘仪灵魂 II'] = {t=1000, icon="Spell_Holy_MagicalSentry" },
  ['秘仪灵魂 III'] = {t=1000, icon="Spell_Holy_MagicalSentry" },
  ['秘仪灵魂 IV'] = {t=1000, icon="Spell_Holy_MagicalSentry" },
  ['秘仪灵魂 V'] = {t=1000, icon="Spell_Holy_MagicalSentry" },
  ['奥术虚弱'] = {t=5000, icon="INV_Misc_QirajiCrystal_01" },
  ['奥金万能钥匙'] = {t=5000, icon="Temp" },
  ['Archaedas Awaken Visual'] = {t=1500, icon="Spell_Nature_Earthquake" },
  ['极地冰狼'] = {t=3000, icon="Ability_Mount_WhiteDireWolf" },
  ['区域燃烧'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['Arugal spawn-in spell'] = {t=2000, icon="Temp" },
  ['阿鲁高的礼物'] = {t=2500, icon="Spell_Shadow_ChillTouch" },
  ['亚雷戈斯的复仇'] = {t=2000, icon="Temp" },
  ['阿克鲁比的传送'] = {t=2000, icon="Spell_Fire_SelfDestruct" },
  ['阿克鲁比的开锁'] = {t=4000, icon="Spell_Nature_MoonKey" },
  ['耐普图隆的守护'] = {t=1000, icon="Temp" },
  ['星界传送'] = {t=10000, icon="Spell_Nature_AstralRecal" },
  ['Atal\'ai Altar Light Visual'] = {t=1000, icon="Temp" },
  ['瘟疫中和器'] = {t=2000, icon="Spell_Holy_SearingLight" },
  ['唤醒克罗尼亚'] = {t=4500, icon="Temp" },
  ['唤醒夺魂者'] = {t=5000, icon="Temp" },
  ['唤醒地灵宝库守卫'] = {t=5000, icon="Spell_Nature_Earthquake" },
  ['阿娜莎之箭'] = {t=500, icon="Temp" },
  ['反手一击'] = {t=1000, icon="Spell_Shadow_LifeDrain" },
  ['自然的平衡'] = {t=3000, icon="Temp" },
  ['自然的平衡失败'] = {t=10000, icon="Temp" },
  ['闪电球'] = {t=1000, icon="Spell_Lightning_LightningBolt01" },
  ['放逐术'] = {t=1500, icon="Spell_Shadow_Cripple" },
  ['放逐烈焰流放者'] = {t=1000, icon="Spell_Shadow_LifeDrain" },
  ['放逐水浪流放者'] = {t=1000, icon="Spell_Shadow_LifeDrain" },
  ['放逐雷霆流放者'] = {t=1000, icon="Spell_Shadow_LifeDrain" },
  ['女妖诅咒'] = {t=2000, icon="Spell_Nature_Drowsy" },
  ['女妖哀嚎'] = {t=1500, icon="Spell_Shadow_ShadowBolt" },
  ['光明屏障'] = {t=2000, icon="Temp" },
  ['基础营火'] = {t=10000, icon="Spell_Fire_Fire" },
  ['野兽之爪'] = {t=1000, icon="Spell_Nature_Regeneration" },
  ['野兽之爪 II'] = {t=1000, icon="Spell_Nature_Regeneration" },
  ['野兽之爪 III'] = {t=1000, icon="Spell_Nature_Regeneration" },
  ['低沉咆哮'] = {t=1500, icon="Spell_Fire_Fire" },
  ['折断胫骨'] = {t=1500, icon="Temp" },
  ['重磅青铜炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['重磅铁制炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['出生'] = {t=2000, icon="Temp" },
  ['黑箭'] = {t=2000, icon="Ability_TheBlackArrow" },
  ['黑色作战机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['黑山羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['黑泥术'] = {t=3000, icon="Spell_Shadow_CallofBone" },
  ['黑马'] = {t=3000, icon="Ability_Mount_NightmareHorse" },
  ['黑色作战科多兽'] = {t=3000, icon="Ability_Mount_Kodo_01" },
  ['黑色战羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['黑色作战迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['黑色战驹'] = {t=3000, icon="Ability_Mount_NightmareHorse" },
  ['黑色战豹'] = {t=3000, icon="Ability_Mount_BlackPanther" },
  ['黑色战狼'] = {t=3000, icon="Ability_Mount_BlackDireWolf" },
  ['黑狼'] = {t=3000, icon="Ability_Mount_BlackDireWolf" },
  ['神圣巫师之油'] = {t=3000, icon="Temp" },
  ['沙赫拉姆的祝福'] = {t=1000, icon="Spell_Holy_LayOnHands" },
  ['暴风雪'] = {t=2000, icon="Spell_Frost_IceStorm" },
  ['血性狂吼'] = {t=1000, icon="Spell_Shadow_LifeDrain" },
  ['Blue Dragon Transform DND'] = {t=1000, icon="Temp" },
  ['蓝色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['青山羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['蓝色骸骨军马'] = {t=3000, icon="Ability_Mount_Undeadhorse" },
  ['布莱队友逃跑'] = {t=10000, icon="INV_Misc_Rune_01" },
  ['炸弹'] = {t=2000, icon="Spell_Fire_SelfDestruct" },
  ['炮击术'] = {t=3000, icon="Ability_GolemStormBolt" },
  ['炮击术 II'] = {t=3000, icon="Ability_GolemStormBolt" },
  ['轰击软泥'] = {t=1000, icon="Temp" },
  ['白骨碎片'] = {t=500, icon="Spell_Shadow_ScourgeBuild" },
  ['投石'] = {t=2000, icon="Ability_Throw" },
  ['破坏大件物品'] = {t=2000, icon="Spell_Shadow_CurseOfAchimonde" },
  ['破坏物品'] = {t=2000, icon="Spell_Shadow_CurseOfAchimonde" },
  ['吐息'] = {t=5000, icon="Spell_Fire_Fire" },
  ['萨格拉斯之息'] = {t=2000, icon="Spell_Shadow_Metamorphosis" },
  ['明亮的小珠'] = {t=5000, icon="INV_Misc_Orb_03" },
  ['明亮篝火'] = {t=10000, icon="Spell_Fire_Fire" },
  ['卓越法力之油'] = {t=3000, icon="Temp" },
  ['卓越巫师之油'] = {t=3000, icon="Temp" },
  ['Brood of Nozdormu Factoin +1000'] = {t=1000, icon="Temp" },
  ['棕马'] = {t=3000, icon="Ability_Mount_RidingHorse" },
  ['棕色科多兽'] = {t=3000, icon="Ability_Mount_Kodo_03" },
  ['棕山羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['棕色骸骨军马'] = {t=3000, icon="Ability_Mount_Undeadhorse" },
  ['暗棕狼'] = {t=3000, icon="Ability_Mount_BlackDireWolf" },
  ['燃烧之风'] = {t=1000, icon="Spell_Nature_Cyclone" },
  ['钻地'] = {t=1000, icon="Ability_Vanish" },
  ['埋葬塞缪尔的遗体'] = {t=2000, icon="Temp" },
  ['快乐奶油'] = {t=1000, icon="INV_ValentinesChocolate01" },
  ['CHU\'s QUEST SPELL']={t=4000,icon='Spell_Shadow_LifeDrain'},
  ['召唤咒逐']={t=1000,icon='Temp'},
  ['召唤上古力量']={t=7000,icon='Temp'},
  ['召唤祈福']={t=1000,icon='Temp'},
  ['召唤灰色座狼']={t=1300,icon='Spell_Shadow_ChillTouch'},
  ['召唤结界雕文']={t=3000,icon='Temp'},
  ['召唤暗牙恐狼'] = {t=1300, icon="Spell_Shadow_ChillTouch" },
  ['火焰的召唤'] = {t=2000, icon="Spell_Shadow_ChillTouch" },
  ['虚空的召唤'] = {t=10000, icon="Temp" },
  ['虚空召唤'] = {t=3000, icon="Spell_Shadow_DeathCoil" },
  ['桑德的召唤'] = {t=1500, icon="Spell_Frost_Wisp" },
  ['召唤屏障'] = {t=10000, icon="Temp" },
  ['召唤被奴役的座狼'] = {t=1300, icon="Spell_Shadow_ChillTouch" },
  ['召唤伊弗斯'] = {t=10000, icon="Temp" },
  ['炮火'] = {t=1000, icon="Spell_Fire_FireBolt02" },
  ['显形卷轴'] = {t=2000, icon="Spell_Magic_LesserInvisibilty" },
  ['捕捉格拉克'] = {t=3000, icon="Temp" },
  ['捕捉座狼幼崽'] = {t=2500, icon="Temp" },
  ['收集白蚁'] = {t=5000, icon="Temp" },
  ['玫瑰凋零'] = {t=500, icon="INV_Misc_Dust_04" },
  ['闪电链'] = {t=2500, icon="Spell_Nature_ChainLightning" },
  ['法力燃烧链'] = {t=3000, icon="Spell_Shadow_ManaBurn" },
  ['治疗链'] = {t=2500, icon="Spell_Nature_HealingWaveGreater" },
  ['闪电链'] = {t=2500, icon="Spell_Nature_ChainLightning" },
  ['闪电链'] = {t=1800, icon="Spell_Nature_ChainLightning" },
  ['冰链术'] = {t=1300, icon="Spell_Frost_ChainsOfIce" },
  ['充能奥术箭'] = {t=7000, icon="Spell_Arcane_StarFire" },
  ['充能'] = {t=5000, icon="Spell_Shadow_EvilEye" },
  ['栗色马'] = {t=3000, icon="Ability_Mount_RidingHorse" },
  ['冰息术'] = {t=1000, icon="Spell_Frost_Wisp" },
  ['多彩坐骑'] = {t=3000, icon="INV_Misc_Head_Dragon_Black" },
  ['净化臭气弹']={t=5000,icon='Temp'},
  ['净化雷角水井'] = {t=10000, icon="Temp" },
  ['净化蛮鬃水井'] = {t=10000, icon="Temp" },
  ['净化冰蹄水井'] = {t=10000, icon="Temp" },
  ['顺劈斩'] = {t=2500, icon="Ability_Warrior_Cleave" },
  ['克隆'] = {t=2500, icon="Spell_Shadow_BlackPlague" },
  ['关闭'] = {t=1000, icon="Temp" },
  ['劣质炸药'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['收集群居龙蛋'] = {t=500, icon="Temp" },
  ['收集放射尘'] = {t=4000, icon="Temp" },
  ['击碎'] = {t=5000, icon="Temp" },
  ['制造召唤法阵'] = {t=10000, icon="Temp" },
  ['制造召集法阵'] = {t=10000, icon="Temp" },
  ['召唤梦境裂隙'] = {t=10000, icon="Temp" },
  ['Conjure Furis Felsteed DUMMY DND']={t=5000,icon='Temp'},
  ['神圣武器'] = {t=3000, icon="Temp" },
  ['烹制甜点'] = {t=2000, icon="Spell_Holy_Heal" },
  ['腐蚀酸液']={t=1500,icon='Spell_Nature_Acid_01'},
  ['腐蚀酸液喷溅'] = {t=3000, icon="Spell_Nature_Acid_01" },
  ['腐蚀毒药'] = {t=1500, icon="Spell_Nature_CorrosiveBreath" },
  ['酸性毒液喷溅'] = {t=2500, icon="Spell_Nature_CorrosiveBreath" },
  ['堕落的雷德帕斯'] = {t=2000, icon="Temp" },
  ['腐蚀术'] = {t=2000, icon="Spell_Shadow_AbominationExplosion" },
  ['寒冰之浪'] = {t=2000, icon="Spell_Frost_FrostNova" },
  ['制造净化图腾'] = {t=5000, icon="Spell_Shadow_LifeDrain" },
  ['制造烟花束发射器'] = {t=2000, icon="INV_Misc_EngGizmos_03" },
  ['制造封灵箱'] = {t=500, icon="Temp" },
  ['制造装满的封灵箱'] = {t=2000, icon="Temp" },
  ['制造烟花发射器'] = {t=2000, icon="INV_Musket_04" },
  ['制造治疗石'] = {t=3000, icon="INV_Stone_04" },
  ['制造强效治疗石'] = {t=3000, icon="INV_Stone_04" },
  ['制造次级治疗石'] = {t=3000, icon="INV_Stone_04" },
  ['制造特效治疗石'] = {t=3000, icon="INV_Stone_04" },
  ['制造初级治疗石'] = {t=3000, icon="INV_Stone_04" },
  ['Create Item Visual (DND)']={t=5000,icon='Spell_Shadow_SoulGem'},
  ['制造法师的宝珠'] = {t=4000, icon="Temp" },
  ['制造法师的长袍'] = {t=4000, icon="Temp" },
  ['制造PX83型密码机'] = {t=2000, icon="INV_Misc_Bowl_01" },
  ['制造遗物包裹'] = {t=1000, icon="Temp" },
  ['制造裂隙'] = {t=3000, icon="Temp" },
  ['制造灵契'] = {t=3000, icon="INV_Misc_Food_09" },
  ['制造卷轴'] = {t=5000, icon="INV_Scroll_05" },
  ['创造占卜之碗'] = {t=2500, icon="INV_Misc_Bowl_01" },
  ['制造伐木机'] = {t=1000, icon="INV_Misc_Gear_01" },
  ['制造先知之水'] = {t=5000, icon="Spell_Shadow_LifeDrain" },
  ['制造枯木图腾束'] = {t=2000, icon="Spell_Lightning_LightningBolt01" },
  ['CreatureSpecial']={t=2000,icon='Temp'},
  ['慢性毒药']={t=2000,icon='Spell_Nature_NullifyPoison'},
  ['慢性毒菌']={t=3000,icon='Spell_Shadow_CreepingPlague'},
  ['惩戒之盾']={t=1000,icon='INV_Shield_19'},
  ['残废术'] = {t=3000, icon="Spell_Shadow_Cripple" },
  ['致残毒药'] = {t=3000, icon="Ability_PoisonSting" },
  ['地穴甲虫'] = {t=1500, icon="Spell_Shadow_CarrionSwarm" },
  ['水晶闪耀'] = {t=2000, icon="Spell_Shadow_Teleport" },
  ['水晶凝视'] = {t=2000, icon="Ability_GolemThunderClap" },
  ['水晶沉睡'] = {t=2000, icon="Spell_Nature_Sleep" },
  ['丘比特之箭'] = {t=1000, icon="Temp" },
  ['治愈疾病'] = {t=2500, icon="Spell_Holy_NullifyDisease" },
  ['血之诅咒'] = {t=2000, icon="Spell_Shadow_RitualOfSacrifice" },
  ['哈卡的诅咒'] = {t=2500, icon="Spell_Shadow_GatherShadows" },
  ['治疗诅咒'] = {t=1000, icon="Spell_Shadow_AntiShadow" },
  ['沙赫拉姆诅咒'] = {t=1000, icon="Spell_Magic_LesserInvisibilty" },
  ['斯塔文的诅咒'] = {t=1000, icon="Spell_Shadow_ShadowPact" },
  ['黑暗主宰诅咒'] = {t=2000, icon="Spell_Shadow_AntiShadow" },
  ['死木诅咒'] = {t=2000, icon="Spell_Shadow_GatherShadows" },
  ['玛格拉姆灵魂诅咒'] = {t=2000, icon="Spell_Shadow_UnholyFrenzy" },
  ['火印诅咒'] = {t=2000, icon="Ability_Creature_Cursed_03" },
  ['瘟疫鼠诅咒'] = {t=1500, icon="Spell_Shadow_UnholyFrenzy" },
  ['部族诅咒'] = {t=2000, icon="Spell_Shadow_CurseOfMannoroth" },
  ['荆棘诅咒'] = {t=2000, icon="Spell_Shadow_AntiShadow" },
  ['图勒的诅咒'] = {t=2000, icon="Spell_Shadow_ShadowPact" },
  ['提米的诅咒'] = {t=1000, icon="Spell_Shadow_ShadowPact" },
  ['虚弱诅咒'] = {t=1000, icon="Spell_Shadow_CurseOfMannoroth" },
  ['达拉然巫师伪装'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['伤害车辆'] = {t=2000, icon="Spell_Fire_Fire" },
  ['黑色欲望'] = {t=1000, icon="INV_ValentinesChocolate04" },
  ['黑铁炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['黑铁矮人伪装'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['黑铁地雷'] = {t=1000, icon="Spell_Shadow_Metamorphosis" },
  ['黑暗治疗'] = {t=3500, icon="Spell_Shadow_ChillTouch" },
  ['黑暗回复'] = {t=2000, icon="Ability_Hunter_MendPet" },
  ['黑暗污泥'] = {t=5000, icon="Spell_Shadow_CreepingPlague" },
  ['黑暗耳语'] = {t=3000, icon="Spell_Shadow_Haunting" },
  ['暗淡幻象'] = {t=2000, icon="Spell_Shadow_Fumble" },
  ['威吓低吼'] = {t=1000, icon="Ability_Racial_Cannibalize" },
  ['黎明先锋'] = {t=1500, icon="Temp" },
  ['致命毒药'] = {t=3000, icon="Ability_Rogue_DualWeild" },
  ['致命毒药 II'] = {t=3000, icon="Ability_Rogue_DualWeild" },
  ['致命毒药 III'] = {t=3000, icon="Ability_Rogue_DualWeild" },
  ['致命毒药 IV'] = {t=3000, icon="Ability_Rogue_DualWeild" },
  ['致命毒药 V'] = {t=3000, icon="Ability_Rogue_DualWeild" },
  ['死亡矿井炸药'] = {t=2000, icon="Spell_Fire_SelfDestruct" },
  ['死亡凋零'] = {t=2000, icon="Spell_Shadow_DeathAndDecay" },
  ['死亡之床'] = {t=2000, icon="Spell_Shadow_Twilight" },
  ['黑色骷髅战马'] = {t=3000, icon="Ability_Mount_Undeadhorse" },
  ['敏捷衰减'] = {t=2000, icon="Spell_Holy_HarmUndeadAura" },
  ['力量衰减'] = {t=2000, icon="Spell_Holy_HarmUndeadAura" },
  ['深度沉睡'] = {t=1000, icon="Spell_Shadow_Cripple" },
  ['迪菲亚盗贼伪装'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['电击'] = {t=4000, icon="Spell_Nature_Purge" },
  ['Delete Me'] = {t=4000, icon="INV_Scroll_02" },
  ['恶魔之锄'] = {t=5000, icon="Temp" },
  ['恶魔之门']={t=500,icon='Spell_Arcane_TeleportOrgrimmar'},
  ['恶魔召唤火炬']={t=3000,icon='Temp'},
  ['致密炸弹']={t=1000,icon='Spell_Fire_SelfDestruct'},
  ['摧毁蛋']={t=3000,icon='INV_Misc_MonsterClaw_02'},
  ['摧毁幽灵磁铁箱']={t=10000,icon='Temp'},
  ['摧毁帐篷']={t=2500,icon='Temp'},
  ['自爆']={t=2000,icon='Temp'},
  ['自爆']={t=5000,icon='Spell_Fire_SelfDestruct'},
  ['挖掘钴矿'] = {t=1500, icon="Temp" },
  ['次元之门'] = {t=2000, icon="Temp" },
  ['恐怖低吼'] = {t=1000, icon="Ability_Racial_Cannibalize" },
  ['暗灰狼'] = {t=3000, icon="Ability_Mount_WhiteDireWolf" },
  ['解除陷阱'] = {t=2000, icon="Spell_Shadow_GrimWard" },
  ['疾病猛击'] = {t=1500, icon="Spell_Nature_EarthBind" },
  ['疾病射击'] = {t=2000, icon="Spell_Shadow_CallofBone" },
  ['疾病软泥'] = {t=2000, icon="Spell_Shadow_CreepingPlague" },
  ['疾病喷吐'] = {t=3000, icon="Spell_Shadow_CreepingPlague" },
  ['分解'] = {t=3000, icon="Spell_Holy_RemoveCurse" },
  ['解散野兽'] = {t=5000, icon="Spell_Nature_SpiritWolf" },
  ['驱散'] = {t=1000, icon="Spell_Holy_DispelMagic" },
  ['驱散毒药'] = {t=2000, icon="Spell_Holy_Purify" },
  ['封闭时空裂隙'] = {t=5000, icon="Temp" },
  ['瓦解'] = {t=3000, icon="Temp" },
  ['干扰群居龙蛋'] = {t=1000, icon="Temp" },
  ['占卜沉思'] = {t=5000, icon="Temp" },
  ['统御意志'] = {t=2000, icon="Spell_Shadow_ShadowWordDominate" },
  ['支配'] = {t=1000, icon="Spell_Shadow_ShadowWordDominate" },
  ['灵魂支配'] = {t=3000, icon="Spell_Shadow_ShadowWordDominate" },
  ['熄灭'] = {t=5000, icon="Temp" },
  ['熄灭永恒之火'] = {t=1000, icon="Temp" },
  ['龙灵采集器900型'] = {t=2000, icon="Temp" },
  ['绘制上古雕文'] = {t=10000, icon="Temp" },
  ['希斯耐特吸血术'] = {t=2000, icon="Spell_Shadow_Haunting" },
  ['绘图工具包'] = {t=7000, icon="Temp" },
  ['喝下初级药水'] = {t=3000, icon="Spell_Holy_Heal" },
  ['喝药水'] = {t=3000, icon="Spell_Holy_Heal" },
  ['放置尼姆布亚的长矛'] = {t=2000, icon="Temp" },
  ['德鲁伊的睡眠'] = {t=2500, icon="Spell_Nature_Sleep" },
  ['醉酒的车队员工'] = {t=2000, icon="Temp" },
  ['Dummy NPC Summon'] = {t=20000, icon="Spell_Shadow_UnsummonBuilding" },
  ['假人轰炸'] = {t=2000, icon="Temp" },
  ['灰尘之云'] = {t=1500, icon="Ability_Hibernation" },
  ['炸药'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['土元素'] = {t=3000, icon="Ability_Temp" },
  ['陷地图腾']={t=500,icon='Spell_Nature_NatureTouchDecay'},
  ['Editor Test Spell']={t=250,icon='Temp'},
  ['蜜饯馅饼']={t=1000,icon='INV_Misc_Food_10'},
  ['充电网'] = {t=500, icon="Ability_Ensnare" },
  ['元素护甲'] = {t=1000, icon="Spell_Frost_Frost" },
  ['元素火焰'] = {t=500, icon="Spell_Fire_Fireball02" },
  ['元素之怒'] = {t=1000, icon="Spell_Fire_FireArmor" },
  ['艾露恩的蜡烛'] = {t=500, icon="Temp" },
  ['Emberseer Start']={t=5000,icon='Spell_Nature_EarthBindTotem'},
  ['绿色迅猛龙']={t=3000,icon='Ability_Mount_Raptor'},
  ['强化宠物']={t=500,icon='Spell_Shadow_DeathPact'},
  ['空空如也的节日酒杯']={t=2000,icon='Temp'},
  ['Encage']={t=2000,icon='Spell_Shadow_Teleport'},
  ['覆体之网']={t=2000,icon='Spell_Nature_EarthBind'},
  ['附魔达隆郡的历史']={t=3500,icon='Temp'},
  ['附有魔法的盖亚之种']={t=5000,icon='Temp'},
  ['魔化迅捷'] = {t=3000, icon="Spell_Nature_Invisibilty" },
  ['魔化共鸣水晶'] = {t=5000, icon="Temp" },
  ['催眠曲'] = {t=1000, icon="Spell_Shadow_SoothingKiss" },
  ['能量虹吸'] = {t=1500, icon="Spell_Shadow_Cripple" },
  ['弱化'] = {t=1500, icon="Ability_Creature_Poison_03" },
  ['削弱'] = {t=2000, icon="Spell_Shadow_CurseOfMannoroth" },
  ['吞噬之影'] = {t=1500, icon="Spell_Shadow_LifeDrain02" },
  ['增强钝器'] = {t=3000, icon="Temp" },
  ['增强钝器 II'] = {t=3000, icon="Temp" },
  ['增强钝器 III'] = {t=3000, icon="Temp" },
  ['增强钝器 IV'] = {t=3000, icon="Temp" },
  ['增强钝器 V'] = {t=3000, icon="Temp" },
  ['巨化术'] = {t=2000, icon="Spell_Nature_Strength" },
  ['启迪'] = {t=2000, icon="Spell_Shadow_Fumble" },
  ['奴役恶魔'] = {t=3000, icon="Spell_Shadow_EnslaveDemon" },
  ['纠缠根须'] = {t=1500, icon="Spell_Nature_StrangleVines" },
  ['包围之风'] = {t=2000, icon="Spell_Nature_Cyclone" },
  ['逃命专家'] = {t=500, icon="Ability_Rogue_Trip" },
  ['永望镇传送'] = {t=10000, icon="Spell_Fire_SelfDestruct" },
  ['邪恶之眼'] = {t=1500, icon="Spell_Shadow_Charm" },
  ['邪神法术反制'] = {t=300000, icon="Temp" },
  ['埃提耶什驱魔'] = {t=20000, icon="Temp" },
  ['驱除灵魂'] = {t=4000, icon="Temp" },
  ['爆炸射击'] = {t=1000, icon="Spell_Fire_Fireball02" },
  ['自爆绵羊'] = {t=2000, icon="Ability_Repair" },
  ['爆炸射击'] = {t=1000, icon="Spell_Fire_Fireball02" },
  ['熄灭'] = {t=2000, icon="Temp" },
  ['眼棱'] = {t=2000, icon="Spell_Nature_CallStorm" },
  ['伊莫塔尔之眼'] = {t=2000, icon="Spell_Shadow_AntiMagicShell" },
  ['基尔罗格之眼'] = {t=5000, icon="Spell_Shadow_EvilEye" },
  ['Eye of Yesmur (PT)'] = {t=2000, icon="Temp" },
  ['野兽之眼'] = {t=2000, icon="Ability_EyeOfTheOwl" },
  ['简易投掷炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['精灵之火'] = {t=2000, icon="Spell_Nature_FaerieFire" },
  ['佯射'] = {t=2000, icon="Ability_Marksmanship" },
  ['狂热之刃'] = {t=1000, icon="Spell_Fire_Immolation" },
  ['视界术'] = {t=2000, icon="Spell_Nature_FarSight" },
  ['视界术'] = {t=2000, icon="Temp" },
  ['恐惧术'] = {t=1500, icon="Spell_Shadow_Possession" },
  ['恐惧术'] = {t=3000, icon="Spell_Shadow_Possession" },
  ['精神衰弱'] = {t=1000, icon="Spell_Shadow_MindSteal" },
  ['精神衰弱 II'] = {t=1000, icon="Spell_Shadow_MindSteal" },
  ['精神衰弱 III'] = {t=1000, icon="Spell_Shadow_MindSteal" },
  ['恶魔诅咒'] = {t=4000, icon="Temp" },
  ['菲斯托姆复活'] = {t=3000, icon="Spell_Totem_WardOfDraining" },
  ['野性幽魂'] = {t=3000, icon="Spell_Nature_SpiritWolf" },
  ['野兽幽魂 II'] = {t=3000, icon="Spell_Nature_SpiritWolf" },
  ['热疫疲倦'] = {t=3000, icon="Spell_Nature_NullifyDisease" },
  ['热疫'] = {t=4500, icon="Spell_Nature_NullifyDisease" },
  ['炽热火焰'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['火焰爆发'] = {t=1500, icon="Spell_Fire_FireBolt" },
  ['装满瓶子'] = {t=5000, icon="Temp" },
  ['装填'] = {t=3000, icon="Temp" },
  ['寻找遗物碎片'] = {t=5000, icon="Temp" },
  ['火炮'] = {t=2000, icon="Temp" },
  ['火元素'] = {t=3000, icon="Ability_Temp" },
  ['火焰之盾'] = {t=1000, icon="Spell_Fire_Immolation" },
  ['火焰之盾 II'] = {t=1000, icon="Spell_Fire_Immolation" },
  ['火焰之盾 III'] = {t=1000, icon="Spell_Fire_Immolation" },
  ['火焰之盾 IV'] = {t=1000, icon="Spell_Fire_Immolation" },
  ['火焰风暴'] = {t=2000, icon="Spell_Fire_SelfDestruct" },
  ['火焰虚弱'] = {t=5000, icon="INV_Misc_QirajiCrystal_02" },
  ['火烤甜面包'] = {t=1000, icon="INV_Misc_Food_11" },
  ['火球术'] = {t=3500, icon="Spell_Fire_FlameBolt" },
  ['连珠火球'] = {t=3000, icon="Spell_Fire_FlameBolt" },
  ['火焰箭'] = {t=2000, icon="Spell_Fire_FireBolt" },
  ['火焰箭 II'] = {t=3000, icon="Spell_Fire_FireBolt02" },
  ['火焰箭 III'] = {t=3000, icon="Spell_Fire_FireBolt02" },
  ['火焰箭 IV'] = {t=3000, icon="Spell_Fire_FireBolt02" },
  ['爆竹'] = {t=500, icon="Temp" },
  ['急救'] = {t=3000, icon="Spell_Holy_GreaterHeal" },
  ['沙赫拉姆之拳'] = {t=1000, icon="Ability_Whirlwind" },
  ['Fix Ritual Bell (DND)'] = {t=3000, icon="Temp" },
  ['Fix Ritual Candle (DND)'] = {t=3000, icon="Temp" },
  ['Fix Ritual Node (DND)'] = {t=3000, icon="Temp" },
  ['烈焰冲击'] = {t=7000, icon="Spell_Fire_SelfDestruct" },
  ['火息术'] = {t=1700, icon="Spell_Fire_Fire" },
  ['烈焰打击'] = {t=2200, icon="Spell_Fire_Fireball" },
  ['烈焰爆击'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['烈焰火炮'] = {t=1500, icon="Spell_Fire_FlameBolt" },
  ['烈焰鞭笞'] = {t=1000, icon="Spell_Fire_Fireball" },
  ['烈焰尖刺'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['烈焰喷射'] = {t=1700, icon="Spell_Fire_Fire" },
  ['火焰破裂'] = {t=2500, icon="Spell_Fire_Fire" },
  ['混乱烈焰'] = {t=1000, icon="Spell_Fire_WindsofWoe" },
  ['惩戒烈焰'] = {t=3000, icon="Temp" },
  ['沙赫拉姆烈焰'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['烈焰喷溅'] = {t=3000, icon="Spell_Fire_FlameBolt" },
  ['烈焰风暴'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['快速治疗'] = {t=1500, icon="Spell_Holy_FlashHeal" },
  ['圣光闪现'] = {t=1500, icon="Spell_Holy_FlashHeal" },
  ['食腐虫'] = {t=5000, icon="INV_Misc_Orb_03" },
  ['投掷火炬'] = {t=1000, icon="Spell_Fire_Flare" },
  ['绿色荧光机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['专注'] = {t=5000, icon="Temp" },
  ['重击'] = {t=1000, icon="INV_Gauntlets_31" },
  ['铸造维里甘之拳'] = {t=600, icon="Spell_Holy_RighteousFury" },
  ['宽恕'] = {t=1000, icon="Temp" },
  ['叉状闪电'] = {t=2000, icon="Spell_Nature_ChainLightning" },
  ['Form of the Moonstalker (no invis)'] = {t=1000, icon="Ability_Hibernation" },
  ['遗弃技能'] = {t=2500, icon="Spell_Shadow_AntiShadow" },
  ['冰冻术'] = {t=4000, icon="Spell_Frost_Glacier" },
  ['冰冻龙蛋'] = {t=500, icon="Temp" },
  ['冰冻龙蛋 - 初号机'] = {t=500, icon="Temp" },
  ['冰霜凝固'] = {t=2500, icon="Spell_Frost_Glacier" },
  ['惊骇之爪'] = {t=1000, icon="Spell_Shadow_ShadowPact" },
  ['冰息术'] = {t=250, icon="Spell_Frost_FrostNova" },
  ['冰霜灼烧'] = {t=2000, icon="Spell_Frost_ChillingBlast" },
  ['冰霜之油'] = {t=3000, icon="Temp" },
  ['霜山羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['冰霜抗性'] = {t=1000, icon="Spell_Frost_WizardMark" },
  ['冰霜虚弱'] = {t=5000, icon="INV_Misc_QirajiCrystal_04" },
  ['寒冰箭'] = {t=3000, icon="Spell_Frost_FrostBolt02" },
  ['连发寒冰箭'] = {t=2000, icon="Spell_Frost_FrostBolt02" },
  ['霜鬃之力'] = {t=1000, icon="Spell_Nature_UndyingStrength" },
  ['霜刃豹'] = {t=3000, icon="Ability_Mount_WhiteTiger" },
  ['霜狼嗥叫者'] = {t=3000, icon="Ability_Mount_WhiteDireWolf" },
  ['全效治疗'] = {t=1000, icon="Temp" },
  ['迟钝术'] = {t=1000, icon="Spell_Shadow_Fumble" },
  ['迟钝术 II'] = {t=1000, icon="Spell_Shadow_Fumble" },
  ['迟钝术 III'] = {t=1000, icon="Spell_Shadow_Fumble" },
  ['熊怪形态'] = {t=2000, icon="INV_Misc_MonsterClaw_04" },
  ['石像鬼打击'] = {t=1500, icon="Spell_Shadow_ShadowBolt" },
  ['毒气炸弹'] = {t=1000, icon="INV_Misc_Ammo_Bullet_01" },
  ['毒蛇宝石'] = {t=5000, icon="Temp" },
  ['幽魂之狼'] = {t=3000, icon="Spell_Nature_SpiritWolf" },
  ['萨维亚的赐福'] = {t=5000, icon="Spell_Holy_FlashHeal" },
  ['寒冰咆哮'] = {t=1000, icon="Spell_Frost_FrostNova" },
  ['闪耀'] = {t=500, icon="Temp" },
  ['侏儒摄像头连接'] = {t=3000, icon="Temp" },
  ['侏儒传送器'] = {t=10000, icon="Temp" },
  ['地精摄像头连接'] = {t=3000, icon="Temp" },
  ['地精暗雷'] = {t=1000, icon="Spell_Shadow_Metamorphosis" },
  ['地精迫击炮'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['铜锣'] = {t=500, icon="Temp" },
  ['敲打祖尔法拉克铜锣'] = {t=500, icon="Temp" },
  ['戈多克绿酒'] = {t=1000, icon="INV_Drink_03" },
  ['缠绕之藤'] = {t=1000, icon="Spell_Nature_Earthquake" },
  ['灰色科多兽'] = {t=3000, icon="Ability_Mount_Kodo_01" },
  ['灰山羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['灰狼'] = {t=3000, icon="Ability_Mount_WhiteDireWolf" },
  ['迅捷棕色科多兽'] = {t=3000, icon="Ability_Mount_Kodo_03" },
  ['迅捷灰色科多兽'] = {t=3000, icon="Ability_Mount_Kodo_01" },
  ['强效治疗术'] = {t=4000, icon="Spell_Holy_Heal" },
  ['迅捷白色科多兽'] = {t=3000, icon="Ability_Mount_Kodo_01" },
  ['强力驱散'] = {t=4000, icon="Spell_Arcane_StarFire" },
  ['强效治疗术'] = {t=3000, icon="Spell_Holy_GreaterHeal" },
  ['强效隐形'] = {t=3000, icon="Spell_Nature_Invisibilty" },
  ['Green Dragon Transform DND'] = {t=1000, icon="Temp" },
  ['绿色科多兽'] = {t=3000, icon="Ability_Mount_Kodo_02" },
  ['绿色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['绿色骸骨战马'] = {t=3000, icon="Ability_Mount_Undeadhorse" },
  ['格罗姆的祭品'] = {t=2000, icon="Temp" },
  ['迅猛龙的狡诈'] = {t=3000, icon="INV_Misc_MonsterClaw_02" },
  ['阵风'] = {t=2000, icon="Spell_Nature_EarthBind" },
  ['愤怒之锤'] = {t=1000, icon="Ability_ThunderClap" },
  ['伊鲁克斯之手'] = {t=5000, icon="Temp" },
  ['收集异种蝎卵'] = {t=5000, icon="Temp" },
  ['收割蜂群'] = {t=3000, icon="Spell_Holy_Dizzy" },
  ['鬼魅幻影'] = {t=2000, icon="Spell_Shadow_BlackPlague" },
  ['鬼魅灵魂'] = {t=2000, icon="Spell_Shadow_BlackPlague" },
  ['治疗术'] = {t=3000, icon="Spell_Holy_Heal02" },
  ['Heal Visual'] = {t=3500, icon="Spell_Holy_Heal" },
  ['治疗藤蔓'] = {t=500, icon="Temp" },
  ['治疗之环'] = {t=3000, icon="Spell_Holy_BlessingOfProtection" },
  ['治疗之舌'] = {t=1000, icon="Spell_Holy_Heal" },
  ['治疗之舌 II'] = {t=1000, icon="Spell_Holy_Heal" },
  ['治疗之触'] = {t=3500, icon="Spell_Nature_HealingTouch" },
  ['治疗结界'] = {t=2000, icon="Spell_Holy_LayOnHands" },
  ['治疗波'] = {t=3000, icon="Spell_Nature_MagicImmunity" },
  ['安图苏尔的治疗波'] = {t=1000, icon="Spell_Holy_Heal02" },
  ['Heart of Hakkar - Molthor chucks the heart'] = {t=2000, icon="Temp" },
  ['炉石'] = {t=10000, icon="INV_Misc_Rune_01" },
  ['烈性炸药'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['察觉'] = {t=1000, icon="Temp" },
  ['地狱烈焰'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['地狱烈焰 II'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['地狱烈焰 III'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['采集草药'] = {t=5000, icon="Spell_Nature_NatureTouchGrow" },
  ['妖术'] = {t=2000, icon="Spell_Nature_Polymorph" },
  ['鸦爪妖术'] = {t=2000, icon="Spell_Shadow_Charm" },
  ['高爆炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['休眠'] = {t=1500, icon="Spell_Nature_Sleep" },
  ['神圣之火'] = {t=3500, icon="Spell_Holy_SearingLight" },
  ['圣光术'] = {t=2500, icon="Spell_Holy_HolyBolt" },
  ['圣光击'] = {t=2500, icon="Spell_Holy_HolySmite" },
  ['神圣愤怒'] = {t=2000, icon="Spell_Holy_Excorcism" },
  ['荣誉点数+138'] = {t=1000, icon="Temp" },
  ['荣誉点数+228'] = {t=1000, icon="Temp" },
  ['荣誉点数+2388'] = {t=1000, icon="INV_BannerPVP_02" },
  ['荣誉点数+378'] = {t=1000, icon="Temp" },
  ['荣誉点数+398'] = {t=1000, icon="Temp" },
  ['荣誉点数+50'] = {t=1000, icon="Temp" },
  ['荣誉点数+82'] = {t=1000, icon="Temp" },
  ['钩网'] = {t=500, icon="Ability_Ensnare" },
  ['恐惧嚎叫'] = {t=2000, icon="Spell_Shadow_DeathScream" },
  ['嚎叫之怒'] = {t=5000, icon="Ability_BullRush" },
  ['寒冰之墓'] = {t=1500, icon="Spell_Frost_Glacier" },
  ['冰霜箭'] = {t=2000, icon="Spell_Frost_FrostBolt02" },
  ['冰柱'] = {t=1500, icon="Spell_Frost_FrostBolt02" },
  ['冰蓝色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['鉴定种类'] = {t=10000, icon="Spell_Lightning_LightningBolt01" },
  ['点燃躯体'] = {t=2000, icon="Spell_Fire_Fire" },
  ['点燃克罗苏斯'] = {t=3000, icon="Temp" },
  ['伊克鲁德的守护者'] = {t=5000, icon="Spell_Shadow_SummonVoidWalker" },
  ['Imbue Chest - Absorb'] = {t=5000, icon="Spell_Holy_GreaterHeal" },
  ['Imbue Chest - Lesser Absorb'] = {t=5000, icon="Spell_Holy_GreaterHeal" },
  ['浸魔胸甲 - 次级精神'] = {t=5000, icon="Spell_Holy_GreaterHeal" },
  ['Imbue Chest - Minor Spirit'] = {t=5000, icon="Spell_Holy_GreaterHeal" },
  ['浸魔披风 - 次级防护'] = {t=5000, icon="Spell_Holy_GreaterHeal" },
  ['Imbue Cloak - Minor Resistance'] = {t=5000, icon="Spell_Holy_GreaterHeal" },
  ['浸魔武器 - 屠兽'] = {t=5000, icon="Spell_Holy_GreaterHeal" },
  ['献祭'] = {t=2000, icon="Spell_Fire_Immolation" },
  ['内爆'] = {t=10000, icon="Spell_Fire_SelfDestruct" },
  ['火岩粉'] = {t=5000, icon="Temp" },
  ['焚烧'] = {t=2000, icon="Spell_Shadow_ChillTouch" },
  ['焚化'] = {t=5000, icon="Temp" },
  ['提高声望'] = {t=1000, icon="Temp" },
  ['诱导幻象'] = {t=30000, icon="Spell_Shadow_LifeDrain" },
  ['地狱火'] = {t=2000, icon="Spell_Shadow_SummonInfernal" },
  ['地狱火罩'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['墨汁喷射'] = {t=1000, icon="Spell_Nature_Sleep" },
  ['速效毒药'] = {t=3000, icon="Ability_Poisons" },
  ['速效毒药 II'] = {t=3000, icon="Ability_Poisons" },
  ['速效毒药 III'] = {t=3000, icon="Ability_Poisons" },
  ['速效毒药 IV'] = {t=3000, icon="Ability_Poisons" },
  ['速效毒药 V'] = {t=3000, icon="Ability_Poisons" },
  ['速效毒药 VI'] = {t=3000, icon="Ability_Poisons" },
  ['速效毒素'] = {t=3000, icon="INV_Potion_19" },
  ['Instill Lord Valthalak\'s Spirit DND'] = {t=5000, icon="Temp" },
  ['剧烈痛楚'] = {t=1000, icon="Spell_Shadow_ShadowWordPain" },
  ['破胆低吼'] = {t=1000, icon="Ability_Racial_Cannibalize" },
  ['Invis Placing Bear Trap'] = {t=2000, icon="Temp" },
  ['隐形术'] = {t=3000, icon="Spell_Nature_Invisibilty" },
  ['铁皮手雷'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['白色迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['Ivus Teleport Visual DND'] = {t=1000, icon="Temp" },
  ['J\'eevee summons object'] = {t=2000, icon="Temp" },
  ['加卡尔的翻译'] = {t=4500, icon="Spell_Holy_Restoration" },
  ['朱莉叶的祝福'] = {t=2000, icon="Spell_Holy_Renew" },
  ['跳跃闪电'] = {t=3000, icon="Spell_Nature_Lightning" },
  ['卡德拉克的旗子'] = {t=2000, icon="INV_Banner_03" },
  ['卡拉然合成火炬'] = {t=1000, icon="Temp" },
  ['Kev'] = {t=3000, icon="Spell_Fire_FireBolt" },
  ['卡德加开锁术'] = {t=10000, icon="INV_Misc_Key_14" },
  ['戈多克之王'] = {t=1000, icon="INV_Crown_02" },
  ['科多兽诱引器'] = {t=5000, icon="Trade_Fishing" },
  ['克雷格的烈酒'] = {t=1000, icon="INV_Drink_05" },
  ['大型铜壳炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['大型爆盐炸弹'] = {t=5000, icon="Temp" },
  ['棕狼'] = {t=3000, icon="Ability_Mount_BlackDireWolf" },
  ['黑斑黄豹'] = {t=3000, icon="Ability_Mount_JungleTiger" },
  ['麻风病治愈！'] = {t=2000, icon="Spell_Holy_FlashHeal" },
  ['次级治疗术'] = {t=2500, icon="Spell_Holy_LesserHeal" },
  ['次级治疗波'] = {t=1500, icon="Spell_Nature_HealingWaveLesser" },
  ['次级隐形术'] = {t=3000, icon="Spell_Magic_LesserInvisibilty" },
  ['次级法力之油'] = {t=3000, icon="Temp" },
  ['次级巫师之油'] = {t=3000, icon="Temp" },
  ['致死毒素'] = {t=3000, icon="Spell_Nature_CorrosiveBreath" },
  ['生命收割'] = {t=1000, icon="Spell_Shadow_Requiem" },
  ['生命偷取'] = {t=1500, icon="Spell_Shadow_LifeDrain02" },
  ['生命封印'] = {t=2000, icon="Temp" },
  ['闪电震爆'] = {t=3200, icon="Spell_Nature_Lightning" },
  ['闪电箭'] = {t=3000, icon="Spell_Nature_Lightning" },
  ['闪电吐息'] = {t=2000, icon="Spell_Nature_Lightning" },
  ['落雷之云'] = {t=3000, icon="Spell_Nature_CallStorm" },
  ['闪电图腾'] = {t=500, icon="Spell_Nature_Lightning" },
  ['光明之泉'] = {t=1500, icon="Spell_Holy_SummonLightwell" },
  ['林克的回旋镖'] = {t=500, icon="INV_Weapon_ShortBlade_10" },
  ['蜥蜴之矢'] = {t=2000, icon="Spell_Nature_Lightning" },
  ['虫群风暴'] = {t=3000, icon="Spell_Nature_InsectSwarm" },
  ['长程射击 II'] = {t=4000, icon="Ability_Marksmanship" },
  ['长程射击 III'] = {t=4000, icon="Ability_Marksmanship" },
  ['长视术'] = {t=1000, icon="Ability_TownWatch" },
  ['月光林地邀请'] = {t=5000, icon="Spell_Arcane_TeleportMoonglade" },
  ['机关枪'] = {t=500, icon="Ability_Marksmanship" },
  ['玛加萨火岩粉'] = {t=1300, icon="Temp" },
  ['法师视界'] = {t=3000, icon="Temp" },
  ['熔岩冲击'] = {t=1000, icon="Spell_Fire_FlameShock" },
  ['Majordomo Teleport Visual'] = {t=1000, icon="Spell_Arcane_Blink" },
  ['法力燃烧'] = {t=3000, icon="Spell_Shadow_ManaBurn" },
  ['法力风暴'] = {t=2000, icon="Spell_Frost_IceStorm" },
  ['显现灵魂'] = {t=5000, icon="Spell_Totem_WardOfDraining" },
  ['净化元素之灵'] = {t=4000, icon="Temp" },
  ['烈焰印记'] = {t=1000, icon="Spell_Fire_Fireball" },
  ['狙击'] = {t=2000, icon="Ability_Marksmanship" },
  ['群体驱魔'] = {t=1000, icon="Spell_Shadow_Teleport" },
  ['群体治疗'] = {t=1000, icon="Spell_Holy_GreaterHeal" },
  ['巨型喷泉'] = {t=1500, icon="Spell_Frost_SummonWaterElemental" },
  ['大规模迫击炮'] = {t=3000, icon="Temp" },
  ['五月柱'] = {t=10000, icon="Spell_Shadow_Twilight" },
  ['麦伯克智慧饮料'] = {t=3000, icon="Temp" },
  ['机械修补包'] = {t=2000, icon="INV_Gizmo_03" },
  ['机械松鼠'] = {t=1000, icon="Spell_Shadow_Metamorphosis" },
  ['百万伏特'] = {t=2000, icon="Spell_Nature_ChainLightning" },
  ['音乐催眠'] = {t=1000, icon="Temp" },
  ['熔化矿石'] = {t=1500, icon="Spell_Fire_SelfDestruct" },
  ['融合软泥怪'] = {t=500, icon="INV_Potion_12" },
  ['麦琳瑟拉的觉醒'] = {t=2000, icon="Temp" },
  ['米布隆的诱饵'] = {t=2000, icon="INV_Misc_Food_50" },
  ['仲夏腊肠'] = {t=1000, icon="INV_Misc_Food_53" },
  ['拉格纳罗斯之力'] = {t=500, icon="Spell_Fire_SelfDestruct" },
  ['沙赫拉姆之力'] = {t=1000, icon="Spell_Nature_WispSplode" },
  ['心灵震爆'] = {t=1500, icon="Spell_Shadow_UnholyFrenzy" },
  ['精神控制'] = {t=3000, icon="Spell_Shadow_ShadowWordDominate" },
  ['心灵腐蚀'] = {t=2000, icon="Spell_Shadow_MindRot" },
  ['心灵震颤'] = {t=2000, icon="Spell_Nature_Earthquake" },
  ['麻痹毒药'] = {t=3000, icon="Spell_Nature_NullifyDisease" },
  ['麻痹毒药 II'] = {t=3000, icon="Spell_Nature_NullifyDisease" },
  ['麻痹毒药 III'] = {t=3000, icon="Spell_Nature_NullifyDisease" },
  ['机枪'] = {t=100, icon="INV_Musket_04" },
  ['采矿'] = {t=3200, icon="Trade_Mining" },
  ['莫甘斯的爪牙'] = {t=2500, icon="Spell_Totem_WardOfDraining" },
  ['玛拉索姆的爪牙'] = {t=1000, icon="Spell_Shadow_CorpseExplode" },
  ['初级法力之油'] = {t=3000, icon="Temp" },
  ['初级巫师之油'] = {t=3000, icon="Temp" },
  ['黑暗泥浆'] = {t=1000, icon="Spell_Nature_StrangleVines" },
  ['暗色湖蘑菇'] = {t=3000, icon="Spell_Holy_HarmUndeadAura" },
  ['槲寄生狂欢者'] = {t=1000, icon="INV_Misc_Branch_01" },
  ['秘银破片炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['熔岩爆裂'] = {t=2000, icon="Spell_Fire_Fire" },
  ['熔铁之水'] = {t=2000, icon="Spell_Fire_Fireball" },
  ['熔岩之雨'] = {t=2000, icon="Temp" },
  ['摩罗加尔附魔'] = {t=1300, icon="Temp" },
  ['红色迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['娜玛拉的爱情药水'] = {t=1000, icon="Temp" },
  ['纳瑞安！'] = {t=3000, icon="INV_Misc_Head_Gnome_01" },
  ['纳拉雷克斯的梦魇'] = {t=2000, icon="Spell_Nature_Sleep" },
  ['自然虚弱'] = {t=5000, icon="INV_Misc_QirajiCrystal_03" },
  ['Nefarius Attack 001'] = {t=1000, icon="Temp" },
  ['虚空宝石'] = {t=3000, icon="Temp" },
  ['夜色虫'] = {t=5000, icon="Trade_Fishing" },
  ['夜刃豹'] = {t=3000, icon="Ability_Mount_BlackPanther" },
  ['怀旧'] = {t=4000, icon="Spell_Shadow_LifeDrain" },
  ['汲取魔法'] = {t=2000, icon="Spell_Shadow_DarkRitual" },
  ['麻木之痛'] = {t=1500, icon="Spell_Nature_CorrosiveBreath" },
  ['黑色迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['打开'] = {t=5000, icon="Temp" },
  ['Opening - No Text'] = {t=5000, icon="Temp" },
  ['打开酒吧的门'] = {t=5000, icon="Temp" },
  ['打开本尼迪克的箱子'] = {t=5000, icon="Temp" },
  ['打开箱子'] = {t=5000, icon="Temp" },
  ['打开笼子'] = {t=5000, icon="Temp" },
  ['打开箱子'] = {t=5000, icon="Temp" },
  ['打开黑暗守护者宝箱'] = {t=5000, icon="Temp" },
  ['打开大型圣甲虫箱'] = {t=5000, icon="Temp" },
  ['打开古物箱'] = {t=5000, icon="Temp" },
  ['打开保险箱'] = {t=5000, icon="Temp" },
  ['打开圣甲虫箱'] = {t=5000, icon="Temp" },
  ['打开密箱'] = {t=5000, icon="Temp" },
  ['打开保险箱'] = {t=5000, icon="Temp" },
  ['打开斯坦索姆邮箱'] = {t=5000, icon="Temp" },
  ['打开保险箱'] = {t=5000, icon="Temp" },
  ['打开白蚁桶'] = {t=5000, icon="Temp" },
  ['Ouro Submerge Visual'] = {t=1500, icon="Spell_Fire_Volcano" },
  ['猫头鹰形态'] = {t=5000, icon="Spell_Nature_RavenForm" },
  ['奥齐爆炸'] = {t=2000, icon="Temp" },
  ['褐色马'] = {t=3000, icon="Ability_Mount_RidingHorse" },
  ['褐色马'] = {t=3000, icon="Ability_Mount_RidingHorse" },
  ['黑豹'] = {t=3000, icon="Ability_Mount_BlackPanther" },
  ['豹笼钥匙'] = {t=5000, icon="Temp" },
  ['寄生'] = {t=2000, icon="Ability_Poisons" },
  ['群体热疫'] = {t=1000, icon="Spell_Shadow_DarkSummoning" },
  ['农夫伪装'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['苦工伪装'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['泰莉欧娜幻象'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['泰里恩幻象'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['开锁'] = {t=5000, icon="Spell_Nature_MoonKey" },
  ['Pickpocket (PT)'] = {t=5000, icon="Temp" },
  ['刺骨暗影'] = {t=2000, icon="Spell_Shadow_ChillTouch" },
  ['挖掘石柱'] = {t=5000, icon="Temp" },
  ['杂色马'] = {t=3000, icon="Ability_Mount_RidingHorse" },
  ['放置奥金鱼漂'] = {t=2000, icon="Temp" },
  ['放置幽灵磁铁'] = {t=1500, icon="Temp" },
  ['放置狮肉'] = {t=2500, icon="INV_Misc_Bowl_01" },
  ['放置水晶球'] = {t=3000, icon="Temp" },
  ['放置蛇颈龙肉'] = {t=2500, icon="INV_Misc_Bowl_01" },
  ['放置剧毒粮草'] = {t=3000, icon="INV_Cask_01" },
  ['放置未淬火的剑'] = {t=1000, icon="Temp" },
  ['放置未铸造的印章'] = {t=500, icon="Temp" },
  ['放置火炬'] = {t=2300, icon="Temp" },
  ['放置捕熊陷阱'] = {t=2000, icon="Temp" },
  ['放置坠饰'] = {t=5000, icon="Temp" },
  ['放置烟鬼的炸药'] = {t=3000, icon="Temp" },
  ['瘟疫之云'] = {t=2000, icon="Spell_Shadow_CallofBone" },
  ['瘟疫心灵'] = {t=4000, icon="Spell_Shadow_CallofBone" },
  ['放置戈泰什的头颅'] = {t=5000, icon="Temp" },
  ['种植魔法豆'] = {t=2000, icon="INV_Misc_Food_Wheat_02" },
  ['播种'] = {t=5000, icon="Temp" },
  ['插旗子'] = {t=2300, icon="Temp" },
  ['放置古斯的信号灯'] = {t=5000, icon="Temp" },
  ['放置艾克曼的信号灯'] = {t=5000, icon="Temp" },
  ['放置杰斯托的信号灯'] = {t=5000, icon="Temp" },
  ['放置穆维里克的信号灯'] = {t=5000, icon="Temp" },
  ['放置雷松的信号灯'] = {t=5000, icon="Temp" },
  ['放置斯里多尔的信号灯'] = {t=5000, icon="Temp" },
  ['放置维波里的信号灯'] = {t=5000, icon="Temp" },
  ['尖锐之矛'] = {t=500, icon="Ability_ImpalingBolt" },
  ['毒液箭'] = {t=2500, icon="Spell_Nature_CorrosiveBreath" },
  ['毒云术'] = {t=1000, icon="Spell_Nature_Regenerate" },
  ['毒性钉刺'] = {t=2000, icon="INV_Misc_MonsterTail_03" },
  ['毒性鱼叉'] = {t=2000, icon="Ability_Poisons" },
  ['毒性射击'] = {t=2000, icon="Ability_Poisons" },
  ['含毒喷溅'] = {t=2000, icon="Spell_Nature_CorrosiveBreath" },
  ['极性转化'] = {t=3000, icon="Spell_Nature_Lightning" },
  ['变形术'] = {t=1500, icon="Spell_Nature_Polymorph" },
  ['变形术：奶牛'] = {t=1500, icon="Spell_Nature_Polymorph_Cow" },
  ['变形术：猪'] = {t=1500, icon="Spell_Magic_PolymorphPig" },
  ['变形术：龟'] = {t=1500, icon="Ability_Hunter_Pet_Turtle" },
  ['传送门：达纳苏斯'] = {t=10000, icon="Spell_Arcane_PortalDarnassus" },
  ['传送门：铁炉堡'] = {t=10000, icon="Spell_Arcane_PortalIronForge" },
  ['传送门：卡拉赞'] = {t=10000, icon="Spell_Arcane_PortalUnderCity" },
  ['传送门：奥格瑞玛'] = {t=10000, icon="Spell_Arcane_PortalOrgrimmar" },
  ['传送门：暴风城'] = {t=10000, icon="Spell_Arcane_PortalStormWind" },
  ['传送门：雷霆崖'] = {t=10000, icon="Spell_Arcane_PortalThunderBluff" },
  ['传送门：幽暗城'] = {t=10000, icon="Spell_Arcane_PortalUnderCity" },
  ['投掷药水'] = {t=2000, icon="Spell_Misc_Drink" },
  ['强力爆盐炸弹'] = {t=5000, icon="Temp" },
  ['强力嗅盐'] = {t=2000, icon="INV_Misc_Ammo_Gunpowder_01" },
  ['艾露恩祷言'] = {t=1000, icon="Spell_Holy_Resurrection" },
  ['治疗祷言'] = {t=3000, icon="Spell_Holy_PrayerOfHealing02" },
  ['死亡显现'] = {t=1000, icon="Spell_Shadow_ShadeTrueSight" },
  ['远古豹'] = {t=3000, icon="Ability_Mount_JungleTiger" },
  ['公主召唤传送门'] = {t=10000, icon="Spell_Arcane_PortalIronForge" },
  ['普罗德摩尔的防护'] = {t=3000, icon="Spell_Holy_BlessingOfProtection" },
  ['心灵占卜'] = {t=5000, icon="Spell_Holy_Restoration" },
  ['净化并放置食物'] = {t=5000, icon="INV_Misc_Bowl_01" },
  ['紫手'] = {t=4000, icon="Spell_Shadow_SiphonMana" },
  ['紫色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['紫色骷髅战马'] = {t=3000, icon="Ability_Mount_Undeadhorse" },
  ['炎爆术'] = {t=6000, icon="Spell_Fire_Fireball02" },
  ['Quest - Sergra Darkthorn Spell'] = {t=3000, icon="Temp" },
  ['召唤树人'] = {t=3000, icon="Spell_Nature_NatureTouchGrow" },
  ['Quest - Teleport Spawn-out'] = {t=1000, icon="Temp" },
  ['Quest - Troll Hero Summon Visual'] = {t=30000, icon="Temp" },
  ['快速嗜血'] = {t=2000, icon="Spell_Nature_BloodLust" },
  ['快速烈焰防护结界'] = {t=1500, icon="Spell_Fire_SealOfFire" },
  ['快速冰霜防护结界'] = {t=1500, icon="Spell_Fire_SealOfFire" },
  ['辐射之箭'] = {t=3000, icon="Spell_Shadow_CorpseExplode" },
  ['图勒之怒'] = {t=1500, icon="Spell_Shadow_UnholyFrenzy" },
  ['拉格纳罗斯显现'] = {t=2900, icon="Spell_Fire_LavaSpawn" },
  ['火焰之雨'] = {t=3000, icon="Spell_Shadow_RainOfFire" },
  ['复活死者'] = {t=1000, icon="Spell_Shadow_RaiseDead" },
  ['复活亡灵甲虫'] = {t=1000, icon="Spell_Shadow_Contagion" },
  ['迅猛龙羽毛'] = {t=5000, icon="Temp" },
  ['剃刀之鬃'] = {t=1000, icon="Spell_Nature_Thorns" },
  ['复生'] = {t=2000, icon="Spell_Nature_Reincarnation" },
  ['召回'] = {t=10000, icon="Temp" },
  ['诵读塞雷布拉斯之语'] = {t=3000, icon="Temp" },
  ['重建'] = {t=3000, icon="Temp" },
  ['红蓝两色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['Red Dragon Transform DND'] = {t=1000, icon="Temp" },
  ['红色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['红色骸骨军马'] = {t=3000, icon="Ability_Mount_Undeadhorse" },
  ['红色骷髅战马'] = {t=3000, icon="Ability_Mount_Undeadhorse" },
  ['赤狼'] = {t=3000, icon="Ability_Mount_BlackDireWolf" },
  ['救赎'] = {t=10000, icon="Spell_Holy_Resurrection" },
  ['愈合'] = {t=2000, icon="Spell_Nature_ResistNature" },
  ['驯鹿之尘效果'] = {t=8000, icon="Temp" },
  ['释放小鬼'] = {t=2000, icon="Temp" },
  ['释放耶维尔'] = {t=2000, icon="Temp" },
  ['释放怒爪'] = {t=10000, icon="Temp" },
  ['放狗'] = {t=2000, icon="Temp" },
  ['释放乌米的雪人'] = {t=2000, icon="Temp" },
  ['释放温娜的猫'] = {t=1000, icon="Ability_Seal" },
  ['释放腐化软泥怪'] = {t=5000, icon="INV_Potion_19" },
  ['遥控炸药'] = {t=1000, icon="INV_Misc_StoneTablet_04" },
  ['解除徽记'] = {t=1000, icon="Temp" },
  ['恢复'] = {t=2000, icon="Spell_Holy_Renew" },
  ['补充精神'] = {t=3000, icon="Spell_Nature_MoonGlow" },
  ['补充精神 II'] = {t=3000, icon="Spell_Nature_MoonGlow" },
  ['Reputation - Ahn\'Qiraj Temple Boss'] = {t=1000, icon="Temp" },
  ['声望 - 藏宝海湾 +500'] = {t=1000, icon="Temp" },
  ['声望 - 永望镇 +500'] = {t=1000, icon="Temp" },
  ['声望 - 加基森 +500'] = {t=1000, icon="Temp" },
  ['声望 - 棘齿城 +500'] = {t=1000, icon="Temp" },
  ['重新补给'] = {t=2000, icon="Spell_Misc_Drink" },
  ['复活术'] = {t=10000, icon="Spell_Holy_Resurrection" },
  ['作呕瘟疫'] = {t=2000, icon="Spell_Shadow_CallofBone" },
  ['复活掘地鼠'] = {t=3000, icon="Spell_Holy_Resurrection" },
  ['复活宠物'] = {t=10000, icon="Ability_Hunter_BeastSoothe" },
  ['浇醒林格'] = {t=2500, icon="Temp" },
  ['科多兽坐骑'] = {t=3000, icon="INV_Misc_Head_Tauren_02" },
  ['骑乘乌龟'] = {t=3000, icon="Ability_Hunter_Pet_Turtle" },
  ['裂隙标记'] = {t=2000, icon="Spell_Nature_AbolishMagic" },
  ['正义火焰'] = {t=4000, icon="Spell_Holy_InnerFire" },
  ['Rimblat Grows Flower DND'] = {t=2000, icon="Temp" },
  ['末日仪式'] = {t=10000, icon="Spell_Shadow_AntiMagicShell" },
  ['末日仪式效果'] = {t=10000, icon="Spell_Arcane_PortalDarnassus" },
  ['召唤仪式'] = {t=5000, icon="Spell_Shadow_Twilight" },
  ['召唤仪式效果'] = {t=5000, icon="Temp" },
  ['火箭爆炸'] = {t=3000, icon="Temp" },
  ['Rookery Whelp Spawn-in Spell'] = {t=500, icon="Temp" },
  ['Rotate Trigger'] = {t=3000, icon="Temp" },
  ['劣质铜壳炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['劣质炸药'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['奇特的朗姆酒'] = {t=1000, icon="INV_Drink_03" },
  ['黑标美味朗姆酒'] = {t=1000, icon="INV_Drink_04" },
  ['黑暗美味朗姆酒'] = {t=1000, icon="INV_Drink_04" },
  ['光明美味朗姆酒'] = {t=1000, icon="INV_Drink_08" },
  ['开启符文'] = {t=5000, icon="Temp" },
  ['Ruul Snowhoof Shapechange (DND)'] = {t=1000, icon="Temp" },
  ['雷松的全视之眼'] = {t=1000, icon="Ability_Ambush" },
  ['雷松的猫头鹰'] = {t=1000, icon="Ability_Hunter_EagleEye" },
  ['牺牲'] = {t=1000, icon="Spell_Holy_DivineIntervention" },
  ['献祭丝囊'] = {t=10000, icon="Temp" },
  ['沙尘爆裂'] = {t=2000, icon="Spell_Nature_Cyclone" },
  ['沙尘之息'] = {t=2000, icon="Spell_Fire_WindsofWoe" },
  ['工兵爆破'] = {t=5000, icon="Spell_Fire_SelfDestruct" },
  ['Sapphiron DND'] = {t=20000, icon="Temp" },
  ['萨瑞鲁斯的元素生物'] = {t=3000, icon="Spell_Shadow_RaiseDead" },
  ['恐吓野兽'] = {t=1500, icon="Ability_Druid_Cower" },
  ['血色复活'] = {t=2000, icon="Spell_Holy_Resurrection" },
  ['裂盾传送门'] = {t=1500, icon="Spell_Arcane_TeleportOrgrimmar" },
  ['灼烧'] = {t=1500, icon="Spell_Fire_SoulBurn" },
  ['灼热烈焰'] = {t=2000, icon="Spell_Fire_Immolation" },
  ['灼热之痛'] = {t=1500, icon="Spell_Fire_SoulBurn" },
  ['诱惑'] = {t=1500, icon="Spell_Shadow_MindSteal" },
  ['横扫重锤'] = {t=1000, icon="Spell_Nature_CorrosiveBreath" },
  ['瑟格拉·黑棘效果'] = {t=3000, icon="Temp" },
  ['自毁'] = {t=7000, icon="Spell_Fire_SelfDestruct" },
  ['自我爆炸'] = {t=7000, icon="Spell_Fire_SelfDestruct" },
  ['自我复活'] = {t=5000, icon="Temp" },
  ['盘蛇净化'] = {t=30000, icon="Spell_Shadow_LifeDrain" },
  ['装配NG-5炸药（蓝色）'] = {t=5000, icon="INV_Misc_Bomb_05" },
  ['装配NG-5炸药（红色）'] = {t=5000, icon="INV_Misc_Bomb_05" },
  ['束缚亡灵'] = {t=1500, icon="Spell_Nature_Slow" },
  ['暗影箭'] = {t=3000, icon="Spell_Shadow_ShadowBolt" },
  ['暗影箭失效'] = {t=2000, icon="Spell_Shadow_ShadowBolt" },
  ['暗影箭雨'] = {t=3000, icon="Spell_Shadow_ShadowBolt" },
  ['暗影烈焰'] = {t=2000, icon="Spell_Fire_Incinerate" },
  ['暗影新星 II'] = {t=3000, icon="Spell_Shadow_ShadeTrueSight" },
  ['暗影之油'] = {t=3000, icon="Temp" },
  ['暗影传送'] = {t=250, icon="Spell_Shadow_AntiShadow" },
  ['暗影之门'] = {t=1000, icon="Spell_Shadow_SealOfKings" },
  ['暗影抗性'] = {t=1000, icon="Spell_Frost_WizardMark" },
  ['暗影外壳'] = {t=1000, icon="Spell_Shadow_AntiShadow" },
  ['暗影虚弱'] = {t=5000, icon="INV_Misc_QirajiCrystal_05" },
  ['暗影闪现'] = {t=500, icon="Spell_Shadow_DetectLesserInvisibility" },
  ['共同禁锢'] = {t=1500, icon="Spell_Shadow_UnsummonBuilding" },
  ['打磨利刃'] = {t=3000, icon="Temp" },
  ['打磨利刃 II'] = {t=3000, icon="Temp" },
  ['打磨利刃 III'] = {t=3000, icon="Temp" },
  ['打磨利刃 IV'] = {t=3000, icon="Temp" },
  ['打磨利刃 V'] = {t=3000, icon="Temp" },
  ['致命武器'] = {t=3000, icon="Temp" },
  ['沙恩的铃铛'] = {t=4500, icon="Temp" },
  ['反转之盾'] = {t=1000, icon="Spell_Shadow_Teleport" },
  ['闪光的小珠'] = {t=5000, icon="INV_Misc_Orb_03" },
  ['震击'] = {t=1000, icon="Temp" },
  ['震荡波'] = {t=2000, icon="Ability_Whirlwind" },
  ['弓射击'] = {t=1000, icon="Ability_Marksmanship" },
  ['弩射击'] = {t=1000, icon="Ability_Marksmanship" },
  ['枪械射击'] = {t=1000, icon="Ability_Marksmanship" },
  ['发射导弹'] = {t=3000, icon="INV_Ammo_Bullet_03" },
  ['发射火箭'] = {t=3000, icon="INV_Ammo_Bullet_03" },
  ['伐木机高温喷射'] = {t=2000, icon="Spell_Fire_Incinerate" },
  ['缩小'] = {t=3000, icon="Spell_Shadow_AntiShadow" },
  ['沉默'] = {t=1500, icon="Spell_Holy_Silence" },
  ['异种蝎群瘟疫'] = {t=2000, icon="Spell_Nature_NullifyDisease" },
  ['白银万能钥匙'] = {t=5000, icon="Temp" },
  ['简易传送'] = {t=1000, icon="Spell_Magic_LesserInvisibilty" },
  ['简易传送小组'] = {t=2000, icon="Spell_Magic_LesserInvisibilty" },
  ['简易传送他人'] = {t=1000, icon="Spell_Magic_LesserInvisibilty" },
  ['骸骨战马'] = {t=3000, icon="Ability_Mount_Undeadhorse" },
  ['骷髅矿工爆炸'] = {t=5000, icon="Spell_Fire_SelfDestruct" },
  ['骷髅马'] = {t=3000, icon="Ability_Mount_Undeadhorse" },
  ['剥皮'] = {t=2500, icon="INV_Misc_Pelt_Wolf_01" },
  ['猛击'] = {t=1500, icon="Ability_Warrior_DecisiveStrike" },
  ['奴隶吸取'] = {t=1000, icon="Spell_Shadow_ChillTouch" },
  ['催眠术'] = {t=1500, icon="Spell_Nature_Sleep" },
  ['软泥之箭'] = {t=2500, icon="Spell_Nature_CorrosiveBreath" },
  ['投掷泥土'] = {t=1000, icon="Spell_Nature_Sleep" },
  ['投掷泥浆'] = {t=1000, icon="Spell_Nature_Sleep" },
  ['减速毒药'] = {t=1000, icon="Spell_Nature_SlowPoison" },
  ['减速毒药 II'] = {t=1000, icon="Spell_Nature_SlowPoison" },
  ['减速毒药'] = {t=1000, icon="Spell_Nature_SlowPoison" },
  ['淤泥毒药'] = {t=2000, icon="Spell_Nature_Regenerate" },
  ['小型青铜炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['小型爆盐炸弹'] = {t=5000, icon="Temp" },
  ['惩击'] = {t=2500, icon="Spell_Holy_HolySmite" },
  ['爱情的重击'] = {t=1000, icon="INV_Ammo_Arrow_02" },
  ['雪人'] = {t=1500, icon="INV_Ammo_Snowball" },
  ['指挥地鼠'] = {t=1500, icon="Spell_Shadow_LifeDrain" },
  ['Sol H'] = {t=3000, icon="Spell_Frost_ManaRecharge" },
  ['Sol L'] = {t=3000, icon="Spell_Frost_ManaRecharge" },
  ['Sol M'] = {t=3000, icon="Spell_Frost_ManaRecharge" },
  ['Sol U'] = {t=3000, icon="Spell_Frost_ManaRecharge" },
  ['实心炸弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['安抚动物'] = {t=1500, icon="Ability_Hunter_BeastSoothe" },
  ['灵魂撕咬'] = {t=2000, icon="Spell_Shadow_SiphonMana" },
  ['灵魂击碎者'] = {t=2000, icon="Spell_Shadow_Haunting" },
  ['灵魂吞噬'] = {t=4000, icon="Ability_Racial_Cannibalize" },
  ['灵魂消耗'] = {t=2000, icon="Spell_Shadow_LifeDrain02" },
  ['灵魂之火'] = {t=6000, icon="Spell_Fire_Fireball02" },
  ['灵魂破碎'] = {t=2000, icon="Spell_Fire_Fire" },
  ['灵魂石复活'] = {t=3000, icon="Spell_Shadow_SoulGem" },
  ['南海海盗伪装'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['南海火炮开火'] = {t=5000, icon="Spell_Fire_FireBolt02" },
  ['火花'] = {t=2000, icon="Spell_Nature_Lightning" },
  ['Spawn Challenge to Urok'] = {t=2000, icon="Temp" },
  ['与头颅交谈'] = {t=5000, icon="Spell_Shadow_LifeDrain" },
  ['法术偏转'] = {t=1000, icon="Temp" },
  ['香料迫击炮'] = {t=500, icon="Spell_Fire_Fireball02" },
  ['尖刺之雨'] = {t=500, icon="Ability_ImpalingBolt" },
  ['灵魂凋零'] = {t=2000, icon="Spell_Holy_HarmUndeadAura" },
  ['Spirit Spawn-out'] = {t=500, icon="Temp" },
  ['精神偷取'] = {t=2000, icon="Spell_Shadow_Possession" },
  ['斑点霜刃豹'] = {t=3000, icon="Ability_Mount_WhiteTiger" },
  ['白斑黑豹'] = {t=3000, icon="Ability_Mount_BlackPanther" },
  ['泼洒净化过的水'] = {t=6000, icon="Temp" },
  ['星火术'] = {t=3500, icon="Spell_Arcane_StarFire" },
  ['钢质机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['Stone Dwarf Awaken Visual'] = {t=1500, icon="Spell_Nature_Earthquake" },
  ['Stoned - Channel Cast Visual'] = {t=3000, icon="Spell_Nature_Cyclone" },
  ['石肤术'] = {t=6000, icon="Spell_Nature_EnchantArmor" },
  ['碎石穴居怪伪装'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['风暴之锤'] = {t=1000, icon="INV_Hammer_01" },
  ['雷矛军用坐骑'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['亚科纳琳之力'] = {t=4000, icon="Spell_Nature_AstralRecal" },
  ['古神之力'] = {t=2000, icon="Spell_Shadow_Requiem" },
  ['打击'] = {t=2000, icon="Temp" },
  ['条纹霜刃豹'] = {t=3000, icon="Ability_Mount_WhiteTiger" },
  ['条纹夜刃豹'] = {t=3000, icon="Ability_Mount_BlackPanther" },
  ['卡死'] = {t=10000, icon="Spell_Shadow_Teleport" },
  ['昏迷炸弹'] = {t=2000, icon="Spell_Fire_SelfDestruct" },
  ['炸弹攻击'] = {t=2000, icon="Spell_Fire_SelfDestruct" },
  ['Submerge Visual'] = {t=1500, icon="Spell_Fire_Volcano" },
  ['召唤'] = {t=1000, icon="Spell_Arcane_Blink" },
  ['召唤报警机器人'] = {t=250, icon="INV_Gizmo_08" },
  ['召唤白鳞蛇'] = {t=1000, icon="Ability_Seal" },
  ['召唤白色钳嘴龟'] = {t=1000, icon="Ability_Seal" },
  ['召唤古树之魂'] = {t=2000, icon="Temp" },
  ['召唤灰色小鸡'] = {t=1000, icon="Ability_Seal" },
  ['召唤亚奎门塔斯'] = {t=2000, icon="Temp" },
  ['召唤阿里亚'] = {t=2500, icon="Spell_Nature_GroundingTotem" },
  ['召唤阿塔莱骷髅'] = {t=1000, icon="Spell_Shadow_RaiseDead" },
  ['召唤蓝龙宝宝'] = {t=1000, icon="Ability_Seal" },
  ['召唤鲨鱼宝宝'] = {t=1000, icon="Ability_Seal" },
  ['召唤黑色王蛇'] = {t=1000, icon="Ability_Seal" },
  ['召唤黑色其拉作战坦克'] = {t=3000, icon="INV_Misc_QirajiCrystal_05" },
  ['召唤黑手恐法师'] = {t=5000, icon="Spell_Nature_Purge" },
  ['召唤黑手老兵'] = {t=5000, icon="Spell_Nature_Purge" },
  ['召唤红鹦鹉'] = {t=1000, icon="Ability_Seal" },
  ['召唤血瓣花瘟疫'] = {t=2000, icon="Spell_Shadow_DarkSummoning" },
  ['召唤蓝色其拉作战坦克'] = {t=3000, icon="INV_Misc_QirajiCrystal_04" },
  ['召唤蓝鳞蛇'] = {t=1000, icon="Ability_Seal" },
  ['召唤野猪之魂'] = {t=1500, icon="Spell_Magic_PolymorphPig" },
  ['召唤炸弹'] = {t=1000, icon="Ability_Seal" },
  ['召唤灰猫'] = {t=1000, icon="Ability_Seal" },
  ['召唤青铜龙宝宝'] = {t=1000, icon="Ability_Seal" },
  ['召唤棕色蟒蛇'] = {t=1000, icon="Ability_Seal" },
  ['召唤腐食甲虫'] = {t=2000, icon="Spell_Shadow_CarrionSwarm" },
  ['召唤战马'] = {t=3000, icon="Ability_Mount_Charger" },
  ['召唤红尾鹦鹉'] = {t=1000, icon="Ability_Seal" },
  ['召唤美冠鹦鹉'] = {t=1000, icon="Ability_Seal" },
  ['召唤蟑螂'] = {t=1000, icon="Ability_Seal" },
  ['召唤普通猫'] = {t=2000, icon="INV_Box_PetCarrier_01" },
  ['召唤黄猫'] = {t=1000, icon="Ability_Seal" },
  ['召唤腐化猫'] = {t=1000, icon="Ability_Seal" },
  ['召唤黄毛兔'] = {t=1000, icon="Ability_Seal" },
  ['召唤赤练蛇'] = {t=1000, icon="Ability_Seal" },
  ['召唤红龙宝宝'] = {t=1000, icon="Ability_Seal" },
  ['召唤塞克隆尼亚'] = {t=10000, icon="Spell_Nature_EarthBind" },
  ['召唤达古恩'] = {t=5000, icon="Temp" },
  ['召唤黑龙宝宝'] = {t=1000, icon="Ability_Seal" },
  ['召唤蓝蛙'] = {t=1000, icon="Ability_Seal" },
  ['召唤宝珠恶魔'] = {t=5000, icon="Temp" },
  ['召唤迷你破坏神'] = {t=1000, icon="Ability_Seal" },
  ['召唤恶心的软泥怪'] = {t=1000, icon="Ability_Seal" },
  ['召唤恐惧战马'] = {t=3000, icon="Ability_Mount_Dreadsteed" },
  ['召唤黄色猫头鹰'] = {t=1000, icon="Ability_Seal" },
  ['召唤埃其亚基'] = {t=500, icon="Spell_Shadow_LifeDrain" },
  ['召唤艾丹娜·邪爪'] = {t=4000, icon="Temp" },
  ['召唤效果'] = {t=5000, icon="Spell_Shadow_AnimateDead" },
  ['召唤小精灵'] = {t=1000, icon="Ability_Seal" },
  ['召唤灰烬'] = {t=2000, icon="Spell_Fire_Fire" },
  ['召唤绿龙宝宝'] = {t=1000, icon="Ability_Seal" },
  ['召唤精灵龙宝宝'] = {t=1000, icon="Ability_Seal" },
  ['召唤农场小鸡'] = {t=1000, icon="Ability_Seal" },
  ['召唤地狱猎犬'] = {t=10000, icon="Spell_Shadow_SummonFelHunter" },
  ['召唤地狱战马'] = {t=3000, icon="Spell_Nature_Swiftness" },
  ['召唤脆弱的骷髅'] = {t=10000, icon="Spell_Shadow_RaiseDead" },
  ['召唤碎腭'] = {t=3000, icon="Temp" },
  ['召唤地精炸弹'] = {t=250, icon="Ability_Repair" },
  ['召唤棕色猫头鹰'] = {t=1000, icon="Ability_Seal" },
  ['召唤绿色其拉作战坦克'] = {t=3000, icon="INV_Misc_QirajiCrystal_03" },
  ['召唤绿色水蛇'] = {t=1000, icon="Ability_Seal" },
  ['召唤绿翼鹦鹉'] = {t=1000, icon="Ability_Seal" },
  ['召唤冈瑟尔的幻影'] = {t=2000, icon="Temp" },
  ['召唤咕唧'] = {t=1000, icon="Ability_Seal" },
  ['召唤黑色猫头鹰'] = {t=1000, icon="Ability_Seal" },
  ['召唤鹰喙钳嘴龟'] = {t=1000, icon="Ability_Seal" },
  ['召唤赫尔库拉之犬'] = {t=3000, icon="Spell_Shadow_Haunting" },
  ['召唤角鹰兽宝宝'] = {t=1000, icon="Ability_Seal" },
  ['召唤花羽鹦鹉'] = {t=1000, icon="Ability_Seal" },
  ['召唤睡梦守卫的幻象'] = {t=1000, icon="Spell_Shadow_Teleport" },
  ['召唤幻影梦魇兽'] = {t=2000, icon="Spell_Fire_SealOfFire" },
  ['召唤幻象之影'] = {t=2000, icon="Spell_Fire_SealOfFire" },
  ['召唤幻影怨灵'] = {t=1000, icon="Spell_Shadow_Teleport" },
  ['召唤小鬼'] = {t=10000, icon="Spell_Shadow_SummonImp" },
  ['召唤地狱火仆从'] = {t=2000, icon="Spell_Shadow_SummonInfernal" },
  ['召唤伊沙姆哈尔'] = {t=2000, icon="Spell_Shadow_LifeDrain" },
  ['召唤岛蛙'] = {t=1000, icon="Ability_Seal" },
  ['召唤加布林'] = {t=1000, icon="Ability_Seal" },
  ['召唤卡拉恩的旗子'] = {t=500, icon="Temp" },
  ['召唤硬皮钳嘴龟'] = {t=1000, icon="Ability_Seal" },
  ['召唤逼真的蟾蜍'] = {t=1000, icon="Ability_Seal" },
  ['召唤活火'] = {t=2000, icon="Spell_Fire_Fire" },
  ['召唤圆头钳嘴龟'] = {t=1000, icon="Ability_Seal" },
  ['召唤月爪枭兽'] = {t=3000, icon="Temp" },
  ['召唤错觉狼影'] = {t=1000, icon="Spell_Shadow_Teleport" },
  ['召唤法杖'] = {t=2000, icon="INV_Staff_26" },
  ['召唤玛格拉姆劫掠者'] = {t=4000, icon="Spell_Shadow_RaiseDead" },
  ['召唤黑纹灰猫'] = {t=1000, icon="Ability_Seal" },
  ['召唤机械小鸡'] = {t=1000, icon="Ability_Seal" },
  ['召唤爪牙'] = {t=500, icon="Temp" },
  ['召唤哼哼先生'] = {t=1000, icon="Ability_Seal" },
  ['召唤小鱼人'] = {t=1000, icon="Ability_Seal" },
  ['召唤小鱼人'] = {t=1000, icon="Ability_Seal" },
  ['召唤密斯莱尔'] = {t=10000, icon="Spell_Shadow_LifeDrain" },
  ['召唤虚无行者'] = {t=4000, icon="Spell_Shadow_GatherShadows" },
  ['召唤绿色钳嘴龟'] = {t=1000, icon="Ability_Seal" },
  ['召唤奥妮克希亚雏龙'] = {t=2000, icon="Temp" },
  ['召唤虎皮猫'] = {t=1000, icon="Ability_Seal" },
  ['召唤孤儿'] = {t=1000, icon="Ability_Seal" },
  ['召唤熊猫'] = {t=1000, icon="Ability_Seal" },
  ['召唤波利'] = {t=1000, icon="Ability_Seal" },
  ['召唤农场小鸡'] = {t=1000, icon="Ability_Seal" },
  ['召唤土拨鼠'] = {t=1000, icon="Ability_Seal" },
  ['召唤拉格纳罗斯'] = {t=10000, icon="Spell_Fire_LavaSpawn" },
  ['召唤拉瑟莱克'] = {t=10000, icon="Temp" },
  ['召唤红色其拉作战坦克'] = {t=3000, icon="INV_Misc_QirajiCrystal_02" },
  ['召唤遥控傀儡'] = {t=3000, icon="Ability_Repair" },
  ['召唤赤环蛇'] = {t=1000, icon="Ability_Seal" },
  ['召唤狮鹫坐骑'] = {t=3000, icon="Ability_BullRush" },
  ['召唤复活的侍从'] = {t=2000, icon="Spell_Shadow_RaiseDead" },
  ['召唤机器人'] = {t=1000, icon="Ability_Seal" },
  ['召唤石翼石像鬼'] = {t=10000, icon="Spell_Shadow_UnsummonBuilding" },
  ['召唤群居雏龙'] = {t=2000, icon="Temp" },
  ['召唤血纹蛇'] = {t=1000, icon="Ability_Seal" },
  ['召唤尖啸者的灵魂'] = {t=2000, icon="Temp" },
  ['召唤金翼鹦鹉'] = {t=1000, icon="Ability_Seal" },
  ['召唤暗影法师'] = {t=5000, icon="Spell_Shadow_RaiseDead" },
  ['召唤暗影之击'] = {t=10000, icon="Temp" },
  ['召唤持盾守卫'] = {t=5000, icon="Spell_Nature_Purge" },
  ['召唤希洛塔姆'] = {t=2500, icon="Temp" },
  ['召唤黑尾白猫'] = {t=1000, icon="Ability_Seal" },
  ['召唤黑斑白猫'] = {t=1000, icon="Ability_Seal" },
  ['召唤骷髅'] = {t=2000, icon="Spell_Shadow_RaiseDead" },
  ['召唤黄纹兔'] = {t=1000, icon="Ability_Seal" },
  ['召唤白色猫头鹰'] = {t=1000, icon="Ability_Seal" },
  ['召唤地鼠'] = {t=2000, icon="Spell_Nature_ProtectionformNature" },
  ['召唤贝尔加的产物'] = {t=4000, icon="Spell_Fire_LavaSpawn" },
  ['召唤飞毛腿'] = {t=1000, icon="Ability_Seal" },
  ['召唤法术卫兵'] = {t=5000, icon="Spell_Nature_Purge" },
  ['召唤蜘蛛之神'] = {t=10000, icon="Spell_Shadow_LifeDrain" },
  ['召唤斑点兔'] = {t=1000, icon="Ability_Seal" },
  ['召唤精龙宝宝'] = {t=1000, icon="Ability_Seal" },
  ['召唤魅魔'] = {t=10000, icon="Spell_Shadow_SummonSuccubus" },
  ['召唤沼泽淤泥怪'] = {t=2500, icon="Spell_Shadow_BlackPlague" },
  ['召唤沼泽幽魂'] = {t=1500, icon="Spell_Nature_AbolishMagic" },
  ['召唤辛迪加鬼魂'] = {t=1000, icon="Spell_Shadow_Twilight" },
  ['召唤塔吉'] = {t=1000, icon="Ability_Seal" },
  ['召唤特沃什的爪牙'] = {t=4000, icon="Spell_Frost_Wisp" },
  ['Summon Thelrin DND'] = {t=1000, icon="Temp" },
  ['召唤法师'] = {t=5000, icon="Spell_Nature_Purge" },
  ['召唤雷霆之击'] = {t=10000, icon="Temp" },
  ['召唤林精'] = {t=3000, icon="Spell_Nature_ProtectionformNature" },
  ['召唤绿色小神龙'] = {t=1000, icon="Ability_Seal" },
  ['召唤红色小神龙'] = {t=1000, icon="Ability_Seal" },
  ['召唤安静的机械雪人'] = {t=1000, icon="Ability_Seal" },
  ['召唤树人'] = {t=1500, icon="Spell_Nature_ForceOfNature" },
  ['召唤寻宝部落'] = {t=1500, icon="Temp" },
  ['Summon Treasure Horde Visual'] = {t=1500, icon="Temp" },
  ['召唤树蛙'] = {t=1000, icon="Ability_Seal" },
  ['召唤毒蛇'] = {t=1500, icon="Spell_Nature_ResistMagic" },
  ['召唤虚空行者'] = {t=10000, icon="Spell_Shadow_SummonVoidWalker" },
  ['召唤军马'] = {t=3000, icon="Spell_Nature_Swiftness" },
  ['召唤水元素'] = {t=2000, icon="Spell_Shadow_SealOfKings" },
  ['召唤小老鼠'] = {t=1000, icon="Ability_Seal" },
  ['召唤白猫'] = {t=1000, icon="Ability_Seal" },
  ['召唤白色小鸡'] = {t=1000, icon="Ability_Seal" },
  ['召唤白色虎崽'] = {t=1000, icon="Ability_Seal" },
  ['召唤枯木地狱猎犬'] = {t=3000, icon="Spell_Shadow_SummonFelHunter" },
  ['召唤林蛙'] = {t=1000, icon="Ability_Seal" },
  ['召唤座狼幼崽'] = {t=1000, icon="Ability_Seal" },
  ['召唤克索诺斯恐惧战马'] = {t=5000, icon="Temp" },
  ['召唤黄色其拉作战坦克'] = {t=3000, icon="INV_Misc_QirajiCrystal_01" },
  ['召唤跳跳虫'] = {t=1000, icon="Ability_Seal" },
  ['召唤僵尸'] = {t=2000, icon="Spell_Shadow_RaiseDead" },
  ['召唤乌洛克'] = {t=1000, icon="Temp" },
  ['超级水晶'] = {t=6000, icon="Temp" },
  ['超强治疗结界'] = {t=2000, icon="Spell_Holy_LayOnHands" },
  ['横扫'] = {t=1500, icon="Spell_Nature_Thorns" },
  ['甜蜜惊喜'] = {t=1000, icon="INV_ValentinesChocolate03" },
  ['迅捷蓝色迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['迅捷棕山羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['迅捷棕马'] = {t=3000, icon="Ability_Mount_RidingHorse" },
  ['迅捷棕狼'] = {t=3000, icon="Ability_Mount_BlackDireWolf" },
  ['迅捷晨刃豹'] = {t=3000, icon="Ability_Mount_JungleTiger" },
  ['迅捷霜刃豹'] = {t=3000, icon="Ability_Mount_WhiteTiger" },
  ['迅捷灰山羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['迅捷灰狼'] = {t=3000, icon="Ability_Mount_WhiteDireWolf" },
  ['迅捷绿色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['迅捷雾刃豹'] = {t=3000, icon="Ability_Mount_BlackPanther" },
  ['迅捷绿色迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['迅捷橙色迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['迅捷褐色马'] = {t=3000, icon="Ability_Mount_RidingHorse" },
  ['拉扎什迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['迅捷雷刃豹'] = {t=3000, icon="Ability_Mount_BlackPanther" },
  ['迅捷森林狼'] = {t=3000, icon="Ability_Mount_WhiteDireWolf" },
  ['迅捷白色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['迅捷白山羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['迅捷白马'] = {t=3000, icon="Ability_Mount_RidingHorse" },
  ['迅捷黄色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['迅捷祖利安猛虎'] = {t=3000, icon="Ability_Mount_JungleTiger" },
  ['生命符记'] = {t=10000, icon="Spell_Holy_Resurrection" },
  ['辛迪加炸弹'] = {t=3000, icon="Spell_Shadow_MindBomb" },
  ['辛迪加伪装'] = {t=3000, icon="Ability_Rogue_Disguise" },
  ['Syndicate Tracker (MURP) DND'] = {t=1000, icon="Spell_Arcane_Blink" },
  ['泰兰死亡'] = {t=2000, icon="Temp" },
  ['修理塔瓦斯德的项链'] = {t=4500, icon="Spell_Holy_Restoration" },
  ['塔姆拉树苗'] = {t=1300, icon="Temp" },
  ['茶色利刃豹'] = {t=3000, icon="Ability_Mount_JungleTiger" },
  ['传授末日咆哮'] = {t=1000, icon="Temp" },
  ['蓝色科多兽'] = {t=3000, icon="Ability_Mount_Kodo_02" },
  ['传送'] = {t=1000, icon="Spell_Magic_LesserInvisibilty" },
  ['传送到海潮祭坛'] = {t=2000, icon="Temp" },
  ['传送：安威玛尔'] = {t=2000, icon="Temp" },
  ['传送：兵营'] = {t=2000, icon="Temp" },
  ['传送：墓地'] = {t=2000, icon="Temp" },
  ['传送：夜色镇'] = {t=2000, icon="Temp" },
  ['传送：暮色森林'] = {t=2000, icon="Temp" },
  ['传送：艾尔文森林'] = {t=2000, icon="Temp" },
  ['从艾萨拉之塔传送'] = {t=1000, icon="Spell_Nature_EarthBind" },
  ['传送：灯塔'] = {t=2000, icon="Temp" },
  ['传送：修道院'] = {t=2000, icon="Temp" },
  ['传送：月溪镇'] = {t=2000, icon="Temp" },
  ['传送：北郡修道院'] = {t=2000, icon="Temp" },
  ['传送到艾萨拉之塔'] = {t=1000, icon="Spell_Nature_AstralRecalGroup" },
  ['Teleport to Darnassus - Event'] = {t=1000, icon="Temp" },
  ['传送：树人'] = {t=2000, icon="Temp" },
  ['传送：西部荒野'] = {t=2000, icon="Temp" },
  ['传送：达纳苏斯'] = {t=10000, icon="Spell_Arcane_TeleportDarnassus" },
  ['传送：铁炉堡'] = {t=10000, icon="Spell_Arcane_TeleportIronForge" },
  ['传送：月光林地'] = {t=10000, icon="Spell_Arcane_TeleportMoonglade" },
  ['传送：奥格瑞玛'] = {t=10000, icon="Spell_Arcane_TeleportOrgrimmar" },
  ['传送：暴风城'] = {t=10000, icon="Spell_Arcane_TeleportStormWind" },
  ['传送：雷霆崖'] = {t=10000, icon="Spell_Arcane_TeleportThunderBluff" },
  ['传送：幽暗城'] = {t=10000, icon="Spell_Arcane_TeleportUnderCity" },
  ['Tell Joke'] = {t=2000, icon="Spell_Shadow_LifeDrain" },
  ['读取温度'] = {t=2000, icon="Temp" },
  ['Tharnariun Cure 1'] = {t=750, icon="Spell_Nature_RemoveDisease" },
  ['萨纳瑞恩的治疗'] = {t=500, icon="Spell_Nature_MagicImmunity" },
  ['大炸弹'] = {t=3000, icon="Spell_Fire_SelfDestruct" },
  ['瑟银手榴弹'] = {t=1000, icon="Spell_Fire_SelfDestruct" },
  ['千刃'] = {t=250, icon="INV-Sword_53" },
  ['威慑凝视'] = {t=2000, icon="Spell_Shadow_Charm" },
  ['胁迫低吼'] = {t=1000, icon="Ability_Racial_Cannibalize" },
  ['掷斧'] = {t=1000, icon="INV_Axe_08" },
  ['爱神的飞刀'] = {t=1000, icon="Temp" },
  ['投掷黑铁啤酒'] = {t=500, icon="Temp" },
  ['投掷炸弹'] = {t=2000, icon="Spell_Fire_SelfDestruct" },
  ['投掷梦魇'] = {t=2000, icon="Spell_Fire_SelfDestruct" },
  ['投掷石块'] = {t=3000, icon="Ability_GolemStormBolt" },
  ['投掷石块 II'] = {t=3000, icon="Ability_GolemStormBolt" },
  ['黑纹虎'] = {t=3000, icon="Ability_Mount_JungleTiger" },
  ['时间流逝'] = {t=2000, icon="Spell_Arcane_PortalOrgrimmar" },
  ['时间停止'] = {t=3000, icon="Temp" },
  ['Time Stop Visual DND'] = {t=3000, icon="Temp" },
  ['牛皮糖'] = {t=1000, icon="INV_SummerFest_Smorc" },
  ['合并火炬'] = {t=5000, icon="Temp" },
  ['投掷火炬'] = {t=3000, icon="Spell_Fire_Fireball02" },
  ['火上浇油！'] = {t=500, icon="Temp" },
  ['投掷臭气弹'] = {t=2000, icon="INV_Misc_Bowl_01" },
  ['死亡之触'] = {t=3000, icon="Spell_Shadow_UnsummonBuilding" },
  ['鸦爪之触'] = {t=1500, icon="Spell_Shadow_Requiem" },
  ['毒性箭'] = {t=2500, icon="Spell_Nature_CorrosiveBreath" },
  ['毒性唾液'] = {t=500, icon="Spell_Nature_CorrosiveBreath" },
  ['毒性喷溅'] = {t=2500, icon="Spell_Nature_CorrosiveBreath" },
  ['变形受害者'] = {t=2000, icon="Spell_Magic_LesserInvisibilty" },
  ['特雷莱恩冰触术'] = {t=3000, icon="Spell_Shadow_UnsummonBuilding" },
  ['救伤'] = {t=7000, icon="Temp" },
  ['充实'] = {t=500, icon="Spell_Shadow_Charm" },
  ['真银万能钥匙'] = {t=5000, icon="Temp" },
  ['调节'] = {t=7000, icon="INV_Gizmo_02" },
  ['超度亡灵'] = {t=1500, icon="Spell_Holy_TurnUndead" },
  ['青色迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['Uldaman Boss Agro'] = {t=5000, icon="Spell_Nature_EarthBindTotem" },
  ['奥达曼钥匙法杖'] = {t=5000, icon="Temp" },
  ['Uldaman Sub-Boss Agro'] = {t=5000, icon="Spell_Nature_EarthBindTotem" },
  ['邪恶诅咒'] = {t=1000, icon="Spell_Shadow_CurseOfMannoroth" },
  ['打开玛雷的脚'] = {t=5000, icon="Temp" },
  ['开锁'] = {t=5000, icon="Temp" },
  ['未涂色的机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['不稳定化合物'] = {t=3000, icon="Spell_Fire_Incinerate" },
  ['乌洛克爪牙消失'] = {t=2000, icon="Temp" },
  ['使用灵珠'] = {t=3000, icon="Temp" },
  ['乌瑟尔的祭品'] = {t=2000, icon="Temp" },
  ['暗影迷雾'] = {t=1500, icon="Spell_Shadow_GatherShadows" },
  ['毒液喷吐'] = {t=2500, icon="Spell_Nature_CorrosiveBreath" },
  ['毒之克星'] = {t=2000, icon="Temp" },
  ['水果芳香'] = {t=1000, icon="INV_ValentinesChocolate02" },
  ['Viewing Room Student Transform - Effect'] = {t=1000, icon="Temp" },
  ['紫色迅猛龙'] = {t=3000, icon="Ability_Mount_Raptor" },
  ['Vipore Cat Form DND'] = {t=1000, icon="Temp" },
  ['虚空箭'] = {t=3000, icon="Spell_Shadow_ShadowBolt" },
  ['虚空行者守卫'] = {t=3000, icon="Spell_Shadow_SummonVoidWalker" },
  ['快速传染'] = {t=2000, icon="Spell_Holy_HarmUndeadAura" },
  ['乱射'] = {t=3000, icon="Ability_TheBlackArrow" },
  ['乱射 II'] = {t=3000, icon="Ability_TheBlackArrow" },
  ['巫毒'] = {t=1000, icon="Spell_Shadow_AntiShadow" },
  ['巫毒妖术'] = {t=1000, icon="Spell_Shadow_CurseOfMannoroth" },
  ['女妖之嚎'] = {t=2000, icon="Spell_Shadow_Possession" },
  ['游荡瘟疫'] = {t=2000, icon="Spell_Shadow_CallofBone" },
  ['战争践踏'] = {t=500, icon="Ability_WarStomp" },
  ['瓦罗什的变形'] = {t=1000, icon="Temp" },
  ['水泡'] = {t=1000, icon="Spell_Frost_Wisp" },
  ['弱效寒冰箭'] = {t=2200, icon="Spell_Frost_FrostBolt02" },
  ['旋风倾泻'] = {t=1500, icon="INV_Spear_05" },
  ['白色机械陆行鸟'] = {t=3000, icon="Ability_Mount_MechaStrider" },
  ['白山羊'] = {t=3000, icon="Ability_Mount_MountainRam" },
  ['白马'] = {t=3000, icon="Ability_Mount_RidingHorse" },
  ['蛮力狂扫'] = {t=4000, icon="Ability_Whirlwind" },
  ['黑女巫的拥抱'] = {t=500, icon="Spell_Arcane_Blink" },
  ['野性回复'] = {t=3000, icon="Spell_Nature_Rejuvenation" },
  ['沙赫拉姆的意志'] = {t=1000, icon="Spell_Holy_MindVision" },
  ['Windsor Death DND'] = {t=1500, icon="Temp" },
  ['Windsor Reading Tablets DND'] = {t=10000, icon="Temp" },
  ['龙翼攻击'] = {t=1000, icon="INV_Misc_MonsterScales_14" },
  ['冬狼'] = {t=3000, icon="Ability_Mount_WhiteDireWolf" },
  ['冰斧智慧'] = {t=1000, icon="Ability_Ambush" },
  ['冬泉霜刃豹'] = {t=3000, icon="Ability_Mount_PinkTiger" },
  ['寒冬'] = {t=1500, icon="Spell_Nature_NullifyDisease" },
  ['凋零之触'] = {t=2000, icon="Spell_Nature_Drowsy" },
  ['巫师之油'] = {t=3000, icon="Temp" },
  ['熔解之语'] = {t=5000, icon="Temp" },
  ['沙虫横扫'] = {t=1000, icon="INV_Misc_MonsterScales_05" },
  ['致伤毒药'] = {t=3000, icon="INV_Misc_Herb_16" },
  ['愤怒'] = {t=2000, icon="Spell_Nature_AbolishMagic" },
  ['耶尼库的解脱'] = {t=4000, icon="Spell_Shadow_LifeDrain" },
  ['[PH] Buttress Activator'] = {t=5000, icon="Temp" },
  ['[PH] Cystal Bazooka'] = {t=1000, icon="Temp" },
  ['[PH] Teleport to Auberdine'] = {t=2000, icon="Temp" },
  ['[PH] Teleport to Balthule'] = {t=2000, icon="Temp" },
  ['[PH] Teleport to Booty Bay'] = {t=2000, icon="Temp" },
  ['[PH] Teleport to Felwood'] = {t=2000, icon="Temp" },
  ['[PH] Teleport to Grom\'Gol'] = {t=2000, icon="Temp" },
  ['[PH] Teleport to Menethil Harbor'] = {t=2000, icon="Temp" },
  ['[PH] Teleport to Orgrimmar'] = {t=2000, icon="Temp" },
  ['[PH] Teleport to Ratchet'] = {t=2000, icon="Temp" },
  ['[PH] Teleport to Theramore'] = {t=2000, icon="Temp" },
  ['[PH] Teleport to Undercity'] = {t=2000, icon="Temp" },
}

local Spells = {

	-- All Classes
		-- General
	[L["Hearthstone"]] = {t=10.0};
	[L["Rough Copper Bomb"]] = {t=1, ni=1};
	[L["Large Copper Bomb"]] = {t=1, ni=1};
	[L["Small Bronze Bomb"]] = {t=1, ni=1};
	[L["Big Bronze Bomb"]] = {t=1, ni=1};
	[L["Iron Grenade"]] = {t=1, ni=1};
	[L["Big Iron Bomb"]] = {t=1, ni=1};
	[L["Mithril Frag Bomb"]] = {t=1, ni=1};
	[L["Hi-Explosive Bomb"]] = {t=1, ni=1};
	[L["Thorium Grenade"]] = {t=1, ni=1};
	[L["Dark Iron Bomb"]] = {t=1, ni=1};
	[L["Arcane Bomb"]] = {t=1, ni=1};
	[L["Sleep"]] = {t=1.5, ni=1};
	[L["Reckless Charge"]] = {t=0};
	[L["Dark Mending"]] = {t=3.5};
	[L["Intense Pain"]] = {t=1};
	[BS["Sacrifice"]] = {t=1};
	[L["Great Heal"]] = {t=2};
	[L["Sweep"]] = {t=1.5};
	[L["Sand Blast"]] = {t=2.0};
	[L["Locust Swarm"]] = {t=3};
	[L["Meteor"]] = {t=1.5};
	[L["Unyielding Pain"]] = {t=2};
	[L["Condemnation"]] = {t=2};
	[L["Holy Bolt"]] = {t=2};
	[L["Polarity Shift"]] = {t=3};
	[L["Ball Lightning"]] = {t=1};
	[L["Destroy Egg"]] = {t=3};
	[L["Fireball Volley"]] = {2};
	[L["Flame Breath"]] = {2};
	[L["Time Lapse"]] = {2};
	[L["Incinerate"]] = {2};
	[L["Ignite Flesh"]] = {2};
	[L["Frost Burn"]] = {2};
	[L["Corrosive Acid"]] = {2};
	[L["Dominate Mind"]] = {2};
	[L["Demon Portal"]] = {0.5};
	

		-- First Aid
	[L["First Aid"]] = {t=8.0};
	[L["Linen Bandage"]] = {t=3.0};
	[L["Heavy Linen Bandage"]] = {t=3.0};
	[L["Wool Bandage"]] = {t=3.0};
	[L["Heavy Wool Bandage"]] = {t=3.0};
	[L["Silk Bandage"]] = {t=3.0};
	[L["Heavy Silk Bandage"]] = {t=3.0};
	[L["Mageweave Bandage"]] = {t=3.0};
	[L["Heavy Mageweave Bandage"]] = {t=3.0};
	[L["Runecloth Bandage"]] = {t=3.0};
	[L["Heavy Runecloth Bandage"]] = {t=3.0};
	
	-- Druid
	[BS["Healing Touch"]] = {t=3.0};
	[BS["Regrowth"]] = {t=2.0, g=21.0};
	[BS["Rebirth"]] = {t=2.0, d=1800.0};
	[BS["Starfire"]] = {t=3};
	[BS["Wrath"]] = {t=1.5};
	[BS["Entangling Roots"]] = {t=1.5};
	[BS["Hibernate"]] = {t=1.5};
	[BS["Soothe Animal"]] = {t=1.5};
	[BS["Barkskin"]] = {t=0};
	[BS["Teleport: Moonglade"]] = {t=10.0};
	[BS["Travel Form"]] = {t=0};
	[BS["Dire Bear Form"]] = {t=0};
	[BS["Cat Form"]] = {t=0};
	[BS["Bear Form"]] = {t=0};
	[BS["Moonkin Form"]] = {t=0};
	[BS["Aquatic Form"]] = {t=0};
	[L["Feral Charge Effect"]] = {t=0};
	[BS["Bash"]] = {t=0};
	[L["Starfire Stun"]] = {t=0};
	[BS["Pounce"]] = {t=0};
	[BS["Nature's Swiftness"]] = {t=0};
	
	-- Hunter
	[BS["Aimed Shot"]] = {t=3.0};
	[BS["Multi-Shot"]] = {t=0.5};
	[BS["Scare Beast"]] = {t=1.5};
	[BS["Dismiss Pet"]] = {t=5.0};
	[BS["Revive Pet"]] = {t=10.0};
	[BS["Eyes of the Beast"]] = {t=2.0};
	[BS["Scatter Shot"]] = {t=0};
	[BS["Freezing Trap Effect"]] = {t=0};
	[BS["Intimidation"]] = {t=0};
	[BS["Wyvern Sting"]] = {t=0};
	
	-- Mage
	[BS["Frostbolt"]] = {t=2.5};
	[BS["Fireball"]] = {t=3.0};
	[BS["Conjure Water"]] = {t=3.0};
	[BS["Conjure Food"]] = {t=3.0};
	[BS["Conjure Mana Ruby"]] = {t=3.0};
	[BS["Conjure Mana Citrine"]] = {t=3.0};
	[BS["Conjure Mana Jade"]] = {t=3.0};
	[BS["Conjure Mana Agate"]] = {t=3.0};
	[BS["Polymorph"]] = {t=1.5};
	[L["Polymorph: Pig"]] = {t=1.5};
	[L["Polymorph: Turtle"]] = {t=1.5};
	[BS["Pyroblast"]] = {t=6.0, d=60.0};
	[BS["Scorch"]] = {t=1.5};
	[BS["Flamestrike"]] = {t=3.0, r="Death Talon Hatcher", a=2};
	[BS["Slow Fall"]] = {t=0, c="gains"};
	[BS["Portal: Darnassus"]] = {t=10.0};
	[BS["Portal: Thunder Bluff"]] = {t=10.0};
	[BS["Portal: Ironforge"]] = {t=10.0};
	[BS["Portal: Orgrimmar"]] = {t=10.0};
	[BS["Portal: Stormwind"]] = {t=10.0};
	[BS["Portal: Undercity"]] = {t=10.0};
	[BS["Teleport: Darnassus"]] = {t=10.0};
	[BS["Teleport: Thunder Bluff"]] = {t=10.0};
	[BS["Teleport: Ironforge"]] = {t=10.0};
	[BS["Teleport: Orgrimmar"]] = {t=10.0};
	[BS["Teleport: Stormwind"]] = {t=10.0};
	[BS["Teleport: Undercity"]] = {t=10.0};
	[BS["Impact"]] = {t=0};
	[BS["Fire Ward"]] = {t=0.0};
	[BS["Frost Ward"]] = {t=0.0};
	[BS["Frost Armor"]] = {t=0.0};
	[BS["Ice Armor"]] = {t=0.0};
	[BS["Mage Armor"]] = {t=0.0};
	[L["Counterspell - Silenced"]] = {t=0.0, ni=1};
	[BS["Ice Barrier"]] = {t=0.0};
	[BS["Mana Shield"]] = {t=0.0};
	[BS["Blink"]] = {t=0};
	[BS["Ice Block"]] = {t=0};
	
	-- Paladin
	[BS["Seal of Wisdom"]] = {t=0};
	[BS["Seal of Light"]] = {t=0};
	[BS["Seal of Righteousness"]] = {t=0};
	[BS["Seal of Command"]] = {t=0};
	[BS["Seal of the Crusader"]] = {t=0};
	[BS["Seal of Justice"]] = {t=0};
	[BS["Righteous Fury"]] = {t=0};
	[BS["Holy Light"]] = {t=2.5};
	[BS["Flash of Light"]] = {t=1.5};
	[BS["Summon Charger"]] = {t=3.0, g=0.0};
	[BS["Summon Warhorse"]] = {t=3.0, g=0.0};
	[BS["Hammer of Wrath"]] = {t=1.0, d=6.0};
	[BS["Holy Wrath"]] = {t=2.0, d=60.0};
	[BS["Turn Undead"]] = {t=1.5, d=30.0};
	[BS["Redemption"]] = {t=10.0};
	[BS["Divine Protection"]] = {t=0};
	[BS["Divine Shield"]] = {t=0};
	[BS["Hammer of Justice"]] = {t=0};
	
	-- Priest
	[BS["Greater Heal"]] = {t=2.5};
	[BS["Flash Heal"]] = {t=1.5};
	[BS["Heal"]] = {t=2.5};
	[BS["Resurrection"]] = {t=10.0};
	[BS["Smite"]] = {t=2};
	[BS["Mind Blast"]] = {t=1.5, d=8.0};
	[BS["Mind Control"]] = {t=3.0};
	[BS["Mana Burn"]] = {t=2.5};
	[BS["Holy Fire"]] = {t=3.0, d=15.0};
	[BS["Mind Soothe"]] = {t=0};
	[BS["Prayer of Healing"]] = {t=3.0};
	[BS["Shackle Undead"]] = {t=1.5};
	[BS["Fade"]] = {t=0};
	[BS["Psychic Scream"]] = {t=0.0};
	[BS["Silence"]] = {t=0.0, ni = 1};
	[BS["Blackout"]] = {t=0.0};
	
	-- Rogue
	[BS["Disarm Trap"]] = {t=5.0};
	[BS["Mind-numbing Poison"]] = {t=3.0};
	[BS["Mind-numbing Poison II"]] = {t=3.0};
	[BS["Mind-numbing Poison III"]] = {t=3.0};
	[BS["Instant Poison"]] = {t=3.0};
	[BS["Instant Poison II"]] = {t=3.0};
	[BS["Instant Poison III"]] = {t=3.0};
	[BS["Instant Poison IV"]] = {t=3.0};
	[BS["Instant Poison V"]] = {t=3.0};
	[BS["Instant Poison VI"]] = {t=3.0};
	[BS["Deadly Poison"]] = {t=3.0};
	[BS["Deadly Poison II"]] = {t=3.0};
	[BS["Deadly Poison III"]] = {t=3.0};
	[BS["Deadly Poison IV"]] = {t=3.0};
	[BS["Deadly Poison V"]] = {t=3.0};
	[BS["Crippling Poison"]] = {t=3.0};
	[BS["Pick Lock"]] = {t=5.0};
	[BS["Blind"]] = {t=0};
	[BS["Gouge"]] = {t=0};
	[BS["Kidney Shot"]] = {t=0};
	[L["Kick - Silenced"]] = {t=0, ni=1};
	[BS["Kick"]] = {t=0, ni=1};
	
	-- Shaman
	[BS["Lesser Healing Wave"]] = {t=1.5};
	[BS["Healing Wave"]] = {t=3.0};
	[BS["Ancestral Spirit"]] = {t=10.0};
	[BS["Chain Lightning"]] = {t=1.5, d=6.0};
	[BS["Ghost Wolf"]] = {t=3.0};
	[BS["Astral Recall"]] = {t=10.0};
	[BS["Chain Heal"]] = {t=2.5};
	[BS["Lightning Bolt"]] = {t=2.0};
	[BS["Far Sight"]] = {t=2.0};
	[BS["Earth Shock"]] = {t=0, ni=1};
	
	-- Warlock
	[BS["Drain Life"]] = {t=7};
	[BS["Shadow Bolt"]] = {t=2.5};
	[BS["Immolate"]] = {t=1.5};
	[BS["Soul Fire"]] = {t=4.0};
	[BS["Searing Pain"]] = {t=1.5};
	[BS["Summon Dreadsteed"]] = {t=3.0};
	[BS["Summon Felsteed"]] = {t=3.0};
	[BS["Summon Imp"]] = {t=6.0};
	[BS["Summon Succubus"]] = {t=6.0};
	[BS["Summon Voidwalker"]] = {t=6.0};
	[BS["Summon Felhunter"]] = {t=6.0};
	[BS["Fear"]] = {t=1.5};
	[BS["Howl of Terror"]] = {t=2.0};
	[BS["Banish"]] = {t=1.5};
	[BS["Ritual of Summoning"]] = {t=5.0};
	[BS["Ritual of Doom"]] = {t=10.0};
	[BS["Create Spellstone"]] = {t=5.0};
	[BS["Create Soulstone"]] = {t=3.0};
	[BS["Create Healthstone"]] = {t=3.0};
	[BS["Create Firestone"]] = {t=3.0};
	[BS["Enslave Demon"]] = {t=3.0};
	[BS["Inferno"]] = {t=2.0};
	[L["Inferno Effect"]] = {t=0};
	[BS["Shadow Ward"]] = {t=0};
	[BS["Death Coil"]] = {t=0.0};
	[BS["Corruption"]] = {t=0};
	[BS["Demon Armor"]] = {t=0};
	[BS["Demon Skin"]] = {t=0};

		-- Succubus
		[BS["Seduction"]] = {t=1.5};
		
		-- Felhunter
		[BS["Spell Lock"]] = {t=0.0, ni=1};
		
		-- Imp
		[BS["Firebolt"]] = {t=2};

	-- Warrior
	[BS["Charge Stun"]] = {t=0};
	[BS["Intercept Stun"]] = {t=0};
	[BS["Revenge Stun"]] = {t=0};
	[BS["Mace Stun Effect"]] = {t=0};
	[BS["Intimidating Shout"]] = {t=0};
	[L["Shield Bash - Silenced"]] = {t=0};
	[BS["Shield Bash"]] = {t=0, ni=1};
	[BS["Pummel"]] = {t=0, ni=1};
	
}

local Raids = {

	-- Ahn'Qiraj

		-- 20 Man Trash
		[L["Explode"]] = {t=6.0};

		-- 40 Man C'thun
		[L["Eye Beam"]] = {t=2};

	-- Blackwing Lair
			
		-- Firemaw/Flamegor/Ebonroc
		[L["Shadow Flame"]] = {t=2.0};
		[L["Wing Buffet"]] = {t=1.0};
		
		-- Neferian/Onyxia
		[L["Bellowing Roar"]] = {t=1.5};
		
		[L["High Priestess Mar'li"]] = true;
		[BS["Drain Life"]] = {t=7};
		
		[L["Emperor Vek'lor"]] = true;
		[L["Gehennas"]] = true;
		[L["Gothik the Harvester"]] = true;
		[BS["Shadow Bolt"]] = {t=1, r=L["Gehennas"], a=0.5};
		[L["Flamewaker Elite"]] = true;
		[BS["Fireball"]] = {t=3, r=L["Flamewaker Elite"], a=1};
		[L["Flamewaker Priest"]] = true;
		[L["Dark Mending"]] = {t=3.5, r=L["Flamewaker Priest"], a=2};
		
		-- Zul'Gurub
		[L["Unstable Concoction"]] = {t=3.0};
}

local NonAfflictions = {
	[BS["Frostbolt"]] = true;
	[BS["Fireball"]] = true;
	[BS["Pyroblast"]] = true;
	[BS["Entangling Roots"]] = true;
	[BS["Soothe Animal"]] = true;
	[BS["Mind Soothe"]] = true;
	[BS["Immolate"]] = true;
	[BS["Corruption"]] = true;
	[BS["Regrowth"]] = true;
--	[BS["Mind Control"]] = true;
	[BS["Holy Fire"]] = true;
	[BS["Greater Heal"]] = true;
}

local Interrupts = {
	[BS["Shield Bash"]] = true;
	[BS["Pummel"]] = true;
	[BS["Kick"]] = true;
	[BS["Earth Shock"]] = true;
}

Cast:RegisterEvent("MINIMAP_ZONE_CHANGED")

local function TriggerCast(mob, spell, castime)
	if CasterDB[mob] then
		CasterDB[mob].sp = spell
		CasterDB[mob].start = GetTime()
		CasterDB[mob].ct = castime
	else
		CasterDB[mob] = {sp = spell, start = GetTime(), ct = castime}
	end
	for _,frame in pairs(LunaUF.Units.frameList) do
		if frame.unit and frame.castBar and LunaUF.db.profile.units[frame.unitGroup].castBar.enabled and mob == UnitName(frame.unit) then
			Cast:FullUpdate(frame)
		end
	end
end

local function TriggerCastStop(mob, spell)
	if CasterDB[mob] and CasterDB[mob].sp and Spells[spell] and not (Spells[spell].ni and Spells[CasterDB[mob].sp] and Spells[CasterDB[mob].sp].ni) then
		if (CasterDB[mob].start + (CasterDB[mob].ct or 0)) > GetTime() then
			CasterDB[mob].ct = 0
			for _,frame in pairs(LunaUF.Units.frameList) do
				if frame.unit and frame.castBar and LunaUF.db.profile.units[frame.unitGroup].castBar.enabled and mob == UnitName(frame.unit) then
					Cast:FullUpdate(frame)
				end
			end
		end
	end
end

local function ProcessData(mob, spell, special)
	local castime
	if (Raids[mob] and Raids[spell]) or (Raids[spell] and not Spells[spell]) then
		if special ~= "hit" then
			castime = Raids[spell].t
			-- Spell might have the same name but a different cast time on another mob, ie. Onyxia/Nefarian on Bellowing Roar
			if Raids[spell].r then
				if (mob == Raids[spell].r) then
					castime = Raids[spell].a
				end
			end
			TriggerCast(mob, spell, castime)
		elseif Interrupts[spell] then
			if CasterDB[mob] and CasterDB[mob].ct and CasterDB[mob].ct > 0 then
				TriggerCastStop(mob, spell)
				return
			end
		end
	else
		if Spells[spell] and special ~= "hit" then
			if special == "afflicted" then
				if not NonAfflictions[spell] then
					TriggerCastStop(mob, spell)
				end
				return
			end
			castime = Spells[spell].t
			if special == "gains" then
				if not NonAfflictions[spell] then
					TriggerCastStop(mob, spell)
				end
				return
			end
			-- Spell might have the same name but a different cast time on another mob, ie. Death Talon Hatchers/Players on Bellowing Roar
			if Spells[spell].r then
				if mob == Spells[spell].r then
					castime = Spells[spell].a
				end
			end
			TriggerCast(mob, spell, castime)
		elseif Interrupts[mob] then -- for these, the two things are parsed in reverse order
			if CasterDB[spell] and CasterDB[spell].ct and CasterDB[spell].ct > 0 then
				TriggerCastStop(spell, mob)
				return
			end
		elseif PFSpells[spell] and special ~= "hit" then
			castime = PFSpells[spell].t/1000
			TriggerCast(mob, spell, castime)
		end
	end
end

function Cast:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS(arg1)
	if LunaUF.db.profile.enemyCastbars then return end
	for _, pattern in pairs(CHAT_PATTERNS["gains"]) do
		for mob, spell in string.gfind(arg1, pattern) do
			ProcessData(mob, spell, "gains")
			return
		end
	end
end
Cast.CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS = Cast.CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS
Cast.CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS = Cast.CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS

function Cast:CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF(arg1)
	if LunaUF.db.profile.enemyCastbars then return end
	-- casts/performs
	for _, pattern in pairs(CHAT_PATTERNS["casts"]) do
		for mob, spell in string.gfind(arg1, pattern) do
			ProcessData(mob, spell, "casts")
			return
		end
	end
	for _, pattern in pairs(CHAT_PATTERNS["interrupt"]) do
		for mob, spell in string.gfind(arg1, pattern) do
			ProcessData(mob, spell, "hit")
			return
		end
	end
end
Cast.CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF = Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
Cast.CHAT_MSG_SPELL_PARTY_BUFF = Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
Cast.CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF = Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
Cast.CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF = Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
Cast.CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF = Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
Cast.CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE = Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE = Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
Cast.CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE = Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
Cast.CHAT_MSG_SPELL_PARTY_DAMAGE = Cast.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF

function Cast:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(arg1)
	if LunaUF.db.profile.enemyCastbars then return end
	for _, pattern in pairs(CHAT_PATTERNS["afflicted"]) do
		for mob, spell in string.gfind(arg1, pattern) do
			ProcessData(mob, spell, "afflicted")
			return
		end
	end
end
Cast.CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = Cast.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE
Cast.CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE = Cast.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE
Cast.CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE = Cast.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE

function Cast:CHAT_MSG_SPELL_SELF_DAMAGE(arg1)
	if LunaUF.db.profile.enemyCastbars then return end
	for _, pattern in pairs(CHAT_PATTERNS["selfinterrupt"]) do
		for mob, spell in string.gfind(arg1, pattern) do
			ProcessData(mob, spell, "hit")
			return
		end
	end
end

local function OnUpdateOther()
	local elapsed = GetTime() - this.startTime
	if this.casting then
		if this.maxValue >= elapsed then
			this.bar:SetValue(elapsed)
			this.Time:SetText(math.floor((this.maxValue - elapsed)*100)/100)
		else
			this.bar:SetMinMaxValues(0,1)
			this.bar:SetValue(0)
			this.casting = false
			this.Text:Hide()
			this.Time:Hide()
			if LunaUF.db.profile.units[this:GetParent().unitGroup].castBar.hide and not this.hidden then
				this.hidden = true
				LunaUF.Units:PositionWidgets(this:GetParent())
			end
		end
	end
end

local function OnUpdatePlayer()
	local sign
	local frame = this:GetParent()
	local elapsed = GetTime() - frame.castBar.startTime
	local text = string.sub(math.max((frame.castBar.maxValue - elapsed + frame.castBar.delaySum),0)+0.001,1,4)
	if (frame.castBar.delaySum ~= 0) then
		local delay = string.sub(math.max(frame.castBar.delaySum, 0)+0.001,1,4)
		if (frame.castBar.channeling == 1) then
			sign = "-"
		else
			sign = "+"
		end
		text = "|cffcc0000"..sign..delay.."|r "..text
	end
	if frame.castBar.casting or frame.castBar.channeling then
		frame.castBar.Time:SetText(text)
	else
		frame.castBar.Time:SetText("")
	end
	
	if (frame.castBar.casting) then
		if (elapsed > (frame.castBar.maxValue + frame.castBar.delaySum) ) then
			frame.castBar.casting = nil
			elapsed = frame.castBar.maxValue
			frame.castBar:SetScript("OnUpdate", nil)
			Cast:FullUpdate(frame)
			return
		end
		frame.castBar.bar:SetValue(elapsed)
	elseif (frame.castBar.channeling) then
		if (elapsed > frame.castBar.maxValue) then
			elapsed = frame.castBar.maxValue
		end
		if (elapsed == frame.castBar.maxValue) then
			frame.castBar.channeling = nil
			frame.castBar:SetScript("OnUpdate", nil)
			Cast:FullUpdate(frame)
			return
		end
		frame.castBar.bar:SetValue(frame.castBar.maxValue - elapsed)
	end
end

-- stolen from OCB, thanks Athene!

local function ItemLinkToName(link)
	return gsub(link,"^.*%[(.*)%].*$","%1");
end

local function GetItemIconTexture(item)
	if ( not item ) or type(item) ~= "string" or item == "" then return "Interface\\Icons\\Temp" end
	item = string.lower(item)
	local link;
	for i = 1,23 do
		link = GetInventoryItemLink("player",i)
		if ( link ) then
			if ( item == string.lower(ItemLinkToName(link)) )then
				return GetInventoryItemTexture('player', i)
			end
		end
	end
	for i = 1,12 do
		inventoryID = KeyRingButtonIDToInvSlotID(i)
		link = GetInventoryItemLink("player",inventoryID)
		if ( link ) then
			if ( item == string.lower(ItemLinkToName(link)) )then
				return GetInventoryItemTexture('player', inventoryID)
			end
		end
	end
	local texture
	for i = 0,NUM_BAG_FRAMES do
		for j = 1,MAX_CONTAINER_ITEMS do
			link = GetContainerItemLink(i,j)
			if ( link ) then
				if (string.find(string.lower(ItemLinkToName(link)), item)) then
					texture = GetContainerItemInfo(i,j)
				end
			end
		end
	end
	return texture or "Interface\\Icons\\Temp"
end

local function isBuffed()
	for i=1, 32 do
		if UnitBuff("player",i) == "Interface\\Icons\\Racial_Troll_Berserk" then
			return true
		end
	end
end

local function OnEvent()
	local frame = this:GetParent()
	if event == "SPELLCAST_CHANNEL_START" then
		frame.castBar.startTime = GetTime()
		frame.castBar.maxValue = (arg1 / 1000)
		frame.castBar.bar:SetMinMaxValues(0, frame.castBar.maxValue)
		frame.castBar.bar:SetValue(frame.castBar.maxValue)
		frame.castBar.casting = false
		frame.castBar.channeling = true
		frame.castBar.delaySum = 0
		local spellName = CL:GetSpell()
		frame.castBar.Text:SetText(spellName)
		if LunaUF.db.profile.units[frame.unitGroup].castBar.icon then
			frame.castBar.icon:SetTexture(BS:GetSpellIcon(spellName or "") or GetItemIconTexture(spellName))
		end
		frame.castBar:SetScript("OnUpdate", OnUpdatePlayer)
		Cast:FullUpdate(frame)
	elseif event == "SPELLCAST_CHANNEL_UPDATE" then
		if (arg1 == 0) then
			frame.castBar.channeling = nil
			frame.castBar.delaySum = 0
		elseif (frame.castBar.channeling) then
			local losttime = frame.castBar.maxValue - (frame.castBar.maxValue - (arg1 / 1000)) - (arg1 / 1000)
			--frame.castBar.elapsed = frame.castBar.maxValue - (arg1 / 1000)
			frame.castBar.delaySum = frame.castBar.delaySum + losttime
		end
	elseif event == "SPELLCAST_DELAYED" then
		if arg1 then
			frame.castBar.delaySum = (frame.castBar.delaySum or 0) + (arg1 / 1000)
			local statusMin, statusMax = frame.castBar.bar:GetMinMaxValues()
			frame.castBar.bar:SetMinMaxValues(statusMin, (statusMax + (arg1 / 1000)))
		end
	elseif event == "SPELLCAST_START" then
		frame.castBar.maxValue = (arg2 / 1000)
		frame.castBar.startTime = GetTime()
		frame.castBar.casting = true
		frame.castBar.channeling = false
		frame.castBar.delaySum = 0
		frame.castBar.Text:SetText(arg1)
		if LunaUF.db.profile.units[frame.unitGroup].castBar.icon then
			frame.castBar.icon:SetTexture(BS:GetSpellIcon(arg1) or GetItemIconTexture(arg1))
		end
		frame.castBar.bar:SetMinMaxValues(0, frame.castBar.maxValue)
		frame.castBar.bar:SetValue(0)
		frame.castBar:SetScript("OnUpdate", OnUpdatePlayer)
		Cast:FullUpdate(frame)
	elseif event == "UNIT_AURA" then
		local newBuffStatus = isBuffed()
		if not buffed and newBuffStatus then
			buffed = true
			if((UnitHealth("player")/UnitHealthMax("player")) >= 0.40) then
				berserkValue = (1.30 - (UnitHealth("player")/UnitHealthMax("player")))/3
			else
				berserkValue = 0.3
			end
		elseif buffed and not newBuffStatus then
			berserkValue = 0
			buffed = nil
		end
	else
		if (event == "SPELLCAST_CHANNEL_STOP" and not frame.castBar.channeling) then return end
		if (event == "SPELLCAST_FAILED" and frame.castBar.channeling) then return end
		frame.castBar.casting = false
		frame.castBar.channeling = false
		frame.castBar:SetScript("OnUpdate", nil)
		Cast:FullUpdate(frame)
	end
end

local function OnAimed(cast)
	if cast == BS["Aimed Shot"] then
		local _,_, latency = GetNetStats()
		local casttime = 3
		for i=1,32 do
			if UnitBuff("player",i) == "Interface\\Icons\\Ability_Warrior_InnerRage" then
				casttime = casttime/1.3
			end
			if UnitBuff("player",i) == "Interface\\Icons\\Ability_Hunter_RunningShot" then
				casttime = casttime/1.4
			end
			if UnitBuff("player",i) == "Interface\\Icons\\Racial_Troll_Berserk" then
				casttime = casttime/ (1 + berserkValue)
			end
			if UnitBuff("player",i) == "Interface\\Icons\\Inv_Trinket_Naxxramas04" then
				casttime = casttime/1.2
			end
			if UnitDebuff("player",i) == "Interface\\Icons\\Spell_Shadow_CurseOfTounges" then
				casttime = casttime/0.5
			end
		end
		for _,uframe in pairs(LunaUF.Units.frameList) do
			if uframe.castBar and LunaUF.db.profile.units[uframe.unitGroup].castBar.enabled and UnitIsUnit(uframe.unit,"player") then
				uframe.castBar.maxValue = casttime + (latency/1000)
				uframe.castBar.casting = true
				uframe.castBar.channeling = false
				uframe.castBar.delaySum = 0
				uframe.castBar.startTime = GetTime()
				uframe.castBar.Text:SetText(BS["Aimed Shot"])
				if LunaUF.db.profile.units[uframe.unitGroup].castBar.icon then
					uframe.castBar.icon:SetTexture(BS:GetSpellIcon("Aimed Shot"))
				end
				uframe.castBar.bar:SetMinMaxValues(0, uframe.castBar.maxValue)
				uframe.castBar.bar:SetValue(0)
				uframe.castBar:SetScript("OnUpdate", OnUpdatePlayer)
				Cast:FullUpdate(uframe)
			end
		end
	elseif cast == BS["Multi-Shot"] then
		local _,_, latency = GetNetStats()
		for _,uframe in pairs(LunaUF.Units.frameList) do
			if uframe.castBar and LunaUF.db.profile.units[uframe.unitGroup].castBar.enabled and UnitIsUnit(uframe.unit,"player") then
				uframe.castBar.maxValue = 0.5 + (latency/1000)
				uframe.castBar.casting = true
				uframe.castBar.channeling = false
				uframe.castBar.delaySum = 0
				uframe.castBar.startTime = GetTime()
				uframe.castBar.Text:SetText(BS["Multi-Shot"])
				if LunaUF.db.profile.units[uframe.unitGroup].castBar.icon then
					uframe.castBar.icon:SetTexture(BS:GetSpellIcon("Multi-Shot"))
				end
				uframe.castBar.bar:SetMinMaxValues(0, uframe.castBar.maxValue)
				uframe.castBar.bar:SetValue(0)
				uframe.castBar:SetScript("OnUpdate", OnUpdatePlayer)
				Cast:FullUpdate(uframe)
			end
		end
	end
end

local function OnSizeChanged(frame)
	local castBar = frame or this
	local height = castBar:GetHeight()
	local width = castBar:GetWidth()
	local config = LunaUF.db.profile.units[castBar:GetParent().unitGroup].castBar
	if config.icon then
		castBar.icon:ClearAllPoints()
		castBar.bar:ClearAllPoints()
		if config.vertical then
			if config.reverse then
				castBar.icon:SetPoint("TOP", castBar, "TOP")
				castBar.bar:SetPoint("BOTTOM", castBar, "BOTTOM")
			else
				castBar.icon:SetPoint("BOTTOM", castBar, "BOTTOM")
				castBar.bar:SetPoint("TOP", castBar, "TOP")
			end
			castBar.icon:SetHeight(width)
			castBar.icon:SetWidth(width)
			castBar.bar:SetHeight(height-width)
			castBar.bar:SetWidth(width)
		else
			if config.reverse then
				castBar.icon:SetPoint("RIGHT", castBar, "RIGHT")
				castBar.bar:SetPoint("LEFT", castBar, "LEFT")
			else
				castBar.icon:SetPoint("LEFT", castBar, "LEFT")
				castBar.bar:SetPoint("RIGHT", castBar, "RIGHT")
			end
			castBar.icon:SetHeight(height)
			castBar.icon:SetWidth(height)
			castBar.bar:SetHeight(height)
			castBar.bar:SetWidth(width-height)
		end
	else
		castBar.bar:SetHeight(height)
		castBar.bar:SetWidth(width)
	end
end

function Cast:OnEnable(frame)
	if not frame.castBar then
		frame.castBar = CreateFrame("Frame", nil, frame)
		frame.castBar.bar = LunaUF.Units:CreateBar(frame.castBar)
		frame.castBar.bar:SetAllPoints(frame.castBar)
		frame.castBar.icon = frame.castBar:CreateTexture(nil, "ARTWORK")
		frame.castBar.Text = frame.castBar.bar:CreateFontString(nil, "ARTWORK")
		frame.castBar.Text:SetAllPoints(frame.castBar.bar)
		frame.castBar.Text:SetShadowColor(0, 0, 0, 1.0)
		frame.castBar.Text:SetShadowOffset(0.80, -0.80)
		frame.castBar.Text:SetJustifyH("LEFT")
		frame.castBar.Time = frame.castBar.bar:CreateFontString(nil, "ARTWORK")
		frame.castBar.Time:SetAllPoints(frame.castBar.bar)
		frame.castBar.Time:SetShadowColor(0, 0, 0, 1.0)
		frame.castBar.Time:SetShadowOffset(0.80, -0.80)
		frame.castBar.Time:SetJustifyH("RIGHT")
	end
	frame.castBar:RegisterEvent("SPELLCAST_CHANNEL_START")
	frame.castBar:RegisterEvent("SPELLCAST_CHANNEL_STOP")
	frame.castBar:RegisterEvent("SPELLCAST_CHANNEL_UPDATE")
	frame.castBar:RegisterEvent("SPELLCAST_DELAYED")
	frame.castBar:RegisterEvent("SPELLCAST_FAILED")
	frame.castBar:RegisterEvent("SPELLCAST_INTERRUPTED")
	frame.castBar:RegisterEvent("SPELLCAST_START")
	frame.castBar:RegisterEvent("SPELLCAST_STOP")
	if playerRace == "Troll" and playerClass == "HUNTER" then
		frame.castBar:RegisterEvent("UNIT_AURA")
	end
	if not LunaUF:IsEventRegistered("CASTLIB_STARTCAST") and playerClass == "HUNTER" then
		LunaUF:RegisterEvent("CASTLIB_STARTCAST", OnAimed)
	end
	frame.castBar:SetScript("OnSizeChanged", OnSizeChanged)
end

function Cast:OnDisable(frame)
	if frame.castBar then
		frame.castBar:SetScript("OnUpdate", nil)
		frame.castBar:SetScript("OnEvent", nil)
		frame.castBar.casting = false
		frame.castBar.channeling = false
		frame.castBar:UnregisterAllEvents()
		frame.castBar:Hide()
	end
end

function Cast:FullUpdate(frame)
	local unitname = UnitName(frame.unit)
	frame.castBar.Text:SetFont("Interface\\AddOns\\LunaUnitFrames\\media\\fonts\\"..LunaUF.db.profile.font..".ttf", LunaUF.db.profile.units[frame.unitGroup].tags.bartags["castBar"].size)
	frame.castBar.Time:SetFont("Interface\\AddOns\\LunaUnitFrames\\media\\fonts\\"..LunaUF.db.profile.font..".ttf", LunaUF.db.profile.units[frame.unitGroup].tags.bartags["castBar"].size)
	if LunaUF.db.profile.units[frame.unitGroup].castBar.vertical then
		frame.castBar.bar:SetOrientation("VERTICAL")
	else
		frame.castBar.bar:SetOrientation("HORIZONTAL")
	end
	frame.castBar.bar:SetReverse(LunaUF.db.profile.units[frame.unitGroup].castBar.reverse)
	if frame.castBar and LunaUF.db.profile.units[frame.unitGroup].castBar.enabled and unitname then
		if not LunaUF.db.profile.units[frame.unitGroup].castBar.icon then
			frame.castBar.icon:SetTexture(nil)
		elseif frame.castBar.casting or frame.castBar.channeling then
			frame.castBar.icon:SetTexture(BS:GetSpellIcon(frame.castBar.Text:GetText() or "") or GetItemIconTexture(frame.castBar.Text:GetText() or ""))
		end
		if frame.castBar.casting then
			frame.castBar.bar:SetStatusBarColor(LunaUF.db.profile.castColors.cast.r, LunaUF.db.profile.castColors.cast.g, LunaUF.db.profile.castColors.cast.b)
		elseif frame.castBar.channeling then
			frame.castBar.bar:SetStatusBarColor(LunaUF.db.profile.castColors.channel.r, LunaUF.db.profile.castColors.channel.g, LunaUF.db.profile.castColors.channel.b)
		end
		if UnitIsUnit(frame.unit,"player") then
			frame.castBar:SetScript("OnEvent", OnEvent)
			if (frame.castBar.casting or frame.castBar.channeling) then
				if not LunaUF.db.profile.units[frame.unitGroup].castBar.vertical then
					frame.castBar.Text:Show()
					frame.castBar.Time:Show()
				end
				if frame.castBar.hidden then
					frame.castBar.hidden = false
					LunaUF.Units:PositionWidgets(frame)
				end
			else
				frame.castBar.Text:Hide()
				frame.castBar.Time:Hide()
				frame.castBar.icon:SetTexture(nil)
				frame.castBar.bar:SetMinMaxValues(0,1)
				frame.castBar.bar:SetValue(0)
				if LunaUF.db.profile.units[frame.unitGroup].castBar.hide and not frame.castBar.hidden then
					frame.castBar.hidden = true
					LunaUF.Units:PositionWidgets(frame)
				elseif not LunaUF.db.profile.units[frame.unitGroup].castBar.hide and frame.castBar.hidden then
					frame.castBar.hidden = nil
					LunaUF.Units:PositionWidgets(frame)
				end
			end
		else
			frame.castBar:SetScript("OnEvent", nil)
			if CasterDB[unitname] and CasterDB[unitname].ct and (CasterDB[unitname].start + CasterDB[unitname].ct) > GetTime() then
				frame.castBar.bar:SetMinMaxValues(0, CasterDB[unitname].ct)
				frame.castBar.startTime = CasterDB[unitname].start
				frame.castBar.maxValue = CasterDB[unitname].ct
				if not LunaUF.db.profile.units[frame.unitGroup].castBar.vertical then
					frame.castBar.Text:Show()
					frame.castBar.Time:Show()
				end
				frame.castBar.Text:SetText(CasterDB[unitname].sp)
				if LunaUF.db.profile.units[frame.unitGroup].castBar.icon then
					frame.castBar.icon:SetTexture(BS:GetSpellIcon(CasterDB[unitname].sp) or GetItemIconTexture(CasterDB[unitname].sp))
				end
				frame.castBar.casting = true
				frame.castBar:SetScript("OnUpdate", OnUpdateOther)
				if frame.castBar.hidden then
					frame.castBar.hidden = false
					LunaUF.Units:PositionWidgets(frame)
				end
			else
				frame.castBar.casting = false
				frame.castBar.channeling = false
				frame.castBar.bar:SetMinMaxValues(0,1)
				frame.castBar.bar:SetValue(0)
				frame.castBar.Text:Hide()
				frame.castBar.Time:Hide()
				frame.castBar.icon:SetTexture(nil)
				frame.castBar:SetScript("OnUpdate", nil)
				if LunaUF.db.profile.units[frame.unitGroup].castBar.hide and not frame.castBar.hidden then
					frame.castBar.hidden = true
					LunaUF.Units:PositionWidgets(frame)
				elseif not LunaUF.db.profile.units[frame.unitGroup].castBar.hide and frame.castBar.hidden then
					frame.castBar.hidden = nil
					LunaUF.Units:PositionWidgets(frame)
				end
			end
		end
		OnSizeChanged(frame.castBar)
	end
end

function Cast:SetBarTexture(frame,texture)
	frame.castBar.bar:SetStatusBarTexture(texture)
	frame.castBar.bar:SetStretchTexture(LunaUF.db.profile.stretchtex)
end

function Cast:MINIMAP_ZONE_CHANGED()
	if DisabledZones[GetMinimapZoneText()] then
		Cast:UnregisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
		Cast:UnregisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
		Cast:UnregisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE")
	else
		Cast:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
		Cast:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
		Cast:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE")
	end
end

Cast:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
Cast:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
Cast:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
Cast:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
Cast:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
Cast:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS")
Cast:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS")
Cast:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
Cast:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE")
Cast:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF")
Cast:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE")
Cast:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS")
Cast:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF")
Cast:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF")
Cast:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
Cast:MINIMAP_ZONE_CHANGED()
Cast:SetScript("OnEvent", function() this[event](this, arg1) end)