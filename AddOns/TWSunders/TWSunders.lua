local TWSunders = CreateFrame("Frame")
local TWSunderChecker = CreateFrame("Frame")
TWSunderChecker:Hide()

TWSunderChecker.timerStart = 0
TWSunders:RegisterEvent("PLAYER_TARGET_CHANGED") -- 目标改变
TWSunders:RegisterEvent("PLAYER_REGEN_DISABLED") -- 进入战斗
TWSunders:RegisterEvent("PLAYER_REGEN_ENABLED") -- 结束战斗

local sDev = false

TWSunders:SetScript("OnEvent", function()
    if event and (GetNumRaidMembers() > 0 or sDev) then
        -- 进入战斗 开启
        if event == "PLAYER_REGEN_DISABLED" then
            -- 目标存在 且 是世界boss 且 是仇恨 或者 可战斗
            if UnitExists('target') and UnitClassification('target') == 'worldboss' and (UnitIsEnemy('player', 'target') or sDev) then
                TWSunderChecker:Hide()
                -- 检查五破
                if not TWSunders:checkFive() then
                    TWSunderChecker:Show()
                end
            end
        end
        -- 结束战斗 不提示
        if event == "PLAYER_REGEN_ENABLED" then
            TWSunderChecker:Hide()
        end
        -- 目标改变 且 目标存在
        if event == 'PLAYER_TARGET_CHANGED' and UnitExists('target') then
            -- 是敌对 且 是世界boss 且 玩家和目标 都处于战斗状态
            if (UnitIsEnemy('player', 'target')  and UnitClassification('target') == 'worldboss' or sDev) and UnitAffectingCombat('player') and UnitAffectingCombat('target') then
                TWSunderChecker:Hide()
                if not TWSunders:checkFive() then
                    TWSunderChecker:Show()
                end
            end
        end
    end
end)

-- OnShow 触发
TWSunderChecker:SetScript("OnShow", function()
    this.startTime = GetTime()
    TWSunderChecker.timerStart = GetTime()
end)
-- OnUpdate 触发
TWSunderChecker:SetScript("OnUpdate", function()
    local plus = 0.1 --seconds
    local gt = GetTime() * 1000
    local st = (this.startTime + plus) * 1000
    if gt >= st then
        TWSunders:check_sunder()
        this.startTime = GetTime()
    end
end)
-- 将num四舍五入到指定的小数位数，然后将结果返回
function TWSunders:sunderRound(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
-- 检测破甲buff 层数
function TWSunders:checkFive()
    for i = 1, 16 do
        local debuff, count = UnitDebuff("target", i)
        if debuff and debuff == "Interface\\Icons\\Ability_Warrior_Sunder" then
            SendChatMessage("[" .. UnitName('target') .. "] 破甲：" .. count .. " 层", "SAY")
            if count and count == 5 then
                return true
            end
        end
    end
    return false
end
-- 检查五破花费的秒数 发送到聊天窗
function TWSunders:check_sunder()
    if UnitExists('target') and (UnitIsEnemy('player', 'target') or sDev) then
        local sunderTime = self:sunderRound(GetTime() - TWSunderChecker.timerStart, 1)
        if self:checkFive() and sunderTime > 1.6 then
            SendChatMessage("[" .. UnitName('target') .. "] " .. sunderTime .. "秒 达到 5 层破甲！！！", "SAY")
            TWSunderChecker:Hide()
            return
        end
    end
end
