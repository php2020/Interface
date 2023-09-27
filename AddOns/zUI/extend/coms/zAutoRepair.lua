--这是一个移植模块，原作者Kael，插件名为AutoRepair，
--
-- Chat Colors
--
zUI:RegisterComponent("zAutoRepair", function()

	--if C.quality.auto_repair =="0" then
	--	Event Handlers
	--
	zUI.repair = CreateFrame("Frame", "zAutoRepair", UIParent);
	
	local setGoldString=zUI.api.setGoldString
	zUI.repair:RegisterEvent("MERCHANT_SHOW");
	

	zUI.repair:SetScript("OnEvent", function()


		if ( event == "MERCHANT_SHOW") then
			if CanMerchantRepair()  then
				AR_RepairHandler();
			end
		end
	end)
	
	-- 
	--	Repair Functions
	--

	function AR_RepairHandler()
		if CanMerchantRepair() then		 
			local AR_EquipCost = GetRepairAllCost();
			local AR_InvCost = AR_GetInventoryCost();
			local AR_Funds = GetMoney();
			local AR_TotalCost = AR_EquipCost + AR_InvCost;
			
			local AR_Afford = AR_TotalCost < AR_Funds;
		
			
			local AR_Needed = AR_TotalCost > 0;
			
			if (AR_Afford and  AR_Needed) then
				Repair(AR_TotalCost);
				
				return;
			end
		end
	end

	function AR_GetInventoryCost()
		
		local AR_InventoryCost = 0;

		for bag = 0,4,1 do	
			for slot = 1, GetContainerNumSlots(bag) , 1 do
				local _, repairCost = GameTooltip:SetBagItem(bag,slot);
				if (repairCost) then
					AR_InventoryCost = AR_InventoryCost + repairCost;
				end
			end
		end

		return AR_InventoryCost;
	end

	function Repair(arneed)
		local  _, class = UnitClass("player")
	local color = RAID_CLASS_COLORS[class].colorStr
		RepairAllItems();			
		UIErrorsFrame:AddMessage("|cffffd200z|c"..color.."UI|r - "..zUI.mlocals["Your repair bill for work done to your equipment was: "] .. setGoldString(arneed));
			
		
	end
--end

end)