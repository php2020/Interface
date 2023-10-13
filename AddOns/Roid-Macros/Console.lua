--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}
local loc = GetLocale()
--MrBCat 20230808 添加并修复了宠物控制相关
SLASH_PETATTACK1 = "/petattack";
SlashCmdList.PETATTACK = function(msg) Roids.DoPetAttack(msg); end
SLASH_PETPASSIVE1 = "/petpassive"
SlashCmdList.PETPASSIVE = function(msg) Roids.PETPASSIVE(msg); end
SLASH_PETDEFENSIVE1 = "/petdefensive"
SlashCmdList.PETDEFENSIVE = function(msg) Roids.PETDEFENSIVE(msg); end
SLASH_PETFOLLOW1 = "/petfollow"
SlashCmdList.PETFOLLOW = function(msg) Roids.PETFOLLOW(msg); end
SLASH_PETSTAY1 = "/petstay"
SlashCmdList.PETSTAY = function(msg) Roids.PETSTAY(msg); end


SLASH_RELOAD1 = "/rl";

SlashCmdList.RELOAD = function() ReloadUI(); end

SLASH_USE1 = "/use";

SlashCmdList.USE = Roids.DoUse;

SLASH_EQUIP1 = "/equip";

SlashCmdList.EQUIP = Roids.DoUse;

SLASH_EQUIPOH1 = "/equipoff";

SlashCmdList.EQUIPOFF = Roids.DoEquipOffhand;

SLASH_UNSHIFT1 = "/unshift";

SlashCmdList.UNSHIFT = Roids.DoUnshift;

SLASH_STARTATTACK1 = "/startattack";
local attack
if loc == "zhCN" then
    attack = "攻击"
else
    attack = "Attack"
end

SlashCmdList.STARTATTACK = function() 
    if ( not PlayerFrame.inCombat ) 
    then CastSpellByName(attack) 
    end

end

SLASH_STOPATTACK1 = "/stopattack";

SlashCmdList.STOPATTACK = function(msg) if Roids.CurrentSpell.autoAttack then Roids.DoCast(msg .. " Attack"); end end

SLASH_STOPCASTING1 = "/stopcasting";

SlashCmdList.STOPCASTING = SpellStopCasting;

Roids.Hooks.CAST_SlashCmd = SlashCmdList.CAST;
Roids.CAST_SlashCmd = function(msg)
    -- get in there first, i.e do a PreHook
    if Roids.DoCast(msg) then
        return;
    end
    -- if there was nothing for us to handle pass it to the original
    Roids.Hooks.CAST_SlashCmd(msg);
end

SlashCmdList.CAST = Roids.CAST_SlashCmd;

Roids.Hooks.TARGET_SlashCmd = SlashCmdList.TARGET;
Roids.TARGET_SlashCmd = function(msg)
    if Roids.DoTarget(msg) then
        return;
    end
    Roids.Hooks.TARGET_SlashCmd(msg);
end
SlashCmdList.TARGET = Roids.TARGET_SlashCmd;
