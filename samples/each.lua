require "luautil-devel"

list = {1, 2, 3, 4, 5, 6}
each(list, function(keys, item)
	return item
end)
