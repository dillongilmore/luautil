#!/usr/bin/env lua

require "luautil"

-- set some global tables to test against
strs = {"one", "two", "three", "four", "five", "six"}
ints = {1, 2, 3, 4, 5, 6}
keys = {one = "1", two = "2", three = "3"}
list_in_list = {{name = "dillon"}, {name = "chris"}, {name = "brandon"}, {name = "amber"}}
some_nils = {1,2,nil,'',4,5,0} 
extention = {four = "4",five = "5", six = "6"}
html = "<html></html>"
func = {greeting = "Hello World", welcoming = function() return "Welcome" end}
all_nil = {nil, nil, false, nil}

do
	print("invoke")
	luautil.invoke(strs, luautil.sort)
end

do
	print("sorty by")
	luautil.sort_by(strs, function(keys, item) return math.sin(item) end)
end
