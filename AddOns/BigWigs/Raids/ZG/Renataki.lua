
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Renataki", "Zul'Gurub")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("zhCN", function() return {
	cmd = "Renataki",

	enrage_trigger = "雷纳塔基获得了狂怒的效果。",
	enragesoon_message = "狂怒马上! 准备!",
	enrage_message = "狂怒!",
	vanishsoon_message = "消失很快!",
	vanish_message = "Boss 消失了!",
	unvanish_message = "Boss 显露了!",
	vanish_bar = "消失",
	return_bar = "回归",

	vanish_cmd = "vanish",
	vanish_name = "消失通告",
	vanish_desc = "显示boss消失通告.",
	
	enraged_cmd = "enraged",
	enraged_name = "通报boss狂怒",
	enraged_desc = "通报boss狂怒.",
} end )



---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20006 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"vanish", "enraged", "bosskill"}

-- locals
local timer = {
	vanishSoon = 28,
	unvanish = 20,
}
local icon = {
	vanish = "Ability_Stealth",
}
local syncName = {
	unvanish = "RenatakiUnvanish"..module.revision,
	vanish = "RenatakiVanish"..module.revision,
	enrage = "RenatakiEnrage"..module.revision,
	enrageSoon = "RenatakiEnrageSoon"..module.revision,
}


------------------------------
--      Initialization      --
------------------------------

--module:RegisterYellEngage(L["start_trigger"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("UNIT_HEALTH")

	self:ThrottleSync(5, syncName.unvanish)
	self:ThrottleSync(5, syncName.vanish)
	self:ThrottleSync(5, syncName.enrage)
	self:ThrottleSync(10, syncName.enrageSoon)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	enrageannounced = nil
	vanished = nil
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.vanish then
		self:Bar(L["vanish_bar"], timer.vanishSoon, icon.vanish)
	end
	self:ScheduleRepeatingEvent("renatakivanishcheck", self.CheckVanish, 1, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers	    --
------------------------------

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["enrage_trigger"] then
		self:Sync(syncName.enrage)
	end
end

function module:UNIT_HEALTH(arg1)
	if UnitName(arg1) == module.translatedName then
		local health = UnitHealth(arg1)
		if health > 25 and health <= 30 and not enrageannounced then
			self:Sync(syncName.enrageSoon)
			enrageannounced = true
		elseif health > 30 and enrageannounced then
			enrageannounced = nil
		end
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.enrageSoon and self.db.profile.enraged then
		self:Message(L["enragesoon_message"], "Urgent")
	elseif sync == syncName.enrage and self.db.profile.enraged then
		self:Message(L["enrage_message"], "Attention")
	elseif sync == syncName.unvanish then
		self:VisiblePhase()
	elseif sync == syncName.vanish then
		self:VanishPhase()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:VisiblePhase()
	vanished = false
	self:CancelScheduledEvent("renatakiunvanishcheck")
	if self.db.profile.vanish then
		self:RemoveBar(L["return_bar"])
		self:Bar(L["vanish_bar"], timer.vanishSoon, icon.vanish)
		self:Message(L["unvanish_message"], "Attention")
	end

	if not vanished then
		self:ScheduleRepeatingEvent("renatakivanishcheck", self.CheckVanish, 0.5, self)
	end
end

function module:VanishPhase()
	vanished = true
	self:CancelScheduledEvent("renatakivanishcheck")
	if self.db.profile.vanish then
		self:RemoveBar(L["vanish_bar"])
		self:Message(L["vanish_message"], "Attention")
		self:Bar(L["return_bar"], timer.unvanish, icon.vanish)
	end
	self:ScheduleRepeatingEvent("renatakiunvanishcheck", self.CheckUnvanish, 0.5, self)
end

------------------------------
--      Utility	Functions   --
------------------------------

function module:CheckUnvanish()
	self:DebugMessage("CheckUnvanish")
	if module:IsRenatakiVisible() then
		self:Sync(syncName.unvanish)
	end
end
function module:CheckVanish()
	self:DebugMessage("CheckVanish")
	if not module:IsRenatakiVisible() then
		self:Sync(syncName.vanish)
	end
end
function module:IsRenatakiVisible()
	if UnitName("playertarget") == self.translatedName then
		return true
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == self.translatedName then
				return true
			end
		end
	end

	return false
end
