local _ = require "luautil-devel"

local list = {6, 5, 4, 3, 2, 1}
local new = _.invoke(list, function(keys, item)
	return keys + item
end)
