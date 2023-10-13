-- haxninja
BINDING_NAME_UndressButtonName = "Open the DressUp Frame";
BINDING_HEADER_UndressButtonHeader = "Undress Button";
UndressButtonHistory = {};
UndressButtonHistory["int"] = 0;

function UBLoad()
	if (not AuctionDressUpFrame) then
		this:RegisterEvent("ADDON_LOADED");
	end
	-- Hooks the DressUp function that will block the Guild Tabard \o/
	ODressUpItem = DressUpItem;
	DressUpItem = UBDressUpItem;
end

function UBHistory(way)
	if (UndressButtonHistory["int"] == 1) then
		if (way == "+") then
			if (UBHcur ~= UndressButtonHistory["max"]) then
				DressUpModel:Undress();
				UBHcur = UBHcur +1;
				for int = 1, UBHcur do
					ODressUpItem(UndressButtonHistory[int]);
				end
			end
		elseif (way == "-") then
			if (UBHcur >= 1) then
				DressUpModel:Undress();
				UBHcur = UBHcur -1;
				if (UBHcur > 0) then
					for int = 1, UBHcur do
						ODressUpItem(UndressButtonHistory[int]);
					end
				else
					DressUpModel:Undress();
				end
			end
		end
	end
end

function necho(msg)
	ChatFrame1:AddMessage(msg);
end

function UBDressUpItem(item)
	-- This will completely block CTRL-clicking the Guild Tabard for display in the Dressing Room.
	if (item ~= "5976") then
		for int = 1, 100 do
			if (not UndressButtonHistory[int]) then
				UndressButtonHistory[int] = item;
				UBHcur = int;
				UndressButtonHistory["max"] = int;
				UndressButtonHistory["int"] = 1;
				break;
			end
		end
		ODressUpItem(item);
	end
end

function UBEvent()
	if (event == "ADDON_LOADED") then
		if (arg1 == "Blizzard_AuctionUI") then
			this:UnregisterEvent("ADDON_LOADED");
			AuctionDressUpFrameUndressButton:SetPoint("BOTTOM", "AuctionDressUpFrameResetButton", "TOP", 0, 2);
			AuctionDressUpFrameUndressButton:SetParent("AuctionDressUpModel");
			AuctionDressUpFrameUndressButton:SetFrameLevel(AuctionDressUpFrameResetButton:GetFrameLevel());
		end
	end
end

function UBReset()
	SetPortraitTexture(DressUpFramePortrait, "player");
	SetDressUpBackground();
	DressUpModel:SetUnit("player");
end

function UBDressUpTarget(x)
	if (not DressUpFrame:IsVisible()) then
		ShowUIPanel(DressUpFrame);
	else
		PlaySound("gsTitleOptionOK");
	end
	if (x == "inspect") then
		if(UnitIsVisible("target")) then
			SetPortraitTexture(DressUpFramePortrait, "target");
			SetDressUpTargetBackground();
			DressUpModel:SetUnit("target");
		else
			UBReset();
		end
	elseif (x == "dress") then
		if(UnitIsVisible("target") and UnitIsPlayer("target") and UnitIsFriend("player","target")) then
			DressUpModel:Undress();
			UndressButton_Inspect("target");
		else
			UBReset();
		end
	end
end

function UndressButton_Inspect()
	DressUpItemLink(GetInventoryItemLink("target", InspectHeadSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectNeckSlot:GetID())); 
	DressUpItemLink(GetInventoryItemLink("target", InspectShoulderSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectBackSlot:GetID())); 
	DressUpItemLink(GetInventoryItemLink("target", InspectChestSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectShirtSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectTabardSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectWristSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectHandsSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectWaistSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectLegsSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectFeetSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectMainHandSlot:GetID()));
	DressUpItemLink(GetInventoryItemLink("target", InspectSecondaryHandSlot:GetID()));
	--DressUpItemLink(GetInventoryItemLink("target", InspectRangedSlot:GetID()));
end

function DressUpTargetTexturePath()
	local race, fileName = UnitRace("target");
	if ( fileName == "侏儒" or fileName == "GNOME" ) then
		fileName = "矮人";
	elseif ( fileName == "巨魔" or fileName == "TROLL" ) then
		fileName = "兽人";
	end
	if ( not fileName ) then
		fileName = "兽人";
	end

	return "Interface\\DressUpFrame\\DressUpBackground-"..fileName;
end

function SetDressUpTargetBackground()
	local texture = DressUpTargetTexturePath();
	DressUpBackgroundTopLeft:SetTexture(texture..1);
	DressUpBackgroundTopRight:SetTexture(texture..2);
	DressUpBackgroundBotLeft:SetTexture(texture..3);
	DressUpBackgroundBotRight:SetTexture(texture..4);
end

function DressUpPlayerTexturePath()
	local race, fileName = UnitRace("player");
	if ( fileName == "侏儒" or fileName == "GNOME" ) then
		fileName = "矮人";
	elseif ( fileName == "巨魔" or fileName == "TROLL" ) then
		fileName = "兽人";
	end
	if ( not fileName ) then
		fileName = "兽人";
	end

	return "Interface\\DressUpFrame\\DressUpBackground-"..fileName;
end

function SetDressUpPlayerBackground()
	local texture = DressUpPlayerTexturePath();
	DressUpBackgroundTopLeft:SetTexture(texture..1);
	DressUpBackgroundTopRight:SetTexture(texture..2);
	DressUpBackgroundBotLeft:SetTexture(texture..3);
	DressUpBackgroundBotRight:SetTexture(texture..4);
end