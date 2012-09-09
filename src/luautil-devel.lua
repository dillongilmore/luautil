#!/usr/bin/env lua

function VERSION()
	print "1.0.0-1"
end

function each(obj, iterator)
	if not obj then return end
	for keys, item in pairs(obj) do
		iterator(keys, item)
	end
end

function map(obj, iterator)
	local results = {}
	if not obj then return results end
	each(obj, function(keys, item)
		results[#results + 1] = iterator(keys, item)
	end)
	return results
end

function foldl(obj, iterator, memo)
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

function foldr(obj, iterator, memo)
	if not obj then obj = {} end
	local reversed = reverse(obj)
	return foldl(reversed, iterator, memo)
end

function find(obj, iterator)
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

function filter(obj, iterator)
	local results = {}
	each(obj, function(keys, item)
		if iterator(keys, item) then
			results[#results + 1] = item
		end
	end)
	return results
end

function reject(obj, iterator)
	local results = {}
	each(obj, function(keys, item)
		if iterator(keys, item) == false then
			results[#results + 1] = item
		end
	end)
	return results
end

function all(obj, iterator)
	local result = true
	if not obj then return result end
	each(obj, function(keys, item)
		if result ~= iterator(keys, item) then
			return false
		end
	end)
	return true
end

function any(obj, iterator)
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

function include(obj, target)
	local found = false
	if obj == nil then return found end
	found = any(obj, function(keys, item)
		return item == target
	end)
	return found
end

function invoke(obj, method, ...)
	return map(obj, function(keys, item)
		if is_function(method) then
			return method(item, arg)
		end
	end)
end

function pluck(obj, key)
	return map(obj, function(keys, item)
		if key == keys then
			return item
		end
	end)
end

function max(obj, memo, iterator)
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

function min(obj, memo, iterator)
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

function shuffle(obj)
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

function sort_by(obj, iterator)
	print "TABLE.SORT() ALWAYS RETURN NIL"
end

function group_by(obj, iterator)
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

function sorted_index(array, obj, iterator)
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

function totable(obj)
	if not obj then return {} end
	if is_table(obj) then
		return obj
	end
	return {obj}
end

function size(obj)
	if is_table(obj) then
		return #obj
	else
		return #keys(obj)
	end
end

function first(array, n)
	if not n then return array[1] end
	local results = map(array, function(keys, item)
		if keys <= n then return item end
	end)
	return results
end

function initial(array, n)
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

function last(array, n)
	local len = n or 1
	local index = #array - len + 1
	local results = map(array, function(keys, item)
		if keys >= index then return item end
	end)
	return results
end

function rest(array, index)
	local init = index or 1
	local len = init + 1
	local results = map(array, function(keys, item)
		if keys >= len then return item end
	end)
	return results
end

function compact(array)
	return filter(array, function(keys, item)
		if item ~= nil then return item end
	end)
end

function flat(input, output)
	each(input, function(keys, item)
		if is_table(item) then
			flatten(item, output)
		elseif item then
			table.insert(output, item)
		end
	end)
	return output
end

function flatten(array, memo)
	if not memo then memo = {} end
	return flat(array, memo)
end

function without(array)
	print("without")
end

function unique(array, sorted, iterator)
	print("unique")
end

function union()
	print("union")
end

function intersection(array)
	print("intersection")
end

function difference(...)
	local args = arguments(...)
	print(select('#', ...))
	print(arguments)
--	local rest = flatten(slice(arg, 1))
--	return filter(arg[1], function(keys, item)
--		return not include(rest, item)
--	end)
end

function zip()
	print("zip")
end

-- this function has a confusing looking for loop
function zip_object(keys, values)
	local results = {}
	for keys, items in pairs(keys) do
		results[items] = values[keys]
	end
	return results
end

function index_of(array, item)
	print("indexof")
end

function last_index_of(array, item)
	if not array then return -1 end
	local index = #array
	while index > 0 do
		if array[index] == item then
			return index
		end
		index = index - 1
	end
end

function range(start, stop, step)
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

function bind(func)
	print("bind")
end

function bind_all(obj)
	print("bindall")
end

function memoize(func, hasher)
	print("memoize")
end

-- FIXME: the delay works but i cant get the func to execute properly
function delay(wait, func)
	local go = os.time() + wait
	repeat
		if os.time == go then
			return func()
		end
	until os.time() > go
end

function defer(func)
	return delay(1, func())
end

-- TODO: this is hard/complicated
function throttle(func, wait)
	print("throttle")
end

function debounce(func, wait, immediate)
	print("debounce")
end

-- FIXME: same problem as delay
function once(func)
	local ran = false
	return function()
		if ran then return end
		ran = true
		return func()
	end
end

function wrap(func, wrapper)
	return function()
		return wrapper(func)
	end
end

-- TODO: finish this
function compose(...)
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
function after(times, func)
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

function keys(obj)
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

function values(obj)
	print("values")
end

function functions(obj)
	print("functions")
end

function extend(...)
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

function pick(...)
	print("pick")
end

function defaults(...)
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

function clone(obj)
	print("clone")
end

-- TODO: test this
function tap(obj, interceptor)
	interceptor(obj)
	return obj
end

-- TODO: finish this
function eq(a, b, stack)
	if a == b then return a ~= 0 or 1 / a == 1 / b end
	if a == nil or b == nil then return a == b end
end

function is_equal(a, b)
	return eq(a, b, {})
end

-- TODO: finish this
function is_empty(obj)
	if obj == nil then return true end
end

function is_table(obj)
	return type(obj) == "table"
end

function is_function(obj)
	return type(obj) == "function"
end

function is_string(obj)
	return type(obj) == "string"
end

function is_number(obj)
	return type(obj) == "number"
end

function is_nil(obj)
	if not obj then
		return true
	else
		return false
	end
end

function is_true(obj)
	if obj then
		return true
	else
		return false
	end
end

function is_boolean(obj)
	return type(obj) == "boolean"
end

function is_userdata(obj)
	return type(obj) == "userdata"
end

function is_thread(obj)
	return type(obj) == "thread"
end

function is_undefined(obj)
	return obj == '' or ""
end

function has(obj, key)
	if not is_table(obj) then return false end
	for keys, item in pairs(obj) do
		if keys == key then
			return true
		else
			return false
		end
	end
end

function identity(value)
	return value
end

function times(n, iterator)
	for keys, items in pairs(range(n)) do
		iterator()
	end
end

function result(object, property)
	if not object then return nil end
	local value = object[property]
	if is_function(value) then
		return value()
	else
		return value
	end
end

function mixin(obj)
	print("mixin")
end

function chain(obj)
	return obj
end

function reverse(obj)
	local length = #obj
	local results = {}
	each(obj, function(keys, item)
		results[length - keys + 1] = item
	end)
	return results
end

function mean(obj, start)
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

function slice(obj, start, stop)
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

function arguments(args)
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
