-- SORT_BY() FUNCTION IS CURRENTLY UNDER MAINTENCE
local _ = require "luautil-devel"

local list = {1, 2, 3, 4, 5, 6}
new = _.sort_by(list, function(keys, item)
	return math.sin(item)
end)

print(new)
