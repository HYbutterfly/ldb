local db = require "ldb"


local function NIL()
end


local function dump(t)
	if type(t) == "table" then
		for k,v in pairs(t) do
			print(k,v)
		end
	else
		print(tostring(t))
	end
end



local u = db.query("user01") or db.init("user01", {id = 1, nick = "windy", todo = {"study", "game", "sleep"}, redundant = "hello world"})


if u.redundant then
	u{
		nick = "cloud",  		-- new nick 
		redundant = NIL 		-- set nil
	}
end

dump(u)


db.delete("user01")