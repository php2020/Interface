local _G = getfenv(0)

local ADDON = {}
MiniNameplatesDBPC = MiniNameplatesDBPC or {}
ADDON.genSettings = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.genSettings
  or {["showPets"]=false,["enableAddOn"]=true,["showFriendly"]=false,["combatOnly"]=false,["hbwidth"]=80,["hbheight"]=4,
      ["texture"]="Interface\\BUTTONS\\WHITE8X8",["refreshRate"]=1/60,["clickThrough"]=true}
ADDON.raidicon = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.raidicon
  or {["size"]=15,["point"]="BOTTOMLEFT",["anchorpoint"]="BOTTOMLEFT",["xoffs"]=-18,["yoffs"]=-4}
ADDON.debufficon = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.debufficon
  or {["hide"]=false,["size"]=12,["point"]="BOTTOMLEFT",["anchorpoint"]="BOTTOMLEFT",["row1yoffs"]=-13,["row2yoffs"]=-25}
ADDON.classicon = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.classicon
  or {["hide"]=false,["size"]=12,["point"]="RIGHT",["anchorpoint"]="LEFT",["xoffs"]=-3,["yoffs"]=-1}
ADDON.targetindicator = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.targetindicator
  or {["hide"]=false,["size"]=25,["point"]="BOTTOM",["anchorpoint"]="TOP",["xoffs"]=0,["yoffs"]=-5}
ADDON.nametext = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.nametext
  or {["size"]=12,["point"]="BOTTOM",["anchorpoint"]="CENTER",["xoffs"]=0,["yoffs"]=-4,
      ["font"]="Fonts\\FZXHLJW.ttf"}
ADDON.leveltext = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.leveltext
  or {["hide"]=false,["size"]=11,["point"]="TOPLEFT",["anchorpoint"]="RIGHT",["xoffs"]=3,["yoffs"]=4,
      ["font"]="Fonts\\FZXHLJW.ttf"}

local Points = {
	"TOP", "RIGHT", "BOTTOM", "LEFT", "CENTER",
	"TOPRIGHT", "TOPLEFT", "BOTTOMLEFT", "BOTTOMRIGHT",
}

local CopyTable
CopyTable = function(t,copied)
  copied = copied or {}
  local copy = {}
  copied[t] = copy
  for k,v in pairs(t) do
    if type(v) == "table" then
      if copied[v] then
        copy[k] = copied[v]
      else
        copy[k] = CopyTable(v,copied)
      end
    else
      copy[k] = v
    end
  end
  return copy
end

local function Options()
  if not next(MiniNameplatesDBPC) then
    MiniNameplatesDBPC = CopyTable(ADDON)
  end
  if MiniNameplatesOptionsFrame then return MiniNameplatesOptionsFrame end
  local optionsFrame = CreateFrame("Frame","MiniNameplatesOptionsFrame",UIParent)
  optionsFrame:SetWidth(460)
  optionsFrame:SetHeight(31)
  optionsFrame:SetPoint("CENTER",UIParent, "CENTER",0,0)
  optionsFrame:EnableMouse(1)
  optionsFrame:SetMovable(1)

  tinsert(UISpecialFrames,"MiniNameplatesOptionsFrame")

  optionsFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 5, right = 3, top = 3, bottom = 5 }
    })
  optionsFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)
  optionsFrame:SetBackdropColor(0.15, 0.15, 0.15)

  optionsFrame.titleregion = optionsFrame:CreateTitleRegion(optionsFrame)
  optionsFrame.titleregion:SetAllPoints(optionsFrame)

  optionsFrame.title = optionsFrame:CreateFontString(nil,"ARTWORK","GameFontHighlight")
  optionsFrame.title:SetText("MiniNameplates 2.0")
  optionsFrame.title:SetPoint("TOPLEFT",optionsFrame,"TOPLEFT",8,-8)

  optionsFrame.close = CreateFrame("BUTTON",nil,optionsFrame,"UIPanelCloseButton")
  optionsFrame.close:SetPoint("TOPRIGHT",optionsFrame,"TOPRIGHT")

  optionsFrame.options = CreateFrame("FRAME",nil,optionsFrame)
  optionsFrame.options:SetWidth(272)
  optionsFrame.options:SetHeight(348)
  optionsFrame.options:SetPoint("TOPLEFT",optionsFrame,"BOTTOMLEFT")
  optionsFrame.options:EnableMouse(1)
  optionsFrame.options:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 5, right = 3, top = 3, bottom = 5 }
    })
  optionsFrame.options:SetBackdropBorderColor(0.4, 0.4, 0.4)
  optionsFrame.options:SetBackdropColor(0.15, 0.15, 0.15)

  optionsFrame.options.genSettings = CreateFrame("FRAME",nil,optionsFrame.options)
  optionsFrame.options.genSettings:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT", 8, -20)
  optionsFrame.options.genSettings:SetPoint("BOTTOMRIGHT",optionsFrame.options,"TOPRIGHT", -8, -155)
  optionsFrame.options.genSettings:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
  optionsFrame.options.genSettings:SetBackdropBorderColor(0, 0, 0)
  optionsFrame.options.genSettings:SetBackdropColor(0.1, 0.1, 0.1)

  optionsFrame.gentext = optionsFrame.options:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
  optionsFrame.gentext:SetText("一般设置")
  optionsFrame.gentext:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",18,-8)

  optionsFrame.enableAddOn = CreateFrame("CheckButton","MiniNameplatescb3",optionsFrame.options.genSettings,"UIOptionsCheckButtonTemplate")
  optionsFrame.enableAddOn:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",16,-22)
  optionsFrame.enableAddOn:SetHitRectInsets(0,-30,5,5)
  optionsFrame.enableAddOn.option = {"genSettings","enableAddOn"}
  MiniNameplatescb3Text:SetText("敌对")

  optionsFrame.showFriendly = CreateFrame("CheckButton","MiniNameplatescb1",optionsFrame.options.genSettings,"UIOptionsCheckButtonTemplate")
  optionsFrame.showFriendly:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",80,-22)
  optionsFrame.showFriendly:SetHitRectInsets(0,-30,5,5)
  optionsFrame.showFriendly.option = {"genSettings","showFriendly"}
  MiniNameplatescb1Text:SetText("友方")

  optionsFrame.combatOnly = CreateFrame("CheckButton","MiniNameplatescb2",optionsFrame.options.genSettings,"UIOptionsCheckButtonTemplate")
  optionsFrame.combatOnly:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",144,-22)
  optionsFrame.combatOnly:SetHitRectInsets(0,-30,5,5)
  optionsFrame.combatOnly.option = {"genSettings","combatOnly"}
  MiniNameplatescb2Text:SetText("只在战斗")

  optionsFrame.showPets = CreateFrame("CheckButton","MiniNameplatescb4",optionsFrame.options.genSettings,"UIOptionsCheckButtonTemplate")
  optionsFrame.showPets:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",16,-46)
  optionsFrame.showPets:SetHitRectInsets(0,-30,5,5)
  optionsFrame.showPets.option = {"genSettings","showPets"}
  MiniNameplatescb4Text:SetText("宠物")

  optionsFrame.clickThrough = CreateFrame("CheckButton","MiniNameplatescb5",optionsFrame.options.genSettings,"UIOptionsCheckButtonTemplate")
  optionsFrame.clickThrough:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",80,-46)
  optionsFrame.clickThrough:SetHitRectInsets(0,-30,5,5)
  optionsFrame.clickThrough.option = {"genSettings","clickThrough"}
  MiniNameplatescb5Text:SetText("通过点击")

  optionsFrame.texture = CreateFrame("EditBox","MiniNameplateseb1",optionsFrame.options.genSettings,"InputBoxTemplate")
  optionsFrame.texture:SetWidth(135)
  optionsFrame.texture:SetHeight(12)
  optionsFrame.texture.text = optionsFrame.texture:CreateFontString(nil,"ARTWORK","GameFontNormalSmall")
  optionsFrame.texture.text:SetText("血条纹理")
  optionsFrame.texture.text:SetPoint("RIGHT",optionsFrame.texture,"LEFT",-5,0)
  optionsFrame.texture:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",115,-72)
  optionsFrame.texture.option = {"genSettings","texture"}

  optionsFrame.hbwidth = CreateFrame("EditBox","MiniNameplateseb2",optionsFrame.options.genSettings,"InputBoxTemplate")
  optionsFrame.hbwidth:SetWidth(25)
  optionsFrame.hbwidth:SetHeight(12)
  optionsFrame.hbwidth.text = optionsFrame.hbwidth:CreateFontString(nil,"ARTWORK","GameFontNormalSmall")
  optionsFrame.hbwidth.text:SetText("宽度")
  optionsFrame.hbwidth.text:SetPoint("RIGHT",optionsFrame.hbwidth,"LEFT",-5,0)
  optionsFrame.hbwidth:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",55,-96)
  optionsFrame.hbwidth.option = {"genSettings","hbwidth"}

  optionsFrame.hbheight = CreateFrame("EditBox","MiniNameplateseb3",optionsFrame.options.genSettings,"InputBoxTemplate")
  optionsFrame.hbheight:SetWidth(25)
  optionsFrame.hbheight:SetHeight(12)
  optionsFrame.hbheight.text = optionsFrame.hbheight:CreateFontString(nil,"ARTWORK","GameFontNormalSmall")
  optionsFrame.hbheight.text:SetText("高度")
  optionsFrame.hbheight.text:SetPoint("RIGHT",optionsFrame.hbheight,"LEFT",-5,0)
  optionsFrame.hbheight:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",150,-96)
  optionsFrame.hbheight.option = {"genSettings","hbheight"}  

  optionsFrame.refreshRate = CreateFrame("Slider","MiniNameplatesslider1",optionsFrame.options.genSettings,"OptionsSliderTemplate")
  optionsFrame.refreshRate:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",18,-125)
  optionsFrame.refreshRate:SetPoint("TOPRIGHT",optionsFrame.options,"TOPRIGHT",-18,-125)
  optionsFrame.refreshRate:SetMinMaxValues(30,120)
  optionsFrame.refreshRate:SetValueStep(5)
  optionsFrame.refreshRate.option = {"genSettings","refreshRate"}
  MiniNameplatesslider1Low:SetText("30")
  MiniNameplatesslider1High:SetText("120")

  optionsFrame.options.iconSettings = CreateFrame("FRAME",nil,optionsFrame.options)
  optionsFrame.options.iconSettings:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT", 8, -165)
  optionsFrame.options.iconSettings:SetPoint("BOTTOMRIGHT",optionsFrame.options,"TOPRIGHT", -8, -224)
  optionsFrame.options.iconSettings:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
  optionsFrame.options.iconSettings:SetBackdropBorderColor(0, 0, 0)
  optionsFrame.options.iconSettings:SetBackdropColor(0.1, 0.1, 0.1)

  optionsFrame.icontext = optionsFrame.options:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
  optionsFrame.icontext:SetText("图标设置")
  optionsFrame.icontext:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",18,-155)

  optionsFrame.doublecb = CreateFrame("CheckButton","MiniNameplatescb6",optionsFrame.options.iconSettings,"UIOptionsCheckButtonTemplate")
  optionsFrame.doublecb:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",16,-165)
  optionsFrame.doublecb:SetHitRectInsets(0,-30,5,5)
  MiniNameplatescb6Text:SetText("占位符6")

  optionsFrame.doublehover = CreateFrame("CheckButton","MiniNameplatescb7",optionsFrame.options.iconSettings,"UIOptionsCheckButtonTemplate")
  optionsFrame.doublehover:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",110,-165)
  optionsFrame.doublehover:SetHitRectInsets(0,-30,5,5)
  optionsFrame.doublehover.option = "doublehover"
  MiniNameplatescb7Text:SetText("占位符7")

  optionsFrame.options.bindingframe = CreateFrame("FRAME",nil,optionsFrame.options)
  optionsFrame.options.bindingframe:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT", 8, -213)
  optionsFrame.options.bindingframe:SetPoint("BOTTOMRIGHT",optionsFrame.options,"TOPRIGHT", -8, -296)
  optionsFrame.options.bindingframe:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
  optionsFrame.options.bindingframe:SetBackdropBorderColor(0, 0, 0)
  optionsFrame.options.bindingframe:SetBackdropColor(0.1, 0.1, 0.1)

  optionsFrame.bindingtext = optionsFrame.options:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
  optionsFrame.bindingtext:SetText("姓名板热键")
  optionsFrame.bindingtext:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",18,-201)

  optionsFrame.bindingkey1 = CreateFrame("Button","MiniNameplateskb1",optionsFrame.options.bindingframe,"UIPanelButtonTemplate2")
  optionsFrame.bindingkey1:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",16,-219)
  optionsFrame.bindingkey1:SetWidth(220)
  optionsFrame.bindingkey1:SetTextFontObject(GameFontHighlightSmall)
  optionsFrame.bindingkey1:SetHighlightFontObject(GameFontHighlightSmall)
  optionsFrame.bindingkey1:SetScript("OnClick",function() srti.SetKeyBinding(arg1,"NAMEPLATES",1) end)

  optionsFrame.unbindingkey1 = CreateFrame("Button",nil,optionsFrame.options.bindingframe)
  optionsFrame.unbindingkey1:SetPoint("LEFT",optionsFrame.bindingkey1,"RIGHT",-6,-1.5)
  optionsFrame.unbindingkey1:SetWidth(32)
  optionsFrame.unbindingkey1:SetHeight(32)
  optionsFrame.unbindingkey1:SetNormalTexture("Interface\\Buttons\\CancelButton-Up")
  optionsFrame.unbindingkey1:SetPushedTexture("Interface\\Buttons\\CancelButton-Down")
  local h = optionsFrame.unbindingkey1:CreateTexture(nil,"HIGHLIGHT")
  h:SetTexture("Interface\\Buttons\\CancelButton-Highlight")
  h:SetAllPoints()
  h:SetBlendMode("ADD")
  optionsFrame.unbindingkey1:SetHighlightTexture(h)
  optionsFrame.unbindingkey1:SetScript("OnClick",function() srti.SetKeyBinding(arg1,"NAMEPLATES",1,1) end)

  optionsFrame.bindingkey2 = CreateFrame("Button","MiniNameplateskb2",optionsFrame.options.bindingframe,"UIPanelButtonTemplate2")
  optionsFrame.bindingkey2:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",16,-242)
  optionsFrame.bindingkey2:SetWidth(220)
  optionsFrame.bindingkey2:SetTextFontObject(GameFontHighlightSmall)
  optionsFrame.bindingkey2:SetHighlightFontObject(GameFontHighlightSmall)
  optionsFrame.bindingkey2:SetScript("OnClick",function() srti.SetKeyBinding(arg1,"FRIENDNAMEPLATES",2) end)

  optionsFrame.unbindingkey2 = CreateFrame("Button",nil,optionsFrame.options.bindingframe)
  optionsFrame.unbindingkey2:SetPoint("LEFT",optionsFrame.bindingkey2,"RIGHT",-6,-1.5)
  optionsFrame.unbindingkey2:SetWidth(32)
  optionsFrame.unbindingkey2:SetHeight(32)
  optionsFrame.unbindingkey2:SetNormalTexture("Interface\\Buttons\\CancelButton-Up")
  optionsFrame.unbindingkey2:SetPushedTexture("Interface\\Buttons\\CancelButton-Down")
  h = optionsFrame.unbindingkey2:CreateTexture(nil,"HIGHLIGHT")
  h:SetTexture("Interface\\Buttons\\CancelButton-Highlight")
  h:SetAllPoints()
  h:SetBlendMode("ADD")
  optionsFrame.unbindingkey2:SetHighlightTexture(h)
  optionsFrame.unbindingkey2:SetScript("OnClick",function() srti.SetKeyBinding(arg1,"FRIENDNAMEPLATES",2,1) end)

  optionsFrame.bindinghover = CreateFrame("CheckButton","MiniNameplatescb8",optionsFrame.options.bindingframe,"UIOptionsCheckButtonTemplate")
  optionsFrame.bindinghover:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",16,-268)
  optionsFrame.bindinghover:SetHitRectInsets(0,-130,5,5)
  optionsFrame.bindinghover.option = "bindinghover"
  MiniNameplatescb7Text:SetText("占位符11")


  optionsFrame.options.hoverframe = CreateFrame("FRAME",nil,optionsFrame.options)
  optionsFrame.options.hoverframe:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT", 8, -298)
  optionsFrame.options.hoverframe:SetPoint("BOTTOMRIGHT",optionsFrame.options,"TOPRIGHT", -8, -342)
  optionsFrame.options.hoverframe:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
  optionsFrame.options.hoverframe:SetBackdropBorderColor(0, 0, 0)
  optionsFrame.options.hoverframe:SetBackdropColor(0.1, 0.1, 0.1)

  optionsFrame.hovertime = CreateFrame("Slider","MiniNameplatesslider2",optionsFrame.options,"OptionsSliderTemplate")
  optionsFrame.hovertime:SetPoint("TOPLEFT",optionsFrame.options,"TOPLEFT",18,-312)
  optionsFrame.hovertime:SetPoint("TOPRIGHT",optionsFrame.options,"TOPRIGHT",-18,-312)
  optionsFrame.hovertime:SetMinMaxValues(0.0,0.5)
  optionsFrame.hovertime:SetValueStep(0.05)
  optionsFrame.hovertime.option = "hovertime"
  MiniNameplatesslider2Low:SetText("占位符12")
  MiniNameplatesslider2High:SetText("占位符13")

  optionsFrame.preview = CreateFrame("FRAME",nil,optionsFrame)
  optionsFrame.preview:EnableMouse(1)
  optionsFrame.preview:SetMovable(1)
  optionsFrame.preview:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 5, right = 3, top = 3, bottom = 5 }
    })
  optionsFrame.preview:SetBackdropBorderColor(0.4, 0.4, 0.4)
  optionsFrame.preview:SetBackdropColor(0.15, 0.15, 0.15)
  optionsFrame.preview:SetPoint("TOPRIGHT",optionsFrame,"BOTTOMRIGHT",0,0)
  optionsFrame.preview:SetPoint("BOTTOMLEFT",optionsFrame.options,"BOTTOMRIGHT",0,0)

  optionsFrame.preview.model = CreateFrame("PLAYERMODEL",nil,optionsFrame.preview)
  optionsFrame.preview.model:SetPoint("TOPRIGHT",optionsFrame.preview,"TOPRIGHT",0,-48)
  optionsFrame.preview.model:SetPoint("BOTTOMLEFT",optionsFrame.preview,"BOTTOMLEFT",0,0)
  optionsFrame.preview.model:RegisterEvent("DISPLAY_SIZE_CHANGED")
  optionsFrame.preview.model:SetRotation(0.61)
  optionsFrame.preview.model:SetUnit("player")
  optionsFrame.preview.model:SetScript("OnEvent", function() this:RefreshUnit() end )

  optionsFrame.preview.nameplate = CreateFrame("Frame",nil,optionsFrame.preview)
  optionsFrame.preview.nameplate:SetPoint("BOTTOM",optionsFrame.preview.model,"TOP",0,-30)
  optionsFrame.preview.nameplate.hbar = CreateFrame("StatusBar",nil,optionsFrame.preview.nameplate)
  optionsFrame.preview.nameplate.hbar.bg = optionsFrame.preview.nameplate.hbar:CreateTexture(nil, "BORDER")
  optionsFrame.preview.nameplate.hbar.bg:SetTexture(0,0,0,0.85)
  optionsFrame.preview.nameplate.nt = optionsFrame.preview.nameplate:CreateFontString(nil,"ARTWORK","GameFontNormal")
  optionsFrame.preview.nameplate.nt:SetTextColor(1,1,1,0.85)
  optionsFrame.preview.nameplate.lt = optionsFrame.preview.nameplate:CreateFontString(nil,"ARTWORK","GameFontNormal")
  optionsFrame.preview.nameplate.lt:SetTextColor(1,0.4,0.2,0.85)
  optionsFrame.preview.nameplate.rt = optionsFrame.preview.nameplate:CreateTexture(nil, "BORDER")
  optionsFrame.preview.nameplate.rt:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
  optionsFrame.preview.nameplate.ti = optionsFrame.preview.nameplate:CreateTexture(nil, "OVERLAY")
  optionsFrame.preview.nameplate.ti:SetTexture("Interface\\AddOns\\MiniNameplates\\Reticule")
  optionsFrame.preview.nameplate.ci = optionsFrame.preview.nameplate:CreateTexture(nil, "BORDER")
  optionsFrame.preview.nameplate.ci:SetTexture("Interface\\AddOns\\MiniNameplates\\Class\\ClassIcon_Hunter")
  optionsFrame.preview.nameplate.ci:SetTexCoord(.078, .92, .079, .937)
  optionsFrame.preview.nameplate.ci:SetAlpha(0.9)
  optionsFrame.preview.nameplate.cib = optionsFrame.preview.nameplate:CreateTexture(nil, "BACKGROUND")
  optionsFrame.preview.nameplate.cib:SetTexture(0,0,0,0.9)
  optionsFrame.preview.nameplate.cib:SetPoint("CENTER", optionsFrame.preview.nameplate.ci, "CENTER", 0, 0)
  optionsFrame.preview.nameplate.cib:Hide()
  optionsFrame.preview.nameplate.di = {}
  for i=1,16,1 do
    if i<=8 then --first row
      optionsFrame.preview.nameplate.di[i] = optionsFrame.preview.nameplate:CreateTexture(nil, "BORDER")
      optionsFrame.preview.nameplate.di[i]:SetTexture("Interface\\Icons\\Temp")
    elseif i>8 then --second row
      optionsFrame.preview.nameplate.di[i] = optionsFrame.preview.nameplate:CreateTexture(nil, "BORDER")
      optionsFrame.preview.nameplate.di[i]:SetTexture("Interface\\Icons\\Temp")
    end
  end
  optionsFrame.preview.nameplate.UpdatePreview = function()
	  optionsFrame.preview.nameplate:SetWidth(100)
	  optionsFrame.preview.nameplate:SetHeight(6)
	  optionsFrame.preview.nameplate:Show()
	  --optionsFrame.preview.nameplate.hbar:SetStatusBarTexture("Interface\\AddOns\\MiniNameplates\\barSmall")
    optionsFrame.preview.nameplate.hbar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8") --  材质替换
  	optionsFrame.preview.nameplate.hbar:SetAllPoints()
  	optionsFrame.preview.nameplate.hbar.bg:ClearAllPoints()
    optionsFrame.preview.nameplate.hbar.bg:SetPoint("CENTER", optionsFrame.preview.nameplate.hbar, "CENTER", 0, 0)
    optionsFrame.preview.nameplate.hbar.bg:SetWidth(optionsFrame.preview.nameplate.hbar:GetWidth() + 1.5)
    optionsFrame.preview.nameplate.hbar.bg:SetHeight(optionsFrame.preview.nameplate.hbar:GetHeight() + 1.5)
    optionsFrame.preview.nameplate.hbar:SetStatusBarColor(1,0,0,0.9)
    optionsFrame.preview.nameplate.nt:SetFont("Fonts\\FZXHLJW.ttf",12)
    optionsFrame.preview.nameplate.nt:SetPoint("BOTTOM",optionsFrame.preview.nameplate,"CENTER",0,6) -- y + 10
    optionsFrame.preview.nameplate.nt:SetText((UnitName("player")))
    optionsFrame.preview.nameplate.lt:SetFont("Fonts\\FZXHLJW.ttf",11)
    optionsFrame.preview.nameplate.lt:SetPoint("TOPLEFT",optionsFrame.preview.nameplate.nt,"RIGHT",3,4)
    optionsFrame.preview.nameplate.lt:SetText("59")
    optionsFrame.preview.nameplate.rt:SetWidth(15)
    optionsFrame.preview.nameplate.rt:SetHeight(15)
    optionsFrame.preview.nameplate.rt:SetPoint("BOTTOMLEFT",optionsFrame.preview.nameplate,"BOTTOMLEFT",-18,-4)
    SetRaidTargetIconTexture(optionsFrame.preview.nameplate.rt,8)
    optionsFrame.preview.nameplate.ti:SetWidth(25)
    optionsFrame.preview.nameplate.ti:SetHeight(25)
    optionsFrame.preview.nameplate.ti:ClearAllPoints()
    optionsFrame.preview.nameplate.ti:SetPoint("BOTTOM",optionsFrame.preview.nameplate,"TOP",0,15) -- y + 10
    optionsFrame.preview.nameplate.ci:ClearAllPoints()
    optionsFrame.preview.nameplate.ci:SetPoint("RIGHT", optionsFrame.preview.nameplate.nt, "LEFT", -3, -1)
    optionsFrame.preview.nameplate.ci:SetWidth(12)
    optionsFrame.preview.nameplate.ci:SetHeight(12)
    optionsFrame.preview.nameplate.cib:SetWidth(12 + 1.5)
    optionsFrame.preview.nameplate.cib:SetHeight(12 + 1.5)
    for i=1,16,1 do
      if i<=8 then --first row
        optionsFrame.preview.nameplate.di[i]:ClearAllPoints()
        optionsFrame.preview.nameplate.di[i]:SetPoint("BOTTOMLEFT", optionsFrame.preview.nameplate, "BOTTOMLEFT", (i-1) * 12, -13)
        optionsFrame.preview.nameplate.di[i]:SetWidth(12) 
        optionsFrame.preview.nameplate.di[i]:SetHeight(12) 
      elseif i>8 then --second row
        optionsFrame.preview.nameplate.di[i]:ClearAllPoints()
        optionsFrame.preview.nameplate.di[i]:SetPoint("BOTTOMLEFT", optionsFrame.preview.nameplate, "BOTTOMLEFT", (i-9) * 12, -25)
        optionsFrame.preview.nameplate.di[i]:SetWidth(12)
        optionsFrame.preview.nameplate.di[i]:SetHeight(12)
      end
    end
  end
  optionsFrame.preview.nameplate.UpdatePreview()
--[[ADDON.raidicon = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.raidicon
  or {["size"]=15,["point"]="BOTTOMLEFT",["anchorpoint"]="BOTTOMLEFT",["xoffs"]=-18,["yoffs"]=-4}
ADDON.debufficon = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.debufficon
  or {["hide"]=false,["size"]=12,["point"]="BOTTOMLEFT",["anchorpoint"]="BOTTOMLEFT",["row1yoffs"]=-13,["row2yoffs"]=-25}
ADDON.classicon = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.classicon
  or {["hide"]=false,["size"]=12,["point"]="RIGHT",["anchorpoint"]="LEFT",["xoffs"]=-3,["yoffs"]=-1}
ADDON.targetindicator = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.targetindicator
  or {["hide"]=false,["size"]=25,["point"]="BOTTOM",["anchorpoint"]="TOP",["xoffs"]=0,["yoffs"]=-5}]]

--[[ADDON.nametext = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.nametext
  or {["size"]=12,["point"]="BOTTOM",["anchorpoint"]="CENTER",["xoffs"]=0,["yoffs"]=-4,
      ["font"]="Interface\\AddOns\\MiniNameplates\\Fonts\\Ubuntu-C.ttf"}
ADDON.leveltext = _G.MiniNameplatesSettings and _G.MiniNameplatesSettings.leveltext
  or {["hide"]=false,["size"]=11,["point"]="TOPLEFT",["anchorpoint"]="RIGHT",["xoffs"]=3,["yoffs"]=4,
      ["font"]="Interface\\AddOns\\MiniNameplates\\Fonts\\Helvetica_Neue_LT_Com_77_Bold_Condensed.ttf"}]]

  optionsFrame.preview.help = optionsFrame.preview:CreateFontString(nil,"ARTWORK","GameFontDisable")
  optionsFrame.preview.help:SetText("预览")
  optionsFrame.preview.help:SetPoint("BOTTOM",optionsFrame.preview,"BOTTOM",0,8)
  optionsFrame.preview.help:SetPoint("LEFT",optionsFrame.preview,"LEFT",0,8)
  optionsFrame.preview.help:SetPoint("RIGHT",optionsFrame.preview,"RIGHT",0,-8)

  optionsFrame.ModiferCB = function()
    local section, option
    if type(this.option) == "table" then
      section,option = this.option[1],this.option[2]
    else
      option = this.option
    end
    if section then
      MiniNameplatesDBPC[section][option] = this:GetChecked() == 1
    else
      MiniNameplatesDBPC[option] = this:GetChecked() == 1
    end
  end

  optionsFrame.DoubleCB = function()
    MiniNameplatesDBPC.double = this:GetChecked() == 1
  end

  optionsFrame.UpdateSlider = function()
    MiniNameplatesslider1Text:SetText(string.format("刷新: %d FPS",math.ceil(1/MiniNameplatesDBPC.genSettings.refreshRate) or 60))
    --MiniNameplatesslider2Text:SetText(string.format(MiniNameplates_OPTIONS_HOVER_TIME,string.sub(MiniNameplatesDBPC.hovertime,1,4) or 0.2))
  end

  optionsFrame.DoubleSlider = function()
  	local section, option
    if type(this.option) == "table" then
      section,option = this.option[1],this.option[2]
    else
      option = this.option
    end
    local val = tonumber(this:GetValue())
    if section then
      MiniNameplatesDBPC[section][option] = 1/val
    else
      MiniNameplatesDBPC[option] = 1/val
    end 
    optionsFrame.UpdateSlider()
  end

  optionsFrame.enableAddOn:SetScript("OnClick",optionsFrame.ModiferCB)
  optionsFrame.showFriendly:SetScript("OnClick",optionsFrame.ModiferCB)
  optionsFrame.combatOnly:SetScript("OnClick",optionsFrame.ModiferCB)
  optionsFrame.showPets:SetScript("OnClick",optionsFrame.ModiferCB)
  optionsFrame.clickThrough:SetScript("OnClick",optionsFrame.ModiferCB)

  optionsFrame.doublecb:SetScript("OnClick",optionsFrame.DoubleCB)
  optionsFrame.refreshRate:SetScript("OnValueChanged",optionsFrame.DoubleSlider)
  optionsFrame.hovertime:SetScript("OnValueChanged",optionsFrame.DoubleSlider)
  optionsFrame.doublehover:SetScript("OnClick",optionsFrame.ModiferCB)

  optionsFrame.bindinghover:SetScript("OnClick",optionsFrame.ModiferCB)

  optionsFrame.UpdateBindings = function()
    local binding1, _ = GetBindingKey("NAMEPLATES")
    local binding2, _ = GetBindingKey("FRIENDNAMEPLATES")
    if ( binding1 ) then
      optionsFrame.bindingkey1:SetText(GetBindingText(binding1, "KEY_"))
      optionsFrame.bindingkey1:SetAlpha(1)
    else
      optionsFrame.bindingkey1:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE)
      optionsFrame.bindingkey1:SetAlpha(0.8)
    end
    if ( binding2 ) then
      optionsFrame.bindingkey2:SetText(GetBindingText(binding2, "KEY_"))
      optionsFrame.bindingkey2:SetAlpha(1)
    else
      optionsFrame.bindingkey2:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE)
      optionsFrame.bindingkey2:SetAlpha(0.8)
    end
  end

  optionsFrame.Update = function()
    optionsFrame.enableAddOn:SetChecked(MiniNameplatesDBPC.genSettings.enableAddOn and 1 or 0)
    optionsFrame.showFriendly:SetChecked(MiniNameplatesDBPC.genSettings.showFriendly and 1 or 0)
    optionsFrame.combatOnly:SetChecked(MiniNameplatesDBPC.genSettings.combatOnly and 1 or 0)
    optionsFrame.showPets:SetChecked(MiniNameplatesDBPC.genSettings.showPets and 1 or 0)
    optionsFrame.clickThrough:SetChecked(MiniNameplatesDBPC.genSettings.clickThrough and 1 or 0)
    local refreshRateVal = tonumber(math.ceil(1/MiniNameplatesDBPC.genSettings.refreshRate))
    optionsFrame.refreshRate:SetValue(refreshRateVal or 60)
    optionsFrame.hovertime:SetValue(MiniNameplatesDBPC.hovertime or 0.2)
    optionsFrame.doublecb:SetChecked(MiniNameplatesDBPC.double or 0)
    optionsFrame.doublehover:SetChecked(MiniNameplatesDBPC.doublehover or 0)

    optionsFrame.UpdateSlider()
    optionsFrame.UpdateBindings()
  end

  optionsFrame:SetScript("OnShow", optionsFrame.Update)

  optionsFrame.Update()
  optionsFrame:Hide()
  return optionsFrame

end

_G["MiniNameplatesOptions"] = Options
