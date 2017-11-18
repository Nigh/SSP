
local _={}

-- 广度优先文件夹遍历
local function mods_loader(folder)
	local lfs = love.filesystem
	local filesTable = lfs.getDirectoryItems(folder)
	local n = 0
	while #filesTable>0 do
		for i=#filesTable,1,-1 do
			local name=filesTable[i]
			local file = folder.."/"..name
			-- print(i,name,file)
			if lfs.isFile(file) then
				if file:sub(-4,-1)==".lua" then
					local _ = require(file:sub(1,-5))
					-- assert(_.name, "NAME is NEEDED\nFILE:"..file)
					_.name = _.name or get_filename(file)
					_.path = get_dir(file)
					if _G[_.name] then assert(true,
						"DUPLICATED name:"..'"'.._.name..'"\nFILE:'..file.."\nwith:".._G[_.name].name.." in ".._G[_.name].path)
					end
					print("loading mods [".._.name.."] from "..file.." in ".._.path)
					_G[_.name]=_
					-- _G[name:sub(1,-5)]=require(file:sub(1,-5))
					-- print("require(",file,")")
				end
				table.remove(filesTable,i)
			elseif lfs.isDirectory(file) then
				local _ = lfs.getDirectoryItems(file)
				for __,v in ipairs(_) do
					table.insert(filesTable,name.."/"..v)
					-- print("insert(",name.."/"..v,")")
				end
				table.remove(filesTable,i)
			end
		end
	end
end
function _:init()
	mods_loader("mods/default")
	mods_loader("mods/user")
	-- setmetatable(self, {__index = _G})
	return self
end

return _:init()
