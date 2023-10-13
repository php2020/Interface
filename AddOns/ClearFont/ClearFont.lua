-- =============================================================================
--  CLEARFONT BY KIRKBURN  v11200-1 （狂鼠的中文修改版）
--  Official website:  http://www.clearfont.co.uk/
--  06.08.26
-- =============================================================================
--  CLEARFONT.LUA - STANDARD WOW UI FONTS
--  Home page:  http://bbs.ngacn.com/read.php?tid=538596
--  在此页面下载并查看详细说明！
-- =============================================================================

-- =============================================================================
--  一个字体框架和更为简洁的本地字体
--  你可以添加属于自己的本地字体,以下的就是例子(最后一行)
-- =============================================================================

ClearFont = CreateFrame("Frame", "ClearFont");

-- 如果你想使用自由高度和宽度的话,可将'Fonts' 改成'Fonts 2'
local CLEAR_FONT_BASE = "Fonts\\";

local CLEAR_FONT = CLEAR_FONT_BASE .. "FZLBJW.TTF";
local CLEAR_FONT_NUMBER = CLEAR_FONT_BASE .. "ARIALN.TTF";
local CLEAR_FONT_ZONE = CLEAR_FONT_BASE .. "FZLBJW.TTF";
local CLEAR_FONT_DAMAGE = CLEAR_FONT_BASE .. "FZJZJW.TTF";
local CLEAR_FONT_QUESTTITLE = CLEAR_FONT_BASE .. "FZLBJW.TTF";
local CLEAR_FONT_QUEST = CLEAR_FONT_BASE .. "FZBWJW.TTF";

-- 添加属于自己的字体
local YOUR_FONT_STYLE = CLEAR_FONT_BASE .. "YourFontName.ttf";

-- 字体的比例:比如,你想把所有字体缩小到80%,那么可以将"1"改成"0.8"
local CF_SCALE = 1

-- 查看现有的字体并变化它们
-----------------------------------------------------
local function CanSetFont(object)
   return (type(object) == "table" and object.SetFont and object.IsObjectType and not object:IsObjectType("SimpleHTML"));
end

-- =============================================================================
--  标准WOW用户界面这一部分
-- =============================================================================
--  这是最需要编辑的一块内容
--  主要的字体已经列出,其余部分字体按照字母表顺序排列
--  如果在补丁改变的情况下,陈述(声明)可能会有所忽略
-- =============================================================================
--  举个例子:游戏初始字体如下:SetFont(CLEAR_FONT, 16 * CF_SCALE)
--  在括号里的第一部分是字体类型,第二部分是字体大小
--  根据个人所需而改变
-- =============================================================================

function ClearFont:ApplySystemFonts()
   -- 世界环境中、3D字体等 (Dark Imakuni)
   --------------------------------------------
   -- 聊天泡泡
   STANDARD_TEXT_FONT = CLEAR_FONT;

   -- 人头上的名字
   UNIT_NAME_FONT = CLEAR_FONT;
   NAMEPLATE_FONT = CLEAR_FONT;

   -- 显示在被攻击目标头上的效果 (和插件SCT/SDT无关)
   DAMAGE_TEXT_FONT = CLEAR_FONT_DAMAGE;

   -- 拾取菜单字体大小
   UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 14 * CF_SCALE;

   -- 系统字体
   --------------
   if (CanSetFont(SystemFont)) then SystemFont:SetFont(CLEAR_FONT, 16 * CF_SCALE); end

   -- 主要字体: 显示在各处的可见主要字体部分
   -------------------------------------------------------

   if (CanSetFont(GameFontNormal)) then GameFontNormal:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontHighlight)) then GameFontHighlight:SetFont(CLEAR_FONT, 14 * CF_SCALE); end

   if (CanSetFont(GameFontDisable)) then SystemFont:SetFont(CLEAR_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontDisable)) then GameFontDisable:SetTextColor(0.6, 0.6, 0.6); end

   if (CanSetFont(GameFontGreen)) then GameFontGreen:SetFont(CLEAR_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontRed)) then GameFontRed:SetFont(CLEAR_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontWhite)) then GameFontWhite:SetFont(CLEAR_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontBlack)) then GameFontBlack:SetFont(CLEAR_FONT, 16 * CF_SCALE); end


   -- 小字体: 也用在泰坦数据面板（插件）
   ---------------------------------------------

   if (CanSetFont(GameFontNormalSmall)) then GameFontNormalSmall:SetFont(CLEAR_FONT, 14 * CF_SCALE); end

   if (CanSetFont(GameFontDisableSmall)) then GameFontDisableSmall:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontDisableSmall)) then GameFontDisableSmall:SetTextColor(0.6, 0.6, 0.6); end

   if (CanSetFont(GameFontDarkGraySmall)) then GameFontDarkGraySmall:SetFont(CLEAR_FONT, 16 * CF_SCALE); end
   if (CanSetFont(GameFontDarkGraySmall)) then GameFontDarkGraySmall:SetTextColor(0.4, 0.4, 0.4); end

   if (CanSetFont(GameFontGreenSmall)) then GameFontGreenSmall:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontRedSmall)) then GameFontRedSmall:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontHighlightSmall)) then GameFontHighlightSmall:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameFontHighlightSmallOutline)) then
      GameFontHighlightSmallOutline:SetFont(CLEAR_FONT, 14 * CF_SCALE,
         "OUTLINE");
   end


   -- 大字体: 标题
   ---------------------------

   if (CanSetFont(GameFontNormalLarge)) then GameFontNormalLarge:SetFont(CLEAR_FONT, 18 * CF_SCALE); end
   if (CanSetFont(GameFontHighlightLarge)) then GameFontHighlightLarge:SetFont(CLEAR_FONT, 18 * CF_SCALE); end

   if (CanSetFont(GameFontDisableLarge)) then GameFontDisableLarge:SetFont(CLEAR_FONT, 18 * CF_SCALE); end
   if (CanSetFont(GameFontDisableLarge)) then GameFontDisableLarge:SetTextColor(0.6, 0.6, 0.6); end

   if (CanSetFont(GameFontGreenLarge)) then GameFontGreenLarge:SetFont(CLEAR_FONT, 18 * CF_SCALE); end
   if (CanSetFont(GameFontRedLarge)) then GameFontRedLarge:SetFont(CLEAR_FONT, 18 * CF_SCALE); end


   -- 极大字体: Raid警报
   ---------------------------------

   if (CanSetFont(GameFontNormalHuge)) then GameFontNormalHuge:SetFont(CLEAR_FONT, 21 * CF_SCALE); end


   -- 战斗字: in-built SCT-style 信息 (仅1.12版有)
   ------------------------------------------------------

   if (CanSetFont(CombatTextFont)) then CombatTextFont:SetFont(CLEAR_FONT, 26 * CF_SCALE); end


   -- 数字字体: 拍卖行、金钱、键盘、数量叠加的用户界面
   ------------------------------------------------------------------------------

   if (CanSetFont(NumberFontNormal)) then NumberFontNormal:SetFont(CLEAR_FONT_NUMBER, 14 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalYellow)) then
      NumberFontNormalYellow:SetFont(CLEAR_FONT_NUMBER, 14 * CF_SCALE,
         "OUTLINE");
   end
   if (CanSetFont(NumberFontNormalSmall)) then NumberFontNormalSmall:SetFont(CLEAR_FONT_NUMBER, 14 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalSmallGray)) then
      NumberFontNormalSmallGray:SetFont(CLEAR_FONT_NUMBER, 14 * CF_SCALE,
         "OUTLINE");
   end
   if (CanSetFont(NumberFontNormalLarge)) then NumberFontNormalLarge:SetFont(CLEAR_FONT_NUMBER, 16 * CF_SCALE, "OUTLINE"); end

   if (CanSetFont(NumberFontNormalHuge)) then
      NumberFontNormalHuge:SetFont(CLEAR_FONT_DAMAGE, 24 * CF_SCALE,
         "THICKOUTLINE");
   end
   if (CanSetFont(NumberFontNormalHuge)) then NumberFontNormalHuge:SetAlpha(30); end


   -- 聊天窗口输入字体和聊天窗口字体大小
   --------------------------------------------------

   if (CanSetFont(ChatFontNormal)) then ChatFontNormal:SetFont(CLEAR_FONT, 14 * CF_SCALE); end

   CHAT_FONT_HEIGHTS = {
      [1] = 7,
      [2] = 8,
      [3] = 9,
      [4] = 10,
      [5] = 11,
      [6] = 12,
      [7] = 13,
      [8] = 14,
      [9] = 15,
      [10] = 16,
      [11] = 17,
      [12] = 18,
      [13] = 19,
      [14] = 20,
      [15] = 21,
      [16] = 22,
      [17] = 23,
      [18] = 24
   };


   -- 任务日志: 任务、书籍等
   ----------------------------------------------------

   if (CanSetFont(QuestTitleFont)) then QuestTitleFont:SetFont(CLEAR_FONT_QUESTTITLE, 18 * CF_SCALE); end
   if (CanSetFont(QuestTitleFont)) then QuestTitleFont:SetShadowColor(0.54, 0.4, 0.1); end

   if (CanSetFont(QuestFont)) then QuestFont:SetFont(CLEAR_FONT_QUEST, 14 * CF_SCALE); end
   if (CanSetFont(QuestFont)) then QuestFont:SetTextColor(0.15, 0.09, 0.04); end

   if (CanSetFont(QuestFontNormalSmall)) then QuestFontNormalSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end
   if (CanSetFont(QuestFontNormalSmall)) then QuestFontNormalSmall:SetShadowColor(0.54, 0.4, 0.1); end

   if (CanSetFont(QuestFontHighlight)) then QuestFontHighlight:SetFont(CLEAR_FONT_QUEST, 14 * CF_SCALE); end


   -- 对话框: “同意”等字样
   ---------------------------------

   if (CanSetFont(DialogButtonNormalText)) then DialogButtonNormalText:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
   if (CanSetFont(DialogButtonHighlightText)) then DialogButtonHighlightText:SetFont(CLEAR_FONT, 14 * CF_SCALE); end


   -- 错误字体: “另一个动作正在进行中”等字样
   -------------------------------------------------------------

   if (CanSetFont(ErrorFont)) then ErrorFont:SetFont(CLEAR_FONT, 16 * CF_SCALE); end
   if (CanSetFont(ErrorFont)) then ErrorFont:SetAlpha(60); end


   -- 物品信息: 框架内的综合使用形式（大概包括任务物品的版面字体，比如可以携带的书籍）
   -------------------------------------

   if (CanSetFont(ItemTextFontNormal)) then ItemTextFontNormal:SetFont(CLEAR_FONT_QUEST, 16 * CF_SCALE); end


   -- 邮件和发货单字体: 游戏中邮件和拍卖行发货单
   --------------------------------------------------------------

   if (CanSetFont(MailTextFontNormal)) then MailTextFontNormal:SetFont(CLEAR_FONT_QUEST, 16 * CF_SCALE); end
   if (CanSetFont(MailTextFontNormal)) then MailTextFontNormal:SetTextColor(0.15, 0.09, 0.04); end
   if (CanSetFont(MailTextFontNormal)) then MailTextFontNormal:SetShadowColor(0.54, 0.4, 0.1); end
   if (CanSetFont(MailTextFontNormal)) then MailTextFontNormal:SetShadowOffset(1, -1); end

   if (CanSetFont(InvoiceTextFontNormal)) then InvoiceTextFontNormal:SetFont(CLEAR_FONT_QUEST, 14 * CF_SCALE); end
   if (CanSetFont(InvoiceTextFontNormal)) then InvoiceTextFontNormal:SetTextColor(0.15, 0.09, 0.04); end

   if (CanSetFont(InvoiceTextFontSmall)) then InvoiceTextFontSmall:SetFont(CLEAR_FONT_QUEST, 12 * CF_SCALE); end
   if (CanSetFont(InvoiceTextFontSmall)) then InvoiceTextFontSmall:SetTextColor(0.15, 0.09, 0.04); end


   -- 技能书: 技能副题
   --------------------------------

   if (CanSetFont(SubSpellFont)) then SubSpellFont:SetFont(CLEAR_FONT_QUEST, 14 * CF_SCALE); end


   -- 状态栏: 单位框架的数字和伤害计算器（插件）
   ---------------------------------------------------------

   if (CanSetFont(TextStatusBarText)) then TextStatusBarText:SetFont(CLEAR_FONT_NUMBER, 14 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(TextStatusBarTextSmall)) then TextStatusBarTextSmall:SetFont(CLEAR_FONT, 13); end


   -- 提示面板
   -----------

   if (CanSetFont(GameTooltipText)) then GameTooltipText:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameTooltipTextSmall)) then GameTooltipTextSmall:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
   if (CanSetFont(GameTooltipHeaderText)) then GameTooltipHeaderText:SetFont(CLEAR_FONT, 18 * CF_SCALE); end


   -- 世界地图: 位置名称
   -----------------------------

   if (CanSetFont(WorldMapTextFont)) then WorldMapTextFont:SetFont(CLEAR_FONT_ZONE, 110 * CF_SCALE, "THICKOUTLINE"); end
   if (CanSetFont(WorldMapTextFont)) then WorldMapTextFont:SetShadowColor(0, 0, 0); end
   if (CanSetFont(WorldMapTextFont)) then WorldMapTextFont:SetShadowOffset(1, -1); end
   if (CanSetFont(WorldMapTextFont)) then WorldMapTextFont:SetAlpha(40); end


   -- 区域切换显示: 在屏幕中央通知
   ----------------------------------------

   if (CanSetFont(ZoneTextFont)) then ZoneTextFont:SetFont(CLEAR_FONT_ZONE, 180 * CF_SCALE, "THICKOUTLINE"); end
   if (CanSetFont(ZoneTextFont)) then ZoneTextFont:SetShadowColor(0, 0, 0); end
   if (CanSetFont(ZoneTextFont)) then ZoneTextFont:SetShadowOffset(1, -1); end

   if (CanSetFont(SubZoneTextFont)) then SubZoneTextFont:SetFont(CLEAR_FONT_ZONE, 26 * CF_SCALE, "THICKOUTLINE"); end


   -- 看上去不再被使用
   ---------------------------------------------------

   if (CanSetFont(CombatLogFont)) then CombatLogFont:SetFont(CLEAR_FONT, 32 * CF_SCALE); end
end

-- =============================================================================
--  C. FUNCTION TO RELOAD EVERY TIME AN ADDON LOADS
--  They do like to mess up my addon!
-- =============================================================================

ClearFont:SetScript("OnEvent", function()
   if (event == "ADDON_LOADED") then
      ClearFont:ApplySystemFonts()
   end
end);
ClearFont:RegisterEvent("ADDON_LOADED");

-- =============================================================================
--  D. APPLY ALL THE ABOVE ON FIRST RUN
--  To start the ball rolling
-- =============================================================================

ClearFont:ApplySystemFonts()
