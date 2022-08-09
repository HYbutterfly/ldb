local serialize = require "serialize"
local util = require "ldb.util"


local function enum(list)
	for i,v in ipairs(list) do
		list[v] = i
	end
	return list
end


local COMMAND = enum{"init", "update", "delete"}



local function logger(filename)
	local t = {}

	local command = {}

	function command.init(key, value)
		t[key] = value
	end

	function command.update(key, patch)
		local obj = assert(t[key])
		util.patch(obj, patch)
	end

	function command.delete(key)
		t[key] = nil
	end

	local file, err = io.open(filename)
	if file then
		local clock = os.clock()
		while true do
			local head = file:read(2)
			if not head then
				break
			end
			local size = head:byte(1) * 256 + head:byte(2)
			local body = assert(file:read(size))
			local cmd, k, v = serialize.unpack(body)
			local f = command[assert(COMMAND[cmd])]
			f(k, v)
		end
		file:close()
		print(string.format('load file "%s" use %fs', filename, os.clock() - clock))
	else
		-- print(err)
	end


	local file = assert(io.open(filename, "a+"))


	local function write(...)
		local s = string.pack(">s2", serialize.pack(...))
		assert(file:write(s))
	end


	local self = setmetatable({}, {__gc = function ()
		file:close()
	end})


	function self.init(key, value)
		write(COMMAND.init, key, value)
		command.init(key, value)
	end

	
	function self.update(key, patch)
		write(COMMAND.update, key, patch)
		command.update(key, patch)
	end

	
	function self.delete(key)
		write(COMMAND.delete, key)
		command.delete(key)
	end


	return self, t
end


return logger