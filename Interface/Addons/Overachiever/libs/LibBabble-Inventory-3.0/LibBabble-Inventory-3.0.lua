--[[
Name: LibBabble-Inventory-3.0
Revision: $Rev: 201 $
Maintainers: ckknight, nevcairiel, Ackis
Website: http://www.wowace.com/projects/libbabble-inventory-3-0/
Dependencies: None
License: MIT
]]

local MAJOR_VERSION = "LibBabble-Inventory-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Rev: 201 $"):match("%d+"))

if not LibStub then error(MAJOR_VERSION .. " requires LibStub.") end
local lib = LibStub("LibBabble-3.0"):New(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

local GAME_LOCALE = GetLocale()

lib:SetBaseTranslations {
	["Alchemy"] = "Alchemy",
	["Ammo Pouch"] = "Ammo Pouch",
	["Aquatic"] = "Aquatic",
	["Archaeology"] = "Archaeology",
	["Armor"] = "Armor",
	["Armor Enchantment"] = "Armor Enchantment",
	["Arrow"] = "Arrow",
	["Axe"] = "Axe",
	["Back"] = "Back",
	["Bag"] = "Bag",
	["Bandage"] = "Bandage",
	["Beast"] = "Beast",
	["Blacksmithing"] = "Blacksmithing",
	["Blue"] = "Blue",
	["Book"] = "Book",
	["Bow"] = "Bow",
	["Bows"] = "Bows",
	["Bullet"] = "Bullet",
	["Chest"] = "Chest",
	["Cloth"] = "Cloth",
	["Cogwheel"] = "Cogwheel",
	["Companion"] = "Companion",
	["Companion Pets"] = "Companion Pets",
	["Companions"] = "Companions",
	["Consumable"] = "Consumable",
	["Container"] = "Container",
	["Cooking"] = "Cooking",
	["Cooking Bag"] = "Cooking Bag",
	["Cosmetic"] = "Cosmetic",
	["Critter"] = "Critter",
	["Crossbow"] = "Crossbow",
	["Crossbows"] = "Crossbows",
	["Dagger"] = "Dagger",
	["Daggers"] = "Daggers",
	["Death Knight"] = "Death Knight",
	["Devices"] = "Devices",
	["Dragonkin"] = "Dragonkin",
	["Drink"] = "Drink",
	["Druid"] = "Druid",
	["Elemental"] = "Elemental",
	["Elixir"] = "Elixir",
	["Enchant"] = "Enchant",
	["Enchanting"] = "Enchanting",
	["Enchanting Bag"] = "Enchanting Bag",
	["Engineering"] = "Engineering",
	["Engineering Bag"] = "Engineering Bag",
	["Explosives"] = "Explosives",
	["Feet"] = "Feet",
	["First Aid"] = "First Aid",
	["Fish"] = "Fish",
	["Fishing"] = "Fishing",
	["Fishing Lure"] = "Fishing Lure",
	["Fishing Pole"] = "Fishing Pole",
	["Fishing Poles"] = "Fishing Poles",
	["Fist Weapon"] = "Fist Weapon",
	["Fist Weapons"] = "Fist Weapons",
	["Flask"] = "Flask",
	["Flying"] = "Flying",
	["Flying Mount"] = "Flying Mount",
	["Food"] = "Food",
	["Food & Drink"] = "Food & Drink",
	["Gem"] = "Gem",
	["Gem Bag"] = "Gem Bag",
	["Glyph"] = "Glyph",
	["Green"] = "Green",
	["Ground Mount"] = "Ground Mount",
	["Gun"] = "Gun",
	["Guns"] = "Guns",
	["Hands"] = "Hands",
	["Head"] = "Head",
	["Held in Off-Hand"] = "Held in Off-Hand",
	["Herb"] = "Herb",
	["Herb Bag"] = "Herb Bag",
	["Herbalism"] = "Herbalism",
	["Holiday"] = "Holiday",
	["Humanoid"] = "Humanoid",
	["Hunter"] = "Hunter",
	["Hydraulic"] = "Hydraulic",
	["Idol"] = "Idol",
	["Idols"] = "Idols",
	["Inscription"] = "Inscription",
	["Inscription Bag"] = "Inscription Bag",
	["Item Enchantment"] = "Item Enchantment",
	["Item Enhancement"] = "Item Enhancement",
	["Jewelcrafting"] = "Jewelcrafting",
	["Junk"] = "Junk",
	["Key"] = "Key",
	["Leather"] = "Leather",
	["Leatherworking"] = "Leatherworking",
	["Leatherworking Bag"] = "Leatherworking Bag",
	["Legs"] = "Legs",
	["Libram"] = "Libram",
	["Librams"] = "Librams",
	["Mace"] = "Mace",
	["Mage"] = "Mage",
	["Magic"] = "Magic",
	["Mail"] = "Mail",
	["Main Hand"] = "Main Hand",
	["Materials"] = "Materials",
	["Meat"] = "Meat",
	["Mechanical"] = "Mechanical",
	["Meta"] = "Meta",
	["Metal & Stone"] = "Metal & Stone",
	["Mining"] = "Mining",
	["Mining Bag"] = "Mining Bag",
	["Miscellaneous"] = "Miscellaneous",
	["Money"] = "Money",
	["Monk"] = "Monk",
	["Mount"] = "Mount",
	["Mounts"] = "Mounts",
	["Naval Equipment"] = "Naval Equipment",
	["Neck"] = "Neck",
	["Off Hand"] = "Off Hand",
	["One-Hand"] = "One-Hand",
	["One-Handed Axes"] = "One-Handed Axes",
	["One-Handed Maces"] = "One-Handed Maces",
	["One-Handed Swords"] = "One-Handed Swords",
	["Orange"] = "Orange",
	["Other"] = "Other",
	["Paladin"] = "Paladin",
	["Parts"] = "Parts",
	["Pet"] = "Pet",
	["Plate"] = "Plate",
	["Polearm"] = "Polearm",
	["Polearms"] = "Polearms",
	["Potion"] = "Potion",
	["Priest"] = "Priest",
	["Prismatic"] = "Prismatic",
	["Projectile"] = "Projectile",
	["Purple"] = "Purple",
	["Quest"] = "Quest",
	["Quiver"] = "Quiver",
	["Ranged"] = "Ranged",
	["Reagent"] = "Reagent",
	["Recipe"] = "Recipe",
	["Red"] = "Red",
	["Relic"] = "Relic",
	["Riding"] = "Riding",
	["Ring"] = "Ring",
	["Rogue"] = "Rogue",
	["Scroll"] = "Scroll",
	["Shaman"] = "Shaman",
	["Shield"] = "Shield",
	["Shields"] = "Shields",
	["Shirt"] = "Shirt",
	["Shoulder"] = "Shoulder",
	["Sigils"] = "Sigils",
	["Simple"] = "Simple",
	["Skinning"] = "Skinning",
	["Soul Bag"] = "Soul Bag",
	["Staff"] = "Staff",
	["Staves"] = "Staves",
	["Sword"] = "Sword",
	["Tabard"] = "Tabard",
	["Tabards"] = "Tabards",
	["Tackle Box"] = "Tackle Box",
	["Tailoring"] = "Tailoring",
	["Thrown"] = "Thrown",
	["Totem"] = "Totem",
	["Totems"] = "Totems",
	["Trade Goods"] = "Trade Goods",
	["Trinket"] = "Trinket",
	["Two-Hand"] = "Two-Hand",
	["Two-Handed Axes"] = "Two-Handed Axes",
	["Two-Handed Maces"] = "Two-Handed Maces",
	["Two-Handed Swords"] = "Two-Handed Swords",
	["Undead"] = "Undead",
	["Waist"] = "Waist",
	["Wand"] = "Wand",
	["Wands"] = "Wands",
	["Warglaives"] = "Warglaives",
	["Warlock"] = "Warlock",
	["Warrior"] = "Warrior",
	["Weapon"] = "Weapon",
	["Weapon Enchantment"] = "Weapon Enchantment",
	["Wrist"] = "Wrist",
	["Yellow"] = "Yellow"
}


if GAME_LOCALE == "enUS" then
	lib:SetCurrentTranslations(true)
elseif GAME_LOCALE == "zhCN" then
	lib:SetCurrentTranslations {
	["Alchemy"] = "炼金术",
	["Ammo Pouch"] = "弹药袋",
	["Aquatic"] = "水栖",
	["Archaeology"] = "考古学",
	["Armor"] = "护甲",
	["Armor Enchantment"] = "护甲强化",
	["Arrow"] = "箭",
	["Axe"] = "斧",
	["Back"] = "背部",
	["Bag"] = "容器",
	["Bandage"] = "绷带",
	["Beast"] = "野兽",
	["Blacksmithing"] = "锻造",
	["Blue"] = "蓝色",
	["Book"] = "书籍",
	["Bow"] = "弓",
	["Bows"] = "弓",
	["Bullet"] = "子弹",
	["Chest"] = "胸部",
	["Cloth"] = "布甲",
	["Cogwheel"] = "齿轮",
	["Companion"] = "小伙伴",
	["Companion Pets"] = "小伙伴",
	["Companions"] = "小伙伴",
	["Consumable"] = "消耗品",
	["Container"] = "容器",
	["Cooking"] = "烹饪",
	["Cooking Bag"] = "烹饪包",
	["Cosmetic"] = "装饰品",
	["Critter"] = "小动物",
	["Crossbow"] = "弩",
	["Crossbows"] = "弩",
	["Dagger"] = "匕首",
	["Daggers"] = "匕首",
	["Death Knight"] = "死亡骑士",
	["Devices"] = "装置",
	["Dragonkin"] = "龙类",
	["Drink"] = "饮料",
	["Druid"] = "德鲁伊",
	["Elemental"] = "元素",
	["Elixir"] = "药剂",
	["Enchant"] = "附魔",
	["Enchanting"] = "附魔",
	["Enchanting Bag"] = "附魔材料袋",
	["Engineering"] = "工程学",
	["Engineering Bag"] = "工程学材料袋",
	["Explosives"] = "爆炸物",
	["Feet"] = "脚",
	["First Aid"] = "急救",
	["Fish"] = "魚",
	["Fishing"] = "钓鱼",
	["Fishing Lure"] = "鱼饵",
	["Fishing Pole"] = "鱼竿",
	["Fishing Poles"] = "鱼竿",
	["Fist Weapon"] = "拳套",
	["Fist Weapons"] = "拳套",
	["Flask"] = "合剂",
	["Flying"] = "飞行",
	["Flying Mount"] = "飞行坐骑",
	["Food"] = "食物",
	["Food & Drink"] = "食物和饮料",
	["Gem"] = "宝石",
	["Gem Bag"] = "宝石袋",
	["Glyph"] = "雕文",
	["Green"] = "绿色",
	["Ground Mount"] = "地面坐骑",
	["Gun"] = "枪械",
	["Guns"] = "枪械",
	["Hands"] = "手",
	["Head"] = "头部",
	["Held in Off-Hand"] = "副手物品",
	["Herb"] = "草药",
	["Herb Bag"] = "草药袋",
	["Herbalism"] = "草药学",
	["Holiday"] = "节日",
	["Humanoid"] = "人型",
	["Hunter"] = "猎人",
	["Hydraulic"] = "液压",
	["Idol"] = "神像",
	["Idols"] = "神像",
	["Inscription"] = "铭文",
	["Inscription Bag"] = "铭文包",
	["Item Enchantment"] = "物品强化",
	["Item Enhancement"] = "物品强化",
	["Jewelcrafting"] = "珠宝加工",
	["Junk"] = "垃圾",
	["Key"] = "钥匙",
	["Leather"] = "皮甲",
	["Leatherworking"] = "制皮",
	["Leatherworking Bag"] = "制皮材料袋",
	["Legs"] = "腿部",
	["Libram"] = "圣契",
	["Librams"] = "圣契",
	["Mace"] = "锤",
	["Mage"] = "法师",
	["Magic"] = "魔法",
	["Mail"] = "锁甲",
	["Main Hand"] = "主手",
	["Materials"] = "原料",
	["Meat"] = "肉类",
	["Mechanical"] = "机械",
	["Meta"] = "多彩",
	["Metal & Stone"] = "金属和矿石",
	["Mining"] = "采矿",
	["Mining Bag"] = "矿石袋",
	["Miscellaneous"] = "其它",
	["Money"] = "金钱",
	["Monk"] = "武僧",
	["Mount"] = "坐骑",
	["Mounts"] = "坐骑",
	["Naval Equipment"] = "海军装备",
	["Neck"] = "颈部",
	["Off Hand"] = "副手",
	["One-Hand"] = "单手",
	["One-Handed Axes"] = "单手斧",
	["One-Handed Maces"] = "单手锤",
	["One-Handed Swords"] = "单手剑",
	["Orange"] = "橙色",
	["Other"] = "其它",
	["Paladin"] = "圣骑士",
	["Parts"] = "零件",
	["Pet"] = "宠物",
	["Plate"] = "板甲",
	["Polearm"] = "长柄武器",
	["Polearms"] = "长柄武器",
	["Potion"] = "药水",
	["Priest"] = "牧师",
	["Prismatic"] = "棱彩",
	["Projectile"] = "弹药",
	["Purple"] = "紫色",
	["Quest"] = "任务",
	["Quiver"] = "箭袋",
	["Ranged"] = "远程",
	["Reagent"] = "材料",
	["Recipe"] = "配方",
	["Red"] = "红色",
	["Relic"] = "圣物",
	["Riding"] = "骑术",
	["Ring"] = "手指",
	["Rogue"] = "潜行者",
	["Scroll"] = "卷轴",
	["Shaman"] = "萨满祭司",
	["Shield"] = "盾牌",
	["Shields"] = "盾牌",
	["Shirt"] = "衬衫",
	["Shoulder"] = "肩部",
	["Sigils"] = "魔印",
	["Simple"] = "简易",
	["Skinning"] = "剥皮",
	["Soul Bag"] = "灵魂袋",
	["Staff"] = "法杖",
	["Staves"] = "法杖",
	["Sword"] = "剑",
	["Tabard"] = "战袍",
	["Tabards"] = "战袍",
	["Tackle Box"] = "工具箱 ",
	["Tailoring"] = "裁缝",
	["Thrown"] = "投掷武器",
	["Totem"] = "图腾",
	["Totems"] = "图腾",
	["Trade Goods"] = "商品",
	["Trinket"] = "饰品",
	["Two-Hand"] = "双手",
	["Two-Handed Axes"] = "双手斧",
	["Two-Handed Maces"] = "双手锤",
	["Two-Handed Swords"] = "双手剑",
	["Undead"] = "亡灵",
	["Waist"] = "腰部",
	["Wand"] = "魔杖",
	["Wands"] = "魔杖",
	--Translation missing 
	-- ["Warglaives"] = "Warglaives",
	["Warlock"] = "术士",
	["Warrior"] = "战士",
	["Weapon"] = "武器",
	["Weapon Enchantment"] = "武器强化",
	["Wrist"] = "手腕",
	["Yellow"] = "黄色"
}
elseif GAME_LOCALE == "zhTW" then
	lib:SetCurrentTranslations {
	["Alchemy"] = "鍊金術",
	["Ammo Pouch"] = "彈藥包",
	["Aquatic"] = "水棲生物",
	["Archaeology"] = "考古學",
	["Armor"] = "護甲",
	["Armor Enchantment"] = "護甲附魔",
	["Arrow"] = "箭",
	["Axe"] = "斧",
	["Back"] = "背部",
	["Bag"] = "容器",
	["Bandage"] = "繃帶",
	["Beast"] = "野獸",
	["Blacksmithing"] = "鍛造",
	["Blue"] = "藍色",
	["Book"] = "書籍",
	["Bow"] = "弓",
	["Bows"] = "弓",
	["Bullet"] = "子彈",
	["Chest"] = "胸部",
	["Cloth"] = "布甲",
	["Cogwheel"] = "榫輪",
	["Companion"] = "夥伴",
	["Companion Pets"] = "寵物",
	["Companions"] = "夥伴們",
	["Consumable"] = "消耗品",
	["Container"] = "容器",
	["Cooking"] = "烹飪",
	["Cooking Bag"] = "烹飪包",
	["Cosmetic"] = "造型",
	["Critter"] = "小動物",
	["Crossbow"] = "弩",
	["Crossbows"] = "弩",
	["Dagger"] = "匕首",
	["Daggers"] = "匕首",
	["Death Knight"] = "死亡騎士",
	["Devices"] = "裝置",
	["Dragonkin"] = "龍類生物",
	["Drink"] = "飲料",
	["Druid"] = "德魯伊",
	["Elemental"] = "元素材料",
	["Elixir"] = "藥劑",
	["Enchant"] = "附魔",
	["Enchanting"] = "附魔",
	["Enchanting Bag"] = "附魔包",
	["Engineering"] = "工程學",
	["Engineering Bag"] = "工程包",
	["Explosives"] = "爆炸物",
	["Feet"] = "腳",
	["First Aid"] = "急救",
	["Fish"] = "釣魚",
	["Fishing"] = "釣魚",
	["Fishing Lure"] = "魚餌",
	["Fishing Pole"] = "魚竿",
	["Fishing Poles"] = "魚竿",
	["Fist Weapon"] = "拳套",
	["Fist Weapons"] = "拳套",
	["Flask"] = "精煉藥劑",
	["Flying"] = "飛行生物",
	["Flying Mount"] = "飛行坐騎",
	["Food"] = "食物",
	["Food & Drink"] = "食物和飲料",
	["Gem"] = "寶石",
	["Gem Bag"] = "寶石包",
	["Glyph"] = "雕紋",
	["Green"] = "綠色",
	["Ground Mount"] = "陸行座騎",
	["Gun"] = "槍械",
	["Guns"] = "槍械",
	["Hands"] = "手",
	["Head"] = "頭部",
	["Held in Off-Hand"] = "副手物品",
	["Herb"] = "草藥",
	["Herb Bag"] = "草藥包",
	["Herbalism"] = "草藥學",
	["Holiday"] = "節慶用品",
	["Humanoid"] = "人形生物",
	["Hunter"] = "獵人",
	["Hydraulic"] = "液壓",
	["Idol"] = "塑像",
	["Idols"] = "塑像",
	["Inscription"] = "銘文學",
	["Inscription Bag"] = "銘文包",
	["Item Enchantment"] = "物品附魔",
	["Item Enhancement"] = "物品強化",
	["Jewelcrafting"] = "珠寶設計",
	["Junk"] = "垃圾",
	["Key"] = "鑰匙",
	["Leather"] = "皮甲",
	["Leatherworking"] = "製皮",
	["Leatherworking Bag"] = "製皮包",
	["Legs"] = "腿部",
	["Libram"] = "聖契",
	["Librams"] = "聖契",
	["Mace"] = "錘",
	["Mage"] = "法師",
	["Magic"] = "魔法生物",
	["Mail"] = "鎖甲",
	["Main Hand"] = "主手",
	["Materials"] = "原料",
	["Meat"] = "肉類",
	["Mechanical"] = "機械生物",
	["Meta"] = "變換",
	["Metal & Stone"] = "金屬與石頭",
	["Mining"] = "採礦",
	["Mining Bag"] = "礦石包",
	["Miscellaneous"] = "其他",
	["Money"] = "金錢",
	["Monk"] = "武僧",
	["Mount"] = "座騎",
	["Mounts"] = "座騎",
	["Naval Equipment"] = "船艦設備",
	["Neck"] = "頸部",
	["Off Hand"] = "副手",
	["One-Hand"] = "單手",
	["One-Handed Axes"] = "單手斧",
	["One-Handed Maces"] = "單手錘",
	["One-Handed Swords"] = "單手劍",
	["Orange"] = "橘色",
	["Other"] = "其他",
	["Paladin"] = "聖騎士",
	["Parts"] = "零件",
	["Pet"] = "寵物",
	["Plate"] = "鎧甲",
	["Polearm"] = "長柄武器",
	["Polearms"] = "長柄武器",
	["Potion"] = "藥水",
	["Priest"] = "牧師",
	["Prismatic"] = "稜彩",
	["Projectile"] = "彈藥",
	["Purple"] = "紫色",
	["Quest"] = "任務",
	["Quiver"] = "箭袋",
	["Ranged"] = "遠程",
	["Reagent"] = "施法材料",
	["Recipe"] = "配方",
	["Red"] = "紅色",
	["Relic"] = "聖物",
	["Riding"] = "騎術",
	["Ring"] = "手指",
	["Rogue"] = "盜賊",
	["Scroll"] = "卷軸",
	["Shaman"] = "薩滿",
	["Shield"] = "盾牌",
	["Shields"] = "盾牌",
	["Shirt"] = "襯衣",
	["Shoulder"] = "肩部",
	["Sigils"] = "符印",
	["Simple"] = "簡單",
	["Skinning"] = "剝皮",
	["Soul Bag"] = "靈魂裂片包",
	["Staff"] = "法杖",
	["Staves"] = "法杖",
	["Sword"] = "劍",
	["Tabard"] = "外袍",
	["Tabards"] = "外袍",
	["Tackle Box"] = "工具箱",
	["Tailoring"] = "裁縫",
	["Thrown"] = "投擲武器",
	["Totem"] = "圖騰",
	["Totems"] = "圖騰",
	["Trade Goods"] = "商品",
	["Trinket"] = "飾品",
	["Two-Hand"] = "雙手",
	["Two-Handed Axes"] = "雙手斧",
	["Two-Handed Maces"] = "雙手錘",
	["Two-Handed Swords"] = "雙手劍",
	["Undead"] = "不死生物",
	["Waist"] = "腰部",
	["Wand"] = "魔杖",
	["Wands"] = "魔杖",
	["Warglaives"] = "戰刃",
	["Warlock"] = "術士",
	["Warrior"] = "戰士",
	["Weapon"] = "武器",
	["Weapon Enchantment"] = "武器附魔",
	["Wrist"] = "手腕",
	["Yellow"] = "黃色"
}
else
	error(("%s: Locale %q not supported"):format(MAJOR_VERSION, GAME_LOCALE))
end
