﻿local kAutoOpen = CreateFrame('Frame')
kAutoOpen:SetScript('OnEvent', function(self, event, ...)
 if not MaoRUISettingDB["Misc"]["kAutoOpen"] then self:UnregisterAllEvents() return end
 self[event](...)
end)

local atBank, atMail, atMerchant, isLooting

local autoOpenItems = {
--	[4632]	 = true, -- Ornate Bronze Lockbox -- Lockpicking
--	[4633]	 = true, -- Heavy Bronze Lockbox -- Lockpicking
--	[4634]	 = true, -- Iron Lockbox -- Lockpicking
--	[4636]	 = true, -- Strong Iron Lockbox -- Lockpicking
--	[4637]	 = true, -- Steel Lockbox -- Lockpicking
--	[4638]	 = true, -- Reinforced Steel Lockbox -- Lockpicking
	[5335]	 = true, -- A Sack of Coins
	[5738]	 = true, -- Covert Ops Pack
--	[5758]	 = true, -- Mithril Lockbox -- Lockpicking
--	[5759]	 = true, -- Thorium Lockbox -- Lockpicking
--	[5760]	 = true, -- Eternium Lockbox -- Lockpicking
	[6307]	 = true, -- Message in a Bottle
	[6351]	 = true, -- Dented Crate
	[6352]	 = true, -- Waterlogged Crate
	[6353]	 = true, -- Small Chest
--	[6354]	 = true, -- Small Locked Chest -- Lockpicking
--	[6355]	 = true, -- Sturdy Locked Chest -- Lockpicking
	[6356]	 = true, -- Battered Chest
	[6357]	 = true, -- Sealed Crate
	[6643]	 = true, -- Bloated Smallfish
	[6645]	 = true, -- Bloated Mud Snapper
	[6647]	 = true, -- Bloated Catfish
	[6715]	 = true, -- Ruined Jumper Cables
	[6755]	 = true, -- A Small Container of Gems
	[6827]	 = true, -- Box of Supplies
	[7190]	 = true, -- Scorched Rocket Boots
--	[7209]	 = true, -- Tazan's Satchel -- Lockpicking
--	[7870]	 = true, -- Thaumaturgy Vessel Lockbox -- Lockpicking
	[8049]	 = true, -- Gnarlpine Necklace
	[8366]	 = true, -- Bloated Trout
	[8484]	 = true, -- Gadgetzan Water Co. Care Package
	[8647]	 = true, -- Egg Crate
	[9265]	 = true, -- Cuergo's Hidden Treasure
	[9276]	 = true, -- Pirate's Footlocker
	[9363]	 = true, -- Sparklematic-Wrapped Box
	[9539]	 = true, -- Box of Rations
	[9540]	 = true, -- Box of Spells
	[9541]	 = true, -- Box of Goodies
	[10456]	 = true, -- A Bulging Coin Purse
	[10479]	 = true, -- Kovic's Trading Satchel
	[10569]	 = true, -- Hoard of the Black Dragonflight
	[10695]	 = true, -- Box of Empty Vials
	[10752]	 = true, -- Emerald Encrusted Chest
	[10773]	 = true, -- Hakkari Urn
	[10834]	 = true, -- Felhound Tracker Kit
	[11024]	 = true, -- Evergreen Herb Casing
	[11107]	 = true, -- A Small Pack
	[11422]	 = true, -- Goblin Engineer's Renewal Gift
	[11423]	 = true, -- Gnome Engineer's Renewal Gift
	[11568]	 = true, -- Torwa's Pouch
	[11617]	 = true, -- Eridan's Supplies
	[11883]	 = true, -- A Dingy Fanny Pack
	[11887]	 = true, -- Cenarion Circle Cache
	[11912]	 = true, -- Package of Empty Ooze Containers
	[11937]	 = true, -- Fat Sack of Coins
	[11938]	 = true, -- Sack of Gems
	[11955]	 = true, -- Bag of Empty Ooze Containers
	[11966]	 = true, -- Small Sack of Coins
--	[12033]	 = true, -- Thaurissan Family Jewels -- Lockpicking
	[12122]	 = true, -- Kum'isha's Junk
	[12339]	 = true, -- Vaelan's Gift
	[12849]	 = true, -- Demon Kissed Sack
	[13874]	 = true, -- Heavy Crate
--	[13875]	 = true, -- Ironbound Locked Chest -- Lockpicking
	[13881]	 = true, -- Bloated Redgill
	[13891]	 = true, -- Bloated Salmon
--	[13918]	 = true, -- Reinforced Locked Chest -- Lockpicking
	[15102]	 = true, -- Un'Goro Tested Sample
	[15103]	 = true, -- Corrupt Tested Sample
	[15699]	 = true, -- Small Brown-Wrapped Package
	[15876]	 = true, -- Nathanos' Chest
	[15902]	 = true, -- A Crazy Grab Bag
--	[16882]	 = true, -- Battered Junkbox -- Lockpicking
--	[16883]	 = true, -- Worn Junkbox -- Lockpicking
--	[16884]	 = true, -- Sturdy Junkbox -- Lockpicking
--	[16885]	 = true, -- Heavy Junkbox -- Lockpicking
	[17685]	 = true, -- Smokywood Pastures Sampler
	[17726]	 = true, -- Smokywood Pastures Special Gift
	[17727]	 = true, -- Smokywood Pastures Gift Pack
	[17962]	 = true, -- Blue Sack of Gems
	[17963]	 = true, -- Green Sack of Gems
	[17964]	 = true, -- Gray Sack of Gems
	[17965]	 = true, -- Yellow Sack of Gems
	[17969]	 = true, -- Red Sack of Gems
	[18804]	 = true, -- Lord Grayson's Satchel
	[19035]	 = true, -- Lard's Special Picnic Basket
	[19150]	 = true, -- Sentinel Basic Care Package
	[19151]	 = true, -- Sentinel Standard Care Package
	[19152]	 = true, -- Sentinel Advanced Care Package
	[19153]	 = true, -- Outrider Advanced Care Package
	[19154]	 = true, -- Outrider Basic Care Package
	[19155]	 = true, -- Outrider Standard Care Package
	[19296]	 = true, -- Greater Darkmoon Prize
	[19297]	 = true, -- Lesser Darkmoon Prize
	[19298]	 = true, -- Minor Darkmoon Prize
	[19422]	 = true, -- Darkmoon Faire Fortune
--	[19425]	 = true, -- Mysterious Lockbox -- Lockpicking
	[20228]	 = true, -- Defiler's Advanced Care Package
	[20229]	 = true, -- Defiler's Basic Care Package
	[20230]	 = true, -- Defiler's Standard Care Package
	[20231]	 = true, -- Arathor Advanced Care Package
	[20233]	 = true, -- Arathor Basic Care Package
	[20236]	 = true, -- Arathor Standard Care Package
	[20469]	 = true, -- Decoded True Believer Clippings
	[20601]	 = true, -- Sack of Spoils
	[20602]	 = true, -- Chest of Spoils
	[20603]	 = true, -- Bag of Spoils
	[20708]	 = true, -- Tightly Sealed Trunk
	[20766]	 = true, -- Slimy Bag
	[20767]	 = true, -- Scum Covered Bag
	[20768]	 = true, -- Oozing Bag
	[20805]	 = true, -- Followup Logistics Assignment
	[20808]	 = true, -- Combat Assignment
	[20809]	 = true, -- Tactical Assignment
	[21042]	 = true, -- Narain's Special Kit
	[21113]	 = true, -- Watertight Trunk
	[21131]	 = true, -- Followup Combat Assignment
	[21132]	 = true, -- Logistics Assignment
	[21133]	 = true, -- Followup Tactical Assignment
	[21150]	 = true, -- Iron Bound Trunk
	[21156]	 = true, -- Scarab Bag
	[21164]	 = true, -- Bloated Rockscale Cod
	[21191]	 = true, -- Carefully Wrapped Present
	[21216]	 = true, -- Smokywood Pastures Extra-Special Gift
	[21228]	 = true, -- Mithril Bound Trunk
	[21266]	 = true, -- Logistics Assignment
	[21270]	 = true, -- Gently Shaken Gift
	[21271]	 = true, -- Gently Shaken Gift
	[21310]	 = true, -- Gaily Wrapped Present
	[21315]	 = true, -- Smokywood Satchel
	[21327]	 = true, -- Ticking Present
	[21363]	 = true, -- Festive Gift
	[21386]	 = true, -- Followup Logistics Assignment
	[21509]	 = true, -- Ahn'Qiraj War Effort Supplies
	[21510]	 = true, -- Ahn'Qiraj War Effort Supplies
	[21511]	 = true, -- Ahn'Qiraj War Effort Supplies
	[21512]	 = true, -- Ahn'Qiraj War Effort Supplies
	[21513]	 = true, -- Ahn'Qiraj War Effort Supplies
	[21528]	 = true, -- Colossal Bag of Loot
	[21640]	 = true, -- Lunar Festival Fireworks Pack
--	[21740]	 = true, -- Small Rocket Recipes -- Engineer only
--	[21741]	 = true, -- Cluster Rocket Recipes -- Engineer only
--	[21742]	 = true, -- Large Rocket Recipes -- Engineer only
--	[21743]	 = true, -- Large Cluster Rocket Recipes -- Engineer only
	[21746]	 = true, -- Lucky Red Envelope
	[21812]	 = true, -- Box of Chocolates
	[21975]	 = true, -- Pledge of Adoration: Stormwind
	[21979]	 = true, -- Gift of Adoration: Darnassus
	[21980]	 = true, -- Gift of Adoration: Ironforge
	[21981]	 = true, -- Gift of Adoration: Stormwind
	[22137]	 = true, -- Ysida's Satchel
	[22154]	 = true, -- Pledge of Adoration: Ironforge
	[22155]	 = true, -- Pledge of Adoration: Darnassus
	[22156]	 = true, -- Pledge of Adoration: Orgrimmar
	[22157]	 = true, -- Pledge of Adoration: Undercity
	[22158]	 = true, -- Pledge of Adoration: Thunder Bluff
	[22159]	 = true, -- Pledge of Friendship: Darnassus
	[22160]	 = true, -- Pledge of Friendship: Ironforge
	[22161]	 = true, -- Pledge of Friendship: Orgrimmar
	[22162]	 = true, -- Pledge of Friendship: Thunder Bluff
	[22163]	 = true, -- Pledge of Friendship: Undercity
	[22164]	 = true, -- Gift of Adoration: Orgrimmar
	[22165]	 = true, -- Gift of Adoration: Thunder Bluff
	[22166]	 = true, -- Gift of Adoration: Undercity
	[22167]	 = true, -- Gift of Friendship: Darnassus
	[22168]	 = true, -- Gift of Friendship: Ironforge
	[22169]	 = true, -- Gift of Friendship: Orgrimmar
	[22170]	 = true, -- Gift of Friendship: Stormwind
	[22171]	 = true, -- Gift of Friendship: Thunder Bluff
	[22172]	 = true, -- Gift of Friendship: Undercity
	[22178]	 = true, -- Pledge of Friendship: Stormwind
	[22320]	 = true, -- Mux's Quality Goods
	[22568]	 = true, -- Sealed Craftsman's Writ
	[22648]	 = true, -- Hive'Ashi Dossier
	[22649]	 = true, -- Hive'Regal Dossier
	[22650]	 = true, -- Hive'Zora Dossier
	[22746]	 = true, -- Buccaneer's Uniform
	[23022]	 = true, -- Curmudgeon's Payoff
	[23846]	 = true, -- Nolkai's Box
	[23921]	 = true, -- Bulging Sack of Silver
	[24336]	 = true, -- Fireproof Satchel
	[24402]	 = true, -- Package of Identified Plants
	[25419]	 = true, -- Unmarked Bag of Gems
	[25422]	 = true, -- Bulging Sack of Gems
	[25423]	 = true, -- Bag of Premium Gems
	[25424]	 = true, -- Gem-Stuffed Envelope
	[27446]	 = true, -- Mr. Pinchy's Gift
	[27481]	 = true, -- Heavy Supply Crate
	[27511]	 = true, -- Inscribed Scrollcase
	[27513]	 = true, -- Curious Crate
--	[29569]	 = true, -- Strong Junkbox -- Lockpicking
	[30260]	 = true, -- Voren'thal's Package
	[30320]	 = true, -- Bundle of Nether Spikes
	[30650]	 = true, -- Dertrok's Wand Case
	[31408]	 = true, -- Offering of the Sha'tar
	[31522]	 = true, -- Primal Mooncloth Supplies
	[31800]	 = true, -- Outcast's Cache
--	[31952]	 = true, -- Khorium Lockbox -- Lockpicking
	[31955]	 = true, -- Arelion's Knapsack
	[32064]	 = true, -- Protectorate Treasure Cache
	[32462]	 = true, -- Morthis' Materials
	[32624]	 = true, -- Large Iron Metamorphosis Geode 
	[32625]	 = true, -- Small Iron Metamorphosis Geode
	[32626]	 = true, -- Large Copper Metamorphosis Geode
	[32627]	 = true, -- Small Copper Metamorphosis Geode
	[32628]	 = true, -- Large Silver Metamorphosis Geode
	[32629]	 = true, -- Large Gold Metamorphosis Geode
	[32630]	 = true, -- Small Gold Metamorphosis Geode
	[32631]	 = true, -- Small Silver Metamorphosis Geode
	[32724]	 = true, -- Sludge-Covered Object
	[32777]	 = true, -- Kronk's Grab Bag
	[32835]	 = true, -- Ogri'la Care Package
	[33045]	 = true, -- Renn's Supplies
	[33844]	 = true, -- Barrel of Fish
	[33857]	 = true, -- Crate of Meat
	[33926]	 = true, -- Sealed Scroll Case
	[33928]	 = true, -- Hollowed Bone Decanter
	[34077]	 = true, -- Crudely Wrapped Gift
	[34119]	 = true, -- Black Conrad's Treasure
	[34426]	 = true, -- Winter Veil Gift
	[34583]	 = true, -- Aldor Supplies Package
	[34584]	 = true, -- Scryer Supplies Package
	[34585]	 = true, -- Scryer Supplies Package
	[34587]	 = true, -- Aldor Supplies Package
	[34592]	 = true, -- Aldor Supplies Package
	[34593]	 = true, -- Scryer Supplies Package
	[34594]	 = true, -- Scryer Supplies Package
	[34595]	 = true, -- Aldor Supplies Package
	[34846]	 = true, -- Black Sack of Gems
	[34863]	 = true, -- Bag of Fishing Treasures
	[34871]	 = true, -- Crafty's Sack
	[35232]	 = true, -- Shattered Sun Supplies
	[35286]	 = true, -- Bloated Giant Sunfish
	[35313]	 = true, -- Bloated Barbed Gill Trout
	[35348]	 = true, -- Bag of Fishing Treasures
	[35512]	 = true, -- Pocket Full of Snow
	[35792]	 = true, -- Mage Hunter Personal Effects
	[35945]	 = true, -- Brilliant Glass
	[37168]	 = true, -- Mysterious Tarot
	[37586]	 = true, -- Handful of Treats
	[39418]	 = true, -- Ornately Jeweled Box
	[39883]	 = true, -- Cracked Egg
	[41426]	 = true, -- Magically Wrapped Gift
	[41888]	 = true, -- Small Velvet Bag
	[43346]	 = true, -- Large Satchel of Spoils
	[43347]	 = true, -- Satchel of Spoils
	[43504]	 = true, -- Winter Veil Gift
	[43556]	 = true, -- Patroller's Pack
--	[43575]	 = true, -- Reinforced Junkbox -- Lockpicking
--	[43622]	 = true, -- Froststeel Lockbox -- Lockpicking
--	[43624]	 = true, -- Titanium Lockbox -- Lockpicking
	[44113]	 = true, -- Small Spice Bag
	[44142]	 = true, -- Strange Tarot
	[44161]	 = true, -- Arcane Tarot
	[44163]	 = true, -- Shadowy Tarot
	[44475]	 = true, -- Reinforced Crate
	[44663]	 = true, -- Abandoned Adventurer's Satchel
	[44700]	 = true, -- Brooding Darkwater Clam
	[44718]	 = true, -- Ripe Disgusting Jar
	[44751]	 = true, -- Hyldnir Spoils
	[44943]	 = true, -- Icy Prism
	[44951]	 = true, -- Box of Bombs
	[45072]	 = true, -- Brightly Colored Egg
	[45328]	 = true, -- Bloated Slippery Eel
	[45724]	 = true, -- Champion's Purse
	[45875]	 = true, -- Sack of Ulduar Spoils
	[45878]	 = true, -- Large Sack of Ulduar Spoils
--	[45986]	 = true, -- Tiny Titanium Lockbox -- Lockpicking
	[46007]	 = true, -- Bag of Fishing Treasures
--	[46110]	 = true, -- Alchemist's Cache -- Alchemist only
	[46740]	 = true, -- Winter Veil Gift
	[46809]	 = true, -- Bountiful Cookbook
	[46810]	 = true, -- Bountiful Cookbook
	[46812]	 = true, -- Northrend Mystery Gem Pouch
	[49294]	 = true, -- Ashen Sack of Gems
	[49369]	 = true, -- Red Blizzcon Bag
	[49631]	 = true, -- Standard Apothecary Serving Kit
	[49909]	 = true, -- Box of Chocolates
	[49926]	 = true, -- Brazie's Black Book of Secrets
	[50160]	 = true, -- Lovely Dress Box
	[50161]	 = true, -- Dinner Suit Box
	[50238]	 = true, -- Cracked Un'Goro Coconut
	[50301]	 = true, -- Landro's Pet Box
	[50409]	 = true, -- Spark's Fossil Finding Kit
	[51316]	 = true, -- Unsealed Chest
	[51999]	 = true, -- Satchel of Helpful Goods
	[52000]	 = true, -- Satchel of Helpful Goods
	[52001]	 = true, -- Satchel of Helpful Goods
	[52002]	 = true, -- Satchel of Helpful Goods
	[52003]	 = true, -- Satchel of Helpful Goods
	[52004]	 = true, -- Satchel of Helpful Goods
	[52005]	 = true, -- Satchel of Helpful Goods
	[52006]	 = true, -- Sack of Frosty Treasures
	[52274]	 = true, -- Earthen Ring Supplies
	[52304]	 = true, -- Fire Prism
	[52344]	 = true, -- Earthen Ring Supplies
	[52676]	 = true, -- Cache of the Ley-Guardian
	[54516]	 = true, -- Loot-Filled Pumpkin
	[54535]	 = true, -- Keg-Shaped Treasure Chest
	[54536]	 = true, -- Satchel of Chilled Goods
	[54537]	 = true, -- Heart-Shaped Box
	[57540]	 = true, -- Coldridge Mountaineer's Pouch
	[60681]	 = true, -- Cannary's Cache
	[61387]	 = true, -- Hidden Stash
	[62062]	 = true, -- Bulging Sack of Gold
--	[63349]	 = true, -- Flame-Scarred Junkbox -- Lockpicking
	[64491]	 = true, -- Royal Reward
	[64657]	 = true, -- Canopic Jar
	[65513]	 = true, -- Crate of Tasty Meat
	[66943]	 = true, -- Treasures from Grim Batol
	[67248]	 = true, -- Satchel of Helpful Goods
	[67250]	 = true, -- Satchel of Helpful Goods
	[67414]	 = true, -- Bag of Shiny Things
	[67443]	 = true, -- Winter Veil Gift
	[67495]	 = true, -- Strange Bloated Stomach
	[67539]	 = true, -- Tiny Treasure Chest
	[67597]	 = true, -- Sealed Crate
	[68384]	 = true, -- Moonkin Egg
	[68598]	 = true, -- Very Fat Sack of Coins
	[68689]	 = true, -- Imported Supplies
--	[68729]	 = true, -- Elementium Lockbox -- Lockpicking
	[68795]	 = true, -- Stendel's Bane
	[68813]	 = true, -- Satchel of Freshly-Picked Herbs
	[69817]	 = true, -- Hive Queen's Honeycomb
	[69818]	 = true, -- Giant Sack
	[69822]	 = true, -- Master Chef's Groceries
	[69823]	 = true, -- Gub's Catch
	[69886]	 = true, -- Bag of Coins
	[69903]	 = true, -- Satchel of Exotic Mysteries
	[69999]	 = true, -- Moat Monster Feeding Kit
	[70719]	 = true, -- Water-Filled Gills
	[70931]	 = true, -- Scrooge's Payoff
	[70938]	 = true, -- Winter Veil Gift
	[71631]	 = true, -- Zen'Vorka's Cache
	[72201]	 = true, -- Plump Intestines
	[73792]	 = true, -- Stolen Present
	[77501]	 = true, -- Blue Blizzcon Bag
	[77956]	 = true, -- Spectral Mount Crate
	[78897]	 = true, -- Pouch o' Tokens
	[78898]	 = true, -- Sack o' Tokens
	[78899]	 = true, -- Pouch o' Tokens
	[78900]	 = true, -- Pouch o' Tokens
	[78901]	 = true, -- Pouch o' Tokens
	[78902]	 = true, -- Pouch o' Tokens
	[78903]	 = true, -- Pouch o' Tokens
	[78904]	 = true, -- Pouch o' Tokens
	[78905]	 = true, -- Sack o' Tokens
	[78906]	 = true, -- Sack o' Tokens
	[78907]	 = true, -- Sack o' Tokens
	[78908]	 = true, -- Sack o' Tokens
	[78909]	 = true, -- Sack o' Tokens
	[78910]	 = true, -- Sack o' Tokens
	[78930]	 = true, -- Sealed Crate
	[85223]	 = true, -- Enigma Seed Pack
	[85224]	 = true, -- Basic Seed Pack
	[85225]	 = true, -- Basic Seed Pack
	[85226]	 = true, -- Basic Seed Pack
	[85227]	 = true, -- Special Seed Pack
	[85271]	 = true, -- Secret Stash
	[85272]	 = true, -- Tree Seed Pack
	[85274]	 = true, -- Gro-Pack
	[85275]	 = true, -- Chee Chee's Goodie Bag
	[85276]	 = true, -- Celebration Gift
	[85277]	 = true, -- Nicely Packed Lunch
	[85497]	 = true, -- Chirping Package
	[85498]	 = true, -- Songbell Seed Pack
	[86428]	 = true, -- Old Man Thistle's Treasure
	[86595]	 = true, -- Bag of Helpful Things
	[86623]	 = true, -- Blingtron 004000 Gift Package
	[87217]	 = true, -- Small Bag of Goods
	[87218]	 = true, -- Big Bag of Arms
	[87219]	 = true, -- Huge Bag of Herbs
	[87220]	 = true, -- Big Bag of Mysteries
	[87221]	 = true, -- Big Bag of Jewels
	[87222]	 = true, -- Big Bag of Linens
	[87223]	 = true, -- Big Bag of Skins
	[87224]	 = true, -- Big Bag of Wonders
	[87225]	 = true, -- Big Bag of Food
	[87391]	 = true, -- Plundered Treasure
	[87533]	 = true, -- Crate of Dwarven Archaeology Fragments
	[87534]	 = true, -- Crate of Draenei Archaeology Fragments
	[87535]	 = true, -- Crate of Fossil Archaeology Fragments
	[87536]	 = true, -- Crate of Night Elf Archaeology Fragments
	[87537]	 = true, -- Crate of Nerubian Archaeology Fragments
	[87538]	 = true, -- Crate of Orc Archaeology Fragments
	[87539]	 = true, -- Crate of Tol'vir Archaeology Fragments
	[87540]	 = true, -- Crate of Troll Archaeology Fragments
	[87541]	 = true, -- Crate of Vrykul Archaeology Fragments
	[87701]	 = true, -- Sack of Raw Tiger Steaks
	[87702]	 = true, -- Sack of Mushan Ribs
	[87703]	 = true, -- Sack of Raw Turtle Meat
	[87704]	 = true, -- Sack of Raw Crab Meat
	[87705]	 = true, -- Sack of Wildfowl Breasts
	[87706]	 = true, -- Sack of Green Cabbages
	[87707]	 = true, -- Sack of Juicycrunch Carrots
	[87708]	 = true, -- Sack of Mogu Pumpkins
	[87709]	 = true, -- Sack of Scallions
	[87710]	 = true, -- Sack of Red Blossom Leeks
	[87712]	 = true, -- Sack of Witchberries
	[87713]	 = true, -- Sack of Jade Squash
	[87714]	 = true, -- Sack of Striped Melons
	[87715]	 = true, -- Sack of Pink Turnips
	[87716]	 = true, -- Sack of White Turnips
	[87721]	 = true, -- Sack of Jade Lungfish
	[87722]	 = true, -- Sack of Giant Mantis Shrimp
	[87723]	 = true, -- Sack of Emperor Salmon
	[87724]	 = true, -- Sack of Redbelly Mandarin
	[87725]	 = true, -- Sack of Tiger Gourami
	[87726]	 = true, -- Sack of Jewel Danio
	[87727]	 = true, -- Sack of Reef Octopus
	[87728]	 = true, -- Sack of Krasarang Paddlefish
	[87729]	 = true, -- Sack of Golden Carp
	[87730]	 = true, -- Sack of Crocolisk Belly
--	[88165]	 = true, -- Vine-Cracked Junkbox -- Lockpicking
	[88496]	 = true, -- Sealed Crate
--	[88567]	 = true, -- Ghost Iron Lockbox -- Lockpicking
	[89427]	 = true, -- Ancient Mogu Treasure
	[89428]	 = true, -- Ancient Mogu Treasure
	[89607]	 = true, -- Crate of Leather
	[89608]	 = true, -- Crate of Ore
	[89609]	 = true, -- Crate of Dust
	[89610]	 = true, -- Pandaria Herbs
	[89613]	 = true, -- Cache of Treasures
	[89804]	 = true, -- Cache of Mogu Riches
	[89807]	 = true, -- Amber Encased Treasure Pouch
	[89808]	 = true, -- Dividends of the Everlasting Spring
	[89810]	 = true, -- Bounty of a Sundered Land
	[89856]	 = true, -- Amber Encased Treasure Pouch
	[89857]	 = true, -- Dividends of the Everlasting Spring
	[89858]	 = true, -- Cache of Mogu Riches
	[89991]	 = true, -- Pandaria Fireworks
	[90041]	 = true, -- Spoils of Theramore
	[90155]	 = true, -- Golden Chest of the Golden King
	[90156]	 = true, -- Golden Chest of the Betrayer
	[90157]	 = true, -- Golden Chest of Windfury
	[90158]	 = true, -- Golden Chest of the Elemental Triad
	[90159]	 = true, -- Golden Chest of the Silent Assassin
	[90160]	 = true, -- Golden Chest of the Light
	[90161]	 = true, -- Golden Chest of the Holy Warrior
	[90162]	 = true, -- Golden Chest of the Regal Lord
	[90163]	 = true, -- Golden Chest of the Howling Beast
	[90164]	 = true, -- Golden Chest of the Cycle
	[90165]	 = true, -- Golden Chest of the Lich Lord
	[90395]	 = true, -- Facets of Research
	[90397]	 = true, -- Facets of Research
	[90398]	 = true, -- Facets of Research
	[90399]	 = true, -- Facets of Research
	[90400]	 = true, -- Facets of Research
	[90401]	 = true, -- Facets of Research
	[90406]	 = true, -- Facets of Research
	[90537]	 = true, -- Winner's Reward
	[90621]	 = true, -- Hero's Purse
	[90622]	 = true, -- Hero's Purse
	[90623]	 = true, -- Hero's Purse
	[90624]	 = true, -- Hero's Purse
	[90625]	 = true, -- Treasures of the Vale
	[90626]	 = true, -- Hero's Purse
	[90627]	 = true, -- Hero's Purse
	[90628]	 = true, -- Hero's Purse
	[90629]	 = true, -- Hero's Purse
	[90630]	 = true, -- Hero's Purse
	[90631]	 = true, -- Hero's Purse
	[90632]	 = true, -- Hero's Purse
	[90633]	 = true, -- Hero's Purse
	[90634]	 = true, -- Hero's Purse
	[90635]	 = true, -- Hero's Purse
	[90735]	 = true, -- Goodies from Nomi
	[90818]	 = true, -- Misty Satchel of Exotic Mysteries
	[90839]	 = true, -- Cache of Sha-Touched Gold
	[90840]	 = true, -- Marauder's Gleaming Sack of Gold
	[90892]	 = true, -- Winter Veil Gift
	[91086]	 = true, -- Darkmoon Pet Supplies
	[92718]	 = true, -- Brawler's Purse
	[92744]	 = true, -- Heavy Sack of Gold
	[92788]	 = true, -- Ride Ticket Book
	[92789]	 = true, -- Ride Ticket Book
	[92790]	 = true, -- Ride Ticket Book
	[92791]	 = true, -- Ride Ticket Book
	[92792]	 = true, -- Ride Ticket Book
	[92793]	 = true, -- Ride Ticket Book
	[92794]	 = true, -- Ride Ticket Book
	[92813]	 = true, -- Greater Cache of Treasures
	[92960]	 = true, -- Silkworm Cocoon
	[93198]	 = true, -- Tome of the Tiger
	[93199]	 = true, -- Tome of the Crane
	[93200]	 = true, -- Tome of the Serpent
	[93360]	 = true, -- Serpent's Cache
	[93626]	 = true, -- Stolen Present
	[93724]	 = true, -- Darkmoon Game Prize
	[94158]	 = true, -- Big Bag of Zandalari Supplies
	[94159]	 = true, -- Small Bag of Zandalari Supplies
	[94219]	 = true, -- Arcane Trove
	[94220]	 = true, -- Sunreaver Bounty
	[94296]	 = true, -- Cracked Primal Egg
	[94553]	 = true, -- Notes on Lightning Steel
	[94566]	 = true, -- Fortuitous Coffer
	[95343]	 = true, -- Treasures of the Thunder King
	[95469]	 = true, -- Serpent's Heart
	[95601]	 = true, -- Shiny Pile of Refuse
	[95602]	 = true, -- Stormtouched Cache
	[95617]	 = true, -- Dividends of the Everlasting Spring
	[95618]	 = true, -- Cache of Mogu Riches
	[95619]	 = true, -- Amber Encased Treasure Pouch
	[97153]	 = true, -- Spoils of the Thunder King
	[97565]	 = true, -- Unclaimed Black Market Container
	[97948]	 = true, -- Surplus Supplies
	[97949]	 = true, -- Surplus Supplies
	[97950]	 = true, -- Surplus Supplies
	[97951]	 = true, -- Surplus Supplies
	[97952]	 = true, -- Surplus Supplies
	[97953]	 = true, -- Surplus Supplies
	[97954]	 = true, -- Surplus Supplies
	[97955]	 = true, -- Surplus Supplies
	[97956]	 = true, -- Surplus Supplies
	[97957]	 = true, -- Surplus Supplies
	[98096]	 = true, -- Large Sack of Coins
	[98097]	 = true, -- Huge Sack of Coins
	[98098]	 = true, -- Bulging Sack of Coins
	[98099]	 = true, -- Giant Sack of Coins
	[98100]	 = true, -- Humongous Sack of Coins
	[98101]	 = true, -- Enormous Sack of Coins
	[98102]	 = true, -- Overflowing Sack of Coins
	[98103]	 = true, -- Gigantic Sack of Coins
	[98133]	 = true, -- Greater Cache of Treasures
	[98560]	 = true, -- Arcane Trove
	[98562]	 = true, -- Sunreaver Bounty
	[102137]	 = true, -- Unclaimed Black Market Container
	[103624]	 = true, -- Treasures of the Vale
	[103632]	 = true, -- Lucky Box of Greatness
	[104034]	 = true, -- Purse of Timeless Coins
	[104035]	 = true, -- Giant Purse of Timeless Coins
	[104112]	 = true, -- Curious Ticking Parcel
	[104114]	 = true, -- Curious Ticking Parcel
	[104198]	 = true, -- Mantid Artifact Hunter's Kit
	[104258]	 = true, -- Glowing Green Ash
	[104260]	 = true, -- Satchel of Savage Mysteries
	[104261]	 = true, -- Glowing Blue Ash
	[104263]	 = true, -- Glinting Pile of Stone
	[104268]	 = true, -- Pristine Stalker Hide
	[104271]	 = true, -- Coalesced Turmoil
	[104272]	 = true, -- Celestial Treasure Box
	[104273]	 = true, -- Flame-Scarred Cache of Offerings
	[104275]	 = true, -- Twisted Treasures of the Vale
	[104292]	 = true, -- Partially-Digested Meal
	[104296]	 = true, -- Ordon Ceremonial Robes
	[104319]	 = true, -- Winter Veil Gift
	[105713]	 = true, -- Twisted Treasures of the Vale
	[105714]	 = true, -- Coalesced Turmoil
	[105751]	 = true, -- Kor'kron Shaman's Treasure
	[106130]	 = true, -- Big Bag of Herbs
--	[106895]	 = true, -- Iron-Bound Junkbox -- Lockpicking
	[107077]	 = true, -- Bag of Transformers
	[107270]	 = true, -- Bound Traveler's Scroll
	[107271]	 = true, -- Frozen Envelope
	[108738]	 = true, -- Giant Draenor Clam
	[108740]	 = true, -- Stolen Weapons
	[110278]	 = true, -- Engorged Stomach
	[110592]	 = true, -- Unclaimed Black Market Container
	[110678]	 = true, -- Darkmoon Ticket Fanny Pack
	[111598]	 = true, -- Gold Strongbox
	[111599]	 = true, -- Silver Strongbox
	[111600]	 = true, -- Bronze Strongbox
	[112108]	 = true, -- Cracked Egg
	[112623]	 = true, -- Pack of Fishing Supplies
	[113258]	 = true, -- Blingtron 005000 Gift Package

	[114028]	 = true, -- Small Pouch of Coins
	[114634]	 = true, -- Icy Satchel of Helpful Goods
	[114641]	 = true, -- Icy Satchel of Helpful Goods
	[114648]	 = true, -- Scorched Satchel of Helpful Goods
	[114655]	 = true, -- Scorched Satchel of Helpful Goods
	[114662]	 = true, -- Tranquil Satchel of Helpful Goods
	[114669]	 = true, -- Tranquil Satchel of Helpful Goods
	[114970]	 = true, -- Small Pouch of Coins
	[116062]	 = true, -- Greater Darkmoon Pet Supplies
	[116111]	 = true, -- Small Pouch of Coins
	[116129]	 = true, -- Dessicated Orc's Coin Pouch

	[116202]	 = true, -- Pet Care Package
	[116376]	 = true, -- Small Pouch of Coins
	[116404]	 = true, -- Pilgrim's Bounty
	[116761]	 = true, -- Winter Veil Gift
	[116762]	 = true, -- Stolen Present
	[116764]	 = true, -- Small Pouch of Coins
--	[116920]	 = true, -- True Steel Lockbox -- Lockpicking
	[116980]	 = true, -- Invader's Forgotten Treasure
	[117386]	 = true, -- Crate of Pandaren Archaeology Fragments
	[117387]	 = true, -- Crate of Mogu Archaeology Fragments
	[117388]	 = true, -- Crate of Mantid Archaeology Fragments
	[117392]	 = true, -- Loot-Filled Pumpkin
	[117393]	 = true, -- Keg-Shaped Treasure Chest
	[117394]	 = true, -- Satchel of Chilled Goods

	[117414]	 = true, -- Stormwind Guard Armor Package
	[118065]	 = true, -- Gleaming Ashmaul Strongbox
	[118066]	 = true, -- Ashmaul Strongbox
	[118093]	 = true, -- Dented Ashmaul Strongbox
	[118094]	 = true, -- Dented Ashmaul Strongbox
--	[118193]	 = true, -- Mysterious Shining Lockbox -- Lockpicking
	[118529]	 = true, -- Cache of Highmaul Treasures
	[118530]	 = true, -- Cache of Highmaul Treasures
	[118531]	 = true, -- Cache of Highmaul Treasures
	[118706]	 = true, -- Cracked Goren Egg
	[118759]	 = true, -- Alchemy Experiment
	[118924]	 = true, -- Cache of Arms
	[118925]	 = true, -- Plundered Booty
	[118926]	 = true, -- Huge Pile of Skins
	[118927]	 = true, -- Maximillian's Laundry
	[118928]	 = true, -- Faintly-Sparkling Cache
	[118929]	 = true, -- Sack of Mined Ore
	[118930]	 = true, -- Bag of Everbloom Herbs
	[118931]	 = true, -- Leonid's Bag of Supplies
--	[119000]	 = true, -- Highmaul Lockbox -- Lockpicking
	[119032]	 = true, -- Challenger's Strongbox
	[119036]	 = true, -- Box of Storied Treasures
	[119037]	 = true, -- Supply of Storied Rarities
	[119040]	 = true, -- Cache of Mingled Treasures
	[119041]	 = true, -- Strongbox of Mysterious Treasures
	[119042]	 = true, -- Crate of Valuable Treasures
	[119043]	 = true, -- Trove of Smoldering Treasures
	[119188]	 = true, -- Unclaimed Payment
	[119189]	 = true, -- Unclaimed Payment
	[119190]	 = true, -- Unclaimed Payment
	[119191]	 = true, -- Jewelcrafting Payment
	[119195]	 = true, -- Jewelcrafting Payment
	[119196]	 = true, -- Jewelcrafting Payment
	[119197]	 = true, -- Jewelcrafting Payment
	[119198]	 = true, -- Jewelcrafting Payment
	[119199]	 = true, -- Jewelcrafting Payment
	[119200]	 = true, -- Jewelcrafting Payment
	[119201]	 = true, -- Jewelcrafting Payment
	[119330]	 = true, -- Steel Strongbox
	[120142]	 = true, -- Coliseum Champion's Spoils
	[120146]	 = true, -- Smuggled Sack of Gold
	[120147]	 = true, -- Bloody Gold Purse
	[120151]	 = true, -- Gleaming Ashmaul Strongbox
	[120170]	 = true, -- Partially-Digested Bag
	[120184]	 = true, -- Ashmaul Strongbox
	[120312]	 = true, -- Bulging Sack of Coins
	[120319]	 = true, -- Invader's Damaged Cache
	[120320]	 = true, -- Invader's Abandoned Sack
	[120322]	 = true, -- Klinking Stacked Card Deck
	[120323]	 = true, -- Bulging Stacked Card Deck
	[120324]	 = true, -- Bursting Stacked Card Deck
	[120325]	 = true, -- Overflowing Stacked Card Deck
	[120334]	 = true, -- Satchel of Cosmic Mysteries
	[120353]	 = true, -- Steel Strongbox
	[120354]	 = true, -- Gold Strongbox
	[120355]	 = true, -- Silver Strongbox
	[120356]	 = true, -- Bronze Strongbox
	[122163]	 = true, -- Routed Invader's Crate of Spoils
	[122191]	 = true, -- Bloody Stack of Invitations
	[122242]	 = true, -- Relic Acquisition Compensatory Package
	[122478]	 = true, -- Scouting Report: Frostfire Ridge
	[122479]	 = true, -- Scouting Report: Shadowmoon Valley
	[122480]	 = true, -- Scouting Report: Gorgrond
	[122481]	 = true, -- Scouting Report: Talador
	[122482]	 = true, -- Scouting Report: Spires of Arak
	[122483]	 = true, -- Scouting Report: Nagrand
	[122484]	 = true, -- Blackrock Foundry Spoils
	[122485]	 = true, -- Blackrock Foundry Spoils
	[122486]	 = true, -- Blackrock Foundry Spoils
	[122607]	 = true, -- Savage Satchel of Cooperation
	[122613]	 = true, -- Stash of Dusty Music Rolls
	[122718]	 = true, -- Clinking Present
	[123857]	 = true, -- Runic Pouch
	[123858]	 = true, -- Follower Retraining Scroll Case
	[123975]	 = true, -- Greater Bounty Spoils
}

local autoOpenItemsSalvage = {
	[118473]	 = true, -- Small Sack of Salvaged Goods
	[114116]	 = true, -- Bag of Salvaged Goods
	[114119]	 = true, -- Crate of Salvage
	[114120]	 = true, -- Big Crate of Salvage
}

function kAutoOpen:Register(event, func)
	self:RegisterEvent(event)
	self[event] = function(...)
		func(...)
	end
end

kAutoOpen:Register('BANKFRAME_OPENED', function()
	atBank = true
end)

kAutoOpen:Register('BANKFRAME_CLOSED', function()
	atBank = false
end)

kAutoOpen:Register('GUILDBANKFRAME_OPENED', function()
	atBank = true
end)

kAutoOpen:Register('GUILDBANKFRAME_CLOSED', function()
	atBank = false
end)

kAutoOpen:Register('MAIL_SHOW', function()
	atMail = true
end)

kAutoOpen:Register('MAIL_CLOSED', function()
	atMail = false
end)

kAutoOpen:Register('MERCHANT_SHOW', function()
	atMerchant = true
end)

kAutoOpen:Register('MERCHANT_CLOSED', function()
	atMerchant = false
end)

kAutoOpen:Register('BAG_UPDATE_DELAYED', function(bag)
	if(atBank or atMail or atMerchant) then return end
	for bag = 0, 4 do
		for slot = 0, GetContainerNumSlots(bag) do
			local id = GetContainerItemID(bag, slot)
			if id and autoOpenItems[id] then
				DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[Auto Open]: " .. GetContainerItemLink(bag, slot))
				UseContainerItem(bag, slot)
				return
			end
		end
	end
end)

-------------------------------------------------------------------------------------AutoConfirmRoll
local AutoConfirmRollRemap = {
	CONFIRM_LOOT_ROLL = "CONFIRM_ROLL",
	CONFIRM_DISENCHANT_ROLL = "CONFIRM_ROLL",
	LOOT_BIND_CONFIRM = "LOOT_BIND_CONFIRM",
}
local AutoConfirmRoll = CreateFrame("Frame")
function AutoConfirmRoll:OnEvent(event, ...)
 if not MaoRUISettingDB["Misc"]["AutoConfirmRoll"] then self:UnregisterAllEvents() return end
	self[AutoConfirmRollRemap[event]](self, ...)
end
for k in pairs(AutoConfirmRollRemap) do AutoConfirmRoll:RegisterEvent(k) end
AutoConfirmRoll:SetScript("OnEvent", AutoConfirmRoll.OnEvent)
function AutoConfirmRoll:CONFIRM_ROLL(id, lootType)
	ConfirmLootRoll(id, lootType)
	StaticPopup_Hide("CONFIRM_LOOT_ROLL")
end

local AutoConfirmRollCheckList = {}
function AutoConfirmRoll:OnUpdate(elapsed)
	for slot in pairs(AutoConfirmRollCheckList) do
		LootSlot(slot)
		ConfirmLootSlot(slot)
	end
	wipe(AutoConfirmRollCheckList)
	StaticPopup_Hide("LOOT_BIND")
	self:SetScript("OnUpdate", nil)
end
function AutoConfirmRoll:LOOT_BIND_CONFIRM(slot)
	if not AutoConfirmRollCheckList[slot] then
		AutoConfirmRollCheckList[slot] = true
		StaticPopup_Hide("LOOT_BIND")
		self:SetScript("OnUpdate", self.OnUpdate)
	end
end