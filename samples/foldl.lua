local _ = require "luautil-devel"

list = {1, 2, 3, 4, 5, 6}
_.foldl(list, function(memo, keys, item)
	return memo + item
end, 0)
