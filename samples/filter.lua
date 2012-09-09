local _ = require "luautil-devel"

list = {1, 2, 3, 4, 5, 6}
_.filter(list, function(keys, item)
	return item % 2 == 0
end)
