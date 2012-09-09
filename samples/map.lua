local _ = require "luautil-devel"

list = {6, 5, 4, 3, 2, 1}
local table = _.map(list, function(keys, item)
	table[keys] = keys
end)
