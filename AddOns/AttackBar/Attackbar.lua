local pont = 0.000
local pofft = 0.000
local ont = 0.000
local offt = 0.000
local ons = 0.000
local offs = 0.000
local offh = 0
local onh = 0

local math_mod = math.fmod or math.mod
if not CatAttackBarDB then CatAttackBarDB = {} end
function Abar_loaded()
  SlashCmdList["ATKBAR"] = Abar_chat;
  SLASH_ATKBAR1 = "/abar";
  SLASH_ATKBAR2 = "/atkbar";
  if CatAttackBarDB.range == nil then
    CatAttackBarDB.range = true
  end
  if CatAttackBarDB.h2h == nil then
    CatAttackBarDB.h2h = true
  end
  if CatAttackBarDB.timer == nil then
    CatAttackBarDB.timer = true
  end
  if CatAttackBarDB.mob == nil then
    CatAttackBarDB.mob = true
  end

  Abar_Mhr:SetPoint("LEFT", Abar_Frame, "TOPLEFT", 6, -13)
  Abar_Oh:SetPoint("LEFT", Abar_Frame, "TOPLEFT", 6, -35)
  Abar_MhrText:SetJustifyH("Left")
  Abar_OhText:SetJustifyH("Left")

  
end
function Abar_chat(msg)
  msg = strlower(msg)
  if msg == "fix" then
    Abar_reset()
  elseif msg == "lock" then
    Abar_Frame:Hide()
  elseif msg == "unlock" then
    Abar_Frame:Show()

  
  else
		DEFAULT_CHAT_FRAME:AddMessage('fix: 计时重置')
		DEFAULT_CHAT_FRAME:AddMessage('lock: 锁定');
		DEFAULT_CHAT_FRAME:AddMessage('unlock: 解锁');
   
  end
end

function Abar_selfhit(arg1)

    ons, offs = UnitAttackSpeed("player");
    local hd, ld, ohd, old = UnitDamage("player")
    hd, ld = hd - math_mod(hd, 1), ld - math_mod(ld, 1)
    if old then
      ohd, old = ohd - math_mod(ohd, 1), old - math_mod(old, 1)
    end
    local tons
    if offs then
      ont, offt = GetTime(), GetTime()
      if ((math.abs((ont - pont) - ons) <= math.abs((offt - pofft) - offs)) and not(onh <= offs / ons)) or offh >= ons / offs then
        if pofft == 0 then pofft = offt end
        pont = ont
        tons = ons
        offh = 0
        onh = onh + 1
        ons = ons - math_mod(ons, 0.01)
        
        Abar_Mhrs(tons+0.65, "主手  " ..ons..  "s", 0, 0, 1)

      else
        pofft = offt
        offh = offh + 1
        onh = 0
        ohd, old = ohd - math_mod(ohd, 1), old - math_mod(old, 1)
        offs = offs - math_mod(offs, 0.01)
        Abar_Ohs(offs+0.65, "副手 "..offs.."s" , 0, 0, 1)

      end
    else
      ont = GetTime()
      tons = ons
      ons = ons - math_mod(ons, 0.01)
      Abar_Mhrs(tons+0.65, "主手 "..ons.."s", 0, 0, 1)

    end
    

  
end
function Abar_reset()
  pont = 0.000
  pofft = 0.000
  ont = 0.000
  offt = 0.000
end
function Abar_event(event)
  if (event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_COMBAT_SELF_HITS") and CatAttackBarDB.h2h == true then Abar_selfhit(arg1) end
  if event == "PLAYER_LEAVE_COMBAT" then Abar_reset() end
  if event == "VARIABLES_LOADED" then Abar_loaded() end
  if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then Abar_spellhit(arg1) end
  if event == "VARIABLES_LOADED" then Abar_loaded() end
  if event == "UNIT_SPELLCAST_SENT" then abar_spelldir(arg2) end
end
--以下代码段来自凡人插件的攻击计时插件20230912，MrBCat修复
local combatSpells = {
	["英勇打击"] = 1,
	["顺劈斩"] = 1,
	["猛击"] = 1,
	["猛禽一击"] = 1,
	["槌击"] = 1,
  ["Maul"] = 1,--槌击
  ['Heroic Strike'] = 1,--英勇打击
  ['Cleave'] = 1,--顺劈斩
  ['Slam']=1,--猛击
  ['Raptor Strike'] = 1 , --猛禽一击
}

local combatStrings = {
	SPELLLOGSELFOTHER,			-- 你的%s击中%s造成%d点伤害。
	SPELLLOGCRITSELFOTHER,		-- 你的%s对%s造成%d的致命一击伤害。
	SPELLDODGEDSELFOTHER,		-- 你的%s被%s躲闪过去了。
	SPELLPARRIEDSELFOTHER,		-- 你的%s被%s招架了。
	SPELLMISSSELFOTHER,			-- 你的%s没有击中%s。
	SPELLBLOCKEDSELFOTHER,		-- 你的%s被%s格挡了。
	SPELLDEFLECTEDSELFOTHER,	-- 你的%s被%s偏斜了。
	SPELLEVADEDSELFOTHER,		-- 你的%s被%s闪避过去了。
	SPELLIMMUNESELFOTHER,		-- 你的%s施放失败。%s对此免疫。
	SPELLLOGABSORBSELFOTHER,	-- 你的%s被%s吸收了。
	SPELLREFLECTSELFOTHER,		-- 你的%s被%s反弹回来。
	SPELLRESISTSELFOTHER,		-- 你的%s被%s抵抗了。
	SPELLLOGCRITSELFSELF,		-- 你的%s致命一击对你造成%d点伤害。
	IMMUNESPELLSELFOTHER,		-- %s对你的%s免疫。
}
for index in combatStrings do
	for _, pattern in {"%%s", "%%d"} do
		combatStrings[index] = gsub(combatStrings[index], pattern, "(.*)")
	end
end

function Abar_spellhit(arg1)
	for _, str in combatStrings do
		local _, _, spell = strfind(arg1, str)
		local rs = UnitRangedDamage("player")
		if spell == "自动射击"  or spell == "Auto Shot" and CatAttackBarDB.range == true then
			trs = rs
			rs = rs - math.mod(rs, 0.01)
			Abar_Mhrs(trs-0.65 , "自动射击 "..(rs-0.65) .."s", 0, 1, 0)
		elseif spell and combatSpells[spell] and CatAttackBarDB.h2h==true then
			Abar_selfhit()
		end
	end
end
function abar_spelldir(spellname)
  if CatAttackBarDB.range then
    local a, b, sparse = string.find(spellname, "(.+)%(")
    if sparse then spellname = sparse end
    local rs, rhd, rld = UnitRangedDamage("player");
    rhd, rld = rhd - math_mod(rhd, 1), rld - math_mod(rld, 1)
    local trs
    if spellname == "Throw" or spellname == "投掷" then
      trs = rs
      rs = rs - math_mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "投掷" ..(rs) .. "s" , 1, .5, 0)
    elseif spellname == "Shoot" or spellname == "射击" then
      rs = UnitRangedDamage("player")
      trs = rs
      rs = rs - math_mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "射击" ..(rs) .. "s]", .5, 0, 1)
    elseif spellname == "Shoot Bow" or spellname == "弓射击"then
      trs = rs
      rs = rs - math_mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "弓" ..(rs) .. "s", 1, .5, 0)
    elseif spellname == "Shoot Gun" or spellname == "枪射击" then
      trs = rs
      rs = rs - math_mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "枪" ..(rs) .. "s", 1, .5, 0)
    elseif spellname == "Shoot Crossbow" or spellname == "弩射击"then
      trs = rs
      rs = rs - math_mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "弩" ..(rs) .. "s" , 1, .5, 0)

    end
  end
end
--以上代码段来自凡人插件20230912
function Abar_Update()
  local ttime = GetTime()
  local left = 0.00
  local tSpark = getglobal(this:GetName() .. "Spark")
  local tText = getglobal(this:GetName() .. "Tmr")
  if CatAttackBarDB.timer == true then
    left =(this.et - GetTime()) -(math_mod((this.et - GetTime()), .01))
    -- tText:SetText(this.txt.. "{"..left.."}")
    tText:SetText(left)
    tText:Show()
  else
    tText:Hide()
  end
  this:SetValue(ttime)
  tSpark:SetPoint("CENTER", this, "LEFT",(ttime - this.st) /(this.et - this.st) * 195, 2);
  if ttime >= this.et then
    this:Hide()
    tSpark:SetPoint("CENTER", this, "LEFT", 195, 2);
  end
end
function Abar_Mhrs(bartime, text, r, g, b)
  Abar_Mhr:Hide()
  Abar_Mhr.txt = text
  Abar_Mhr.st = GetTime()
  Abar_Mhr.et = GetTime() + bartime
  Abar_Mhr:SetStatusBarColor(r, g, b)
  Abar_MhrText:SetText(text)
  Abar_Mhr:SetMinMaxValues(Abar_Mhr.st, Abar_Mhr.et)
  Abar_Mhr:SetValue(Abar_Mhr.st)
  Abar_Mhr:Show()
end

function Abar_Ohs(bartime, text, r, g, b)
  Abar_Oh:Hide()
  Abar_Oh.txt = text
  Abar_Oh.st = GetTime()
  Abar_Oh.et = GetTime() + bartime
  Abar_Oh:SetStatusBarColor(r, g, b)
  Abar_OhText:SetText(text)
  Abar_Oh:SetMinMaxValues(Abar_Oh.st, Abar_Oh.et)
  Abar_Oh:SetValue(Abar_Oh.st)
  Abar_Oh:Show()
end
function Abar_Boo(inpt)
  if inpt == true then return " ON" else return " OFF" end
end
