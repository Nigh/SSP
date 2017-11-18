
local classes={}

function get_dir(file)
	local _, i = file:reverse():find('/')
	return string.sub(file, 1, -i)
end

function get_filename(file)
	local _, i = file:reverse():find('/')
	return string.sub(file, 1-i, -5)
end

-- 广度优先文件夹遍历
local function class_loader(folder)
	local lfs = love.filesystem
	local filesTable = lfs.getDirectoryItems(folder)
	local n = 0
	while #filesTable>0 do
		for i=#filesTable,1,-1 do
			local name=filesTable[i]
			local file = folder.."/"..name
			-- print(i,name,file)
			if lfs.isFile(file) then
				local _ = require(file:sub(1,-5))
				_.name = _.name or get_filename(file)
				_.path = get_dir(file)
				if _G[_.name] then assert(true,
					"DUPLICATED name:"..'"'.._.name..'"\nFILE:'..file.."\nwith:".._G[_.name].name.." in ".._G[_.name].path)
				end
				print("loading class [".._.name.."] from "..file.." in ".._.path)
				_G[_.tag]=_
				-- _G[name:sub(1,-5)]=require(file:sub(1,-5))
				-- print("require(",file,")")
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

function classes:init()
	class_loader("classes")
	-- setmetatable(self, {__index = _G})
	return self
end

function classes:new(prop)
	if type(prop)=="string" then prop=_G[prop] end
	print("classes:new[".. prop.name .."]")
	if prop and _G[prop.tag] then
		local _=class(prop.name,_G[prop.tag])
		_:include(prop)
		_:include({uid=uid(prop.tag)})
		local _=_:new(_.name)
		return _
	end
	assert(not prop, "input a empty instance")
	assert(not _G[prop.tag], prop.tag.."is NOT a valid class")
end

return classes:init()
