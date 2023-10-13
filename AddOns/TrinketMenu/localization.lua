TrinketMenu.CheckOptInfo = {
	{"ShowIcon","ON","迷你地图按钮","显示或隐藏小地图按钮."},
	{"SquareMinimap","OFF","方形迷你地图","如果迷你地图是方形移动迷你地图按钮.","ShowIcon"},
	{"CooldownCount","OFF","冷却计时","在按钮上显示剩余冷却时间."},
	{"TooltipFollow","OFF","跟随鼠标","提示信息跟随鼠标.","ShowTooltips"},
	{"KeepOpen","OFF","保持列表开启","保持饰物列表始终开启."},
	{"KeepDocked","ON","保持列表粘附","保持饰物列表粘附在当前装备列表."},
	{"Notify","OFF","可使用提示","饰物冷却后提示玩家."},
	{"DisableToggle","OFF","禁止开关","止使用点击小地图按钮来控制列表的显示/隐藏.","ShowIcon"},
	{"NotifyChatAlso","OFF","在聊天窗口提示","在饰物冷却结束后在聊天窗口也发出提示信息."},
	{"Locked","OFF","锁定窗口","不能移动,缩放,转动饰品列表."},
	{"ShowTooltips","ON","显示提示信息","显示提示信息."},
	{"NotifyThirty","ON","三十秒提示","在饰品冷却前三十秒时提示玩家."},
	{"MenuOnShift","OFF","Shift显示列表","只有按下Shift才会显示饰品选择列表."},
	{"TinyTooltips","OFF","迷你提示","简化饰品的提示信息变为只有名字, 用途, 冷却.","ShowTooltips"},
	{"SetColumns","OFF","设置列表列数","设置饰品选择列表的列数.\n\n不选择此项 TrinketMenu 会自动排列."},
	{"LargeCooldown","ON","大字体","用更大的字体显示冷却时间.","CooldownCount"},
	{"ShowHotKeys","ON","显示快捷键","在饰品上显示绑定的快捷键."},
	{"StopOnSwap","OFF","被动饰品停止排队","当换上一个被动饰品时停止自动排队.  选中这个选项时, 当一个可点击饰品通过 TrinketMenu 被手动换上时同样会停止自动排队.."}
}

TrinketMenu.TooltipInfo = {
	{"TrinketMenu_LockButton","锁定窗口","不能移动,缩放,转动饰品列表."},
	{"TrinketMenu_Trinket0Check","上面饰品栏自动排队","选中这个选项会让饰品自动排队替换到上面的饰品栏.  你也可以Alt+点击饰品来开关自动排队."},
	{"TrinketMenu_Trinket1Check","下面饰品栏自动排队","选中这个选项会让饰品自动排队替换到下面的饰品栏.  你也可以Alt+点击饰品来开关自动排队."},
	{"TrinketMenu_SortPriority","高优先权","当选中这个选项时, 这个饰品会被第一时间装备上, 而不管装备着的饰品是否在冷却中.\n\n当没选中时, 这个饰品不会替换掉没有在冷却中的已装备饰品."},
	{"TrinketMenu_SortDelay","延迟替换","设置一个饰品被替换的时间 (秒).  比如, 你需要20秒得到大地之击的20秒BUFF."},
	{"TrinketMenu_SortKeepEquipped","暂停自动排队","选中这个选项,当这个饰品被装备时会暂停自动排队替换. 比如, 你有一个自动换装的插件在你骑马时把棍子上的胡萝卜装备上了."}
}

TrinketMenu.Tooltip1 = "点击: 开关选项窗口\n拖动: 移动设置按钮";
TrinketMenu.Tooltip2 = "左键点击: 开关饰物窗口\n右键点击: 开关选项窗口\n拖动: 移动设置按钮";
StopQueueHereText1 = "-- 停止排队线 --";
StopQueueHereText2 = "停止排队线";
StopQueueHereTooltip = "移动这个来标记让下面的饰品不自动排队.  当你想让一个被动饰品只允许手动换上时, 就把它移动到这条线的下面.";

TrinketMenu_Tab1:SetText("选项");
TrinketMenu_Tab2:SetText("下面      ");
TrinketMenu_Tab3:SetText("上面      ");

TrinketMenu_SortDelayText1:SetText("延迟")
TrinketMenu_SortDelayText2:SetText("秒")
--TrinketMenu_SortPriorityText:SetText("优先")
--TrinketMenu_SortKeepEquippedText:SetText("暂停自动排队")

TrinketMenu.Message1 = "|cFFFFFF00TrinketMenu 缩放:";
TrinketMenu.Message2 = "/trinket scale main (number) : 设置主列表缩放比";
TrinketMenu.Message3 = "/trinket scale menu (number) : 设置选择列表缩放比";
TrinketMenu.Message4 = "比如: /trinket scale menu 0.85";
TrinketMenu.Message5 = "提示: 你可以拖动右下角调整缩放比.";
TrinketMenu.Message6= "|cFFFFFF00TrinketMenu 帮助:";
TrinketMenu.Message7 = "/trinket or /trinketmenu : 开关列表";
TrinketMenu.Message8 = "/trinket reset : 重置所有设置";
TrinketMenu.Message9 = "/trinket opt : 打开设置窗口";
TrinketMenu.Message10 = "/trinket lock|unlock : 锁定/解锁窗口";
TrinketMenu.Message11 = "/trinket scale main|menu (number) : 缩放主/列表";


