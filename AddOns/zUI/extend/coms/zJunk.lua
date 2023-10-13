
--MrBCat添加功能
local _G = zUI.api.GetGlobalEnv()
local setGoldString=zUI.api.setGoldString
zUI:RegisterComponent("自动售卖垃圾", function()
  --if C.quality.auto_junk=="1"then  
  
  local processed = {}



  local function GetNextGreyItem()
    for bag = 0, 4, 1 do
      for slot = 1, GetContainerNumSlots(bag), 1 do
        local name = GetContainerItemLink(bag, slot)
        if name and string.find(name, "ff9d9d9d") and not processed[bag .. "x" .. slot] then
          processed[bag .. "x" .. slot] = true
          return bag, slot
        end
      end
    end

    return nil, nil
  end

 
    
    local autovendor = CreateFrame("Frame", nil, nil)
    autovendor:Hide()

    autovendor:SetScript("OnShow", function()
      processed = {}
      this.price = 0
      this.count = 0
    end)

    autovendor:SetScript("OnHide", function()
      local  _, class = UnitClass("player")
	local color = RAID_CLASS_COLORS[class].colorStr
      if this.count > 0 then
        UIErrorsFrame:AddMessage("|cffffd200z|c"..color.."UI|r - "..zUI.mlocals["Your vendor trash has been sold and you earned "] ..
        setGoldString(this.price))
      end
    end)

    autovendor:SetScript("OnUpdate", function()
      -- throttle to to one item per .1 second
      if (this.tick or 1) > GetTime() then return else this.tick = GetTime() + .1 end

      -- scan for the next grey item
      local bag, slot = GetNextGreyItem()
      if not bag or not slot then
        this:Hide()
        return
      end

      -- double check to only sell grey
      local name = GetContainerItemLink(bag, slot)
      if not name or not string.find(name, "ff9d9d9d") then
        return
      end

      -- get value 计算售卖所得
      local _, icount = GetContainerItemInfo(bag, slot)
      local _, _, id = string.find(GetContainerItemLink(bag, slot), "item:(%d+):%d+:%d+:%d+")
      local sell = 0
      --调用AUX 计算售卖垃圾所得
      if DbItems and DbItems[tonumber(id)] then
         sell= DbItems[tonumber(id)][4]
      end
         
      local price = sell or 0
      if this.price then
        this.price = this.price + (price * (icount or 1))
        this.count = this.count + 1
      end

      -- abort if the merchant window disappeared
      if not this.merchant then return end

      -- clear cursor and sell the item
      ClearCursor()
      UseContainerItem(bag, slot)
    end)

    autovendor:RegisterEvent("MERCHANT_SHOW")
    autovendor:RegisterEvent("MERCHANT_CLOSED")
    autovendor:RegisterEvent("MERCHANT_UPDATE")
    autovendor:SetScript("OnEvent", function()
      --autovendor.button:Update()

      if event == "MERCHANT_CLOSED" then
        autovendor.merchant = nil
        autovendor:Hide()
      elseif event == "MERCHANT_SHOW" then
        --SendChatMessage("打开背包", "SAY")
        autovendor.merchant = true
        autovendor:Show()
        --autovendor.button:Show()

      end

      MerchantRepairText:SetText("")
      -- if MerchantRepairItemButton:IsShown() then
      --   autovendor.button:ClearAllPoints()
      --   autovendor.button:SetPoint("RIGHT", MerchantRepairItemButton, "LEFT", -4, 0)
      -- else
      --   autovendor.button:ClearAllPoints()
      --   autovendor.button:SetPoint("RIGHT", MerchantBuyBackItemItemButton, "LEFT", -14, 0)
      -- end
    end)

    -- Setup Autosell button
    -- autovendor.button = CreateFrame("Button", nil, MerchantFrame)
    -- autovendor.button:SetWidth(36)
    -- autovendor.button:SetHeight(36)
    -- autovendor.button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2")
    -- autovendor.button:SetNormalTexture("Interface\\Icons\\Spell_Shadow_SacrificialShield")
    -- autovendor.button:SetScript("OnEnter", function()
    --   GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    --   GameTooltip:SetText(zUI.locals["Sell Grey Items"])
    --   GameTooltip:Show()
    -- end)

    -- autovendor.button:SetScript("OnLeave", function()
    --   GameTooltip:Hide()
    -- end)

    -- autovendor.button:SetScript("OnClick", function()
    --   autovendor:Show()
    -- end)

    -- autovendor.button.Update = function()
    --   if not autovendor:IsVisible() then
    --     if HasGreyItems() then
    --       autovendor.button:Enable()
    --       autovendor.button:GetNormalTexture():SetDesaturated(false)
    --     else
    --       autovendor.button:Disable()
    --       autovendor.button:GetNormalTexture():SetDesaturated(true)
    --     end
    --   else
    --     autovendor.button:Disable()
    --     autovendor.button:GetNormalTexture():SetDesaturated(true)
    --   end
    -- end

    -- Hook MerchantFrame_Update
    if not HookMerchantFrame_Update then
      local HookMerchantFrame_Update = MerchantFrame_Update
      function _G.MerchantFrame_Update()
        -- if MerchantFrame.selectedTab == 1 then
        --   autovendor.button:Show()
        -- else
        --   autovendor.button:Hide()
        -- end
        HookMerchantFrame_Update()
      end
    end
  --end
end)
