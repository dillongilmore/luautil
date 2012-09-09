local _ = require "luautil-devel"

local list = {1, 2, 3, 4, 5, 6}
local remove = {2, 4, 6}
local odds = _.difference({1,2,3}, {1}, {2})
