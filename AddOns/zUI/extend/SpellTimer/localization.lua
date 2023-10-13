--------------------------------SpellTimer author:sharak--------------------------------------------------
--这里是插件(SpellTimer)的语言部分,现在有3种语言,其中简体中文和繁体中文我相信没多大问题,
--因为繁体wow也是根据简体来的,所以差别不会很大,而且我是直接重http://statue.sayya.org/wowdb/index.php
--复制的信息,应该不会有任何问题.英文版的搞的时间最长,pattern部分就花了不少时间,然后是技能,
--最郁闷的是资料库里的法术信息不全,问了很多朋友,象萨满的"宁静之风图腾"的英文名就是风来告诉我的.
--非常感谢大家的帮助.
-->加入了被动触发的天赋技能监视..这个太远了会不准确,原因用过ccw的都知道.<OK>
-->加入了审判计时,感谢原JudgmentTimer的作者提供的插件,我是在研究了他的插件后整合入Seplltimer的
-->加入了使用背包和装备物品的监视<被否决了>
-->加入了宠物技能的监视<OK>
-->目标施法监视与该SpellTimer是独立的2个模块,之间无多大关系.
SPELL_TIMER_NATURE = "自然之握"
Spell_TIMER_JUDGMENT = "审判"
SPELL_TIMER_LASTIONG_JUDGMENT = "持久审判"
SPELL_TIMER_LIGHT_JUDGMENT = "圣光审判"
SPELL_TIMER_WISDOM_JUDGMENT = "智慧审判"
SPELL_TIMER_TOOLTIP = "左键选目标，右键施放该法术。\nAlt+左键拖动图标移动窗口。"
SPELLTIMER_TEXT_OPTION_SLIDER = "你可以在原有法术的持续时间上再额外增加一段时间，拖动该滑动条来调整该时间。" 
SHOW_PROGRESS_BAR = "显示进度条"
SHOW_SPELL_NAME = "显示魔法名称"
ENABLE_SPELL_TIMER = "启用法术计时器"
SPELLTIMER_AIMED = "瞄准射击"
SPELLTIMER_CAST_BREAK = "被打断"
--ENABLE_SPELLTIMER_CASTBAR = "瞄准射击计时器"
SPELL_TIMER = "法术计时器"
SPELLTIMER_EFFECT = "效果"     
SPELLTIMER_ENTRAPMENT = "诱捕"
SPELLTIMER_LEVEL = "|cffff00ff 等级:|r"
SPELLTIMER_NAME = "|cffff00ff目标:|r"      
--      ST_BUTTON_RELOADUI = "重载插件"
--      ST_BUTTON_ClOSE = "关闭"
SHOW_SPELL_TARGETNAME = "显示目标名字"
SHOW_TOOLTIP_INFO = "精简鼠标提示"
SPELLTIMER_MINIMAPBUTTONPOS = "小地图按钮位置"
SPELLTIMER_MINIMAPBUTTON_POS_TOOLTIP = "设置法术计时器配置按钮在小地图上的位置"
ST_ENEMY_TEXT = {
     [1] = "载入目标施法计时器",
   [2] = "显示目标施法计时器的配置界面",
}
---------------------------------------------------------------------------------------------------------
 if (GetLocale() == "zhCN") then
      --class
      BF_CLASS_WARRIOR = "战士" 
      BF_CLASS_MAGE = "法师" 
      BF_CLASS_SHAMAN = "萨满祭司" 
      BF_CLASS_PALADIN = "圣骑士" 
      BF_CLASS_ROGUE = "盗贼" 
      BF_CLASS_HUNTER = "猎人" 
      BF_CLASS_WARLOCK = "术士" 
      BF_CLASS_PRIEST = "牧师" 
      BF_CLASS_DRUID = "德鲁伊"
      --
 
      ST_TRAP_EFFECT = {
              ["冰冻陷阱效果"] = "冰冻陷阱",
	      ["献祭陷阱效果"] = "献祭陷阱",
	      ["爆炸陷阱效果"] = "爆炸陷阱",
	      ["冰霜陷阱光环"] = "冰霜陷阱",
      }
      --patterns
      SPELLTIMER_SPELL_AFFLICTED_1 = "^(.+)受到了(.+)效果的影响。$"
--      SPELLTIMER_SPELL_AFFLICTED_2 = "(.+)受到(.+)的伤害";
      SPELLTIMER_SPELL_DISPEL_BUFF = "^(.+)的(.+)被移除了。$"
      SPELLTIMER_TOTEM_RUINED = "^(.+)被摧毁了。$"
      SPELLTIMER_HOSTILE_DEATH = "^你杀死了(.+)！$"
      SPELLTIMER_SPELL_SELF_FAIL = "^你施放(.+)失败"
      SPELLTIMER_SPELL_SELF_RESIST = "^(.+)抵抗了你的(.+)。$" or "^你的(.+)被(.+)抵抗了。$"
      SPELLTIMER_SPELL_EVADE = "^你的(.+)被(.+)闪避过去了。$"
      SPELLTIMER_SPELL_DODGE = "^你的(.+)被(.+)躲闪过去了。$"
      SPELLTIMER_SPELL_PARRY = "^你的(.+)被(.+)招架了。$"
      SPELLTIMER_SPELL_BLOCK = "^你的(.+)被(.+)格挡了。"
      SPELLTIMER_SPELL_ABSORB = "^你的(.+)被(.+)吸收了。"
      SPELLTIMER_SPELL_IMMUNE = "^你的(.+)施放失败。(.+)对此免疫。"
      SPELLTIMER_SPELL_MISS = "^你的(.+)没有击中(.+)。$"
      SPELLTIMER_SPELL_HIT = "^你击中(.+)造成(%d+)点伤害。"	
      SPELLTIMER_SPELL_Crit = "^你对(.+)造成(%d+)的致命一击伤害。"
      SPELLTIMER_AURA_GONE_OTHER = "^(.+)效果从(.+)身上消失。$"
      --spells
      SpellTimer_Spells = {};
      SpellTimer_Spells[BF_CLASS_WARLOCK] = {};
      SpellTimer_Spells[BF_CLASS_WARLOCK]["恐惧术"] = {"使敌人因为极度的恐惧而奔逃，最多持续([%d%.]+)秒。"}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["献祭"] = {"在([%d%.]+)秒内"}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["放逐术"] = {"但也不会受到任何伤害，最多持续([%d%.]+)秒。",nil,nil,nil,{["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["腐蚀术"] = {"腐蚀目标，在([%d%.]+)秒内造成"}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["生命虹吸"] = {"生命值转移给施法者，持续([%d%.]+)秒。"}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["厄运诅咒"] = {"对目标施加终极的诅咒，在([%d%.]+)分钟后", 60, nil, {"痛苦诅咒", "元素诅咒", "虚弱诅咒", "语言诅咒", "鲁莽诅咒", "暗影诅咒", "疲劳诅咒"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["痛苦诅咒"] = {"给目标施加痛苦的诅咒，使其在([%d%.]+)秒内受到", nil, nil, {"厄运诅咒", "元素诅咒", "虚弱诅咒", "语言诅咒", "鲁莽诅咒", "暗影诅咒", "疲劳诅咒"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["元素诅咒"] = {"受到火焰和冰霜系攻击时所承受的伤害提高%d+%%，效果持续([%d%.]+)分钟", 60, nil, {"痛苦诅咒", "厄运诅咒", "虚弱诅咒", "语言诅咒", "鲁莽诅咒", "暗影诅咒", "疲劳诅咒"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["虚弱诅咒"] = {"目标所能造成的伤害降低%d+点，持续([%d%.]+)分钟", 60, nil, {"痛苦诅咒", "厄运诅咒", "元素诅咒", "语言诅咒", "鲁莽诅咒", "暗影诅咒", "疲劳诅咒"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["语言诅咒"] = {"使其所有法术的施放时间延长%d+%%，持续([%d%.]+)秒", nil, nil, {"痛苦诅咒", "厄运诅咒", "元素诅咒", "虚弱诅咒", "鲁莽诅咒", "暗影诅咒", "疲劳诅咒"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["鲁莽诅咒"] = {"持续([%d%.]+)分钟", 60, nil, {"痛苦诅咒", "厄运诅咒", "元素诅咒", "虚弱诅咒", "语言诅咒", "暗影诅咒", "疲劳诅咒"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["暗影诅咒"] = {"效果持续([%d%.]+)分钟", 60, nil, {"痛苦诅咒", "厄运诅咒", "元素诅咒", "虚弱诅咒", "语言诅咒", "鲁莽诅咒", "疲劳诅咒"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["疲劳诅咒"] = {"持续([%d%.]+)秒", nil, nil, {"痛苦诅咒", "厄运诅咒", "元素诅咒", "虚弱诅咒", "语言诅咒", "鲁莽诅咒", "暗影诅咒"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["死亡缠绕"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["恐惧嚎叫"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["奴役恶魔"] = {"奴役效果最多持续([%d%.]+)分钟", 60, nil, nil, {["live"] = 1, ["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["燃烧"] = {nil, nil, 0, {"献祭"}}
      --PET      
      SpellTimer_Spells[BF_CLASS_WARLOCK]["诱惑"] = {"使其在最多([%d%.]+)秒内无法行动", nil,nil,nil,{["pet"] = 1}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["法术封锁"] = {"使敌人沉默([%d%.]+)秒。", nil,nil,nil,{["pet"] = 1}}  
      SpellTimer_Spells[BF_CLASS_ROGUE] = {}
      SpellTimer_Spells[BF_CLASS_ROGUE]["凿击"] = {"令其瘫痪([%d%.]+)秒，"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["绞喉"] = {"猛勒敌人的脖子，在([%d%.]+)秒内"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["闷棍"] = {"将目标击昏([%d%.]+)秒", nil, nil, nil, {["live"] = 1, ["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_ROGUE]["破甲"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["偷袭"] = {"使目标昏迷([%d%.]+)秒，"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["致盲"] = {"持续最多([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["割裂"] = {{"GetTimeFrompoints", "(%d+)点：%d+伤害，持续([%d%.]+)秒", "GetComboPoints"}}
      SpellTimer_Spells[BF_CLASS_ROGUE]["切割"] = {{"GetTimeFrompoints", "(%d+)点：([%d%.]+)秒", "GetComboPoints"}}
      SpellTimer_Spells[BF_CLASS_ROGUE]["脚踢"] = {"并使其在([%d%.]+)秒内"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["扰乱"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["还击"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["肾击"] = {{"GetTimeFrompoints", "(%d+)点：([%d%.]+)秒", "GetComboPoints"}}
      SpellTimer_Spells[BF_CLASS_ROGUE]["闪避"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["疾跑"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_PRIEST] = {}
      SpellTimer_Spells[BF_CLASS_PRIEST]["暗言术：痛"] = {"黑暗的咒语，在([%d%.]+)秒内造成"}
      SpellTimer_Spells[BF_CLASS_PRIEST]["沉默"] = {"使目标沉默，在([%d%.]+)秒内不能施法"}
      SpellTimer_Spells[BF_CLASS_PRIEST]["心灵尖啸"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_PRIEST]["吸血鬼的拥抱"] = {"效果持续([%d%.]+)分钟。", 60}
      SpellTimer_Spells[BF_CLASS_PRIEST]["恢复"] = {"在([%d%.]+)秒内恢复总计",nil,nil,nil,{["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_PRIEST]["束缚亡灵"] = {"束缚敌对亡灵单位，最多持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_PRIEST]["噬灵瘟疫"] = {"使目标患上疾病，在([%d%.]+)秒内"}
      SpellTimer_Spells[BF_CLASS_PRIEST]["精神控制"] = {"最多持续([%d%.]+)分钟。", 60}
      SpellTimer_Spells[BF_CLASS_PRIEST]["神圣之火"] = {"并在([%d%.]+)秒内造成"}
      SpellTimer_Spells[BF_CLASS_PRIEST]["安抚心灵"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARRIOR] = {}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["断筋"] = {"持续([%d%.]+)秒。"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["撕裂"] = {"在([%d%.]+)秒内造成"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["盾击"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["挫志怒吼"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["刺耳怒吼"] = {"眩晕([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["惩戒痛击"] = {"并迫使它在([%d%.]+)秒内一直攻击你。"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["雷霆一击"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["缴械"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["破胆怒吼"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["破甲攻击"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["致死打击"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["拦截"] = {"并使其昏迷([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_HUNTER] = {}
      SpellTimer_Spells[BF_CLASS_HUNTER]["照明弹"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_HUNTER]["猎人印记"] = {"持续([%d%.]+)分钟", 60, nil, nil, {["live"] = 1, ["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["摔绊"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_HUNTER]["恐吓野兽"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_HUNTER]["反击"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_HUNTER]["狂野怒火"] = {"持续([%d%.]+)秒",nil,nil,nil,{["notarget"] = 1, ["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["毒蛇钉刺"] = {"在([%d%.]+)秒内对其造成", nil, nil, {"蝰蛇钉刺", "毒蝎钉刺", "翼龙钉刺"}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["蝰蛇钉刺"] = {"在([%d%.]+)秒内抽取", nil, nil, {"毒蛇钉刺", "毒蝎钉刺", "翼龙钉刺"}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["毒蝎钉刺"] = {"持续([%d%.]+)秒", nil, nil, {"毒蛇钉刺", "蝰蛇钉刺", "翼龙钉刺"}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["翼龙钉刺"] = {"钉刺目标，使其沉睡([%d%.]+)秒", nil, nil, {"毒蛇钉刺", "蝰蛇钉刺", "毒蝎钉刺"}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["震荡射击"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_HUNTER]["驱散射击"] = {"并使其困惑([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_HUNTER]["冰冻陷阱"] = {{"GetTrapTime", {"使其在最多([%d%.]+)秒内无法行动", "陷阱可存在([%d%.]+)分钟"}, "SpellTimerReturnTwo"}, nil, nil, {"冰霜陷阱", "献祭陷阱", "爆炸陷阱"}, {["notarget"] = 1,["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["冰霜陷阱"] = {{"GetTrapTime", {"持续([%d%.]+)秒", "陷阱可以存在([%d%.]+)分钟"}, "SpellTimerReturnTwo"}, nil, nil, {"冰冻陷阱", "献祭陷阱", "爆炸陷阱"}, {["notarget"] = 1,["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["献祭陷阱"] = {{"GetTrapTime", {"持续([%d%.]+)秒", "最多存在([%d%.]+)分钟"}, "SpellTimerReturnTwo"}, nil, nil, {"冰冻陷阱", "冰霜陷阱", "爆炸陷阱"}, {["notarget"] = 1,["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["爆炸陷阱"] = {{"GetTrapTime", {"接下来的([%d%.]+)秒", "存在([%d%.]+)分钟"}, "SpellTimerReturnTwo"}, nil, nil, {"冰冻陷阱", "冰霜陷阱", "献祭陷阱"}, {["notarget"] = 1,["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["胁迫"] = {nil,nil,3}
      --pet
      SpellTimer_Spells[BF_CLASS_HUNTER]["狂野释放"] = {nil,nil,4,nil,{["pet"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["蝎毒"] = {nil,nil,8,nil,{["pet"] = 1}}
      SpellTimer_Spells[BF_CLASS_DRUID] = {}
      SpellTimer_Spells[BF_CLASS_DRUID]["休眠"] = {"最多持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_DRUID]["月火术"] = {"并在([%d%.]+)秒内造成"}
      SpellTimer_Spells[BF_CLASS_DRUID]["重击"] = {"使目标昏迷([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_DRUID]["挫志咆哮"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_DRUID]["精灵之火"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_DRUID]["精灵之火（野性）"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_DRUID]["纠缠根须"] = {"在([%d%.]+)秒内"}
      SpellTimer_Spells[BF_CLASS_DRUID]["自然之握"] = {"持续([%d%.]+)秒。",nil,nil,nil,{["纠缠根须"] = 1, ["notarget"] = 1}}      
      SpellTimer_Spells[BF_CLASS_DRUID]["突袭"] = {"并在([%d%.]+)秒内造成"}
      SpellTimer_Spells[BF_CLASS_DRUID]["撕扯"] = {{"GetTimeFrompoints", "(%d+)点：([%d%.]+)秒", "GetComboPoints"}}
      SpellTimer_Spells[BF_CLASS_DRUID]["愈合"] = {"并在([%d%.]+)秒内恢复",nil,nil,nil,{["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_DRUID]["回春术"] = {"治疗目标，在([%d%.]+)秒内",nil,nil,nil,{["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_DRUID]["扫击"] = {"在([%d%.]+)秒内"}
      SpellTimer_Spells[BF_CLASS_DRUID]["野性冲锋"] = {"并使其在([%d%.]+)秒内"}
      SpellTimer_Spells[BF_CLASS_DRUID]["虫群"] = {"在([%d%.]+)秒内"}     
      SpellTimer_Spells[BF_CLASS_SHAMAN] = {} 
      --震击类
      SpellTimer_Spells[BF_CLASS_SHAMAN]["冰霜震击"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["烈焰震击"] = {"并在随后的([%d%.]+)秒"}
      --大地  	
      SpellTimer_Spells[BF_CLASS_SHAMAN]["地缚图腾"] = {"持续([%d%.]+)秒", nil, nil, {"石爪图腾", "大地之力图腾", "石肤图腾", "战栗图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["石爪图腾"] = {"持续([%d%.]+)秒", nil, nil, {"地缚图腾", "大地之力图腾", "石肤图腾", "战栗图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 65}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["大地之力图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"地缚图腾", "石爪图腾", "石肤图腾", "战栗图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["石肤图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"地缚图腾", "石爪图腾", "大地之力图腾", "战栗图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["战栗图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"地缚图腾", "石爪图腾", "大地之力图腾", "石肤图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      --火
      SpellTimer_Spells[BF_CLASS_SHAMAN]["火焰新星图腾"] = {"持续([%d%.]+)秒", nil, nil, {"灼热图腾", "熔岩图腾", "抗寒图腾", "火舌图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["灼热图腾"] = {"持续([%d%.]+)秒", nil, nil, {"火焰新星图腾", "熔岩图腾", "抗寒图腾", "火舌图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["熔岩图腾"] = {"持续([%d%.]+)秒", nil, nil, {"火焰新星图腾", "灼热图腾", "抗寒图腾", "火舌图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["抗寒图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"火焰新星图腾", "灼热图腾", "熔岩图腾", "火舌图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["火舌图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"火焰新星图腾", "灼热图腾", "熔岩图腾", "抗寒图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      --空气
      SpellTimer_Spells[BF_CLASS_SHAMAN]["风之优雅图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"岗哨图腾","宁静之风图腾", "风墙图腾", "风怒图腾", "自然抗性图腾", "根基图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["宁静之风图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"岗哨图腾","风之优雅图腾", "风墙图腾", "风怒图腾", "自然抗性图腾", "根基图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["风墙图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"岗哨图腾","宁静之风图腾", "风之优雅图腾", "风怒图腾", "自然抗性图腾", "根基图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["风怒图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"岗哨图腾","宁静之风图腾", "风之优雅图腾", "风墙图腾", "自然抗性图腾", "根基图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["自然抗性图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"岗哨图腾","宁静之风图腾", "风之优雅图腾", "风墙图腾", "风怒图腾", "根基图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["根基图腾"] = {"持续([%d%.]+)秒", nil, nil, {"岗哨图腾","宁静之风图腾", "风之优雅图腾", "风墙图腾", "风怒图腾", "自然抗性图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["岗哨图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"宁静之风图腾", "风之优雅图腾", "风墙图腾", "风怒图腾", "自然抗性图腾", "根基图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 100}}
      --水
      SpellTimer_Spells[BF_CLASS_SHAMAN]["抗火图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"治疗之泉图腾", "法力之泉图腾", "法力之潮图腾", "清毒图腾", "祛病图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["治疗之泉图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"抗火图腾", "法力之泉图腾", "法力之潮图腾", "清毒图腾", "祛病图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["法力之泉图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"抗火图腾", "治疗之泉图腾", "法力之潮图腾", "清毒图腾", "祛病图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["法力之潮图腾"] = {"持续([%d%.]+)秒",nil, nil, {"抗火图腾", "治疗之泉图腾", "法力之泉图腾", "清毒图腾", "祛病图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["清毒图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"抗火图腾", "治疗之泉图腾", "法力之泉图腾", "法力之潮图腾", "祛病图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["祛病图腾"] = {"持续([%d%.]+)分钟", 60, nil, {"抗火图腾", "治疗之泉图腾", "法力之泉图腾", "法力之潮图腾", "清毒图腾"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_PALADIN] = {}
      SpellTimer_Spells[BF_CLASS_PALADIN]["制裁之锤"] = {"使目标昏迷([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_PALADIN]["忏悔"] = {"最多持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_PALADIN]["超度亡灵"] = {"最多([%d%.]+)秒"}  
      SpellTimer_Spells[BF_CLASS_PALADIN]["审判"] = {nil,nil,0,nil,{["圣光审判"] = 1, ["智慧审判"] = 1, ["十字军审判"] = 1, ["公证审判"] = 1}}
      SpellTimer_Spells[BF_CLASS_PALADIN]["公证审判"] = {"公证圣印",nil,10,{"圣光审判", "十字军审判", "智慧审判"}}
      SpellTimer_Spells[BF_CLASS_PALADIN]["圣光审判"] = {"光明圣印",nil,10,{"公证审判", "十字军审判", "智慧审判"}}
      SpellTimer_Spells[BF_CLASS_PALADIN]["十字军审判"] = {"十字军圣印",nil,10,{"圣光审判", "公证审判", "智慧审判"}}
      SpellTimer_Spells[BF_CLASS_PALADIN]["智慧审判"] = {"智慧圣印",nil,10,{"圣光审判","十字军审判", "公证审判"}}
      SpellTimer_Spells[BF_CLASS_MAGE] = {}
      SpellTimer_Spells[BF_CLASS_MAGE]["变形术"] = {"最多持续([%d%.]+)秒", nil, nil, {"变形术：猪", "变形术：龟"},{["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["变形术：猪"] = {"最多持续([%d%.]+)秒", nil, nil, {"变形术", "变形术：龟"},{["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["变形术：龟"] = {"最多持续([%d%.]+)秒", nil, nil, {"变形术", "变形术：猪"},{["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["冰锥术"] = {"持续([%d%.]+)秒", nil, nil, {"寒冰箭"},{["notarget"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["寒冰箭"] = {"持续([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_MAGE]["炎爆术"] = {"并在([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_MAGE]["火球术"] = {"并在([%d%.]+)秒"}
      SpellTimer_Spells[BF_CLASS_MAGE]["烈焰风暴"] = {"并在([%d%.]+)秒", nil, nil, nil, {["notarget"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["侦测魔法"] = {"持续([%d%.]+)分钟", 60}
      SpellTimer_Spells[BF_CLASS_MAGE]["冲击波"] = {"眩晕([%d%.]+)秒", nil, nil, nil, {["notarget"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["冰霜新星"] = {"最高可持续([%d%.]+)秒", nil, nil, nil, {["notarget"] = 1}} 
      --talents
      --只考虑了个别有用的天赋，象什么治疗之路什么的完全忽视了
      --天赋监视不是很准确
      SpellTimer_Talents = {}
      SpellTimer_Talents[BF_CLASS_MAGE] = {}
      SpellTimer_Talents[BF_CLASS_MAGE]["点燃"] = {"令其在([%d%.]+)秒", nil, nil, "点燃"}
      SpellTimer_Talents[BF_CLASS_MAGE]["冲击"] = {"令目标昏迷([%d%.]+)秒", nil, nil, "冲击"}
      SpellTimer_Talents[BF_CLASS_MAGE]["霜寒刺骨"] = {"冰冻([%d%.]+)秒", nil, nil, "霜寒刺骨"}
      SpellTimer_Talents[BF_CLASS_WARRIOR] = {}
      SpellTimer_Talents[BF_CLASS_WARRIOR]["重伤"] = {"使其在([%d%.]+)秒", nil, nil, "重伤"}				
      SpellTimer_Talents[BF_CLASS_WARRIOR]["強化复仇"] = {"令目标昏迷([%d%.]+)秒", nil, nil, "复仇昏迷"}	
      SpellTimer_Talents[BF_CLASS_SHAMAN] = {}
      SpellTimer_Talents[BF_CLASS_PALADIN] = {}
      SpellTimer_Talents[BF_CLASS_PALADIN]["辩护"] = {"持续([%d%.]+)秒", nil, nil, "辩护"}
      SpellTimer_Talents[BF_CLASS_PALADIN]["持久审判"] = {"持续时间延长([%d%.]+)秒", nil, nil, "持久审判"}
      SpellTimer_Talents[BF_CLASS_ROGUE] = {}
      SpellTimer_Talents[BF_CLASS_HUNTER] = {}
      SpellTimer_Talents[BF_CLASS_HUNTER]["诱捕"] = {"持续([%d%.]+)秒", nil, nil, "诱捕"}
      SpellTimer_Talents[BF_CLASS_WARLOCK] = {}
      SpellTimer_Talents[BF_CLASS_WARLOCK]["強化暗影箭"] = {"持续([%d%.]+)秒", nil, nil, "強化暗影箭"}
      SpellTimer_Talents[BF_CLASS_WARLOCK]["火焰冲撞"] = {"使目标昏迷([%d%.]+)秒", nil, nil, "火焰冲撞"}
      SpellTimer_Talents[BF_CLASS_PRIEST] = {}				
      SpellTimer_Talents[BF_CLASS_PRIEST]["昏阙"] = {"昏迷([%d%.]+)秒", nil, nil, "昏阙"}
      SpellTimer_Talents[BF_CLASS_DRUID] = {}
      SpellTimer_Talents[BF_CLASS_DRUID]["强化星火术"] = {"将目标击昏([%d%.]+)秒",nil,nil,"星火昏迷"}
      --物品  
      --[[
      SpellTimer_Spells[PlayerClass]["退化射线"] = {"持续([%d%.]+)秒",nil,nil,nil,{["退化射线"] = 1,["notarget"] = 1}}
      SpellTimer_Spells[PlayerClass]["铁皮手雷"] = {"并使他们昏迷([%d%.]+)秒",nil,nil,nil,{["铁皮手雷"] = 1,["notarget"] = 1}}
      SpellTimer_Spells[PlayerClass]["重磅铁制炸弹"] = {"并使他们昏迷([%d%.]+)秒",nil,nil,nil,{["重磅铁制炸弹"] = 1,["notarget"] = 1}}
      SpellTimer_Spells[PlayerClass]["地精撒网器"] = {"持续([%d%.]+)秒",nil,nil,nil,{["地精撒网器"] = 1}}
      SpellTimer_Spells[PlayerClass]["高爆炸弹"] = {"并使他们昏迷([%d%.]+)秒",nil,nil,nil,{["高爆炸弹"] = 1,["notarget"] = 1}}
      SpellTimer_Spells[PlayerClass]["瑟银手榴弹"] = {"并使他们昏迷([%d%.]+)秒",nil,nil,nil,{["瑟银手榴弹"]=1,["notarget"] = 1}}
      SpellTimer_Spells[PlayerClass]["黑铁炸弹"] = {"并使他们昏迷([%d%.]+)秒",nil,nil,nil,{["黑铁炸弹"] = 1,["notarget"] = 1}}
      SpellTimer_Spells[PlayerClass]["地精火箭头盔"] = {"将其昏迷([%d%.]+)秒",nil,nil,nil,{["地精火箭头盔"] = 1}} 
      --]]
else
      --<I found this info from http://wow.allakhazam.com/ and http://www.thottbot.com and wowwiki. Thanks for them.>
      --class
      BF_CLASS_WARRIOR = "Warrior" 
      BF_CLASS_MAGE = "Mage" 
      BF_CLASS_SHAMAN = "Shaman" 
      BF_CLASS_PALADIN = "Paladin" 
      BF_CLASS_ROGUE = "Rogue" 
      BF_CLASS_HUNTER = "Hunter" 
      BF_CLASS_WARLOCK = "Warlock" 
      BF_CLASS_PRIEST = "Priest" 
      BF_CLASS_DRUID = "Druid"
      --
      SPELL_TIMER_NATURE = "Nature's Grasp"
      Spell_TIMER_JUDGMENT = "Judgment"
      SPELL_TIMER_LASTIONG_JUDGMENT = "Lasting Judgment"  
      SPELL_TIMER_LIGHT_JUDGMENT = "Judgement of Light"
      SPELL_TIMER_WISDOM_JUDGMENT = "Judgement of Wisdom"





      SPELLTIMER_AIMED = "Aimed Shot"
      SPELLTIMER_EFFECT = "Effect"     
      SPELLTIMER_CAST_BREAK = "Break"

--      ST_TEXT_OPTION = "Help"
--      ST_BUTTON_RELOADUI = "Relaodui"
--      ST_BUTTON_ClOSE = "Close"

      ST_TRAP_EFFECT = {
              ["Freezing Trap Effect"] = "Freezing Trap",
	      ["Immolation Trap Effect"] = "Immolation Trap",
	      ["Explosive Trap Effect"] = "Explosive Trap",
	      ["Frost Trap Aura"] = "Frost Trap",
      }   
      --patterns
      SPELLTIMER_SPELL_AFFLICTED_1 = "^(.+) is afflicted by (.+).$";
--      SPELLTIMER_SPELL_AFFLICTED_2 = "-- dummy --";
      SPELLTIMER_SPELL_DISPEL_BUFF = "^(.+)'s (.+) is removed.$"
      SPELLTIMER_TOTEM_RUINED = "^(.+) is destroyed.$"
      SPELLTIMER_HOSTILE_DEATH = "^(.+) dies.$"
	  SPELLTIMER_HONOR_GAIN = "^(.+) dies.$"
      SPELLTIMER_SPELL_SELF_FAIL = "^You fail to cast (.+)."

      SPELLTIMER_SPELL_SELF_RESIST = "^Your (.+) was resisted by (.+).$"
      SPELLTIMER_SPELL_EVADE = "^Your (.+) was evaded by (.+).$"
      SPELLTIMER_SPELL_DODGE = "^Your (.+) was dodged by (.+).$"
      SPELLTIMER_SPELL_PARRY = "^Your (.+) is parried by (.+).$"
      SPELLTIMER_SPELL_BLOCK = "^Your (.+) was blocked by (.+)."
      SPELLTIMER_SPELL_ABSORB = "^Your (.+) is absorbed by (.+)."
      SPELLTIMER_SPELL_IMMUNE = "^Your (.+) failed. (.+) is immune."
      SPELLTIMER_SPELL_MISS = "^Your (.+) missed (.+).$"
      SPELLTIMER_SPELL_HIT = "^You hit (.+) for (%d+)."	
      SPELLTIMER_SPELL_Crit = "^You crit (.+) for (%d+)."
      SPELLTIMER_AURA_GONE_OTHER = "^(.+) fades from (.+)。$"
      --castbar      
      SpellTimer_CastBar_Disable = "Disabled SPELLTIMER_AIMED."
      SpellTimer_CastBar_Enable  = "Enabled SPELLTIMER_AIMED."
--    spells
      SpellTimer_Spells = {};
      SpellTimer_Spells[BF_CLASS_WARLOCK] = {};
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Fear"] = {"causing it to run in fear for up to ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Immolate"] = {"over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Banish"] = {"but making it invulnerable for up to ([%d%.]+) sec.",nil,nil,nil,{["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Corruption"] = {"Shadow damage over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Siphon Life"] = {"Lasts ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Curse of Doom"] = {"Shadow damage after ([%d%.]+) min.", 60, nil, {"Curse of Agony", "Curse of the Elements", "Curse of Weakness", "Curse of Tongues", "Curse of Recklessness", "Curse of Shadow", "Curse of Exhaustion"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Curse of Agony"] = {"Shadow damage over ([%d%.]+) sec.", nil, nil, {"Curse of Doom", "Curse of the Elements", "Curse of Weakness", "Curse of Tongues", "Curse of Recklessness", "Curse of Shadow", "Curse of Exhaustion"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Curse of the Elements"] = {"Curses the target for ([%d%.]+) min", 60, nil, {"Curse of Agony", "Curse of Doom", "Curse of Weakness", "Curse of Tongues", "Curse of Recklessness", "Curse of Shadow", "Curse of Exhaustion"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Curse of Weakness"] = {"the target is reduced by %d+ for ([%d%.]+) min.", 60, nil, {"Curse of Agony", "Curse of Doom", "Curse of the Elements", "Curse of Tongues", "Curse of Recklessness", "Curse of Shadow", "Curse of Exhaustion"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Curse of Tongues"] = {"Lasts ([%d%.]+) sec.", nil, nil, {"Curse of Agony", "Curse of Doom", "Curse of the Elements", "Curse of Weakness", "Curse of Recklessness", "Curse of Shadow", "Curse of Exhaustion"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Curse of Recklessness"] = {"reducing armor by %d+ for ([%d%.]+) min.", 60, nil, {"Curse of Agony", "Curse of Doom", "Curse of the Elements", "Curse of Weakness", "Curse of Tongues", "Curse of Shadow", "Curse of Exhaustion"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Curse of Shadow"] = {"Curses the target for ([%d%.]+) min", 60, nil, {"Curse of Agony", "Curse of Doom", "Curse of the Elements", "Curse of Weakness", "Curse of Tongues", "Curse of Recklessness", "Curse of Exhaustion"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Curse of Exhaustion"] = {"movement speed by %d+%% for ([%d%.]+) sec.", nil, nil, {"Curse of Agony", "Curse of Doom", "Curse of the Elements", "Curse of Weakness", "Curse of Tongues", "Curse of Recklessness", "Curse of Shadow"}}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Death Coil"] = {"the enemy target to run in horror for ([%d%.]+) sec"}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Howl of Terror"] = {"flee in terror for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Enslave Demon"] = {"Lasts up to ([%d%.]+) min", 60, nil, nil, {["live"] = 1, ["unique"] = 1}}
      --pet
      SpellTimer_Spells[BF_CLASS_WARLOCK]["Spell Lock"] = {"Silences the enemy for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_ROGUE] = {}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Gouge"] = {"incapacitating the opponent for ([%d%.]+) sec"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Garrote"] = {"Garrote the enemy, causing %d+ damage over ([%d%.]+) sec"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Sap"] = {"Incapacitates the target for up to ([%d%.]+) sec", nil, nil, nil, {["live"] = 1, ["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Expose Armor"] = {"Finishing move that exposes the target for ([%d%.]+) sec"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Cheap Shot"] = {"Stuns the target for ([%d%.]+) sec"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Blind"] = {"Blinds the target, causing it to wander disoriented for up to ([%d%.]+) sec"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Rupture"] = {{"GetTimeFrompoints", "(%d+) point : 60 damage over ([%d%.]+) secs", "GetComboPoints"}}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Slice and Dice"] = {{"GetTimeFrompoints", "(%d+) point : ([%d%.]+) sec", "GetComboPoints"}}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Kick"] = {"from being cast for ([%d%.]+) sec"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Distract"] = {"all nearby monsters for ([%d%.]+) sec"}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Riposte"] = {"disarms the target for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_ROGUE]["Kidney Shot"] = {{"GetTimeFrompoints", "(%d+) point : ([%d%.]+) second(%d+)", "GetComboPoints"}}
      SpellTimer_Spells[BF_CLASS_PRIEST] = {}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Shadow Word: Pain"] = {"A word of darkness that causes 30 Shadow damage over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Silence"] = {"from casting spells for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Psychic Scream"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Vampiric Embrace"] = {"you deal for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Renew"] = {"over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Shackle Undead"] = {"Shackles the target undead enemy for up to ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Devouring Plague"] = {"Lasts ([%d%.]+) min."}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Mind Control"] = {"Lasts up to ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Holy Fire"] = {"over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PRIEST]["Mind Soothe"] = {"Lasts ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR] = {}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Hamstring"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Rend"] = {"over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Shield Bash"] = {"from being cast for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Demoralizing Shout"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Piercing Howl"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Mocking Blow"] = {"forces the target to focus attacks on you for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Thunder Clap"] = {"for ([%d%.]+) sec"}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Disarm"] = {"Disarm the enemy's weapon for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Intimidating Shout"] = {"Lasts ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Sunder Armor"] = {"Lasts ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Mortal Strike"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_WARRIOR]["Intercept"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_HUNTER] = {}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Flare"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Hunter's Mark"] = {"Lasts for ([%d%.]+) min.", 60, nil, nil, {["live"] = 1, ["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Wing Clip"] = {"by %d+%% for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Scare Beast"] = {"fear for up to ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Counterattack"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Bestial Wrath"] = {"for ([%d%.]+) sec.",nil,nil,nil,{["notarget"] = 1,["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Serpent Sting"] = {"damage over ([%d%.]+) sec.", nil, nil, {"Viper Sting", "Scorpid Sting", "Wyvern Sting"}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Viper Sting"] = {"mana over ([%d%.]+) sec.", nil, nil, {"Serpent Sting", "Scorpid Sting", "Wyvern Sting"}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Scorpid Sting"] = {"by %d+ for ([%d%.]+) sec.", nil, nil, {"Serpent Sting", "Viper Sting", "Wyvern Sting"}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Wyvern Sting"] = {"over ([%d%.]+) sec.", nil, nil, {"Serpent Sting", "Viper Sting", "Scorpid Sting"}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Concussive Shot"] = {"speed by %d+%% for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Scatter Shot"] = {"the target for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Freezing Trap"] = {{"GetTrapTime", {"all action for up to ([%d%.]+) sec.", "Trap will exist for ([%d%.]+) min."}, "SpellTimerReturnTwo"}, nil, nil, {"Frost Trap", "Immolation Trap", "Explosive Trap"}, {["notarget"] = 1,["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Frost Trap"] = {{"GetTrapTime", {"around itself for ([%d%.]+) sec", "Trap will exist for ([%d%.]+) min."}, "SpellTimerReturnTwo"}, nil, nil, {"Freezing Trap", "Immolation Trap", "Explosive Trap"}, {["notarget"] = 1,["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Immolation Trap"] = {{"GetTrapTime", {"over ([%d%.]+) sec.", "exist for ([%d%.]+) min."}, "SpellTimerReturnTwo"}, nil, nil, {"Freezing Trap", "Frost Trap", "Explosive Trap"}, {["notarget"] = 1,["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_HUNTER]["Explosive Trap"] = {{"GetTrapTime", {"Fire damage over ([%d%.]+) sec", "Trap will exist for ([%d%.]+) min."}, "SpellTimerReturnTwo"}, nil, nil, {"Freezing Trap", "Frost Trap", "Immolation Trap"}, {["notarget"] = 1,["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_DRUID] = {}
      SpellTimer_Spells[BF_CLASS_DRUID]["Hibernate"] = {"for up to ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Moonfire"] = {"over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Bash"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Demoralizing Roar"] = {"Lasts ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Faerie Fire"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Faerie Fire (Feral)"] = {"for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Entangling Roots"] = {"over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Nature's Grasp"] = {"Lasts ([%d%.]+) sec",nil,nil,nil,{["Entangling Roots"] = 1}}     
      SpellTimer_Spells[BF_CLASS_DRUID]["Pounce"] = {"over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Rip"] = {{"GetTimeFrompoints", "(%d+) point : %d+ damage over ([%d%.]+) sec.", "GetComboPoints"}}
      SpellTimer_Spells[BF_CLASS_DRUID]["Regrowth"] = {"over ([%d%.]+) sec.",nil,nil,nil,{["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_DRUID]["Rejuvenation"] = {"over ([%d%.]+) sec.",nil,nil,nil,{["live"] = 1}}
      SpellTimer_Spells[BF_CLASS_DRUID]["Rake"] = {"over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Feral Charge"] = {"cast for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_DRUID]["Insect Swarm"] = {"over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_SHAMAN] = {}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Frost Shock"] = {"Lasts ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Flame Shock"] = {"over ([%d%.]+) sec."}
      --earth
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Earthbind Totem"] = {"for ([%d%.]+) sec", nil, nil, {"Stoneclaw Totem", "Strength of Earth Totem", "Stoneskin Totem", "Tremor Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Stoneclaw Totem"] = {"for ([%d%.]+) sec", nil, nil, {"Earthbind Totem", "Strength of Earth Totem", "Stoneskin Totem", "Tremor Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 65}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Strength of Earth Totem"] = {" Lasts ([%d%.]+) min.", 60, nil, {"Earthbind Totem", "Stoneclaw Totem", "Stoneskin Totem", "Tremor Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Stoneskin Totem"] = {"Lasts ([%d%.]+) min.", 60, nil, {"Earthbind Totem", "Stoneclaw Totem", "Strength of Earth Totem", "Tremor Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Tremor Totem"] = {"Lasts ([%d%.]+) min.", 60, nil, {"Earthbind Totem", "Stoneclaw Totem", "Strength of Earth Totem", "Stoneskin Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      --fire
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Fire Nova Totem"] = {"within ([%d%.]+) sec.", nil, nil, {"Searing Totem", "Magma Totem", "Frost Resistance Totem", "Flametongue Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Searing Totem"] = {"for ([%d%.]+) sec", nil, nil, {"Fire Nova Totem", "Magma Totem", "Frost Resistance Totem", "Flametongue Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Magma Totem"] = {"for ([%d%.]+) sec", nil, nil, {"Fire Nova Totem", "Searing Totem", "Frost Resistance Totem", "Flametongue Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Frost Resistance Totem"] = {"for ([%d%.]+) min.", 60, nil, {"Fire Nova Totem", "Searing Totem", "Magma Totem", "Flametongue Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Flametongue Totem"] = {"Lasts ([%d%.]+) min.", 60, nil, {"Fire Nova Totem", "Searing Totem", "Magma Totem", "Frost Resistance Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      --air
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Grace of Air Totem"] = {"Lasts ([%d%.]+) min.", 60, nil, {"Tranquil Air Totem", "Windwall Totem", "Windfury Totem", "Nature Resistance Totem", "Grounding Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Tranquil Air Totem"] = {"Lasts ([%d%.]+) min.", 60, nil, {"Grace of Air Totem", "Windwall Totem", "Windfury Totem", "Nature Resistance Totem", "Grounding Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Windwall Totem"] = {"Lasts ([%d%.]+) min.", 60, nil, {"Tranquil Air Totem", "Grace of Air Totem", "Windfury Totem", "Nature Resistance Totem", "Grounding Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Windfury Totem"] = {"Lasts ([%d%.]+) min.", 60, nil, {"Tranquil Air Totem", "Grace of Air Totem", "Windwall Totem", "Nature Resistance Totem", "Grounding Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Nature Resistance Totem"] = {"for ([%d%.]+) min", 60, nil, {"Tranquil Air Totem", "Grace of Air Totem", "Windwall Totem", "Windfury Totem", "Grounding Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Grounding Totem"] = {"Lasts ([%d%.]+) sec.", nil, nil, {"Tranquil Air Totem", "Grace of Air Totem", "Windwall Totem", "Windfury Totem", "Nature Resistance Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Sentry Totem"] = {"for ([%d%.]+) min", 60, nil, {"Tranquil Air Totem", "Grace of Air Totem", "Windwall Totem", "Windfury Totem", "Nature Resistance Totem", "Grounding Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 100}}
      --water
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Fire Resistance Totem"] = {"for ([%d%.]+) min", 60, nil, {"Healing Stream Totem", "Mana Spring Totem", "Mana Tide Totem", "Poison Cleansing Totem", "Disease Cleansing Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Healing Stream Totem"] = {"for ([%d%.]+) min", 60, nil, {"Fire Resistance Totem", "Mana Spring Totem", "Mana Tide Totem", "Poison Cleansing Totem", "Disease Cleansing Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Mana Spring Totem"] = {"for ([%d%.]+) min", 60, nil, {"Fire Resistance Totem", "Healing Stream Totem", "Mana Tide Totem", "Poison Cleansing Totem", "Disease Cleansing Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Mana Tide Totem"] = {"for ([%d%.]+) sec", nil, nil, {"Fire Resistance Totem", "Healing Stream Totem", "Mana Spring Totem", "Poison Cleansing Totem", "Disease Cleansing Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Poison Cleansing Totem"] = {"Lasts ([%d%.]+) min.", 60, nil, {"Fire Resistance Totem", "Healing Stream Totem", "Mana Spring Totem", "Mana Tide Totem", "Disease Cleansing Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_SHAMAN]["Disease Cleansing Totem"] = {"Lasts ([%d%.]+) min.", 60, nil, {"Fire Resistance Totem", "Healing Stream Totem", "Mana Spring Totem", "Mana Tide Totem", "Poison Cleansing Totem"}, {["notarget"] = 1, ["live"] = 1, ["hp"] = 5}}
      SpellTimer_Spells[BF_CLASS_PALADIN] = {}
      SpellTimer_Spells[BF_CLASS_PALADIN]["Hammer of Justice"] = {"Stuns the target for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PALADIN]["Repentance"] = {"for up to ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_PALADIN]["Turn Undead"] = {"flee for up to ([%d%.]+) sec."}  
      SpellTimer_Spells[BF_CLASS_PALADIN]["Judgement"] = {nil,nil,0,nil,{["Judgement of Light"] = 1, ["Judgement of Wisdom"] = 1, ["Judgement of Crusader"] = 1, ["Judgement of Justice"] = 1}}
      SpellTimer_Spells[BF_CLASS_PALADIN]["Judgement of Justice"] = {"Seal of Justice",nil,10,{"Judgement of Light", "Judgement of Crusader", "Judgement of Wisdom"}}
      SpellTimer_Spells[BF_CLASS_PALADIN]["Judgement of Light"] = {"Seal of Light",nil,10,{"Judgement of Justice", "Judgement of Crusader", "Judgement of Wisdom"}}
      SpellTimer_Spells[BF_CLASS_PALADIN]["Judgement of Crusader"] = {"Seal of the Crusader",nil,10,{"Judgement of Light", "Judgement of Justice", "Judgement of Wisdom"}}
      SpellTimer_Spells[BF_CLASS_PALADIN]["Judgement of Wisdom"] = {"	Seal of Wisdom",nil,10,{"Judgement of Light","Judgement of Crusader", "Judgement of Justice"}}
      SpellTimer_Spells[BF_CLASS_MAGE] = {}
      SpellTimer_Spells[BF_CLASS_MAGE]["Polymorph"] = {"around for up to ([%d%.]+) sec.", nil, nil, {"Polymorph: Pig", "Polymorph: Turtle"},{["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["Polymorph: Pig"] = {"around for up to ([%d%.]+) sec.", nil, nil, {"Polymorph", "Polymorph: Turtle"},{["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["Polymorph: Turtle"] = {"around for up to ([%d%.]+) sec.", nil, nil, {"Polymorph", "Polymorph: Pig"},{["unique"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["Cone of Cold"] = {"slowed by ([%d%.]+) for 8 sec.", nil, nil, {"Frostbolt"},{["notarget"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["Frostbolt"] = {"by 40% for ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_MAGE]["Pyroblast"] = {"damage over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_MAGE]["Fireball"] = {"damage over ([%d%.]+) sec."}
      SpellTimer_Spells[BF_CLASS_MAGE]["Flamestrike"] = {"damage over ([%d%.]+) sec.", nil, nil, nil, {["notarget"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["Detect Magic"] = {"the target for ([%d%.]+) min.", 60}
      SpellTimer_Spells[BF_CLASS_MAGE]["Blast Wave"] = {"dazing them for ([%d%.]+) sec.", nil, nil, nil, {["notarget"] = 1}}
      SpellTimer_Spells[BF_CLASS_MAGE]["Frost Nova"] = {"place for up to ([%d%.]+) sec.", nil, nil, nil, {["notarget"] = 1}}
      --talents     
      SpellTimer_Talents = {}
      SpellTimer_Talents[BF_CLASS_MAGE] = {}
      SpellTimer_Talents[BF_CLASS_MAGE]["Impact"] = {"for ([%d%.]+) sec.", nil, nil, "Impact"}
      SpellTimer_Talents[BF_CLASS_MAGE]["Ignite"] = {"damage over ([%d%.]+) sec.", nil, nil, "Ignite"}
      SpellTimer_Talents[BF_CLASS_MAGE]["Frostbite"] = {"for ([%d%.]+) sec.", nil, nil, "Frostbite"}
      SpellTimer_Talents[BF_CLASS_WARRIOR] = {}
      SpellTimer_Talents[BF_CLASS_WARRIOR]["Deep Wounds"] = {"over ([%d%.]+) sec.", nil, nil, "Deep Wounds"}				
      SpellTimer_Talents[BF_CLASS_WARRIOR]["Improved Revenge"] = {"for ([%d%.]+) sec.", nil, nil, "Revenge stun"} 
      SpellTimer_Talents[BF_CLASS_SHAMAN] = {}
      SpellTimer_Talents[BF_CLASS_PALADIN] = {}
      SpellTimer_Talents[BF_CLASS_PALADIN]["Vindication"] = {"for ([%d%.]+) sec.", nil, nil, "Vindication"}
      SpellTimer_Talents[BF_CLASS_PALADIN]["Lasting Judgment"] = {"by ([%d%.]+) sec.", nil, nil, "Lasting Judgment"}
      SpellTimer_Talents[BF_CLASS_ROGUE] = {}
      SpellTimer_Talents[BF_CLASS_HUNTER] = {}
      SpellTimer_Talents[BF_CLASS_HUNTER]["Entrapment"] = {"for ([%d%.]+) sec.", nil, nil, "Entrapment"}
      SpellTimer_Talents[BF_CLASS_WARLOCK] = {}
      SpellTimer_Talents[BF_CLASS_WARLOCK]["Improved Shadow Bolt"] = {"lasts a maximum of ([%d%.]+) sec.", nil, nil, "Improved Shadow Bolt"}
      SpellTimer_Talents[BF_CLASS_WARLOCK]["Pyroclasm"] = {"for ([%d%.]+) sec.", nil, nil, "Pyroclasm"}
      SpellTimer_Talents[BF_CLASS_PRIEST] = {}				
      SpellTimer_Talents[BF_CLASS_PRIEST]["Blackout"] = {"for ([%d%.]+) sec.", nil, nil, "Blackout"}
      SpellTimer_Talents[BF_CLASS_DRUID] = {}
      SpellTimer_Talents[BF_CLASS_DRUID]["Improved Starfire"] = {"stun the target for ([%d%.]+) sec.",nil,nil,"Starfire stun"} 

end