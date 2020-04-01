--## Version: 1.6.2  ## Author: Anayanka (Defias Brotherhood - EU)
CorruptionDateR = {
    ["6455"] = {"Avoidant", "I", 315607},
    ["6483"] = {"Avoidant", "I [10/15/20]", 315607},
    ["6484"] = {"Avoidant", "II [10/15/20]", 315608},
    ["6485"] = {"Avoidant", "III [10/15/20]", 315609},
    ["6474"] = {"Expedient", "I [10/15/20]", 315544},
    ["6475"] = {"Expedient", "II [10/15/20]", 315545},
    ["6476"] = {"Expedient", "III [10/15/20]", 315546},
    ["6471"] = {"Masterful", "I [10/15/20]", 315529},
    ["6472"] = {"Masterful", "II [10/15/20]", 315530},
    ["6473"] = {"Masterful", "III [10/15/20]", 315531},
    ["6480"] = {"Severe", "I [10/15/20]", 315554},
    ["6481"] = {"Severe", "II [10/15/20]", 315557},
    ["6482"] = {"Severe", "III [10/15/20]", 315558},
    ["6477"] = {"Versatile", "I [10/15/20]", 315549},
    ["6478"] = {"Versatile", "II [10/15/20]", 315552},
    ["6479"] = {"Versatile", "III [10/15/20]", 315553},
    ["6493"] = {"Siphoner", "I [10/15/20]", 315590},
    ["6494"] = {"Siphoner", "II [10/15/20]", 315591},
    ["6495"] = {"Siphoner", "III [10/15/20]", 315592},
    ["6437"] = {"Strikethrough", "I [10/15/20]", 315277},
    ["6438"] = {"Strikethrough", "II [10/15/20]", 315281},
    ["6439"] = {"Strikethrough", "III [10/15/20]", 315282},
    ["6555"] = {"Racing Pulse", "I [15/20/35]", 318266},
    ["6559"] = {"Racing Pulse", "II [15/20/35]", 318492},
    ["6560"] = {"Racing Pulse", "III [15/20/35]", 318496},
    ["6556"] = {"Deadly Momentum", "I [15/20/35]", 318268},
    ["6561"] = {"Deadly Momentum", "II [15/20/35]", 318493},
    ["6562"] = {"Deadly Momentum", "III [15/20/35]", 318497},
    ["6558"] = {"Surging Vitality", "I [15/20/35]", 318270},
    ["6565"] = {"Surging Vitality", "II [15/20/35]", 318495},
    ["6566"] = {"Surging Vitality", "III [15/20/35]", 318499},
    ["6557"] = {"Honed Mind", "I [15/20/35]", 318269},
    ["6563"] = {"Honed Mind", "II [15/20/35]", 318494},
    ["6564"] = {"Honed Mind", "III [15/20/35]", 318498},
    ["6549"] = {"Echoing Void", "I [25/35/60]", 318280},
    ["6550"] = {"Echoing Void", "II [25/35/60]", 318485},
    ["6551"] = {"Echoing Void", "III [25/35/60]", 318486},
    ["6552"] = {"Infinite Stars", "I [25/50/75]", 318274},
    ["6553"] = {"Infinite Stars", "II [25/50/75]", 318487},
    ["6554"] = {"Infinite Stars", "III [25/50/75]", 318488},
    ["6547"] = {"Ineffable Truth", "I [12/30]", 318303},
    ["6548"] = {"Ineffable Truth", "II [12/30]", 318484},
    ["6537"] = {"Twilight Devastation", "I [25/50/75]", 318276},
    ["6538"] = {"Twilight Devastation", "II [25/50/75]", 318477},
    ["6539"] = {"Twilight Devastation", "III [25/50/75]", 318478},
    ["6543"] = {"Twisted Appendage", "I [10/35/66]", 318481},
    ["6544"] = {"Twisted Appendage", "II [10/35/66]", 318482},
    ["6545"] = {"Twisted Appendage", "III [10/35/66]", 318483},
    ["6540"] = {"Void Ritual", "I [15/35/66]", 318286},
    ["6541"] = {"Void Ritual", "II [15/35/66]", 318479},
    ["6542"] = {"Void Ritual", "III [15/35/66]", 318480},
    ["6573"] = {"Gushing Wound", "", 318272},
    ["6546"] = {"Glimpse of Clarity", "", 318239},
    ["6571"] = {"Searing Flames", "", 318293},
    ["6572"] = {"Obsidian Skin", "", 316651},
    ["6567"] = {"Devour Vitality", "", 318294},
    ["6568"] = {"Whispered Truths", "", 316780},
    ["6570"] = {"Flash of Insight", "", 318299},
    ["6569"] = {"Lash of the Void", "", 317290},
}

-- fixed weapon bonuses for EJ
CorruptionDateW = {
    ["172199"] = "6571", -- Faralos, Empire's Dream
    ["172200"] = "6572", -- Sk'shuul Vaz
    ["172191"] = "6567", -- An'zig Vra
    ["172193"] = "6568", -- Whispering Eldritch Bow
    ["172198"] = "6570", -- Mar'kowa, the Mindpiercer
    ["172197"] = "6569", -- Unguent Caress
    ["172227"] = "6544", -- Shard of the Black Empire
    ["172196"] = "6541", -- Vorzz Yoq'al
    ["174106"] = "6550", -- Qwor N'lyeth
    ["172189"] = "6548", -- Eyestalk of Il'gynoth
    ["174108"] = "6553", -- Shgla'yos, Astral Malignity
    ["172187"] = "6539", -- Devastation's Hour
}
CorruptionTooltips = LibStub("AceAddon-3.0"):NewAddon("CorruptionTooltips", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")

local defaults = {
    profile = {
        append = true,
        summary = true,
        english = false,
        icon = true,
    }
}

local function GetItemSplit(itemLink)
  local itemString = string.match(itemLink, "item:([%-?%d:]+)")
  local itemSplit = {}
  -- Split data into a table
  for _, v in ipairs({strsplit(":", itemString)}) do
    if v == "" then
      itemSplit[#itemSplit + 1] = 0
    else
      itemSplit[#itemSplit + 1] = tonumber(v)
    end
  end
  return itemSplit
end

function CorruptionTooltips:Append(tooltip, line)
    if defaults.profile.append then
        local detected
        for i = 1, tooltip:NumLines() do
            local left = _G[tooltip:GetName().."TextLeft"..i]
            local text = left:GetText()
            if (text ~= nil) then
                local detected = string.find(text, ITEM_MOD_CORRUPTION)
                if (detected ~= nil and (strsub(text, 1, 1) == "+")) then
                    left:SetText(left:GetText().." / "..line)
                    return true
                end
            end
        end
    end
end


function CorruptionTooltips:GetCorruption(bonuses)
    if #bonuses > 0 then
        for i, bonus_id in pairs(bonuses) do
            bonus_id = tostring(bonus_id)
            if CorruptionDateR[bonus_id] ~= nil then
                local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(CorruptionDateR[bonus_id][3])
                if CorruptionDateR[bonus_id][2] ~= "" then
                    rank = CorruptionDateR[bonus_id][2]
                else
                    rank = ""
                end
                if defaults.profile.english then
                    name = CorruptionDateR[bonus_id][1]
                    rank = CorruptionDateR[bonus_id][2]
                end
                return {
                    name.." "..rank,
                    icon,
                }
            end
        end
    end
end


function CorruptionTooltips:CreateTooltip(tooltip)
	local name, item = tooltip:GetItem()
  	if not name then return end
  	if IsCorruptedItem(item) then
        local itemSplit = GetItemSplit(item)
        local bonuses = {}
        for index=1, itemSplit[13] do
            bonuses[#bonuses + 1] = itemSplit[13 + index]
        end
        -- local lookup for items without bonuses, like in the EJ
        if itemSplit[13] == 1 then
            local itemID = tostring(itemSplit[1])
            if CorruptionDateW[itemID] ~= nil then
                bonuses[#bonuses + 1] = CorruptionDateW[itemID]
            end
        end
		local corruption = CorruptionTooltips:GetCorruption(bonuses)
		if corruption then
			local name = corruption[1]
			local icon = corruption[2]
            local line = '|T'..icon..':0|t '..'|cff956dd1'..name..'|r'
            if defaults.profile.icon ~= true then
                line = '|cff956dd1'..name..'|r'
            end
			if CorruptionTooltips:Append(tooltip, line) ~= true then
                --tooltip:AddLine(" ")
                tooltip:AddLine(line)
			end
		end
	end
end

function CorruptionTooltips:TooltipHook(frame)
	self:CreateTooltip(frame)
end

function CorruptionTooltips:GetCorruptions()
    local corruptions = {}
    local slotNames = {
        "HeadSlot", -- [1]
        "NeckSlot", -- [2]
        "ShoulderSlot", -- [3]
        "BackSlot", -- [4]
        "ChestSlot", -- [5]
        "ShirtSlot", -- [6]
        "TabardSlot", -- [7]
        "WristSlot", -- [8]
        "HandsSlot", -- [9]
        "WaistSlot", -- [10]
        "LegsSlot", -- [11]
        "FeetSlot", -- [12]
        "Finger0Slot", -- [13]
        "Finger1Slot", -- [14]
        "Trinket0Slot", -- [15]
        "Trinket1Slot", -- [16]
        "MainHandSlot", -- [17]
        "SecondaryHandSlot", -- [18]
        "AmmoSlot" -- [19]
    }
    for slotNum=1, #slotNames do
        local slotId = GetInventorySlotInfo(slotNames[slotNum])
        local itemLink = GetInventoryItemLink('player', slotId)
        if itemLink then
            local itemSplit = GetItemSplit(itemLink)
            local bonuses = {}
            for index=1, itemSplit[13] do
                bonuses[#bonuses + 1] = itemSplit[13 + index]
            end
            local corruption = CorruptionTooltips:GetCorruption(bonuses)
            if corruption then
                corruptions[#corruptions + 1] = corruption
            end
        end
    end
    return corruptions
end

function CorruptionTooltips:SummaryHook(frame)
    if defaults.profile.summary then
        local corruptions = CorruptionTooltips:GetCorruptions()
        if #corruptions > 0 then
            GameTooltip:AddLine(" ")
            local buckets = {}
            for i=1, #corruptions do
                local name = corruptions[i][1]
                local icon = corruptions[i][2]
                local line = '|T'..icon..':0|t '..'|cff956dd1'..name..'|r'
                if defaults.profile.icon ~= true then
                    line = '|cff956dd1'..name..'|r'
                end

                if buckets[name] == nil then
                    buckets[name] = {
                        1,
                        line,
                    }
                else
                    buckets[name][1]= buckets[name][1] + 1
                end
            end
            table.sort(buckets)
            for name, _ in pairs(buckets) do
                GameTooltip:AddLine("  |cff956dd1"..buckets[name][2]..' x '..buckets[name][1].."|r")
            end
            GameTooltip:Show()
        end
    end
end

function CorruptionTooltips:OnEnable()
    self:SecureHookScript(GameTooltip, 'OnTooltipSetItem', 'TooltipHook')
    self:SecureHookScript(ItemRefTooltip, 'OnTooltipSetItem', 'TooltipHook')
    self:SecureHookScript(ShoppingTooltip1, 'OnTooltipSetItem', 'TooltipHook')
    self:SecureHookScript(ShoppingTooltip2, 'OnTooltipSetItem', 'TooltipHook')
    self:SecureHookScript(EmbeddedItemTooltip, 'OnTooltipSetItem', 'TooltipHook')
    self:SecureHookScript(CharacterStatsPane.ItemLevelFrame.Corruption, 'OnEnter', 'SummaryHook')
end