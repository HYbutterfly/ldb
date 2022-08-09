local util = require "ldb.util"
local logger = require "ldb.logger"


local _, const = logger("ldb/data/const")
local log, db = logger("ldb/data/test")


local M = {
	NIL = function() end
}



function M.init(key, value)
	log.init(key, value)

	if type(value) == 'table' then
		return M.query(key)
	end
end


local function has_nil(patch)
	for k,v in pairs(patch) do
		if type(v) == "function" then
			local real_v = v()
			if real_v == nil then
				return true
			else
				patch[k] = real_v
			end
		end
	end
	return false
end



function M.update(key, patch)

	if has_nil(patch) then
		local obj = assert(db[key], key)
		log.init(key, obj)
		util.patch(obj, patch)
	else
		log.update(key, patch)
	end
end


function M.delete(key)
	log.delete(key)
end



function M.query(key)
	local value = db[key]
	local t = type(value)

	if t == "table" then
		return setmetatable(value, {__call = function (_, patch)
			M.update(key, patch)
			return value
		end})
	end

	return value
end




return M