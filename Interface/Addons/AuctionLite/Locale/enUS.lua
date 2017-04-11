local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

local L = LibStub("AceLocale-3.0"):NewLocale("AuctionLite", "enUS", true, debug);

L["Accept"] = true
L["Add a new item to a favorites list by entering the name here."] = true
L["Add an Item"] = true
L["Advanced"] = true
L["Always"] = true
L["Amount to multiply by vendor price to get default sell price."] = true
L["Approve"] = true
L["Auction"] = true
L["Auction creation is already in progress."] = true
L["Auction house data cleared."] = true
L["AuctionLite"] = true
L["AuctionLite Buy"] = true
L["AuctionLite - Buy"] = true
L["AuctionLite Sell"] = true
L["AuctionLite - Sell"] = true
L["AuctionLite v%s loaded!"] = true
L["Auction scan skipped (control key is down)"] = true
L["Batch %d: %d at %s"] = true
L["Below AH"] = true
L["Bid cost for %d:"] = true
L["Bid on %dx %s (%d |4listing:listings; at %s)."] = true
L["Bid Per Item"] = true
L["Bid Price"] = true
L["Bid Total"] = true
L["Bid Undercut"] = true
L["Bid Undercut (Fixed)"] = true
L["Bought %dx %s (%d |4listing:listings; at %s)."] = true
L["Buyout cannot be less than starting bid."] = true
L["Buyout cost for %d:"] = true
L["Buyout Per Item"] = true
L["Buyout Price"] = true
L["Buyout Total"] = true
L["Buyout Undercut"] = true
L["Buyout Undercut (Fixed)"] = true
L["Buy Tab"] = true
L["Cancel"] = true
L["Cancel All"] = true
L["Cancel All Auctions"] = true
L["CANCEL_CONFIRM_TEXT"] = "Some of your auctions have bids on them.  Do you want to cancel all auctions, cancel only those with no bids, or do nothing?"
L["Cancelled %d |4listing:listings; of %s."] = true
L["Cancelled %d listings of %s"] = true
L["CANCEL_NOTE"] = [=[AuctionLite can only cancel one item per click due to a Blizzard restriction, so only one of your auctions was cancelled.

To work around this problem, you can continue clicking on the "Cancel" button until all the desired auctions have been cancelled.]=]
L["CANCEL_TOOLTIP"] = [=[|cffffffffClick:|r Cancel all auctions
|cffffffffCtrl-Click:|r Cancel undercut auctions]=]
L["Cancel Unbid"] = true
L["Cancel Undercut Auctions"] = true
L["|cff00ff00Scanned %d listings.|r"] = true
L["|cff00ff00Using previous price.|r"] = true
L["|cff808080(per item)|r"] = true
L["|cff808080(per stack)|r"] = true
L["|cff8080ffData for %s x%d|r"] = true
L["|cffff0000Buyout less than bid.|r"] = true
L["|cffff0000Buyout less than vendor price.|r"] = true
L["|cffff0000[Error]|r Insufficient funds."] = true
L["|cffff0000Invalid stack size/count.|r"] = true
L["|cffff0000No bid price set.|r"] = true
L["|cffff0000Not enough cash for deposit.|r"] = true
L["|cffff0000Not enough items available.|r"] = true
L["|cffff0000Stack size too large.|r"] = true
L["|cffff0000Using %.3gx vendor price.|r"] = true
L["|cffff0000[Warning]|r Skipping your own auctions.  You might want to cancel them instead."] = true
L["|cffff7030Buyout less than vendor price.|r"] = true
L["|cffff7030Stack %d will have %d |4item:items;.|r"] = true
L["|cffffd000Using historical data.|r"] = true
L["|cffffff00Scanning: %d%%|r"] = true
L["Choose a favorites list to edit."] = true
L["Choose which tab is selected when opening the auction house."] = true
L["Clear All"] = true
L["Clear all auction house price data."] = true
L["Clear All Data"] = true
L["CLEAR_DATA_WARNING"] = "Do you really want to delete all auction house price data gathered by AuctionLite?"
L["Competing Auctions"] = true
L["Configure"] = true
L["Configure AuctionLite"] = true
L["Consider resale value of excess items when filling an order on the \"Buy\" tab."] = true
L["Consider Resale Value When Buying"] = true
L["Create a new favorites list."] = true
L["Created %d |4auction:auctions; of %s x%d."] = true
L["Created %d |4auction:auctions; of %s x%d (%s total)."] = true
L["Current: %s (%.2fx historical)"] = true
L["Current: %s (%.2fx historical, %.2fx vendor)"] = true
L["Current: %s (%.2fx vendor)"] = true
L["Deals must be below the historical price by this much gold."] = true
L["Deals must be below the historical price by this percentage."] = true
L["Default"] = true
L["Default Number of Stacks"] = true
L["Default Stack Size"] = true
L["Delete"] = true
L["Delete the selected favorites list."] = true
L["%dh"] = true
L["Disable"] = true
L["Disenchant"] = true
L["Do it!"] = true
L["Do Nothing"] = true
L["Enable"] = true
L["Enter item name and click \"Search\""] = true
L["Enter the name of the new favorites list:"] = true
L["Error locating item in bags.  Please try again!"] = true
L["Error when creating auctions."] = true
L["Fast Auction Scan"] = true
L["Fast auction scan disabled."] = true
L["Fast auction scan enabled."] = true
L["FAST_SCAN_AD"] = [=[AuctionLite's fast auction scan can scan the entire auction house in a few seconds.

However, depending on your connection, a fast scan can cause you to be disconnected from the server.  If this happens, you can disable fast scanning on the AuctionLite options screen.

Enable fast auction scans?]=]
L["Favorites"] = true
L["Fixed amount to undercut market value for bid prices (e.g., 1g 2s 3c)."] = true
L["Fixed amount to undercut market value for buyout prices (e.g., 1g 2s 3c)."] = true
L["Full Scan"] = true
L["Full Stack"] = true
L["Hide Tooltips"] = true
L["Historical Price"] = true
L["Historical price for %d:"] = true
L["Historical: %s (%d |4listing:listings;/scan, %d |4item:items;/scan)"] = true
L["If Applicable"] = true
L["Invalid starting bid."] = true
L["Item"] = true
L["Items"] = true
L["Item Summary"] = true
L["Last Used Tab"] = true
L["Listing %d of %d"] = true
L["Listings"] = true
L["Market Price"] = true
L["Max Stacks"] = true
L["Max Stacks + Excess"] = true
L["Member Of"] = true
L["Minimum Profit (Gold)"] = true
L["Minimum Profit (Pct)"] = true
L["Mouse Cursor"] = true
L["Name"] = true
L["Net cost for %d:"] = true
L["Never"] = true
L["New..."] = true
L["No current auctions"] = true
L["No deals found"] = true
L["No items found"] = true
L["(none set)"] = true
L["Note: %d |4listing:listings; of %d |4item was:items were; not purchased."] = true
L["Not enough cash for deposit."] = true
L["Not enough items available."] = true
L["Number of Items"] = true
L["Number of Items |cff808080(max %d)|r"] = true
L["Number of stacks suggested when an item is first placed in the \"Sell\" tab."] = true
L["One Item"] = true
L["One Stack"] = true
L["On the summary view, show how many listings/items are yours."] = true
L["Open All Bags at AH"] = true
L["Open all your bags when you visit the auction house."] = true
L["Open configuration dialog"] = true
L["Percent to undercut market value for bid prices (0-100)."] = true
L["Percent to undercut market value for buyout prices (0-100)."] = true
L["per item"] = true
L["per stack"] = true
L["Placement of tooltips in \"Buy\" and \"Sell\" tabs."] = true
L["Potential Profit"] = true
L["Pricing Method"] = true
L["Print Detailed Price Data"] = true
L["Print detailed price data when selling an item."] = true
L["Profiles"] = true
L["Qty"] = true
L["Remove Items"] = true
L["Remove the selected items from the current favorites list."] = true
L["Resell %d:"] = true
L["Right Side of AH"] = true
L["Round all prices to this granularity, or zero to disable (0-1)."] = true
L["Round Prices"] = true
L["Save All"] = true
L["Saved Item Settings"] = true
L["Scan complete.  Try again later to find deals!"] = true
L["Scanning:"] = true
L["Scanning..."] = true
L["Search"] = true
L["Searching:"] = true
L["Select a Favorites List"] = true
L["Selected Stack Size"] = true
L["Sell Tab"] = true
L["Shift-click to search for the exact name. Normal click to perform a regular search."] = true
L["Show auction house value in tooltips."] = true
L["Show Auction Value"] = true
L["Show Deals"] = true
L["Show Disenchant Value"] = true
L["Show expected disenchant value in tooltips."] = true
L["Show Favorites"] = true
L["Show Full Stack Price"] = true
L["Show full stack prices in tooltips (shift toggles on the fly)."] = true
L["Show How Many Listings are Mine"] = true
L["Show My Auctions"] = true
L["Show Vendor Price"] = true
L["Show vendor sell price in tooltips."] = true
L["Stack Count"] = true
L["Stack Size"] = true
L["Stack size suggested when an item is first placed in the \"Sell\" tab."] = true
L["Stack size too large."] = true
L["stacks of"] = true
L["Start Tab"] = true
L["Store Price Data"] = true
L["Store price data for all items seen (disable to save memory)."] = true
L["Time Elapsed:"] = true
L["Time Remaining:"] = true
L["Tooltip Location"] = true
L["Tooltips"] = true
L["Use Coin Icons in Tooltips"] = true
L["Use fast method for full scans (may cause disconnects)."] = true
L["Uses the standard gold/silver/copper icons in tooltips."] = true
L["Vendor"] = true
L["Vendor Multiplier"] = true
L["Vendor: %s"] = true
L["VENDOR_WARNING"] = "Your buyout price is below the vendor price.  Do you still want to create this auction?"
L["Window Corner"] = true

-------------------Advanced
L["ADVANCED_TRUNC"] = "Adv."
L["ADVANCED"] = "Advanced"
L["ADVANCED_DESC"] = "Contains advanced features for AuctionLite."

L["USE"] = "Use"
L["USE_DESC"] = "Check to only search for items that your character can use."
L["CATEGORY"] = "Category"
L["CATEGORY_DESC"] = [[Choose the item category that you would like to search.

You can also set the item rarity filter in this menu.]]
L["LEVEL_MIN"] = "Minimum Level"
L["LEVEL_MIN_DESC"] = [[Choose the minimum level requirement that you wish to search for.

Leave blank to not use this filter.]]
L["LEVEL_MAX"] = "Maximum Level"
L["LEVEL_MAX_DESC"] = [[Choose the maximum level requirement that you wish to search for.

Leave blank to not use this filter.]]
L["RESET"] = "Reset Filters"
L["RESET_DESC"] = "Click to reset all filters."
L["NAME"] = "Name"
L["NAME_DESC"] = [[Enter the name of an item you wish to search for.

Leave blank to search for all items that fit the current filters.]]
L["QUANTITY"] = "Quantity"
L["QUANTITY_DESC"] = "Choose the amount of the item that you would like to buy."
L["SEARCH"] = "Search"
L["SEARCH_DESC"] = [[Click to search the auction house using the filters that you have set.

Hold the Shift key when clicking to force the name searched for to match exactly.]]
L["FULLSCAN"] = "Full Scan"
L["FULLSCAN_DESC"] = [[Click to do a full scan of all items in the auction house.

This may only be done once per 15 minutes.]]

L["RARITY"] = "Rarity"
L["RARITY_DESC"] = "Select the lowest item rarity that you would like to search for."
L["RARITY_LABEL"] = "Rarity: %s"
L["CLEARCATEGORY"] = "Reset Category Filter"
L["CLEARCATEGORY_DESC"] = "Resets the category filter in order to search all categories."