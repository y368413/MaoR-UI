﻿--## Author: Semlar ## Version: 8.3.0.1

C_MythicPlus.RequestRewards()

local function GetModifiers(linkType, ...)
	if type(linkType) ~= 'string' then return end
	local modifierOffset = 4
	local itemID, instanceID, mythicLevel, notDepleted, _ = ... -- "keystone" links
	if linkType:find('item') then -- only used for ItemRefTooltip currently
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel = ...
		if ... == '138019' or ... == '158923' then -- mythic keystone
			modifierOffset = 16
		else
			return
		end
	elseif not linkType:find('keystone') then
		return
	end

	local modifiers = {}
	for i = modifierOffset, select('#', ...) do
		local num = strmatch(select(i, ...) or '', '^(%d+)')
		if num then
			local modifierID = tonumber(num)
			--if not modifierID then break end
			tinsert(modifiers, modifierID)
		end
	end
	local numModifiers = #modifiers
	if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
		tremove(modifiers, numModifiers)
	end
	return modifiers, instanceID, mythicLevel
end

function WhatADropItemLevel(mlvl)
 if (mlvl == "2" or mlvl == "3") then
  return "435"
 elseif (mlvl == "4") then
  return "440"
 elseif (mlvl == "5" or mlvl == "6") then
  return "445"
 elseif (mlvl == "7" or mlvl == "8") then
  return "450"
 elseif (mlvl == "9" or mlvl == "10" or mlvl == "11") then
  return "455"
 elseif (mlvl == "12" or mlvl == "13" or mlvl == "14") then
  return "460"
 elseif (mlvl >= "15") then
  return "465"
 else
  return ""
 end
end

local function DecorateTooltip(self, link, _)
	if not link then
		_, link = self:GetItem()
	end
	if type(link) == 'string' then
		local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(':', link))
		if modifiers then
			--for _, modifierID in ipairs(modifiers) do
				--local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(modifierID)
				--if modifierName and modifierDescription then
					--self:AddLine(modifierName.. " - |cffff00ff" .. modifierDescription.."|r" , 0, 1, 0, true)
				--end
			--end
			--if instanceID then
				--local name, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(instanceID)
				--if timeLimit then
					--self:AddLine('Time Limit: ' .. SecondsToTime(timeLimit, false, true), 1, 1, 1)
				--end
			--end
			if mythicLevel then
				local weeklyRewardLevel, endOfRunRewardLevel = C_MythicPlus.GetRewardLevelForDifficultyLevel(mythicLevel)
				if weeklyRewardLevel ~= 0 then
								self:AddDoubleLine("|cffff00ff"..WEEKLY..REWARD.."|r", weeklyRewardLevel, 1, 1, 1,true)
								self:AddDoubleLine("|cffff00ff"..INSTANCE..LOOT.."|r", WhatADropItemLevel(mythicLevel) .. "+", 1,1,1,true)
				end
			end
			-- C_MythicPlus.GetRewardLevelForDifficultyLevel(9)
			-- -> 375, 365 (weeklyRewardLevel, endOfRunRewardLevel)
			self:Show()
		end
	end
end

-- hack to handle ItemRefTooltip:GetItem() not returning a proper keystone link
hooksecurefunc(ItemRefTooltip, 'SetHyperlink', DecorateTooltip) 
--ItemRefTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
GameTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)

--[[do
	-- Auto-slot keystone when interacting with the pedastal 
	local f = CreateFrame('frame')
	f:SetScript('OnEvent', function(self, event, addon)
		if addon == 'Blizzard_ChallengesUI' then
			ChallengesKeystoneFrame:HookScript('OnShow', function()
				-- todo: see if PickupItem(158923) works for this
				if not C_ChallengeMode.GetSlottedKeystoneInfo() then
					for bag = 0, NUM_BAG_SLOTS do
						for slot = 1, GetContainerNumSlots(bag) do
							if GetContainerItemID == 158923 then
								PickupContainerItem(bag, slot)
								if CursorHasItem() then
									C_ChallengeMode.SlotKeystone()
								end
							end
						end
					end
				end
			end)
			self:UnregisterEvent(event)
		end
	end)
	f:RegisterEvent('ADDON_LOADED')
end]]

--------------------
do 
    local f = CreateFrame("Frame"); 
    f:RegisterEvent("ADDON_LOADED") 
    f:SetScript("OnEvent", function(self, event, addon) 
        if addon ~= "Blizzard_ChallengesUI" then return end 
        local levels = {nil, 435, 435, 440, 445, 445, 450, 450, 455, 455, 455, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460} 
        local titans = {nil, 440, 445, 450, 450, 455, 460, 460, 465, 465, 465, 470, 470, 475, 475, 475, 475, 475, 475, 475, 475, 475, 475, 475, 475}
        ChallengesFrame.WeeklyInfo.Child.WeeklyChest:HookScript("OnEnter", function(self) 
            if GameTooltip:IsVisible() then 
                GameTooltip:AddLine("|cff00ff00".."钥石层数  奖励装等  低保装等".."|r") 
                local start = 2 
                if self.level and self.level > 0 then 
                    start = self.level - 3 
                elseif self.ownedKeystoneLevel and self.ownedKeystoneLevel > 0 then 
                    start = self.ownedKeystoneLevel - 5 
                end 
                for i = start, start + 9 do 
                    if levels[i] or titans[i] then 
                        local line = "    %2d层 |T130758:10:35:0:0:32:32:10:22:10:22|t %s |T130758:10:25:0:0:32:32:10:22:10:22|t %s" 
                        local level = levels[i] and format("%d", levels[i]) or " ? " 
                        local titan = titans[i] and format("%4d", titans[i]) or "  ? " 
                    if i == self.level then line = "|cff00ff00"..line.."|r" end
                        GameTooltip:AddLine(format(line, i, level, titan)) 
                    else 
                        break 
                    end 
                end 
            --GameTooltip:AddLine(" ") 
            --GameTooltip:AddLine("415随机 需要1725  分解返365")
            --GameTooltip:AddLine("430随机 需要9000  分解返2000")
            --GameTooltip:AddLine("445随机 需要47500 分解返10000")
            --GameTooltip:AddLine("445指定 需要20万")
            --GameTooltip:AddLine("分解400返115 385返35 370返12")
            --GameTooltip:AddLine("仅分解|cffff0000同甲|r特质装才返")
            --GameTooltip:Show() 
            end 
        end) 
    end) 
end