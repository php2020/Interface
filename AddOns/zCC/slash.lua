local function zCC_GetDefault()
	return {
		font = "Fonts\\FZLBJW.TTF",
		size = 20,
		min = 3,
		texture = zShineTextures[1],
		scale = 256,
		speed = 0.92,
		NoShine = nil,
		NoPet = nil,
	}
end
local function zCC_Print(msg,r,g,b,frame,id)
	if (not r) then r = 1.0 end
	if (not g) then g = 1.0 end
	if (not b) then b = 0.0 end
	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id)
	elseif ( frame ) then
		frame:AddMessage(msg,r,g,b,id)
	end
end
local function zSetNum(str, min, max, varName)
	if (tonumber(str) and tonumber(str) >= min and tonumber(str) <= max) then
		zCC_Print(varName.."设置为|cFF00FF00"..str.."|r")
		return tonumber(str)
	else
		zCC_Print(varName.."未设置，"..str.."为非法值！",1,0,0)
		return nil
	end
end
SlashCmdList["ZCCSLASH"] = function(msg)
	local args = {}
	local word
	for word in string.gfind(msg, "[^%s]+") do
		table.insert(args, word )
	end
	
	if(not args[1] or args[1] == "" or args[1] == "help") then
		zCC_Print("炽火冷却计时设置",0,0.6,1)
		zCC_Print("|cFF00FF00/zcc reset|r - 重置")
		zCC_Print("|cFF00FF00/zcc shine|r - 隐藏/显示闪光")
		zCC_Print("|cFF00FF00/zcc pet|r - 开启/关闭宠物按钮的计时和闪光")
		zCC_Print("|cFF00FF00/zcc font <value>|r - 设置字体文件, 默认是 Fonts\\FZLBJW.TTF")
		zCC_Print("|cFF00FF00/zcc size <value>|r - 字体大小, 取值1~50, 默认是 20")
		zCC_Print("|cFF00FF00/zcc min <value>|r - 少于此值的冷却不显示, >0, 默认是 3 秒")
		zCC_Print("|cFF00FF00/zcc texture <value>|r - 闪光材质, 取值1~4, 默认是 1")
		zCC_Print("|cFF00FF00/zcc scale <value>|r - 闪光大小, 取值36~512, 默认是 256")
		zCC_Print("|cFF00FF00/zcc speed <value>|r - 闪光速度, 取值-3~3, 默认是 0")
		return
	else
		msg = string.lower(args[1])
	end
	
	if (msg == "reset") then
		zCC = zCC_GetDefault()
		zCC_Print("zCC - 所有属性已经重置为默认值。",0,1,1)
		return
	elseif (msg == "pet") then
		if (not zCC.NoPet) then
			zCC.NoPet = true
			zCC_Print("宠物按钮的计时和闪光已|cFF00FF00关闭|r")
		else
			zCC.NoPet = nil
			zCC_Print("宠物按钮的计时和闪光已|cFF00FF00开启|r")
		end
		return
	elseif (msg == "shine") then
		if (not zCC.NoShine) then
			zCC.NoShine = true
			zCC_Print("闪光效果设置为|cFF00FF00隐藏|r")
		else
			zCC.NoShine = nil
			zCC_Print("闪光效果设置为|cFF00FF00显示|r")
		end
		return
	end
	
	if (not args[2] or args[2] == "") then
		zCC_Print("-- 命令行错误，或缺少参数!!! --",1,0,0)
		return
	elseif (msg == "font") then
		if(not zCCTestFont) then
			CreateFont("zCCTestFont")
		end
		if( zCCTestFont:SetFont(args[2], zCC.size) ) then
			zCC.font = args[2]
			zCC_Print("字体：|cFF00FF00"..args[2].."|r 设置成功。")
		else
			zCC_Print("|cFFFF0000字体未设置，"..args[2].."为无效字体，请检查拼写！|r")
		end
	elseif (msg == "size") then
		zCC.size = zSetNum(args[2], 1, 50, "字体大小") or zCC.size
	elseif (msg == "min") then
		zCC.min = zSetNum(args[2], 0, 65535, "最小冷却时间") or zCC.min
	elseif (msg == "texture")then
		local n = zSetNum(args[2], 1, 4, "闪光材质")
		if (n) then
			zCC.texture = zShineTextures[n]
		end
	elseif (msg == "scale")then
		zCC.scale = zSetNum(args[2], 36, 512, "闪光大小") or zCC.scale
	elseif (msg == "speed")then
		local n = zSetNum(args[2], -3, 3, "闪光速度")
		if (n) then
			zCC.speed = 0.92 - 0.02*n
		end
	else
		zCC_Print("--命令行错误!!!--",1,0,0)
	end
end
SLASH_ZCCSLASH1 = "/zcc"