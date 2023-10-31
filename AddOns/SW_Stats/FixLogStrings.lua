--[[
	字符串匹配用，删除后会影响同步功能
--]]

if LOCALE_zhCN then
	function SW_FixLogStrings(str)
		-- jinsongzhao
		if string.find(str,"的%%s") or string.find(str,"对%%s") or string.find(str,"击中%%s") then
			str = string.gsub(str, "(%%%d?$?s)([^%s+].)", "%1%2");
			str = string.gsub(str, "(.[^%s+])(%%%d?$?s)", "%1%2");
			str = string.gsub(str, "(.[^%s+])(%%%d?$?d)", "%1%2");
			return string.gsub(str, "(%%%d?$?d)([^%s+].)", "%1%2");
		end
		return str;	
	end
else
	function SW_FixLogStrings(str)
		--problematic strings
		-- %s's 
		--Twilight's Hammer Ambassador's Flame Shock hits you for 1234 fire damage.
		-- or fictional: Twilight's Hammer Ambassador's Nature's Grasp ...
		return string.gsub(str, "(%%%d?$?s)('s)", "%1% %2");
	end
end