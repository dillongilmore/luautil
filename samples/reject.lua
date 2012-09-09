local _ = require "luautil-devel"

local list = {1, 2, 3, 4, 5, 6}
_.reject(list, function(keys, item)
	return item % 2 == 0
end)
