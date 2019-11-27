--	Player class colors.
local function whoaUnitClass(healthbar, unit)
	if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
		_, class = UnitClass(unit);
		local class = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class];
		healthbar:SetStatusBarColor(class.r, class.g, class.b);
	elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
		healthbar:SetStatusBarColor(0.5,0.5,0.5);
	else
		healthbar:SetStatusBarColor(0,0.9,0);
	end
end
hooksecurefunc("UnitFrameHealthBar_Update", whoaUnitClass)
hooksecurefunc("HealthBar_OnValueChanged", function(self) whoaUnitClass(self, self.unit) end)

--	Unit faction colors.
local function whoaUnitReaction(healthbar, unit)
	if UnitExists(unit) and (not UnitIsPlayer(unit)) then
		if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
			healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
		elseif (not UnitIsTapDenied(unit)) then
			local reaction = FACTION_BAR_COLORS[UnitReaction(unit,"player")];
			if reaction then
				healthbar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
			else
				healthbar:SetStatusBarColor(0,0.6,0.1)
			end
		end
				--healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
	end
end
hooksecurefunc("TargetFrame_CheckFaction", whoaUnitReaction)
hooksecurefunc("UnitFrameHealthBar_Update", whoaUnitReaction)
hooksecurefunc("HealthBar_OnValueChanged", function(self) whoaUnitReaction(self, self.unit) end)

---------------------------------------------------------------------------------	Aura positioning constants.
local LARGE_AURA_SIZE, SMALL_AURA_SIZE, AURA_OFFSET_Y, AURA_ROW_WIDTH, NUM_TOT_AURA_ROWS = 21, 16, 1, 128, 2   -- Set aura size.
hooksecurefunc("TargetFrame_UpdateAuraPositions", function(self, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX, mirrorAurasVertically)
	local offsetY = AURA_OFFSET_Y;
	local rowWidth = 0;
	local firstBuffOnRow = 1;
	for i=1, numAuras do
		if ( largeAuraList[i] ) then
			size = LARGE_AURA_SIZE;
			offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y;
		else
			size = SMALL_AURA_SIZE;
		end
		if ( i == 1 ) then
			rowWidth = size;
			self.auraRows = self.auraRows + 1;
		else
			rowWidth = rowWidth + size + offsetX;
		end
		if ( rowWidth > maxRowWidth ) then
			updateFunc(self, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically);
			rowWidth = size;
			self.auraRows = self.auraRows + 1;
			firstBuffOnRow = i;
			offsetY = AURA_OFFSET_Y;
			if ( self.auraRows > NUM_TOT_AURA_ROWS ) then
				maxRowWidth = AURA_ROW_WIDTH;
			end
		else
			updateFunc(self, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically);
		end
	end
end)
--[[	Player frame dead text.
hooksecurefunc("TextStatusBar_UpdateTextStringWithValues",function(self)
	local deadText = DEAD;
	local ghostText = "Ghost";
	
	if UnitIsDead("player") or UnitIsGhost("player") then
		PlayerFrameHealthBarText:SetFontObject(GameFontNormalSmall);
		for i, v in pairs({	PlayerFrameHealthBar.LeftText, PlayerFrameHealthBar.RightText, PlayerFrameManaBar.LeftText, PlayerFrameManaBar.RightText, PlayerFrameTextureFrameManaBarText, PlayerFrameManaBar }) do v:SetAlpha(0); end
		if GetCVar("statusTextDisplay")=="BOTH" then
			PlayerFrameHealthBarText:Show();
		end
		if UnitIsDead("player") then
			PlayerFrameHealthBarText:SetText(deadText);
		elseif UnitIsGhost("player") then
			PlayerFrameHealthBarText:SetText(ghostText);
		end
	elseif not UnitIsDead("player") and not UnitIsGhost("player") then
		PlayerFrameHealthBarText:SetFontObject(TextStatusBarText);
		for i, v in pairs({	PlayerFrameHealthBar.LeftText, PlayerFrameHealthBar.RightText, PlayerFrameManaBar.LeftText, PlayerFrameManaBar.RightText, PlayerFrameTextureFrameManaBarText, PlayerFrameManaBar }) do v:SetAlpha(1); end
	end
	
--	Target frame ghost text.
	if UnitExists("target") and UnitIsDead("target") or UnitIsGhost("target") then
		TargetFrameTextureFrameHealthBarText:SetFontObject(GameFontNormalSmall);
		if GetCVar("statusTextDisplay")=="BOTH" then
			TargetFrameTextureFrameHealthBarText:Show();
		end
		for i, v in pairs({	TargetFrameHealthBar.LeftText, TargetFrameHealthBar.RightText, TargetFrameManaBar.LeftText, TargetFrameManaBar.RightText, TargetFrameTextureFrameManaBarText, TargetFrameManaBar }) do v:SetAlpha(0); end
		if UnitIsGhost("target") then
			TargetFrameTextureFrameHealthBarText:SetText(ghostText);
		end
	elseif not UnitIsDead("target") and not UnitIsGhost("target") then
		TargetFrameTextureFrameHealthBarText:SetFontObject(TextStatusBarText);
		for i, v in pairs({	TargetFrameHealthBar.LeftText, TargetFrameHealthBar.RightText, TargetFrameManaBar.LeftText, TargetFrameManaBar.RightText, TargetFrameTextureFrameManaBarText, TargetFrameManaBar }) do v:SetAlpha(1); end
	end
	
--	Focus frame ghost text.
	if UnitExists("focus") and UnitIsDead("focus") or UnitIsGhost("focus") then
		FocusFrameTextureFrameHealthBarText:SetFontObject(GameFontNormalSmall);
		if GetCVar("statusTextDisplay")=="BOTH" then
			FocusFrameTextureFrameHealthBarText:Show();
		end
		for i, v in pairs({	FocusFrameHealthBar.LeftText, FocusFrameHealthBar.RightText, FocusFrameManaBar.LeftText, FocusFrameManaBar.RightText, FocusFrameTextureFrameManaBarText, FocusFrameManaBar }) do v:SetAlpha(0); end
		if UnitIsGhost("focus") then
			FocusFrameTextureFrameHealthBarText:SetText(ghostText);
		end
	elseif not UnitIsDead("focus") and not UnitIsGhost("focus") then
		FocusFrameTextureFrameHealthBarText:SetFontObject(TextStatusBarText);
		for i, v in pairs({	FocusFrameHealthBar.LeftText, FocusFrameHealthBar.RightText, FocusFrameManaBar.LeftText, FocusFrameManaBar.RightText, FocusFrameTextureFrameManaBarText, FocusFrameManaBar }) do v:SetAlpha(1); end
	end
end)]]
--	Player frame.
hooksecurefunc("PlayerFrame_ToPlayerArt", function(self)
		PlayerFrameTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame");
		PlayerStatusTexture:SetTexture("Interface\\AddOns\\_ShiGuang\\Media\\Modules\\UFs\\UI-Player-Status");
	PlayerFrameBackground:SetWidth(120);
		self.name:Hide();
		--self.name:ClearAllPoints();
		--self.name:SetPoint("CENTER", PlayerFrame, "CENTER",50.5, 36);
		self.healthbar:SetPoint("TOPLEFT",106,-24);
		self.healthbar:SetHeight(28);
		self.healthbar.LeftText:ClearAllPoints();
		self.healthbar.LeftText:SetPoint("LEFT",self.healthbar,"LEFT",5,0);	
		self.healthbar.RightText:ClearAllPoints();
		self.healthbar.RightText:SetPoint("RIGHT",self.healthbar,"RIGHT",-5,0);
		self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0);
		self.manabar.LeftText:ClearAllPoints();
		self.manabar.LeftText:SetPoint("LEFT",self.manabar,"LEFT",5,0)		;
		self.manabar.RightText:ClearAllPoints();
		self.manabar.RightText:SetPoint("RIGHT",self.manabar,"RIGHT",-5,0);
		self.manabar.TextString:SetPoint("CENTER",self.manabar,"CENTER",0,0);
		--PlayerFrameGroupIndicatorText:ClearAllPoints();
		--PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame,"TOP",0,-20);
		PlayerFrameGroupIndicatorLeft:Hide();
		PlayerFrameGroupIndicatorMiddle:Hide();
		PlayerFrameGroupIndicatorRight:Hide();
end)
		--self.healthbar.LeftText:SetFontObject(SystemFont_Outline_Small);
		--self.healthbar.RightText:SetFontObject(SystemFont_Outline_Small);
		--self.manabar.TextString:SetFontObject(SystemFont_Outline_Small);
		--self.manabar.LeftText:SetFontObject(SystemFont_Outline_Small);
		--self.manabar.RightText:SetFontObject(SystemFont_Outline_Small);
--	Player vehicle frame.
hooksecurefunc("PlayerFrame_ToVehicleArt", function(self, vehicleType)
		if ( vehicleType == "Natural" ) then
		PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Organic");
		PlayerFrameFlash:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Organic-Flash");
		PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86);
		self.healthbar:SetSize(103,12);
		self.healthbar:SetPoint("TOPLEFT",116,-41);
		self.manabar:SetSize(103,12);
		self.manabar:SetPoint("TOPLEFT",116,-52);
	else
		PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame");
		PlayerFrameFlash:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Flash");
		PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86);
		self.healthbar:SetSize(100,12);
		self.healthbar:SetPoint("TOPLEFT",119,-41);
		self.manabar:SetSize(100,12);
		self.manabar:SetPoint("TOPLEFT",119,-52);
	end
	PlayerName:SetPoint("CENTER",50,23);
	PlayerFrameBackground:SetWidth(114);
end)

-- Pet frame
--[[hooksecurefunc("PlayerFrame_ToPlayerArt", function()
		PetFrameHealthBarTextLeft:SetPoint("LEFT",PetFrameHealthBar,"LEFT",0,0);
		PetFrameHealthBarTextRight:SetPoint("RIGHT",PetFrameHealthBar,"RIGHT",0,0);
		PetFrameManaBarText:SetPoint("CENTER",PetFrameManaBar,"CENTER",0,-3);
		PetFrameManaBarTextLeft:SetPoint("LEFT",PetFrameManaBar,"LEFT",0,-3);
		PetFrameManaBarTextRight:SetPoint("RIGHT",PetFrameManaBar,"RIGHT",0,-3);
		PetFrameHealthBarText:SetFontObject(SystemFont_Outline_Small);
		PetFrameHealthBarTextLeft:SetFontObject(SystemFont_Outline_Small);
		PetFrameHealthBarTextRight:SetFontObject(SystemFont_Outline_Small);
		PetFrameManaBarText:SetFontObject(SystemFont_Outline_Small);
		PetFrameManaBarTextLeft:SetFontObject(SystemFont_Outline_Small);
		PetFrameManaBarTextRight:SetFontObject(SystemFont_Outline_Small);
end)]]

hooksecurefunc("PetFrame_Update", function(self, override)
	if ( (not PlayerFrame.animating) or (override) ) then
		if ( UnitIsVisible(self.unit) and PetUsesPetFrame() and not PlayerFrame.vehicleHidesPet ) then
			if ( UnitPowerMax(self.unit) == 0 ) then
					PetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-SmallTargetingFrame-NoMana");
				PetFrameManaBarText:Hide();
			else
					PetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-SmallTargetingFrame");
			end
		end
	end
end)

local function whoaPetFrameBg()
	local f = CreateFrame("Frame",nil,PetFrame)
	f:SetFrameStrata("BACKGROUND")
	f:SetSize(70,18);
	local t = f:CreateTexture(nil,"BACKGROUND")
	t:SetColorTexture(0, 0, 0, 0.5)
	t:SetAllPoints(f)
	f.texture = t
	f:SetPoint("CENTER",16,-5);
	f:Show()
end
whoaPetFrameBg();


--	Target frame
hooksecurefunc("TargetFrame_CheckClassification", function(self, forceNormalTexture)
	local classification = UnitClassification(self.unit);
	self.highLevelTexture:ClearAllPoints();
	self.highLevelTexture:SetPoint("CENTER", self.levelText, "CENTER", 0,0);
	self.deadText:SetFont(STANDARD_TEXT_FONT,21,"OUTLINE")
	self.deadText:SetPoint("TOPLEFT", self.healthbar, "TOPRIGHT", 12, -8)
	self.nameBackground:Hide();
	self.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash");
	self.name:SetPoint("LEFT", self, 15, 36);
	self.healthbar:SetSize(119, 28);
	self.healthbar:SetPoint("TOPLEFT", 5, -24);
	self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 5, 0);
	self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -3, 0);
	self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0);
	self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 2, -1);	
	self.manabar.RightText:ClearAllPoints();
	self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -2, -1);
	self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, -1);
	--TargetFrame.threatNumericIndicator:SetPoint("BOTTOM", PlayerFrame, "TOP", 72, -21);
	--TargetFrame.threatNumericIndicator:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", -66, -3);
	if ( forceNormalTexture ) then
		self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 88, -8, "NumberFontNormalLarge", 36)
	elseif ( UnitClassification(self.unit) == "minus" ) then
		self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus");
		forceNormalTexture = true;
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 66, 0, "NumberFontNormalLarge", 36)
	elseif ( UnitClassification(self.unit) == "worldboss" or UnitClassification(self.unit) == "elite" ) then
		self.borderTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame-Elite");
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 102, -8, "NumberFontNormalLarge", 36)
	elseif ( UnitClassification(self.unit) == "rareelite" ) then
		self.borderTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame-Rare-Elite");
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 102, -8, "NumberFontNormalLarge", 36)
	elseif ( UnitClassification(self.unit) == "rare" ) then
		self.borderTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame-Rare");
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 102, -8, "NumberFontNormalLarge", 36)
	else
		self.borderTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame");
		forceNormalTexture = true;
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 88, -8, "NumberFontNormalLarge", 36)
	end
	if ( forceNormalTexture ) then
		self.haveElite = nil;
		if ( UnitClassification(self.unit) == "minus" ) then
			self.Background:SetSize(119,12);
			self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 47);
			self.name:SetPoint("LEFT", self, 16, 19);
			self.healthbar:ClearAllPoints();
			self.healthbar:SetPoint("LEFT", 5, 3);
			self.healthbar:SetHeight(12);
			self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 3, 0);
			self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -2, 0);
		else
			self.Background:SetSize(119,42);
			self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 35);
		end
		if ( self.threatIndicator ) then
			if ( UnitClassification(self.unit) == "minus" ) then
				self.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus-Flash");
				self.threatIndicator:SetTexCoord(0, 1, 0, 1);
				self.threatIndicator:SetWidth(256);
				self.threatIndicator:SetHeight(128);
				self.threatIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -24, 0);
			else
				self.threatIndicator:SetTexCoord(0, 0.9453125, 0, 0.181640625);
				self.threatIndicator:SetWidth(242);
				self.threatIndicator:SetHeight(93);
				self.threatIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -24, 0);
			end
		end	
	else
		self.haveElite = true;
		self.Background:SetSize(119,42);
		if ( self.threatIndicator ) then
			self.threatIndicator:SetTexCoord(0, 0.9453125, 0.181640625, 0.400390625);
			self.threatIndicator:SetWidth(242);
			self.threatIndicator:SetHeight(112);
		end		
	end
	self.healthbar.lockColor = true;
end)

-- Mana texture
hooksecurefunc("UnitFrameManaBar_UpdateType", function(manaBar)
	local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit);
	local info = PowerBarColor[powerToken];
	if ( info ) then
		if ( not manaBar.lockColor ) then
			if not ( info.atlas ) then
				manaBar:SetStatusBarTexture("Interface\\Addons\\_ShiGuang\\Media\\Skullflower3");
			end
		end
	end
end)

--[[function CreateStatusBarText(name, parentName, parent, point, x, y)
	local fontString = parent:CreateFontString(parentName..name, nil, "TextStatusBarText")
	fontString:SetPoint(point, parent, point, x, y)
	return fontString
end
function whoaStatustextFrame()
		TargetFrameHealthBar.TextString = CreateStatusBarText("Text", "TargetFrameHealthBar", TargetFrameTextureFrame, "CENTER", 0, 0);
		TargetFrameHealthBar.LeftText = CreateStatusBarText("TextLeft", "TargetFrameHealthBar", TargetFrameTextureFrame, "LEFT", 5, 0);
		TargetFrameHealthBar.RightText = CreateStatusBarText("TextRight", "TargetFrameHealthBar", TargetFrameTextureFrame, "RIGHT", -3, 0);
		TargetFrameManaBar.TextString = CreateStatusBarText("Text", "TargetFrameManaBar", TargetFrameTextureFrame, "CENTER", 0, 0);
		TargetFrameManaBar.LeftText = CreateStatusBarText("TextLeft", "TargetFrameManaBar", TargetFrameTextureFrame, "LEFT", 5, 0);
		TargetFrameManaBar.RightText = CreateStatusBarText("TextRight", "TargetFrameManaBar", TargetFrameTextureFrame, "RIGHT", -3, 0);
end
whoaStatustextFrame()]]

--	ToT & ToF
function whoaFrameToTF()
	TargetFrameToTTextureFrameDeadText:ClearAllPoints();
	TargetFrameToTTextureFrameDeadText:SetPoint("CENTER", "TargetFrameToTHealthBar","CENTER",1, 0);
	TargetFrameToTTextureFrameName:SetSize(65,10);
	TargetFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetofTargetFrame");
	TargetFrameToTHealthBar:ClearAllPoints();
	TargetFrameToTHealthBar:SetPoint("TOPLEFT", 45, -15);
    TargetFrameToTHealthBar:SetHeight(10);
    TargetFrameToTManaBar:ClearAllPoints();
    TargetFrameToTManaBar:SetPoint("TOPLEFT", 45, -25);
    TargetFrameToTManaBar:SetHeight(5);
	TargetFrameToTBackground:SetSize(50,14);
	TargetFrameToTBackground:ClearAllPoints();
	TargetFrameToTBackground:SetPoint("CENTER", "TargetFrameToT","CENTER",20, 0);
	FocusFrameToTTextureFrameDeadText:ClearAllPoints();
	FocusFrameToTTextureFrameDeadText:SetPoint("CENTER", "FocusFrameToTHealthBar" ,"CENTER",1, 0);
	FocusFrameToTTextureFrameName:SetSize(65,10);
	FocusFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetofTargetFrame");
	FocusFrameToTHealthBar:ClearAllPoints();
    FocusFrameToTHealthBar:SetPoint("TOPLEFT", 43, -15);
    FocusFrameToTHealthBar:SetHeight(10);
    FocusFrameToTManaBar:ClearAllPoints();
    FocusFrameToTManaBar:SetPoint("TOPLEFT", 43, -25);
    FocusFrameToTManaBar:SetHeight(5);
end
hooksecurefunc("TargetofTarget_Update", whoaFrameToTF)
hooksecurefunc("TargetFrame_CheckClassification", whoaFrameToTF)

--	Boss target frames.
--[[function whoaBossFrames()
	for i = 1, MAX_BOSS_FRAMES do
		_G["Boss"..i.."TargetFrameTextureFrameDeadText"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameTextureFrameDeadText"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrameHealthBar"],"CENTER",0,0);
		_G["Boss"..i.."TargetFrameTextureFrameName"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameTextureFrameName"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrameManaBar"],"CENTER",0,0);
		_G["Boss"..i.."TargetFrameTextureFrameTexture"]:SetTexture("Interface\\Addons\\whoaUnitFrames\\media\\UI-UNITFRAME-BOSS");
		_G["Boss"..i.."TargetFrameNameBackground"]:Hide();
		_G["Boss"..i.."TargetFrameHealthBar"]:SetSize(116,18);
		_G["Boss"..i.."TargetFrameHealthBar"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameHealthBar"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrame"],"CENTER",-51,18);
		_G["Boss"..i.."TargetFrameManaBar"]:SetSize(116,18);
		_G["Boss"..i.."TargetFrameManaBar"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameManaBar"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrame"],"CENTER",-51,-3);
		_G["Boss"..i.."TargetFrameTextureFrameHealthBarTextLeft"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameTextureFrameHealthBarTextLeft"]:SetPoint("LEFT",_G["Boss"..i.."TargetFrameHealthBar"],"LEFT",0,0);
		_G["Boss"..i.."TargetFrameTextureFrameHealthBarTextRight"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameTextureFrameHealthBarTextRight"]:SetPoint("RIGHT",_G["Boss"..i.."TargetFrameHealthBar"],"RIGHT",0,0);
		_G["Boss"..i.."TargetFrameTextureFrameHealthBarText"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameTextureFrameHealthBarText"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrameHealthBar"],"CENTER",0,0);
		_G["Boss"..i.."TargetFrameTextureFrameManaBarTextLeft"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameTextureFrameManaBarTextLeft"]:SetPoint("LEFT",_G["Boss"..i.."TargetFrameManaBar"],"LEFT",0,0);
		_G["Boss"..i.."TargetFrameTextureFrameManaBarTextRight"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameTextureFrameManaBarTextRight"]:SetPoint("RIGHT",_G["Boss"..i.."TargetFrameManaBar"],"RIGHT",0,0);
		_G["Boss"..i.."TargetFrameTextureFrameManaBarText"]:ClearAllPoints();
		_G["Boss"..i.."TargetFrameTextureFrameManaBarText"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrameManaBar"],"CENTER",0,0);
	end
end
whoaBossFrames();
hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function()
	for i = 1, MAX_BOSS_FRAMES do
		_G["Boss"..i.."TargetFrameTextureFrameManaBarTextLeft"]:SetText(" ");
		_G["Boss"..i.."TargetFrameTextureFrameManaBarTextRight"]:SetText(" ");
		_G["Boss"..i.."TargetFrameTextureFrameManaBarText"]:SetText(" ");
	end
end)]]

--	Party Frames.
function whoaPartyFrames()
	local useCompact = GetCVarBool("useCompactPartyFrames");
	if IsInGroup(player) and (not IsInRaid(player)) and (not useCompact) then 
		for i = 1, 4 do
			_G["PartyMemberFrame"..i.."Name"]:SetSize(80,12);
			_G["PartyMemberFrame"..i.."Name"]:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
			_G["PartyMemberFrame"..i.."Texture"]:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-PartyFrame");
			_G["PartyMemberFrame"..i.."Flash"]:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-PARTYFRAME-FLASH");
			_G["PartyMemberFrame"..i.."HealthBar"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."HealthBar"]:SetPoint("TOPLEFT", 45, -13);
			_G["PartyMemberFrame"..i.."HealthBar"]:SetHeight(12);
			_G["PartyMemberFrame"..i.."ManaBar"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."ManaBar"]:SetPoint("TOPLEFT", 45, -26);
			_G["PartyMemberFrame"..i.."ManaBar"]:SetHeight(5);
			--_G["PartyMemberFrame"..i.."HealthBarTextLeft"]:SetText(" ");
			_G["PartyMemberFrame"..i.."HealthBarTextLeft"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."HealthBarTextLeft"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."HealthBar"], "LEFT", 0, 0);
			--_G["PartyMemberFrame"..i.."HealthBarTextRight"]:SetText(" ");
			_G["PartyMemberFrame"..i.."HealthBarTextRight"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."HealthBarTextRight"]:SetPoint("RIGHT", _G["PartyMemberFrame"..i.."HealthBar"], "RIGHT", 0, 0);
			--_G["PartyMemberFrame"..i.."ManaBarTextLeft"]:SetText(" ");
			_G["PartyMemberFrame"..i.."ManaBarTextLeft"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."ManaBarTextLeft"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."ManaBar"], "LEFT", 0, 0);
			--_G["PartyMemberFrame"..i.."ManaBarTextRight"]:SetText(" ");
			_G["PartyMemberFrame"..i.."ManaBarTextRight"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."ManaBarTextRight"]:SetPoint("RIGHT", _G["PartyMemberFrame"..i.."ManaBar"], "RIGHT", 0, 0);
			--_G["PartyMemberFrame"..i.."HealthBarText"]:SetText(" ");
			_G["PartyMemberFrame"..i.."HealthBarText"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."HealthBarText"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."HealthBar"], "RIGHT", 0, 0);
			--_G["PartyMemberFrame"..i.."ManaBarText"]:SetText(" ");
			_G["PartyMemberFrame"..i.."ManaBarText"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."ManaBarText"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."ManaBar"], "RIGHT", 0, 0);
			
		end
	end
end
hooksecurefunc("UnitFrame_Update", whoaPartyFrames)
hooksecurefunc("PartyMemberFrame_ToPlayerArt", whoaPartyFrames)
--------------------------------------------------------------------------------------whoa end