 local Pet_Spells = {};
 local BF_key1 = nil;
 local BF_Key2 = nil;
 BF_Player_Spells = {};
 SpellHelper_Stack = {};
--===============================================================================================================
--========================================法術信息===============================================================
--===============================================================================================================
 if (GetLocale() == "zhCN") then 
    BIGFOOT_SPELL_RANK_MATCH_PATTERN = "等级 (%d+)" 
    BIGFOOT_SPELL_INSTANT_PATTERN = "<n>瞬发"
 elseif (GetLocale() == "zhTW") then 
    BIGFOOT_SPELL_RANK_MATCH_PATTERN = "等級 (%d+)" 
    BIGFOOT_SPELL_INSTANT_PATTERN = "<n>立即施法"
 else 
    BIGFOOT_SPELL_RANK_MATCH_PATTERN = "Rank (%d+)" 
    BIGFOOT_SPELL_INSTANT_PATTERN = "<n>Instant cast"
 end 
function BigFootSpells_OnLoad() 
    this:RegisterEvent("LEARNED_SPELL_IN_TAB") 
    this:RegisterEvent("PLAYER_LOGIN")
    this:RegisterEvent("UNIT_PET")        
end 

function BigFootSpells_OnEvent(event) 
    if (event == "PLAYER_LOGIN") then
         BigFoot_DelayCall(BF_GetPlayerSpellInfo,5)
    elseif (event == "LEARNED_SPELL_IN_TAB") then
         if (SPELL_HELPER_KEY) then
              BF_GetNewSpells();
	 else
	      BigFoot_DelayCall(BF_GetPlayerSpellInfo,5);
         end                  
	 SpellTimer_GetTalents();
    elseif (event == "UNIT_PET" and arg1 == "player") then   
         BigFoot_DelayCall(BF_GetPetSpellInfo,2)
    end
end 
function BF_GetPlayerSpellInfo() 
    BF_key1 = 1;
    if (not MyPlayerInfo) then
    	MyPlayerInfo = {};
    end
    if (not MyPlayerInfo.Spells) then
    	MyPlayerInfo.Spells = {};
    end    
    MyPlayerInfo.Spells = Scan_SpellBook(); 
end 

function BF_GetPetSpellInfo()
     BF_Key2 = 1;
     if (not PlayerInfo) then
     	 PlayerInfo = {};
     end
     if (not PlayerInfo["petspells"]) then
         PlayerInfo["petspells"] = {};
     end
     local _, PlayerClass = UnitClass("Player");
     if (PlayerClass == "WARLOCK" or PlayerClass == "HUNTER") then
         PlayerInfo["petspells"] = Scan_PetSpells();	         
     end
end

function Scan_SpellBook() 
    local tabnum = GetNumSpellTabs(); 
    local name, texture, offset, numspells; 
    local PlayerSpells; 
    PlayerSpells = {}; 
    for i = 1, MAX_SKILLLINE_TABS do 
         if (i <= tabnum) then 
	      name, texture, offset, numspells = GetSpellTabInfo(i); 
	      PlayerSpells[name] = {}; 
	      for j = 1, numspells do 
	           local texture = GetSpellTexture(offset + j, BOOKTYPE_SPELL); 
		   local SpellName, subSpellName = GetSpellName(offset + j, BOOKTYPE_SPELL); 
		   local Passive = IsSpellPassive(offset + j, BOOKTYPE_SPELL); 
		   local start, duration, enable = GetSpellCooldown(offset + j, BOOKTYPE_SPELL); 
		   BigFoot_Tooltip_Init(); 
		   BigFootTooltip:SetSpell(offset + j, BOOKTYPE_SPELL); 
		   local Text = BigFoot_Tooltip_GetText(); 
		   BigFootTooltip:Hide(); 
		   local NameOfSpell; 
		   local SpellRank; 
		   if (subSpellName) then 
		        NameOfSpell = SpellName .. "(" ..subSpellName .. ")" ;
		   else 
		        NameOfSpell = SpellName ;
		   end 
		   PlayerSpells[name][NameOfSpell] = {}; 
		   PlayerSpells[name][NameOfSpell]["spellName"] = SpellName ;
		   PlayerSpells[name][NameOfSpell]["subSpellName"] = subSpellName;
		   if (subSpellName) then 
		        k, v, SpellRank = string.find(subSpellName, BIGFOOT_SPELL_RANK_MATCH_PATTERN); 
			if (k and v) then 
			     PlayerSpells[name][NameOfSpell]["rank"] = tonumber(SpellRank) ;
			end 
		   end
		   PlayerSpells[name][NameOfSpell]["texture"] = texture; 
		   PlayerSpells[name][NameOfSpell]["isPassive"] = Passive ;
		   PlayerSpells[name][NameOfSpell]["name"] = NameOfSpell; 
		   PlayerSpells[name][NameOfSpell]["id"] = offset + j ;
		   PlayerSpells[name][NameOfSpell]["bookType"] = BOOKTYPE_SPELL; 
		   if (string.find(Text, BIGFOOT_SPELL_INSTANT_PATTERN)) then 
		        PlayerSpells[name][NameOfSpell]["instant"] = 1; 
		   end 
		   PlayerSpells[name][NameOfSpell]["description"] = Text;		  
	      end 
	 end 
    end 
    return PlayerSpells 
end 

function BF_GetNewSpells() 
    local Spells = Scan_SpellBook() 
    local newSpells = {} 
    for i, v in Spells do 
        if (MyPlayerInfo.Spells[i]) then                             
            for k, t in v do 
                if (not MyPlayerInfo.Spells[i][k]) then 
                     newSpells[k] = t 
                end 
            end  
        else                                                    
            for k, t in v do 
                newSpells[k] = t 
            end 
        end 
    end 
    --得到新学法术的信息，保存在SpellHelper_Stack中，如果可以的话。
    if (BF_key1) then     
        for i, v in newSpells do	     
	      if (not v["isPassive"]) then
	     	   SpellHelper_Stack[v["name"]] = v
                   SpellHelperButton_UpdateButtons() 
	      end	                      
        end 
    end 
    MyPlayerInfo.Spells = Spells 
end 

function BifFootSpell_GetSpellTextureFromName(name)    
    for k, v in MyPlayerInfo.Spells do
         for i, t in v do
              if (t["spellName"] == name) then
              	   return t["texture"];
              end
         end    	
    end
end
--ID
function BigFootSpell_GetSpellIdFromName(spellname, spellrank) 
    for i, v in MyPlayerInfo.Spells do 
         for k, t in v do 
             if (k == spellname) then 
               return t["id"] 
             end 
         end 
    end
end

--SPELLINFO
function BigFootSpell_GetSpellInfoFromName(name, SpellRank) 
    local SpellInfo ;
    local spellrank ;
    if (not BF_key1) then 
         BF_GetPlayerSpellInfo();   
    end 
    if (not BF_Key2) then
    	BF_GetPetSpellInfo();
    end
    for i, v in MyPlayerInfo.Spells do
         for k, t in v do
              if (t["spellName"] == name) then
                   if (t["rank"]) then
                        if (not spellrank) then 
		             spellrank = 0 ;
                        end
                        if (t["rank"] == SpellRank) then 
	                     return t["id"], t["bookType"], t["subSpellName"], t["rank"], t["texture"], t["description"], t["instant"]; 
                        elseif (t["rank"] > spellrank) then 
	                     spellrank = t["rank"]; 
			     SpellInfo = t ;
                        end 
                   else 
	                return t["id"], t["bookType"], t["subSpellName"], t["rank"], t["texture"], t["description"], t["instant"]; 
                   end 
              end 
         end 
    end  
    if (PlayerInfo["petspells"]) then    
         for i, v in PlayerInfo["petspells"] do    	      
    	      if (v["spellName"] == name) then
    	           if (v["rank"]) then
                        if (not spellrank) then 
		             spellrank = 0; 
                        end
                        if (v["rank"] == SpellRank) then 
	                     return v["id"], v["bookType"], v["subSpellName"], v["rank"], v["texture"], v["description"], v["instant"]; 
                        elseif (v["rank"] > spellrank) then 
	                     spellrank = v["rank"] ;
			     SpellInfo = v ;
                        end 
                   else 
	                return v["id"], v["bookType"], v["subSpellName"], v["rank"], v["texture"], v["description"], v["instant"]; 
                   end               
    	      end    	     
         end
    end
    if (SpellInfo) then 
         return SpellInfo["id"], SpellInfo["bookType"], SpellInfo["subSpellName"], SpellInfo["rank"], SpellInfo["texture"], SpellInfo["description"], SpellInfo["instant"]; 
    end 
end 
--============================================================================================================
--=======================================宠物法术信息=========================================================
--============================================================================================================

function Scan_PetSpells()
    if (not Pet_Spells) then
    	 Pet_Spells = {};
    end
    local SpellName, subSpellName, texture, Passive, strt, duration, enable;
    local SpellRank, Rank    
    local numPetSpells = HasPetSpells();
    if (not numPetSpells) then
    	  return nil;
    end
    for id = 1, numPetSpells do
          local texture = GetSpellTexture(id, BOOKTYPE_PET); 
          local SpellName, subSpellName = GetSpellName(id, BOOKTYPE_PET); 
	  local Passive = IsSpellPassive(id, BOOKTYPE_PET); 
	  local start, duration, enable = GetSpellCooldown(id, BOOKTYPE_PET);
	  BigFoot_Tooltip_Init(4); 
	  Pet_Tooltip:SetSpell(id, BOOKTYPE_PET); 
	  local text = BigFoot_Tooltip_GetText(4);
	  Pet_Tooltip:Hide();  
	  local NameOfSpell;
	  if (subSpellName) then
	      NameOfSpell = SpellName.."("..subSpellName..")";
	  else
	      NameOfSpell = SpellName;
	  end
          Pet_Spells[NameOfSpell] = {};
	  if (subSpellName) then
	       _,_,SpellRank = string.find(subSpellName,BIGFOOT_SPELL_RANK_MATCH_PATTERN);
	       if (_) then
	       	   Rank = tonumber(SpellRank);
	       end
	  end
	  Pet_Spells[NameOfSpell]["name"] = NameOfSpell;
	  Pet_Spells[NameOfSpell]["rank"] = Rank;
	  Pet_Spells[NameOfSpell]["texture"] = texture ;
          Pet_Spells[NameOfSpell]["isPassive"] = Passive;	  
	  Pet_Spells[NameOfSpell]["id"] = id; 
	  Pet_Spells[NameOfSpell]["bookType"] = BOOKTYPE_PET; 
	  if (string.find(text, BIGFOOT_SPELL_INSTANT_PATTERN)) then 
	       Pet_Spells[NameOfSpell]["instant"] = 1;
	  end 
	  Pet_Spells[NameOfSpell]["description"] = text;
	  Pet_Spells[NameOfSpell]["spellName"] = SpellName;
	  Pet_Spells[NameOfSpell]["subSpellName"] = subSpellName;
    end
    return Pet_Spells;
end
--========================================================================================
--~================================以下為基礎函數.========================================
--========================================================================================
------------------------------------------------------------------------------------------
--延迟函数
------------------------------------------------------------------------------------------
function BigFoot_DelayCall(BigFootfunc, BigFootdelay, ...) 
     if ( not BigFootFrame.callroutine ) then
         BigFootFrame.callroutine = {} 
     end 
     local BigFootDelayCall = {} 
     BigFootDelayCall["func"] = BigFootfunc 
     BigFootDelayCall["delay"] = BigFootdelay 
     BigFootDelayCall["lastUpdate"] = 0 
     for t = 1, arg.n, 1 do 
         BigFootDelayCall["arg"..t] = arg[t] 
     end 
     table.insert(BigFootFrame.callroutine, BigFootDelayCall) 
end
function BigFoot_OnUpdate(elapsed) 
     if (BigFootFrame.callroutine) then    
         for k, v in BigFootFrame.callroutine do 
              v["lastUpdate"] = v["lastUpdate"] + elapsed 
              if ( v["lastUpdate"] > v["delay"] ) then 
                   if (type(v["func"]) == "string") then 
                        local BigFootfunc = getglobal(v["func"]) 
                        BigFootfunc(v["arg1"], v["arg2"], v["arg3"], v["arg4"], v["arg5"], v["arg6"], v["arg7"], v["arg8"], v["arg9"]) 
                   else 
                        v["func"](v["arg1"], v["arg2"], v["arg3"], v["arg4"], v["arg5"], v["arg6"], v["arg7"], v["arg8"], v["arg9"]) 
                   end 
                   table.remove(BigFootFrame.callroutine, k) 
              end 
         end 
     end
end
-----------------------------------------------------------------------------------------------------------
--初始化tooltip
-----------------------------------------------------------------------------------------------------------
function BigFoot_Tooltip_Init(tip)
     local Tooltip = BigFootTooltip
     tip = tostring(tip)
     if (not tip) then
     	 Tooltip = BigFootTooltip
     elseif (tip == "1") then
         Tooltip = SPTalentTooltip
     elseif (tip == "2") then
         Tooltip = SPBagTooltip
     elseif (tip == "3") then
         Tooltip = SPInventoryTooltip
     elseif (tip == "4") then
         Tooltip = Pet_Tooltip
     end
     for i = 1, 30, 1 do 
         local TooltipLeftText = getglobal(Tooltip:GetName().."TextLeft"..i) 
         local TooltipRightText = getglobal(Tooltip:GetName().."TextRight"..i) 
	 TooltipLeftText:SetText("") 	
         TooltipRightText:SetText("") 
     end 
     Tooltip:SetOwner(UIParent, "ANCHOR_NONE") 
     Tooltip:SetPoint("TOPLEFT", "UIParent", "BOTTOMRIGHT", 5, -5)
     Tooltip:SetText("BigFootTooltip")
     Tooltip:Show() 
end 
------------------------------------------------------------------------------------------------
--获取tooltip信息
------------------------------------------------------------------------------------------------
function BigFoot_Tooltip_GetText(tip)
     local Tooltip = BigFootTooltip
     tip = tostring(tip)
     if (not tip) then 
         Tooltip = BigFootTooltip
     elseif (tip == "1") then
         Tooltip = SPTalentTooltip
     elseif (tip == "2") then
         Tooltip = SPBagTooltip
     elseif (tip == "3") then
         Tooltip = SPInventoryTooltip
     elseif (tip == "4") then
         Tooltip = Pet_Tooltip
     end 
     local BF_TooltipText = "" 
     getglobal(Tooltip:GetName()):Show() 
     for i = 1, 30, 1 do
         local TooltipLeftText = getglobal(Tooltip:GetName().."TextLeft"..i) 
         local TooltipRightText = getglobal(Tooltip:GetName().."TextRight"..i) 
         local LeftText 
         local RightText 
	 LeftText = TooltipLeftText:GetText()	
	 RightText = TooltipRightText:GetText() 
         local LeftandRightText = "" 
         if ( i == 1 ) then 
              if ( LeftText == nil ) then 
                   return 
              end 
         end 
         if ( LeftText == nil and RightText == nil ) then
              LeftandRightText = "" 
         else 
              if ( LeftText == nil ) then
                   LeftText = "" 
              end 
              if ( RightText == nil ) then 
                   RightText = "" 
              end 
              if ( RightText ~= "" ) then 
                   LeftandRightText = LeftText.."<t>"..RightText
              else 
                   LeftandRightText = LeftText 
              end 
         end 
         if ( LeftandRightText ~= "" ) then 
             BF_TooltipText = BF_TooltipText..LeftandRightText.."<n>" 
         end 
      end 
      return BF_TooltipText 
end 
