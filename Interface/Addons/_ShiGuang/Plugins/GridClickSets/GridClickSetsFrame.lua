﻿local i
local queue = false
local function makeMovable(frame)
    local mover = _G[frame:GetName() .. "Mover"] or CreateFrame("Frame", frame:GetName() .. "Mover", frame)
    mover:EnableMouse(true)
    mover:SetPoint("TOP", frame, "TOP", 0, 10)
    mover:SetWidth(160)
    mover:SetHeight(40)
    mover:SetScript("OnMouseDown", function(self)
        self:GetParent():StartMoving()
    end)
    mover:SetScript("OnMouseUp", function(self)
        self:GetParent():StopMovingOrSizing()
    end)
    -- mover:SetClampedToScreen(true)		-- doesn't work?
    frame:SetMovable(true)
end

function GridClickSetsFrame_OnLoad(self)
    self:RegisterEvent("PLAYER_REGEN_ENABLED");
    self:RegisterEvent("VARIABLES_LOADED");
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
    self:RegisterEvent("PLAYER_ALIVE");
    makeMovable(self)
    PanelTemplates_SetNumTabs(self, GRID_CLICK_SETS_BUTTONS + 2);
    self.selectedTab = 1;
    PanelTemplates_UpdateTabs(self);

    for i = 1, 8 do
        getglobal("GridClickSetButton"..i.."Title"):SetText(GridClickSets_Titles[i])
    end

    --GridClickSetsFrame_TabOnClick();
    table.insert(UISpecialFrames, self:GetName())
end

function GridClickSetsFrame_OnEvent(self, event, arg1)
    if(event=="PLAYER_REGEN_ENABLED") then
        if(queue) then
            GridClickSetsFrame_UpdateAll()
            queue = false
        end
    end

    if(event=="VARIABLES_LOADED" or (event=="PLAYER_SPECIALIZATION_CHANGED" and arg1=="player") or event=="PLAYER_ALIVE") then
        GridClickSetsFrame_UpdateAll(1);
    end
end

function GridClickSetsFrame_TypeUpdate(id)
    local argF = getglobal("GridClickSetButton"..id.."Arg")
    local typeDD = getglobal("GridClickSetButton"..id.."Type")
    local value = Lib_UIDropDownMenu_GetSelectedValue(typeDD)
    if (not value) then value = "NONE" end

    if( value=="spell" or value=="macro" ) then
        argF:Show();
    else
        argF:Hide();
    end

    local below = getglobal("GridClickSetButton"..(id+1))
    if(below) then
        below:ClearAllPoints();
        if argF:IsVisible() then
            below:SetPoint("TOPLEFT", argF, "BOTTOMLEFT", -50, 0);
        else
            below:SetPoint("TOPLEFT", getglobal("GridClickSetButton"..id), "BOTTOMLEFT", 0, -5);
        end
    end
end

function GridClickSetsFrame_Resize()
    local k=0;
    local id
    for id=1, 8 do
        local argF = getglobal("GridClickSetButton"..id.."Arg")
        if(argF:IsVisible()) then
            k = k + argF:GetHeight() + 1;
        end
    end
    local height = 340 + k;
    if(height > 450) then
        GridClickSetsFrame:SetHeight(height);
    else
        GridClickSetsFrame:SetHeight(450);
    end
end

function GridClickSetsFrame_TypeUpdateAll()
    for i=1,8 do
        GridClickSetsFrame_TypeUpdate(i)
    end
    GridClickSetsFrame_Resize();
end

function GridClickSets_Type_OnClick(self)
    Lib_UIDropDownMenu_SetSelectedValue(self.owner, self.value);
    local id=self.owner:GetParent():GetID()
    GridClickSetsFrame_TypeUpdate(id)
    GridClickSetsFrame_Resize()
end

local function ddname(str)
    return " = "..str.." = ";
end

function GridClickSetButton_TypeDropDown_Initialize(self)
    local info;

    local _, c = UnitClass("player")
    local spec = GetSpecialization()
    local list = GridClickSets_SpellList[c];
    if(list) then
        for spellId, defSpec in pairs(list) do
            --ReplacingTalentSpell IsKnown = false, Replaced IsKnown = true
            if GridClickSets_MayHaveSpell(defSpec, spec) then
                local name, _, icon = GetSpellInfo(spellId)
                if name ~= nil then
                    info = {};
                    info.text = name
                    info.icon = icon;
                    info.owner = self;
                    info.func = GridClickSets_Type_OnClick;
                    info.value = "spellId:"..spellId
                    info.tooltipFunc = function(self, tip, arg1) tip:SetSpellByID(arg1) end
                    info.tooltipFuncArg1 = spellId
                    Lib_UIDropDownMenu_AddButton(info);
                end
            end
        end
    end

    info = {};
    info.text = ddname(TARGET);
    info.owner = self;
    info.func = GridClickSets_Type_OnClick;
    info.value = "target"
    Lib_UIDropDownMenu_AddButton(info);

    info = {};
    info.text = ddname(BINDING_NAME_ASSISTTARGET);
    info.owner = self;
    info.func = GridClickSets_Type_OnClick;
    info.value = "assist"
    Lib_UIDropDownMenu_AddButton(info);

    info = {};
    info.text = ddname(SKILL..NAME);
    info.owner = self;
    info.func = GridClickSets_Type_OnClick;
    info.value = "spell"
    Lib_UIDropDownMenu_AddButton(info);

    --	info = {};
    --	info.text = ddname(SOCIAL_LABEL);
    --	info.owner = self;
    --	info.func = GridClickSets_Type_OnClick;
    --	info.value = "menu"
    --	Lib_UIDropDownMenu_AddButton(info);

    info = {};
    info.text = ddname(MACRO);
    info.owner = self;
    info.func = GridClickSets_Type_OnClick;
    info.value = "macro"
    Lib_UIDropDownMenu_AddButton(info);

    info = {};
    info.text = NONE; --ddname(NONE);
    info.owner = self;
    info.func = GridClickSets_Type_OnClick;
    info.value = "NONE"
    Lib_UIDropDownMenu_AddButton(info);
end

function GridClickSetsFrame_GetTabSet(btn)
    local set = GridClickSetsFrame_GetCurrentSet()
    return set[tostring(btn)]
end

function GridClickSetsFrame_LoadSet(set)
    for i = 1, 8 do
        local dd = getglobal("GridClickSetButton"..i.."Type")
        local atts = set and set[GridClickSets_Modifiers[i]] or {}
        Lib_UIDropDownMenu_Initialize(dd, GridClickSetButton_TypeDropDown_Initialize);
        Lib_UIDropDownMenu_SetSelectedValue(dd, atts.type or "NONE")
        if(atts.arg) then
            getglobal("GridClickSetButton"..i.."Arg"):SetText(atts.arg)
        else
            getglobal("GridClickSetButton"..i.."Arg"):SetText("")
        end
    end

    GridClickSetsFrame_TypeUpdateAll();
end

function GridClickSetsFrame_TabOnClick()
    GridClickSetsFrame_LoadSet( GridClickSetsFrame_GetTabSet(GridClickSetsFrame.selectedTab) );
    if ( false and GridClickSetsFrame.selectedTab == 1 ) then
        Lib_UIDropDownMenu_SetSelectedValue(GridClickSetButton1Type, "target");
        Lib_UIDropDownMenu_DisableDropDown(GridClickSetButton1Type)
    else
        Lib_UIDropDownMenu_EnableDropDown(GridClickSetButton1Type)
    end
end

function GridClickSetsFrame_DefaultsOnClick(fromDialog)
    if fromDialog == "YES" then
        local talent = GetSpecialization() or 1
        ShiGuangPerDB[talent] = nil
        GridClickSetsFrame_LoadSet( GridClickSetsFrame_GetTabSet(GridClickSetsFrame.selectedTab) )
        GridClickSetsFrame_ApplyOnClick()
    else
        StaticPopup_Show("GridClickSets_Reset")
    end
end

function GridClickSetsFrame_SaveOnClick()
    local set = GridClickSetsFrame_GetCurrentSet()
    for i=1,8 do
        set[tostring(GridClickSetsFrame.selectedTab)][GridClickSets_Modifiers[i]] = {
            type = Lib_UIDropDownMenu_GetSelectedValue( getglobal("GridClickSetButton"..i.."Type") ),
            arg = getglobal("GridClickSetButton"..i.."Arg"):GetText()
        }

        if set[tostring(GridClickSetsFrame.selectedTab)][GridClickSets_Modifiers[i]].arg == "" then
            set[tostring(GridClickSetsFrame.selectedTab)][GridClickSets_Modifiers[i]].arg = nil
        end

        if set[tostring(GridClickSetsFrame.selectedTab)][GridClickSets_Modifiers[i]].type == "NONE" then
            set[tostring(GridClickSetsFrame.selectedTab)][GridClickSets_Modifiers[i]] = nil
        end
    end
end

function GridClickSetsFrame_CancelOnClick()
    GridClickSetsFrame_LoadSet( GridClickSetsFrame_GetTabSet(GridClickSetsFrame.selectedTab) );
end

function GridClickSetsFrame_CloseOnClick(self)
    GridClickSetsFrame:Hide();
    local last = GridClickSetsFrame.lastFrame
    GridClickSetsFrame.lastFrame = nil
    if last then
        if type(last) == "function" then
            last(GridClickSetsFrame)
        else
            last:Show()
        end
    end
end

function GridClickSetsFrame_ApplyOnClick()
    GridClickSetsFrame_SaveOnClick()
    GridClickSetsFrame_UpdateAll()
    --GridClickSetsFrame:Hide()
end

ShiGuangPerDB={}
GridClickSetsFrame_Updates = {} --for other module insert

function GridClickSetsFrame_GetCurrentSet()
    local spec = GetSpecialization() or 0;
    if GridClickSetsFrame:IsVisible() then
        GridClickSetsFrameTalentText:SetFormattedText("%s: %s", SPECIALIZATION, select(2, GetSpecializationInfo(spec)) or UNKNOWN)
    end
    if ShiGuangPerDB[spec]==nil then
        ShiGuangPerDB[spec] = GridClickSets_GetDefault(spec);
    end
    local set = ShiGuangPerDB[spec]
    for i=1, GRID_CLICK_SETS_BUTTONS+2 do set[tostring(i)] = set[tostring(i)] or {} end
    return set
end

function GridClickSetsFrame_UpdateAll(silent)
    local set = GridClickSetsFrame_GetCurrentSet()
    if GridClickSetsFrame:IsVisible() then GridClickSetsFrame_TabOnClick() end
    if(InCombatLockdown()) then
        queue = true
        if not silent then DEFAULT_CHAT_FRAME:AddMessage(GRIDCLICKSETS_LOCKWARNING, 1, 0, 0) end
    else
        for _, v in pairs(GridClickSetsFrame_Updates) do
            v(set)
        end
        --if not silent then DEFAULT_CHAT_FRAME:AddMessage(GRIDCLICKSETS_SET, 1, 1, 0) end
    end
end

SLASH_CLICKSET1 = "/clicksets";
SLASH_CLICKSET2 = "/gcs";
SLASH_CLICKSET3 = "/gridclicksets";
SlashCmdList["CLICKSET"] = function(msg)
    if GridClickSetsFrame:IsVisible() then GridClickSetsFrame:Hide() else GridClickSetsFrame:Show() end
end

StaticPopupDialogs['GridClickSets_Reset'] = {preferredIndex = 3,
	text = GRIDCLICKSETS_SET_RESET_WARNING,
	button1 = YES,
	button2 = NO,
	OnAccept = function(self) GridClickSetsFrame_DefaultsOnClick("YES") end,
	hideOnEscape = 1,
}