
local device=class("device")


function device:initialize()
	self.slot = {}
	self.dx = 0
	self.dy = 0
	self.host = nil
	self.cd = 0
	self.cd_set = 0
	self.rot = 0
end

function device:update(dt)
	for i,v in pairs(self.slot) do
		v:update(dt)
		if v.gc then self.slot[i] = nil end
	end
	self:cool_down(dt)
end

function device:draw()
	for i,v in pairs(self.slot) do v:draw() end
end

function device:cool_down(dt)
	if self.cd>0 then self.cd = self.cd-dt end
end

function device:_selector(name,...)
	local _=class(name,selector)
	_:include({arg=arg,uid=uid(_.tag)})
	local _=_:new(name)
	self:install(_)
	print(self,#self.slot,_)
	_:bind("mouse")
	return
end

function device:selector(name,...)
	local _=class(name,selector)
	_:include(require("mods.default.selector."..name))
	_:include({arg=arg,uid=uid(_.tag)})
	local _=_:new(name)
	self:install(_)
	_:bind("mouse")
	return
end

function device:install(mod,func)
	mod.host = self
	table.insert(self.slot, mod)
	if func then func(mod) end
	-- setmetatable(mod, {__index = self})
end

function device:install_to(host,func)
	table.insert(host.slot, self)
	self.host = host
	if func then func(self) end
	-- setmetatable(self, {__index = host})
end

function device:delete(index)
	self.host.slot[index] = nil
end

function device:getXY()
	if self.host and self.host.x and self.host.y then
		return self.host.x+self.dx,self.host.y+self.dy
	else
		return 0,0
	end
end

function device:getROT()
	if self.host then
		return self.rot+self.host:getROT()
	else
		return 0
	end
end


return device
