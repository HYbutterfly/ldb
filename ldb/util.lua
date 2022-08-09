local util = {}


local function split(str, sep)
    local splits = {}
    
    if sep == nil then
        table.insert(splits, str)
    elseif sep == "" then
        local len = #str
        for i = 1, len do
            table.insert(splits, str:sub(i, i))
        end
    else
        local pattern = "[^" .. sep .. "]+"
        for str in string.gmatch(str, pattern) do
            table.insert(splits, str)
        end
    end
    
    return splits
end


local function patch_real_value(v)
	if type(v) == "function" then
		return v()
	else
		return v
	end
end


function util.patch(obj, patch)
	for k,v in pairs(patch) do
		if k:find("%.") then
			local t = obj
			local path = split(k)
			for i=1,#path-1 do
				t = assert(t[path[i]], string.format("invalid update, not found path:%s in object('%s')", k, key))
			end
			t[path[#path]] = patch_real_value(v)
		else
			obj[k] = patch_real_value(v)
		end
	end
end



return util