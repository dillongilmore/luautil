local _ = require "luautil-devel"

local list = {1, 2, 3, 4, 5, 6}
_.group_by(list, function(keys, item)
	if item % 2 == 0 then
		return "even"
	else
		return "odd"
	end
end)
