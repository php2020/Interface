--[[ Override Range Indicator ]]
local zOld_ActionButton_OnUpdate = ActionButton_OnUpdate;
function ActionButton_OnUpdate(elapsed) 
	
	local flag
	-- Handle range indicator
	if ( this.rangeTimer and this.rangeTimer <= elapsed ) then
		flag = IsActionInRange(ActionButton_GetPagedID(this))
		if this.zRangeFlag ~= flag then
			this.zRangeFlag = flag
			flag = true
		else
			flag = nil
		end
	end

	zOld_ActionButton_OnUpdate(elapsed)
	
	if flag then ActionButton_UpdateUsable() end
end

local zOld_ActionButton_UpdateUsable = ActionButton_UpdateUsable
function ActionButton_UpdateUsable()
	zOld_ActionButton_UpdateUsable()
	
	if this.zRangeFlag == 0 and IsUsableAction(ActionButton_GetPagedID(this)) then
		getglobal(this:GetName().."Icon"):SetVertexColor(0.9, 0.1, 0.1)
		getglobal(this:GetName().."NormalTexture"):SetVertexColor(1.0, 0, 0)
	end
end