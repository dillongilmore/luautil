local _ = require "luautil-devel"

list = {1, 2, 3, 4, 5, 6}
_.find(list, function(keys, item)
	return 4
end)
