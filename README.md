# Interface

turtle-wow Interface file

文件名 说明

### 基本：

```
!Libs        = 基础函数库
Blizzard\_\* = 暴雪自带的
```

## UP 主插件分享顺序：

### 1、字体

```
放到 Fonts 文件夹里，魔兽主目录下
FZBWJW.TTF（任务说明字体）
FZJZJW.TTF（打怪时显示）
FZLBJW.TTF（登陆画面及人物、物品、装备、技能等.主字体）
FZXHJW.TTF（物品技能说明字体）
FZXHLJW.TTF（聊天）
FRIZQT\_\_.TTF 和 ARIALN.TTF（各种英文符号）

ClearFont = 字体清晰调整插件
```

### 2、团队小队头像角色框架

```
LunaUnitFrames = 露娜框架
```

### 3、动作条

```
ShaguTweaks   = Shagu 德国作者暗黑风格 UI
zUI           = ZUI 和 Shagu 其中一些插件需要禁用，在 ZUI 组件里禁用 https://github.com/Ko0z/zUI
```

### 4、战斗伤害

```
MikScrollingBattleText        = 战斗伤害 命令：/msbt
MikScrollingBattleTextOptions = 战斗伤害
```

#### 5、地图

```
Cartographer                = 地图插件-主体
Cartographer_Data           = 地图插件-矿石数据库
Cartographer_Herbalism      = 地图插件-草药数据库
Cartographer_Minimap_Coords = 地图插件-迷你地图插件
Cartographer_Mining         = 地图插件-矿物的过滤器
```

### 6、高科技

```
放到魔兽 data 目录下 5.自动登录 6.矿草光柱 7.尸体军旗
```

### 7、聊天频道

```
ChatMOD    = 聊天辅助插件 命令：/chatmod
S_ChatBar  = 聊天窗频道按钮下方（未在整合的包里，心情就像夜单独整理的）
ChatBar    = 群主的聊天频道按钮上方
ChatMats   = 聊天框材料链接（使用：alt + 左键 点击要制造物品图标）
```

### 8、盗贼专题

```
RogueFocus = 连击点 命令：/rfc 或者 /roguefocus
EasyUnlock = 右键箱子直接开锁插件
AutoBar    = 消耗品快捷栏
BuyEmAll   = 批量购买 (使用：shift + 右键购买物品)
```

### 9、实用三件套

```
AtlasLoot  = 掉落查询 https://github.com/Lexiebean/AtlasLoot
Atlas      = 副本地图
AtlasQuest = 副本任务
```

### 10、信息&背包

```
FuBar      = 信息条
Titan      = 泰坦信息条
TitanPlus  = 泰坦信息条 plus
OneBag     = 背包插件
OneBank    = 背包银行
OneRing    = 背包钥匙链
OneView    = 背包管理
```

### 11、冷却&拾取&物品信息

```
Zcc                 = 冷却计时插件 （命令：/zcc）
XLoot               = 拾取跟随鼠标焦点
SpecialTalent       = 天赋模拟器
SpecialTalentUI     = 天赋模拟器 UI
MobInfo2            = 怪物数据库
MobInfo2_Browser    = 怪物数据库
Mendeleev           = 物品提示信息
```

### 12、鼠标提示&距离&人物观察

```
DistanceWarning  = 目标距离
TinyTip          = 鼠标提示
TinyTipOptions   = 鼠标提示选项
SuperInspect     = 查看目标装备
SuperInspect_UI  = 查看目标装备
```

### 13、娱乐插件 1

```
AdvancedTradeSkillWindow = ATSW 商业生产技能增强
TrainerSkills            = 可学技能监视
Trainer                  = 训练者辅助，帮助你在你的城市找到训练者
MCP                      = 插件管理
```

### 14、娱乐插件 2

```
GryllsComboSounds = 盗贼连击点音效
FishEase          = 钓鱼插件 （命令：/fishease 或 /fe）
FelwoodGather     = 费伍德水果助手最新版
```

### 15、职业插件：猎人&萨满&骑士篇

```
PetFeeder         = 宠物插件
GFW_HuntersHelper = 猎人野兽技能显示
YaHT              = 猎人射击条助手
PallyPower        = 骑士一键祝福
CallOfElements    = 萨满图腾助手
```

### 16、小黑本&试衣间&法术计时条&一键驱散&装备比较

```
AuldLangSyne    = 好友和公会成员管理插件（命令：/AuldLangSyne 或 /auld）
ChatMats        = 聊天框材料链接
UndressButton   = 试衣间增强
Chronometer     = 法术计时条
Decursive       = 一键驱散
EquipCompare    = 装备比较（插件包里已经没有了）
```

### 其他视频里没讲过的：

```
!ImprovedErrorFrame         = 错误屏蔽插件 （命令 /ief 允许用户选择出现错误的帧或按钮 /iefd 调试）
AttackBar                   = 全职业攻击计时
aux-addon                   = 拍卖行助手
avbars                      = 战场计时条 （命令 显示：/avbars show 隐藏：/avbars hide 测试：/avbars test）
BigWigs                     = 首领警报
pfQuest                     = 任务助手
pfQuest-icons               = 采集图标
pfQuest-turtle              = 乌龟服任务数据库
Chronos                     = 时间管理插件 （不知道是干嘛的）
DoubleExperience            = 双倍经验插件
FancyAH                     = 拍卖行右键摆放不必拖动插件
FancyTrade                  = 交易栏右键摆放插件
Fizzle                      = 装备栏显示耐久 （命令：/fizzle 或 /fizz）
iLoot                       = 拾取报告插件 通知你谁摸了 BOSS 尸体
LTF                         = 队伍查找器
MacroTextStop               = 隐藏动作条宏按钮中的文本
MinimapButtonBag-TurtleWoW  = 小地图图标整合
ModifiedPowerAuras          = 简易 WA
oGlow                       = 装备材质高亮
Outfitter                   = 一键换装
Postal                      = 邮箱助手
PowerAuras                  = 触发和法术效果提示
QuestAnnouncer              = 任务进度通告
QuestItem                   = 任务物品提示
retarget                    = 不丢目标
ShaguDPS                    = 伤害统计
StatCompare                 = 角色属性查看
StatCompareBuff             = 显示角色装备提供的属性的Buff数据模块
StatCompareChar             = 显示角色装备提供的属性的全属性预估模块
StatCompareSets             = 装备属性套装集合
StatCompareSpell            = 显示角色装备提供的属性的法术/技能数据模块
StatCompareUI               = 装备属性对比的图形配置界面
SuperInspect                = 缓存目标装备详情依赖库
SuperInspect_UI             = 缓存目标装备详情UI
TrinketMenu                 = 饰品管理
TWThreat                    = 仇恨统计
Roid-Macros                 = 简单宏插件
SuperMacro                  = 超级宏
WIM                         = 私聊窗口化
FlightMap                   = 飞行点插件
ShaguValue                  = 物品价格
Masque                      = 动作条美化
SilverDragon                = 稀有怪物追踪
SmallerRollFrames           = 小窗口ROLL美化
StopWatch                   = 倒计时小插件
SimpleRaidTargetIcons       = 团队标记助手 选其一
Banana                      = 团队标记助手 选其一
AutoMessage                 = 自动发送消息
TWSunders                   = BOSS五层破甲检测助手
EquipColor                  = 背包不可用物品红色插件

```

### 插件默认不加载

```
在 .toc 文件里加入 ## DefaultState: Disable

## OptionalDeps: zUI ## 如果可用，应首先加载的附加组件。
## Dependencies: zUI ## 必须首先加载的附加组件。别名包括RequiredDeps 和 任何以 开头的单词Dep。

```

### 其他

```
-- 颜色解释

16进制颜色转换在线网站：https://www.rgbtohex.net/hex-to-rgb/

例如 cffffcc00 是一个十六进制颜色代码，表示ARGB（Alpha、红、绿、蓝）颜色

具体来说，cffffcc00 中的各个部分可以解释为：
c 表示这是一个ARGB颜色。
ff 是Alpha通道，表示完全不透明。
ff 是红色通道，表示红色分量最大。
cc 是绿色通道，表示绿色分量中等。
00 是蓝色通道，表示蓝色分量最小。
所以这个颜色是一个深橙色，相当于RGB表示法中的(255, 204, 0)。
```

```
-- 打印消息
local function p(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

-- 循环遍历数组
for i = 1, #myArray do
    print(myArray[i])
end

```

```
local chatcolors = {
  ["SAY"] = "|cffFFFFFF",
  ["EMOTE"] = "|cffFF7E40",
  ["YELL"] = "|cffFF3F40",
  ["PARTY"] = "|cffAAABFE",
  ["GUILD"] = "|cff3CE13F",
  ["OFFICER"] = "|cff40BC40",
  ["RAID"] = "|cffFF7D01",
  ["RAID_WARNING"] = "|cffFF4700",
  ["BATTLEGROUND"] = "|cffFF7D01",
  ["WHISPER"] = "|cffFF7EFF",
  ["CHANNEL"] = "|cffFEC1C0"
}
```

```
-- 职业颜色
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
```

### URL 链接

```
    API函数： https://wowpedia.fandom.com/wiki/World_of_Warcraft_API?oldid=255618
    API事件： https://github.com/shagu/wow-vanilla-api/blob/master/events.md
    界面纹理： https://github.com/doorknob6/vanilla-wow-interface-textures
    界面浏览器： https://wow-tools.vercel.app/
    工具： https://github.com/mitjafelicijan/wow-tools
    用户界面宏： https://github.com/Meridaw/Vanilla-Macros/tree/master/User%20Interface
    Lua定义：https://github.com/refaim/Vanilla-WoW-Lua-Definitions
    乌龟UI源： https://github.com/refaim/Turtle-WoW-UI-Source
    颜色转换： https://rgbacolorpicker.com/rgba-to-hex
    色轮选择器：https://rgbacolorpicker.com/color-wheel-picker
    魔兽里声音列表 PlaySound("")：https://wow.tools/files/sounds.php#search=&page=1
    宏命令：https://docs.qq.com/doc/DREZBVGZrUW9ucUZ6
```

### 内置函数的说明

```
## 是否可攻击目标
UnitCanAttack("player","target")

## 测试某个操作是否在使用范围内。 参数 动作槽
inRange = IsActionInRange(actionSlot);

在范围内 inRange
标志Flag - 如果动作槽没有动作或者没有当前目标，则为零。如果操作超出范围，则为 0；如果操作在范围内，则为 1。请注意，如果范围不适用于此操作或者您无法对目标使用该法术，则它始终返回 1。


```

### 事件

PLAYER_TARGET_CHANGED 目标发送改变时
ACTIONBAR_SLOT_CHANGED 当任何操作栏插槽的内容发生更改时触发；通常是按钮的拾取和放下。
PLAYER_ENTERING_WORLD 玩家登录、/重新加载 UI 或地图实例之间的区域时触发。基本上每当加载屏幕出现时。
CHARACTER_POINTS_CHANGED 当玩家的可用天赋点发生变化时触发。

## xml UI

```
## 窗体可拖拽，可以加锁定判断
<Scripts>
    <OnMouseDown>
        if( arg1 == "LeftButton" and LOCK==0 ) then
            this:StartMoving(); ## 开始移动
            ## Frame:StartSizing() ## 调整大小
        end
    </OnMouseDown>
    <OnMouseUp>
        if( arg1 == "LeftButton" ) then
            this:StopMovingOrSizing(); ## 停止移动或调整大小
        end
    </OnMouseUp>
</Scripts>
```
