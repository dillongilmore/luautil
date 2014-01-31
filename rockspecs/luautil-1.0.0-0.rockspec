package = "Luautil"

version = "1.0.1-1"

source = {
	url = "http://cloud.dyelon.com/luautil/luautil.tar.gz"
}

description = {
	summary = "Utility Belt for the Lua Programming Language",

	detailed = [[
		Luautil is a Lua library developed to add additional functionality
		to the standard set of Lua functions.
	]]
}

dependencies = {
	"lua >= 5.1"
}

build = {
	type = "module",
	modules = { luautil = "src/luautil.lua" },
	copy_directories = { "docs" }
}
