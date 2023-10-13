
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Baron Geddon", "Molten Core")

module.revision = 20007 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = nil
module.toggleoptions = {"inferno", "service", "bomb", "mana", "announce", "icon", "bosskill"}


---------------------------------
--      Module specific Locals --
---------------------------------

local timer = {
	bomb = 8,
	inferno = 8,
	earliestNextInferno = 20,
	latestNextInferno = 26,
	earliestFirstIgnite = 10,
	latestFirstIgnite = 15,
	earliestIgnite = 20,
	latestIgnite = 30,
	service = 8,
}
local icon = {
	bomb = "Inv_Enchant_EssenceAstralSmall",
	inferno = "Spell_Fire_Incinerate",
	ignite = "Spell_Fire_Incinerate",
	service = "Spell_Fire_SelfDestruct",
}
local syncName = {
	bomb = "GeddonBomb"..module.revision,
	bombStop = "GeddonBombStop"..module.revision,
	inferno = "GeddonInferno"..module.revision,
	ignite = "GeddonManaIgnite"..module.revision,
	service = "GeddonService"..module.revision,
}

local firstinferno = true
local firstignite = true

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("zhCN", function() return {
	inferno_trigger = "迦顿男爵获得了地狱火的效果。",
	service_trigger = "performs one last service for Ragnaros",
	ignitemana_trigger = "受到了点燃法力效果的影响",
	bombyou_trigger = "你受到了活化炸弹效果的影响。",
	bombother_trigger = "(.*)受到了活化炸弹效果的影响。",
	bombyouend_trigger = "活化炸弹效果从你身上消失了。",
	bombotherend_trigger = "活化炸弹效果从(.*)身上消失。",
	ignitemana_trigger1 = "受到了点燃法力效果的影响。",
	ignitemana_trigger2 = "点燃法力被抵抗了",
	deathyou_trigger = "你死了。",
	deathother_trigger = "(.*)死亡了。",

	bomb_message_you = "你是炸弹人!",
	bomb_message_youscreen = "你是炸弹人!",
	bomb_message_other = "%s 是炸弹人!",

	bomb_bar = "炸弹人: %s",
	bomb_bar1 = "炸弹人: %s",
	inferno_bar = "下次地狱火(近战AOE火伤)",
	inferno_channel = "地狱火施放中(近战AOE火伤)",
	nextinferno_message = "3 秒后地狱火!",
	service_bar = "最后服务",
	nextbomb_bar = "下个炸弹人(跑出人群)",
	ignite_bar = "可能点燃法力",

	service_message = "最后服务! 男爵在8秒后爆炸!",
	inferno_message = "地狱火8秒!",
	ignite_message = "现在驱散!",

	cmd = "Baron",

	service_cmd = "service",
	service_name = "最后服务计时条",
	service_desc = "迦顿的最后服务计时器.",

	inferno_cmd = "inferno",
	inferno_name = "地狱火警报",
	inferno_desc = "迦顿男爵的地狱火计时器.",

	bombtimer_cmd = "bombtimer",
	bombtimer_name = "活化炸弹时间",
	bombtimer_desc = "显示一个8秒的条，炸弹的目标.",

	bomb_cmd = "bomb",
	bomb_name = "活化炸弹警报",
	bomb_desc = "当玩家是炸弹时警告",
	
	mana_cmd = "manaignite",
	mana_name = "法力引燃警报",
	mana_desc = "显示点燃法力计时器并宣布驱散它",

	icon_cmd = "icon",
	icon_name = "团队炸弹图标",
	icon_desc = "把骷髅图标放在炸弹的人身上. (需要L或A)",

	announce_cmd = "whispers",
	announce_name = "密语炸弹人玩家",
	announce_desc = "发送一个密语的玩家被活体炸弹. (需要L或A)",
} end)

L:RegisterTranslations("esES", function() return {
	inferno_trigger = "Barón Geddon gana Inferno\.",
	service_trigger = "lleva a cabo un último servicio para Ragnaros",
	ignitemana_trigger = "sufre de Ignición de maná",
	bombyou_trigger = "Sufres de Bomba viviente.",
	bombother_trigger = "(.*) sufre de Bomba viviente.",
	bombyouend_trigger = "Bomba viviente acaba de disiparse.",
	bombotherend_trigger = "Bomba viviente desaparece de (.*).",
	ignitemana_trigger1 = "sufre de Ignición de maná",
	ignitemana_trigger2 = "Resistido Ignición de maná de Barón Geddon",
	deathyou_trigger = "Has muerto.",
	deathother_trigger = "(.*) ha muerto",

	bomb_message_you = "¡Eres la bomba!",
	bomb_message_youscreen = "¡Eres la bomba!",
	bomb_message_other = "¡%s es la bomba!",

	bomb_bar = "Bomba viviente: %s",
	bomb_bar1 = "Bomba viviente: %s",
	inferno_bar = "Próximo Inferno",
	inferno_channel = "Inferno",
	nextinferno_message = "¡3 segundos hasta Inferno!",
	service_bar = "Último Servicio",
	nextbomb_bar = "Próximo Bomba viviente",
	ignite_bar = "Ignición de maná Posible",

	service_message = "¡Último servicio! Barón Geddon se explota en 8 segundos!",
	inferno_message = "¡Inferno por 8 segundos!",
	ignite_message = "¡Disipa AHORA!",

	--cmd = "Baron",

	--service_cmd = "service",
	service_name = "Alerta de Último servicio",
	service_desc = "Barra temporizadora para el último servicio de Barón Geddon.",

	--inferno_cmd = "inferno",
	inferno_name = "Alerta de Inferno",
	inferno_desc = "Barra temporizadora para el Inferno de Barón Geddon.",

	--bombtimer_cmd = "bombtimer",
	bombtimer_name = "Temporizador de Bomba viviente",
	bombtimer_desc = "Muestra una barra de 8 segundos cuando se explote la bomba.",

	--bomb_cmd = "bomb",
	bomb_name = "Alerta de Bomba viviente",
	bomb_desc = "Avisa cuando jugadores sean la bomba",

	--mana_cmd = "manaignite",
	mana_name = "Alerta de Ignición de maná",
	mana_desc = "Muestra temporizadores para Ignición de maná y anuncia para disiparlo",

	--icon_cmd = "icon",
	icon_name = "Marcar la bomba",
	icon_desc = "Marca con un icono el jugador quien tiene la bomba. (Requiere asistente o líder)",

	--announce_cmd = "whispers",
	announce_name = "Susurrar a los objetivos de la Bomba",
	announce_desc = "Susurra a los jugadores quien tienen la Bomba viviente. (Require asistente o líder)",
} end)

L:RegisterTranslations("deDE", function() return {
	inferno_trigger = "Baron Geddon bekommt \'Inferno",
	service_trigger = "performs one last service for Ragnaros",
	ignitemana_trigger = "von Mana entz\195\188nden betroffen",
	bombyou_trigger = "Ihr seid von Lebende Bombe betroffen.",
	bombother_trigger = "(.*) ist von Lebende Bombe betroffen.",
	bombyouend_trigger = "'Lebende Bombe\' schwindet von Euch.",
	bombotherend_trigger = "Lebende Bombe schwindet von (.*).",
	ignitemana_trigger1 = "von Mana entz\195\188nden betroffen",
	ignitemana_trigger2 = "Mana entz\195\188nden(.+)widerstanden",
	deathyou_trigger = "Ihr sterbt.",
	deathother_trigger = "(.*) stirbt",

	bomb_message_you = "Du bist die Bombe!",
	bomb_message_youscreen = "Du bist die Bombe!",
	bomb_message_other = "%s ist die Bombe!",

	bomb_bar = "Lebende Bombe: %s",
	bomb_bar1 = "Lebende Bombe: %s",
	inferno_bar = "N\195\164chstes Inferno",
	inferno_channel = "Inferno",
	nextinferno_message = "3 Sekunden bis Inferno!",
	service_bar = "Letzter Dienst.",
	nextbomb_bar = "N\195\164chste Lebende Bombe",
	ignite_bar = "Mögliches Mana entz\195\188nden",

	service_message = "Letzter Dienst! Baron Geddon explodiert in 8 Sekunden!",
	inferno_message = "Inferno 8 Sekunden lang!",
	ignite_message = "Entferne Magie JETZT!",

	cmd = "Baron",

	service_cmd = "service",
	service_name = "Alarm f\195\188r Letzten Dienst",
	service_desc = "Timer Balken f\195\188r Baron Geddons Letzten Dienst.",

	inferno_cmd = "inferno",
	inferno_name = "Alarm f\195\188r Inferno",
	inferno_desc = "Timer Balken f\195\188r Baron Geddons Inferno.",

	bombtimer_cmd = "bombtimer",
	bombtimer_name = "Timer f\195\188r Lebende Bombe",
	bombtimer_desc = "Zeigt einen 8 Sekunden Timer f\195\188r die Explosion der Lebenden Bombe an.",

	bomb_cmd = "bomb",
	bomb_name = "Alarm f\195\188r Lebende Bombe",
	bomb_desc = "Warnen, wenn andere Spieler die Bombe sind.",

	mana_cmd = "mana",
	mana_name = "Alarm f\195\188r Mana entz\195\188nden",
	mana_desc = "Zeige Timer f\195\188r Mana entz\195\188nden und verk\195\188nde Magie entfernen",

	icon_cmd = "icon",
	icon_name = "Schlachtzugssymbole auf die Bombe",
	icon_desc = "Markiert den Spieler, der die Bombe ist.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent).",

	announce_cmd = "whispers",
	announce_name = "Der Bombe fl\195\188stern",
	announce_desc = "Dem Spieler fl\195\188stern, wenn er die Bombe ist.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent).",
} end)


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	--self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "Event")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:ThrottleSync(5, syncName.bomb)
	self:ThrottleSync(3, syncName.bombStop)
	self:ThrottleSync(4, syncName.service)
	self:ThrottleSync(4, syncName.ignite)
	self:ThrottleSync(29, syncName.inferno)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
	firstinferno = true
	firstignite = true

	bombt = 0
end

-- called after boss is engaged
function module:OnEngage()
	self:Inferno()
	self:ManaIgnite()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
--      Event Handlers      --
------------------------------

function module:Event(msg)
	local _,_, bombother, mcverb = string.find(msg, L["bombother_trigger"])
	local _,_, bombotherend, mcverb = string.find(msg, L["bombotherend_trigger"])
	--local _,_, bombotherdeath,mctype = string.find(msg, L["deathother_trigger"])
	if string.find(msg, L["bombyou_trigger"]) then
		self:Sync(syncName.bomb)
		if self.db.profile.bomb then
			self:Bar(string.format(L["bomb_bar1"], UnitName("player")), timer.bomb, icon.bomb)
			self:Message(L["bomb_message_youscreen"], "Attention", "RunAway")
			self:WarningSign("Spell_Shadow_MindBomb", timer.bomb)
		end
		if self.db.profile.icon then
			self:Icon(UnitName("player"))
		end
	elseif string.find(msg, L["bombyouend_trigger"]) then
		self:RemoveBar(string.format(L["bomb_bar1"], UnitName("player")))
		self:Sync(syncName.bombStop)
	elseif string.find(msg, L["deathyou_trigger"]) then
		self:RemoveBar(string.format(L["bomb_bar1"], UnitName("player")))
	elseif bombother then
		bombt = bombother
		self:Sync(syncName.bomb)
		if self.db.profile.bomb then
			self:Bar(string.format(L["bomb_bar"], bombother), timer.bomb, icon.bomb)
			self:Message(string.format(L["bomb_message_other"], bombother), "Attention")
		end
		if self.db.profile.icon then
			self:Icon(bombother)
		end
		if self.db.profile.announce then
			self:TriggerEvent("BigWigs_SendTell", bombother, L["bomb_message_you"])
		end
	elseif bombotherend then
		self:RemoveBar(string.format(L["bomb_bar"], bombotherend))
		--elseif string.find(msg, L["deathother_trigger"]) then
		--	self:RemoveBar(string.format(L["bomb_bar"], bombotherdeath))
	elseif (string.find(msg, L["ignitemana_trigger1"]) or string.find(msg, L["ignitemana_trigger2"])) then
		self:Sync(syncName.ignite)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if string.find(msg, L["inferno_trigger"]) then
		BigWigs:DebugMessage("inferno trigger")
		self:Sync(syncName.inferno)
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["service_trigger"]) and self.db.profile.service then
		self:Sync(syncName.service)
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.bomb then
	elseif sync == syncName.inferno then
		self:Inferno()
	elseif sync == syncName.ignite then
		self:ManaIgnite()
	elseif sync == syncName.bombStop and self.db.profile.bomb then
		self:RemoveBar(string.format(L["bomb_bar"], bombt))
	elseif sync == syncName.service and self.db.profile.service then
		self:Bar(L["service_bar"], timer.service, icon.service)
		self:Message(L["service_message"], "Important")
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Inferno()
	--self:DelayedSync(timer.nextInferno, syncName.inferno)

	if self.db.profile.inferno then
		self:RemoveBar(L["inferno_bar"])
		if firstinferno then
			self:IntervalBar(L["inferno_bar"], timer.earliestNextInferno, timer.latestNextInferno, icon.inferno)
			firstinferno = false
		else
			self:Message(L["inferno_message"], "Important")
			self:Bar(L["inferno_channel"], timer.inferno, icon.inferno)
			self:DelayedIntervalBar(timer.inferno, L["inferno_bar"], timer.earliestNextInferno - timer.inferno, timer.latestNextInferno - timer.inferno, icon.inferno)
		end

		self:DelayedMessage(timer.earliestNextInferno - 5, L["nextinferno_message"], "Urgent", nil, nil, true)
	end

	firstinferno = false
end

function module:ManaIgnite()
	if self.db.profile.mana then
		if not firstignite then
			self:Message(L["ignite_message"], "Important")
			self:IntervalBar(L["ignite_bar"], timer.earliestIgnite, timer.latestIgnite, icon.ignite)
		else
			self:IntervalBar(L["ignite_bar"], timer.earliestFirstIgnite, timer.latestFirstIgnite, icon.ignite)
		end
		firstignite = false
	end
end