
local visual=class("visual")

visual.tag="visual"

function visual:initialize()
	self.slot = {}
	self.dx = self.dx or 0
	self.dy = self.dy or 0
	self.host = nil
end

function visual:update(dt)

end

function visual:draw()

end

function visual:install_to(host,func)
	table.insert(host.slot, self)
	self.host = host
	if func then func(self) end
end

function visual:install_with_cam(host,cam,func)
	self:install_to(host,func)
	self.camera = cam
end

function visual:setDelta(dx,dy)
	self.dx,self.dy = dx,dy
end

return visual
