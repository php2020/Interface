--------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------
Talents = {}
Spell_Info = {}
SPELLTIMER_BARNUMBER_MAX = 8  
ST_Default_Config = { 
    ["Enabled"] = nil, 
    ["EnabledTest"] = 1,
    ["ShowProgressBar"] = 1, 
    ["ShowName"] = 1, 
    ["WarningTime"] = 5, 
    --["HideAllWhenLeaveCombat"] = nil, 
    ["ShowTargetName"] = nil, 
    ["TooltipInfo"] = nil, 
    ["EnableEnemy"] = nil, 
    ["Settings"] = 20,
}
local sharak = nil 
local CastingSpell = nil 
local CastingPet = nil
local judgment_time = nil
local judgment_name = nil
local org_stconfig = nil
local org_enconfig = nil
UIPanelWindows["SpellTimer_Option"] = {area = "left", pushable = 1} 
---------------------------------------------------------------------------------------------
--������D�Ĳ�ͬ���������Ӧ����ʾʱ������PointtoTime��
-----------------------------------------------------------------------------------------------
function GetTimeFrompoints(str, func)
     local PointtoTime = {}
     local i, j, combatpoint, duration 
     i, j, combatpoint, duration = string.find(str, func) 
     while (i and j) do 
          PointtoTime[tonumber(combatpoint)] = tonumber(duration) 
	  i, j, combatpoint, duration = string.find(str, func, j) 
     end 
     return PointtoTime 
end 
-----------------------------------------------------------------------------------------------
--��������[1]�Ǽ��ܳ���ʱ��[2]���������ʱ��
--MF�ĸ�ʽ�����ǵĲ�ͬ,����Ҫ�޸���<��Ӣ����վ��ƭ��,��ʽ��һ����!>
-----------------------------------------------------------------------------------------------
function GetTrapTime(str, func)
     local PointtoTime = {}
     local i, j
     i, j, PointtoTime[1] = string.find(str, func[1])
     if (i and j) then
         i, j, PointtoTime[2] = string.find(str, func[2])
         if (i and j) then	     
	     	   PointtoTime[2] = tostring(tonumber(PointtoTime[2])*60)	            
             return PointtoTime 
         end 
     end 
end 
-----------------------------------------------------------------------------------------------
--�����õ�����ĳ���ʱ��<ע�������PointtoTime��ʽ>
------------------------------------------------------------------------------------------------
function SpellTimerReturnTwo() 
     return 2 
end 
------------------------------------------------------------------------------------------------
--������Ϸ
-------------------------------------------------------------------------------------------------
function SpellTimerFrame_OnLoad() 
     this:RegisterEvent("VARIABLES_LOADED")
end 

function ST_Show_Options()
     PlaySound("igMainMenuOption")
     ToggleFrame(SpellTimer_Option)
     org_stconfig = {} 
     org_stconfig = ST_Clone(SpellTimer_Config)
     if (IsAddOnLoaded("SpellTimer_Enemy")) then
         org_enconfig = {}
         org_enconfig = ST_Clone(EnemyConfig)
     end  
end
-----------------------------------------------------------------------------------------------
--Hook/Unhook
------------------------------------------------------------------------------------------------
function SpellTimer_Toggle(num)
     if (num and not sharak) then
         SpellTimerMainFrame:Show() 
	 sharak = 1 
	 SpellTimer_Config.EnabledTest = 1 
	 SpellTimerMainFrame:RegisterEvent("SPELLCAST_STOP") 
	 SpellTimerMainFrame:RegisterEvent("SPELLCAST_START") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_MISS") 
	 SpellTimerMainFrame:RegisterEvent("SPELLCAST_INTERRUPTED") 
	 SpellTimerMainFrame:RegisterEvent("SPELLCAST_FAILED") 
	 SpellTimerMainFrame:RegisterEvent("PLAYER_REGEN_ENABLED") 
	 SpellTimerMainFrame:RegisterEvent("SPELL_BREAK_AURA") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_FAILED_LOCALPLAYER") 
	 SpellTimerMainFrame:RegisterEvent("SPELL_CAST_TIME_INSTANT")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" )
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" )
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
	 org_CastSpell = CastSpell 
	 CastSpell = New_CastSpell 
	 org_SpellTargetUnit = SpellTargetUnit 
	 SpellTargetUnit = New_SpellTargetUnit 
	 org_TargetUnit = TargetUnit 
	 TargetUnit = New_TargetUnit 
	 org_StopTargetting = StopTargetting 
	 old_StopTargetting = StopTargetting 
	 org_CastSpellByName = CastSpellByName 
	 CastSpellByName = New_CastSpellByName 
	 org_UseAction = UseAction 
	 UseAction = New_UseAction 
	 org_UseContainerItem = UseContainerItem 
	 UseContainerItem = New_UseContainerItem 
	 org_UseInventoryItem = UseInventoryItem 
	 UseInventoryItem = New_UseInventoryItem 
	 org_CastPetAction = CastPetAction
	 CastPetAction = New_CastPetAction
    elseif (not num and sharak) then
         for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do 
	     getglobal("SpellTimerFrame"..i):Hide() 
         end 
	 SpellTimerMainFrame:Hide() 
	 sharak = nil 
	 SpellTimer_Config.EnabledTest = nil 
	 SpellTimerMainFrame:UnregisterEvent("SPELLCAST_STOP") 
	 SpellTimerMainFrame:UnregisterEvent("SPELLCAST_START") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_BREAK_AURA") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_SELF_MISS") 
	 SpellTimerMainFrame:UnregisterEvent("SPELLCAST_INTERRUPTED") 
	 SpellTimerMainFrame:UnregisterEvent("SPELLCAST_FAILED") 
	 SpellTimerMainFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	 SpellTimerMainFrame:UnregisterEvent("SPELL_BREAK_AURA") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_FAILED_LOCALPLAYER")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" )
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" )
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
	 CastSpell = org_CastSpell 
	 org_CastSpell = nil 
	 SpellTargetUnit = org_SpellTargetUnit 
	 org_SpellTargetUnit = nil 
	 TargetUnit = org_TargetUnit 
	 org_TargetUnit = nil 
	 old_StopTargetting = org_StopTargetting 
	 org_StopTargetting = nil 
	 CastSpellByName = org_CastSpellByName 
	 org_CastSpellByName = nil 
	 UseAction = org_UseAction 
	 org_UseAction = nil 
	 UseContainerItem = org_UseContainerItem 
	 org_UseContainerItem = nil 
	 UseInventoryItem = org_UseInventoryItem 
	 org_UseInventoryItem = nil 
	 CastPetAction = org_CastPetAction
         org_CastPetAction = nil
    end 
end 
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
--[[
function De_bug(msg) 
    ChatFrame1:AddMessage (msg,1,1,1,1)
end
--]]
-----------------------------------------------------------------------------------------
--�������෨�������������.
-----------------------------------------------------------------------------------------
function SpellTimer_Chat_Start()
    if (CastingSpell and CastingSpell.spellname == arg1) then
        if (Andy_Xiao) then
            if (not SpellTimer011) then
                SpellTimer011 = CastingSpell 
            end 
	    BigFoot_DelayCall(SpellTimer_Chat_Start, 0.2) 
	else
            if (SpellTimer011) then
                 Duration_Spell = SpellTimer011 
		 SpellTimer011 = nil 
            else 
	         Duration_Spell = CastingSpell 
		 CastingSpell = nil 
            end 
        end 
    else 
        CastingSpell = nil 
    end 
end 
------------------------------------------------------------------------------------------
--��Ҫ����
--���ּ�ʱЧ���Ĵ�������������
------------------------------------------------------------------------------------------
function SpellTimerFrame_OnEvent()
	if (event == "VARIABLES_LOADED") then
		PlayerClass = UnitClass("player")
		local i, j, spell, name
		if (not SpellTimer_Config) then
			SpellTimer_Config = {}
			SpellTimer_Config = ST_Clone(ST_Default_Config)
		end
		if (SpellTimer_Config.EnabledTest) then
			SpellTimer_Toggle(1) 
			SpellTimer_GetTalents()
		end 
		if (SpellTimer_Config and SpellTimer_Config["EnableEnemy"] and IsAddOnLoadOnDemand("SpellTimer_Enemy")) then
			EnableAddOn("SpellTimer_Enemy") 
			LoadAddOn("SpellTimer_Enemy")	
			SpellTimer_EnemyBar_Toggle(1)
	      --SpellTimer_EnemyMain:RegisterEvent("VARIABLES_LOADED")
		end
		--ST_MinimapButton_UpdatePosition()    
	elseif (event == "SPELL_CAST_TIME_INSTANT") then 
	elseif (event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") then 
		i, j, name, spell = string.find(arg1, SPELLTIMER_SPELL_AFFLICTED_1)
	 --��������Ч����������ʾЧ����ʱ--�������˸�����<�޷���֤�����Լ�������>
		if (PlayerClass == BF_CLASS_HUNTER and spell and ST_TRAP_EFFECT[spell]) then               
			local orgspell = ST_TRAP_EFFECT[spell]	      
			local _, _, context = SpellTimer_Filter(nil, nil, orgspell)		   
				if (_) then		   
					TrapOnSameTarget(name, orgspell, spell, context[1]) 
				return end          	      
		end
	 --�����ʱ
		if ((PlayerClass == BF_CLASS_HUNTER or PlayerClass == BF_CLASS_WARLOCK) and spell and SpellTimer_Spells[PlayerClass][spell] and name == UnitName("pettarget") and CastingPet and CastingPet.spellname == spell) then
			local level = UnitLevel("pettarget")	      
			SpellTimer_AddSpell(name, level, spell, CastingPet.hodetime, CastingPet.value, CastingPet.texture, CastingPet.SpellID, CastingPet.type, CastingPet.Special) 
			CastingPet = nil
        return end
	
		if (PlayerClass == BF_CLASS_PALADIN and spell and ((CastingSpell and CastingSpell.Special and CastingSpell.Special[spell]) or (Sharak_Spell and Sharak_Spell.Special and Sharak_Spell.Special[spell]))) then	
			judgment_time = tostring(SpellTimer_Spells[BF_CLASS_PALADIN][spell][3])
			judgment_name = spell
			if (Talents[SPELL_TIMER_LASTIONG_JUDGMENT] and Talents[SPELL_TIMER_LASTIONG_JUDGMENT][1]) then
				if (spell == SPELL_TIMER_LIGHT_JUDGMENT or spell == SPELL_TIMER_WISDOM_JUDGMENT) then
					judgment_time = tostring(judgment_time + Talents[SPELL_TIMER_LASTIONG_JUDGMENT][1])	               
				end	      	
			end 
		local jtexture , seal, level
		level = UnitLevel("target")
	    seal = SpellTimer_Spells[PlayerClass][spell][1]
	    jtexture = BifFootSpell_GetSpellTextureFromName(seal)	     
	    SpellTimer_ShowTalent(name, level, spell, judgment_time, jtexture)	   
	    CastingSpell = nil
	    Sharak_Spell  = nil
	    return end	
		if (PlayerClass == BF_CLASS_DRUID and spell) then
			SpellTimer_ShowNature(name,spell)	     
		end        
		if (spell and Talents[spell]) and SpellTimer_Has_Spell(spell) then
			if (SpellStopTime and (GetTime() - SpellStopTime) < 2) then
				if (spell ~= SPELLTIMER_ENTRAPMENT) then
					SpellTimer_ShowTalent (name, UnitLevel("target"), spell, Talents[spell][1], Talents[spell][2])
				else
					SpellTimer_ShowTalent (name, nil, spell, Talents[spell][1], Talents[spell][2])
				end
	      	   
			else
				if (spell == SPELLTIMER_ENTRAPMENT) then
					TrapOnSameTarget(name, spell, spell, Talents[spell][1])
				end
			end	
		return end 
	elseif (event == "CHAT_MSG_COMBAT_SELF_HITS") then           
		local level = UnitLevel("target")
		local name, damage
			if (PlayerClass == BF_CLASS_PALADIN and judgment_name and judgment_time) then
				for name, damage in string.gfind(arg1, SPELLTIMER_SPELL_HIT) do 
					SpellTimer_Show_Judgment_Again(name,level,judgment_name,judgment_time)
				end
				for name, damage in string.gfind(arg1, SPELLTIMER_SPELL_Crit) do 
					SpellTimer_Show_Judgment_Again(name,level,judgment_name,judgment_time)
				end	      
			end
    elseif (event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS") then
	    local _, _, damage = string.find (arg1, "([%d%.]+)")
	    if (PlayerClass == BF_CLASS_SHAMAN and damage) then
			for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
				local SpellTimerFrame = getglobal("SpellTimerFrame"..i)		    
				if (SpellTimerFrame and SpellTimerFrame:IsVisible()) then
					local _, _ = string.find (arg1, SpellTimerFrame.spell)
					if (_ and SpellTimerFrame.hp) then
						SpellTimerFrame.hp = SpellTimerFrame.hp - tonumber(damage)
							if (SpellTimerFrame.hp <= 0) then
								SpellTimer_FadeOut(SpellTimerFrame)
							end
					return end
				end
			end
	    end	    
    --elseif (event == "CHAT_MSG_SPELL_AURA_GONE_OTHER") then
    elseif (event == "CHAT_MSG_SPELL_BREAK_AURA") then         
		local i, j, name, spell = string.find(arg1, SPELLTIMER_SPELL_DISPEL_BUFF)
		if (i and j) then
			FadeOut_ByNLS(name, nil, spell) 
        end 
	elseif (event == "CHAT_MSG_COMBAT_FRIENDLY_DEATH") then        
        local i, j, spell = string.find(arg1, SPELLTIMER_TOTEM_RUINED)
        if (i and j) then
            FadeOut_ByNLS(spell, nil, spell) 
        end 
    elseif (event == "SPELLCAST_INTERRUPTED" or event == "SPELLCAST_FAILED") then        
        CastingSpell = nil 
		DisableShow = nil 
    elseif (event == "SPELLCAST_START") then
        SpellTimer_Chat_Start(0) 
    elseif (event == "SPELLCAST_STOP") then
        SpellStopTime = GetTime()
        if (Duration_Spell and not Andy_Xiao) then 
			BigFoot_DelayCall(SpellTimer_Show, 0.6, 1, 1) 
			Andy_Xiao = 1 
        elseif (CastingSpell and CastingSpell.instant) then 
			Sharak_Spell = nil
			SpellTimer_Show()	     	     
        end 	
		DisableShow = nil	 		
    elseif (event == "PLAYER_REGEN_ENABLED") then
        FadeOutAll() 
		DisableShow = nil 
		judgment_name = nil
        judgment_time = nil
    elseif (event == "CHAT_MSG_COMBAT_HOSTILE_DEATH") then
        local i, j, name = string.find(arg1, SPELLTIMER_HOSTILE_DEATH)
        if (i and j) then
            FadeOut_ByNLS(name,nil,nil)
        end	
    elseif (event == "CHAT_MSG_SPELL_FAILED_LOCALPLAYER") then
        local i, j, spell = string.find(arg1, SPELLTIMER_SPELL_SELF_FAIL)
        if (Duration_Spell and Duration_Spell.spellname == spell) then
            Duration_Spell = nil 
        end 
    elseif (event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF") then
        local Displayed_Spell
        local Has_duration
        if (Duration_Spell) then
			Displayed_Spell = Duration_Spell 	         
			Has_duration = 1 
        elseif (CastingSpell) then
            Displayed_Spell = CastingSpell 
        elseif (Sharak_Spell) then
            Displayed_Spell = Sharak_Spell 
			Sharak_Spell = nil 
		else 
			Displayed_Spell = nil 
        end
        if (Displayed_Spell) then
		
            local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_SELF_RESIST)        --�ֿ�
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then 
				HideLastTimer(spell)		--������һ����ʱ��<��Ϊʩ�������Ϳ�ʼ��ʱ>
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
				
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_EVADE)                  --����
			if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then 
				HideLastTimer(spell)		--������һ����ʱ��
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
				
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_DODGE)                      --����
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then  
				HideLastTimer(spell)		--������һ����ʱ��
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
				
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_PARRY)                      --�м�
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then   
				HideLastTimer(spell)		--������һ����ʱ��
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
			
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_BLOCK)                      --��
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then
				HideLastTimer(spell)		--������һ����ʱ��
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
			
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_ABSORB)                     --����
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then
				HideLastTimer(spell)		--������һ����ʱ��
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
			
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_IMMUNE)                     --����
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then
				HideLastTimer(spell)		--������һ����ʱ��
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
			return end
			
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_MISS)                       --δ����
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then
				HideLastTimer(spell)--������һ����ʱ��
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
			
         end 
     end 
end

-------------------------------------------------------------------------------------------------------
--������һ����ʱ��
-------------------------------------------------------------------------------------------------------

function HideLastTimer(spell)
     if (SpellTimer_LastTimer and (not spell or SpellTimer_LastTimer.spell == spell)) then
         SpellTimer_LastTimer:Hide() 
     end 
end 

-------------------------------------------------------------------------------------------------------------
--DG_Spell
-------------------------------------------------------------------------------------------------------------
--function DG_Spell_Key()
--    DG_Spell = nil
--end

function SpellTimer_Show(value, Displayed_Spell)
     if (Displayed_Spell) then
         Andy_Xiao = nil 
     end
     if (Displayed_Spell and Duration_Spell) then
         Displayed_Spell = Duration_Spell
	 Duration_Spell = nil 
    elseif (not Displayed_Spell) then
         Displayed_Spell = CastingSpell 
	 Sharak_Spell = CastingSpell 
	 CastingSpell = nil 
    else 
         return 
    end
    if (Displayed_Spell) then
         if (type(Displayed_Spell.hodetime) == "string") then
             if (value) then
                 SpellTimer_AddSpell(Displayed_Spell.name, Displayed_Spell.level, Displayed_Spell.spellname, Displayed_Spell.hodetime - value, Displayed_Spell.value, Displayed_Spell.texture, Displayed_Spell.SpellID, Displayed_Spell.type, Displayed_Spell.Special, nil, Displayed_Spell.spellrank) 
             else 
	         SpellTimer_AddSpell(Displayed_Spell.name, Displayed_Spell.level, Displayed_Spell.spellname, Displayed_Spell.hodetime, Displayed_Spell.value, Displayed_Spell.texture, Displayed_Spell.SpellID, Displayed_Spell.type, Displayed_Spell.Special, nil, Displayed_Spell.spellrank) 
             end 
         elseif (type(Displayed_Spell.hodetime) == "table") then
             local PointtoTime = Displayed_Spell.hodetime["detect"]()
             local duration
             if (PointtoTime) then
                 duration = Displayed_Spell.hodetime[PointtoTime] 
             end
             if (duration) then
                 if (value) then
                     SpellTimer_AddSpell(Displayed_Spell.name, Displayed_Spell.level, Displayed_Spell.spellname, duration - value, Displayed_Spell.value, Displayed_Spell.texture, Displayed_Spell.SpellID, Displayed_Spell.type, Displayed_Spell.Special, Displayed_Spell.hodetime, Displayed_Spell.spellrank) 
		 else 
		     SpellTimer_AddSpell(Displayed_Spell.name, Displayed_Spell.level, Displayed_Spell.spellname, duration, Displayed_Spell.value, Displayed_Spell.texture, Displayed_Spell.SpellID, Displayed_Spell.type, Displayed_Spell.Special, Displayed_Spell.hodetime, Displayed_Spell.spellrank) 
                 end 
             end 
         end 
    end 
end 
---------------------------------------------------------------------------------------------------------------------
--��ʾ�츳���ӣ�������������ʿ������
---------------------------------------------------------------------------------------------------------------------
function SpellTimer_Show_Judgment_Again(name,level,spell,duration)
     for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
	 local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
	 if (SpellTimerFrame and SpellTimerFrame:IsVisible() and          --frame����ʾ��
	(SpellTimerFrame.name == name and SpellTimerFrame.level == level) --ͬһ����
	and SpellTimerFrame.spell == spell) then		          --ͬһ������	
	     SpellTimerFrame.SpellID = nil
	     SpellTimerFrame.talent = 1 
	     Show_SpellTimer_Frame(SpellTimerFrame, spell, duration)
	     return
	end
     end	
end

function SpellTimer_ShowTalent(name, level, talent, duration, texture)   	
	for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
		local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
		if (SpellTimerFrame and SpellTimerFrame:IsVisible() and 
		((Special and Special["unique"]) or (not SpellTimerFrame.name or (SpellTimerFrame.name == name and SpellTimerFrame.level == level))) 
		and SpellTimerFrame.spell == talent) then			
			SpellTimerFrame.SpellID = nil
			SpellTimerFrame.talent = 1  -->������Ͳ������Ҽ��ͷŸ÷�����
			Show_SpellTimer_Frame(SpellTimerFrame, talent, duration)
			return
		end
	end	
	for j = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
		local SpellTimerFrame = getglobal("SpellTimerFrame"..j)
		if (SpellTimerFrame and not SpellTimerFrame:IsVisible()) then
			SpellTimerFrame.spell = talent
			SpellTimerFrame.name = name
			SpellTimerFrame.level = level							
			SpellTimerFrame.talent = 1			
			local textureOb = getglobal("SpellTimerFrame"..j.."IconTexture")
			textureOb:SetTexture(texture)
			Show_SpellTimer_Frame(SpellTimerFrame, talent, duration)
			return
		end
	end
end
----------------------------------------------------------------------------------------------------------------
--��³������Ȼ֮�ռ��ӣ����ҿ϶���ʹ��
----------------------------------------------------------------------------------------------------------------
function SpellTimer_ShowNature(mob,spell)
	for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
	      local frame = getglobal("SpellTimerFrame"..i)
	      if (frame and frame:IsVisible() and frame.spell == SPELL_TIMER_NATURE and SpellTimer_Spells[BF_CLASS_DRUID][SPELL_TIMER_NATURE][5][spell]) then
		   local spellrank = frame.rank
		   spellrank = tonumber(spellrank)
	           if (not Spell_Info[spell] or not Spell_Info[spell][Spellrank]) then                       
			SpellTimer_GetSpellInfoFromName(spell, spellrank)
                   end                 
	           local duration = Spell_Info[spell][spellrank][1]
	           local texture = Spell_Info[spell][spellrank][2]
	           local value = SpellTimer_Has_Delay(spell) 
	           local SpellID = Spell_Info[spell][spellrank][3] 
	           local BookType = Spell_Info[spell][spellrank][4] 
	           local instant = Spell_Info[spell][spellrank][5] 
		   SpellTimer_FadeOut(frame)
	           SpellTimer_AddSpell(nil, nil, spell, duration, value, texture, SpellID, BookType, nil, nil)                                    
	           return			
	      end
	end	
end
-----------------------------------------------------------------------------------------------------
--���Ҽ����Ч��
-----------------------------------------------------------------------------------------------------
function SpellTimerFrame_OnClick(arg1)
    if (this:GetParent().name) then
        if (arg1 == "RightButton" and not this:GetParent().talent ) then
            if (this:GetParent().SpellID and type(this:GetParent().SpellID) ~= table and this:GetParent().type) then
                CastSpell(this:GetParent().SpellID, this:GetParent().type) 
	    else
	        if (this:GetParent().SpellID and type(this:GetParent().SpellID) == table and not this:GetParent().type) then
	        	UseContainerItem(this:GetParent().SpellID[1],this:GetParent().SpellID[2])
	        end
            end 
	else 
	    if (this:GetParent().name) then
                TargetByName(this:GetParent().name) 
            end 
        end 
    end 
end 

---------------------------------------------------------------------------------
--������Ƶ���ʱ����ʱ��ʾ�����ݣ�������Ŀ������ֵȼ���ʾ��
---------------------------------------------------------------------------------
function SpellTimerFrame_OnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")
	GameTooltip:ClearLines()	
	if (this:GetParent().name) then
	     if (this:GetParent().level) then
		   GameTooltip:AddLine (SPELLTIMER_NAME..this:GetParent().name..SPELLTIMER_LEVEL..this:GetParent().level, 1, 1, 0)
	     else
		   GameTooltip:AddLine (SPELLTIMER_NAME..this:GetParent().name, 1, 1, 0)
	     end
	end
	if (not SpellTimer_Config.TooltipInfo) then
	     GameTooltip:AddLine (SPELL_TIMER_TOOLTIP)	
	end	
	GameTooltip:Show()
end
-------------------------------------------------------------------------------------
--ˢ�¼�ʱ���棬ֻ�����ڼ�ʱ�İ��棬ÿ0.02�����һ�Ρ�
-------------------------------------------------------------------------------------
function SpellTimerFrame_OnUpdate(elapsed)
    if (this.casting) then
        if (not this.CheckTime) then
            this.CheckTime = 0 
        end
        if (this.CheckTime > 0.02) then
            this.CheckTime = 0 
	else 
	    this.CheckTime = this.CheckTime + elapsed 
            return 
        end
        local Text = getglobal(this:GetName().."Text")
        local status = GetTime()
        if ( status > this.max ) then
            status = this.max 
        end
        local spelltime = this.max - status
        if (SpellTimer_Config.ShowProgressBar) then
            local SpellTimerBar = getglobal(this:GetName().."Bar")
            local SpellTimerSpark = getglobal(SpellTimerBar:GetName().."Spark")
            local SpellTimerFlash = getglobal(SpellTimerBar:GetName().."Flash")
	    SpellTimerBar:SetValue(status) 
	    SpellTimerFlash:Hide()
            local SparkPostion 
	    SparkPostion = ((status - this.Curenttime) / (this.max - this.Curenttime)) * 128
            if ( SparkPostion < 0 ) then
                SparkPostion = 0 
            end 
	    SpellTimerSpark:SetPoint("CENTER", SpellTimerBar, "LEFT", SparkPostion, 0) 
        end
        if (SpellTimer_Config.ShowName) then
            ShowSpellFrameTime(Text, SpellTimer_Format(spelltime).." - "..this.spell, spelltime) 
	elseif (SpellTimer_Config.ShowTargetName and this.name) then
	    ShowSpellFrameTime(Text, SpellTimer_Format(spelltime).." - "..this.name, spelltime) 
	else 
	    ShowSpellFrameTime(Text, SpellTimer_Format(spelltime), spelltime) 
        end
        if (status == this.max) then
            SpellTimer_FadeOut(this) 
        end 
    elseif (GetTime() < this.Zero) then 
        return 
    elseif (this.SpellTimerFlash) then
        if (SpellTimer_Config.ShowProgressBar) then
            local SpellTimerBar = getglobal(this:GetName().."Bar")
            local SpellTimerFlash = getglobal(SpellTimerBar:GetName().."Flash")
            local alpha = SpellTimerFlash:GetAlpha() + 0.2
            if ( alpha < 1 ) then
                SpellTimerFlash:SetAlpha(alpha) 
            else 
	        SpellTimerFlash:SetAlpha(1.0) 
		this.SpellTimerFlash = nil 
            end 
        end 
    elseif (this.fadeOut) then
        local alpha = this:GetAlpha() - 0.05
        local SpellTimerBar = getglobal(this:GetName().."Bar")
        local min, max = SpellTimerBar:GetMinMaxValues()
        if (SpellTimerBar:GetValue() ~= max) then
            this:SetAlpha(1.0)
	    this.fadeOut = nil 
        end
        if ( alpha > 0 ) then
            this:SetAlpha(alpha) 
	else 
	    this.fadeOut = nil 
	    this:Hide() 
        end 	
    end 
end 
---------------------------------------------------------------------------------
--��ʱ���ϵ�������ʾ
--�������ֺ�ʣ��ʱ��
---------------------------------------------------------------------------------
function ShowSpellFrameTime(Text, str, spelltime, warning)
    if (SpellTimer_Config.WarningTime) then
        Text:SetText(str)
        if (tonumber(spelltime) < SpellTimer_Config.WarningTime and Text.WarningEnable) then
            if (not warning) then
            	Text:SetTextColor(0.9, 0, 0)
            end	    
            if (not Text.TextFlashTime) then
                Text.TextFlashTime = 0 
            end 
	    Text.TextFlashTime = Text.TextFlashTime + 1
            if (Text.TextFlashTime > 5) then
                Text.WarningEnable = nil
		Text.TextFlashTime = 0 
            end
	else 
	    Text:SetTextColor(0.9, 0.9, 0.9)
            if (not Text.TextFlashTime) then
                Text.TextFlashTime = 0 
            end Text.TextFlashTime = Text.TextFlashTime + 1
            if (Text.TextFlashTime > 5) then
                Text.WarningEnable = 1 
		Text.TextFlashTime = 0 
            end 
        end 
     else 
         Text:SetText(str) 
	 Text:SetTextColor(0.9, 0.9, 0.9) 
     end 
end 
----------------------------------------------------------------------------------
--����ʱ�����ʾ��ʽ
-----------------------------------------------------------------------------------
function SpellTimer_Format(duration)
     duration = math.floor(duration)
     local minute = math.floor(duration/60)
     local second = duration - minute*60 
     return string.format("%02d:%02d", minute, second) 
end 
----------------------------------------------------------------------------------------
--���ÿ����ʾframe��������֡��ȼ�����������ͬ�ͷ���
----------------------------------------------------------------------------------------
function SpellTimer_Filter(name, level, spell) 
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
         local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
         if (SpellTimerFrame and SpellTimerFrame:IsVisible() and (not SpellTimerFrame.name or (SpellTimerFrame.name == name and SpellTimerFrame.level == level)) and SpellTimerFrame.spell == spell) then
              return SpellTimerFrame, spell, SpellTimerFrame.context 
         end 
    end 
end 
-----------------------------------------------------------------------------------------------------
--��֤ͬ�෨��ֻ��ʾһ������������ͬ����ͼ��
------------------------------------------------------------------------------------------------------
function CheckSpellOnSameTarget(name, level, Tab_Four) 
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
        local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
        if (SpellTimerFrame and SpellTimerFrame:IsVisible() and (not SpellTimerFrame.name or (SpellTimerFrame.name == name and SpellTimerFrame.level == level))) then
            for combatpoint, spell in Tab_Four do
                if (spell == SpellTimerFrame.spell) then
                    SpellTimer_FadeOut(SpellTimerFrame) 
                end 
            end 
        end 
    end 
end 
---------------------------------------------------------------------------------------------------------
--Ŀ����������������.."Ч��"ȡ��ԭ������������
--Ŀ�����֡����������壩��Ч��������ʱ��
---------------------------------------------------------------------------------------------------------
function TrapOnSameTarget(name, spell, newbuff, hodetime) 
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
        local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
        if (SpellTimerFrame and SpellTimerFrame:IsVisible() and SpellTimerFrame.spell == spell) then
            SpellTimerFrame.name = name 
	    SpellTimerFrame.spell = newbuff 
	    Show_SpellTimer_Frame(SpellTimerFrame, newbuff, hodetime) 
            return 
        end 
    end 
end 
-----------------------------------------------------------------------------------------------------------
--���¼�ʱ��������ʾ�µļ�ʱ����ֻҪ��������������ǰ����Ҳ���ǡ�unique���ģ�
-----------------------------------------------------------------------------------------------------------
function SpellTimer_AddSpell(name, level, spell, hodetime, value, texture, SpellID, BookType, Special, context, spellrank)
    if (not value) then
        value = 0 
    end 
    --����ԭ��ʱ��
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
        local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
        if (SpellTimerFrame and SpellTimerFrame:IsVisible() and ((Special and Special["unique"]) or not SpellTimerFrame.name or (SpellTimerFrame.name == name and SpellTimerFrame.level == level)) and SpellTimerFrame.spell == spell) then
            Show_SpellTimer_Frame(SpellTimerFrame, spell, hodetime + value)
	    SpellTimerFrame.talent = nil
	    if (Special and Special.hp) then
	    	SpellTimerFrame.hp = Special.hp
	    end
            if (SpellTimer_Spells[PlayerClass][spell][4]) then
                CheckSpellOnSameTarget(name, level, SpellTimer_Spells[PlayerClass][spell][4]) 
            end 
            return 
        end 
    end 
    --�½�һ��
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
        local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
        if (SpellTimerFrame and not SpellTimerFrame:IsVisible()) then
	    if (Specaial and Special.hp) then
	    	SpellTimerFrame.hp = Special.hp
	    end
            SpellTimerFrame.spell = spell
	    SpellTimerFrame.rank = spellrank -->ר��Ϊ��Ȼ֮�����
	    SpellTimerFrame.name = name 
	    SpellTimerFrame.level = level 
	    SpellTimerFrame.SpellID = SpellID 
	    SpellTimerFrame.Special = Special 
	    SpellTimerFrame.talent = nil
	    SpellTimerFrame.type = BookType 
	    SpellTimerFrame.context = context
            local textureOb = getglobal("SpellTimerFrame"..i.."IconTexture") 
	    textureOb:SetTexture(texture) 
	    Show_SpellTimer_Frame(SpellTimerFrame, spell, hodetime + value)
            if (SpellTimer_Spells[PlayerClass][spell][4]) then
                CheckSpellOnSameTarget(name, level, SpellTimer_Spells[PlayerClass][spell][4]) 
            end 
            return 
       end 
    end 
end 
----------------------------------------------------------------------------------------------------------
--�ж��Ƿ�����ؼ�ʱ�� 
--ʧȥBUFF�����Ƴ��� ��BUF�ļ�ʱ���Ƴ�
--ͼ�ڱ��ݻ� ��ͼ�ڵļ�ʱ���Ƴ�
----------------------------------------------------------------------------------------------------------
function FadeOut_ByNLS(name, level, spell) 
     for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
         local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
         if (SpellTimerFrame and SpellTimerFrame:IsVisible() and (not spell or SpellTimerFrame.spell == spell) and (not name or SpellTimerFrame.name == name) and (not level or SpellTimerFrame.level == level)) then
             SpellTimer_FadeOut(SpellTimerFrame) 
         end 
     end 
end 
-----------------------------------------------------------------------------------------------------------
--����ʾʱ 
--�趨��ʾʱ�䡢�Ƿ���ʾ��ʱ���ͷ��������Լ�͸���ȵȳ�ʼ��Ϣ
-----------------------------------------------------------------------------------------------------------
function Show_SpellTimer_Frame(SpellTimerFrame, str, duration)
     local SpellTimerBar = getglobal(SpellTimerFrame:GetName().."Bar")
     local icon = getglobal(SpellTimerFrame:GetName().."Icon")
     local Text = getglobal(SpellTimerFrame:GetName().."Text") 

     SpellTimerFrame.Curenttime = GetTime() 
     SpellTimerFrame.max = SpellTimerFrame.Curenttime + duration

     if (SpellTimer_Config.ShowProgressBar) then
         local SpellTimerSpark = getglobal(SpellTimerBar:GetName().."Spark")
         local SpellTimerFlash = getglobal(SpellTimerBar:GetName().."Flash") 
	 SpellTimerBar:SetStatusBarColor(1.0, 0.7, 0.0) 
	 SpellTimerBar:SetMinMaxValues(SpellTimerFrame.Curenttime, SpellTimerFrame.max) 
	 SpellTimerBar:SetValue(SpellTimerFrame.Curenttime) 
	 SpellTimerFlash:Hide() 
	 SpellTimerBar:Show() 
	 SpellTimerSpark:SetPoint("CENTER", SpellTimerBar, "LEFT", 0, 0) 
	 SpellTimerSpark:Show() 
	 Text:ClearAllPoints() 
	 Text:SetPoint("TOPLEFT", SpellTimerFrame, "TOPLEFT", 35, 0) 
     else 
         Text:ClearAllPoints() 
	 Text:SetPoint("LEFT", SpellTimerFrame, "LEFT", 35, 0) 
	 SpellTimerBar:Hide() 
     end

     if (SpellTimer_Config.ShowName) then
         ShowSpellFrameTime(Text, SpellTimer_Format(duration).." - "..str, duration) 
     elseif (SpellTimer_Config.ShowTargetName and SpellTimerFrame.name) then
         ShowSpellFrameTime(Text, SpellTimer_Format(duration).." - "..SpellTimerFrame.name, duration)
     else    
	 ShowSpellFrameTime(Text, SpellTimer_Format(duration), duration) 
     end 
     SpellTimerFrame:SetAlpha(1.0) 
     SpellTimerFrame.Zero = 0 
     SpellTimerFrame.casting = 1 
     SpellTimerFrame.fadeOut = nil 
     SpellTimerFrame:Show()    
     SpellTimer_LastTimer = SpellTimerFrame    
end 
-------------------------------------------------------------------------------------------------------
--�ú���δʹ��
-------------------------------------------------------------------------------------------------------
function SpellTimer050(SpellTimerFrame)
     if (not SpellTimerFrame) then
         SpellTimerFrame = SpellTimer_LastTimer 
     end
     if (SpellTimerFrame and SpellTimerFrame:IsShown()) then
         if (SpellTimer_Config.ShowProgressBar) then
             local SpellTimerBar = getglobal(SpellTimerFrame:GetName().."Bar")
             local SpellTimerSpark = getglobal(SpellTimerBar:GetName().."Spark") 
	     SpellTimerBar:SetValue(SpellTimerFrame.max) 
	     SpellTimerBar:SetStatusBarColor(1.0, 0.0, 0.0) 
	     SpellTimerSpark:Hide() 
         end 
	 SpellTimerFrame.casting = nil 
	 SpellTimerFrame.fadeOut = 1 
	 SpellTimerFrame.Zero = GetTime() + 1 
     end 
end 
------------------------------------------------------------------------------------------------------
--�뿪ս�������س�����[��live��]����������м�ʱ��
------------------------------------------------------------------------------------------------------
function FadeOutAll() 
     for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
         local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
         if (SpellTimerFrame and SpellTimerFrame:IsVisible() and (not SpellTimerFrame.Special or not SpellTimerFrame.Special["live"])) then
             SpellTimer_FadeOut(SpellTimerFrame) 
         end 
     end 
end 
--------------------------------------------------------------------------------------------------------
--��frame��ʧ
--------------------------------------------------------------------------------------------------------
function SpellTimer_FadeOut(SpellTimerFrame)
     if (not SpellTimerFrame) then
         SpellTimerFrame = SpellTimer_LastTimer 
     end
     if (SpellTimerFrame and SpellTimerFrame:IsShown()) then
         if (SpellTimer_Config.ShowProgressBar) then
             local SpellTimerBar = getglobal(SpellTimerFrame:GetName().."Bar")
             local SpellTimerSpark = getglobal(SpellTimerBar:GetName().."Spark")
             local SpellTimerFlash = getglobal(SpellTimerBar:GetName().."Flash")
	     SpellTimerBar:SetValue(SpellTimerFrame.max) 
	     SpellTimerBar:SetStatusBarColor(0.0, 1.0, 0.0) 
	     SpellTimerSpark:Hide() 
	     SpellTimerFlash:SetAlpha(0.0) 
	     SpellTimerFlash:Show() 
	     SpellTimerFrame.SpellTimerFlash = 1 
         end 
	 SpellTimerFrame.casting = nil 
	 SpellTimerFrame.fadeOut = 1 
     end 
end 
-------------------------------------------------------------------------------------------------------
--��ʵ��������û����������ʵ�ʡ��ú�����Ϊ�˵��㷨������Ϣ��������һ��arry
--��Ȼ��������Ҳ��һ���ĵ����������ķ������и�ʩ�ŵķ�������ô�ͷ���true
-------------------------------------------------------------------------------------------------------
function SpellTimer_GetSpellInfoFromName(spellname, spellrank)
     local SpellName, info
     if (not spellname) then
     	 return    
     else 
         for SpellName, info in SpellTimer_Spells[PlayerClass] do
             if (SpellName == spellname) then
                 local SpellID, _type, subname, _rank, texture, desc, instant = BigFootSpell_GetSpellInfoFromName(SpellName, spellrank)
		 if (not SpellID) then
		     return false 
		 end
                 local i, j, hodetime
                 if (info[3]) then
                     i = 1 
		     j = 1 
		     hodetime = tostring(info[3])
		 --����ṹ�ǳ���,ʹ֮���Ժ���������[1]
		 else
                     if (type(info[1]) == "string") then
                         i, j, hodetime = string.find(desc, info[1])
                         if (hodetime and info[2]) then
                             hodetime = tostring(tonumber(hodetime)*info[2]) 
                         end 
                     elseif (type(info[1]) == "table") then
                     
                         local func = getglobal(info[1][1])    --func 
			 hodetime = func(desc, info[1][2])     
                         if (hodetime) then
                             hodetime["detect"] = getglobal(info[1][3]) 
			     i = 1 
			     j = 1 
                         end 
                     elseif (type(info[1]) == "number") then
                         hodetime = tostring(tonumber(info[1])) 
                     end 
                 end		 
                 if (i and j) then
                     if (not Spell_Info[SpellName]) then
                         Spell_Info[SpellName] = {} 
                     end
                     if (spellrank) then
                         Spell_Info[SpellName][spellrank] = {hodetime, texture, SpellID, _type, instant}
                     else 
		         Spell_Info[SpellName][1] = {hodetime, texture, SpellID, _type, instant}
			 --��Ҫ���:����ʱ��,ͼ��,ID,type,˲��<����Ҫ���ǳ���ʱ���ͼ��>
                     end 
                 end 
             end 
         end 
     end 
     return true 
end 
-----------------------------------------------------------------------------------------------------
--�жϸ÷����Ƿ������ʾ
--û�и÷�������û��disable��������ʾ��
-----------------------------------------------------------------------------------------------------
function SpellTimer_Has_Spell(spellname)
     if (not SpellTimer_Config.Spells) then 
         return 1 
     end
     if (not SpellTimer_Config.Spells[spellname]) then 
         return 1 
     end
     if (not SpellTimer_Config.Spells[spellname].disabled) then 
         return 1 
     end 
end 
------------------------------------------------------------------------------------------------------
--�����Ƿ����ӳ����ã�����еĻ��ͷ����ӳ�ֵ��û�оͻ�0
------------------------------------------------------------------------------------------------------
function SpellTimer_Has_Delay(spellname)
     if (not SpellTimer_Config.Spells) then 
         return 0 
     end
     if (not SpellTimer_Config.Spells[spellname]) then 
         return 0 
     end
     if (not SpellTimer_Config.Spells[spellname].delay) then 
         return 0 
     end 
         return SpellTimer_Config.Spells[spellname].delay 
end 
----------------------------------------------------------------------------------------------------------
--hook CastSpll����
--����÷������Լ�ʱ����ô�͵õ�һϵ�з�����Ϣ
--
----------------------------------------------------------------------------------------------------------
function New_CastSpell(slot, BookType)
     if (not DisableShow) then
         local spellname, spellrank = GetSpellName(slot, BookType)
	 --��ʱû����������         
         local SpellRank = 1 
	 CastingSpell = nil
         if (spellrank) then
             local _, _,  Rank = string.find(spellrank, "(%d+)")
	     SpellRank = tonumber( Rank)
             if (not SpellRank) then
                 SpellRank = 1 
             end 
         end
         local name = UnitName("target")
         local level = UnitLevel("target")
         if (slot) then
             if (SpellTimer_Spells[PlayerClass][spellname] and SpellTimer_Has_Spell(spellname)) then
	     --�÷����Ƿ��ڱ���,�����Ƿ�����ڿ���ʹ���б���,�Ƿ���disable
                 if (not Spell_Info[spellname] or not Spell_Info[spellname][SpellRank]) then		
                     if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
		     --����������ڿ�ʹ���б���,��ô�ٻ�ȡһ��,�����û��,��ô����û��ѧϰ�÷�����
                         org_CastSpell(slot, BookType) 
                         return 
                     end 
                 end
                 if (Spell_Info[spellname] and Spell_Info[spellname][SpellRank]) then
                     CastingSpell = {}
                     if (SpellTimer_Spells[PlayerClass][spellname][5]) then
                         CastingSpell.Special = SpellTimer_Spells[PlayerClass][spellname][5] 
                     end
                     if (CastingSpell.Special and CastingSpell.Special["notarget"]) then
                         CastingSpell.notarget = 1 
		     else 
		         CastingSpell.name = name 
                     end 
		     CastingSpell.level = level 
		     CastingSpell.spellname = spellname 
                     CastingSpell.spellrank = SpellRank		     		     
		     CastingSpell.hodetime = Spell_Info[spellname][SpellRank][1] 
		     CastingSpell.value = SpellTimer_Has_Delay(spellname) 
		     CastingSpell.texture = Spell_Info[spellname][SpellRank][2] 
		     CastingSpell.SpellID = Spell_Info[spellname][SpellRank][3] 
		     CastingSpell.type = Spell_Info[spellname][SpellRank][4] 
		     CastingSpell.instant = Spell_Info[spellname][SpellRank][5] 
                 end 
             end 
         end 
     end 
     org_CastSpell(slot, BookType) 
end 
--------------------------------------------------------------------------------------------
--hook SpellTargetUnit���� ��ҪΪ�˵õ�Ŀ�����ֺ͵ȼ�
--------------------------------------------------------------------------------------------
function New_SpellTargetUnit(unit)
     if (CastingSpell and not CastingSpell.name) then
         if (not CastingSpell.notarget) then
             CastingSpell.name = UnitName(unit) 
         end 
	 CastingSpell.level = UnitLevel(unit) 
     end 
     org_SpellTargetUnit(unit) 
end 
------------------------------------------------------------------------------------------------
--hook TargetUnit���� ���ü���ͬ��
------------------------------------------------------------------------------------------------
function New_TargetUnit(unit)
     if (CastingSpell and not CastingSpell.name) then
         if (not CastingSpell.notarget) then
             CastingSpell.name = UnitName(unit) 
         end 
	 CastingSpell.level = UnitLevel(unit) 
     end 
     org_TargetUnit(unit) 
end 
------------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------
function old_StopTargetting()
     if (CastingSpell) then
         CastingSpell = nil 
     end 
     org_StopTargetting() 
end 
------------------------------------------------------------------------------------------------
--hook CastSpellByName ���� 
------------------------------------------------------------------------------------------------
function New_CastSpellByName(name)     
     if (not DisableShow) then         
         local i, j, spellname = string.find(name, "(.+)%(")	 
         local _, _,  Rank = string.find(name, "([%d]+)")
         local SpellRank = 1 
	 CastingSpell = nil
         if (not spellname) then
             spellname = name 
         end
         if ( Rank) then
             SpellRank = tonumber( Rank)
             if (not SpellRank) then
                 SpellRank = 1 
             end 
         end
         local name = UnitName("target")
         local level = UnitLevel("target")
         local SpellID, BookType = BigFootSpell_GetSpellInfoFromName(spellname, SpellRank)
         if (SpellID) then
             if (SpellTimer_Spells[PlayerClass][spellname] and SpellTimer_Has_Spell(spellname)) then
                 if (not Spell_Info[spellname] or not Spell_Info[spellname][SpellRank]) then
                     if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
                         org_CastSpellByName(name) 
                         return 
                     end 
                 end
                 if (Spell_Info[spellname] and Spell_Info[spellname][SpellRank]) then
                     CastingSpell = {}
                     if (SpellTimer_Spells[PlayerClass][spellname][5]) then
                         CastingSpell.Special = SpellTimer_Spells[PlayerClass][spellname][5] 
                     end
                     if (CastingSpell.Special and CastingSpell.Special["notarget"]) then
                         CastingSpell.notarget = 1 else CastingSpell.name = name 
                     end 
		     CastingSpell.level = level 
		     CastingSpell.spellname = spellname 
		     CastingSpell.spellrank = SpellRank		     
		     CastingSpell.hodetime = Spell_Info[spellname][SpellRank][1] 
		     CastingSpell.value = SpellTimer_Has_Delay(spellname) 
		     CastingSpell.texture = Spell_Info[spellname][SpellRank][2] 
		     CastingSpell.SpellID = Spell_Info[spellname][SpellRank][3] 
		     CastingSpell.type = Spell_Info[spellname][SpellRank][4] 
		     CastingSpell.instant = Spell_Info[spellname][SpellRank][5] 
                 end 
             end 
         end 
     end 
     org_CastSpellByName(name) 
end 
------------------------------------------------------------------------------------------------------------
--�µ�UseContainerItem
--���ڻ�û������Ʒ��ʱ����Ϊ�һ�û�ҵ����ʵ�����Ʒ��ʼ��ʱ���¼�
------------------------------------------------------------------------------------------------------------
--[[
function New_UseContainerItem(bagID, slot, onself)
     if (not DisableShow) then         
         local itemname, item = SpellTimer_GetItemInfoFromName(bagID,slot)	
	 if (not itemrank) then
	      itemrank = 1
	 end
	 CastingSpell = nil
	 local name = UnitName("target")
         local level = UnitLevel("target")   
	 if (item) then	      
	      if (SpellTimer_Spells[PlayerClass][itemname] and SpellTimer_Has_Spell(itemname)) then
                   if (not Spell_Info[itemname] or not Spell_Info[itemname][itemrank]) then
                        if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
                             org_CastSpellByName(name) 
                             return 
                        end 
                   end
                   if (Spell_Info[itemname] and Spell_Info[itemname][itemrank]) then
                        CastingSpell = {}
                        if (SpellTimer_Spells[PlayerClass][itemname][5]) then
                             CastingSpell.Special = SpellTimer_Spells[PlayerClass][itemname][itemname][5] 
                        end
                        if (CastingSpell.Special and CastingSpell.Special["notarget"]) then
                             CastingSpell.notarget = 1 
		        else 
		             CastingSpell.name = name 
                        end 
			SpellStartTime = GetTime()
		        CastingSpell.level = level                                  -->���õ�Ŀ��ȼ�
		        CastingSpell.spellname = itemname 
			CastingSpell.spellrank = SpellRank                          -->��Ʒ����
		        CastingSpell.hodetime = Spell_Info[itemname][itemrank][1]-->����ʱ��
		        CastingSpell.value = SpellTimer_Has_Delay(spellname)        -->�ӳ�
		        CastingSpell.texture = Spell_Info[itemname][itemrank][2] -->texture
		        CastingSpell.SpellID = Spell_Info[itemname][itemrank][3] -->table
		        CastingSpell.type = Spell_Info[itemname][itemrank][4]    -->nil
		        CastingSpell.instant = Spell_Info[itemname][itemrank][5] -->nil
                   end 
              end    
	 end         
     end 
     org_UseContainerItem(bagID, slot, onself) 
end
--]]
function New_UseContainerItem(bagID, slot, onself)
     if (not DisableShow) then
         CastingSpell = nil 
     end 
     org_UseContainerItem(bagID, slot, onself) 
end
------------------------------------------------------------------------------------------------------------
--�µ� UseInventoryItem
------------------------------------------------------------------------------------------------------------
function New_UseInventoryItem(slot, onself)
     if (not DisableShow) then
         CastingSpell = nil 
     end 
     org_UseInventoryItem(slot, onself) 
end 
-------------------------------------------------------------------------------------------------------------
--������hook���������м�ֵ��
-------------------------------------------------------------------------------------------------------------
function New_UseAction(slot, checkCursor, onSelf)
     if (not DisableShow) then
         CastingSpell = nil 
	 SpellTimerTooltip:SetOwner(UIParent, "ANCHOR_NONE") 
	 SpellTimerTooltip:SetPoint("TOPLEFT", "UIParent", "BOTTOMRIGHT", 5, -5) 
	 SpellTimerTooltip:SetText("SpellTimerTooltip") 
	 SpellTimerTooltip:Show() 
	 SpellTimerTooltip:SetAction(slot)
         local spellname = SpellTimerTooltipTextLeft1:GetText()
	 local rankString = SpellTimerTooltipTextRight1:GetText() 
	 SpellTimerTooltip:Hide()
         local  Rank
         if (rankString) then
             local _ _, _, Rank = string.find(rankString, "[^%d]*(%d+)") 
         end
         local SpellRank = tonumber(Rank)
         if (not SpellRank) then
             SpellRank = 1 
         end
         local name = UnitName("target")
         local level = UnitLevel("target")
         if (slot) then
             if (SpellTimer_Spells[PlayerClass][spellname] and SpellTimer_Has_Spell(spellname)) then
                 if (not Spell_Info[spellname] or not Spell_Info[spellname][SpellRank]) then
                     if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
                         org_UseAction(slot, checkCursor, onSelf) 
                         return 
                     end 
                 end
                 if (Spell_Info[spellname] and Spell_Info[spellname][SpellRank]) then
--		     ChatFrame1:AddMessage("��"..spellname)
                     CastingSpell = {}
                     if (SpellTimer_Spells[PlayerClass][spellname][5]) then
                         CastingSpell.Special = SpellTimer_Spells[PlayerClass][spellname][5] 		     
                     end
                     if (CastingSpell.Special and CastingSpell.Special["notarget"]) then
                         CastingSpell.notarget = 1
		     else 
		         CastingSpell.name = name 
                     end 
		     SpellStartTime = GetTime()
		     CastingSpell.level = level 
		     CastingSpell.spellname = spellname 
		     CastingSpell.spellrank = SpellRank		     
		     CastingSpell.hodetime = Spell_Info[spellname][SpellRank][1] 
		     CastingSpell.value = SpellTimer_Has_Delay(spellname) 
		     CastingSpell.texture = Spell_Info[spellname][SpellRank][2] 
		     CastingSpell.SpellID = Spell_Info[spellname][SpellRank][3] 
		     CastingSpell.type = Spell_Info[spellname][SpellRank][4] 
		     CastingSpell.instant = Spell_Info[spellname][SpellRank][5] 
                 end 
             end 
         end 
     end 
     org_UseAction(slot, checkCursor, onSelf) 
end 
-----------------------------------------------------------------------------------------------------------------------
--���¶������ʩ������,����Ч
-----------------------------------------------------------------------------------------------------------------------
function New_CastPetAction(slotId) 
    if (not DisableShow) then
         CastingPet = nil
	 Pet_Tooltip:SetOwner(UIParent, "ANCHOR_NONE") 
	 Pet_Tooltip:SetPoint("TOPLEFT", "UIParent", "BOTTOMRIGHT", 5, -5) 
	 Pet_Tooltip:SetText("Pet_Tooltip") 
	 Pet_Tooltip:Show() 
         Pet_Tooltip:SetPetAction(slotId);    
         local spellname = Pet_TooltipTextLeft1:GetText();    
         local rankstring = Pet_TooltipTextRight1:GetText();
         Pet_Tooltip:Hide()
	 if (rankstring) then
	      local _ _, _, Rank = string.find(rankstring, "[^%d]*(%d+)") 
	 end
	 local SpellRank = tonumber(Rank)
         if (not SpellRank) then
              SpellRank = 1 	
         end
	 local name = UnitName("target")
	 local level = UnitLevel("target")
         if (slotId) then
             if (SpellTimer_Spells[PlayerClass][spellname] and SpellTimer_Has_Spell(spellname)) then
                 if (not Spell_Info[spellname] or not Spell_Info[spellname][SpellRank]) then
                     if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
                         org_CastPetAction(slotId)
                         return 
                     end 
                 end
                 if (Spell_Info[spellname] and Spell_Info[spellname][SpellRank]) then
                     CastingPet = {}
                     if (SpellTimer_Spells[PlayerClass][spellname][5]) then
                         CastingPet.Special = SpellTimer_Spells[PlayerClass][spellname][5] 
                     end
                     if (CastingPet.Special and CastingPet.Special["notarget"]) then
                         CastingPet.notarget = 1
		     else 
		         CastingPet.name = name 
                     end 		 
		     CastingPet.level = level 
		     CastingPet.spellname = spellname 
		     CastingPet.spellrank = SpellRank
		     CastingPet.hodetime = Spell_Info[spellname][SpellRank][1] 
		     CastingPet.value = SpellTimer_Has_Delay(spellname) 
		     CastingPet.texture = Spell_Info[spellname][SpellRank][2] 
		     CastingPet.SpellID = Spell_Info[spellname][SpellRank][3] 
		     CastingPet.type = Spell_Info[spellname][SpellRank][4] 
		     CastingPet.instant = Spell_Info[spellname][SpellRank][5] 
                 end 
             end 
         end 
     end 
    org_CastPetAction(slotId)
end
-----------------------------------------------------------------------------------------------------------------------
--enable/disable  ����Ϊ���ú���
-----------------------------------------------------------------------------------------------------------------------
function SpellTimerOption_Toggle(enable)
     if (enable) then
        local i
        for i = 1, 8, 1 do
            local SpellTimerFrame = getglobal("SpellTimerOptionFrameSpellOption"..i) 
			Checkbox_Slider_Toggle(SpellTimerFrame, 1) 
        end 
        SpellTimerScrollFrameScrollBarScrollUpButton:Enable() 
        SpellTimerScrollFrameScrollBarScrollDownButton:Enable()
        MobElement_Enable(SpellTimerOptionShowProgress) 
        MobElement_Enable(SpellTimerOptionShowName)
	    MobElement_Enable(SpellTimerOptionShowTargetName)
        MobElement_Enable(SpellTimerOptionShowTooltip) 
     else
        local i 
		for i = 1, 8, 1 do
            local SpellTimerFrame = getglobal("SpellTimerOptionFrameSpellOption"..i)
			Checkbox_Slider_Toggle(SpellTimerFrame, nil) 
        end 
	 SpellTimerScrollFrameScrollBarScrollUpButton:Disable() 
	 SpellTimerScrollFrameScrollBarScrollDownButton:Disable() 
	 SpellTimer_Config.EnabledTest = nil 
	 MobElement_Disable(SpellTimerOptionShowProgress) 
	 MobElement_Disable(SpellTimerOptionShowName) 
     MobElement_Disable(SpellTimerOptionShowTargetName) 
	 MobElement_Disable(SpellTimerOptionShowTooltip)        
     end 
end 

function SpellTimerOptionEnable_OnShow() 
     getglobal(this:GetName().."Text"):SetText(ENABLE_SPELL_TIMER)
     if (SpellTimer_Config.EnabledTest) then
        this:SetChecked(1) 
		SpellTimerOption_Toggle(1)
     else 
        this:SetChecked(0) 
		SpellTimerOption_Toggle(nil) 
     end 
end 
----------------------------------------------------------------------------------------------------
--��ʼ���߹ر�SepllTimer
----------------------------------------------------------------------------------------------------
function SpellTimerOptionEnable_OnClick()
     if (this:GetChecked() == 1) then
         SpellTimer_Config.EnabledTest = 1 
	 SpellTimerOption_Toggle(1) 
	 SpellTimer_Toggle(1) 
     else 
         SpellTimerOption_Toggle(nil) 
	 SpellTimer_Toggle(nil) 
     end 
end 
---------------------------------------------------------------------------------------------------
--���������ֹĳ����ʱ����ʾ
---------------------------------------------------------------------------------------------------
function Checkbox_Slider_Toggle(SpellTimerFrame, enable)
     local SpellTimerCheckbox = getglobal(SpellTimerFrame:GetName().."Checkbox")
     local SpellTimerSlider = getglobal(SpellTimerFrame:GetName().."Slider")
     if (enable) then
         MobElement_Enable(SpellTimerCheckbox) 
	 SpellTimer_Slider_Enable(SpellTimerSlider) 
     else 
         MobElement_Disable(SpellTimerCheckbox) 
	 SpellTimer_Slider_Disable(SpellTimerSlider) 
     end 
end 
-----------------------------------------------------------------------------------------------------
--��ֹ���߿����÷���������Ϣ����ԭtab
-----------------------------------------------------------------------------------------------------
function SpellTimerOptionFrameCheckbox_OnClick(id)
     if (this:GetChecked() == 1) then
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {}
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
             SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].disabled = nil
         local SpellTimerSlider 
	 SpellTimer_Slider_Enable(getglobal(this:GetParent():GetName().."Slider")) 
    else
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {} 
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
             SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].disabled = 1 
	 SpellTimer_Slider_Disable(getglobal(this:GetParent():GetName().."Slider")) 
    end 
end 
----------------------------------------------------------------------------------------------------
--��ʼ������ѡ���е���Ϣ
----------------------------------------------------------------------------------------------------
function Creat_OptionSpells()
    if (not OptionSpells) then
        OptionSpells = {n = 0}
        local spellname 
	for spellname in SpellTimer_Spells[PlayerClass] do 
	    table.insert(OptionSpells, spellname) 
        end 
	for Spellname in SpellTimer_Talents[PlayerClass] do
            table.insert(OptionSpells, SpellTimer_Talents[PlayerClass][Spellname][4])
	end
    end 
end 
----------------------------------------------------------------------------------------------------
--���ô�����ʾ
---------------------------------------------------------------------------------------------------
function SpellTimerOptionFrame_OnShow() 
    SpellTimerList_Update() 
    local text = getglobal(this:GetParent():GetName().."TitleText")  
    text:SetText(SPELL_TIMER)     
end 
---------------------------------------------------------------------------------------------------
--�õ�����ѡ���з�������Ŀ
---------------------------------------------------------------------------------------------------
function Get_Spells_Number() 
     Creat_OptionSpells() 
     return table.getn(OptionSpells) 
end 
---------------------------------------------------------------------------------------------------
--�õ�ָ����ŵķ�����Ϣ��������ڵĻ�
---------------------------------------------------------------------------------------------------
function Get_Config_Spells(id) 
     Creat_OptionSpells()
     if (OptionSpells[id]) then
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {}
         end
         if (SpellTimer_Config.Spells[OptionSpells[id]]) then
             return OptionSpells[id], not SpellTimer_Config.Spells[OptionSpells[id]].disabled, SpellTimer_Config.Spells[OptionSpells[id]].delay 
	 else 
             return OptionSpells[id], 1, nil 
         end 
    end 
end 
----------------------------------------------------------------------------------------------------
--�ú���û�õ�
----------------------------------------------------------------------------------------------------
function Set_Enable_Delay(id, enable, value) 
     Creat_OptionSpells()
     if (OptionSpells[id]) then
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {}
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
             SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].enabled = enable 
	 SpellTimer_Config.Spells[OptionSpells[id]].delay = value 
     end 
end 
-----------------------------------------------------------------------------------------------------
--��ʾָ��id�ķ�����Ϣ
-----------------------------------------------------------------------------------------------------
function SetUp_SpellOption(SpellTimerFrame, spellname, enable, value)
     if (spellname) then
         local SpellTimerCheckbox = getglobal(SpellTimerFrame:GetName().."Checkbox")
         local SpellTimerSlider = getglobal(SpellTimerFrame:GetName().."Slider")
         local str = getglobal(SpellTimerCheckbox:GetName().."Text") 
	 str:SetText(spellname)
         if (enable) then
             SpellTimerCheckbox:SetChecked(1)
	     SpellTimer_Slider_Enable(SpellTimerSlider) 
	 else 
	     SpellTimerCheckbox:SetChecked(0) 
	     SpellTimer_Slider_Disable(SpellTimerSlider) 
         end
         if (value) then
             local SliderText = getglobal(SpellTimerSlider:GetName().."Text") 
	     SpellTimerSlider:SetValue(value)
	     SliderText:SetText(value) 
	 else
             local SliderText = getglobal(SpellTimerSlider:GetName().."Text") 
	     SpellTimerSlider:SetValue(0)
	     SliderText:SetText(0) 
         end 
    end 
end 
----------------------------------------------------------------------------------------------------------------
--�����ð����Updata��ʾ��Ϣ
----------------------------------------------------------------------------------------------------------------
function SpellTimerList_Update()
     local SpellNumbers = Get_Spells_Number()
     local OffSet = FauxScrollFrame_GetOffset(SpellTimerScrollFrame)
     local id 
     for i = 1, 8, 1 do
         id = OffSet + i
         local str, enable, delay = Get_Config_Spells(id)
         local SpellOption = getglobal("SpellTimerOptionFrameSpellOption"..i) 
	 SpellOption:SetID(id)
	 SetUp_SpellOption(SpellOption, str, enable, delay)
         if ( id > SpellNumbers ) then
             SpellOption:Hide() 
	 else 
	     SpellOption:Show() 
         end 
     end
     if (SpellTimer_Config.EnabledTest) then
         FauxScrollFrame_Update(SpellTimerScrollFrame, SpellNumbers, 8, 20) 
     else 
         FauxScrollFrame_Update(SpellTimerScrollFrame, 1, 8, 20) 
     end 
end 

function SpellTimerOptionShowProgress_OnClick()
     if (this:GetChecked() == 1) then
         SpellTimer_Config.ShowProgressBar = 1 
     else 
         SpellTimer_Config.ShowProgressBar = nil 
     end 
end 

function SpellTimerOptionShowProgress_OnShow() 
     getglobal(this:GetName().."Text"):SetText(SHOW_PROGRESS_BAR)
     if (SpellTimer_Config.EnabledTest) then
         MobElement_Enable(this) 
     else 
         MobElement_Disable(this) 
     end
     if (SpellTimer_Config.ShowProgressBar) then
         this:SetChecked(1) 
     else 
         this:SetChecked(0) 
     end 
end 

function SpellTimerOptionShowName_OnClick()
     if (this:GetChecked() == 1) then
         SpellTimer_Config.ShowName = 1 
	 SpellTimer_Config.ShowTargetName = nil
	 SpellTimerOptionShowTargetName:SetChecked(0)
     else 
         SpellTimer_Config.ShowName = nil 
     end 
end 

function SpellTimerOptionShowName_OnShow() 
     getglobal(this:GetName().."Text"):SetText(SHOW_SPELL_NAME)
     if ( not SpellTimer_Config.EnabledTest) then
         MobElement_Disable(this) 
     elseif (SpellTimer_Config.ShowTargetName) then
         this:SetChecked(0)  
	 MobElement_Enable(this) 
	 return 
     else 
         MobElement_Enable(this)  
     end
     if (SpellTimer_Config.ShowName) then
         this:SetChecked(1) 
     else 
         this:SetChecked(0) 
     end 
end 
-----------------------------------------------------------------------------------------------
--����ָ��id<Ҳ���ǵ�ǰ����>�������ӳ�ʱ��
-----------------------------------------------------------------------------------------------
function SpellTimerOptionFrameSlider_OnChange(id)
     if (this.disabled) then 
         return 
     end
     local delay_time = this:GetValue() 
     this.value = delay_time 
     getglobal(this:GetName().."Text"):SetText(delay_time)
     if (delay_time > 0) then
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {} 
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
             SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].delay = delay_time
    else
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {} 
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
            SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].delay = nil 
    end 
end 

function SpellTimer_Slider_Disable(slider)
     local name = slider:GetName() 
     getglobal(name.."Thumb"):Hide() 
     getglobal(name.."Text"):SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b) 
     slider.disabled = 1 
end 

function SpellTimer_Slider_Enable(slider)
     local name = slider:GetName() 
     getglobal(name.."Thumb"):Show() 
     getglobal(name.."Text"):SetVertexColor(NORMAL_FONT_COLOR.r , NORMAL_FONT_COLOR.g , NORMAL_FONT_COLOR.b) 
     slider.disabled = nil
     if (slider.value) then
         slider:SetValue(slider.value) 
     end 
end 

function MobElement_Disable(obj) 
     obj:Disable() 
     local textOb = getglobal(obj:GetName().."Text") 
     textOb:SetTextColor(0.5, 0.5, 0.5) 
end 

function MobElement_Enable(obj) 
     obj:Enable() 
     local textOb = getglobal(obj:GetName().."Text") 
     textOb:SetTextColor(1.0, 0.82, 0) 
end 
---------------------------------------------------------------------------------------------------
--�õ��츳��Ϣ,ԭ����ST_DB���.
---------------------------------------------------------------------------------------------------
function SpellTimer_GetTalents()
    if (not PlayerClass) then
    	PlayerClass = UnitClass("player")
    end    
    local numTabs = GetNumTalentTabs()    
    local name, iconTexture, tier, column, rank, maxRank,text;
    local numTalents
    local tabname, texture, points, fileName;
    if (not Talents) then
    	Talents = {}    
    end      
    for x=1, numTabs do
         numTalents = GetNumTalents( x )  
         tabname, texture, points, fileName = GetTalentTabInfo( x )        
         for i=1, numTalents do
              name, iconTexture, tier, column, rank, maxRank = GetTalentInfo( x, i)
	      if (SpellTimer_Talents[PlayerClass][name] and rank > 0) then 
	           effec = SpellTimer_Talents[PlayerClass][name][4]
		   if (not Talents[effec]) then
		   	Talents[effec] = {}
		   end
		   BigFoot_Tooltip_Init(1)
                   SPTalentTooltip:SetTalent(x,i)
                   local text = BigFoot_Tooltip_GetText(1) 
                   SPTalentTooltip:Hide()
                   _, _, duration = string.find(text, SpellTimer_Talents[PlayerClass][name][1])
		   if ( SpellTimer_Talents[PlayerClass][name][2]) then
		   	duration = tonumber(tonumber(duration)*SpellTimer_Talents[PlayerClass][name][2])
		   else
		        duration = tonumber(duration)
		   end	
		   Talents[effec][1] = duration
		   Talents[effec][2] = iconTexture
              end
         end
    end   
end
---------------------------------------------------------------------------------------------------------
--��ʾĿ������
---------------------------------------------------------------------------------------------------------
function ST_ShowTargetName_OnClick()
    if (this:GetChecked() == 1) then
    	 SpellTimer_Config.ShowTargetName = 1
	 SpellTimer_Config.ShowName = nil
	 SpellTimerOptionShowName:SetChecked(0)
    else
         SpellTimer_Config.ShowTargetName = nil	
    end
end
function ST_ShowTargetName_OnShow()
    getglobal(this:GetName().."Text"):SetText(SHOW_SPELL_TARGETNAME) 
    if ( not SpellTimer_Config.EnabledTest) then
    	 MobElement_Disable(this)
    elseif (SpellTimer_Config.ShowName) then
         MobElement_Enable(this) 
         this:SetChecked(0)
	 return
    else
         MobElement_Enable(this)  
    end
    if (SpellTimer_Config.ShowTargetName) then
    	 this:SetChecked(1)
    else
         this:SetChecked(0)
    end
end
--------------------------------------------------------------------------------------------------------
--�������ʾ
--------------------------------------------------------------------------------------------------------
function ST_MoseInfo_OnClick()
     if (this:GetChecked() == 1) then
     	 SpellTimer_Config.TooltipInfo = 1
     else
         SpellTimer_Config.TooltipInfo = nil
     end
end
function ST_MoseInfo_Onshow()
     getglobal(this:GetName().."Text"):SetText(SHOW_TOOLTIP_INFO)
     if ( not SpellTimer_Config.EnabledTest) then
    	 MobElement_Disable(this) 
     else
         MobElement_Enable(this)  
     end
     if (SpellTimer_Config.TooltipInfo) then
     	 this:SetChecked(1)
     else
         this:SetChecked(0)
     end
end
--========================================================================================
--===============================WOWSHELL=================================================
--========================================================================================
function Load_Default_OnClick()
     PlaySound("igMainMenuOption")
     SpellTimer_Config = {}
     SpellTimer_Config = ST_Clone(ST_Default_Config)
     SpellTimerList_Update()            
     if (IsAddOnLoaded("SpellTimer_Enemy")) then
	   EnemyConfig = {}
	   EnemyConfig = ST_Clone(Enemy_Default_Config)
	   SpellTimer_EnemyList_Update()
     end
     if (SpellTimerOptionFrame:IsVisible()) then
     	 SpellTimerOptionFrame:Hide()
         SpellTimerOptionFrame:Show()
     else
         SpellTimer_EnemyOptionFrame:Hide()
	 SpellTimer_EnemyOptionFrame:Show()
     end     
end

function SpellTimer_Option_OnShow()     
     SpellTimerOptionFrame:Show()
     local texture = getglobal(this:GetName().."IconTexture")
     texture:SetTexture("Interface\\QuestFrame\\UI-QuestLog-BookIcon") 
end

function SpellTimer_Cancel()
    PlaySound("igMainMenuOption")
    if (SpellTimer_EnemyOptionFrame) then
    	 SpellTimer_EnemyOptionFrame:Hide()
    end    
    SpellTimerOptionFrame:Show()
    HideUIPanel(this:GetParent())
    SpellTimer_Config = {}
    SpellTimer_Config = ST_Clone(org_stconfig)
    if (IsAddOnLoaded("SpellTimer_Enemy")) then
        EnemyConfig = {}
        if ( org_enconfig) then             
    	     EnemyConfig = ST_Clone(org_enconfig)
	else
             EnemyConfig = ST_Clone(Enemy_Default_Config)
        end        
    end    
end
--------------------------------------------------------------------------------------------
--��¡һ��table
--------------------------------------------------------------------------------------------
function ST_Clone(t) 
    local new = {}             
    local i, v = next(t, nil)  
    while i do
  	 if type(v)=="table" then 
  	      v=ST_Clone(v)
  	 end 
         new[i] = v
         i, v = next(t, i)      
    end
    return new
end  