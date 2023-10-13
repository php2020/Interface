DISTANCEWARNING_SAVE={};
DISTANCEWARNING_PROFILE="";
DW_CFG_LOADED=false;
DW_LOCK=nil;
DW_SCALE=nil;
DW_SHOWMOD=2;
DW_NEEDSCAN=false;
DW_MAX_DISTANCE=nil;
DW_MIN_DISTANCE=nil;
DW_ATTACK_ACTION_SLOT={};
DW_ASSIST_ACTION_SLOT={};
DW_ATTACK_NEEDSCAN={};
DW_ASSIST_NEEDSCAN={};
DW_PLAYER_CLASS=nil;
DW_PLAYER_LEVEL=nil; 
DW_TALENTTAB_LOADED=false;
DW_TOWNWATCH_RANK=0;
DW_EVILSTRATAGEM_RANK=0;
DW_EVILSTRATAGEM_INCREASE_RANGE=0; 
DW_FRAMETHROWING_RANK=0;
DW_ARCTICREACH_RANK=0;
DW_NATUREREACH_RANK=0;
DW_GRIMREACH_RANK=0;
DW_DESTRUCTIVEREACH_RANK=0;
DW_HOLYREACH_RANK=0;
DW_SHADOWREACH_RANK=0;
DW_STORMREACH_RANK=0;
DW_MELEE_MODIFYER=nil;
DW_RANGE_MODIFYER=nil;
DW_MELEE_ATTACK_BAR=nil;
DW_RANGE_ATTACK_BAR=nil;
DW_ASSIST_BAR=nil;
DW_MSG1="于动作栏探测到--";
DW_MSG2="--可对敌对目标提示";
DW_MSG3="--可对友方目标提示";

function DistanceWarning_OnLoad()
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHARACTER_POINTS_CHANGED"); 
	
	for i=5,41 do
		DW_ATTACK_ACTION_SLOT[i]=nil;
		DW_ATTACK_NEEDSCAN[i]=false;
		DW_ASSIST_ACTION_SLOT[i]=nil;
		DW_ASSIST_NEEDSCAN[i]=false;
	end
	DW_NEEDSCAN=false;
	
	SLASH_DISTANCEWARNING1="/distancewarning";
	SLASH_DISTANCEWARNING2="/dw";
	SLASH_DISTANCEWARNING3="/DW";
	SlashCmdList["DISTANCEWARNING"]=function(msg)
		DistanceWarning_SlashCommanHandler(msg);
	end
end

function DistanceWarning_LoadCfg()
	if(DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE]==nil) then
		DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE]={};
	end
	if(DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].lock==nil) then
		DW_LOCK=0;
		DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].lock=0;
	else
		DW_LOCK=DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].lock;
	end
	if(DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].scale==nil) then
		DW_SCALE=1;
		DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].scale=1;
	else
		DW_SCALE=DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].scale;
		DistanceWarningBar:SetScale(DW_SCALE*UIParent:GetScale());
	end
	if(DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].showmod==nil) then
		DW_SHOWMOD=1;
		DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].showmod=1;
	else
		DW_SHOWMOD=DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].showmod;
	end
	if(DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].meleeattackbar==nil) then
		DW_MELEE_ATTACK_BAR=0;
	else
		DW_MELEE_ATTACK_BAR=DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].meleeattackbar;
	end
	if(DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].rangeattackbar==nil) then
		DW_RANGE_ATTACK_BAR=0;
	else
		DW_RANGE_ATTACK_BAR=DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].rangeattackbar;
	end
	if(DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].assistbar==nil) then
		DW_ASSIST_BAR=0;
	else
		DW_ASSIST_BAR=DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].assistbar;
	end
end

function DistanceWarning_SlashCommanHandler(msg)
	if(msg) then
		if(string.lower(msg)=="lock" or msg=="锁定") then
			DW_LOCK=1;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].lock=1; 
			ChatFrame1:AddMessage("DistanceWarning 锁定",1,1,0);
		elseif(string.lower(msg)=="unlock" or msg=="解锁") then
			DW_LOCK=0;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].lock=0;
			ChatFrame1:AddMessage("DistanceWarning 解除锁定",1,1,0);
		elseif(string.sub(string.lower(msg),1,5)=="scale" or string.sub(msg,1,6)=="缩放") then
			if(string.sub(string.lower(msg),1,5)=="scale") then
				DW_SCALE=tonumber(string.sub(string.lower(msg),7)); 
			else
				DW_SCALE=tonumber(string.sub(string.lower(msg),8));
 			end
 			if(DW_SCALE and DW_SCALE>=0.5 and DW_SCALE<=3) then
				DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].scale=DW_SCALE; 
				DistanceWarningBar:ClearAllPoints();
				DistanceWarningBar:SetPoint("CENTER","UIParent",0,0);
				DistanceWarningBar:SetScale(DW_SCALE*UIParent:GetScale());
				ChatFrame1:AddMessage("DistanceWarning 缩放比例:"..DW_SCALE,1,1,0);
			else
				DistanceWarning_ShowCmd();
			end
		elseif(string.lower(msg)=="usedefault" or string.lower(msg)=="默认设置") then
			DW_LOCK=0;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].lock=0;
			ChatFrame1:AddMessage("DistanceWarning 解除锁定",1,1,0);
			
			DW_SCALE=1;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].scale=0.8;
			DistanceWarningBar:ClearAllPoints();
			DistanceWarningBar:SetPoint("CENTER","UIParent",0,0);
			DistanceWarningBar:SetScale(DW_SCALE*UIParent:GetScale());
			ChatFrame1:AddMessage("DistanceWarning 缩放比例:"..DW_SCALE,1,1,0);
			
			DW_SHOWMOD=1;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].showmod=1;
			ChatFrame1:AddMessage("DistanceWarning 显示模式1",1,1,0);
			
			DW_MELEE_ATTACK_BAR=0;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].meleeattackbar=0;
			ChatFrame1:AddMessage("DistanceWarning 近身攻击动作栏取消",1,1,0);
			DW_RANGE_ATTACK_BAR=0;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].rangeattackbar=0;
			ChatFrame1:AddMessage("DistanceWarning 远程攻击动作栏取消",1,1,0);
			DW_ASSIST_BAR=0;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].assistbar=0;
			ChatFrame1:AddMessage("DistanceWarning 援助动作栏取消",1,1,0);
			
		elseif(string.lower(msg)=="showmod1" or string.lower(msg)=="显示模式1") then
			DW_SHOWMOD=1;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].showmod=1;
			ChatFrame1:AddMessage("DistanceWarning 显示模式1",1,1,0);
		elseif(string.lower(msg)=="showmod2" or string.lower(msg)=="显示模式2") then
			DW_SHOWMOD=2;
			DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].showmod=2;
			ChatFrame1:AddMessage("DistanceWarning 显示模式2",1,1,0); 
								
		elseif(string.sub(string.lower(msg),1,8)=="meleebar" or string.sub(msg,1,15)=="近战动作栏") then
			if(string.sub(string.lower(msg),1,8)=="meleebar") then 
				DW_MELEE_ATTACK_BAR=tonumber(string.sub(msg,10));
			else
				DW_MELEE_ATTACK_BAR=tonumber(string.sub(msg,17));
			end
 			if(DW_MELEE_ATTACK_BAR and DW_MELEE_ATTACK_BAR>=1 and DW_MELEE_ATTACK_BAR<=10) then
				DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].meleeattackbar=DW_MELEE_ATTACK_BAR;
				ChatFrame1:AddMessage("DistanceWarning 当可攻击目标距离小于8时自动切换到动作栏"..DW_MELEE_ATTACK_BAR,1,1,0); 
				ChatFrame1:AddMessage("由于暴雪将用于切换动作栏的函数ChangeActionBarPage()设置为在战斗状态下禁用，导致现在无法在战斗中通过宏或插件切换动作栏，故该功能暂时取消!敬请谅解",1,0,0);
 				else
				DW_MELEE_ATTACK_BAR=0;
				DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].meleeattackbar=0;
				ChatFrame1:AddMessage("DistanceWarning 近身攻击动作栏取消",1,1,0);
			end
		elseif(string.sub(string.lower(msg),1,8)=="rangebar" or string.sub(msg,1,15)=="远程动作栏") then
			if(string.sub(string.lower(msg),1,8)=="rangebar") then 
				DW_RANGE_ATTACK_BAR=tonumber(string.sub(msg,10));
			else
				DW_RANGE_ATTACK_BAR=tonumber(string.sub(msg,17));
			end
 			if(DW_RANGE_ATTACK_BAR and DW_RANGE_ATTACK_BAR>=1 and DW_RANGE_ATTACK_BAR<=10) then
				DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].rangeattackbar=DW_RANGE_ATTACK_BAR;
				ChatFrame1:AddMessage("DistanceWarning 当可攻击目标距离大于8时自动切换到动作栏"..DW_RANGE_ATTACK_BAR,1,1,0); 
				ChatFrame1:AddMessage("由于暴雪将用于切换动作栏的函数ChangeActionBarPage()设置为在战斗状态下禁用，导致现在无法在战斗中通过宏或插件切换动作栏，故该功能暂时取消!敬请谅解",1,0,0);
			else
				DW_RANGE_ATTACK_BAR=0;
				DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].rangeattackbar=0;
				ChatFrame1:AddMessage("DistanceWarning 远程攻击动作栏取消",1,1,0);
			end
		elseif(string.sub(string.lower(msg),1,9)=="assistbar" or string.sub(msg,1,15)=="援助动作栏") then
			if(string.sub(string.lower(msg),1,9)=="assistbar") then 
				DW_ASSIST_BAR=tonumber(string.sub(msg,11));
			else
				DW_ASSIST_BAR=tonumber(string.sub(msg,17));
			end
 			if(DW_ASSIST_BAR and DW_ASSIST_BAR>=1 and DW_ASSIST_BAR<=10) then 
				DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].assistbar=DW_ASSIST_BAR;
				ChatFrame1:AddMessage("DistanceWarning 对可援助目标将自动切换到动作栏"..DW_ASSIST_BAR,1,1,0); 
				ChatFrame1:AddMessage("由于暴雪将用于切换动作栏的函数ChangeActionBarPage()设置为在战斗状态下禁用，导致现在无法在战斗中通过宏或插件切换动作栏，故该功能暂时取消!敬请谅解",1,0,0);
			else
				DW_ASSIST_BAR=0;
				DISTANCEWARNING_SAVE[DISTANCEWARNING_PROFILE].assistbar=0;
				ChatFrame1:AddMessage("DistanceWarning 援助动作栏取消",1,1,0);
			end 
		
		elseif(string.lower(msg)=="扫描结果" or string.lower(msg)=="showresult") then
			local ActionName=nil; 
			DWSpelltip:SetOwner(UIParent,"ANCHOR_NONE");
			for yard=5,41 do 
				if(DW_ATTACK_ACTION_SLOT[yard]~=nil) then
					DWSpelltip:SetAction(DW_ATTACK_ACTION_SLOT[yard]);
					ActionName=DWSpelltipTextLeft1:GetText(); 
					ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
 				end
				if(DW_ASSIST_ACTION_SLOT[yard]~=nil) then
					DWSpelltip:SetAction(DW_ASSIST_ACTION_SLOT[yard]);
					ActionName=DWSpelltipTextLeft1:GetText();
					ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0); 
				end
			end
	
		else 
			DistanceWarning_ShowCmd();
		end	
	end
end
function DistanceWarning_ShowCmd()
	ChatFrame1:AddMessage("**************************************************************",1,1,1);
	ChatFrame1:AddMessage("DistanceWarning命令列表(格式:/dw 命令 参数):",1,1,1);
	ChatFrame1:AddMessage("lock 锁定进度条",1,1,1);
	ChatFrame1:AddMessage("unlock 解除锁定",1,1,1);
	ChatFrame1:AddMessage("scale 缩放(参数范围:0.5~3)",1,1,1);
	ChatFrame1:AddMessage("detector_off 关闭动作栏/天赋探测",1,1,1);
	ChatFrame1:AddMessage("detector_on  打开动作栏/天赋探测",1,1,1);
	ChatFrame1:AddMessage("usedefault 使用默认配置",1,1,1);
	ChatFrame1:AddMessage("meleebar 设置近身攻击动作栏",1,1,1);
	ChatFrame1:AddMessage("rangebar 设置远程攻击动作栏",1,1,1);
	ChatFrame1:AddMessage("assistbar 设置援助动作栏",1,1,1);
	ChatFrame1:AddMessage("**************************************************************",1,1,1);
end
if (GetLocale()=="znCN") then return end;
function DistanceWarning_OnEvent(event,arg1)
	if(event=="PLAYER_ENTERING_WORLD") then
		if(DW_PLAYER_CLASS==nil) then
			DW_PLAYER_CLASS=UnitClass("player"); 
			ChatFrame1:AddMessage("职业:"..DW_PLAYER_CLASS,1,1,0);
		end
		if(DW_PLAYER_LEVEL==nil) then
			DW_PLAYER_LEVEL=UnitLevel("player");
			ChatFrame1:AddMessage("等级:"..DW_PLAYER_LEVEL,1,1,0);
		end
	end
		
	if(event=="PLAYER_TARGET_CHANGED") then
		if(UnitName("target")) then
			local melee_mod1,melee_mod2,range_mod1,range_mod2;
			if(UnitIsPlayer("target")) then
				if(UnitRace("target")=="Tauren") then
					melee_mod1=2.4;
					range_mod1=3.4;
 				else
					melee_mod1=0;
					range_mod1=1;
				end
				if(UnitRace("player")=="Tauren") then
					melee_mod2=2.4;
					range_mod2=3.4;
				else
					melee_mod2=0;
					range_mod2=1;
				end
			else
				melee_mod1=0;
				range_mod1=0;
				melee_mod2=0;
				range_mod2=0;
			end
			DW_MELEE_MODIFYER=melee_mod1+melee_mod2;
			DW_RANGE_MODIFYER=range_mod1+range_mod2;
			DistanceWarningBar:Show();
		else
			DistanceWarningBar:Hide();
		end
		DW_MAX_DISTANCE=nil;
		DW_MIN_DISTANCE=nil;
	end

	if(event=="CHARACTER_POINTS_CHANGED" and DW_DETECT==1) then
		if(DW_PLAYER_CLASS=="Hunter") then
			local rank0=DW_TOWNWATCH_RANK;
			local _,texture,_,_,rank,_,_,_=GetTalentInfo(2,7);
			
			if(not(texture) or rank==nil) then
				DW_TOWNWATCH_RANK=0;
			else
				DW_TOWNWATCH_RANK=rank;
			end
			if(DW_TOWNWATCH_RANK~=rank0) then
				ChatFrame1:AddMessage("天赋配置改变:",1,0,0); 
				ChatFrame1:AddMessage("鹰眼等级:"..DW_TOWNWATCH_RANK,1,1,0);
				if(DW_ATTACK_ACTION_SLOT[15+rank0*2]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[15+DW_TOWNWATCH_RANK*2]==nil) then
						DW_ATTACK_NEEDSCAN[15+DW_TOWNWATCH_RANK*2]=true;
					end
					DW_ATTACK_ACTION_SLOT[15+rank0*2]=nil;
					DW_ATTACK_NEEDSCAN[15+rank0*2]=true;
					DW_NEEDSCAN=true;
				end
				if(DW_ATTACK_ACTION_SLOT[35+rank0*2]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[35+DW_TOWNWATCH_RANK*2]==nil) then
						DW_ATTACK_NEEDSCAN[35+DW_TOWNWATCH_RANK*2]=true;
					end
					DW_ATTACK_ACTION_SLOT[35+rank0*2]=nil;
					DW_ATTACK_NEEDSCAN[35+rank0*2]=true;
					DW_NEEDSCAN=true;
				end
			end
		elseif(DW_PLAYER_CLASS=="Rogue") then
			local rank0=DW_THROWING_RANK;
			local _,texture,_,_,rank,_,_,_=GetTalentInfo(2,17);
			if(not(texture) or rank==nil) then
				DW_THROWING_RANK=0;
			else
				DW_THROWING_RANK=rank;
			end
			if(DW_THROWING_RANK~=rank0) then
				ChatFrame1:AddMessage("天赋配置改变:",1,0,0); 
				ChatFrame1:AddMessage("Throw武器专精等级:"..DW_THROWING_RANK,1,1,0);
				if(DW_ATTACK_ACTION_SLOT[30+rank0*3]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[30+DW_THROWING_RANK*3]==nil) then
						DW_ATTACK_NEEDSCAN[30+DW_THROWING_RANK*3]=true;
					end
					DW_ATTACK_ACTION_SLOT[30+rank0*3]=nil;
					DW_ATTACK_NEEDSCAN[30+rank0*3]=true;
					DW_NEEDSCAN=true;
				end
			end 
		elseif(DW_PLAYER_CLASS=="Mage") then
			local rank0_1=DW_FRAMETHROWING_RANK;
			local rank0_2=DW_ARCTICREACH_RANK;
			local _,texture1,_,_,rank1,_,_,_=GetTalentInfo(2,4);
			local _,texture2,_,_,rank2,_,_,_=GetTalentInfo(3,11);
			if(not(texture1) or rank1==nil) then
				DW_FRAMETHROWING_RANK=0;
			else
				DW_FRAMETHROWING_RANK=rank1;
			end
			if(not(texture2) or rank2==nil) then
				DW_ARCTICREACH_RANK=0;
			else
				DW_ARCTICREACH_RANK=rank2;
			end
			if(DW_FRAMETHROWING_RANK~=rank0_1) then
				ChatFrame1:AddMessage("天赋配置改变:",1,1,0); 
				ChatFrame1:AddMessage("火焰Throw等级:"..DW_FRAMETHROWING_RANK,1,1,0);
				if(DW_ATTACK_ACTION_SLOT[20+rank0_1*3]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[20+DW_FRAMETHROWING_RANK*3]==nil) then
						DW_ATTACK_NEEDSCAN[20+DW_FRAMETHROWING_RANK*3]=true;
					end
					DW_ATTACK_ACTION_SLOT[20+rank0_1*3]=nil;
					DW_ATTACK_NEEDSCAN[20+rank0_1*3]=true;
					DW_NEEDSCAN=true;
				end
				if(DW_ATTACK_ACTION_SLOT[30+rank0_1*3]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[30+DW_FRAMETHROWING_RANK*3]==nil) then
						DW_ATTACK_NEEDSCAN[30+DW_FRAMETHROWING_RANK*3]=true;
					end
					DW_ATTACK_ACTION_SLOT[30+rank0_1*3]=nil;
					DW_ATTACK_NEEDSCAN[30+rank0_1*3]=true;
					DW_NEEDSCAN=true;
				end
				if(DW_ATTACK_ACTION_SLOT[35+rank0_1*3]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[35+DW_FRAMETHROWING_RANK*3]==nil) then
						DW_ATTACK_NEEDSCAN[35+DW_FRAMETHROWING_RANK*3]=true;
					end
					DW_ATTACK_ACTION_SLOT[35+rank0_1*3]=nil;
					DW_ATTACK_NEEDSCAN[35+rank0_1*3]=true;
					DW_NEEDSCAN=true;
				end
			end
			if(DW_ARCTICREACH_RANK~=rank0_2) then
				ChatFrame1:AddMessage("天赋配置改变:",1,1,0); 
				ChatFrame1:AddMessage("极寒延伸等级:"..DW_ARCTICREACH_RANK,1,1,0);
				if(DW_ATTACK_ACTION_SLOT[30*(1+rank0_2*0.1)]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[30*(1+DW_ARCTICREACH_RANK*0.1)]==nil) then
						DW_ATTACK_NEEDSCAN[30*(1+DW_ARCTICREACH_RANK*0.1)]=true;
					end
					DW_ATTACK_ACTION_SLOT[30*(1+rank0_2*0.1)]=nil;
					DW_ATTACK_NEEDSCAN[30*(1+rank0_2*0.1)]=true;
					DW_NEEDSCAN=true;
				end
			end
		elseif(DW_PLAYER_CLASS=="Druid") then
			local rank0=DW_NATUREREACH_RANK;
			local _,texture,_,_,rank,_,_,_=GetTalentInfo(1,10); 
			if(not(texture) or rank==nil) then
				DW_NATUREREACH_RANK=0;
			else 
				DW_NATUREREACH_RANK=rank;
			end 
			if(DW_NATUREREACH_RANK~=rank0) then
				ChatFrame1:AddMessage("天赋配置改变:",1,1,0);
				ChatFrame1:AddMessage("自然延伸等级:"..DW_NATUREREACH_RANK,1,1,0);
				if(DW_ATTACK_ACTION_SLOT[30*(1+rank0*0.1)]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[30*(1+DW_NATUREREACH_RANK *0.1)]==nil) then
						DW_ATTACK_NEEDSCAN[30*(1+DW_NATUREREACH_RANK *0.1)]=true;
					end
					DW_ATTACK_ACTION_SLOT[30*(1+rank0*0.1)]=nil;
					DW_ATTACK_NEEDSCAN[30*(1+rank0*0.1)]=true;
					DW_NEEDSCAN=true; 
				end
			end
		elseif(DW_PLAYER_CLASS=="Warlock") then
			local rank0_1=DW_GRIMREACH_RANK;
			local rank0_2=DW_DESTRUCTIVEREACH_RANK;
			local _,texture1,_,_,rank1,_,_,_=GetTalentInfo(1,10);
			local _,texture2,_,_,rank2,_,_,_=GetTalentInfo(3,10);
			if(not(texture1) or rank1==nil) then
				DW_GRIMREACH_RANK=0;
			else
				DW_GRIMREACH_RANK=rank1;
			end
			if(not(texture2) or rank2==nil) then
				DW_DESTRUCTIVEREACH_RANK=0; 
			else
				DW_DESTRUCTIVEREACH_RANK=rank2;
			end
			if(DW_GRIMREACH_RANK~=rank0_1) then
				ChatFrame1:AddMessage("天赋配置改变:",1,1,0);
				ChatFrame1:AddMessage("无情延伸等级:"..DW_GRIMREACH_RANK,1,1,0);
				if(DW_ATTACK_ACTION_SLOT[20*(1+rank0_1*0.1)]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[20*(1+DW_GRIMREACH_RANK*0.1)]==nil) then
						DW_ATTACK_NEEDSCAN[20*(1+DW_GRIMREACH_RANK*0.1)]=true;
					end 
					DW_ATTACK_ACTION_SLOT[20*(1+rank0_1*0.1)]=nil;
					DW_ATTACK_NEEDSCAN[20*(1+rank0_1*0.1)]=true;
					DW_NEEDSCAN=true;
				end
				if(DW_ATTACK_ACTION_SLOT[30*(1+rank0_1*0.1)]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[30*(1+DW_GRIMREACH_RANK*0.1)]==nil) then
						DW_ATTACK_NEEDSCAN[30*(1+DW_GRIMREACH_RANK*0.1)]=true;
					end
					DW_ATTACK_ACTION_SLOT[30*(1+rank0_1*0.1)]=nil;
					DW_ATTACK_NEEDSCAN[30*(1+rank0_1*0.1)]=true;
					DW_NEEDSCAN=true;
				end 
			end
			if(DW_DESTRUCTIVEREACH_RANK~=rank0_2) then
				ChatFrame1:AddMessage("天赋配置改变:",1,1,0);
				ChatFrame1:Addmessage("毁灭延伸等级:"..DW_DESTRUCTIVEREACH_RANK,1,1,0);
				if(DW_ATTACK_ACTION_SLOT[20*(1+rank0_2*0.1)]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[20*(1+DW_DESTRUCTIVEREACH_RANK*0.1)]==nil) then
						DW_ATTACK_NEEDSCAN[20*(1+DW_DESTRUCTIVEREACH_RANK*0.1)]=true;
					end
					DW_ATTACK_ACTION_SLOT[20*(1+rank0_2*0.1)]=nil;
					DW_ATTACK_NEEDSCAN[20*(1+rank0_2*0.1)]=true;
					DW_NEEDSCAN=true;
				end
				if(DW_ATTACK_ACTION_SLOT[30*(1+rank0_2*0.1)]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[30*(1+DW_DESTRUCTIVEREACH_RANK*0.1)]==nil) then
						DW_ATTACK_NEEDSCAN[30*(1+DW_DESTRUCTIVEREACH_RANK*0.1)]=true;
					end
					DW_ATTACK_ACTION_SLOT[30*(1+rank0_2*0.1)]=nil;
					DW_ATTACK_NEEDSCAN[30*(1+rank0_2*0.1)]=true;
					DW_NEEDSCAN=true;
				end 
			end
		elseif(DW_PLAYER_CLASS=="Priest") then
			local rank0_1=DW_HOLYREACH_RANK;
			local rank0_2=DW_SHADOWREACH_RANK;
			local _,texture1,_,_,rank1,_,_,_=GetTalentInfo(2,9);
			local _,texture2,_,_,rank2,_,_,_=GetTalentInfo(3,10); 
			if(not(texture1) or rank1==nil) then
				DW_HOLYREACH_RANK=0;
			else
				DW_HOLYREACH_RANK=rank1;
			end 
			if(not(texture2) or rank2==nil) then
				DW_SHADOWREACH_RANK=0;
			else
				DW_SHADOWREACH_RANK=rank2;
			end 
			if(DW_HOLYREACH_RANK~=rank0_1) then
				ChatFrame1:AddMessage("天赋配置改变:",1,1,0);
				ChatFrame1:AddMessage("神圣延伸等级:"..DW_HOLYREACH_RANK,1,1,0); 
				if(DW_ATTACK_ACTION_SLOT[30*(1+rank0_1*0.1)]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[30*(1+DW_HOLYREACH_RANK*0.1)]==nil) then
						DW_ATTACK_NEEDSCAN[30*(1+DW_HOLYREACH_RANK*0.1)]=true;
					end 
					DW_ATTACK_ACTION_SLOT[30*(1+rank0_1*0.1)]=nil;
					DW_ATTACK_NEEDSCAN[30*(1+rank0_1*0.1)]=true;
					DW_NEEDSCAN=true;
				end
			end
			if(DW_SHADOWREACH_RANK~=rank0_2) then
				local shadowrange0;
				ChatFrame1:AddMessage("天赋配置改变:",1,1,0);
				ChatFrame1:AddMessage("暗影延伸等级:"..DW_SHADOWREACH_RANK,1,1,0);
				if(DW_SHADOWREACH_RANK==1) then
					DW_SHADOW_INCREASE_RANGE=0.06;
				elseif(DW_SHADOWREACH_RANK==2) then
					DW_SHADOW_INCREASE_RANGE=0.13;
				elseif(DW_SHADOWREACH_RANK==3) then
					DW_SHADOW_INCREASE_RANGE=0.2;
				else
					DW_SHADOW_INCREASE_RANGE=0;
				end
				if(rank0_2==1) then
					shadowrange0=0.06;
				elseif(rank0_2==2) then
					shadowrange0=0.13;
				elseif(rank0_2==3) then
					shadowrange0=0.2; 
				else
					shadowrange0=0;
				end
				if(DW_ATTACK_ACTION_SLOT[20*(1+shadowrange0)]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[20*(1+DW_SHADOW_INCREASE_RANGE)]==nil) then
						DW_ATTACK_NEEDSCAN[20*(1+DW_SHADOW_INCREASE_RANGE)]=true;
					end
					DW_ATTACK_ACTION_SLOT[20*(1+shadowrange0)]=nil;
					DW_ATTACK_NEEDSCAN[20*(1+shadowrange0)]=true;
					DW_NEEDSCAN=true;
				end 
				if(DW_ATTACK_ACTION_SLOT[30*(1+shadowrange0)]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[30*(1+DW_SHADOW_INCREASE_RANGE)]==nil) then
						DW_ATTACK_NEEDSCAN[30*(1+DW_SHADOW_INCREASE_RANGE)]=true;
					end
					DW_ATTACK_ACTION_SLOT[30*(1+shadowrange0)]=nil;
					DW_ATTACK_NEEDSCAN[30*(1+shadowrange0)]=true;
					DW_NEEDSCAN=true; 
				end 
			end
		elseif(DW_PLAYER_CLASS=="Shaman") then
			local rank0=DW_STORMREACH_RANK;
			local _,texture,_,_,rank,_,_,_=GetTalentInfo(1,12); 
			if(not(texture) or rank==nil) then 
				DW_STORMREACH_RANK=0;
			else
				DW_STORMREACH_RANK=rank;
			end 
			if(DW_STORMREACH_RANK~=rank0) then
				ChatFrame1:AddMessage("天赋配置改变:",1,1,0);
				ChatFrame1:AddMessage("风暴来临等级:"..DW_STORMREACH_RANK,1,1,0); 
				if(DW_ATTACK_ACTION_SLOT[30+rank0*3]~=nil) then
					if(DW_ATTACK_ACTION_SLOT[30+DW_STORMREACH_RANK*3]==nil) then
						DW_ATTACK_NEEDSCAN[30+DW_STORMREACH_RANK*3]=true;
					end
					DW_ATTACK_ACTION_SLOT[30+rank0*3]=nil;
					DW_ATTACK_NEEDSCAN[30+rank0*3]=true;
					DW_NEEDSCAN=true;
				end
			end
		end
	end
	
	if(event=="ACTIONBAR_SLOT_CHANGED" and DW_DETECT==1) then
		if(DW_PLAYER_CLASS) then
			for i=5,41 do
				if(arg1==DW_ATTACK_ACTION_SLOT[i]) then
					DW_ATTACK_ACTION_SLOT[i]=nil;
					DW_ATTACK_NEEDSCAN[i]=true;
				elseif(arg1==DW_ASSIST_ACTION_SLOT[i]) then
					DW_ASSIST_ACTION_SLOT[i]=nil;
					DW_ASSIST_NEEDSCAN[i]=true;
				end
			end
			DistanceWarning_SpellDetector(arg1);
			DW_NEEDSCAN=DistanceWarning_CheckScanNeed();
		end
	end
end
	
function DistanceWarning_OnUpdate()
	--装载配置变量
	if(DW_CFG_LOADED==false) then
		DISTANCEWARNING_PROFILE=UnitName("player").." 在 "..GetCVar("RealmName");
		if(UnitName("player") and GetCVar("RealmName")) then
			DistanceWarning_LoadCfg();
			DW_CFG_LOADED=true;
		end
	end

	--等天赋树装载完毕以初始化需要扫描的技能
	if(not(DW_TALENTTAB_LOADED)) then
		if(DW_PLAYER_CLASS=="Hunter") then
			local _,texture,_,_,rank,_,_,_=GetTalentInfo(2,7);
			if(DW_PLAYER_LEVEL<10) then
				DW_TOWNWATCH_RANK=0;
				DW_TALENTTAB_LOADED=true;
				ChatFrame1:AddMessage("d",1,1,0);
			elseif(texture) then
				DW_TOWNWATCH_RANK=rank;
				DW_TALENTTAB_LOADED=true;
			end
			if(DW_TALENTTAB_LOADED) then
				ChatFrame1:AddMessage("鹰眼等级:"..DW_TOWNWATCH_RANK,1,1,0);
				DW_ATTACK_NEEDSCAN[5]=true;
				DW_ATTACK_NEEDSCAN[8]=true;
				DW_ATTACK_NEEDSCAN[15+DW_TOWNWATCH_RANK*2]=true;
				DW_ATTACK_NEEDSCAN[30]=true;
				DW_ATTACK_NEEDSCAN[35+DW_TOWNWATCH_RANK*2]=true;
				DW_ASSIST_NEEDSCAN[15]=true;
				DW_NEEDSCAN=true;
			end
		elseif(DW_PLAYER_CLASS=="Warrior") then
			DW_TALENTTAB_LOADED=true;
			DW_ATTACK_NEEDSCAN[5]=true;
			DW_ATTACK_NEEDSCAN[8]=true;
			DW_ATTACK_NEEDSCAN[10]=true;
			DW_ATTACK_NEEDSCAN[25]=true;
			DW_ATTACK_NEEDSCAN[30]=true;
			DW_ASSIST_NEEDSCAN[15]=true;
			DW_NEEDSCAN=true;
		elseif(DW_PLAYER_CLASS=="Rogue") then
			DW_TALENTTAB_LOADED=true;	 	
			DW_ATTACK_NEEDSCAN[5]=true;
			DW_ATTACK_NEEDSCAN[8]=true;
			DW_ATTACK_NEEDSCAN[10]=true;
			DW_ATTACK_NEEDSCAN[30]=true;
			DW_ASSIST_NEEDSCAN[15]=true;
			DW_NEEDSCAN=true;
		elseif(DW_PLAYER_CLASS=="Mage") then
			local _,texture1,_,_,rank1,_,_,_=GetTalentInfo(2,4);
			local _,texture2,_,_,rank2,_,_,_=GetTalentInfo(3,11);
			if(DW_PLAYER_LEVEL<10) then
				DW_FRAMETHROWING_RANK=0;
				DW_ARCTICREACH_RANK=0;
				DW_TALENTTAB_LOADED=true;
			elseif(texture1 and texture2) then
				DW_FRAMETHROWING_RANK=rank1;
				DW_ARCTICREACH_RANK=rank2;
				DW_TALENTTAB_LOADED=true;
			end
			if(DW_TALENTTAB_LOADED) then
				ChatFrame1:AddMessage("火焰Throw等级:"..DW_FRAMETHROWING_RANK,1,1,0); 
				ChatFrame1:AddMessage("极寒延伸等级:"..DW_ARCTICREACH_RANK,1,1,0);
				DW_ATTACK_NEEDSCAN[20+DW_FRAMETHROWING_RANK*3]=true;
				DW_ATTACK_NEEDSCAN[30+DW_FRAMETHROWING_RANK*3]=true;
				DW_ATTACK_NEEDSCAN[35+DW_FRAMETHROWING_RANK*3]=true;
				DW_ATTACK_NEEDSCAN[30*(1+DW_ARCTICREACH_RANK*0.1)]=true;
				DW_ATTACK_NEEDSCAN[30]=true;
				DW_ATTACK_NEEDSCAN[40]=true;
				DW_ASSIST_NEEDSCAN[30]=true;
				DW_ASSIST_NEEDSCAN[15]=true;
				DW_NEEDSCAN=true;
			end
		elseif(DW_PLAYER_CLASS=="Shaman") then
			local _,texture,_,_,rank,_,_,_=GetTalentInfo(1,12);
			if(DW_PLAYER_LEVEL<10) then
				DW_TALENTTAB_LOADED=true;
				DW_STORMREACH_RANK=0;
			elseif(texture) then 
				DW_TALENTTAB_LOADED=true;
				DW_STORMREACH_RANK=rank;
			end
			if(DW_TALENTTAB_LOADED) then
				ChatFrame1:AddMessage("风暴来临等级:"..DW_STORMREACH_RANK,1,1,0);
				DW_ATTACK_NEEDSCAN[30+DW_STORMREACH_RANK*3]=true;
				DW_ATTACK_NEEDSCAN[20]=true;
				DW_ATTACK_NEEDSCAN[30]=true;
				DW_ASSIST_NEEDSCAN[40]=true;
				DW_ASSIST_NEEDSCAN[30]=true;
				DW_ASSIST_NEEDSCAN[15]=true;
				DW_NEEDSCAN=true;
			end
		elseif(DW_PLAYER_CLASS=="Druid") then
			local _,texture,_,_,rank,_,_,_=GetTalentInfo(1,10); 
			if(DW_PLAYER_LEVEL<10) then
				DW_NATUREREACH_RANK=0;
				DW_TALENTTAB_LOADED=true;
			elseif(texture) then
				DW_NATUREREACH_RANK=rank; 
				DW_TALENTTAB_LOADED=true;
			end 
			if(DW_TALENTTAB_LOADED) then
				ChatFrame1:AddMessage("自然延伸等级:"..DW_NATUREREACH_RANK,1,1,0);
				DW_ATTACK_NEEDSCAN[5]=true;
				DW_ATTACK_NEEDSCAN[8]=true;
				DW_ATTACK_NEEDSCAN[25]=true;
				DW_ATTACK_NEEDSCAN[30]=true;
				DW_ATTACK_NEEDSCAN[30*(1+DW_NATUREREACH_RANK*0.1)]=true;
				DW_ASSIST_NEEDSCAN[15]=true;
				DW_ASSIST_NEEDSCAN[30]=true;
				DW_ASSIST_NEEDSCAN[40]=true;
				DW_NEEDSCAN=true;
			end 
		elseif(DW_PLAYER_CLASS=="Paladin") then
			DW_TALENTTAB_LOADED=true;
			DW_ATTACK_NEEDSCAN[10]=true;
			DW_ATTACK_NEEDSCAN[20]=true;
			DW_ATTACK_NEEDSCAN[30]=true;
			DW_ASSIST_NEEDSCAN[20]=true;
			DW_ASSIST_NEEDSCAN[15]=true;
			DW_ASSIST_NEEDSCAN[30]=true;
			DW_ASSIST_NEEDSCAN[40]=ture; 
			DW_NEEDSCAN=true;
		elseif(DW_PLAYER_CLASS=="Warlock") then
			local _,texture1,_,_,rank1,_,_,_=GetTalentInfo(1,10);
			local _,texture2,_,_,rank2,_,_,_=GetTalentInfo(3,10); 
			if(DW_PLAYER_LEVEL<10) then
				DW_TALENTTAB_LOADED=true;
				DW_GRIMREACH_RANK=0;
				DW_DESTRUCTIVEREACH_RANK=0;
			elseif(texture1 and texture2) then
				DW_TALENTTAB_LOADED=true;
				DW_GRIMREACH_RANK=rank1;
				DW_DESTRUCTIVEREACH_RANK=rank2;
			end
			if(DW_TALENTTAB_LOADED) then
				ChatFrame1:AddMessage("无情延伸等级:"..DW_GRIMREACH_RANK,1,1,0); 
				ChatFrame1:AddMessage("毁灭延伸等级:"..DW_DESTRUCTIVEREACH_RANK,1,1,0);
				DW_ATTACK_NEEDSCAN[20*(1+DW_GRIMREACH_RANK*0.1)]=true;
				DW_ATTACK_NEEDSCAN[30*(1+DW_GRIMREACH_RANK*0.1)]=true;
				DW_ATTACK_NEEDSCAN[20*(1+DW_DESTRUCTIVEREACH_RANK*0.1)]=true;
				DW_ATTACK_NEEDSCAN[30*(1+DW_DESTRUCTIVEREACH_RANK*0.1)]=true;
				DW_ATTACK_NEEDSCAN[30]=true;
				DW_ASSIST_NEEDSCAN[30]=true;
				DW_ASSIST_NEEDSCAN[15]=true;
				DW_NEEDSCAN=true;
			end	
		elseif(DW_PLAYER_CLASS=="Priest") then
			local _,texture1,_,_,rank1,_,_,_=GetTalentInfo(2,9); 
			local _,texture2,_,_,rank2,_,_,_=GetTalentInfo(3,10);
			if(DW_PLAYER_LEVEL<10) then
				DW_TALENTTAB_LOADED=true;
				DW_HOLYREACH_RANK=0;
				DW_SHADOWREACH_RANK=0;
				DW_SHADOW_INCREASE_RANGE=0;
			elseif(texture1 and texture2) then
				DW_TALENTTAB_LOADED=true;
				DW_HOLYREACH_RANK=rank1;
				DW_SHADOWREACH_RANK=rank2;
				if(DW_SHADOWREACH_RANK==1) then
					DW_SHADOW_INCREASE_RANGE=0.06;
				elseif(DW_SHADOWREACH_RANK==2) then
					DW_SHADOW_INCREASE_RANGE=0.13;
				elseif(DW_SHADOWREACH_RANK==3) then
					DW_SHADOW_INCREASE_RANGE=0.2;
				else
					DW_SHADOW_INCREASE_RANGE=0;
				end
			end
			if(DW_TALENTTAB_LOADED) then
				ChatFrame1:AddMessage("神圣延伸等级:"..DW_HOLYREACH_RANK,1,1,0);
				ChatFrame1:AddMessage("暗影延伸等级:"..DW_SHADOWREACH_RANK,1,1,0);
				DW_ATTACK_NEEDSCAN[30*(1+DW_HOLYREACH_RANK*0.1)]=true;
				DW_ATTACK_NEEDSCAN[20*(1+DW_SHADOW_INCREASE_RANGE)]=true;
				DW_ATTACK_NEEDSCAN[30*(1+DW_SHADOW_INCREASE_RANGE)]=true;
				DW_ATTACK_NEEDSCAN[20]=true;
				DW_ATTACK_NEEDSCAN[30]=true;
				DW_ASSIST_NEEDSCAN[15]=true;
				DW_ASSIST_NEEDSCAN[30]=true;
				DW_ASSIST_NEEDSCAN[40]=true;
				DW_NEEDSCAN=true;
			end
		end
	end

	if(DW_NEEDSCAN) then
		local slotnum=1;
		while(slotnum<=120 and DistanceWarning_CheckScanNeed()) do
			DistanceWarning_SpellDetector(slotnum);
			slotnum=slotnum+1;
		end
		for j=5,41 do
			if(DW_ATTACK_NEEDSCAN[j]) then
				--ChatFrame1:AddMessage("未扫描到"..j.."码攻击技能--无法对敌对目标准确提示"..j.."码距离",1,0,0);
				DW_ATTACK_NEEDSCAN[j]=false;
			end
			if(DW_ASSIST_NEEDSCAN[j]) then
				--ChatFrame1:AddMessage("未扫描到"..j.."码援助技能--无法对友方目标准确提示"..j.."码距离",1,0,0);
				DW_ASSIST_NEEDSCAN[j]=false;
			end
		end
		DW_NEEDSCAN=false;
	end
	function DistanceWarning_SetStatusBar(maxdis,mindis)
		local text;
		local r, g, b
		if(DW_PLAYER_CLASS=="Hunter") then
			if(maxdis<=5) then
				r, g, b =1,1,0;
			elseif(maxdis<=8) then
				r, g, b =1,0,0;
			elseif(maxdis<=15+DW_TOWNWATCH_RANK*2) then
				r, g, b =1,1,0;
			elseif(maxdis<=30) then
				r, g, b =1,0.5,0;
			elseif(maxdis<=35+DW_TOWNWATCH_RANK*2) then
				r, g, b =0,1,0;
			else
				r, g, b = 0, 0.9, 0.9
			end
		elseif(DW_PLAYER_CLASS=="Warrior") then
			if(maxdis<=5) then
				r, g, b =0,1,0;
			elseif(maxdis<=8) then
				r, g, b =1,0,0;
			elseif(maxdis<=25) then
				r, g, b =1,1,0;
			elseif(maxdis<=41) then
				r, g, b =1,0,0;
			else
				r, g, b =1,0,0;
			end
		elseif(DW_PLAYER_CLASS=="Rogue") then
			if(maxdis<=8) then
				r, g, b =0,1,0;
			elseif(maxdis<=10) then
				r, g, b =1,1,0; 
			elseif(maxdis<=41) then
				r, g, b =1,0,0;
			else
				r, g, b =1,0,0;
			end
		elseif(DW_PLAYER_CLASS=="Mage") then
			if(maxdis<=6) then
				r, g, b =1,0,0;
			elseif(maxdis<=10) then
				r, g, b =1,0.5,0;
			elseif(maxdis<=26) then
				r, g, b =1,1,0;
			elseif(maxdis<=30) then
				r, g, b =0,1,0;
			elseif(maxdis<=41) then
				r, g, b =1,1,0;
			else
				r, g, b =0, 0.9, 0.9;
			end
		elseif(DW_PLAYER_CLASS=="Shaman") then
			if(maxdis<=5.55) then
				r, g, b =1,1,0;
			elseif(maxdis<=20) then
				r, g, b =0,1,0;
			elseif(maxdis<=30) then
				r, g, b =1,1,0;
			elseif(maxdis<=41) then
				r, g, b =1,1,0;
			else
				r, g, b =1,0,0;
			end
		elseif(DW_PLAYER_CLASS=="Druid") then
			if(maxdis<=10) then
				r, g, b =1,0,0;
			elseif(maxdis<=30) then
				r, g, b =1,1,0;
			elseif(maxdis<=41) then
				r, g, b =0,1,0;
			else
				r, g, b =0, 0.9, 0.9;
			end
		elseif(DW_PLAYER_CLASS=="Paladin") then
			if(maxdis<=10) then
				r, g, b =0,1,0;
			elseif(maxdis<=30) then
				r, g, b =1,1,0;
			elseif(maxdis<=41) then
				r, g, b =1,0,0;
			else
				r, g, b =1,0,0;
			end
		elseif(DW_PLAYER_CLASS=="Warlock") then
			if(maxdis<=10) then
				r, g, b =1,0,0;
			elseif(maxdis<=24) then
				r, g, b =0,1,0;
			elseif(maxdis<=41) then
				r, g, b =1,1,0;
			else
				r, g, b =0, 0.9, 0.9;
			end
		elseif(DW_PLAYER_CLASS=="Priest") then
			if(maxdis<=10) then
				r, g, b =1,0,0;
			elseif(maxdis<=24) then
				r, g, b =0,1,0;
			elseif(maxdis<=41) then
				r, g, b =1,1,0;
			else
				r, g, b =0, 0.9, 0.9;
			end
		end
		if(maxdis<=41) then
			if(mindis<maxdis) then
				text=string.format("%d", mindis).." - "..string.format("%d", maxdis);
			else
				text="< "..string.format("%d", maxdis);
			end
		else
			text="> "..string.format("%d", mindis);
		end

		DistanceWarningText:SetText(text);
		DistanceWarningText:SetTextColor(r, g, b)
	end
	if(UnitName("target")) then
		local MaxDis,MinDis=DistanceWarning_GetDistance();
		--DistanceWarning_SetCurrentBarPage(MaxDis);
		if(MaxDis~=DW_MAX_DISTANCE) then
			DW_MAX_DISTANCE=MaxDis;
			DistanceWarning_SetStatusBar(MaxDis,MinDis);
		end
		if(MinDis~=DW_MIN_DISTANCE) then
			DW_MIN_DISTANCE=MinDis;
			DistanceWarning_SetStatusBar(MaxDis,MinDis);
		end
	end
end

--返回对可攻击目标的距离
function DistanceWarning_GetDistance()
	local MaxDistance;
	local MinDistance;
	
	--以内定距离进行预判
	if(CheckInteractDistance("target",3)) then
		MaxDistance=10;
		MinDistance=0;
 
		if(MaxDistance-DW_RANGE_MODIFYER<=5)
 then 
			MaxDistance=MaxDistance-DW_MELEE_MODIFYER;
 
		else
			MaxDistance=MaxDistance-DW_RANGE_MODIFYER;
		end
	elseif(CheckInteractDistance("target",2)) then
		MaxDistance=11.11;
		MinDistance=10;
		if(MaxDistance-DW_RANGE_MODIFYER<=5) then
			MaxDistance=MaxDistance-DW_MELEE_MODIFYER;
		else
			MaxDistance=MaxDistance-DW_RANGE_MODIFYER;
		end
		if(MinDistance-DW_RANGE_MODIFYER<=5) then
			MinDistance=MinDistance-DW_MELEE_MODIFYER;
		else
			MinDistance=MinDistance-DW_RANGE_MODIFYER;
		end
	elseif(CheckInteractDistance("target",4)) then
		MaxDistance=30-DW_RANGE_MODIFYER;
		if(11.11-DW_RANGE_MODIFYER<=5) then
			MinDistance=11.11-DW_MELEE_MODIFYER;
		else
			MinDistance=11.11-DW_RANGE_MODIFYER;
		end
	else
		MaxDistance=200;
		MinDistance=30-DW_RANGE_MODIFYER;
		--表示大于30码内定距离
	end
	
	--对可攻击目标进行技能距离判定
	if(UnitCanAttack("player","target")) then
		if(DW_ATTACK_ACTION_SLOT[5]~=nil and IsActionInRange(DW_ATTACK_ACTION_SLOT[5])==1) then
			if(MaxDistance>5) then
				MaxDistance=5;
				MinDistance=0;
			end
		elseif(DW_ATTACK_ACTION_SLOT[8]~=nil and IsActionInRange(DW_ATTACK_ACTION_SLOT[8])==0 
		and MaxDistance<=30) then
			if(MaxDistance>8) then
				MaxDistance=8;
			end
			if(MinDistance<5 and DW_ATTACK_ACTION_SLOT[5]~=nil) then
				MinDistance=5;
			end
		else
			if(MinDistance<5 and DW_ATTACK_ACTION_SLOT[5]~=nil) then
				MinDistance=5;
			end
			if(MinDistance<8 and DW_ATTACK_ACTION_SLOT[9]~=nil) then
				MinDistance=8;
			end
			local i=9;
			while(i<=42 and IsActionInRange(DW_ATTACK_ACTION_SLOT[i])~=1) do 
				if(DW_ATTACK_ACTION_SLOT[i] and MinDistance<i) then
					MinDistance=i;
				end
				i=i+1;
			end
			if(i<=41) then
				if(MaxDistance>i) then
					MaxDistance=i;
				end
			end
		end
	end
	
	--对可援助目标进行技能距离判定
	if(UnitCanAssist("player","target")) then
		local i=15;
		while(i<=42 and IsActionInRange(DW_ASSIST_ACTION_SLOT[i])~=1) do
			if(DW_ASSIST_ACTION_SLOT[i] and MinDistance<i) then
				MinDistance=i;
			end
			i=i+1;
		end
		if(i<=41) then
			if(MaxDistance>i) then
				MaxDistance=i;
			end
		end
	end 
	--返回距离范围
	return MaxDistance,MinDistance
end

--探测动作栏上可用于提示距离的攻击技能
function DistanceWarning_SpellDetector(slot)
	local ico=nil;
	local lab=nil;
	local ActionName=nil;
	local yard;
	DWSpelltip:SetOwner(DWSpelltip,"ANCHOR_NONE");
	DWSpelltip:SetAction(slot);
	ActionName=DWSpelltipTextLeft1:GetText();
	ico=GetActionTexture(slot);
	lab=GetActionText(slot);
	if(DW_PLAYER_CLASS=="Hunter") then
		--如果lab值不为空则说明该动作是宏，不作为距离参考
		if(ico~=nil and lab==nil) then
			if(DW_ATTACK_ACTION_SLOT[5]==nil and (ActionName=="Wing Clip" or ActionName=="翅夹" 
			or ActionName=="Mongoose Bite" or ActionName=="Counterattack")) then
				DW_ATTACK_ACTION_SLOT[5]=slot;
				DW_ATTACK_NEEDSCAN[5]=false;
				yard=5;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[8]==nil and (ActionName=="Viper Sting" or ActionName=="Serpent Sting" 
			or ActionName=="Arcane Shot" or ActionName=="Concussive Shot" or ActionName=="Multi-Shot" 
			or ActionName=="Aimed Shot" or ActionName=="Scorpid Sting" or ActionName=="Auto Shot" 
			or ActionName=="Wyvern Sting" or ActionName=="Tranquilizing Shot")) then
				DW_ATTACK_ACTION_SLOT[8]=slot;
				DW_ATTACK_NEEDSCAN[8]=false;
				yard=8;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[15+DW_TOWNWATCH_RANK*2]==nil and (ActionName=="Scatter Shot")) then
				yard=15+DW_TOWNWATCH_RANK*2;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[35+DW_TOWNWATCH_RANK*2]==nil and (ActionName=="Viper Sting" 
			or ActionName=="Serpent Sting" or ActionName=="Arcane Shot" or ActionName=="Concussive Shot" 
			or ActionName=="Multi-Shot" or ActionName=="Aimed Shot" or ActionName=="Scorpid Sting" 
			or ActionName=="Auto Shot" or ActionName=="Wyvern Sting" or ActionName=="Tranquilizing Shot")) then
				yard=35+DW_TOWNWATCH_RANK*2;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end 
		end
	elseif(DW_PLAYER_CLASS=="Warrior") then
		if(ico~=nil and lab==nil) then
			if(DW_ATTACK_ACTION_SLOT[5]==nil and (ActionName=="Mortal Strike" or ActionName=="Sunder Armor" 
			or ActionName=="Hamstring" or ActionName=="Taunt" or ActionName=="Overpower" 
			or ActionName=="Shield Bash" or ActionName=="Revenge" or ActionName=="Mocking Blow"
			or ActionName=="Disarm" or ActionName=="Execute" or ActionName=="处决" 
			or ActionName=="Slam" or ActionName=="Shield Slam" or ActionName=="Rend" 
			or ActionName=="Pummel" or ActionName=="Bloodthirst" or ActionName=="Concussion Blow")) then
				DW_ATTACK_ACTION_SLOT[5]=slot;
				DW_ATTACK_NEEDSCAN[5]=false;
				yard=5;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[8]==nil and (ActionName=="Shoot Bow" or ActionName=="Shoot Gun" 
			or ActionName=="Shoot Crossbow" or ActionName=="Throw")) then
				DW_ATTACK_ACTION_SLOT[8]=slot;
				DW_ATTACK_NEEDSCAN[8]=false;
				yard=8;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[10]==nil and (ActionName=="Intimidation")) then
				DW_ATTACK_ACTION_SLOT[10]=slot;
				DW_ATTACK_NEEDSCAN[10]=false;
				yard=10;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[25]==nil and (ActionName=="Charge" or ActionName=="Intercept")) then
				DW_ATTACK_ACTION_SLOT[25]=slot;
				DW_ATTACK_NEEDSCAN[25]=false;
				yard=25;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[30]==nil and (ActionName=="Shoot Bow" or Actionname=="Shoot Gun" 
			or ActionName=="Shoot Crossbow")) then
				DW_ATTACK_ACTION_SLOT[30]=slot;
				DW_ATTACK_NEEDSCAN[30]=false;
				yard=30;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
		end
	elseif(DW_PLAYER_CLASS=="Rogue") then
		if(ico~=nil and lab==nil) then
			if(DW_ATTACK_ACTION_SLOT[5]==nil and(ActionName=="Rupture" or ActionName=="Sinister Strike" 
			or ActionName=="险恶攻击" or ActionName=="Backstab" or ActionName=="Kick" 
			or ActionName=="Gouge" or ActionName=="Eviscerate" or ActionName=="Garrote" 
			or ActionName=="绞杀" or ActionName=="Cheap Shot" or ActionName=="卸甲" 
			or ActionName=="Expose Armor" or ActionName=="Feint" or ActionName=="Kidney Shot" 
			or ActionName=="Ambush" or ActionName=="Hemorrhage" or ActionName=="放血")) then
				DW_ATTACK_ACTION_SLOT[5]=slot; 
				DW_ATTACK_NEEDSCAN[5]=false;
				yard=5;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[8]==nil and (ActionName=="Shoot Bow" or ActionName=="Shoot Gun" 
			or ActionName=="Shoot Crossbow" or ActionName=="Throw")) then
				DW_ATTACK_ACTION_SLOT[8]=slot;
				DW_ATTACK_NEEDSCAN[8]=false;
				yard=8;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[10]==nil and (ActionName=="Blind")) then
				DW_ATTACK_ACTION_SLOT[10]=slot;
				DW_ATTACK_NEEDSCAN[10]=false;
				yard=10;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[30]==nil and (ActionName=="Shoot Bow" or Actionname=="Shoot Gun" 
			or ActionName=="Shoot Crossbow" or ActionName=="Throw")) then
				DW_ATTACK_ACTION_SLOT[30]=slot;
				DW_ATTACK_NEEDSCAN[30]=false;
				yard=30;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
		end 
	elseif(DW_PLAYER_CLASS=="Mage") then
		local ActionRank;
		ActionRank=DWSpelltipTextRight1:GetText();
		if(ico~=nil and lab==nil) then
			if(DW_ATTACK_ACTION_SLOT[20+DW_FRAMETHROWING_RANK*3]==nil and ActionName=="Fire Blast") then
				yard=20+DW_FRAMETHROWING_RANK*3;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
  
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end 
			if(DW_ATTACK_ACTION_SLOT[30+DW_FRAMETHROWING_RANK*3]==nil and ActionName=="Scorch") then
				yard=30+DW_FRAMETHROWING_RANK*3;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..ActionRank..DW_MSG2..yard.."码",1,1,0);
			end 
			if(DW_ATTACK_ACTION_SLOT[35+DW_FRAMETHROWING_RANK*3]==nil and (ActionName=="Pyroblast" 
			or ActionName=="火球术")) then
				yard=35+DW_FRAMETHROWING_RANK*3;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..ActionRank..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[30*(1+DW_ARCTICREACH_RANK*0.1)]==nil and ActionName=="Frostbolt") then
				yard=30*(1+DW_ARCTICREACH_RANK*0.1);
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[30]==nil and ActionName=="Counterspell") then
				yard=30;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ATTACK_ACTION_SLOT[40]==nil and ActionName=="Detect Magic") then
				yard=40;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ASSIST_ACTION_SLOT[30]==nil and (ActionName=="Arcane Intellect" 
			or ActionName=="Remove Lesser Curse" or ActionName=="Remove Curse")) then
				yard=30;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0); 
			end
		end
	elseif(DW_PLAYER_CLASS=="Shaman") then
		if(ico~=nil and lab==nil) then
			if(DW_ATTACK_ACTION_SLOT[30+DW_STORMREACH_RANK*3]==nil and (ActionName=="Chain Lightning" 
			or ActionName=="Lightning Bolt")) then
				yard=30+DW_STORMREACH_RANK*3;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ATTACK_ACTION_SLOT[20]==nil and (ActionName=="Earth Shock" or ActionName=="Flame Shock" 
			or ActionName=="Frost Shock")) then
				yard=20;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[30]==nil and ActionName=="Purge") then 
				yard=30;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ASSIST_ACTION_SLOT[30]==nil and (ActionName=="Cure Poison" or ActionName=="Cure Disease" 
			or ActionName=="Water Breathing" or ActionName=="Water Walking")) then
				yard=30;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0);
			end
			if(DW_ASSIST_ACTION_SLOT[40]==nil and (ActionName=="Healing Wave" 
			or ActionName=="Lesser Healing Wave" or ActionName=="Chain Heal")) then
				yard=40;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0);
			end
		end 
	elseif(DW_PLAYER_CLASS=="Druid") then
		if(ico~=nil and lab==nil) then  
			if(DW_ATTACK_ACTION_SLOT[5]==nil and (ActionName=="Maul" or ActionName=="Swipe" 
			or ActionName=="Growl" or ActionName=="Bash" or ActionName=="Rake" or ActionName=="Claw" 
			or ActionName=="Shred" or ActionName=="Ravage" or ActionName=="Pounce" or ActionName=="Rip" 
			or ActionName=="Ferocious Bite" or ActionName=="Cower"))then
				yard=5;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false; 
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[8]==nil and ActionName=="Throw") then
				yard=8;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ATTACK_ACTION_SLOT[25]==nil and ActionName=="野性Charge") then
				yard=25;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[30*(1+DW_NATUREREACH_RANK*0.1)]==nil and (ActionName=="Wrath" 
			or ActionName=="Moonfire" or ActionName=="Starfire" or ActionName=="Entangling Roots" 
			or ActionName=="Faerie Fire")) then
				yard=30*(1+DW_NATUREREACH_RANK*0.1); 
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ASSIST_ACTION_SLOT[30]==nil and (ActionName=="Mark of the Wild" or ActionName=="Thorns" 
			or ActionName=="废毒术" or ActionName=="Abolish Poison" or ActionName=="Remove Curse")) then
				yard=30;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0);
			end
			if(DW_ASSIST_ACTION_SLOT[40]==nil and (ActionName=="Regrowth" or ActionName=="Healing Touch" 
			or ActionName=="Rejuvenation")) then
				yard=40;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0); 
			end
		end
	elseif(DW_PLAYER_CLASS=="Paladin") then
		if(ico~=nil and lab==nil) then
			if(DW_ATTACK_ACTION_SLOT[10]==nil and (ActionName=="Hammer of Justice" or ActionName=="Judgement")) then
				yard=10;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[20]==nil and ActionName=="Holy Shock") then
				yard=20;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[30]==nil and ActionName=="Hammer of Wrath") then
				yard=30;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ASSIST_ACTION_SLOT[20]==nil and ActionName=="Holy Shock") then
				yard=20;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0);
			end
			if(DW_ASSIST_ACTION_SLOT[30]==nil and (ActionName=="Cleanse" or ActionName=="Purify" 
			or ActionName=="Blessing of Might" or ActionName=="Blessing of Wisdom" or ActionName=="Blessing of Sanctuary" 
			or ActionName=="Blessing of Freedom" or ActionName=="Blessing of Light" or ActionName=="Blessing of Kings")) then
				yard=30;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0);
			end
			if(DW_ASSIST_ACTION_SLOT[40]==nil and (ActionName=="Holy Light" or ActionName=="Lay on Hands" 
			or ActionName=="Flash of Light" or ActionName=="Greater Blessing of Might" or ActionName=="Greater Blessing of Wisdom" 
			or ActionName=="Greater Blessing of Sanctuary" or ActionName=="Greater Blessing of Light" 
			or ActionName=="Greater Blessing of Kings")) then
				yard=40;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0);
			end
		end
	elseif(DW_PLAYER_CLASS=="Warlock") then
		if(ico~=nil and lab==nil) then 
			if(DW_ATTACK_ACTION_SLOT[20*(1+DW_GRIMREACH_RANK*0.1)]==nil and (ActionName=="Fear" 
			or ActionName=="Drain Life" or ActionName=="Drain Mana")) then
				yard=20*(1+DW_GRIMREACH_RANK*0.1);
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ATTACK_ACTION_SLOT[30*(1+DW_GRIMREACH_RANK*0.1)]==nil and (ActionName=="Curse of Weakness" 
			or ActionName=="Corruption" or ActionName=="Curse of Agony" or ActionName=="Drain Soul" 
			or ActionName=="Curse of Recklessness" or ActionName=="舌之诅咒" or ActionName=="Siphon Life" 
			or ActionName=="Curse of the Elements" or ActionName=="Death Coil" or ActionName=="阴影诅咒")) then
				yard=30*(1+DW_GRIMREACH_RANK*0.1);
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ATTACK_ACTION_SLOT[20*(1+DW_DESTRUCTIVEREACH_RANK*0.1)]==nil and (ActionName=="暗影燃烧" 
			or ActionName=="燃烧")) then
				yard=20*(1+DW_DESTRUCTIVEREACH_RANK*0.1);
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ATTACK_ACTION_SLOT[30*(1+DW_DESTRUCTIVEREACH_RANK*0.1)]==nil and (ActionName=="Shadow Bolt" 
			or ActionName=="Immolate" or ActionName=="Searing Pain" or ActionName=="燃烧灵魂")) then
				yard=30*(1+DW_DESTRUCTIVEREACH_RANK*0.1); 
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ASSIST_ACTION_SLOT[30]==nil and (ActionName=="Water Breathing" or ActionName=="Detect Lesser Invisibility" 
			or ActionName=="Detect Invisibility" or ActionName=="Detect Greater Invisibility")) then
				yard=30;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false; 
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0); 
			end 
		end
	elseif(DW_PLAYER_CLASS=="Priest") then
		if(ico~=nil and lab==nil) then
			if(DW_ATTACK_ACTION_SLOT[30*(1+DW_HOLYREACH_RANK*0.1)]==nil and (ActionName=="Holy Fire" 
			or ActionName=="Smite")) then
				yard=30*(1+DW_HOLYREACH_RANK*0.1);
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ATTACK_ACTION_SLOT[20*(1+DW_SHADOW_INCREASE_RANGE)]==nil and ActionName=="Mind Flay") then
				yard=20*(1+DW_SHADOW_INCREASE_RANGE);
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ATTACK_ACTION_SLOT[30*(1+DW_SHADOW_INCREASE_RANGE)]==nil and (ActionName=="Shadow Word: Pain" 
			or ActionName=="Mind Blast" or ActionName=="Devouring Plague")) then
				yard=30*(1+DW_SHADOW_INCREASE_RANGE);
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
			end
			if(DW_ATTACK_ACTION_SLOT[20]==nil and ActionName=="Silence") then
				yard=20;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ATTACK_ACTION_SLOT[30]==nil and (ActionName=="Dispel Magic" or ActionName=="Mana Burn" 
			or ActionName=="Vampiric Embrace")) then
				yard=30;
				DW_ATTACK_ACTION_SLOT[yard]=slot;
				DW_ATTACK_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0); 
			end
			if(DW_ASSIST_ACTION_SLOT[30]==nil and (ActionName=="Power Word: Fortitude" or ActionName=="Spirit" 
			or ActionName=="Dispel Magic" or ActionName=="Cure Disease" or ActionName=="Abolish Disease")) then
				yard=30;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false; 
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0); 
			end
			if(DW_ASSIST_ACTION_SLOT[40]==nil and (ActionName=="Heal" or ActionName=="Lesser Heal" 
			or ActionName=="Flash Heal" or ActionName=="Greater Heal" or ActionName=="Renew")) then
				yard=40;
				DW_ASSIST_ACTION_SLOT[yard]=slot;
				DW_ASSIST_NEEDSCAN[yard]=false;
				--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0); 
			end 
		end
	end
	--如果lab值不为空则说明该动作是宏，不作为距离参考
	if(ico~=nil and lab==nil) then
		if(DW_ATTACK_ACTION_SLOT[30]==nil and (ActionName=="Goblin Rocket Helmet" or ActionName=="Gnomish Net-o-Matic Projector" 
		or ActionName=="Gnomish Shrink Ray" or ActionName=="Shoot" or ActionName=="Throw")) then
			yard=30;
			DW_ATTACK_ACTION_SLOT[30]=slot;
			DW_ATTACK_NEEDSCAN[30]=false;
			--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG2..yard.."码",1,1,0);
		end 
		if(DW_ASSIST_ACTION_SLOT[15]==nil and (ActionName=="Linen Bandage" or ActionName=="Heavy Linen Bandage" 
		or ActionName=="Wool Bandage" or ActionName=="Heavy Wool Bandage" or ActionName=="Silk Bandage" 
		or ActionName=="Heavy Silk Bandage" or ActionName=="Mageweave Bandage" or ActionName=="Heavy Mageweave Bandage" 
		or ActionName=="厚魔纹绷带" or ActionName=="Runecloth Bandage" or ActionName=="Heavy Runecloth Bandage")) then
			yard=15;
			DW_ASSIST_ACTION_SLOT[yard]=slot;
			DW_ASSIST_NEEDSCAN[yard]=false;
			--ChatFrame1:AddMessage(DW_MSG1..ActionName..DW_MSG3..yard.."码",1,1,0);
		end
	end
end

--检测是否需要扫描
function DistanceWarning_CheckScanNeed()
	local needscan
	if(DW_PLAYER_CLASS=="Hunter") then
		needscan=(DW_ATTACK_NEEDSCAN[5] or DW_ATTACK_NEEDSCAN[8] 
		or DW_ATTACK_NEEDSCAN[15+DW_TOWNWATCH_RANK*2] or DW_ATTACK_NEEDSCAN[30] 
		or DW_ATTACK_NEEDSCAN[35+DW_TOWNWATCH_RANK*2] or DW_ASSIST_NEEDSCAN[15]);
	elseif(DW_PLAYER_CLASS=="Warrior") then
		needscan=(DW_ATTACK_NEEDSCAN[5] or DW_ATTACK_NEEDSCAN[8] or DW_ATTACK_NEEDSCAN[10] 
		or DW_ATTACK_NEEDSCAN[25] or DW_ATTACK_NEEDSCAN[30] or DW_ASSIST_NEEDSCAN[15]);
	elseif(DW_PLAYER_CLASS=="Rogue") then
		needscan=(DW_ATTACK_NEEDSCAN[5] or DW_ATTACK_NEEDSCAN[8] or DW_ATTACK_NEEDSCAN[10] 
		or DW_ATTACK_NEEDSCAN[30] or DW_ATTACK_NEEDSCAN[30+DW_THROWING_RANK*3] 
		or DW_ASSIST_NEEDSCAN[15]);
	elseif(DW_PLAYER_CLASS=="Mage") then
		needscan=(DW_ATTACK_NEEDSCAN[20+DW_FRAMETHROWING_RANK*3] 
		or DW_ATTACK_NEEDSCAN[30+DW_FRAMETHROWING_RANK*3] 
		or DW_ATTACK_NEEDSCAN[35+DW_FRAMETHROWING_RANK*3] 
		or DW_ATTACK_NEEDSCAN[30*(1+DW_ARCTICREACH_RANK*0.1)] or DW_ATTACK_NEEDSCAN[30] 
		or DW_ATTACK_NEEDSCAN[40] or DW_ASSIST_NEEDSCAN[30] or DW_ASSIST_NEEDSCAN[15]);
	elseif(DW_PLAYER_CLASS=="Shaman") then
		needscan=(DW_ATTACK_NEEDSCAN[20] or DW_ATTACK_NEEDSCAN[30] or DW_ASSIST_NEEDSCAN[40] 
		or DW_ASSIST_NEEDSCAN[30] or DW_ASSIST_NEEDSCAN[15] 
		or DW_ATTACK_NEEDSCAN[30+DW_STORMREACH_RANK*3]);
	elseif(DW_PLAYER_CLASS=="Druid") then
		needscan=(DW_ATTACK_NEEDSCAN[5] or DW_ATTACK_NEEDSCAN[8] or DW_ATTACK_NEEDSCAN[25] 
		or DW_ATTACK_NEEDSCAN[30] or DW_ATTACK_NEEDSCAN[30*(1+DW_NATUREREACH_RANK*0.1)] 
		or DW_ASSIST_NEEDSCAN[15] or DW_ASSIST_NEEDSCAN[30] or DW_ASSIST_NEEDSCAN[40]);
	elseif(DW_PLAYER_CLASS=="Paladin") then
		needscan=(DW_ATTACK_NEEDSCAN[10] or DW_ATTACK_NEEDSCAN[20] or DW_ATTACK_NEEDSCAN[30] 
		or DW_ASSIST_NEEDSCAN[15] or DW_ASSIST_NEEDSCAN[20] or DW_ASSIST_NEEDSCAN[30] 
		or DW_ASSIST_NEEDSCAN[40]);
	elseif(DW_PLAYER_CLASS=="Warlock") then
		needscan=(DW_ATTACK_NEEDSCAN[20*(1+DW_GRIMREACH_RANK*0.1)] 
		or DW_ATTACK_NEEDSCAN[30*(1+DW_GRIMREACH_RANK*0.1)] 
		or DW_ATTACK_NEEDSCAN[20*(1+DW_DESTRUCTIVEREACH_RANK*0.1)] 
		or DW_ATTACK_NEEDSCAN[30*(1+DW_DESTRUCTIVEREACH_RANK*0.1)] or DW_ATTACK_NEEDSCAN[30] 
		or DW_ASSIST_NEEDSCAN[30] or DW_ASSIST_NEEDSCAN[15]);
	elseif(DW_PLAYER_CLASS=="Priest") then
		needscan=(DW_ATTACK_NEEDSCAN[30*(1+DW_HOLYREACH_RANK*0.1)] 
		or DW_ATTACK_NEEDSCAN[20*(1+DW_SHADOW_INCREASE_RANGE)] 
		or DW_ATTACK_NEEDSCAN[30*(1+DW_SHADOW_INCREASE_RANGE)] or DW_ATTACK_NEEDSCAN[30] 
		or DW_ASSIST_NEEDSCAN[15] or DW_ASSIST_NEEDSCAN[30] or DW_ASSIST_NEEDSCAN[40]);
	end
	return needscan;
end

