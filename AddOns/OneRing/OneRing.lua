--$Id: OneRing.lua 12749 2006-10-03 02:19:17Z kergoth $
OneRing = OneCore:NewModule("OneRing", "AceEvent-2.0", "AceHook-2.0", "AceDebug-2.0", "AceConsole-2.0", "AceDB-2.0")
local L = AceLibrary("AceLocale-2.1"):GetInstance("OneRing", true)

function OneRing:OnInitialize()
    
    OneRingFrameName:ClearAllPoints()
    OneRingFrameName:SetPoint("TOPLEFT", "OneRingFrame", "TOPLEFT", 10, -15)
	OneRingFrameName:SetText(L["Keyring"])
    OneRingFrameConfigButton:Hide()
	OneRingFramepackupButton:Hide()--隐藏多余的整理按钮
    OneRingFrameBagButton:Hide()
    OneRingFrameMoneyFrame:Hide()
    
	self.fBags = {-2}
    self.rBags = {-2}

    self.frame = OneRingFrame
	self.frame.handler = self
    self.frame.bags = {}
    
    self:RegisterDB("OneRingDB")
	self:RegisterDefaults('profile', OneRing:GetDefaults())
end

function OneRing:OnEnable()
   	self:RegisterEvent("BAG_UPDATE",			  function() self:UpdateBag(arg1) end)
	self:RegisterEvent("BAG_UPDATE_COOLDOWN",	  function() self:UpdateBag(arg1) end)
    
    self:Hook("ToggleKeyRing", function() if self.frame:IsVisible() then self.frame:Hide() else self.frame:Show() end end)
end

function OneRing:OnCustomShow()
    if not OneBag.frame:IsVisible() then 
        this:ClearAllPoints() 
        this:SetPoint("CENTER", UIParent, "CENTER", 0, 0) 
    else 
        this:ClearAllPoints() 
        this:SetPoint("BOTTOMLEFT", OneBagFrame, "TOPLEFT", 0, 8) 
    end
end

function OneRing:OnCustomHide()
end

function OneRing:GetDefaults()
    if not self.defaults then
        self.defaults = {
            cols = 4,
            scale = 1,
            alpha = 1,
            colors = {
                mouseover 	= {r = 0, g = .7, b = 1},
                ammo 		= {r = 1, g = 1, b = 0},
                soul 		= {r = .5, g = .5, b = 1}, 
                prof 		= {r = 1, g = 0, b = 1},
                bground     = {r = 0, g = 0, b = 0, a = .45},
                glow        = false,
                rarity 		= true,
            },
            show = {
                ['*'] = true
            },
            strata = 3,
            locked = false,
            clamped = true,
            bagBreak = false,
        }
    end
    
    return self.defaults
end