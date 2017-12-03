
local device=class("device")
device.tag = "device"

function device:initialize()
	self.slot = self.slot or {}
	self.dx = self.dx or 0
	self.dy = self.dy or 0
	self.host = self.host or nil
	self.cd = self.cd or 0
	self.cd_set = self.cd_set or 0
	self.rot = self.rot or 0
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
	local _ = classes:new(name,...)
	_.uid=uid(_.tag)
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
	if self.host then
		local x,y = self.host:getXY()
		local dx,dy = math.axisRot(self.dx,self.dy,self.host:getROT())
		return x+dx,y+dy
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
