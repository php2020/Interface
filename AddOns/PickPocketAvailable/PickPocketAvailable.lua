-- 创建一个框体来显示偷窃技能提示
local frame = CreateFrame("Frame", "PickPocketAvailableFrame", UIParent)
frame:SetWidth(50)
frame:SetHeight(50)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")

-- 设置框体的背景颜色和透明度
frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
frame:SetBackdropColor(0, 0, 0, 0.7)

-- 创建材质来显示偷窃技能的图标
local texture = frame:CreateTexture(nil, "ARTWORK")
texture:SetAllPoints(frame)
texture:SetTexture("Interface/Icons/INV_Misc_Bag_11") -- 这里使用了偷窃技能的图标

-- 创建高亮闪烁效果
local shine = frame:CreateTexture(nil, "OVERLAY")
shine:SetPoint("CENTER", frame, "CENTER", 0, 0)
shine:SetHeight(frame:GetHeight())
shine:SetWidth(frame:GetWidth())
shine:SetTexture("Interface/Cooldown/starburst")
shine:SetBlendMode("ADD")
shine:Hide()

-- 设置拖拽功能
frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

-- 监听目标改变事件
frame:RegisterEvent("PLAYER_TARGET_CHANGED")

-- 创建每帧检查技能是否可用的函数
local function CheckSkillAvailability()
    if UnitExists("target") and UnitIsEnemy("player", "target") then
        local distance = CheckInteractDistance("target", 1) -- 1表示5码最大交互距离
        local isInStealth = UnitBuff("player", "Stealth") or UnitBuff("player", "Vanish") -- 潜行 或者 消失 
        if distance and not isInStealth then
            -- 如果选中敌对目标并且在偷窃范围内，并且玩家不处于隐身状态，显示提示框和高亮闪烁效果
            frame:Show()
            shine:Show()

            -- 添加高亮闪烁动画
            local animGroup = shine:CreateAnimationGroup()
            local fadeIn = animGroup:CreateAnimation("Alpha")
            fadeIn:SetFromAlpha(0)
            fadeIn:SetToAlpha(1)
            fadeIn:SetDuration(0.5)
            fadeIn:SetOrder(1)

            local fadeOut = animGroup:CreateAnimation("Alpha")
            fadeOut:SetFromAlpha(1)
            fadeOut:SetToAlpha(0)
            fadeOut:SetDuration(0.5)
            fadeOut:SetOrder(2)

            animGroup:SetLooping("REPEAT")
            animGroup:Play()
            PlaySound("igMainMenuOpen");
        else
            -- 如果不符合条件，隐藏提示框和高亮闪烁效果
            frame:Hide()
            shine:Hide()
            -- PlaySound("igMainMenuClose");
        end
    end
end

-- 注册每帧检查技能是否可用的函数
frame:SetScript("OnUpdate", CheckSkillAvailability)
