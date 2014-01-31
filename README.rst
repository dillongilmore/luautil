=====
Lua Utility Belt
=====

Lua is a fantastic language and the people behind it have great goals.
Mainly **To keep Lua fast**.
For the common developer like myself where speed actually doesn't matter and additional functionality would be nice.
Luautil is a utility belt that adds that functionality.
Luautil started based off of Underscore.js, but I decided that a general utility belt would be better. Adding additional functions that exist in languages
like Python and JavaScript that don't exist in Lua.

====
Why?
====

Because I love Lua, it is by far my favorite language, the syntax is awesome. You can read a book and create one project and know Lua top and down. Most
languages these days you wouldn't be able to understand fully even after years of experience. **Simplicity is perfection**

=====
What about Underscore.lua?
=====

Underscore.lua isn't a full implementation of Underscore.js (neither is luautil), but my implementation covers more of it.
It also doesn't add functions like "slice", which is present in almost all languages.
Lua has valid reasons for not supporting slice but again performance isn't a goal for **this** project.
Also, if you look at the people behind lua they use certain conventions that should ideally be law that Underscore.lua doesn't follow, instead
Underscore.lua follows JavaScript conventions, which is a terrible idea to bring to lua.
