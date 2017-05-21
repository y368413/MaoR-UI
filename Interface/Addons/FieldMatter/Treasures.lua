﻿local DRTS = {}
local arrowAvailable, arrowTextAvailable = false, false

local UnitPosition, IsQuestFlaggedCompleted = UnitPosition, IsQuestFlaggedCompleted
local GetCurrentMapDungeonLevel, GetCurrentMapZone, GetCurrentMapAreaID, GetAreaMapInfo, GetPOITextureCoords = GetCurrentMapDungeonLevel, GetCurrentMapZone, GetCurrentMapAreaID, GetAreaMapInfo, GetPOITextureCoords
local abs, format, select, pairs = math.abs, format, select, pairs

if not DRTSOptions then
    DRTSOptions = {
        enabled = true,
        debug = false,
        arrowEnabled = true,
        ignoretm = false,
        minimap = true,
	surprise = true,    --惊喜模式，靠近宝藏180码才显示箭头
        hidden = { },
    }
end

local TreasureContinentsIds = {
    [1116] = 13, -- Draenor
    [1152] = 13, -- Garrison Level 1 (H)
    [1330] = 13, -- Garrison Level 2 (H)
    [1153] = 13, -- Garrison Level 3 (H)
    [1158] = 13, -- Garrison Level 1 (A)
    [1331] = 13, -- Garrison Level 2 (A)
    [1159] = 13, -- Garrison Level 3 (A)
    [1464] = 13, -- Tanaan Jungle
    [1220] = 14, -- Broken Isles
}

local TreasureQuestsDesc = {
    [36466] = "塔拉多",
    [36467] = "阿兰卡峰",
    [36465] = "戈尔德隆",
    [34557] = "霜火岭",
    [36468] = "纳格兰",
    [36464] = "影月谷",
    [36249] = "需要伐木场",
    [36250] = "需要伐木场",
    [36251] = "需要搏击场",
    [36252] = "需要搏击场",
    [39463] = "塔纳安丛林",
	[1015] = "阿苏纳", -- Azsuna
	[1017] = "风暴峡湾", -- Tornheim
	[1018] = "瓦尔莎拉", -- Val'sharah
	[1024] = "至高岭", -- Haut-roc
	[1033] = "苏拉玛", -- Suramar
}

local alltreasures = {

------------------------------------------ LEGION --------------------------------------------
    { id = 3104, continent = 13, x = 7169.229, y = 6024.37, name = "Arena Spectator's Chest", desc = "", flags = 131073, quests = { 34557, 33501, 0, 0 } },
    --{ id = 3105, continent = 13, x = 7257.686, y = 6089.362, name = "Arena Master's Warhorn", desc = "", flags = 131073, quests = { 34557, 33916, 0, 0 } },
    { id = 3107, continent = 13, x = 6457.64, y = 5789.28, name = "Slave's Stash", desc = "", flags = 131073, quests = { 34557, 33500, 0, 0 } },
    { id = 3109, continent = 13, x = 7882.47, y = 6167.6, name = "Lagoon Pool", desc = "", flags = 131073, quests = { 34557, 33926, 0, 0 } },
    --{ id = 3114, continent = 13, x = 7512.659, y = 4439.047, name = "Fallen Ogre", desc = "", flags = 131073, quests = { 34557, 33531, 0, 0 } },
    { id = 3116, continent = 13, x = 6829.731, y = 4152.84, name = "Young Orc Traveler", desc = "", flags = 131073, quests = { 34557, 33525, 0, 0 } },
    { id = 3117, continent = 13, x = 7675.647, y = 3629.538, name = "Young Orc Woman", desc = "", flags = 131073, quests = { 34557, 33525, 0, 0 } },
    { id = 3125, continent = 13, x = 7317.838, y = 5415.456, name = "Thunderlord Cache", desc = "", flags = 131073, quests = { 34557, 32803, 0, 0 } },
    --{ id = 3162, continent = 13, x = 604.9202, y = -890.7083, name = "Hanging Satchel ", desc = "", flags = 131073, quests = { 36464, 33564, 0, 0 } },
    --{ id = 3163, continent = 13, x = -1388.733, y = -2275.856, name = "Scaly Rylakk Egg", desc = "", flags = 131073, quests = { 36464, 33564, 0, 0 } },
    --{ id = 3164, continent = 13, x = 19.0434, y = -712.0226, name = "Peaceful Offering ", desc = "", flags = 131073, quests = { 36464, 33612, 0, 0 } },
    --{ id = 3165, continent = 13, x = -47.28472, y = -662.6996, name = "Peaceful Offering ", desc = "", flags = 131073, quests = { 36464, 33611, 0, 0 } },
    --{ id = 3166, continent = 13, x = -41.40799, y = -760.842, name = "Peaceful Offering ", desc = "", flags = 131073, quests = { 36464, 33610, 0, 0 } },
    --{ id = 3167, continent = 13, x = -178.9792, y = -711.6042, name = "Peaceful Offering ", desc = "", flags = 131073, quests = { 36464, 33384, 0, 0 } },
    --{ id = 3168, continent = 13, x = -1088.89, y = -357.47, name = "Waterlogged Chest ", desc = "", flags = 131073, quests = { 36464, 33566, 0, 0 } },
    --{ id = 3169, continent = 13, x = 636.467, y = -1612.104, name = "Kaliri Egg", desc = "", flags = 131073, quests = { 36464, 33568, 0, 0 } },
    --{ id = 3171, continent = 13, x = 715.9774, y = -23.30556, name = "Veema's Herb Bag", desc = "", flags = 131073, quests = { 36464, 33866, 0, 0 } },
    --{ id = 3172, continent = 13, x = 834.6875, y = -133.0521, name = "Uzko's Knickknacks", desc = "", flags = 131073, quests = { 36464, 33540, 0, 0 } },
    { id = 3173, continent = 13, x = 736.3351, y = -309.191, name = "Greka's Urn", desc = "", flags = 131073, quests = { 36464, 33614, 0, 0 } },
    --{ id = 3174, continent = 13, x = 670.316, y = -189.0938, name = "Rovo's Dagger", desc = "", flags = 131073, quests = { 36464, 33573, 0, 0 } },
    { id = 3175, continent = 13, x = 679.4479, y = -262.375, name = "Ashes of A'kumbo", desc = "", flags = 131073, quests = { 36464, 33584, 0, 0 } },
    --{ id = 3176, continent = 13, x = 891.2639, y = 27.56597, name = "Carved Drinking Horn", desc = "", flags = 131073, quests = { 36464, 33569, 0, 0 } },
    { id = 3177, continent = 13, x = -684.5955, y = -1432.448, name = "Giant Beehive", desc = "", flags = 131073, quests = { 36464, 35580, 0, 0 } },
    --{ id = 3178, continent = 13, x = 1678.11, y = -1675.38, name = "Mikkal's Chest", desc = "", flags = 131073, quests = { 36464, 35603, 0, 0 } },
    --{ id = 3179, continent = 13, x = 916.0035, y = 176.8802, name = "Ronokk's Belongings", desc = "", flags = 131073, quests = { 36464, 33886, 0, 0 } },
    --{ id = 3180, continent = 13, x = 595.368, y = -35.28472, name = "Giant Moonwillow Seed", desc = "", flags = 131073, quests = { 36464, 33891, 0, 0 } },
    --{ id = 3181, continent = 13, x = 1410.788, y = -506.0816, name = "Armored Elekk Tusk", desc = "", flags = 131073, quests = { 36464, 33869, 0, 0 } },
    --{ id = 3182, continent = 13, x = 981.0573, y = -1035.134, name = "Astrologer's Box", desc = "", flags = 131073, quests = { 36464, 33867, 0, 0 } },
    { id = 3183, continent = 13, x = 11.6923, y = -249.389, name = "Iron Horde Tribute ", desc = "", flags = 131073, quests = { 36464, 33567, 0, 0 } },
    --{ id = 3184, continent = 13, x = 1575.71, y = -812.825, name = "Shadowmoon Exile Treasure", desc = "", flags = 131073, quests = { 36464, 33570, 0, 0 } },
    --{ id = 3185, continent = 13, x = 632.6268, y = 261.5347, name = "Sacrificial Dagger", desc = "", flags = 131073, quests = { 36464, 33571, 0, 0 } },
    --{ id = 3186, continent = 13, x = 1148.15, y = 735.252, name = "Rotting Basket", desc = "", flags = 131073, quests = { 36464, 33572, 0, 0 } },
    { id = 3187, continent = 13, x = -873.7952, y = -1157.694, name = "Vindicator's Cache", desc = "", flags = 131073, quests = { 36464, 33574, 0, 0 } },
    --{ id = 3188, continent = 13, x = 1455.448, y = 861.5313, name = "Demonic Cache", desc = "", flags = 131073, quests = { 36464, 33575, 0, 0 } },
    { id = 3189, continent = 13, x = 1627.335, y = -222.0017, name = "Bubbling Cauldron", desc = "", flags = 131073, quests = { 36464, 33613, 0, 0 } },
    --{ id = 3190, continent = 13, x = 760.875, y = -3233.625, name = "Cargo of the Raven Queen", desc = "", flags = 131073, quests = { 36464, 33885, 0, 0 } },
    { id = 3191, continent = 13, x = 2406.634, y = 491.4531, name = "Fantastic Fish", desc = "", flags = 131073, quests = { 36464, 34174, 0, 0 } },
    --{ id = 3192, continent = 13, x = 2338.802, y = 337.632, name = "Sunken Treasure", desc = "", flags = 131073, quests = { 36464, 35600, 0, 0 } },
    { id = 3193, continent = 13, x = 2549.666, y = 456.7083, name = "Stolen Treasure", desc = "", flags = 131073, quests = { 36464, 35280, 0, 0 } },
    { id = 3201, continent = 13, x = 6967.17, y = 5294.63, name = "Smoldering True Iron Deposit", desc = "", flags = 131073, quests = { 34557, 34649, 0, 0 } },
    { id = 3202, continent = 13, x = 7512.659, y = 4439.047, name = "Cragmaul Brute", desc = "", flags = 131073, quests = { 34557, 33531, 0, 0 } },
    { id = 3203, continent = 13, x = 6540.52, y = 3721.04, name = "Borokk the Devourer", desc = "", flags = 131073, quests = { 34557, 33511, 0, 0 } },
    --{ id = 3204, continent = 13, x = 7224.77, y = 6104.65, name = "Arena Master's War Horn", desc = "", flags = 131073, quests = { 34557, 33916, 0, 0 } },
    { id = 3208, continent = 13, x = 2087.788, y = 199.3316, name = "Spark's Stolen Supplies", desc = "", flags = 131073, quests = { 36464, 35289, 0, 0 } },
    --{ id = 3209, continent = 13, x = 1875.517, y = 203.6806, name = "Buried Supplies", desc = "", flags = 131073, quests = { 36464, 35381, 0, 0 } },
    { id = 3210, continent = 13, x = 1869.172, y = 196.7205, name = "Buried Supplies", desc = "", flags = 131073, quests = { 36464, 35382, 0, 0 } },
    { id = 3211, continent = 13, x = 1740.95, y = 210.0972, name = "Buried Supplies", desc = "", flags = 131073, quests = { 36464, 35384, 0, 0 } },
    { id = 3212, continent = 13, x = 1965.497, y = 333.3542, name = "Buried Supplies", desc = "", flags = 131073, quests = { 36464, 35383, 0, 0 } },
    { id = 3213, continent = 13, x = 1772.161, y = 244.6788, name = "Lunarfall Egg", desc = "", flags = 131073, quests = { 36464, 35530, 0, 0 } },
    --{ id = 3214, continent = 13, x = 810.3837, y = -194.9688, name = "Beloved Offering", desc = "", flags = 131073, quests = { 36464, 33046, 0, 0 } },
    --{ id = 3215, continent = 13, x = 650.0347, y = -1411.036, name = "Alchemist's Satchel", desc = "", flags = 131073, quests = { 36464, 35581, 0, 0 } },
    --{ id = 3216, continent = 13, x = 500.0521, y = -1270.34, name = "Relics of the Ancestors", desc = "", flags = 131073, quests = { 36464, 35584, 0, 0 } },
    --{ id = 3217, continent = 13, x = 1768.549, y = -1471.252, name = "Strange Spore", desc = "", flags = 131073, quests = { 36464, 35600, 0, 0 } },
    --{ id = 3218, continent = 13, x = 1498.639, y = -223.2205, name = "Sunken Fishing Boat", desc = "", flags = 131073, quests = { 36464, 35677, 0, 0 } },
    { id = 3219, continent = 13, x = -74.20139, y = -551.6996, name = "Iron Horde Cargo Shipment", desc = "", flags = 131073, quests = { 36464, 33041, 0, 0 } },
    --{ id = 3220, continent = 13, x = 535.507, y = -995.3489, name = "Glowing Cave Mushroom", desc = "", flags = 131073, quests = { 36464, 35798, 0, 0 } },
    --{ id = 3221, continent = 13, x = 908.7049, y = 378.6979, name = "Shadowmoon Treasure", desc = "", flags = 131073, quests = { 36464, 33883, 0, 0 } },
    { id = 3222, continent = 13, x = 5558.314, y = 5776.554, name = "Pale Fishmonger", desc = "", flags = 131073, quests = { 34557, 34470, 0, 0 } },
    { id = 3257, continent = 13, x = 3949.6, y = 2324.932, name = "Deceptia's Smoldering Boots", desc = "", flags = 65541, quests = { 33933, 33927, 36466, 0 } },
    { id = 3258, continent = 13, x = 3900.229, y = 1963.028, name = "Rook's Tacklebox", desc = "", flags = 65537, quests = { 34232, 36466, 0, 0 } },
    { id = 3465, continent = 13, x = 7190.413, y = 3729.827, name = "Jehil the Climber", desc = "", flags = 131073, quests = { 34557, 34708, 0, 0 } },
    { id = 3795, continent = 13, x = 6529.838, y = 5815.319, name = "Slave's Stash", desc = "", flags = 131073, quests = { 34557, 33500, 0, 0 } },
    { id = 3796, continent = 13, x = 6733.249, y = 5164.507, name = "Obsidian Petroglyph", desc = "", flags = 131073, quests = { 34557, 33502, 0, 0 } },
    { id = 3797, continent = 13, x = 5589.77, y = 3568.49, name = "Wiggling Egg", desc = "", flags = 131073, quests = { 34557, 33505, 0, 0 } },
    { id = 3798, continent = 13, x = 5457.753, y = 3293.088, name = "Iron Horde Supplies", desc = "", flags = 131073, quests = { 34557, 33017, 0, 0 } },
    { id = 3799, continent = 13, x = 7574.577, y = 5080.94, name = "Cragmaul Cache", desc = "", flags = 131073, quests = { 34557, 33532, 0, 0 } },
    { id = 3800, continent = 13, x = 7257.686, y = 6089.362, name = "Arena Master's War Horn", desc = "", flags = 131073, quests = { 34557, 33916, 0, 0 } },
    { id = 3802, continent = 13, x = 6980.578, y = 4897.733, name = "Crag-Leaper's Cache", desc = "", flags = 131073, quests = { 34557, 33940, 0, 0 } },
    { id = 3803, continent = 13, x = 6247.956, y = 6520.465, name = "Supply Dump", desc = "", flags = 131073, quests = { 34557, 33942, 0, 0 } },
    { id = 3804, continent = 13, x = 7225.838, y = 3548.812, name = "Survivalist's Cache", desc = "", flags = 131073, quests = { 34557, 33946, 0, 0 } },
    { id = 3805, continent = 13, x = 6405.215, y = 3340.942, name = "Grimfrost Treasure", desc = "", flags = 131073, quests = { 34557, 33947, 0, 0 } },
    { id = 3806, continent = 13, x = 7198.648, y = 3427.224, name = "Goren Leftovers", desc = "", flags = 131073, quests = { 34557, 33948, 0, 0 } },
    { id = 3812, continent = 13, x = 6148.353, y = 4010.733, name = "Frozen Orc Skeleton", desc = "", flags = 131073, quests = { 34557, 34476, 0, 0 } },
    { id = 3813, continent = 13, x = 6293.714, y = 6027.578, name = "Frozen Frostwolf Axe", desc = "", flags = 131073, quests = { 34557, 34507, 0, 0 } },
    { id = 3814, continent = 13, x = 7487.992, y = 4928.118, name = "Burning Pearl", desc = "", flags = 131073, quests = { 34557, 34520, 0, 0 } },
    { id = 3816, continent = 13, x = 6426.817, y = 6905.155, name = "Sealed Jug", desc = "", flags = 131073, quests = { 34557, 34641, 0, 0 } },
    { id = 3817, continent = 13, x = 7785.124, y = 6331.755, name = "Lucky Coin", desc = "", flags = 131073, quests = { 34557, 34642, 0, 0 } },
    { id = 3818, continent = 13, x = 7748.58, y = 6040.359, name = "Snow-Covered Strongbox", desc = "", flags = 131073, quests = { 34557, 34647, 0, 0 } },
    { id = 3819, continent = 13, x = 7439.214, y = 5945.621, name = "Gnawed Bone", desc = "", flags = 131073, quests = { 34557, 34648, 0, 0 } },
    { id = 3822, continent = 13, x = 6205.389, y = 6180.609, name = "Pale Loot Sack", desc = "", flags = 131073, quests = { 34557, 34931, 0, 0 } },
    { id = 3823, continent = 13, x = 6007.518, y = 4836.484, name = "Forgotten Supplies", desc = "", flags = 131073, quests = { 34557, 34841, 0, 0 } },
    { id = 3824, continent = 13, x = 5534.604, y = 4713.354, name = "Lady Sena's Materials Stash", desc = "", flags = 131073, quests = { 34557, 34936, 0, 0 } },
    { id = 3825, continent = 13, x = 5863.688, y = 5228.03, name = "Raided Loot", desc = "", flags = 131073, quests = { 34557, 34967, 0, 0 } },
    { id = 3826, continent = 13, x = 6838.816, y = 5883.857, name = "Ogre Booty", desc = "", flags = 131073, quests = { 34557, 35347, 0, 0 } },
    { id = 3827, continent = 13, x = 6790.1, y = 5891.89, name = "Gorr'thogg's Personal Reserve", desc = "", flags = 131073, quests = { 34557, 35367, 0, 0 } },
    { id = 3828, continent = 13, x = 6869.01, y = 5771.945, name = "Ogre Booty", desc = "", flags = 131073, quests = { 34557, 35368, 0, 0 } },
    { id = 3829, continent = 13, x = 6678.749, y = 5807.52, name = "Ogre Booty", desc = "", flags = 131073, quests = { 34557, 35369, 0, 0 } },
    { id = 3830, continent = 13, x = 6665.021, y = 5879.452, name = "Doorog's Secret Stash", desc = "", flags = 131073, quests = { 34557, 35370, 0, 0 } },
    { id = 3831, continent = 13, x = 6895.448, y = 5819.13, name = "Ogre Booty", desc = "", flags = 131073, quests = { 34557, 35371, 0, 0 } },
    { id = 3832, continent = 13, x = 6740.029, y = 5784.96, name = "Ogre Booty", desc = "", flags = 131073, quests = { 34557, 35373, 0, 0 } },
    { id = 3833, continent = 13, x = 6884.815, y = 5788.954, name = "Ogre Booty", desc = "", flags = 131073, quests = { 34557, 35567, 0, 0 } },
    { id = 3834, continent = 13, x = 6673.973, y = 5666.999, name = "Ogre Booty", desc = "", flags = 131073, quests = { 34557, 35569, 0, 0 } },
    { id = 3835, continent = 13, x = 6697.491, y = 5627.534, name = "Ogre Booty", desc = "", flags = 131073, quests = { 34557, 35568, 0, 0 } },
    { id = 3836, continent = 13, x = 6694.982, y = 5838.496, name = "Ogre Booty", desc = "", flags = 131073, quests = { 34557, 35570, 0, 0 } },
    { id = 3837, continent = 13, x = 5345.302, y = 4038.32, name = "Iron Horde Munitions", desc = "", flags = 131073, quests = { 34557, 36863, 0, 0 } },
    { id = 3876, continent = 13, x = -178.9792, y = -711.6042, name = "Peaceful Offering", desc = "", flags = 131073, quests = { 36464, 33384, 0, 0 } },
    { id = 3877, continent = 13, x = 604.3246, y = -890.1059, name = "Hanging Satchel", desc = "", flags = 131073, quests = { 36464, 33564, 0, 0 } },
    { id = 3878, continent = 13, x = -1099.799, y = -2223.375, name = "Scaly Rylak Egg", desc = "", flags = 131073, quests = { 36464, 33565, 0, 0 } },
    { id = 3879, continent = 13, x = -1087.453, y = -357.4323, name = "Waterlogged Chest", desc = "", flags = 131073, quests = { 36464, 33566, 0, 0 } },
    { id = 3880, continent = 13, x = 14.10417, y = -244.684, name = "Iron Horde Tribute", desc = "", flags = 131073, quests = { 36464, 33567, 0, 0 } },
    { id = 3881, continent = 13, x = 650.0347, y = -1411.036, name = "Alchemist's Satchel", desc = "", flags = 131073, quests = { 36464, 35581, 0, 0 } },
    { id = 3882, continent = 13, x = 1562.731, y = -801.0573, name = "Shadowmoon Exile Treasure", desc = "", flags = 131073, quests = { 36464, 33570, 0, 0 } },
    { id = 3883, continent = 13, x = 634.2656, y = 259.6389, name = "Shadowmoon Sacrificial Dagger", desc = "", flags = 131073, quests = { 36464, 35919, 0, 0 } },
    { id = 3884, continent = 13, x = 1148.342, y = 734.8507, name = "Rotting Basket", desc = "", flags = 131073, quests = { 36464, 33572, 0, 0 } },
    { id = 3885, continent = 13, x = -873.7952, y = -1157.694, name = "Vindicator's Cache", desc = "", flags = 131073, quests = { 36464, 33574, 0, 0 } },
    { id = 3886, continent = 13, x = 1291.441, y = 903.6129, name = "Demonic Cache", desc = "", flags = 131073, quests = { 36464, 33575, 0, 0 } },
    { id = 3887, continent = 13, x = -41.40799, y = -760.842, name = "Peaceful Offering", desc = "", flags = 131073, quests = { 36464, 33610, 0, 0 } },
    { id = 3888, continent = 13, x = -47.28472, y = -662.6996, name = "Peaceful Offering", desc = "", flags = 131073, quests = { 36464, 33611, 0, 0 } },
    { id = 3889, continent = 13, x = 19.0434, y = -712.0226, name = "Peaceful Offering", desc = "", flags = 131073, quests = { 36464, 33612, 0, 0 } },
    { id = 3890, continent = 13, x = 981.0573, y = -1035.134, name = "Astrologer's Box", desc = "", flags = 131073, quests = { 36464, 33867, 0, 0 } },
    { id = 3891, continent = 13, x = 1410.788, y = -506.0816, name = "Armored Elekk Tusk", desc = "", flags = 131073, quests = { 36464, 33869, 0, 0 } },
    { id = 3892, continent = 13, x = 916.0035, y = 176.8802, name = "Ronokk's Belongings", desc = "", flags = 131073, quests = { 36464, 33886, 0, 0 } },
    { id = 3893, continent = 13, x = 595.368, y = -35.28472, name = "Giant Moonwillow Cone", desc = "", flags = 131073, quests = { 36464, 33891, 0, 0 } },
    { id = 3894, continent = 13, x = 660.2708, y = -3396.606, name = "Cargo of the Raven Queen", desc = "", flags = 131073, quests = { 36464, 33885, 0, 0 } },
    { id = 3895, continent = 13, x = 2338.802, y = 337.632, name = "Sunken Treasure", desc = "", flags = 131073, quests = { 36464, 35279, 0, 0 } },
    { id = 3896, continent = 13, x = 2549.666, y = 456.7083, name = "Stolen Treasure", desc = "", flags = 131073, quests = { 36464, 35280, 0, 0 } },
    { id = 3897, continent = 13, x = 1550.115, y = -1274.443, name = "Mushroom-Covered Chest", desc = "", flags = 131073, quests = { 36464, 37254, 0, 0 } },
    --{ id = 3898, continent = 13, x = 1772.161, y = 244.6788, name = "Lunarfall Egg", desc = "", flags = 0, quests = { 0, 0, 0, 0 } },
    { id = 3899, continent = 13, x = 636.467, y = -1612.104, name = "Kaliri Egg", desc = "", flags = 131073, quests = { 36464, 33568, 0, 0 } },
    { id = 3901, continent = 13, x = 891.2639, y = 27.56597, name = "Carved Drinking Horn", desc = "", flags = 131073, quests = { 36464, 33569, 0, 0 } },
    { id = 3902, continent = 13, x = 670.316, y = -189.0938, name = "Rovo's Dagger", desc = "", flags = 131073, quests = { 36464, 33573, 0, 0 } },
    { id = 3903, continent = 13, x = 834.6875, y = -133.0521, name = "Uzko's Knickknacks", desc = "", flags = 131073, quests = { 36464, 33540, 0, 0 } },
    { id = 3905, continent = 13, x = 715.9774, y = -23.30556, name = "Veema's Herb Bag", desc = "", flags = 131073, quests = { 36464, 33866, 0, 0 } },
    { id = 3906, continent = 13, x = 810.3837, y = -194.9688, name = "Beloved's Offering", desc = "", flags = 131073, quests = { 36464, 33046, 0, 0 } },
    { id = 3907, continent = 13, x = -683.7552, y = -1435.722, name = "Swamplighter Hive", desc = "", flags = 131073, quests = { 36464, 35580, 0, 0 } },
    { id = 3908, continent = 13, x = 499.6684, y = -1270.806, name = "Ancestral Greataxe", desc = "", flags = 131073, quests = { 36464, 35584, 0, 0 } },
    { id = 3909, continent = 13, x = 1768.549, y = -1471.252, name = "Strange Spore", desc = "", flags = 131073, quests = { 36464, 35600, 0, 0 } },
    { id = 3910, continent = 13, x = 1680.865, y = -1675.922, name = "Mikkal's Chest", desc = "", flags = 131073, quests = { 36464, 35603, 0, 0 } },
    { id = 3911, continent = 13, x = 907.5313, y = 377.4861, name = "Shadowmoon Treasure", desc = "", flags = 131073, quests = { 36464, 33883, 0, 0 } },
    { id = 3912, continent = 13, x = 537.2899, y = -995.592, name = "Glowing Cave Mushroom", desc = "", flags = 131073, quests = { 36464, 35798, 0, 0 } },
    { id = 3913, continent = 13, x = 1164.458, y = -2217.799, name = "Orc Skeleton", desc = "", flags = 131073, quests = { 36464, 36507, 0, 0 } },
    { id = 3986, continent = 13, x = 5232.353, y = 735.2917, name = "Strange Looking Dagger", desc = "", flags = 131073, quests = { 36465, 34940, 0, 0 } },
    { id = 3987, continent = 13, x = 7036.018, y = 1584.538, name = "Horned Skull", desc = "", flags = 131073, quests = { 36465, 35056, 0, 0 } },
    { id = 3988, continent = 13, x = 7039.32, y = 704.5018, name = "Ancient Titan Chest", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35701 } },
    { id = 3989, continent = 13, x = 5541.935, y = 1452.163, name = "Laughing Skull Cache", desc = "", flags = 131073, quests = { 36465, 35709, 0, 0 } },
    { id = 3990, continent = 13, x = 6948.707, y = 1054.359, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35952 } },
    { id = 3991, continent = 13, x = 6468.098, y = 426.6042, name = "Mysterious Petrified Pod", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35965 } },
    { id = 3992, continent = 13, x = 6238.682, y = 831.1962, name = "Remains of Grimnir Ashpick", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35966 } },
    { id = 3993, continent = 13, x = 5651.58, y = 843.8871, name = "Unknown Petrified Egg", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35967 } },
    { id = 3994, continent = 13, x = 5293.418, y = 1006.38, name = "Forgotten Ogre Cache", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35968 } },
    { id = 3995, continent = 13, x = 5826.502, y = 1222.625, name = "Forgotten Skull Cache", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35971 } },
    { id = 3996, continent = 13, x = 4489.813, y = 1308.092, name = "Remains of Explorer Engineer Toldirk Ashlamp", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35975 } },
    { id = 3997, continent = 13, x = 5920.523, y = 1718.245, name = "Obsidian Crystal Formation", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35979 } },
    { id = 3998, continent = 13, x = 5379.155, y = 1702.519, name = "Mysterious Petrified Pod", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35980 } },
    { id = 3999, continent = 13, x = 5123.101, y = 1361.264, name = "Unknown Petrified Egg", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35981 } },
    { id = 4000, continent = 13, x = 5145.028, y = 1633.694, name = "Botani Essence Seed", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35982 } },
    { id = 4001, continent = 13, x = 6659.609, y = 965.6458, name = "Ancient Titan Chest", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 35984 } },
    { id = 4002, continent = 13, x = 7218.859, y = 1558.069, name = "Unknown Petrified Egg", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36001 } },
    { id = 4003, continent = 13, x = 6604.423, y = 1604.821, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36003 } },
    { id = 4004, continent = 13, x = 5624.428, y = 119.8611, name = "Mysterious Petrified Pod", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36015 } },
    { id = 4005, continent = 13, x = 4722.083, y = 1321.438, name = "Forgotten Skull Cache", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36019 } },
    { id = 4007, continent = 13, x = 5653.285, y = 1792.845, name = "Femur of Improbability", desc = "", flags = 131073, quests = { 36465, 36170, 0, 0 } },
    { id = 4008, continent = 13, x = 7011.023, y = 1064.405, name = "Warm Goren Egg", desc = "", flags = 131073, quests = { 36465, 36203, 0, 0 } },
    { id = 4009, continent = 13, x = 6472.645, y = -107.8542, name = "Mysterious Petrified Pod", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36430 } },
    { id = 4010, continent = 13, x = 6702.746, y = 1654.592, name = "Brokor's Sack", desc = "", flags = 131073, quests = { 36465, 36506, 0, 0 } },
    { id = 4011, continent = 13, x = 7211.82, y = 1036.87, name = "Weapons Cache", desc = "", flags = 131073, quests = { 36465, 36596, 0, 0 } },
    { id = 4012, continent = 13, x = 7248.598, y = 1285.319, name = "Petrified Rylak Egg", desc = "", flags = 131073, quests = { 36465, 36521, 0, 0 } },
    { id = 4013, continent = 13, x = 4500.716, y = 1131.722, name = "Stashed Emergency Rucksack", desc = "", flags = 131073, quests = { 36465, 36604, 0, 0 } },
    { id = 4014, continent = 13, x = 6539.042, y = 337.2934, name = "Remains of Balldir Deeprock", desc = "", flags = 131073, quests = { 36465, 36605, 0, 0 } },
    { id = 4015, continent = 13, x = 6880.062, y = 1330.691, name = "Suntouched Spear", desc = "", flags = 131073, quests = { 36465, 36610, 0, 0 } },
    { id = 4016, continent = 13, x = 7274.203, y = 1493.936, name = "Iron Supply Chest", desc = "", flags = 131073, quests = { 36465, 36618, 0, 0 } },
    { id = 4017, continent = 13, x = 5414.996, y = 1766.139, name = "Explorer Canister", desc = "", flags = 131073, quests = { 36465, 36621, 0, 0 } },
    { id = 4018, continent = 13, x = 5043.693, y = 1603.094, name = "Discarded Pack", desc = "", flags = 131073, quests = { 36465, 36625, 0, 0 } },
    { id = 4019, continent = 13, x = 6112.983, y = 218.5243, name = "Vindicator's Hammer", desc = "", flags = 131073, quests = { 36465, 36628, 0, 0 } },
    { id = 4020, continent = 13, x = 5880.929, y = 1874.91, name = "Sasha's Secret Stash", desc = "", flags = 131073, quests = { 36465, 36631, 0, 0 } },
    { id = 4021, continent = 13, x = 7266.995, y = 1390.825, name = "Sniper's Crossbow", desc = "", flags = 131073, quests = { 36465, 36634, 0, 0 } },
    { id = 4022, continent = 13, x = 6865.279, y = 1296.707, name = "Harvestable Precious Crystal", desc = "", flags = 131073, quests = { 36465, 36651, 0, 0 } },
    { id = 4023, continent = 13, x = 5529.676, y = 723.4045, name = "Remains of Balik Orecrusher", desc = "", flags = 131073, quests = { 36465, 36654, 0, 0 } },
    { id = 4024, continent = 13, x = 5337.245, y = 1647.179, name = "Evermorn Supply Cache", desc = "", flags = 131073, quests = { 36465, 36658, 0, 0 } },
    { id = 4025, continent = 13, x = 6818.813, y = 1025.53, name = "Ancient Titan Chest", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36710 } },
    { id = 4026, continent = 13, x = 5280.54, y = 732.9774, name = "Unknown Petrified Egg", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36713 } },
    { id = 4027, continent = 13, x = 5404.312, y = 1171.137, name = "Mysterious Petrified Pod", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36714 } },
    { id = 4028, continent = 13, x = 5824.107, y = 835.0261, name = "Mysterious Petrified Pod", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36715 } },
    { id = 4029, continent = 13, x = 6523.04, y = 1850.745, name = "Forgotten Skull Cache", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36716 } },
    { id = 4030, continent = 13, x = 7211.749, y = 1181.906, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36717 } },
    { id = 4031, continent = 13, x = 6766.718, y = 1203.714, name = "Unknown Petrified Egg", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36718 } },
    { id = 4032, continent = 13, x = 7078.941, y = 1625.811, name = "Ancient Titan Chest", desc = "", flags = 524310, quests = { 36249, 36250, 36465, 36720 } },
    { id = 4033, continent = 13, x = 7062.096, y = 1132.563, name = "Obsidian Crystal Formation", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36721 } },
    { id = 4034, continent = 13, x = 6902.425, y = 1335.677, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36722 } },
    { id = 4035, continent = 13, x = 7096.861, y = 1532.474, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36723 } },
    { id = 4036, continent = 13, x = 7122.329, y = 1652.021, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36726 } },
    { id = 4037, continent = 13, x = 6753.998, y = 1616.521, name = "Ancient Titan Chest", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36727 } },
    { id = 4038, continent = 13, x = 6380.192, y = 1644.688, name = "Obsidian Crystal Formation", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36728 } },
    { id = 4039, continent = 13, x = 6085.777, y = 1627.929, name = "Obsidian Crystal Formation", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36729 } },
    { id = 4040, continent = 13, x = 6583.323, y = 1132.33, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36730 } },
    { id = 4041, continent = 13, x = 6772.521, y = 1520.958, name = "Ancient Titan Chest", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36731 } },
    { id = 4042, continent = 13, x = 7047.219, y = 1454.274, name = "Obsidian Crystal Formation", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36732 } },
    { id = 4043, continent = 13, x = 7247.283, y = 1342.941, name = "Ancient Ogre Cache", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36733 } },
    { id = 4044, continent = 13, x = 7379.397, y = 869.1511, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36734 } },
    { id = 4045, continent = 13, x = 7410.851, y = 1147.809, name = "Ancient Titan Chest", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36735 } },
    { id = 4046, continent = 13, x = 6153.528, y = 1300.88, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36736 } },
    { id = 4047, continent = 13, x = 5778.484, y = 1381.252, name = "Ancient Ogre Cache", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36737 } },
    { id = 4048, continent = 13, x = 5961.171, y = 951.7587, name = "Ancient Titan Chest", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36738 } },
    { id = 4049, continent = 13, x = 6784.957, y = 314.4375, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36739 } },
    { id = 4050, continent = 13, x = 6398.533, y = 33.38542, name = "Ancient Ogre Cache", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36740 } },
    { id = 4051, continent = 13, x = 5624.845, y = 196.4254, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36781 } },
    { id = 4052, continent = 13, x = 5604.082, y = 630.5417, name = "Ancient Ogre Cache", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36782 } },
    { id = 4053, continent = 13, x = 5094.429, y = 1049.877, name = "Ancient Titan Chest", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36783 } },
    { id = 4054, continent = 13, x = 4781.897, y = 1326.46, name = "Aged Stone Container", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36784 } },
    { id = 4055, continent = 13, x = 4516.721, y = 1618.568, name = "Ancient Ogre Cache", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36787 } },
    { id = 4056, continent = 13, x = 4874.052, y = 1671.889, name = "Ancient Ogre Cache", desc = "", flags = 524310, quests = { 36251, 36252, 36465, 36789 } },
    { id = 4057, continent = 13, x = 5940.388, y = 772.6875, name = "Odd Skull", desc = "", flags = 131073, quests = { 36465, 36509, 0, 0 } },
    { id = 4086, continent = 13, x = 3977.395, y = 1929.977, name = "Jug of Aged Ironwine", desc = "", flags = 131073, quests = { 36466, 34233, 0, 0 } },
    { id = 4087, continent = 13, x = 3254.937, y = 2699.602, name = "Luminous Shell", desc = "", flags = 131073, quests = { 36466, 34235, 0, 0 } },
    { id = 4088, continent = 13, x = 3141.912, y = 2131.863, name = "Amethyl Crystal", desc = "", flags = 131073, quests = { 36466, 34236, 0, 0 } },
    { id = 4089, continent = 13, x = 3290.069, y = 2413.174, name = "Foreman's Lunchbox", desc = "", flags = 131073, quests = { 36466, 34238, 0, 0 } },
    { id = 4090, continent = 13, x = 973.2448, y = 1868.349, name = "Curious Deathweb Egg", desc = "", flags = 131073, quests = { 36466, 34239, 0, 0 } },
    { id = 4091, continent = 13, x = 2443.32, y = 1239.833, name = "Charred Sword", desc = "", flags = 131073, quests = { 36466, 34248, 0, 0 } },
    { id = 4092, continent = 13, x = 590.9983, y = 3722.271, name = "Farmer's Bounty", desc = "", flags = 131073, quests = { 36466, 34249, 0, 0 } },
    { id = 4093, continent = 13, x = 2651.515, y = 1315.174, name = "Relic of Aruuna", desc = "", flags = 131073, quests = { 36466, 34250, 0, 0 } },
    { id = 4094, continent = 13, x = 1280.913, y = 1982.535, name = "Iron Box", desc = "", flags = 131073, quests = { 36466, 34251, 0, 0 } },
    { id = 4095, continent = 13, x = 2522.234, y = 2112.002, name = "Barrel of Fish", desc = "", flags = 131073, quests = { 36466, 34252, 0, 0 } },
    { id = 4096, continent = 13, x = 1777.247, y = 2539.335, name = "Draenei Weapons", desc = "", flags = 131073, quests = { 36466, 34253, 0, 0 } },
    { id = 4097, continent = 13, x = 2239.031, y = 3479.884, name = "Soulbinder's Reliquary", desc = "", flags = 131073, quests = { 36466, 34254, 0, 0 } },
    { id = 4098, continent = 13, x = 907.5, y = 1931.443, name = "Webbed Sac", desc = "", flags = 131073, quests = { 36466, 34255, 0, 0 } },
    { id = 4099, continent = 13, x = 782.4965, y = 3033.621, name = "Relic of Telmor", desc = "", flags = 131073, quests = { 36466, 34256, 0, 0 } },
    { id = 4100, continent = 13, x = 1070.229, y = 3548.034, name = "Treasure of Ango'rosh", desc = "", flags = 131073, quests = { 36466, 34257, 0, 0 } },
    { id = 4101, continent = 13, x = 3935.661, y = 3556.531, name = "Light of the Sea", desc = "", flags = 131073, quests = { 36466, 34258, 0, 0 } },
    { id = 4102, continent = 13, x = 1376.488, y = 3848.273, name = "Bonechewer Remnants", desc = "", flags = 131073, quests = { 36466, 34259, 0, 0 } },
    { id = 4103, continent = 13, x = 3040.252, y = 953.3854, name = "Aruuna Mining Cart", desc = "", flags = 131073, quests = { 36466, 34260, 0, 0 } },
    { id = 4104, continent = 13, x = 2783.681, y = 1320.766, name = "Keluu's Belongings", desc = "", flags = 131073, quests = { 36466, 34261, 0, 0 } },
    { id = 4105, continent = 13, x = 3844.26, y = 1169.962, name = "Pure Crystal Dust", desc = "", flags = 131073, quests = { 36466, 34263, 0, 0 } },
    { id = 4106, continent = 13, x = 1045.122, y = 1900.377, name = "Rusted Lockbox", desc = "", flags = 131073, quests = { 36466, 34276, 0, 0 } },
    { id = 4107, continent = 13, x = 3328.651, y = 2615.092, name = "Ketya's Stash", desc = "", flags = 131073, quests = { 36466, 34290, 0, 0 } },
    { id = 4108, continent = 13, x = 2387.293, y = 1449.896, name = "Bright Coin", desc = "", flags = 131073, quests = { 36466, 34471, 0, 0 } },
    { id = 4109, continent = 13, x = 1480.271, y = 4140.854, name = "Gift of the Ancients", desc = "", flags = 131073, quests = { 36466, 36829, 0, 0 } },
    { id = 4163, continent = 13, x = -659.1285, y = 2416.286, name = "Rooby's Roo", desc = "", flags = 131073, quests = { 36467, 36657, 0, 0 } },
    { id = 4164, continent = 13, x = 690.1285, y = 2450.045, name = "Outcast's Belongings", desc = "", flags = 131073, quests = { 36467, 36243, 0, 0 } },
    { id = 4165, continent = 13, x = 643.3854, y = 2093.873, name = "Misplaced Scrolls", desc = "", flags = 131073, quests = { 36467, 36244, 0, 0 } },
    { id = 4166, continent = 13, x = 722.132, y = 2077.46, name = "Relics of the Outcasts", desc = "", flags = 131073, quests = { 36467, 36245, 0, 0 } },
    { id = 4167, continent = 13, x = 490.5642, y = 1620.51, name = "Fractured Sunstone", desc = "", flags = 131073, quests = { 36467, 36246, 0, 0 } },
    { id = 4168, continent = 13, x = 222.2882, y = 1603.944, name = "Lost Herb Satchel", desc = "", flags = 131073, quests = { 36467, 36247, 0, 0 } },
    { id = 4169, continent = 13, x = -1049.988, y = 1123.845, name = "Ogron Plunder", desc = "", flags = 131073, quests = { 36467, 36340, 0, 0 } },
    { id = 4170, continent = 13, x = -400.3073, y = 1896.108, name = "Relics of the Outcasts", desc = "", flags = 131073, quests = { 36467, 36354, 0, 0 } },
    { id = 4171, continent = 13, x = 282.2222, y = 2065.719, name = "Relics of the Outcasts", desc = "", flags = 131073, quests = { 36467, 36355, 0, 0 } },
    { id = 4172, continent = 13, x = -225.7014, y = 598.1493, name = "Relics of the Outcasts", desc = "", flags = 131073, quests = { 36467, 36356, 0, 0 } },
    { id = 4173, continent = 13, x = -794.2743, y = 1032.257, name = "Relics of the Outcasts", desc = "", flags = 131073, quests = { 36467, 36359, 0, 0 } },
    { id = 4174, continent = 13, x = -592.9549, y = 1536.625, name = "Relics of the Outcasts", desc = "", flags = 131073, quests = { 36467, 36360, 0, 0 } },
    { id = 4175, continent = 13, x = 145.033, y = 1776.891, name = "Shattered Hand Lockbox", desc = "", flags = 131073, quests = { 36467, 36361, 0, 0 } },
    { id = 4176, continent = 13, x = 219.6337, y = 1273.351, name = "Shattered Hand Cache", desc = "", flags = 131073, quests = { 36467, 36362, 0, 0 } },
    --{ id = 4177, continent = 13, x = -93.71702, y = 1146.608, name = "Shattered Hand Spoils", desc = "", flags = 0, quests = { 0, 0, 0, 0 } },
    { id = 4178, continent = 13, x = 68.58681, y = 1387.109, name = "Toxicfang Venom", desc = "", flags = 131073, quests = { 36467, 36364, 0, 0 } },
    { id = 4179, continent = 13, x = -1902.62, y = 1067.543, name = "Spray-O-Matic 5000 XT", desc = "", flags = 131073, quests = { 36467, 36365, 0, 0 } },
    { id = 4180, continent = 13, x = -2278.181, y = 1095.26, name = "Sailor Zazzuk's 180-Proof Rum", desc = "", flags = 131073, quests = { 36467, 36366, 0, 0 } },
    { id = 4181, continent = 13, x = -2286.859, y = 1315.913, name = "Campaign Contributions", desc = "", flags = 131073, quests = { 36467, 36367, 0, 0 } },
    { id = 4183, continent = 13, x = 775.5469, y = 2020.028, name = "Elixir of Shadow Sight", desc = "", flags = 131073, quests = { 36467, 36395, 0, 0 } },
    { id = 4184, continent = 13, x = 388.908, y = 2024.769, name = "Elixir of Shadow Sight", desc = "", flags = 131073, quests = { 36467, 36397, 0, 0 } },
    { id = 4185, continent = 13, x = -367.4115, y = 490.5, name = "Elixir of Shadow Sight", desc = "", flags = 131073, quests = { 36467, 36398, 0, 0 } },
    { id = 4186, continent = 13, x = -1143.807, y = 1713.441, name = "Elixir of Shadow Sight", desc = "", flags = 131073, quests = { 36467, 36399, 0, 0 } },
    { id = 4187, continent = 13, x = 490.8021, y = 1308.524, name = "Elixir of Shadow Sight", desc = "", flags = 131073, quests = { 36467, 36400, 0, 0 } },
    { id = 4188, continent = 13, x = -2029.918, y = 1460.201, name = "Elixir of Shadow Sight", desc = "", flags = 131073, quests = { 36467, 36401, 0, 0 } },
    { id = 4189, continent = 13, x = -205.776, y = 2482.236, name = "Orcish Signaling Horn", desc = "", flags = 131073, quests = { 36467, 36402, 0, 0 } },
    { id = 4190, continent = 13, x = -859.2899, y = 1450.427, name = "Offering to the Raven Mother", desc = "", flags = 131073, quests = { 36467, 36403, 0, 0 } },
    { id = 4191, continent = 13, x = -741.8629, y = 1750.896, name = "Offering to the Raven Mother", desc = "", flags = 131073, quests = { 36467, 36405, 0, 0 } },
    { id = 4192, continent = 13, x = -826.4167, y = 1717.491, name = "Offering to the Raven Mother", desc = "", flags = 131073, quests = { 36467, 36406, 0, 0 } },
    { id = 4193, continent = 13, x = -1228.339, y = 1537.01, name = "Offering to the Raven Mother", desc = "", flags = 131073, quests = { 36467, 36407, 0, 0 } },
    { id = 4194, continent = 13, x = -1196.818, y = 986.0139, name = "Offering to the Raven Mother", desc = "", flags = 131073, quests = { 36467, 36410, 0, 0 } },
    { id = 4195, continent = 13, x = -75.62327, y = 1786.2, name = "Lost Ring", desc = "", flags = 131073, quests = { 36467, 36411, 0, 0 } },
    --{ id = 4196, continent = 13, x = -42.01215, y = 2429.142, name = "Reagent Pouch", desc = "", flags = 131073, quests = { 36467, 36415, 0, 0 } },
    { id = 4197, continent = 13, x = -345.5295, y = 1501.51, name = "Misplaced Scroll", desc = "", flags = 131073, quests = { 36467, 36416, 0, 0 } },
    { id = 4198, continent = 13, x = -955.9063, y = 2464.325, name = "Ephial's Dark Grimoire", desc = "", flags = 131073, quests = { 36467, 36418, 0, 0 } },
    { id = 4199, continent = 13, x = -535.4827, y = 2429.778, name = "Garrison Supplies", desc = "", flags = 131073, quests = { 36467, 36420, 0, 0 } },
    { id = 4200, continent = 13, x = 271.8576, y = 2612.075, name = "Sun-Touched Cache", desc = "", flags = 131073, quests = { 36467, 36421, 0, 0 } },
    { id = 4201, continent = 13, x = 281.7031, y = 2663.765, name = "Sun-Touched Cache", desc = "", flags = 131073, quests = { 36467, 36422, 0, 0 } },
    { id = 4202, continent = 13, x = -446.8733, y = 1269.623, name = "Smuggled Apexis Artifacts", desc = "", flags = 131073, quests = { 36467, 36433, 0, 0 } },
    { id = 4203, continent = 13, x = 341.5885, y = 1631.247, name = "Iron Horde Explosives", desc = "", flags = 131073, quests = { 36467, 36444, 0, 0 } },
    { id = 4204, continent = 13, x = -119.6059, y = 1699.254, name = "Assassin's Spear", desc = "", flags = 131073, quests = { 36467, 36445, 0, 0 } },
    { id = 4205, continent = 13, x = 7.605903, y = 1838.613, name = "Outcast's Pouch", desc = "", flags = 131073, quests = { 36467, 36446, 0, 0 } },
    { id = 4206, continent = 13, x = 507.533, y = 2125.688, name = "Outcast's Belongings", desc = "", flags = 131073, quests = { 36467, 36447, 0, 0 } },
    { id = 4207, continent = 13, x = -579.5886, y = 339.8472, name = "Sethekk Ritual Brew", desc = "", flags = 131073, quests = { 36467, 36450, 0, 0 } },
    { id = 4208, continent = 13, x = -653.5573, y = 2144.672, name = "Garrison Workman's Hammer", desc = "", flags = 131073, quests = { 36467, 36451, 0, 0 } },
    { id = 4209, continent = 13, x = -2211.233, y = 534.4705, name = "Coinbender's Payment", desc = "", flags = 131073, quests = { 36467, 36453, 0, 0 } },
    { id = 4210, continent = 13, x = -1338.191, y = 828.3143, name = "Mysterious Mushrooms", desc = "", flags = 131073, quests = { 36467, 36454, 0, 0 } },
    { id = 4211, continent = 13, x = -900.2205, y = 652.6493, name = "Waterlogged Satchel", desc = "", flags = 131073, quests = { 36467, 36455, 0, 0 } },
    { id = 4212, continent = 13, x = -2034.417, y = 992.7986, name = "Shredder Parts", desc = "", flags = 131073, quests = { 36467, 36456, 0, 0 } },
    { id = 4213, continent = 13, x = -837.243, y = 2221.233, name = "Abandoned Mining Pick", desc = "", flags = 131073, quests = { 36467, 36458, 0, 0 } },
    { id = 4215, continent = 13, x = -816.6945, y = 2488.134, name = "Admiral Taylor's Coffer", desc = "", flags = 131073, quests = { 36467, 36462, 0, 0 } },
    { id = 4278, continent = 13, x = 2249.955, y = 7168.293, name = "Treasure of Kull'krosh", desc = "", flags = 131073, quests = { 36468, 34760, 0, 0 } },
    { id = 4279, continent = 13, x = 2938.825, y = 5338.54, name = "Adventurer's Pack", desc = "", flags = 131073, quests = { 36468, 35597, 0, 0 } },
    { id = 4280, continent = 13, x = 2113.915, y = 6629.726, name = "Goblin Pack", desc = "", flags = 131073, quests = { 36468, 35576, 0, 0 } },
    { id = 4281, continent = 13, x = 1809.851, y = 6463.887, name = "Steamwheedle Supplies", desc = "", flags = 131073, quests = { 36468, 35577, 0, 0 } },
    { id = 4282, continent = 13, x = 2406.651, y = 6472.311, name = "Void-Infused Crystal", desc = "", flags = 131073, quests = { 36468, 35579, 0, 0 } },
    { id = 4283, continent = 13, x = 1893.13, y = 6319.139, name = "Steamwheedle Supplies", desc = "", flags = 131073, quests = { 36468, 35583, 0, 0 } },
    { id = 4284, continent = 13, x = 2572.533, y = 5167.321, name = "Goblin Pack", desc = "", flags = 131073, quests = { 36468, 35590, 0, 0 } },
    { id = 4285, continent = 13, x = 2957.642, y = 4891.429, name = "Steamwheedle Supplies", desc = "", flags = 131073, quests = { 36468, 35591, 0, 0 } },
    { id = 4286, continent = 13, x = 2632.434, y = 4731.55, name = "Warsong Spoils", desc = "", flags = 131073, quests = { 36468, 35593, 0, 0 } },
    { id = 4287, continent = 13, x = 3310.394, y = 4299.127, name = "Steamwheedle Supplies", desc = "", flags = 131073, quests = { 36468, 35616, 0, 0 } },
    { id = 4288, continent = 13, x = 3221.08, y = 4335.749, name = "Hidden Stash", desc = "", flags = 131073, quests = { 36468, 35622, 0, 0 } },
    { id = 4289, continent = 13, x = 4398.923, y = 5305.63, name = "Mountain Climber's Pack", desc = "", flags = 131073, quests = { 36468, 35643, 0, 0 } },
    { id = 4290, continent = 13, x = 4219.137, y = 5301.935, name = "Steamwheedle Supplies", desc = "", flags = 131073, quests = { 36468, 35646, 0, 0 } },
    { id = 4291, continent = 13, x = 4256.379, y = 5642.717, name = "Steamwheedle Supplies", desc = "", flags = 131073, quests = { 36468, 35648, 0, 0 } },
    { id = 4292, continent = 13, x = 4232.899, y = 4263.482, name = "Fungus-Covered Chest", desc = "", flags = 131073, quests = { 36468, 35660, 0, 0 } },
    { id = 4293, continent = 13, x = 3513.492, y = 4707.116, name = "Brilliant Dreampetal", desc = "", flags = 131073, quests = { 36468, 35661, 0, 0 } },
    { id = 4294, continent = 13, x = 4155.813, y = 4337.042, name = "Steamwheedle Supplies", desc = "", flags = 131073, quests = { 36468, 35662, 0, 0 } },
    { id = 4295, continent = 13, x = 2064.877, y = 5162.518, name = "Appropriated Warsong Supplies", desc = "", flags = 131073, quests = { 36468, 35673, 0, 0 } },
    { id = 4296, continent = 13, x = 2261.113, y = 5163.319, name = "Warsong Lockbox", desc = "", flags = 131073, quests = { 36468, 35678, 0, 0 } },
    { id = 4297, continent = 13, x = 2278.266, y = 4992.127, name = "Warsong Spear", desc = "", flags = 131073, quests = { 36468, 35682, 0, 0 } },
    { id = 4298, continent = 13, x = 4108.274, y = 5162.79, name = "Freshwater Clam", desc = "", flags = 131073, quests = { 36468, 35692, 0, 0 } },
    { id = 4299, continent = 13, x = 2937.118, y = 6001.19, name = "Golden Kaliri Egg", desc = "", flags = 131073, quests = { 36468, 35694, 0, 0 } },
    { id = 4300, continent = 13, x = 2642.108, y = 6373.464, name = "Warsong Cache", desc = "", flags = 131073, quests = { 36468, 35695, 0, 0 } },
    { id = 4301, continent = 13, x = 2899.928, y = 4461.472, name = "Burning Blade Cache", desc = "", flags = 131073, quests = { 36468, 35696, 0, 0 } },
    { id = 4302, continent = 13, x = 2663.834, y = 5469.439, name = "Abandoned Cargo", desc = "", flags = 131073, quests = { 36468, 35759, 0, 0 } },
    { id = 4303, continent = 13, x = 2781.601, y = 4639.753, name = "Adventurer's Pack", desc = "", flags = 131073, quests = { 36468, 35765, 0, 0 } },
    { id = 4304, continent = 13, x = 4514.324, y = 5161.796, name = "A Pile of Dirt", desc = "", flags = 131073, quests = { 36468, 35951, 0, 0 } },
    { id = 4305, continent = 13, x = 4428.327, y = 4685.477, name = "Adventurer's Staff", desc = "", flags = 131073, quests = { 36468, 35953, 0, 0 } },
    { id = 4306, continent = 13, x = 4185.468, y = 5508.517, name = "Elemental Offering", desc = "", flags = 131073, quests = { 36468, 35954, 0, 0 } },
    { id = 4307, continent = 13, x = 4391.368, y = 5112.813, name = "Adventurer's Sack", desc = "", flags = 131073, quests = { 36468, 35955, 0, 0 } },
    { id = 4308, continent = 13, x = 2955.452, y = 6718.929, name = "Adventurer's Pack", desc = "", flags = 131073, quests = { 36468, 35969, 0, 0 } },
    { id = 4309, continent = 13, x = 2430.627, y = 4234.758, name = "Warsong Supplies", desc = "", flags = 131073, quests = { 36468, 35976, 0, 0 } },
    { id = 4310, continent = 13, x = 3861, y = 4921.224, name = "Bone-Carved Dagger", desc = "", flags = 131073, quests = { 36468, 35986, 0, 0 } },
    { id = 4311, continent = 13, x = 2745.786, y = 6855.361, name = "Genedar Debris", desc = "", flags = 131073, quests = { 36468, 35987, 0, 0 } },
    { id = 4312, continent = 13, x = 2648.761, y = 6580.662, name = "Genedar Debris", desc = "", flags = 131073, quests = { 36468, 35999, 0, 0 } },
    { id = 4313, continent = 13, x = 2366.674, y = 6772.226, name = "Genedar Debris", desc = "", flags = 131073, quests = { 36468, 36002, 0, 0 } },
    { id = 4314, continent = 13, x = 2169.201, y = 6551.215, name = "Genedar Debris", desc = "", flags = 131073, quests = { 36468, 36008, 0, 0 } },
    { id = 4315, continent = 13, x = 2339.733, y = 6167.44, name = "Genedar Debris", desc = "", flags = 131073, quests = { 36468, 36011, 0, 0 } },
    { id = 4316, continent = 13, x = 2414.811, y = 6706.011, name = "Fragment of Oshu'gun", desc = "", flags = 131073, quests = { 36468, 36020, 0, 0 } },
    { id = 4317, continent = 13, x = 2678.853, y = 6000.099, name = "Pokkar's Thirteenth Axe", desc = "", flags = 131073, quests = { 36468, 36021, 0, 0 } },
    { id = 4318, continent = 13, x = 2618.104, y = 5182.128, name = "Polished Saberon Skull", desc = "", flags = 131073, quests = { 36468, 36035, 0, 0 } },
    { id = 4319, continent = 13, x = 4334.327, y = 4830.916, name = "Elemental Shackles", desc = "", flags = 131073, quests = { 36468, 36036, 0, 0 } },
    { id = 4320, continent = 13, x = 3066.684, y = 5484.286, name = "Highmaul Sledge", desc = "", flags = 131073, quests = { 36468, 36039, 0, 0 } },
    { id = 4321, continent = 13, x = 2432.226, y = 5635.986, name = "Telaar Defender Shield", desc = "", flags = 131073, quests = { 36468, 36046, 0, 0 } },
    { id = 4322, continent = 13, x = 1904.056, y = 4713.988, name = "Ogre Beads", desc = "", flags = 131073, quests = { 36468, 36049, 0, 0 } },
    { id = 4323, continent = 13, x = 2163.285, y = 6098.297, name = "Adventurer's Pouch", desc = "", flags = 131073, quests = { 36468, 36050, 0, 0 } },
    { id = 4324, continent = 13, x = 2165.747, y = 4365.18, name = "Grizzlemaw's Bonepile", desc = "", flags = 131073, quests = { 36468, 36051, 0, 0 } },
    { id = 4326, continent = 13, x = 3571.056, y = 5632.976, name = "Watertight Bag", desc = "", flags = 131073, quests = { 36468, 36071, 0, 0 } },
    { id = 4327, continent = 13, x = 3243.724, y = 6333.919, name = "Warsong Helm", desc = "", flags = 131073, quests = { 36468, 36073, 0, 0 } },
    { id = 4328, continent = 13, x = 3140.645, y = 5031.07, name = "Gambler's Purse", desc = "", flags = 131073, quests = { 36468, 36074, 0, 0 } },
    { id = 4329, continent = 13, x = 2576.186, y = 5005.851, name = "Adventurer's Mace", desc = "", flags = 131073, quests = { 36468, 36077, 0, 0 } },
    { id = 4330, continent = 13, x = 2748.736, y = 5803.464, name = "Lost Pendant", desc = "", flags = 131073, quests = { 36468, 36082, 0, 0 } },
    { id = 4331, continent = 13, x = 2492.012, y = 6279.075, name = "Adventurer's Pouch", desc = "", flags = 131073, quests = { 36468, 36088, 0, 0 } },
    { id = 4332, continent = 13, x = 2440.05, y = 5039.187, name = "Important Exploration Supplies", desc = "", flags = 131073, quests = { 36468, 36099, 0, 0 } },
    { id = 4333, continent = 13, x = 2465.943, y = 5042.031, name = "Saberon Stash", desc = "", flags = 131073, quests = { 36468, 36102, 0, 0 } },
    { id = 4334, continent = 13, x = 2701.168, y = 7132.761, name = "Goldtoe's Plunder", desc = "", flags = 131073, quests = { 36468, 36109, 0, 0 } },
    { id = 4335, continent = 13, x = 2575.405, y = 6028.518, name = "Pale Elixir", desc = "", flags = 131073, quests = { 36468, 36115, 0, 0 } },
    { id = 4336, continent = 13, x = 2385.167, y = 5759.047, name = "Bag of Herbs", desc = "", flags = 131073, quests = { 36468, 36116, 0, 0 } },
    { id = 4337, continent = 13, x = 4294.313, y = 4934.307, name = "Bounty of the Elements", desc = "", flags = 131073, quests = { 36468, 36174, 0, 0 } },
    { id = 4338, continent = 13, x = 2757.136, y = 7295.27, name = "Spirit's Gift", desc = "", flags = 131073, quests = { 36468, 36846, 0, 0 } },
    { id = 4339, continent = 13, x = 3669.489, y = 4253.515, name = "Smuggler's Cache", desc = "", flags = 131073, quests = { 36468, 36857, 0, 0 } },
    { id = 4345, continent = 13, x = 1627.335, y = -222.0017, name = "Bubbling Cauldron", desc = "", flags = 131073, quests = { 36464, 33613, 0, 0 } },
    { id = 4346, continent = 13, x = 2406.634, y = 491.4531, name = "Fantastic Fish", desc = "", flags = 131073, quests = { 36464, 34174, 0, 0 } },
    --{ id = 4417, continent = 13, x = 2087.788, y = 199.3316, name = "Spark's Stolen Supplies", desc = "", flags = 0, quests = { 0, 0, 0, 0 } },
    --{ id = 4418, continent = 13, x = 1843.5, y = 256.1024, name = "Pippers' Buried Supplies", desc = "", flags = 0, quests = { 0, 0, 0, 0 } },
    --{ id = 4419, continent = 13, x = 1870.811, y = 199.9045, name = "Pippers' Buried Supplies", desc = "", flags = 0, quests = { 0, 0, 0, 0 } },
    --{ id = 4420, continent = 13, x = 1965.497, y = 333.3542, name = "Pippers' Buried Supplies", desc = "", flags = 0, quests = { 0, 0, 0, 0 } },
    --{ id = 4421, continent = 13, x = 1740.95, y = 210.0972, name = "Pippers' Buried Supplies", desc = "", flags = 0, quests = { 0, 0, 0, 0 } },
    { id = 4424, continent = 13, x = 5549.832, y = 4364.098, name = "Lady Sena's Other Materials Stash", desc = "", flags = 131073, quests = { 34557, 34937, 0, 0 } },
    { id = 4425, continent = 13, x = 5670.688, y = 4537.518, name = "Unused Wood Pile", desc = "", flags = 131073, quests = { 34557, 36053, 0, 0 } },
    { id = 4563, continent = 13, x = 6031, y = 398.882, name = "Strange Spore", desc = "", flags = 131073, quests = { 36465, 37249, 0, 0 } },
    { id = 4564, continent = 13, x = 4150.79, y = 1653.69, name = "Burning Blade Cache", desc = "", flags = 131073, quests = { 36466, 36937, 0, 0 } },
    { id = 4566, continent = 13, x = 1498.639, y = -223.2205, name = "Sunken Fishing Boat", desc = "", flags = 131073, quests = { 36464, 35677, 0, 0 } },
    { id = 4567, continent = 13, x = 2326.16, y = 7018.98, name = "Spirit Coffer", desc = "", flags = 131073, quests = { 36468, 37435, 0, 0 } },
    { id = 4568, continent = 13, x = 1075.13, y = -1198.34, name = "False-Bottomed Jar", desc = "", flags = 131073, quests = { 36464, 33037, 0, 0 } },
    { id = 4569, continent = 13, x = -189.405, y = 539.862, name = "Sethekk Idol", desc = "", flags = 131073, quests = { 36467, 36375, 0, 0 } },
    { id = 4571, continent = 13, x = 896.797, y = 1994.45, name = "Rukhmar's Image", desc = "", flags = 131073, quests = { 36467, 36377, 0, 0 } },
    { id = 4572, continent = 13, x = -853.58, y = 978.34, name = "Gift of Anzu", desc = "", flags = 131073, quests = { 36467, 36381, 0, 0 } },
    { id = 4574, continent = 13, x = -250.215, y = 1836.16, name = "Gift of Anzu", desc = "", flags = 131073, quests = { 36467, 36389, 0, 0 } },
    { id = 4576, continent = 13, x = 592.319, y = 1527.95, name = "Gift of Anzu", desc = "", flags = 131073, quests = { 36467, 36392, 0, 0 } },
    { id = 4583, continent = 13, x = 483.049, y = 1169.05, name = "Statue of Anzu", desc = "", flags = 131073, quests = { 36467, 36374, 0, 0 } },
    { id = 4854, continent = 13, x = 4411.662, y = -198.3559, name = "Strange Sapphire", desc = "", flags = 131073, quests = { 39463, 37956, 0, 0 } },
    { id = 4855, continent = 13, x = 4191.485, y = 872.3229, name = "Weathered Axe", desc = "", flags = 131073, quests = { 39463, 38208, 0, 0 } },
    { id = 4856, continent = 13, x = 4080.802, y = 815.1684, name = "Stolen Captain's Chest", desc = "", flags = 131073, quests = { 39463, 38283, 0, 0 } },
    { id = 4857, continent = 13, x = 4500.199, y = 695.4045, name = "The Blade of Kra'nak", desc = "", flags = 131073, quests = { 39463, 38320, 0, 0 } },
    { id = 4858, continent = 13, x = 5116.36, y = 199.7951, name = "Jewel of Hellfire", desc = "", flags = 131073, quests = { 39463, 38334, 0, 0 } },
    { id = 4859, continent = 13, x = 3469.583, y = 5.977431, name = "Tome of Secrets", desc = "", flags = 131073, quests = { 39463, 38426, 0, 0 } },
    { id = 4860, continent = 13, x = 3656.682, y = -1282.207, name = "Forgotten Sack", desc = "", flags = 131073, quests = { 39463, 38591, 0, 0 } },
    { id = 4861, continent = 13, x = 3507.308, y = -1165.425, name = "Lodged Hunting Spear", desc = "", flags = 131073, quests = { 39463, 38593, 0, 0 } },
    { id = 4862, continent = 13, x = 3280.182, y = -1504.892, name = "Blackfang Island Cache", desc = "", flags = 131073, quests = { 39463, 38601, 0, 0 } },
    { id = 4863, continent = 13, x = 3458.348, y = -1552.172, name = "Crystallized Fel Spike", desc = "", flags = 131073, quests = { 39463, 38602, 0, 0 } },
    { id = 4864, continent = 13, x = 3414.467, y = 112.8142, name = "Polished Crystal", desc = "", flags = 131073, quests = { 39463, 38629, 0, 0 } },
    { id = 4865, continent = 13, x = 3140.44, y = -423.2153, name = "Snake Charmer's Flute", desc = "", flags = 131073, quests = { 39463, 38638, 0, 0 } },
    { id = 4866, continent = 13, x = 3289.344, y = -432.7621, name = "The Perfect Blossom", desc = "", flags = 131073, quests = { 39463, 38639, 0, 0 } },
    { id = 4867, continent = 13, x = 4313.882, y = -236.7899, name = "Pale Removal Equipment", desc = "", flags = 131073, quests = { 39463, 38640, 0, 0 } },
    { id = 4868, continent = 13, x = 3367.066, y = -473.7917, name = "Forgotten Champion's Blade", desc = "", flags = 131073, quests = { 39463, 38657, 0, 0 } },
    { id = 4869, continent = 13, x = 4261.537, y = 553.309, name = "Bleeding Hollow Warchest", desc = "", flags = 131073, quests = { 39463, 38678, 0, 0 } },
    { id = 4870, continent = 13, x = 5050.86, y = -1364.665, name = "Jewel of the Fallen Star", desc = "", flags = 131073, quests = { 39463, 38679, 0, 0 } },
    { id = 4871, continent = 13, x = 5214.644, y = -1578.026, name = "Censer of Torment", desc = "", flags = 131073, quests = { 39463, 38682, 0, 0 } },
    { id = 4872, continent = 13, x = 4388.667, y = 302.8368, name = "Looted Bleeding Hollow Treasure", desc = "", flags = 131073, quests = { 39463, 38683, 0, 0 } },
    { id = 4873, continent = 13, x = 5082.651, y = -1007.715, name = "Rune Etched Femur", desc = "", flags = 131073, quests = { 39463, 38686, 0, 0 } },
    { id = 4874, continent = 13, x = 4459.429, y = -1683.458, name = "Strange Fruit", desc = "", flags = 131073, quests = { 39463, 38701, 0, 0 } },
    { id = 4875, continent = 13, x = 3090.201, y = -911.4601, name = "Discarded Helm", desc = "", flags = 131073, quests = { 39463, 38702, 0, 0 } },
    { id = 4876, continent = 13, x = 3146.502, y = -913.7864, name = "Scout's Belongings", desc = "", flags = 131073, quests = { 39463, 38703, 0, 0 } },
    { id = 4877, continent = 13, x = 3973.533, y = -1953.269, name = "Forgotten Iron Horde Supplies", desc = "", flags = 131073, quests = { 39463, 38704, 0, 0 } },
    { id = 4878, continent = 13, x = 3469.229, y = -807.1614, name = "Crystalized Essence of the Elements", desc = "", flags = 131073, quests = { 39463, 38705, 0, 0 } },
    { id = 4879, continent = 13, x = 3659.84, y = -959.6424, name = "Overgrown Relic", desc = "", flags = 131073, quests = { 39463, 38731, 0, 0 } },
    { id = 4880, continent = 13, x = 4845.531, y = 59.68576, name = "Jeweled Arakkoa Effigy", desc = "", flags = 131073, quests = { 39463, 38732, 0, 0 } },
    { id = 4881, continent = 13, x = 4174.221, y = 378.908, name = "\"Borrowed\" Enchanted Spyglass", desc = "", flags = 131073, quests = { 39463, 38735, 0, 0 } },
    { id = 4882, continent = 13, x = 3385.81, y = -719.908, name = "Mysterious Corrupted Obelisk", desc = "", flags = 131073, quests = { 39463, 38739, 0, 0 } },
    { id = 4883, continent = 13, x = 4950.329, y = -1620.701, name = "Forgotten Shard of the Cipher", desc = "", flags = 131073, quests = { 39463, 38740, 0, 0 } },
    { id = 4884, continent = 13, x = 3729.583, y = 315.099, name = "Looted Bleeding Hollow Treasure", desc = "", flags = 131073, quests = { 39463, 38741, 0, 0 } },
    { id = 4885, continent = 13, x = 4721.906, y = -112.9878, name = "Skull of the Mad Chief", desc = "", flags = 131073, quests = { 39463, 38742, 0, 0 } },
    { id = 4886, continent = 13, x = 4028.851, y = 922.7344, name = "Axe of the Weeping Wolf", desc = "", flags = 131073, quests = { 39463, 38754, 0, 0 } },
    { id = 4887, continent = 13, x = 3941.606, y = 797.0695, name = "Spoils of War", desc = "", flags = 131073, quests = { 39463, 38755, 0, 0 } },
    { id = 4888, continent = 13, x = 3183.853, y = -175.7986, name = "Ironbeard's Treasure", desc = "", flags = 131073, quests = { 39463, 38758, 0, 0 } },
    { id = 4889, continent = 13, x = 3854.408, y = 868.8768, name = "The Eye of Grannok", desc = "", flags = 131073, quests = { 39463, 38757, 0, 0 } },
    { id = 4890, continent = 13, x = 3198.556, y = -71.38021, name = "Stashed Iron Sea Booty", desc = "", flags = 131073, quests = { 39463, 38760, 0, 0 } },
    { id = 4891, continent = 13, x = 3226.92, y = -130.8559, name = "Stashed Iron Sea Booty", desc = "", flags = 131073, quests = { 39463, 38761, 0, 0 } },
    { id = 4892, continent = 13, x = 3192.925, y = -98.02431, name = "Stashed Iron Sea Booty", desc = "", flags = 131073, quests = { 39463, 38762, 0, 0 } },
    { id = 4893, continent = 13, x = 4650.619, y = -752.4011, name = "Book of Zyzzix", desc = "", flags = 131073, quests = { 39463, 38771, 0, 0 } },
    { id = 4894, continent = 13, x = 4380.742, y = -755.9983, name = "Fel-Drenched Satchel", desc = "", flags = 131073, quests = { 39463, 38773, 0, 0 } },
    { id = 4895, continent = 13, x = 4457.226, y = -751.75, name = "Sacrificial Blade", desc = "", flags = 131073, quests = { 39463, 38776, 0, 0 } },
    { id = 4896, continent = 13, x = 4420.985, y = -2157.908, name = "Stashed Bleeding Hollow Loot", desc = "", flags = 131073, quests = { 39463, 38779, 0, 0 } },
    { id = 4897, continent = 13, x = 3106.711, y = -272.1337, name = "Brazier of Awakening", desc = "", flags = 131073, quests = { 39463, 38788, 0, 0 } },
    { id = 4898, continent = 13, x = 3246.298, y = -914.2396, name = "Bleeding Hollow Mushroom Stash", desc = "", flags = 131073, quests = { 39463, 38809, 0, 0 } },
    { id = 4899, continent = 13, x = 3300.825, y = -839.2813, name = "Looted Mystical Staff", desc = "", flags = 131073, quests = { 39463, 38814, 0, 0 } },
    { id = 4900, continent = 13, x = 4591.291, y = -559.3958, name = "The Commander's Shield", desc = "", flags = 131073, quests = { 39463, 38821, 0, 0 } },
    { id = 4901, continent = 13, x = 4694.978, y = -541.3993, name = "Dazzling Rod", desc = "", flags = 131073, quests = { 39463, 38822, 0, 0 } },
    { id = 4902, continent = 13, x = 4722.054, y = 192.3507, name = "Partially Mined Apexis Crystal", desc = "", flags = 131073, quests = { 39463, 38863, 0, 0 } },
    { id = 4903, continent = 13, x = 4789.866, y = -1002.445, name = "Fel-Tainted Apexis Formation", desc = "", flags = 131073, quests = { 39463, 39075, 0, 0 } },
    { id = 4904, continent = 13, x = 2957.8, y = -1751.554, name = "Bejeweled Egg", desc = "", flags = 131073, quests = { 39463, 39469, 0, 0 } },
    { id = 4905, continent = 13, x = 2759.64, y = -1175.747, name = "Dead Man's Chest", desc = "", flags = 131073, quests = { 39463, 39470, 0, 0 } },

    { id = 5000, continent = 14, x = 4029.823979, y = 4209.308125, name = "A Steamy Jewelry Box", desc = "", flags = 65537, quests = { 39531, 0, 0, 0 } },
    { id = 5001, continent = 14, x = 4053.043389, y = 4672.325625, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40491, 0, 0, 0 } },
    { id = 5002, continent = 14, x = 4138.781371, y = 4498.740625, name = "Small Treasure Chest", desc = "On a boat", flags = 65537, quests = { 40475, 0, 0, 0 } },
    { id = 5003, continent = 14, x = 4159.393254, y = 4503.490000, name = "Treasure Chest", desc = "Underwater cave, below the boat", flags = 65537, quests = { 44352, 0, 0, 0 } },
    { id = 5004, continent = 14, x = 3929.992932, y = 4328.228750, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40472, 0, 0, 0 } },
    --{ id = 5005, continent = 14, x = 4019.304266, y = -25.187352, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40916, 0, 0, 0 } },
    --{ id = 5006, continent = 14, x = 4202.765088, y = -271.050719, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38690, 0, 0, 0 } },
    --{ id = 5007, continent = 14, x = 4338.265859, y = -387.238021, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40909, 0, 0, 0 } },
    --{ id = 5008, continent = 14, x = 4141.656897, y = -211.577536, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40914, 0, 0, 0 } },
    --{ id = 5009, continent = 14, x = 4301.614569, y = -369.866129, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40913, 0, 0, 0 } },
    --{ id = 5010, continent = 14, x = 4246.842010, y = -115.521191, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40911, 0, 0, 0 } },
    --{ id = 5011, continent = 14, x = 4506.534790, y = -37.041114, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40915, 0, 0, 0 } },
    --{ id = 5012, continent = 14, x = 4351.073373, y = -210.657847, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40912, 0, 0, 0 } },
    { id = 5013, continent = 14, x = 1345.965486, y = 2449.678455, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40223, 0, 0, 0 } },
    { id = 5014, continent = 14, x = 629.910996, y = 2344.104678, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39971, 0, 0, 0 } },
    { id = 5015, continent = 14, x = 1514.683797, y = 1419.772562, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39976, 0, 0, 0 } },
    { id = 5016, continent = 14, x = 1882.319999, y = 1523.848839, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39974, 0, 0, 0 } },
    { id = 5017, continent = 14, x = 1227.912584, y = 3165.858017, name = "Small Treasure Chest", desc = "Cave entrance @ 23.6, 54.2", flags = 65537, quests = { 40797, 0, 0, 0 } },
    { id = 5018, continent = 14, x = 820.842221, y = 2724.469777, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39970, 0, 0, 0 } },
    { id = 5019, continent = 14, x = 1314.268406, y = 956.670566, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40820, 0, 0, 0 } },
    { id = 5020, continent = 14, x = 1313.270073, y = 1080.963098, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40274, 0, 0, 0 } },
    { id = 5021, continent = 14, x = 1634.234198, y = 2465.776584, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40759, 0, 0, 0 } },
    { id = 5022, continent = 14, x = 1351.955485, y = 1277.884400, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39975, 0, 0, 0 } },
    { id = 5023, continent = 14, x = 1599.791702, y = 1174.931248, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40338, 0, 0, 0 } },
    { id = 5024, continent = 14, x = 1305.283408, y = 2114.987118, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40743, 0, 0, 0 } },
    { id = 5025, continent = 14, x = 1211.939253, y = 1248.308767, name = "Small Treasure Chest", desc = "Cave entrance @ 70.7, 54.0", flags = 65537, quests = { 39977, 0, 0, 0 } },
    { id = 5026, continent = 14, x = 3603.430000, y = 4179.621503, name = "Glimmering Treasure Chest", desc = "Inside cave", flags = 65537, quests = { 39606, 0, 0, 0 } },
    { id = 5027, continent = 14, x = 4686.362500, y = 4882.462304, name = "Floating Treasure", desc = "On river surface", flags = 65537, quests = { 39494, 0, 0, 0 } },
    { id = 5028, continent = 14, x = 5134.050000, y = 4084.872340, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40498, 0, 0, 0 } },
    { id = 5029, continent = 14, x = 5331.032500, y = 4467.404406, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40481, 0, 0, 0 } },
    { id = 5030, continent = 14, x = 4462.518750, y = 4071.437758, name = "Glimmering Treasure Chest", desc = "Path past the Skyhorn", flags = 65537, quests = { 39471, 0, 0, 0 } },
    { id = 5031, continent = 14, x = 3503.525000, y = 4421.443992, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40489, 0, 0, 0 } },
    { id = 5032, continent = 14, x = 5071.373750, y = 4379.726077, name = "Small Treasure Chest", desc = "All the way at the top of the mountain", flags = 65537, quests = { 40507, 0, 0, 0 } },
    { id = 5033, continent = 14, x = 4255.640000, y = 4893.068553, name = "Treasure Chest", desc = "", flags = 65537, quests = { 39812, 0, 0, 0 } },
    { id = 5034, continent = 14, x = 4886.172500, y = 4321.038163, name = "Treasure Chest", desc = "1/4 of slow fall toy", flags = 65537, quests = { 39503, 0, 0, 0 } },
    { id = 5035, continent = 14, x = 4668.455000, y = 3913.051098, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40500, 0, 0, 0 } },
    { id = 5036, continent = 14, x = 5675.987500, y = 4704.984395, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40479, 0, 0, 0 } },
    { id = 5037, continent = 14, x = 5369.203750, y = 5048.626879, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40477, 0, 0, 0 } },
    { id = 5038, continent = 14, x = 5311.240000, y = 4096.892757, name = "Small Treasure Chest", desc = "All the way at the top of the mountain", flags = 65537, quests = { 40506, 0, 0, 0 } },
    { id = 5039, continent = 14, x = 5143.003750, y = 4137.196505, name = "Small Treasure Chest", desc = "Cave @ 51.6, 37.4", flags = 65537, quests = { 40497, 0, 0, 0 } },
    { id = 5040, continent = 14, x = 4539.803750, y = 3991.537345, name = "Totally Safe Treasure Chest", desc = "", flags = 65537, quests = { 39766, 0, 0, 0 } },
    { id = 5041, continent = 14, x = 4622.743750, y = 3791.432771, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40487, 0, 0, 0 } },
    { id = 5042, continent = 14, x = 5002.571250, y = 3859.312767, name = "Glimmering Treasure Chest", desc = "Cave entrance @ 55.1, 44.3", flags = 65537, quests = { 40483, 0, 0, 0 } },
    { id = 5043, continent = 14, x = 4557.711250, y = 3898.909432, name = "Treasure Chest", desc = "1/4 of slow fall toy; on ledge, path to southeast", flags = 65537, quests = { 39824, 0, 0, 0 } },
    { id = 5044, continent = 14, x = 5668.447500, y = 4494.273572, name = "Small Treasure Chest", desc = "Underwater cave", flags = 65537, quests = { 44279, 0, 0, 0 } },
    { id = 5045, continent = 14, x = 5435.178750, y = 4011.335677, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40505, 0, 0, 0 } },
    { id = 5046, continent = 14, x = 4911.620000, y = 3910.222765, name = "Small Treasure Chest", desc = "Cave entrance @ 55.1, 44.3", flags = 65537, quests = { 40484, 0, 0, 0 } },
    { id = 5047, continent = 14, x = 3534.156250, y = 4596.093567, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40510, 0, 0, 0 } },
    { id = 5048, continent = 14, x = 5184.945000, y = 4178.914419, name = "Treasure Chest", desc = "1/4 of slow fall toy, in nest at top of mountain", flags = 65537, quests = { 39466, 0, 0, 0 } },
    { id = 5049, continent = 14, x = 5638.287500, y = 4388.918160, name = "Glimmering Treasure Chest", desc = "Top of the building", flags = 65537, quests = { 40482, 0, 0, 0 } },
    { id = 5050, continent = 14, x = 5102.947500, y = 3937.799014, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40499, 0, 0, 0 } },
    { id = 5051, continent = 14, x = 4500.690000, y = 3939.920264, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40493, 0, 0, 0 } },
    { id = 5052, continent = 14, x = 5243.851250, y = 4084.872340, name = "Treasure Chest", desc = "Cave @ 51.6, 37.4", flags = 65537, quests = { 40496, 0, 0, 0 } },
    { id = 5053, continent = 14, x = 4034.623750, y = 5100.951044, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40488, 0, 0, 0 } },
    { id = 5054, continent = 14, x = 5779.662500, y = 4608.113983, name = "Treasure Chest", desc = "Cave entrance @ 42.5, 25.4", flags = 65537, quests = { 40478, 0, 0, 0 } },
    { id = 5055, continent = 14, x = 4027.083750, y = 4905.796053, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40474, 0, 0, 0 } },
    { id = 5056, continent = 14, x = 5311.100098, y = 4684.200195, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40480, 0, 0, 0 } },
    { id = 5057, continent = 14, x = 3371.103750, y = 4910.745636, name = "Treasure Chest", desc = "Hard to reach; try from behind the totem", flags = 65537, quests = { 40473, 0, 0, 0 } },
    { id = 5058, continent = 14, x = 516.421830, y = 151.544452, name = "Treasure Chest", desc = "Underwater in a ship", flags = 65537, quests = { 38503, 0, 0, 0 } },
    { id = 5059, continent = 14, x = 343.134063, y = 889.288678, name = "Treasure Chest", desc = "", flags = 65537, quests = { 38516, 0, 0, 0 } },
    { id = 5060, continent = 14, x = 515.262456, y = 191.854546, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38510, 0, 0, 0 } },
    { id = 5061, continent = 14, x = 294.131189, y = 411.938395, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38383, 0, 0, 0 } },
    { id = 5062, continent = 14, x = 3976.183416, y = 4213.871250, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40471, 0, 0, 0 } },
    { id = 5063, continent = 14, x = 301.653468, y = 3883.400455, name = "Small Treasure Chest", desc = "Grapple from 50.0, 84.5", flags = 65537, quests = { 43864, 0, 0, 0 } },
    { id = 5064, continent = 14, x = 2187.493060, y = 3985.558729, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43853, 0, 0, 0 } },
    { id = 5065, continent = 14, x = 2998.248597, y = 4684.010402, name = "Arcane Power Unit", desc = "", flags = 65537, quests = { 43989, 0, 0, 0 } },
    { id = 5066, continent = 14, x = 1917.981630, y = 5195.356978, name = "Ancient Mana Chunk", desc = "", flags = 65537, quests = { 42827, 0, 0, 0 } },
    { id = 5067, continent = 14, x = 2339.278343, y = 3756.257821, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43854, 0, 0, 0 } },
    { id = 5068, continent = 14, x = 2817.957297, y = 5168.706993, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43847, 0, 0, 0 } },
    { id = 5069, continent = 14, x = 1627.738552, y = 3124.431108, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43857, 0, 0, 0 } },
    { id = 5070, continent = 14, x = 1311.951121, y = 1996.248437, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43862, 0, 0, 0 } },
    { id = 5071, continent = 14, x = 181.706073, y = 5006.031047, name = "Shimmering Ancient Mana Cluster", desc = "", flags = 65537, quests = { 43748, 0, 0, 0 } },
    { id = 5072, continent = 14, x = 2845.352689, y = 5033.236239, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43848, 0, 0, 0 } },
    { id = 5073, continent = 14, x = 1417.090195, y = 3566.931891, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43871, 0, 0, 0 } },
    { id = 5074, continent = 14, x = 714.065188, y = 3940.586880, name = "Treasure Chest", desc = "Upstairs", flags = 65537, quests = { 43867, 0, 0, 0 } },
    { id = 5075, continent = 14, x = 1423.753939, y = 5699.485849, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43844, 0, 0, 0 } },
    { id = 5076, continent = 14, x = 1132.400237, y = 4884.440493, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43831, 0, 0, 0 } },
    { id = 5077, continent = 14, x = 1429.677268, y = 5469.074525, name = "Kel'danath's Manaflask", desc = "", flags = 65537, quests = { 42842, 0, 0, 0 } },
    { id = 5078, continent = 14, x = 1212.365167, y = 3642.440180, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43875, 0, 0, 0 } },
    { id = 5079, continent = 14, x = 1318.985073, y = 2107.845246, name = "Small Treasure Chest", desc = "Entrance @ 79.3, 57.4", flags = 65537, quests = { 43861, 0, 0, 0 } },
    { id = 5080, continent = 14, x = 827.348839, y = 5166.486161, name = "Kyrtos's Research Notes", desc = "Cave entrance @ 27.3, 72.9", flags = 65537, quests = { 43987, 0, 0, 0 } },
    { id = 5081, continent = 14, x = 2483.659466, y = 4073.836802, name = "Shimmering Ancient Mana Cluster", desc = "", flags = 65537, quests = { 43744, 0, 0, 0 } },
    { id = 5082, continent = 14, x = 1639.215000, y = 5358.588132, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43842, 0, 0, 0 } },
    { id = 5083, continent = 14, x = 637.061923, y = 4194.316939, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43869, 0, 0, 0 } },
    { id = 5084, continent = 14, x = 2263.385701, y = 4212.638804, name = "Glimmering Treasure Chest", desc = "Cave entrance behind waterfall @ 42.2, 30.0", flags = 65537, quests = { 43856, 0, 0, 0 } },
    { id = 5085, continent = 14, x = 1405.613747, y = 2921.224978, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43858, 0, 0, 0 } },
    { id = 5086, continent = 14, x = 1391.175635, y = 3251.573742, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43872, 0, 0, 0 } },
    { id = 5087, continent = 14, x = 461.583327, y = 3878.958791, name = "Treasure Chest", desc = "Upstairs", flags = 65537, quests = { 44325, 0, 0, 0 } },
    { id = 5088, continent = 14, x = 2717.260719, y = 4323.680405, name = "Glimmering Treasure Chest", desc = "", flags = 65537, quests = { 43849, 0, 0, 0 } },
    { id = 5089, continent = 14, x = 592.266754, y = 4864.453005, name = "Small Treasure Chest", desc = "Inside the Lightbreaker, after quests; portal @ 31.0, 85.1", flags = 65537, quests = { 43834, 0, 0, 0 } },
    { id = 5090, continent = 14, x = 387.541726, y = 3977.785816, name = "Small Treasure Chest", desc = "Grapple from 48.4, 82.2", flags = 65537, quests = { 43866, 0, 0, 0 } },
    { id = 5091, continent = 14, x = 1151.651054, y = 3455.890289, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43874, 0, 0, 0 } },
    { id = 5092, continent = 14, x = 1210.143919, y = 3475.877777, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43873, 0, 0, 0 } },
    { id = 5093, continent = 14, x = 879.177960, y = 2043.441117, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43863, 0, 0, 0 } },
    { id = 5094, continent = 14, x = 2287.079014, y = 3730.718253, name = "Dusty Coffer", desc = "", flags = 65537, quests = { 40767, 0, 0, 0 } },
    { id = 5095, continent = 14, x = 2298.185254, y = 4170.998203, name = "Enchanted Burial Urn", desc = "", flags = 65537, quests = { 43986, 0, 0, 0 } },
    { id = 5096, continent = 14, x = 2344.831463, y = 5736.684785, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43846, 0, 0, 0 } },
    { id = 5097, continent = 14, x = 404.941502, y = 3776.800518, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43868, 0, 0, 0 } },
    { id = 5098, continent = 14, x = 2017.197376, y = 3799.008838, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43855, 0, 0, 0 } },
    { id = 5099, continent = 14, x = 2735.400911, y = 4328.677277, name = "Shimmering Ancient Mana Cluster", desc = "", flags = 65537, quests = { 43746, 0, 0, 0 } },
    { id = 5100, continent = 14, x = 909.535017, y = 3307.649751, name = "Glimmering Treasure Chest", desc = "", flags = 65537, quests = { 43876, 0, 0, 0 } },
    { id = 5101, continent = 14, x = 774.038886, y = 3961.129576, name = "Treasure Chest", desc = "Upstairs", flags = 65537, quests = { 44323, 0, 0, 0 } },
    { id = 5102, continent = 14, x = 809.578854, y = 3977.230608, name = "Treasure Chest", desc = "Jumping puzzle! I recommend starting on the bookshelf.", flags = 65537, quests = { 44324, 0, 0, 0 } },
    { id = 5103, continent = 14, x = 607.075074, y = 4294.809589, name = "Small Treasure Chest", desc = "Upstairs", flags = 65537, quests = { 43870, 0, 0, 0 } },
    { id = 5104, continent = 14, x = 747.383909, y = 2236.653504, name = "Shimmering Ancient Mana Cluster", desc = "", flags = 65537, quests = { 43741, 0, 0, 0 } },
    { id = 5105, continent = 14, x = 735.537253, y = 3987.224353, name = "Small Treasure Chest", desc = "Grapple to it", flags = 65537, quests = { 43865, 0, 0, 0 } },
    { id = 5106, continent = 14, x = 1169.050830, y = 2389.890914, name = "Small Treasure Chest", desc = "Underwater, in a sunken ship", flags = 65537, quests = { 43860, 0, 0, 0 } },
    { id = 5107, continent = 14, x = 1604.045239, y = 2690.813654, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43859, 0, 0, 0 } },
    { id = 5108, continent = 14, x = 2852.016434, y = 5559.573431, name = "Small Treasure Chest", desc = "Cave entrance @ 19.4, 19.4", flags = 65537, quests = { 43845, 0, 0, 0 } },
    { id = 5109, continent = 14, x = 2598.423948, y = 4198.758604, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43850, 0, 0, 0 } },
    { id = 5110, continent = 14, x = 220.577914, y = 4541.321944, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43830, 0, 0, 0 } },
    { id = 5111, continent = 14, x = 281.292027, y = 5217.565298, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43831, 0, 0, 0 } },
    { id = 5112, continent = 14, x = -1259.708750, y = 5544.067295, name = "Seemingly Unguarded Treasure", desc = "Seemingly...", flags = 65537, quests = { 38239, 0, 0, 0 } },
    { id = 5113, continent = 14, x = -264.524375, y = 8101.484460, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 44105, 0, 0, 0 } },
    { id = 5114, continent = 14, x = 738.568750, y = 6437.614751, name = "Treasure Chest", desc = "Leyhollow cave entrance @ 47.8, 23.7", flags = 65537, quests = { 42289, 0, 0, 0 } },
    { id = 5115, continent = 14, x = 1266.258125, y = 5984.251440, name = "Treasure Chest", desc = "Ley Portal @ 58.7, 14.1", flags = 65537, quests = { 37980, 0, 0, 0 } },
    { id = 5116, continent = 14, x = 1450.356250, y = 7024.087639, name = "Glimmering Treasure Chest", desc = "", flags = 65537, quests = { 38367, 0, 0, 0 } },
    { id = 5117, continent = 14, x = 455.171875, y = 7103.821593, name = "Treasure Chest", desc = "", flags = 65537, quests = { 42292, 0, 0, 0 } },
    { id = 5118, continent = 14, x = 291.285000, y = 6559.522037, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 37831, 0, 0, 0 } },
    { id = 5119, continent = 14, x = 72.476250, y = 6900.862436, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 37713, 0, 0, 0 } },
    { id = 5120, continent = 14, x = 901.576875, y = 6349.314339, name = "Treasure Chest", desc = "Cave entrance @ 53.9, 22.4; don't wake up the bears", flags = 65537, quests = { 42339, 0, 0, 0 } },
    { id = 5121, continent = 14, x = -727.625625, y = 7157.856174, name = "Treasure Chest", desc = "", flags = 65537, quests = { 38316, 0, 0, 0 } },
    { id = 5122, continent = 14, x = -117.333750, y = 5985.569357, name = "Glimmering Treasure Chest", desc = "", flags = 65537, quests = { 37830, 0, 0, 0 } },
    { id = 5123, continent = 14, x = 276.785625, y = 6112.089350, name = "Treasure Chest", desc = "", flags = 65537, quests = { 38251, 0, 0, 0 } },
    { id = 5124, continent = 14, x = -161.710625, y = 5692.332913, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42294, 0, 0, 0 } },
    { id = 5125, continent = 14, x = 708.251875, y = 6082.436227, name = "Small Treasure Chest", desc = "Cave entrance @ 55.7, 25.4", flags = 65537, quests = { 42338, 0, 0, 0 } },
    { id = 5126, continent = 14, x = -403.366875, y = 6522.620372, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42290, 0, 0, 0 } },
    { id = 5127, continent = 14, x = 1137.960625, y = 5664.656664, name = "Treasure Chest", desc = "", flags = 65537, quests = { 37832, 0, 0, 0 } },
    { id = 5128, continent = 14, x = -43.518750, y = 6404.666836, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42281, 0, 0, 0 } },
    { id = 5129, continent = 14, x = 25.463125, y = 6284.077467, name = "Small Treasure Chest", desc = "Inside the Academy", flags = 65537, quests = { 42284, 0, 0, 0 } },
    { id = 5130, continent = 14, x = 243.832500, y = 7552.572196, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 44102, 0, 0, 0 } },
    { id = 5131, continent = 14, x = 991.209375, y = 6166.123931, name = "Treasure Chest", desc = "Ley Portal inside tower", flags = 65537, quests = { 40711, 0, 0, 0 } },
    { id = 5132, continent = 14, x = -190.709375, y = 6305.823091, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42283, 0, 0, 0 } },
    { id = 5133, continent = 14, x = 1466.613125, y = 6677.475572, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42295, 0, 0, 0 } },
    { id = 5134, continent = 14, x = 272.831250, y = 6246.516844, name = "Small Treasure Chest", desc = "Inside the Academy", flags = 65537, quests = { 42285, 0, 0, 0 } },
    { id = 5135, continent = 14, x = 169.138750, y = 6336.794131, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 37596, 0, 0, 0 } },
    { id = 5136, continent = 14, x = 499.988125, y = 5293.004183, name = "Small Treasure Chest", desc = "Underwater cave, entrance is on east side of cliff", flags = 65537, quests = { 44103, 0, 0, 0 } },
    { id = 5137, continent = 14, x = -102.834375, y = 5478.171465, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40751, 0, 0, 0 } },
    { id = 5138, continent = 14, x = 505.260625, y = 5517.708963, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42958, 0, 0, 0 } },
    { id = 5139, continent = 14, x = -575.162500, y = 5679.812705, name = "Small Treasure Chest", desc = "Cave entrance @ 64.0, 52.9", flags = 65537, quests = { 42278, 0, 0, 0 } },
    { id = 5140, continent = 14, x = 84.339375, y = 5636.980416, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42293, 0, 0, 0 } },
    { id = 5141, continent = 14, x = 1584.365625, y = 6186.551638, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38389, 0, 0, 0 } },
    { id = 5142, continent = 14, x = -186.755000, y = 6577.313911, name = "Treasure Chest", desc = "", flags = 65537, quests = { 37828, 0, 0, 0 } },
    { id = 5143, continent = 14, x = -968.842500, y = 5886.066653, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42272, 0, 0, 0 } },
    { id = 5144, continent = 14, x = -759.700000, y = 5719.350203, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42273, 0, 0, 0 } },
    { id = 5145, continent = 14, x = 441.551250, y = 6065.303311, name = "Treasure Chest", desc = "", flags = 65537, quests = { 38419, 0, 0, 0 } },
    { id = 5146, continent = 14, x = 1270.212500, y = 6015.881438, name = "Treasure Chest", desc = "", flags = 65537, quests = { 37958, 0, 0, 0 } },
    { id = 5147, continent = 14, x = -693.793750, y = 6147.673099, name = "Disputed Treasure", desc = "", flags = 65537, quests = { 38365, 0, 0, 0 } },
    { id = 5148, continent = 14, x = 1009.663125, y = 6298.574550, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 44104, 0, 0, 0 } },
    { id = 5149, continent = 14, x = 210.000625, y = 6252.447468, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42287, 0, 0, 0 } },
    { id = 5150, continent = 14, x = -540.012500, y = 5967.118524, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40752, 0, 0, 0 } },
    { id = 5151, continent = 14, x = -484.651250, y = 6215.545804, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 44405, 0, 0, 0 } },
    { id = 5152, continent = 14, x = -125.242500, y = 6293.961841, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42282, 0, 0, 0 } },
    { id = 5153, continent = 14, x = 587.423750, y = 6183.256847, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42288, 0, 0, 0 } },
    { id = 5154, continent = 14, x = -1025.082500, y = 6327.568715, name = "Treasure Chest", desc = "", flags = 65537, quests = { 37829, 0, 0, 0 } },
    { id = 5155, continent = 14, x = -483.333125, y = 6506.146414, name = "Treacherous Stallions", desc = "Ley Portal @ 60.3, 46.3; kill the stallions", flags = 65537, quests = { 44081, 0, 0, 0 } },
    { id = 5156, continent = 14, x = -742.125000, y = 6575.337036, name = "Treasure Chest", desc = "", flags = 65537, quests = { 38370, 0, 0, 0 } },
    { id = 5157, continent = 14, x = 3081.846258, y = 6040.459164, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38355, 0, 0, 0 } },
    { id = 5158, continent = 14, x = 3683.102610, y = 6630.624824, name = "Glimmering Treasure Chest", desc = "Cave entrance @ 53.2, 38.0", flags = 65537, quests = { 38390, 0, 0, 0 } },
    { id = 5159, continent = 14, x = 2378.850133, y = 6151.218546, name = "Small Treasure Chest", desc = "Second floor balcony", flags = 65537, quests = { 39069, 0, 0, 0 } },
    { id = 5160, continent = 14, x = 2006.416449, y = 6578.275863, name = "Small Treasure Chest", desc = "In underwater cave", flags = 65537, quests = { 38861, 0, 0, 0 } },
    { id = 5161, continent = 14, x = 2833.924427, y = 7255.506111, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39077, 0, 0, 0 } },
    { id = 5162, continent = 14, x = 2959.170863, y = 7405.389453, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38369, 0, 0, 0 } },
    { id = 5163, continent = 14, x = 1794.856486, y = 7047.212349, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38277, 0, 0, 0 } },
    { id = 5164, continent = 14, x = 2497.118029, y = 7478.126958, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39079, 0, 0, 0 } },
    { id = 5165, continent = 14, x = 2869.551713, y = 5736.835188, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38783, 0, 0, 0 } },
    { id = 5166, continent = 14, x = 2246.257865, y = 6119.809169, name = "Treasure Chest", desc = "", flags = 65537, quests = { 39102, 0, 0, 0 } },
    { id = 5167, continent = 14, x = 3473.379105, y = 5840.982069, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39073, 0, 0, 0 } },
    { id = 5168, continent = 14, x = 3002.511272, y = 5892.779989, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38386, 0, 0, 0 } },
    { id = 5169, continent = 14, x = 1888.148553, y = 6520.416484, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38861, 0, 0, 0 } },
    { id = 5170, continent = 14, x = 2566.168850, y = 7487.494667, name = "Small Treasure Chest", desc = "Basement; must have completed The Farmsteads", flags = 65537, quests = { 39080, 0, 0, 0 } },
    { id = 5171, continent = 14, x = 2787.278394, y = 5902.698740, name = "Treasure Chest", desc = "Cave entrance @ 65.9, 56.3; doesn't appear until area quests are finished", flags = 65537, quests = { 38782, 0, 0, 0 } },
    { id = 5172, continent = 14, x = 3462.360357, y = 5936.312283, name = "Treasure Chest", desc = "", flags = 65537, quests = { 39108, 0, 0, 0 } },
    { id = 5173, continent = 14, x = 1795.223778, y = 6002.988329, name = "Treasure Chest", desc = "", flags = 65537, quests = { 39074, 0, 0, 0 } },
    { id = 5174, continent = 14, x = 2824.742137, y = 7743.178015, name = "Treasure Chest", desc = "", flags = 65537, quests = { 39081, 0, 0, 0 } },
    { id = 5175, continent = 14, x = 1717.357958, y = 6114.298752, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38389, 0, 0, 0 } },
    { id = 5176, continent = 14, x = 2055.633523, y = 5974.885202, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38391, 0, 0, 0 } },
    { id = 5177, continent = 14, x = 1946.915209, y = 6272.998761, name = "Small Treasure Chest", desc = "Cave entrance @ 62.1, 86.1", flags = 65537, quests = { 38893, 0, 0, 0 } },
    { id = 5178, continent = 14, x = 3289.366013, y = 7324.386324, name = "Glimmering Treasure Chest", desc = "Top of wall", flags = 65537, quests = { 39086, 0, 0, 0 } },
    { id = 5179, continent = 14, x = 1825.708981, y = 6046.520623, name = "Treasure Chest", desc = "", flags = 65537, quests = { 38900, 0, 0, 0 } },
    { id = 5180, continent = 14, x = 2613.916758, y = 6244.895635, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39087, 0, 0, 0 } },
    { id = 5181, continent = 14, x = 2108.156222, y = 6782.712333, name = "Small Treasure Chest", desc = "Cave entrance @ 50.9, 77.0", flags = 65537, quests = { 38388, 0, 0, 0 } },
    { id = 5182, continent = 14, x = 2253.603697, y = 6923.779008, name = "Small Treasure Chest", desc = "Under tree roots", flags = 65537, quests = { 38366, 0, 0, 0 } },
    { id = 5183, continent = 14, x = 2371.137009, y = 6620.706074, name = "Small Treasure Chest", desc = "In cave", flags = 65537, quests = { 39093, 0, 0, 0 } },
    { id = 5184, continent = 14, x = 2761.200690, y = 5778.163316, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38781, 0, 0, 0 } },
    { id = 5185, continent = 14, x = 1833.054813, y = 6151.218546, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 44136, 0, 0, 0 } },
    { id = 5186, continent = 14, x = 3291.202471, y = 6085.093542, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 44139, 0, 0, 0 } },
    { id = 5187, continent = 14, x = 2948.886698, y = 7224.647776, name = "Treasure Chest", desc = "Top of wall", flags = 65537, quests = { 39084, 0, 0, 0 } },
    { id = 5188, continent = 14, x = 1931.856254, y = 7162.380064, name = "Treasure Chest", desc = "Cave under the inn; entrance behind the building", flags = 65537, quests = { 38387, 0, 0, 0 } },
    { id = 5189, continent = 14, x = 2490.139488, y = 6185.934173, name = "Treasure Chest", desc = "Chest behind waterfall", flags = 65537, quests = { 39071, 0, 0, 0 } },
    { id = 5190, continent = 14, x = 1724.336499, y = 7233.464443, name = "Treasure Chest", desc = "Cave entrance @ 43.7, 89.9", flags = 65537, quests = { 44138, 0, 0, 0 } },
    { id = 5191, continent = 14, x = 2177.207044, y = 7215.280067, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38363, 0, 0, 0 } },
    { id = 5192, continent = 14, x = 3708.078439, y = 6241.038343, name = "Treasure Chest", desc = "Underwater, hidden in roots", flags = 65537, quests = { 39088, 0, 0, 0 } },
    { id = 5193, continent = 14, x = 2239.646616, y = 6608.032115, name = "Small Treasure Chest", desc = "In house behind the fence", flags = 65537, quests = { 38359, 0, 0, 0 } },
    { id = 5194, continent = 14, x = 2136.437676, y = 6134.687295, name = "Small Treasure Chest", desc = "Inside Den of Claws, entrance @ 62.2, 76.2", flags = 65537, quests = { 39070, 0, 0, 0 } },
    { id = 5195, continent = 14, x = 2860.002131, y = 6508.293567, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39072, 0, 0, 0 } },
    { id = 5196, continent = 14, x = 2113.665596, y = 6545.213361, name = "Unguarded Thistlemaw Treasure", desc = "Unguarded...", flags = 65537, quests = { 38466, 0, 0, 0 } },
    { id = 5197, continent = 14, x = 2743.203402, y = 6603.072739, name = "Treasure Chest", desc = "In cave", flags = 65537, quests = { 39097, 0, 0, 0 } },
    { id = 5198, continent = 14, x = 2056.735398, y = 6244.344593, name = "Glimmering Treasure Chest", desc = "", flags = 65537, quests = { 39089, 0, 0, 0 } },
    { id = 5199, continent = 14, x = 2309.799312, y = 6306.612305, name = "Small Treasure Chest", desc = "Upstairs, stairs on the right", flags = 65537, quests = { 38943, 0, 0, 0 } },
    { id = 5200, continent = 14, x = 1800.365860, y = 6906.696716, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38886, 0, 0, 0 } },
    { id = 5201, continent = 14, x = 2256.909321, y = 6209.077924, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39087, 0, 0, 0 } },
    { id = 5202, continent = 14, x = 1714.052334, y = 7291.874863, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 39085, 0, 0, 0 } },
    { id = 5203, continent = 14, x = 3289.733305, y = 7324.937365, name = "Small Treasure Chest", desc = "Top of wall", flags = 65537, quests = { 39085, 0, 0, 0 } },
    { id = 5204, continent = 14, x = 3781.621909, y = 3110.520740, name = "Treasure Chest", desc = "", flags = 65537, quests = { 38495, 0, 0, 0 } },
    { id = 5205, continent = 14, x = 2306.080613, y = 2240.788937, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38476, 0, 0, 0 } },
    { id = 5206, continent = 14, x = 2812.500004, y = 2577.309581, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38477, 0, 0, 0 } },
    { id = 5207, continent = 14, x = 3262.435643, y = 672.486691, name = "Treasure Chest", desc = "On top of the mast", flags = 65537, quests = { 42629, 0, 0, 0 } },
    { id = 5208, continent = 14, x = 3761.117533, y = 3000.861427, name = "Treasure Chest", desc = "Cave entrance @ 34.8, 34.2", flags = 65537, quests = { 38487, 0, 0, 0 } },
    { id = 5209, continent = 14, x = 3590.892528, y = 2114.303591, name = "Small Treasure Chest", desc = "In cave", flags = 65537, quests = { 38483, 0, 0, 0 } },
    { id = 5210, continent = 14, x = 3523.963151, y = 1503.924767, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 40094, 0, 0, 0 } },
    { id = 5211, continent = 14, x = 3346.774395, y = 2150.276487, name = "Glimmering Treasure Chest", desc = "Guarded by Vault Keepers", flags = 65537, quests = { 38763, 0, 0, 0 } },
    { id = 5212, continent = 14, x = 3858.996912, y = 2569.186669, name = "Glimmering Treasure Chest", desc = "Entrance @ 42.2, 34.9", flags = 65537, quests = { 43189, 0, 0, 0 } },
    { id = 5213, continent = 14, x = 3610.623154, y = 2529.152316, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 43238, 0, 0, 0 } },
    { id = 5214, continent = 14, x = 3352.577521, y = 1842.186035, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40095, 0, 0, 0 } },
    { id = 5215, continent = 14, x = 3323.175020, y = 2949.222914, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38680, 0, 0, 0 } },
    { id = 5216, continent = 14, x = 2508.416244, y = 2992.738515, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38478, 0, 0, 0 } },
    { id = 5217, continent = 14, x = 3082.151887, y = 2960.246866, name = "Treasure Chest", desc = "On the wrecked ship", flags = 65537, quests = { 38677, 0, 0, 0 } },
    { id = 5218, continent = 14, x = 2059.641230, y = 2015.668229, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 38480, 0, 0, 0 } },
    { id = 5219, continent = 14, x = 1573.726214, y = 1945.463061, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43190, 0, 0, 0 } },
    { id = 5220, continent = 14, x = 3395.907522, y = 2611.541854, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38488, 0, 0, 0 } },
    { id = 5221, continent = 14, x = 3509.648776, y = 1241.090539, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43205, 0, 0, 0 } },
    { id = 5222, continent = 14, x = 2631.829373, y = 2561.063757, name = "Treasure Chest", desc = "", flags = 65537, quests = { 38474, 0, 0, 0 } },
    { id = 5223, continent = 14, x = 2066.604980, y = 2320.277434, name = "Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 38481, 0, 0, 0 } },
    { id = 5224, continent = 14, x = 2159.068108, y = 2145.634823, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 38485, 0, 0, 0 } },
    { id = 5225, continent = 14, x = 2415.566241, y = 483.338881, name = "Treasure Chest", desc = "*Really* requires the Stormforged Grapple Launcher", flags = 65537, quests = { 43307, 0, 0, 0 } },
    { id = 5226, continent = 14, x = 3581.220653, y = 2100.378599, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 43246, 0, 0, 0 } },
    { id = 5227, continent = 14, x = 2915.408757, y = 1592.696592, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40088, 0, 0, 0 } },
    { id = 5228, continent = 14, x = 3857.062536, y = 2279.662873, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 43255, 0, 0, 0 } },
    { id = 5229, continent = 14, x = 3068.224387, y = 252.416094, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43191, 0, 0, 0 } },
    { id = 5230, continent = 14, x = 2565.673746, y = 283.167118, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40099, 0, 0, 0 } },
    { id = 5231, continent = 14, x = 2832.617504, y = 642.896083, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 43304, 0, 0, 0 } },
    { id = 5232, continent = 14, x = 3681.808156, y = 2876.116705, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43208, 0, 0, 0 } },
    { id = 5233, continent = 14, x = 2856.216880, y = 2185.669176, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43207, 0, 0, 0 } },
    { id = 5234, continent = 14, x = 2764.140627, y = 2249.492057, name = "Treasure Chest", desc = "Underwater, at base of waterfall", flags = 65537, quests = { 38738, 0, 0, 0 } },
    { id = 5235, continent = 14, x = 4097.311919, y = 3133.729061, name = "Treasure Chest", desc = "Cave entrance @ 33.6, 27.3", flags = 65537, quests = { 38490, 0, 0, 0 } },
    { id = 5236, continent = 14, x = 2663.939999, y = 2329.560762, name = "Small Treasure Chest", desc = "Cave entrance @ 48.2, 65.2", flags = 65537, quests = { 38681, 0, 0, 0 } },
    { id = 5237, continent = 14, x = 3156.431889, y = 742.111652, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42632, 0, 0, 0 } },
    { id = 5238, continent = 14, x = 3571.548777, y = 778.664757, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40085, 0, 0, 0 } },
    { id = 5239, continent = 14, x = 3698.056906, y = 2423.554459, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 43240, 0, 0, 0 } },
    { id = 5240, continent = 14, x = 2952.935633, y = 3447.621593, name = "Treasure Chest", desc = "Cave entrance @ 31.4, 57.1", flags = 65537, quests = { 38529, 0, 0, 0 } },
    { id = 5241, continent = 14, x = 4428.863805, y = 2737.446991, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38498, 0, 0, 0 } },
    { id = 5242, continent = 14, x = 3053.523136, y = 848.289718, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 42628, 0, 0, 0 } },
    { id = 5243, continent = 14, x = 2731.643126, y = 1671.604881, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40090, 0, 0, 0 } },
    { id = 5244, continent = 14, x = 3465.158149, y = 860.474086, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 43305, 0, 0, 0 } },
    { id = 5245, continent = 14, x = 2577.666871, y = 973.034439, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43188, 0, 0, 0 } },
    { id = 5246, continent = 14, x = 3444.653773, y = 1021.771912, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 38637, 0, 0, 0 } },
    { id = 5247, continent = 14, x = 2526.212494, y = 2674.784526, name = "Small Treasure Chest", desc = "In tower; grapple to wall, then to top of tower", flags = 65537, quests = { 38475, 0, 0, 0 } },
    { id = 5248, continent = 14, x = 3558.781902, y = 1031.635448, name = "Small Treasure Chest", desc = "Tomb entrance @ 70.0, 42.6", flags = 65537, quests = { 40086, 0, 0, 0 } },
    { id = 5249, continent = 14, x = 4032.316917, y = 1061.226057, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40108, 0, 0, 0 } },
    { id = 5250, continent = 14, x = 3459.355024, y = 1470.852910, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40093, 0, 0, 0 } },
    { id = 5251, continent = 14, x = 2655.428749, y = 2742.668863, name = "Treasure Chest", desc = "", flags = 65537, quests = { 38486, 0, 0, 0 } },
    { id = 5252, continent = 14, x = 2957.578133, y = 1228.325963, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43187, 0, 0, 0 } },
    { id = 5253, continent = 14, x = 3646.602530, y = 1303.172796, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43302, 0, 0, 0 } },
    { id = 5254, continent = 14, x = 2328.906238, y = 1397.746701, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40091, 0, 0, 0 } },
    { id = 5255, continent = 14, x = 3917.801913, y = 1440.101886, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38744, 0, 0, 0 } },
    { id = 5256, continent = 14, x = 2744.023126, y = 1445.903966, name = "Treasure Chest", desc = "", flags = 65537, quests = { 40089, 0, 0, 0 } },
    { id = 5257, continent = 14, x = 2943.263758, y = 1091.977081, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40083, 0, 0, 0 } },
    { id = 5258, continent = 14, x = 3339.036895, y = 1665.802801, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 40082, 0, 0, 0 } },
    { id = 5259, continent = 14, x = 4474.515056, y = 2128.808791, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43195, 0, 0, 0 } },
    { id = 5260, continent = 14, x = 2910.766257, y = 741.531444, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43237, 0, 0, 0 } },
    { id = 5261, continent = 14, x = 3409.061272, y = 789.108501, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 43194, 0, 0, 0 } },
    { id = 5262, continent = 14, x = 2470.115618, y = 2471.131516, name = "Small Treasure Chest", desc = "On top of the hut, grapple up", flags = 65537, quests = { 38489, 0, 0, 0 } },
    { id = 5263, continent = 14, x = 3559.168777, y = 716.002292, name = "Small Treasure Chest", desc = "Requires: Stormforged Grapple Launcher", flags = 65537, quests = { 43306, 0, 0, 0 } },
    { id = 5264, continent = 14, x = 3010.580010, y = 3228.883174, name = "Small Treasure Chest", desc = "", flags = 65537, quests = { 38676, 0, 0, 0 } },
    { id = 5265, continent = 14, x = 3351.416896, y = 3173.763413, name = "Treasure Chest", desc = "", flags = 65537, quests = { 43196, 0, 0, 0 } },
}

local frame = CreateFrame("Frame")

local function GetDistanceToPoint(pointx, pointy, x, y)
    local dX = pointx - x
    local dY = pointy - y
    return (dX * dX + dY * dY) ^ 0.5
end

local function SelectQuest(treasure, type)
    if treasure.flags == 131073 then
        if type == "map" then
            return treasure.quests[1]
        elseif type == "complete" then
            return treasure.quests[2]
        else
            --print("Unknown type "..type.. " for flags 131073")
            return 0
        end
    elseif treasure.flags == 65541 then
        if type == "map" then
            return treasure.quests[2]
        elseif type == "complete" then
            return treasure.quests[1]
        else
            --print("Unknown type "..type.. " for flags 65541")
            return 0
        end
    elseif treasure.flags == 65537 then
        if type == "map" then
            return treasure.quests[2]
        elseif type == "complete" then
            return treasure.quests[1]
        else
            --print("Unknown type "..type.. " for flags 65537")
            return 0
        end
    elseif treasure.flags == 524310 then
        if type == "choise1" then
            return treasure.quests[1]
        elseif type == "choise2" then
            return treasure.quests[2]
        elseif type == "map" then
            return treasure.quests[3]
        elseif type == "complete" then
            return treasure.quests[4]
        else
            --print("Unknown type "..type.. " for flags 524310")
            return 0
        end
    elseif treasure.flags == 0 then
        --print("Treasure "..treasure.id.." has 0 flags")
        return 0
    else
        --print("Unknown flags "..treasure.flags)
        return 0
    end
end

local function GetTreasureCompletion(treasure)
    local trquest, tmquest, c1quest, c2quest = SelectQuest(treasure, "complete"), SelectQuest(treasure, "map"), SelectQuest(treasure, "choise1"), SelectQuest(treasure, "choise2")
    local trCheck = trquest == 0 or not IsQuestFlaggedCompleted(trquest)
    local tmCheck = DRTSOptions.ignoretm or tmquest == 0 or not IsQuestFlaggedCompleted(tmquest)
    local choise1Check = c1quest == 0 or IsQuestFlaggedCompleted(c1quest)
    local choise2Check = c2quest == 0 or IsQuestFlaggedCompleted(c2quest)
    return trCheck, tmCheck, choise1Check, choise2Check, trquest, tmquest, c1quest, c2quest
end

local function GetClosestTreasure()
    local dist = 99999999
    local closest = nil
    local x, y, _, mapID = UnitPosition("player")
    for k,v in pairs(alltreasures) do
        if TreasureContinentsIds[mapID] == v.continent then
        local dist2 = GetDistanceToPoint(x, y, v.x, v.y)
        local trCheck, tmCheck, choise1Check, choise2Check = GetTreasureCompletion(v)
        if dist2 < dist and (DRTSOptions.debug or not DRTSOptions.hidden[v.id]) and (DRTSOptions.debug or (trCheck and tmCheck and choise1Check and choise2Check)) then
            dist = dist2
            closest = v
        end
    end
end
    
    if  (DRTSOptions.surprise == true) and dist > 120 then       
        closest = false
    end
    return closest, dist
end

if DBM then
    arrowAvailable = true
    if DBMArrow then
        local text = DBMArrow:CreateFontString(nil, "OVERLAY", "GameTooltipText")
        text:SetWidth(150)
        text:SetHeight(60)
        text:SetPoint("CENTER", DBMArrow, "CENTER", 0, -35)
        text:SetTextColor(1, 1, 1, 1)
        text:SetJustifyH("CENTER")
        DBMArrow.text = text
        arrowTextAvailable = true
    end
end

local function ShowArrow(treasure, dist)
    if dist < 5 then return end
    local x, y, text = treasure.x, treasure.y, DRTSOptions.debug and format("%s (%u)\n%.02f 码", treasure.name, treasure.id, dist) or format("%s\n%.02f 码", treasure.name, dist)
    if arrowAvailable then
        DBM.Arrow:ShowRunTo(x, y, nil, 5)
    end
    if arrowTextAvailable then
        if not DBMArrow.text:IsShown() then
            DBMArrow.text:Show()
        end
        DBMArrow.text:SetText(text)
    end
end

local function HideArrow()
    if arrowAvailable then
        DBM.Arrow:Hide()
    end
    if arrowTextAvailable then
        DBMArrow.text:Hide()
    end
end

local function FilterMinimapPOI(v, x, y, mapID, radius)
    local showTreasures = DRTSOptions.enabled and TreasureContinentsIds[mapID] == v.continent
    if not showTreasures then return false end

    local distCheck = GetDistanceToPoint(x, y, v.x, v.y) < radius
    if not distCheck then return false end

    local trCheck, tmCheck, choise1Check, choise2Check, _, _, _, _ = GetTreasureCompletion(v)
    if DRTSOptions.debug or (not DRTSOptions.hidden[v.id] and trCheck and tmCheck and choise1Check and choise2Check) then
        return true
    end
    return false
end

local currentmapid = -1
local interval = 1

local function onUpdate(self,elapsed)
    if not DRTSOptions.enabled then return end
    if not DRTSOptions.arrowEnabled then return end
    currentmapid = select(4, UnitPosition("player"))
    if not TreasureContinentsIds[currentmapid] then return end
    interval = interval + elapsed
    if interval >= 1 then
        interval = 0
        local closest, dist = GetClosestTreasure()
        if not closest then
            HideArrow()
            return
        end
        ShowArrow(closest, dist)
    end
end

local function onEvent(self, event)
    if event == "ADDON_LOADED" then
        if not DRTSOptions.hidden then
            DRTSOptions.hidden = { }
        end
        if not DRTSOptions.minimap then
            DRTSOptions.minimap = true
        end
        if DRTSOptions.enabled then
            frame:SetScript("OnUpdate", onUpdate)
        else
            frame:SetScript("OnUpdate", nil)
        end
        MinimapPOIHandler:SetFilter(FilterMinimapPOI)
        MinimapPOIHandler:SetDataSource(alltreasures, TreasureContinentsIds)
        if DRTSOptions.minimap then
            MinimapPOIHandler:Enable()
        end
    end
end

frame:SetScript("OnEvent", onEvent)
frame:RegisterEvent("ADDON_LOADED")

SLASH_DRTS1 = "/drts"

SlashCmdList["DRTS"] = function(msg, editBox)
    if msg:lower() == "on" then
        frame:SetScript("OnUpdate", onUpdate)
        DRTSOptions.enabled = true
        DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏: 开启~")
    elseif msg:lower() == "off" then
        frame:SetScript("OnUpdate", nil)
        DRTSOptions.enabled = false
        HideArrow()
        DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏： 关闭~")
    elseif msg:lower() == "toggle" then
        DRTSOptions.enabled = not DRTSOptions.enabled
        frame:SetScript("OnUpdate", (DRTSOptions.enabled and onUpdate or nil))
        if not DRTSOptions.enabled then HideArrow() end
        DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏 "..(DRTSOptions.enabled and "enabled" or "disabled"))
    elseif msg:lower() == "arrow" then
        if not arrowAvailable then
            DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏： 指示箭头不可用，请安装DBM以启用此功能！")
            return
        end
        DRTSOptions.arrowEnabled = not DRTSOptions.arrowEnabled
        DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏： 指示箭头 "..(DRTSOptions.arrowEnabled and "开启" or "关闭"))
        if not DRTSOptions.arrowEnabled then
            HideArrow()
        end
    elseif msg:lower() == "debug" then
        DRTSOptions.debug = not DRTSOptions.debug
        DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏: 调试模式 "..(DRTSOptions.debug and "开启" or "关闭"))
    elseif msg:lower() == "surprise" then
        DRTSOptions.surprise = not DRTSOptions.surprise
        if DRTSOptions.enabled == true then
            frame:SetScript("OnUpdate", onUpdate)
            --DRTSOptions.enabled = true
            DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏 惊喜模式~")
        else
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏 惊喜模式开启，当看见屏幕中间的箭头，就说明你离宝藏挺近的喽~~~")
        end
   elseif msg:lower() == "closest" then
        local closest, dist = GetClosestTreasure()
        if closest then
        DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏: "..closest.id.." ("..closest.name..") "..dist.." 码外")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏: 附近没有啥宝藏~")
        end
    elseif msg:lower() == "minimap" then
        DRTSOptions.minimap = not DRTSOptions.minimap
        if DRTSOptions.minimap then
            MinimapPOIHandler:Enable()
        else
            MinimapPOIHandler:Disable()
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏:小地图按钮"..(DRTSOptions.minimap and "enabled" or "disabled"))
    elseif msg:lower() == "hidepoi" then
        local closest, dist = GetClosestTreasure()
        if closest then
            DRTSOptions.hidden[closest.id] = true
            DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏: POI "..closest.name.." ("..closest.id..") 隐藏模式")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏: 附近没有啥宝藏")
        end
    elseif msg:lower() == "clearhidden" then
    	table.wipe(DRTSOptions.hidden)
    	DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏: hidden treasures cleared")
    elseif msg:lower() == "itm" then
        DRTSOptions.ignoretm = not DRTSOptions.ignoretm
        DEFAULT_CHAT_FRAME:AddMessage("|cff0080ff[地图]|r宝藏: treasure map quests now "..(DRTSOptions.ignoretm and "忽略" or "used"))
    else
        DEFAULT_CHAT_FRAME:AddMessage("命令: /drts on|off   (开启/关闭)|cff0080ff[地图]|r宝藏")
        DEFAULT_CHAT_FRAME:AddMessage("命令: /drts arrow (toggle)    (开启/关闭)|cff0080ff[地图]|r宝藏 指示箭头")
        DEFAULT_CHAT_FRAME:AddMessage("命令: /drts surprise    (开启/关闭)|cff0080ff[地图]|r宝藏 近距模式")
        --DEFAULT_CHAT_FRAME:AddMessage("命令: /drts debug (toggle)    (开启/关闭)|cff0080ff[地图]|r宝藏 调试模式")
    end
end

local function WorldPosToScreenPos(x, y)
    local isMapDungeon = true
    local floorIndex, minY, minX, maxY, maxX = GetCurrentMapDungeonLevel()
    local zoneIndex, locLeft, locTop, locRight, locBottom

    if not (minX and minY and maxX and maxY) then
        isMapDungeon = false
        zoneIndex, locLeft, locTop, locRight, locBottom = GetCurrentMapZone()
        if not (locLeft and locTop and locRight and locBottom) then
            return 0, 0, false
        end
    end

    if isMapDungeon then
        local h, w = abs(maxY - minY), abs(maxX - minX)
        local sx = (maxX - x) / w
        local sy = (maxY - y) / h
        local onMap = y < maxY and y > minY and x < maxX and x > minX
        return sy, sx, onMap
    else
        local h, w = abs(locRight - locLeft), abs(locBottom - locTop)
        local sx = (locTop - x) / w
        local sy = (locLeft - y) / h
        local onMap = y < locLeft and y > locRight and x < locTop and x > locBottom
        return sy, sx, onMap
    end
end

local function TreasureMap_ResetPOI(button)
    button:SetWidth(24)
    button:SetHeight(24)
    button.Texture:SetWidth(12)
    button.Texture:SetHeight(12)
    button.Texture:SetPoint("CENTER", 0, 0)
    button.Texture:SetTexture("Interface\\Minimap\\POIIcons")
    if button.HighlightTexture then
        button.HighlightTexture:SetWidth(12)
        button.HighlightTexture:SetHeight(12)
        button.HighlightTexture:SetTexture("Interface\\Minimap\\POIIcons");
    end

    button.specialPOIInfo = nil
end

local debugMsgFormat = "Treasure %s (%u):\nxpos %f\nypos %f\ntracking quest %u (%s)\ntreasuremap quest %u (%s)\ndistance %.02f"

local function TreasureMapPOI_OnClick(self, button)
    if not DRTSOptions.debug or button == "RightButton" then
        WorldMapButton_OnClick(WorldMapButton, button)
        return
    end
    local t = alltreasures[self.id]
    local trCheck, tmCheck, _, _, trquest, tmquest, _, _ = GetTreasureCompletion(t)
    local trstate = trquest ~= 0 and (trCheck and "Not completed" or "Completed") or "No quest"
    local tmstate = tmquest ~= 0 and (tmCheck and "Not completed" or "Completed") or "No quest"
    local x, y = UnitPosition("player")
    print(format(debugMsgFormat, t.name, t.id, t.x, t.y, trquest, trstate, tmquest, tmstate, GetDistanceToPoint(x, y, t.x, t.y)))
end

local function TreasureMap_CreatePOI(index)
    local button = CreateFrame("Button", "TreasureMapFramePOI"..index, WorldMapPOIFrame)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnEnter", WorldMapPOI_OnEnter)
    button:SetScript("OnLeave", WorldMapPOI_OnLeave)
    button:SetScript("OnClick", TreasureMapPOI_OnClick)

    button.Texture = button:CreateTexture(button:GetName().."Texture", "BACKGROUND")
    button.HighlightTexture = button:CreateTexture(button:GetName().."HighlightTexture", "HIGHLIGHT");
    button.HighlightTexture:SetBlendMode("ADD");
    button.HighlightTexture:SetAlpha(.4);
    button.HighlightTexture:SetAllPoints(button.Texture);

    TreasureMap_ResetPOI(button)
    return button
end

local function DrawTreasurePOI()
    local worldMapID, isContinent = GetCurrentMapAreaID()
    local mapID = GetAreaMapInfo(worldMapID)
    local showTreasures = (not isContinent) and (worldMapID > 0) and DRTSOptions.enabled

    for k,v in pairs(alltreasures) do
        local treasureMapPOI = _G["TreasureMapFramePOI"..k] or TreasureMap_CreatePOI(k)

        local trCheck, tmCheck, choise1Check, choise2Check, _, tmquest, c1quest, _ = GetTreasureCompletion(v)

        if showTreasures and (TreasureContinentsIds[mapID] == v.continent) and (DRTSOptions.debug or (not DRTSOptions.hidden[v.id] and trCheck and tmCheck and choise1Check and choise2Check)) then
            local x, y, onMap = WorldPosToScreenPos(v.x, v.y)
            if onMap then
                local name
                if DRTSOptions.debug then
                    name = format("%s (%u, %.02f, %.02f)", v.name, v.id, x * 100, y * 100)
                else
                    name = format("%s (%.02f, %.02f)", v.name, x * 100, y * 100)
                end

                local description = v.desc ~= "" and v.desc or format("Treasure: %s!", TreasureQuestsDesc[c1quest] or TreasureQuestsDesc[tmquest] or "Unknown")

                --x = x * WorldMapPOIFrame:GetWidth()
                --y = y * WorldMapPOIFrame:GetHeight()
                --treasureMapPOI:SetPoint("CENTER", "WorldMapPOIFrame", "TOPLEFT", x, -y)
                WorldMapPOIFrame_AnchorPOI(treasureMapPOI, x, y, WorldMap_GetFrameLevelForLandmark(LE_MAP_LANDMARK_TYPE_NORMAL));

                TreasureMap_ResetPOI(treasureMapPOI)

                local x1, x2, y1, y2 = GetPOITextureCoords(197)

                treasureMapPOI.Texture:SetTexCoord(x1, x2, y1, y2)
                treasureMapPOI.HighlightTexture:SetTexCoord(x1, x2, y1, y2);

                treasureMapPOI.id = k
                treasureMapPOI.name = name
                treasureMapPOI.description = description
                treasureMapPOI.mapLinkID = nil
                treasureMapPOI.poiID = v.id
                treasureMapPOI.landmarkType = LE_MAP_LANDMARK_TYPE_NORMAL

                treasureMapPOI:Show()
            else
                treasureMapPOI:Hide()
            end
        else
            treasureMapPOI:Hide()
        end
    end
end

local function MyWorldMapFrame_OnUpdate(self, e)
    --WorldMapFrame_OnUpdate(self, e)
    DrawTreasurePOI()
end

WorldMapFrame:HookScript("OnUpdate", MyWorldMapFrame_OnUpdate)