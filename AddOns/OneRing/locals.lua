--$Id: locals.lua 12749 2006-10-03 02:19:17Z kergoth $ 

local AL = AceLibrary("AceLocale-2.1")

AL:RegisterTranslation("OneRing", "enUS", function()
    return {
		["Keyring"] = true,
    }
end)

AL:RegisterTranslation("OneRing", "zhCN", function()
    return {
		["Keyring"] = "钥匙链",
    }
end)