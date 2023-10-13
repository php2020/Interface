local L = AceLibrary("AceLocale-2.1")

L:RegisterTranslation("BuyEmAll", "enUS", function()
    return {
        ["Max"] = true,
        ["Stack"] = true,
        ["Are you sure you want to buy\n %d × %s?"] = true,
		["Stack purchase"] = true,
        ["Stack size"] = true,
		["Partial stack"] = true,
        ["Maximum purchase"] = true,
        ["You can fit"] = true,
        ["You can afford"] = true,
        ["Vendor has"] = true,
    }
end)

L:RegisterTranslation("BuyEmAll", "zhCN", function()
    return {
        -- Thanks to q09q09
        ["Max"] = "最多",
        ["Stack"] = "一组",
        ["Are you sure you want to buy\n %d × %s?"] = "是否确实要买\n %2$s x %1$d ?",
		["Stack purchase"] = "堆叠购买",
        ["Stack size"] = "堆叠大小",
		["Partial stack"] = "部分堆叠",
        ["Maximum purchase"] = "最大购买量",
        ["You can fit"] = "能够买",
        ["You can afford"] = "能买得起",
        ["Vendor has"] = "商店有",
    }
end)