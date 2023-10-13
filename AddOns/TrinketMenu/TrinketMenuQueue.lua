--[[ TrinketMenuQueue : auto queue system ]]

-- SavedVariable
TrinketMenuQueue = {
	Stats = {}, -- indexed by id of trinket, delay, priority and keep
	Sort = {}, -- indexed by number, ids in order of use
	Enabled = {} -- 0 or 1 whether auto queue is on for the slot
}
TrinketMenu.PausedQueue = {} -- 0 or 1 whether queue is paused

function TrinketMenu.QueueInit()
	TrinketMenuQueue.Sort[0] = TrinketMenuQueue.Sort[0] or {}
	TrinketMenuQueue.Sort[1] = TrinketMenuQueue.Sort[1] or {}
	TrinketMenu_SubQueueFrame:SetBackdropBorderColor(.3,.3,.3,1)
	TrinketMenu_SortPriorityText:SetText("优先")
	TrinketMenu_SortPriorityText:SetTextColor(.95,.95,.95)
	TrinketMenu_SortKeepEquippedText:SetText("暂停自动排队")
	TrinketMenu_SortKeepEquippedText:SetTextColor(.95,.95,.95)
	TrinketMenu_SortListFrame:SetBackdropBorderColor(.3,.3,.3,1)
	TrinketMenu.ReflectQueueEnabled()
	TrinketMenu.UpdateCombatQueue()
	TrinketMenu.BagsNeedUpdating = {}
	TrinketMenu.CreateTimer("UpdateBaggedTrinkets",TrinketMenu.UpdateBaggedTrinkets,.2)
	TrinketMenu_MainFrame:RegisterEvent("BAG_UPDATE")
end

function TrinketMenu.ReflectQueueEnabled()
	TrinketMenu_Trinket0Check:SetChecked(TrinketMenuQueue.Enabled[0])
	TrinketMenu_Trinket1Check:SetChecked(TrinketMenuQueue.Enabled[1])
end	

function TrinketMenu.OpenSort(which)
	TrinketMenu.CurrentlySorting = which
	TrinketMenu.PopulateSort(which)
	TrinketMenu.SortSelected = 0
	TrinketMenu_SortScrollScrollBar:SetValue(0)
	TrinketMenu.SortValidate()
	TrinketMenu.SortScrollFrameUpdate()
end

function TrinketMenu.GetID(bag,slot)
	local id
	if slot then
		_,_,id = string.find(GetContainerItemLink(bag,slot) or "","item:(%d+)")
	else
		_,_,id = string.find(GetInventoryItemLink("player",bag) or "","item:(%d+)")
	end
	return id
end

function TrinketMenu.GetNameByID(id)
	if id==0 then
		return StopQueueHereText1,"Interface\\Buttons\\UI-GroupLoot-Pass-Up",1
	else
		local name,_,quality,_,_,_,_,_,texture = GetItemInfo(id or "")
		return name,texture,quality
	end
end

-- adds id to which sort if it's not already in the list
function TrinketMenu.AddToSort(which,id)
	if not id then return end
	local name = TrinketMenu.GetNameByID(id)
	if name and not TrinketMenu.WatchItem[name] then
		TrinketMenu.AddWatchItem(name)
	end

	local found
	for i=1,table.getn(TrinketMenuQueue.Sort[which]) do
		found = found or TrinketMenuQueue.Sort[which][i]==id
	end
	if not found then
		table.insert(TrinketMenuQueue.Sort[which],id)
	end
end

-- populates sorts adding any new trinkets
function TrinketMenu.PopulateSort(which)
	TrinketMenuQueue.Sort[which] = TrinketMenuQueue.Sort[which] or {}
	TrinketMenu.AddToSort(which,TrinketMenu.GetID(which+13))
	TrinketMenu.AddToSort(which,TrinketMenu.GetID((1-which)+13))
	local equipLoc,id
	for i=0,4 do
		for j=1,GetContainerNumSlots(i) do
			id = TrinketMenu.GetID(i,j)
			_,_,_,_,_,_,_,equipLoc = GetItemInfo(id or "")
			if equipLoc=="INVTYPE_TRINKET" then
				TrinketMenu.AddToSort(which,id)
			end
		end
	end
	TrinketMenu.AddToSort(which,0) -- id 0 is Stop
end

function TrinketMenu.SortScrollFrameUpdate()
	local offset = FauxScrollFrame_GetOffset(TrinketMenu_SortScroll)
	local list = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting]
	FauxScrollFrame_Update(TrinketMenu_SortScroll, list and table.getn(list) or 0, 9, 24)

	if list then
		local r,g,b,found
		local texture,name,quality
		local item,itemName,itemIcon
		for i=1,9 do
			item = getglobal("TrinketMenu_Sort"..i)
			itemName = getglobal("TrinketMenu_Sort"..i.."Name")
			itemIcon = getglobal("TrinketMenu_Sort"..i.."Icon")
			idx = offset+i
			if idx<=table.getn(list) then
				name,texture,quality = TrinketMenu.GetNameByID(list[idx])
				itemIcon:SetTexture(texture)
				itemName:SetText(name)
				r,g,b = GetItemQualityColor(quality)
				itemName:SetTextColor(r,g,b)
				itemIcon:SetVertexColor(1,1,1)
				item:Show()
				if idx == TrinketMenu.SortSelected then
					TrinketMenu.LockHighlight(item)
				else
					TrinketMenu.UnlockHighlight(item)
				end
			else
				item:Hide()
			end
		end
	end
end

function TrinketMenu.LockHighlight(frame)
	if type(frame)=="string" then frame = getglobal(frame) end
	if not frame then return end
	frame.lockedHighlight = 1
	getglobal(frame:GetName().."Highlight"):Show()
end

function TrinketMenu.UnlockHighlight(frame)
	if type(frame)=="string" then frame = getglobal(frame) end
	if not frame then return end
	frame.lockedHighlight = nil
	getglobal(frame:GetName().."Highlight"):Hide()
end

-- shows tooltip for items in the sort list
function TrinketMenu.SortTooltip()
	local idx = FauxScrollFrame_GetOffset(TrinketMenu_SortScroll) + this:GetID()
	local name,itemLink = GetItemInfo(TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting][idx] or "")
	if itemLink and TrinketMenuOptions.ShowTooltips=="ON" then
		TrinketMenu.AnchorTooltip()
		GameTooltip:SetHyperlink(itemLink)
		GameTooltip:Show()
	else
		TrinketMenu.OnTooltip(StopQueueHereText2,StopQueueHereTooltip)
	end
end

function TrinketMenu.SortOnClick()
	TrinketMenu_SortDelay:ClearFocus()
	local idx = FauxScrollFrame_GetOffset(TrinketMenu_SortScroll) + this:GetID()
	if TrinketMenu.SortSelected == idx then
		TrinketMenu.SortSelected = 0
	else
		TrinketMenu.SortSelected = idx
	end
	TrinketMenu.SortScrollFrameUpdate()
	TrinketMenu.SortValidate()
end

-- turns move buttons on/off, moves the list to keep selected in view and keeps the sorting slot button highlighted
function TrinketMenu.SortValidate()
	local selected = TrinketMenu.SortSelected
	local list = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting]
	TrinketMenu_MoveTop:Enable()
	TrinketMenu_MoveUp:Enable()
	TrinketMenu_MoveDown:Enable()
	TrinketMenu_MoveBottom:Enable()
	if selected==0 or table.getn(list)<2 then -- none selected, disable all
		TrinketMenu_MoveTop:Disable()
		TrinketMenu_MoveUp:Disable()
		TrinketMenu_MoveDown:Disable()
		TrinketMenu_MoveBottom:Disable()
	elseif selected==1 then -- top selected, disable up
		TrinketMenu_MoveUp:Disable()
		TrinketMenu_MoveTop:Disable()
		TrinketMenu_MoveDown:Enable()
	elseif selected == table.getn(list) then -- bottom selected, disable down
		TrinketMenu_MoveDown:Disable()
		TrinketMenu_MoveBottom:Disable()
	end
	local idx = FauxScrollFrame_GetOffset(TrinketMenu_SortScroll)
	if selected>0 and list[selected] and list[selected]~=0 then
		TrinketMenu_SortDelay:Show()
		TrinketMenu_SortPriority:Show()
		TrinketMenu_SortKeepEquipped:Show()
	else
		TrinketMenu_SortDelay:Hide()
		TrinketMenu_SortPriority:Hide()
		TrinketMenu_SortKeepEquipped:Hide()
	end
	local stats = TrinketMenuQueue.Stats[list[TrinketMenu.SortSelected]]
	TrinketMenu_SortDelay:SetText(stats and (stats.delay or "0") or "0")
	TrinketMenu_SortPriority:SetChecked(stats and stats.priority)
	TrinketMenu_SortKeepEquipped:SetChecked(stats and stats.keep)
			
	if not IsShiftKeyDown() and selected>0 then -- keep selected visible on list, moving thumb as needed, unless shift is down
		local parent = TrinketMenu_SortScrollScrollBar
		local offset
		if selected <= idx then
			offset = (selected==1) and 0 or (parent:GetValue() - (parent:GetHeight() / 2))
			parent:SetValue(offset)
			PlaySound("UChatScrollButton")
		elseif selected >= (idx+10) then
			offset = (selected==table.getn(list)) and TrinketMenu_SortScroll:GetVerticalScrollRange() or (parent:GetValue() + (parent:GetHeight() / 2))
			parent:SetValue(offset)
			PlaySound("UChatScrollButton");
		end
	end
end

-- movement buttons
function TrinketMenu.SortMove()
	TrinketMenu_SortDelay:ClearFocus()
	local dir = ((this==TrinketMenu_MoveUp) and -1) or ((this==TrinketMenu_MoveTop) and "top") or ((this==TrinketMenu_MoveDown) and 1) or ((this==TrinketMenu_MoveBottom) and "bottom")
	if dir then
		local idx1 = TrinketMenu.SortSelected -- FauxScrollFrame_GetOffset(ItemRack_Config_SortScroll) + 
		local list = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting]
		local idx2 = ((dir=="top") and 1) or ((dir=="bottom") and table.getn(list)) or idx1+dir
		local temp = list[idx1]
		if tonumber(dir) then
			list[idx1] = list[idx2]
			list[idx2] = temp
		elseif dir=="top" then
			table.remove(list,idx1)
			table.insert(list,1,temp)
		elseif dir=="bottom" then
			table.remove(list,idx1)
			table.insert(list,temp)
		end
		TrinketMenu.SortSelected = idx2
		TrinketMenu.SortValidate()
		TrinketMenu.SortScrollFrameUpdate()
	end
end

function TrinketMenu.SortDelay_OnTextChanged()
	local delay = tonumber(TrinketMenu_SortDelay:GetText()) or 0
	local id = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting][TrinketMenu.SortSelected]
	TrinketMenuQueue.Stats[id] = TrinketMenuQueue.Stats[id] or {}
	TrinketMenuQueue.Stats[id].delay = delay~=0 and delay or nil
end

function TrinketMenu.SortPriority_OnClick()
	local check = this:GetChecked()
	local id = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting][TrinketMenu.SortSelected]
	TrinketMenuQueue.Stats[id] = TrinketMenuQueue.Stats[id] or {}
	TrinketMenuQueue.Stats[id].priority = check
end

function TrinketMenu.SortKeepEquipped_OnClick()
	local check = this:GetChecked()
	local id = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting][TrinketMenu.SortSelected]
	TrinketMenuQueue.Stats[id] = TrinketMenuQueue.Stats[id] or {}
	TrinketMenuQueue.Stats[id].keep = check
end

function TrinketMenu.TabCheck_OnClick()
	TrinketMenuQueue.Enabled[3-this:GetID()] = this:GetChecked()
	TrinketMenu.UpdateCombatQueue()
end

--[[ Auto queue processing ]]

function TrinketMenu.UpdateBaggedTrinkets()
	local id,name,equipLoc
	for i in TrinketMenu.BagsNeedUpdating do
		for j=1,GetContainerNumSlots(i) do
			_,_,id = string.find(GetContainerItemLink(i,j) or "","item:(%d+)")
			name,_,_,_,_,_,_,equipLoc = GetItemInfo(id or "")
			if equipLoc=="INVTYPE_TRINKET" then
				TrinketMenu.AddWatchItem(name,nil,i,j)
			end
		end
		TrinketMenu.BagsNeedUpdating[i] = nil
	end
end

function TrinketMenu.TrinketNearReady(bag,slot)
	local start,duration
	if slot then
		start,duration = GetContainerItemCooldown(bag,slot)
	else
		start,duration = GetInventoryItemCooldown("player",bag)
	end
	if start==0 or duration-(GetTime()-start)<=30 then
		return 1
	end
end

function TrinketMenu.CanCooldown(inv)
	local _,_,enable = GetInventoryItemCooldown("player",inv)
	return enable==1
end

-- this function quickly checks if conditions are right for a possible ProcessAutoQueue
function TrinketMenu.PeriodicQueueCheck()
	for i=0,1 do
		if TrinketMenuQueue.Enabled[i] then
			TrinketMenu.ProcessAutoQueue(i)
		end
	end
end

-- which = 0 or 1, decides if a trinket should be equipped and equips if so
function TrinketMenu.ProcessAutoQueue(which)

	local start,duration,enable = GetInventoryItemCooldown("player",13+which)
	local _,_,id,name = string.find(GetInventoryItemLink("player",13+which) or "","item:(%d+).+%[(.+)%]")
	local icon = getglobal("TrinketMenu_Trinket"..which.."Queue") 

	if not id then return end -- leave if no trinket equipped
	if IsInventoryItemLocked(13+which) then return end -- leave if slot being swapped
	if TrinketMenu.PausedQueue[which] then
		icon:SetVertexColor(1,.5,.5) -- leave if SetQueue(which,"PAUSE")
		return
	end
	if TrinketMenuQueue.Stats[id] then
		if TrinketMenuQueue.Stats[id].keep then
			icon:SetVertexColor(1,.5,.5)
			return -- leave if .keep flag set on this item
		end
		if TrinketMenuQueue.Stats[id].delay then
			local timeLeft = GetTime()-start
			-- leave if currently equipped trinket is on cooldown for less than its delay
			if start>0 and (duration-timeLeft)>30 and timeLeft<TrinketMenuQueue.Stats[id].delay then
				icon:SetDesaturated(1)
				return
			end
		end
	end

	icon:SetDesaturated(0) -- normal queue operation, reflect that in queue inset
	icon:SetVertexColor(1,1,1)

--	local name = TrinketMenu.GetNameByID(id)
	local ready = TrinketMenu.TrinketNearReady(13+which)
	if ready and TrinketMenu.CombatQueue[which] then
		TrinketMenu.CombatQueue[which] = nil
		TrinketMenu.UpdateCombatQueue()
	end
	local list,rank = TrinketMenuQueue.Sort[which]
	for i=1,table.getn(list) do
		if list[i]==0 then rank=i break end
		if ready and list[i]==id then rank=i break end
	end
	if rank then
		local bag,slot
		for i=1,rank do
			if not ready or enable==0 or (TrinketMenuQueue.Stats[list[i]] and TrinketMenuQueue.Stats[list[i]].priority) then
				name = GetItemInfo(list[i]) or ""
				if TrinketMenu.WatchItem[name] then
					bag,slot = TrinketMenu.WatchItem[name].bag,TrinketMenu.WatchItem[name].slot
					if bag then
						if string.find(GetContainerItemLink(bag,slot) or "",name,1,1) then
							if TrinketMenu.TrinketNearReady(bag,slot) then
								if TrinketMenu.CombatQueue[which]~=name then
									TrinketMenu.EquipTrinketByName(name,13+which)
								end
								break
							end
						end
					end
				end
			end
		end
	end
end

--[[ TrinketMenu.SetQueue and TrinketMenu.GetQueue ]]

-- These functions are for macros and mods to configure sort queues.

-- TrinketMenu.SetQueue(0 or 1,"ON" or "OFF" or "PAUSE" or "RESUME" or "SORT"[,"sort list")
-- some examples:
-- TrinketMenu.SetQueue(1,"PAUSE") -- if queue is going, pause it
-- TrinketMenu.SetQueue(1,"RESUME") -- if queue is paused, resume it
-- TrinketMenu.SetQueue(1,"SORT","Earthstrike","Insignia of the Alliance","Diamond Flask") -- set sort
-- TrinketMenu.SetQUeue(0,"SORT","Lifestone","Darkmoon Card: Heroism") -- set sort for trinket 0
-- (a "stop the queue" is assumed at the end of the list)
function TrinketMenu.SetQueue(which,...)
	local errorstub = "|cFFBBBBBBTrinketMenu.SetQueue:|cFFFFFFFF "
	if not which or not tonumber(which) or which<0 or which>1 then
		DEFAULT_CHAT_FRAME:AddMessage(errorstub.."First parameter must be 0 for top trinket or 1 for bottom.")
		return
	end
	if table.getn(arg)<1 then
		DEFAULT_CHAT_FRAME:AddMessage(errorstub.."Second parameter is either ON, OFF, PAUSE, RESUME or the beginning of a list of trinkets in a sort order.")
		return
	end
	if TrinketMenu_OptFrame:IsVisible() then
		TrinketMenu_OptFrame:Hide() -- close option frame if it's up. the mess otherwise would be scary
	end
	if arg[1]=="ON" then
		TrinketMenuQueue.Enabled[which]=1
		TrinketMenu.PausedQueue[which]=nil
	elseif arg[1]=="OFF" then
		TrinketMenuQueue.Enabled[which]=nil
		TrinketMenu.PausedQueue[which]=nil
	elseif arg[1]=="PAUSE" then
		TrinketMenu.PausedQueue[which]=1
	elseif arg[1]=="RESUME" then
		TrinketMenu.PausedQueue[which]=nil
	elseif arg[1]=="SORT" and table.getn(arg)>1 then
		local sortidx,inv,bag,slot,id = 1
		table.setn(TrinketMenuQueue.Sort[which],0)
		for i=2,table.getn(arg) do
			inv,bag,slot = TrinketMenu.FindItem(arg[i],1) -- include inventory
			if inv then
				table.insert(TrinketMenuQueue.Sort[which],TrinketMenu.GetID(inv))
			elseif bag then
				table.insert(TrinketMenuQueue.Sort[which],TrinketMenu.GetID(bag,slot))
			else
				DEFAULT_CHAT_FRAME:AddMessage(errorstub.."Trinket \""..arg[i].."\" not found.")
			end
		end
		table.insert(TrinketMenuQueue.Sort[which],0)
	else
		DEFAULT_CHAT_FRAME:AddMessage(errorstub.." Expected ON, OFF, PAUSE, RESUME or SORT+list")
	end

	TrinketMenu.ReflectQueueEnabled()
	TrinketMenu.UpdateCombatQueue()

end

-- returns 1 or nil if queue is enabled, and a table containing an ordered list of the trinkets
function TrinketMenu.GetQueue(which)
	if not which or not tonumber(which) or which<0 or which>1 then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFBBBBBBTrinketMenu.GetQueue:|cFFFFFFFF Parameter must be 0 for top trinket or 1 for bottom.")
		return
	end
	local trinketList,name = {}
	for i=1,table.getn(TrinketMenuQueue.Sort[which]) do
		name = TrinketMenu.GetNameByID(TrinketMenuQueue.Sort[which][i])
		table.insert(trinketList,name)
	end
	return TrinketMenuQueue.Enabled[which],trinketList
end
