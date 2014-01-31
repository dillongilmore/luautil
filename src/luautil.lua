-- Copyright (c) 2013 Dillon Gilmore <dillon@gilm.re>
--
-- This file is part of luautil.

-- Luautil is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- Luautil is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.--See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with luautil.  If not, see <http://www.gnu.org/licenses/>.

--- Luautil is a collection of utility functions
-- @author Dillon Gilmore <dillon@gilm.re>
-- @copyright GNU GPLv3

--- luautil's version
-- @return string - the version
function VERSION()
	print "1.0.1-1"
end

local luautil = {}
luautil.__index = luautil

--- luautil's constructor function
-- @param init
-- @return luautil metatable
function luautil:new(val)
	return setmetatable({_val = val}, self)
end

--- immutability is important
-- people should expect this to work the same all the time
function luautil.__newindex(...)
	error("This is a static library, please use the functions provided.")
end

--- Provide the basic necessities for using the luautil object as any
-- other basic type: number, string, boolean, nil

--- Get the length of the string if the object is one
-- @usage #my_util_string
-- @return number
function luautil:__len()
	return #self._val
end

--- If the current value is a string or number then return it
-- @return number or string
function luautil:__tostring()
	if (type(self._val) == "string" or type(self._val) == "number") then
		return luautil._val
	end
end

function luautil:__concat()
	if (type(self._val) == "string" or type(self._val) == "number") then
		return luautil._val
	end
end

function luautil:__unm()
	if (type(self._val == "number")) then
		return -self._val
	end
end

function luautil:__add(num)
	if (type(num) == "string" or type(num) == "number") then
		return self._val + num
	end
end

function luautil:__sub(num)
	if (type(num) == "string" or type(num) == "number") then
		return self._val - num
	end
end

function luautil:__mul(num)
	if (type(num) == "string" or type(num) == "number") then
		return self._val * num
	end
end

function luautil:__mod(num)
	if (type(num) == "string" or type(num) == "number") then
		return self._val % num
	end
end

function luautil:__pow(num)
	if (type(num) == "string" or type(num) == "number") then
		return self._val ^ num
	end
end

function luautil:__lt(num)
	if (type(num) == "string" or type(num) == "number") then
		return self._val < num
	end
end

function luautil:__le(num)
	if (type(num) == "string" or type(num) == "number") then
		return self._val <= num
	end
end

--- Add easy meta programming by
-- providing a way to call functions via string
-- @usage luautil(function_name, then, the, function, parameters)
-- @param string|function luautil:the function luautil:to be called
-- @return - function luautil:- either the fed function's return value
-- @return - string - luautil's implementation of said function
function luautil:__call(fn, ...)
	if (type(fn) == "string") then
		return self[fn](...)
	elseif (type(fn) == "function") then
		return fn(...)
	end
end

function luautil:each(obj, iterator)
	if not obj then return end
	for keys, item in pairs(obj) do
		iterator(keys, item)
	end
end

function luautil:map(obj, iterator)
	local results = {}
	if not obj then return results end
	each(obj, function(keys, item)
		results[#results + 1] = iterator(keys, item)
	end)
	return results
end

function luautil:foldl(obj, iterator, memo)
	if not memo then memo = 0 end
	if not obj then obj = {} end
	each(obj, function(keys, item)
		if memo then
			memo = iterator(memo, keys, item)
		else 
			memo = item
		end
	end)
	return memo
end

function luautil:foldr(obj, iterator, memo)
	if not obj then obj = {} end
	local reversed = reverse(obj)
	return foldl(reversed, iterator, memo)
end

function luautil:find(obj, iterator)
	iterator = iterator or identity
	local result
	if not obj then return result end
	any(reverse(obj), function(keys, item)
		if iterator(keys, item) then
			result = item
			return true
		end
	end)
	return result
end

function luautil:filter(obj, iterator)
	local results = {}
	each(obj, function(keys, item)
		if iterator(keys, item) then
			results[#results + 1] = item
		end
	end)
	return results
end

function luautil:reject(obj, iterator)
	local results = {}
	each(obj, function(keys, item)
		if iterator(keys, item) == false then
			results[#results + 1] = item
		end
	end)
	return results
end

function luautil:all(obj, iterator)
	local result = true
	if not obj then return result end
	each(obj, function(keys, item)
		if result ~= iterator(keys, item) then
			return false
		end
	end)
	return true
end

function luautil:any(obj, iterator)
	if not iterator then iterator = identity end
	local result = false
	if not obj then return result end
	each(obj, function(keys, item)
		if not result then
			result = is_true(iterator(keys, item))
		end
	end)
	return result
end

function luautil:include(obj, target)
	local found = false
	if obj == nil then return found end
	found = any(obj, function(keys, item)
		return item == target
	end)
	return found
end

function luautil:invoke(obj, method, ...)
	return map(obj, function(keys, item)
		if is_function(method) then
			return method(item, arg)
		end
	end)
end

function luautil:pluck(obj, key)
	return map(obj, function(keys, item)
		if key == keys then
			return item
		end
	end)
end

function luautil:max(obj, memo, iterator)
	if not memo then memo = 0 end
	if not iterator then
		for keys, item in pairs(obj) do
			memo = math.max(item, memo)
		end
	else
		for keys, item in pairs(obj) do
			memo = iterator(item, memo)
		end
	end
	return memo
end

function luautil:min(obj, memo, iterator)
	if not memo then memo = 0 end
	if not iterator then
		for keys, item in pairs(obj) do
			memo = math.min(item, memo)
		end
	else
		for keys, item in pairs(obj) do
			memo = iterator(item, memo)
		end
	end
	return memo
end

function luautil:shuffle(obj)
	local index = 0
	local shuffled = {}
	each(obj, function(keys, item)
		index = index + 1
		local rand = math.floor(math.random() * index)
		shuffled[index] = shuffled[rand]
		shuffled[rand] = item
	end)
	return shuffled
end

function luautil:sort_by(obj, iterator)
	print "TABLE.SORT() ALWAYS RETURN NIL"
end

function luautil:group_by(obj, iterator)
	local results = {}
	if is_function(iterator) then
		each(obj, function(keys, item)
			local key = iterator(keys, item)
			if results[key] then
				if is_table(results[key]) then
					table.insert(results[key], item)
				else
					local memo = results[key]
					table.remove(results, results[key])
					local val = {memo, item}
					results[key] = val
				end
			else
				results[key] = item
			end
		end)
	end
	return results
end

function luautil:sorted_index(array, obj, iterator)
	if not iterator then iterator = identity end
	local value = iterator(obj)
	local low = 0
	local high = #array
	while low < high do
		local mid = mean(low + high)
		if iterator(array[mid]) < value then
			low = mid + 1
		else
			high = mid
		end
	end
	return low
end

function luautil:totable(obj)
	if not obj then return {} end
	if is_table(obj) then
		return obj
	end
	return {obj}
end

function luautil:size(obj)
	if is_table(obj) then
		return #obj
	else
		return #keys(obj)
	end
end

function luautil:first(array, n)
	if not n then return array[1] end
	local results = map(array, function(keys, item)
		if keys <= n then return item end
	end)
	return results
end

function luautil:initial(array, n)
	local len = n or 1
	local actual = 0
	local index = #array - len
	local results = map(array, function(keys, item)
		if actual <= index then
			actual = actual + 1
			return item
		end
	end)
	return results
end

function luautil:last(array, n)
	local len = n or 1
	local index = #array - len + 1
	local results = map(array, function(keys, item)
		if keys >= index then return item end
	end)
	return results
end

function luautil:rest(array, index)
	local init = index or 1
	local len = init + 1
	local results = map(array, function(keys, item)
		if keys >= len then return item end
	end)
	return results
end

function luautil:compact(array)
	return filter(array, function(keys, item)
		if item ~= nil then return item end
	end)
end

function luautil:flat(input, output)
	each(input, function(keys, item)
		if is_table(item) then
			flatten(item, output)
		elseif item then
			table.insert(output, item)
		end
	end)
	return output
end

function luautil:flatten(array, memo)
	if not memo then memo = {} end
	return flat(array, memo)
end

function luautil:without(array)
	print("without")
end

function luautil:unique(array, sorted, iterator)
	print("unique")
end

function luautil:union()
	print("union")
end

function luautil:intersection(array)
	print("intersection")
end

function luautil:difference(...)
	local args = arguments(...)
	print(select('#', ...))
	print(arguments)
--	local rest = flatten(slice(arg, 1))
--	return filter(arg[1], function(keys, item)
--		return not include(rest, item)
--	end)
end

function luautil:zip()
	print("zip")
end

-- this function luautil:has a confusing looking for loop
function luautil:zip_object(keys, values)
	local results = {}
	for keys, items in pairs(keys) do
		results[items] = values[keys]
	end
	return results
end

function luautil:index_of(array, item)
	print("indexof")
end

function luautil:last_index_of(array, item)
	if not array then return -1 end
	local index = #array
	while index > 0 do
		if array[index] == item then
			return index
		end
		index = index - 1
	end
end

function luautil:range(start, stop, step)
	local stop = stop or start or 0
	local start = start or 0
	local step = step or 1

	if stop == start then start = 0 end

	local len = math.max(math.ceil((stop - start) / step ), 0)
	local idx = 0
	local ran = {}

	while idx < len do
		idx = idx + 1
		ran[idx] = start
		start = start + step
	end

	return ran
end

function luautil:bind(func)
	print("bind")
end

function luautil:bind_all(obj)
	print("bindall")
end

function luautil:memoize(func, hasher)
	print("memoize")
end

-- FIXME: the delay works but i cant get the func to execute properly
function luautil:delay(wait, func)
	local go = os.time() + wait
	repeat
		if os.time == go then
			return func()
		end
	until os.time() > go
end

function luautil:defer(func)
	return delay(1, func())
end

-- TODO: this is hard/complicated
function luautil:throttle(func, wait)
	print("throttle")
end

function luautil:debounce(func, wait, immediate)
	print("debounce")
end

-- FIXME: same problem as delay
function luautil:once(func)
	local ran = false
	return function()
		if ran then return end
		ran = true
		return func()
	end
end

function luautil:wrap(func, wrapper)
	return function()
		return wrapper(func)
	end
end

-- TODO: finish this
function luautil:compose(...)
	local funcs = arg
	return function()
		local args = {}
		for keys, item in pairs(funcs) do
			args = args[key](item)
		end
		return args[0]
	end
end

-- FIXME: wont execute just like delay
function luautil:after(times, func)
	if times <= 0 then
		return func()
	end
	return function()
		if times < 1 then
			return func()
		else
			times = times - 1
		end
	end
end

function luautil:keys(obj)
	if not is_table(obj) then
		obj = totable(obj)
	end
	local key = {}
	for index, item in pairs(obj) do
		if has(obj, index) then
			key[#key + 1] = index
		end
	end
	return key
end

function luautil:values(obj)
	print("values")
end

function luautil:functions(obj)
	print("functions")
end

function luautil:extend(...)
	local args = initial(arg)
	each(args, function(inkeys, initems)
		for keys, items in pairs(initems) do
			if not args[1][keys] then
				args[1][keys] = items
			end
		end
	end)
	return args[1]
end

function luautil:pick(...)
	print("pick")
end

function luautil:defaults(...)
	local args = initial(arg)
	each(args, function(inkeys, initems)
		for keys, items in pairs(initems) do
			if args[1][keys] == nil then
				args[1][keys] = initems[keys]
			end
		end
	end)
	return args[1]
end

function luautil:clone(obj)
	print("clone")
end

-- TODO: test this
function luautil:tap(obj, interceptor)
	interceptor(obj)
	return obj
end

-- TODO: finish this
function luautil:eq(a, b, stack)
	if a == b then return a ~= 0 or 1 / a == 1 / b end
	if a == nil or b == nil then return a == b end
end

function luautil:is_equal(a, b)
	return eq(a, b, {})
end

-- TODO: finish this
function luautil:is_empty(obj)
	if obj == nil then return true end
end

function luautil:is_table(obj)
	return type(obj) == "table"
end

function luautil:is_function(obj)
	return type(obj) == "function"
end

function luautil:is_string(obj)
	return type(obj) == "string"
end

function luautil:is_number(obj)
	return type(obj) == "number"
end

function luautil:is_nil(obj)
	if not obj then
		return true
	else
		return false
	end
end

function luautil:is_true(obj)
	if obj then
		return true
	else
		return false
	end
end

function luautil:is_boolean(obj)
	return type(obj) == "boolean"
end

function luautil:is_userdata(obj)
	return type(obj) == "userdata"
end

function luautil:is_thread(obj)
	return type(obj) == "thread"
end

function luautil:is_undefined(obj)
	return obj == '' or ""
end

function luautil:has(obj, key)
	if not is_table(obj) then return false end
	for keys, item in pairs(obj) do
		if keys == key then
			return true
		else
			return false
		end
	end
end

function luautil:identity(value)
	return value
end

function luautil:times(n, iterator)
	for keys, items in pairs(range(n)) do
		iterator()
	end
end

function luautil:result(object, property)
	if not object then return nil end
	local value = object[property]
	if is_function(value) then
		return value()
	else
		return value
	end
end

function luautil:mixin(obj)
	print("mixin")
end

function luautil:chain(obj)
	return obj
end

function luautil:reverse(obj)
	local length = #obj
	local results = {}
	each(obj, function(keys, item)
		results[length - keys + 1] = item
	end)
	return results
end

function luautil:mean(obj, start)
	if not start then start = 0 end
	local value = obj
	if is_number(obj) then
		value = range(start, obj)
	end
	results = foldl(value, function(memo, keys, item)
		if keys % 2 == 0 then
			return memo + item
		else
			return memo - item
		end
	end, start)
	return math.abs(results)
end

function luautil:slice(obj, start, stop)
	if not stop then stop = #obj end
	local steps = 0
	if start < 0 then
		start = #obj - math.abs(start)
	end
	if stop < 0 then
		stop = math.abs(stop)
	end
	if start > stop then
		steps = range(stop, start)
	else
		steps = range(start, stop)
	end
	for keys, item in pairs(steps) do
		table.remove(obj, item)
	end
	return obj
end

function luautil:arguments(args)
	for i,k in pairs(args) do
		if type(k) == 'table' then
			for key,item in pairs(k) do
				print(item)
			end
		else
			print(k)
		end
	end
end
