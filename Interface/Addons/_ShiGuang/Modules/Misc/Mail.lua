﻿local _, ns = ...
local M, R, U, I = unpack(ns)
local MISC = M:GetModule("Misc")

local strsplit, pairs, tonumber, sub = string.split, pairs, tonumber, string.sub
local deletedelay, mailItemIndex, inboxItems = .5, 0, {}
local button1, button2, button3, lastopened, imOrig_InboxFrame_OnClick, hasNewMail, takingOnlyCash, onlyCurrentMail, needsToWait, skipMail

function MISC:MailItem_OnClick()
	mailItemIndex = 7 * (InboxFrame.pageNum - 1) + tonumber(sub(self:GetName(), 9, 9))
	local modifiedClick = IsModifiedClick("MAILAUTOLOOTTOGGLE")
	if modifiedClick then
		InboxFrame_OnModifiedClick(self, self.index)
	else
		InboxFrame_OnClick(self, self.index)
	end
end

function MISC:MailBox_OpenAll()
	if GetInboxNumItems() == 0 then return end

	button1:SetScript("OnClick", nil)
	button2:SetScript("OnClick", nil)
	button3:SetScript("OnClick", nil)
	imOrig_InboxFrame_OnClick = InboxFrame_OnClick
	InboxFrame_OnClick = M.Dummy

	if onlyCurrentMail then
		button3:RegisterEvent("UI_ERROR_MESSAGE")
		MISC.MailBox_Open(button3, mailItemIndex)
	else
		button1:RegisterEvent("UI_ERROR_MESSAGE")
		MISC.MailBox_Open(button1, GetInboxNumItems())
	end
end

function MISC:MailBox_Update(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if (not needsToWait) or (self.elapsed > deletedelay) then
		self.elapsed = 0
		needsToWait = false
		self:SetScript("OnUpdate", nil)

		local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(lastopened)
		if skipMail then
			MISC.MailBox_Open(self, lastopened - 1)
		elseif money > 0 or (not takingOnlyCash and numItems and numItems > 0 and COD <= 0) then
			MISC.MailBox_Open(self, lastopened)
		else
			MISC.MailBox_Open(self, lastopened - 1)
		end
	end
end

function MISC:MailBox_Open(index)
	if not InboxFrame:IsVisible() or index == 0 then
		MISC:MailBox_Stop()
		return
	end

	local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(index)
	if not takingOnlyCash then
		if money > 0 or (numItems and numItems > 0) and COD <= 0 then
			AutoLootMailItem(index)
			needsToWait = true
		end
		if onlyCurrentMail then MISC:MailBox_Stop() return end
	elseif money > 0 then
		TakeInboxMoney(index)
		needsToWait = true
	end

	local items = GetInboxNumItems()
	if (numItems and numItems > 0) or (items > 1 and index <= items) then
		lastopened = index
		self:SetScript("OnUpdate", MISC.MailBox_Update)
	else
		MISC:MailBox_Stop()
	end
end

function MISC:MailBox_Stop()
	button1:SetScript("OnUpdate", nil)
	button1:SetScript("OnClick", function() onlyCurrentMail = false MISC:MailBox_OpenAll() end)
	button2:SetScript("OnClick", function() takingOnlyCash = true MISC:MailBox_OpenAll() end)
	button3:SetScript("OnUpdate", nil)
	button3:SetScript("OnClick", function() onlyCurrentMail = true MISC:MailBox_OpenAll() end)
	if imOrig_InboxFrame_OnClick then
		InboxFrame_OnClick = imOrig_InboxFrame_OnClick
	end
	if onlyCurrentMail then
		button3:UnregisterEvent("UI_ERROR_MESSAGE")
	else
		button1:UnregisterEvent("UI_ERROR_MESSAGE")
	end
	takingOnlyCash = false
	onlyCurrentMail = false
	needsToWait = false
	skipMail = false
end

function MISC:MailBox_OnEvent(event, _, msg)
	if event == "UI_ERROR_MESSAGE" then
		if msg == ERR_INV_FULL then
			MISC:MailBox_Stop()
		elseif msg == ERR_ITEM_MAX_COUNT then
			skipMail = true
		end
	elseif event == "MAIL_CLOSED" then
		if not hasNewMail then MiniMapMailFrame:Hide() end
		MISC:MailBox_Stop()
	end
end

function MISC:TotalCash_OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	local total_cash = 0
	for index = 0, GetInboxNumItems() do
		total_cash = total_cash + select(5, GetInboxHeaderInfo(index))
	end
	if total_cash > 0 then SetTooltipMoney(GameTooltip, total_cash)	end
	GameTooltip:Show()
end

function MISC:MailBox_DelectClick()
	local selectedID = self.id + (InboxFrame.pageNum-1)*7
	if InboxItemCanDelete(selectedID) then
		DeleteInboxItem(selectedID)
	else
		UIErrorsFrame:AddMessage(I.InfoColor..ERR_MAIL_DELETE_ITEM_ERROR)
	end
end

function MISC:MailItem_AddDelete(i)
	local bu = CreateFrame("Button", nil, self)
	bu:SetPoint("BOTTOMRIGHT", self:GetParent(), "BOTTOMRIGHT", -10, 5)
	bu:SetSize(16, 16)
	M.PixelIcon(bu, 136813, true)
	bu.id = i
	bu:SetScript("OnClick", MISC.MailBox_DelectClick)
	M.AddTooltip(bu, "ANCHOR_RIGHT", DELETE, "system")
end

function MISC:CreatButton(parent, text, w, h, ap, frame, rp, x, y)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetWidth(w)
	button:SetHeight(h)
	button:SetPoint(ap, frame, rp, x, y)
	button:SetText(text)
	return button
end

function MISC:InboxFrame_Hook()
	hasNewMail = false
	if select(4, GetInboxHeaderInfo(1)) then
		for i = 1, GetInboxNumItems() do
			local wasRead = select(9, GetInboxHeaderInfo(i))
			if not wasRead then
				hasNewMail = true
				break
			end
		end
	end
end

function MISC:InboxItem_OnEnter()
	wipe(inboxItems)

	local itemAttached = select(8, GetInboxHeaderInfo(self.index))
	if itemAttached then
		for attachID = 1, 12 do
			local _, _, _, itemCount = GetInboxItem(self.index, attachID)
			if itemCount and itemCount > 0 then
				local _, itemid = strsplit(":", GetInboxItemLink(self.index, attachID))
				itemid = tonumber(itemid)
				inboxItems[itemid] = (inboxItems[itemid] or 0) + itemCount
			end
		end

		if itemAttached > 1 then
			GameTooltip:AddLine(U["Attach List"])
			for key, value in pairs(inboxItems) do
				local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = GetItemInfo(key)
				if itemName then
					local r, g, b = GetItemQualityColor(itemQuality)
					GameTooltip:AddDoubleLine(" |T"..itemTexture..":12:12:0:0:50:50:4:46:4:46|t "..itemName, value, r, g, b)
				end
			end
			GameTooltip:Show()
		end
	end
end

function MISC:MailBox()
	if not MaoRUISettingDB["Misc"]["Mail"] then return end
	if IsAddOnLoaded("Postal") then return end

	for i = 1, 7 do
		local itemButton = _G["MailItem"..i.."Button"]
		itemButton:SetScript("OnClick", MISC.MailItem_OnClick)
		MISC.MailItem_AddDelete(itemButton, i)
	end

	button1 = MISC:CreatButton(InboxFrame, MAIL_RECEIVELETTERS, 80, 26, "TOPLEFT", "InboxFrame", "TOPLEFT", 60, -28)
	button1:RegisterEvent("MAIL_CLOSED")
	button1:SetScript("OnClick", MISC.MailBox_OpenAll)
	button1:SetScript("OnEvent", MISC.MailBox_OnEvent)

	button2 = MISC:CreatButton(InboxFrame, MAIL_RECEIVECOINS, 80, 26, "LEFT", button1, "RIGHT", 2, 0)
	button2:SetScript("OnClick", function()
		takingOnlyCash = true
		MISC:MailBox_OpenAll()
	end)
	button2:SetScript("OnEnter", MISC.TotalCash_OnEnter)
	button2:SetScript("OnLeave", M.HideTooltip)

	button3 = MISC:CreatButton(OpenMailFrame, MAIL_RECEIVELETTERS, 80, 22, "RIGHT", "OpenMailReplyButton", "LEFT", -2, 0)
	button3:SetScript("OnClick", function()
		onlyCurrentMail = true
		MISC:MailBox_OpenAll()
	end)
	button3:SetScript("OnEvent", MISC.MailBox_OnEvent)
	
	-------DelMailbutton----------------
	button4 = MISC:CreatButton(InboxFrame, MAIL_DELETEEMPTYMAILS, 100, 26, "LEFT", button2, "RIGHT", 2, 0)
	button4:SetScript("OnClick", function() sendCmd("/mbclean") end)

	hooksecurefunc("InboxFrame_Update", MISC.InboxFrame_Hook)
	hooksecurefunc("InboxFrameItem_OnEnter", MISC.InboxItem_OnEnter)

	-- Replace the alert frame
	if InboxTooMuchMail then
		InboxTooMuchMail:ClearAllPoints()
		InboxTooMuchMail:SetPoint("BOTTOM", MailFrame, "TOP", 0, 5)
	end

	-- Hide Blizz
	M.HideObject(OpenAllMail)
end

-------MailinputboxResizer---------------------------------------------------------------
SendMailCostMoneyFrame:ClearAllPoints()
SendMailCostMoneyFrame:SetPoint("TOPLEFT","SendMailFrame","TOPLEFT",82,-70)
_G["SendMailNameEditBox"]:SetSize(230,20)				----EditBox width default: 224
_G["SendMailNameEditBoxRight"]:ClearAllPoints()
_G["SendMailNameEditBoxRight"]:SetPoint("TOPRIGHT",0,0)
_G["SendMailNameEditBoxMiddle"]:SetSize(0,20)
_G["SendMailNameEditBoxMiddle"]:ClearAllPoints()
_G["SendMailNameEditBoxMiddle"]:SetPoint("LEFT","SendMailNameEditBoxLeft","LEFT",8,0)
_G["SendMailNameEditBoxMiddle"]:SetPoint("RIGHT",_G["SendMailNameEditBoxRight"],"RIGHT",-8,0)

-- Mailbox Cleaner-------- by Jadya - EU-Well of Eternity---------------------------------
local title = GEAR_DELETEEMPTYMAILS_TITLE
local em_enabled = false
local timeout = 0
local MailboxCleaner = CreateFrame("Frame")
local options_desc = { ["read"] = "Delete unread mails" }

local function endloop()
 em_enabled = false
 MailboxCleaner:Hide()
 print(title.." - Done.")
end

local function update()
 if not em_enabled or not InboxFrame or not InboxFrame:IsVisible() then endloop() return end
 local num = GetInboxNumItems()
 if num < 1 or i < 1 then
  endloop()
  return
 end
 local t = time()
 if timeout > 0 then
  if i > num or (timeout < t) then
   i = math.min(i - 1, num)
   timeout = 0
  else
   return
  end
 end

 --if InboxItemCanDelete(i) then
 local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, itemCount, wasRead, wasReturned, textCreated, canReply, isGM, itemQuantity = GetInboxHeaderInfo(i)
 if (ShiGuangDB["MailRead"] or wasRead) and not isGM and (not snd or (snd and (snd == string.lower(sender)))) and (not itemCount or itemCount == 0) and (not money or money == 0) then
  DeleteInboxItem(i)
  timeout = t + 1
 else
  i = i - 1
 end   
 --end
 if i > num then 
  endloop()
 end
end

MailboxCleaner:SetScript("OnUpdate", update)
MailboxCleaner:Hide()

local function printOptionMsg(arg, help)
 if ShiGuangDB[arg] == nil then return end
 print(title.." - "..(options_desc[arg] or "<unknown>").." = |cff69CCF0"..tostring(ShiGuangDB[arg]).."|r".. (help and " (|cffCCCCCC/mbclean "..arg.."|r)" or ""))
end

local function start(arg)
 if arg == "MailRead" then
  ShiGuangDB["MailRead"] = not ShiGuangDB["MailRead"]
  printOptionMsg(arg)
  return
 end

 if not InboxFrame or not InboxFrame:IsVisible() then
  print(title..MAIL_OPENMAILBOX)
  return
 end
 if arg and arg ~= "" then
  snd = string.lower(arg)
 else
  snd = nil
 end
 i = GetInboxNumItems()
 print(title.." - Doing"..(snd and " from "..snd or "").."...")
 em_enabled = true
 MailboxCleaner:Show()
end

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function() printOptionMsg("...", true) eventframe:SetScript("OnEvent", nil) end)
-- slash command
SLASH_MAILBOXCLEANER1 = "/mbclean"
SLASH_MAILBOXCLEANER2 = "/mailboxcleaner"
SlashCmdList["MAILBOXCLEANER"] = start

------------------------------------ 輸入框名冊-- Author:M----------------------------------
--此表會被重載
TinyRosterDB = {
    SendMailNameEditBox = {},                                                   --發郵件
    BankItemSearchBox = {},                                                     --銀行查找
    BagItemSearchBox = {},                                                      --背包查找
}

--按鈕數量和高度
local numButton, btnHeight = 12, 18

--加入/删除名冊
local function toggle(list, name, delete)
    local pos
    if (name == "") then return end
    for i, v in ipairs(list) do
        if (v == name) then pos = i end
    end
    if (not pos) then
        table.insert(list, 1, name)
    elseif (delete and pos) then
        table.remove(list, pos)
    end
    --table.sort(list, function(a, b) return string.byte(a) < string.byte(b) end)
end

--左鍵選擇,右鍵刪除
local function onclick(self, button)
    local editbox = self:GetParent().editbox
    if (not editbox) then return end
    if (IsControlKeyDown() and button == "RightButton") then
        for k in pairs(editbox.rosterList) do
            editbox.rosterList[k] = nil
        end
        return editbox.rosterFunc(editbox)
    elseif (button == "RightButton") then
        toggle(editbox.rosterList, self.text, true)
        return editbox.rosterFunc(editbox)
    end
    editbox:SetText(self.text)
    self:GetParent():Hide()
    editbox.rosterAddButton:Hide()
end

--创建按钮
local function createButton(parent, index)
    local button = CreateFrame("Button", "TinyRosterFrameButton"..index, parent, "ClassicLFGListSearchAutoCompleteButtonTemplate")
    button:SetAlpha(0.9)
    button:SetHeight(btnHeight)
    button.Label:SetJustifyH("CENTER")
    button.Label:SetFont(UNIT_NAME_FONT, 14, "NORMAL")
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", onclick)
    if (index == 1) then
        button:SetPoint("TOPLEFT", parent, "TOPLEFT")
        button:SetPoint("TOPRIGHT", parent, "TOPRIGHT")
    else
        button:SetPoint("TOPLEFT", _G["TinyRosterFrameButton"..(index-1)], "BOTTOMLEFT")
        button:SetPoint("TOPRIGHT", _G["TinyRosterFrameButton"..(index-1)], "BOTTOMRIGHT")
    end
end

--系統自動填充是異步行爲 空字符不觸發此函數
hooksecurefunc("AutoComplete_UpdateResults", function(self, results, context)
    if (self.CallbackToTinyRoster) then
        if (#results == 0) then
            self.CallbackToTinyRoster = false
        else
            TinyRosterFrame:ClearAllPoints()
            TinyRosterFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 4, 0)
            TinyRosterFrame:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -3, 0)
        end
    end
end)

--顯示名冊 1.處理異步情況 2.context在獲得焦點時值是true
local function ShowRosterList(editbox, context)
    TinyRosterFrame.editbox = editbox
    local text = editbox:GetText()
    if (not AutoCompleteBox.CallbackToTinyRoster or text == "") then
        TinyRosterFrame:Show()
        TinyRosterFrame:ClearAllPoints()
        TinyRosterFrame:SetPoint("TOPLEFT", editbox, "BOTTOMLEFT", -2, 0)
        TinyRosterFrame:SetPoint("TOPRIGHT", editbox, "BOTTOMRIGHT", -3, 0)
    end
    local AutoCompleteFrame = editbox:GetParent().AutoCompleteFrame
    if (AutoCompleteFrame and AutoCompleteFrame:IsShown()) then
        TinyRosterFrame:ClearAllPoints()
        TinyRosterFrame:SetPoint("TOPLEFT", AutoCompleteFrame, "BOTTOMLEFT", 7, 8)
        TinyRosterFrame:SetPoint("TOPRIGHT", AutoCompleteFrame, "BOTTOMRIGHT", -4, 8)
    end
    if (editbox.autoCompleteParams) then
        AutoCompleteBox.CallbackToTinyRoster = true
    else
        AutoCompleteBox.CallbackToTinyRoster = false
    end
    local button
    local index = 1
    local list = editbox.rosterList
    --當記錄大於按鈕總數,用戶變更輸入之後,自動開啓模糊查詢
    if (context == "userInput" and #list > numButton and strlen(text) > 0) then
        list = {}
        for _, v in ipairs(editbox.rosterList) do
            if (string.find(v,text)) then tinsert(list,v) end 
        end
    end
    while (list[index] and index <= numButton) do
        button = _G["TinyRosterFrameButton"..index]
        button.text = list[index]
        button:SetText(list[index])
        button:Show()
        index = index + 1
    end

    TinyRosterFrame:SetHeight(index*btnHeight)
    editbox.rosterAddButton:Show()
    editbox.rosterAddButton:ClearAllPoints()
    editbox.rosterAddButton:SetPoint("BOTTOMLEFT", TinyRosterFrame, "BOTTOMLEFT")
    editbox.rosterAddButton:SetPoint("BOTTOMRIGHT", TinyRosterFrame, "BOTTOMRIGHT")
    
    while (_G["TinyRosterFrameButton"..index]) do
        _G["TinyRosterFrameButton"..index]:Hide()
        index = index + 1
    end
end

--用戶輸入
local function OnTextChanged(self, userInput)
    if (userInput) then ShowRosterList(self, "userInput") end
end

--失去焦點
local function OnEditFocusLost(self)
    TinyRosterFrame:Hide()
    self.rosterAddButton:Hide()
    toggle(self.rosterList, self:GetText()) --自動保存
end

--獲取框架
local function getEditBox(name)
    local frame, subframe, thirdframe = strsplit(".", name)
    if (thirdframe and _G[frame] and _G[frame][subframe]) then
        return _G[frame][subframe][thirdframe]
    elseif (subframe and _G[frame]) then
        return _G[frame][subframe]
    else
        return _G[frame]
    end
end

--讓輸入框有此功能
local function fn(editboxName, config)
    local editbox = getEditBox(editboxName)
    if (not editbox) then return end
    if (not config.list) then config.list = {} end
    editbox.rosterMark = true
    editbox.rosterList = config.list
    editbox.rosterFunc = ShowRosterList
    --editbox.autoCompleteParams = nil --去掉註釋表示關閉系統自動填充
    editbox:HookScript("OnTextChanged", OnTextChanged)
    editbox:HookScript("OnEditFocusGained", ShowRosterList)
    editbox:HookScript("OnEditFocusLost", OnEditFocusLost)
    editbox.rosterAddButton = CreateFrame("Button", nil, TinyRosterFrame, "ClassicLFGListSearchAutoCompleteButtonTemplate")
    editbox.rosterAddButton:Hide()
    editbox.rosterAddButton:SetHeight(btnHeight)
    editbox.rosterAddButton.Label:SetFont(UNIT_NAME_FONT, 14, "OUTLINE")
    editbox.rosterAddButton.Label:SetJustifyH("CENTER")
    editbox.rosterAddButton.Label:SetTextColor(1, 0.82, 0)
    editbox.rosterAddButton:SetText(SAVE..NAME)
    editbox.rosterAddButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    editbox.rosterAddButton:SetScript("OnClick", function(self, button)
        if (button == "LeftButton") then
            local text = editbox:GetText()
            if (text and text ~= "") then
                toggle(editbox.rosterList, text)
                editbox.rosterFunc(editbox)
            end
        else
            editbox:SetText("")
        end
    end)
end

--創建框架
do
    local function OnEvent(self, event)
        if (event == "ADDON_LOADED") then
            for editboxName, v in pairs(TinyRosterDB) do
                --if (v.depands and v.depands == arg1 and not getEditBox(editboxName).rosterMark) then
                    fn(editboxName, v)
                --end
            end
        end
    end
    local TinyRosterFrame = CreateFrame("Frame", "TinyRosterFrame", UIParent)
    TinyRosterFrame:Hide()
    TinyRosterFrame:SetClampedToScreen(true)
    TinyRosterFrame:SetFrameStrata("DIALOG")
    TinyRosterFrame:SetSize(136, numButton*btnHeight)
    TinyRosterFrame.BottomLeftBorder = TinyRosterFrame:CreateTexture(nil, "ARTWORK", "UI-Frame-BotCornerLeft")
    TinyRosterFrame.BottomLeftBorder:ClearAllPoints()
    TinyRosterFrame.BottomLeftBorder:SetPoint("BOTTOMLEFT", -7, -7)
    TinyRosterFrame.BottomRightBorder = TinyRosterFrame:CreateTexture(nil, "ARTWORK", "UI-Frame-BotCornerRight")
    TinyRosterFrame.BottomRightBorder:ClearAllPoints()
    TinyRosterFrame.BottomRightBorder:SetPoint("BOTTOMRIGHT", 4, -7)
    TinyRosterFrame.BottomBorder = TinyRosterFrame:CreateTexture(nil, "ARTWORK", "_UI-Frame-Bot")
    TinyRosterFrame.BottomBorder:ClearAllPoints()
    TinyRosterFrame.BottomBorder:SetPoint("BOTTOMLEFT", TinyRosterFrame.BottomLeftBorder, "BOTTOMRIGHT")
    TinyRosterFrame.BottomBorder:SetPoint("BOTTOMRIGHT", TinyRosterFrame.BottomRightBorder, "BOTTOMLEFT")
    TinyRosterFrame.LeftBorder = TinyRosterFrame:CreateTexture(nil, "ARTWORK", "!UI-Frame-LeftTile")
    TinyRosterFrame.LeftBorder:ClearAllPoints()
    TinyRosterFrame.LeftBorder:SetPoint("TOP", 0, 1)
    TinyRosterFrame.LeftBorder:SetPoint("BOTTOMLEFT", TinyRosterFrame.BottomLeftBorder, "TOPLEFT")
    TinyRosterFrame.RightBorder = TinyRosterFrame:CreateTexture(nil, "ARTWORK", "!UI-Frame-RightTile")
    TinyRosterFrame.RightBorder:ClearAllPoints()
    TinyRosterFrame.RightBorder:SetPoint("TOP", 0, 1)
    TinyRosterFrame.RightBorder:SetPoint("BOTTOMRIGHT", TinyRosterFrame.BottomRightBorder, "TOPRIGHT", 1, 0)
    TinyRosterFrame.TopBorder = TinyRosterFrame:CreateTexture(nil, "ARTWORK", "_UI-Frame-Bot")
    TinyRosterFrame.TopBorder:ClearAllPoints()
    TinyRosterFrame.TopBorder:SetPoint("TOPLEFT", TinyRosterFrame, "TOPLEFT", -2, 3)
    TinyRosterFrame.TopBorder:SetPoint("BOTTOMRIGHT", TinyRosterFrame, "TOPRIGHT", 2, -3)
    for i = 1, numButton do createButton(TinyRosterFrame, i) end
    TinyRosterFrame:SetScript("OnEvent", OnEvent)
    TinyRosterFrame:RegisterEvent("VARIABLES_LOADED")
    TinyRosterFrame:RegisterEvent("ADDON_LOADED")
end