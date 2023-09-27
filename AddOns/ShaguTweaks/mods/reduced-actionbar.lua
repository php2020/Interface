local module = ShaguTweaks:register({
  title = "精简暴雪动作条",
  description = "[reduced-actionbar]\n精简暴雪风格动作条，移除底部默认工具栏（如包裹栏和系统栏）和重排居中堆叠系统动作条、经验条和声望条。",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  categpry = nil,
  enabled = nil,
})

module.enable = function(self)
  -- 隐藏纹理和框架的通用功能 general function to hide textures and frames
  local function hide(frame, texture)
    if not frame then return end

    if texture and texture == 1 and frame.SetTexture then
      frame:SetTexture("")
    elseif texture and texture == 2 and frame.SetNormalTexture then
      frame:SetNormalTexture("")
    else
      frame:ClearAllPoints()
      frame.Show = function() return end
      frame:Hide()
    end
  end

  -- 应隐藏的框架 frames that shall be hidden
  local frames = {
    -- 操作栏分页 actionbar paging
    MainMenuBarPageNumber, ActionBarUpButton, ActionBarDownButton,
    -- xp和信誉条 xp and reputation bar
    MainMenuXPBarTexture2, MainMenuXPBarTexture3,
    ReputationWatchBarTexture2, ReputationWatchBarTexture3,
    -- 操作栏背景 actionbar backgrounds
    MainMenuBarTexture2, MainMenuBarTexture3,
    MainMenuMaxLevelBar2, MainMenuMaxLevelBar3,
    -- 系统按钮面板 micro button panel
    CharacterMicroButton, SpellbookMicroButton, TalentMicroButton,
    QuestLogMicroButton, MainMenuMicroButton, SocialsMicroButton,
    WorldMapMicroButton, MainMenuBarPerformanceBarFrame, HelpMicroButton,
    -- 包裹面板 bag panel
    CharacterBag3Slot, CharacterBag2Slot, CharacterBag1Slot,
    CharacterBag0Slot, MainMenuBarBackpackButton, KeyRingButton,
    -- 变形背景 shapeshift backgrounds
    ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
  }

  -- 应设置为空的纹理 textures that shall be set empty
  local textures = {
    ReputationWatchBarTexture2, ReputationWatchBarTexture3,
    ReputationXPBarTexture2, ReputationXPBarTexture3,
    SlidingActionBarTexture0, SlidingActionBarTexture1,
  }

  -- 应设置为空的按钮纹理 button textures that shall be set empty
  local normtextures = {
    ShapeshiftButton1, ShapeshiftButton2,
    ShapeshiftButton3, ShapeshiftButton4,
    ShapeshiftButton5, ShapeshiftButton6,
  }

  -- 应调整大小为511px的元素 elements that shall be resized to 511px
  local resizes = {
    MainMenuBar, MainMenuExpBar, MainMenuBarMaxLevelBar,
    ReputationWatchBar, ReputationWatchStatusBar,
  }

  -- 隐藏框架 hide frames
  for id, frame in pairs(frames) do hide(frame) end

  -- 清晰的纹理 clear textures
  for id, frame in pairs(textures) do hide(frame, 1) end
  for id, frame in pairs(normtextures) do hide(frame, 2) end

  -- 调整操作栏大小 resize actionbar
  for id, frame in pairs(resizes) do frame:SetWidth(511) end

  -- 经验条 experience bar
  MainMenuXPBarTexture0:SetPoint("LEFT", MainMenuExpBar, "LEFT")
  MainMenuXPBarTexture1:SetPoint("RIGHT", MainMenuExpBar, "RIGHT")

  -- 声望条 reputation bar
  ReputationWatchBar:SetPoint("BOTTOM", MainMenuExpBar, "TOP", 0, 0)
  ReputationWatchBarTexture0:SetPoint("LEFT", ReputationWatchBar, "LEFT")
  ReputationWatchBarTexture1:SetPoint("RIGHT", ReputationWatchBar, "RIGHT")

  -- 移动菜单栏纹理背景 move menubar texture background
  MainMenuMaxLevelBar0:SetPoint("LEFT", MainMenuBarArtFrame, "LEFT")
  MainMenuBarTexture0:SetPoint("LEFT", MainMenuBarArtFrame, "LEFT")
  MainMenuBarTexture1:SetPoint("RIGHT", MainMenuBarArtFrame, "RIGHT")

  -- 移动鹰头狮纹理 move gryphon textures
  MainMenuBarLeftEndCap:SetPoint("RIGHT", MainMenuBarArtFrame, "LEFT", 30, 0)
  MainMenuBarRightEndCap:SetPoint("LEFT", MainMenuBarArtFrame, "RIGHT", -30, 0)

  -- 将多条底部向右移动到多条底部向左的顶部 move MultiBarBottomRight ontop of MultiBarBottomLeft
  MultiBarBottomRight:ClearAllPoints()
  MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 5)

  -- 在原始框架管理运行后重新加载自定义框架位置 reload custom frame positions after original frame manage runs
  local hookUIParent_ManageFramePositions = UIParent_ManageFramePositions
  UIParent_ManageFramePositions = function(a1, a2, a3)
    -- 运行原始函数 run original function
    hookUIParent_ManageFramePositions(a1, a2, a3)

    -- 如果xp或信誉被跟踪，则移动顶部操作栏 move top actionbar if xp or reputation is tracked
    MultiBarBottomLeft:ClearAllPoints()
    if MainMenuExpBar:IsVisible() or ReputationWatchBar:IsVisible() then
      local anchor = GetWatchedFactionInfo() and ReputationWatchBar or MainMenuExpBar
      MultiBarBottomLeft:SetPoint("BOTTOM", anchor, "TOP", 0, 3)
    else
      MultiBarBottomLeft:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, -3)
    end

    -- 将宠物操作栏移动到其他操作栏之上 move pet actionbar above other actionbars
    PetActionBarFrame:ClearAllPoints()
    local anchor = MainMenuBarArtFrame
    anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
    anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
    PetActionBarFrame:SetPoint("BOTTOM", anchor, "TOP", 0, 3)

    -- 形状偏移条形框 ShapeshiftBarFrame
    ShapeshiftBarFrame:ClearAllPoints()
    local offset = 0
    local anchor = ActionButton1
    anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
    anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor

    offset = anchor == ActionButton1 and ( MainMenuExpBar:IsVisible() or ReputationWatchBar:IsVisible() ) and 6 or 0
    offset = anchor == ActionButton1 and offset + 6 or offset
    ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 8, 2 + offset)

    -- 将脚轮移动到其他横杆的顶部 move castbar ontop of other bars
    local anchor = MainMenuBarArtFrame
    anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
    anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
    local pet_offset = PetActionBarFrame:IsVisible() and 40 or 0
    CastingBarFrame:SetPoint("BOTTOM", anchor, "TOP", 0, 10 + pet_offset)
  end
end
