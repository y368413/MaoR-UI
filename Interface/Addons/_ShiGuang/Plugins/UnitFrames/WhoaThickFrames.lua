function CreateBarPctText(frame, ap, rp, x, y, font, fontsize)
	local bar = frame.healthbar 
	if bar then
		if bar.pctText then
			bar.pctText:ClearAllPoints()
			bar.pctText:SetPoint(ap, bar, rp, x, y)
		else
			bar.pctText = frame:CreateFontString(nil, "OVERLAY", font)
			bar.pctText:SetPoint(ap, bar, rp, x, y)
			bar.pctText:SetFont("Interface\\addons\\_ShiGuang\\Media\\Fonts\\Pixel.TTF", fontsize, "OUTLINE")
			bar.pctText:SetShadowColor(0, 0, 0)
		end
	end
end
CreateBarPctText(PlayerFrame, "RIGHT", "LEFT", -80, -8, "NumberFontNormalLarge", 36)
CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 80, -8, "NumberFontNormalLarge", 36)
--CreateBarPctText(TargetFrameToT, "BOTTOMLEFT", "TOPRIGHT", 0, 5)
--CreateBarPctText(FocusFrame, "RIGHT", "LEFT", -3, -8, "NumberFontNormalLarge")
--CreateBarPctText(FocusFrameToT, "BOTTOMLEFT", "TOP", 24, 10)
for i = 1, 4 do CreateBarPctText(_G["PartyMemberFrame"..i], "LEFT", "RIGHT", 6, 0, "NumberFontNormal", 16) end
--for i = 1, MAX_BOSS_FRAMES do CreateBarPctText(_G["Boss"..i.."TargetFrame"], "LEFT", "RIGHT", 8, 30, "NumberFontNormal", 36) end	

--	Player class colors.
local function whoaUnitClass(healthbar, unit)
	if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
		_, class = UnitClass(unit);
		local c = RAID_CLASS_COLORS[class];
		healthbar:SetStatusBarColor(c.r, c.g, c.b);
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
	end
end
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

local function CreateStatusBarText(name, parentName, parent, point, x, y)
	local fontString = parent:CreateFontString(parentName..name, nil, "TextStatusBarText")
	fontString:SetPoint(point, parent, point, x, y)
	return fontString
end

--	Player frame.
hooksecurefunc("PlayerFrame_ToPlayerArt", function(self)
		PlayerFrameTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame");
		PlayerStatusTexture:SetTexture("Interface\\AddOns\\_ShiGuang\\Media\\Modules\\UFs\\UI-Player-Status");
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

--	Target frame
hooksecurefunc("TargetFrame_CheckClassification", function(self, forceNormalTexture)
	local classification = UnitClassification(self.unit);
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
	--TargetFrame.threatNumericIndicator:SetPoint("BOTTOM", PlayerFrame, "TOP", 72, -21);
	--TargetFrame.threatNumericIndicator:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", -66, -3);
	FocusFrame.threatNumericIndicator:SetAlpha(0);
	if ( forceNormalTexture ) then
		self.haveElite = nil;
		if ( classification == "minus" ) then
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
			if ( classification == "minus" ) then
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
	if ( forceNormalTexture ) then
		self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 88, -8, "NumberFontNormalLarge", 36)
	elseif ( classification == "minus" ) then
		self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus");
		forceNormalTexture = true;
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 66, 0, "NumberFontNormalLarge", 36)
	elseif ( classification == "worldboss" or classification == "elite" ) then
		self.borderTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame-Elite");
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 102, -8, "NumberFontNormalLarge", 36)
	elseif ( classification == "rareelite" ) then
		self.borderTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame-Rare-Elite");
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 102, -8, "NumberFontNormalLarge", 36)
	elseif ( classification == "rare" ) then
		self.borderTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame-Rare");
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 102, -8, "NumberFontNormalLarge", 36)
	else
		self.borderTexture:SetTexture("Interface\\Addons\\_ShiGuang\\Media\\Modules\\UFs\\UI-TargetingFrame");
		forceNormalTexture = true;
		CreateBarPctText(TargetFrame, "LEFT", "RIGHT", 88, -8, "NumberFontNormalLarge", 36)
	end
	if ( self.showPVP ) then
		local factionGroup = UnitFactionGroup(self.unit);
		if ( UnitIsPVPFreeForAll(self.unit) ) then
				self.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		elseif ( factionGroup and factionGroup ~= "Neutral" and UnitIsPVP(self.unit) ) then
				self.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		end
	end
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
			_G["PartyMemberFrame"..i.."HealthBarTextLeft"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."HealthBarTextLeft"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."HealthBar"], "LEFT", 0, 0);
			_G["PartyMemberFrame"..i.."HealthBarTextRight"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."HealthBarTextRight"]:SetPoint("RIGHT", _G["PartyMemberFrame"..i.."HealthBar"], "RIGHT", 0, 0);
			_G["PartyMemberFrame"..i.."ManaBarTextLeft"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."ManaBarTextLeft"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."ManaBar"], "LEFT", 0, 0);
			_G["PartyMemberFrame"..i.."ManaBarTextRight"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."ManaBarTextRight"]:SetPoint("RIGHT", _G["PartyMemberFrame"..i.."ManaBar"], "RIGHT", 0, 0);
			_G["PartyMemberFrame"..i.."HealthBarText"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."HealthBarText"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."HealthBar"], "RIGHT", 0, 0);
			_G["PartyMemberFrame"..i.."ManaBarText"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."ManaBarText"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."ManaBar"], "RIGHT", 0, 0);
		end
	end
end
hooksecurefunc("UnitFrame_Update", whoaPartyFrames)
hooksecurefunc("PartyMemberFrame_ToPlayerArt", whoaPartyFrames)
hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function()
		for i = 1, 4 do
			_G["PartyMemberFrame"..i.."ManaBarText"]:SetText(" ");
			_G["PartyMemberFrame"..i.."ManaBarTextLeft"]:SetText(" ");
			_G["PartyMemberFrame"..i.."ManaBarTextRight"]:SetText(" ");
		end
end)
--------------------------------------------------------------------------------------whoa end