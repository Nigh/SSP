
local universal=class("universal",device)

universal.tag = "uni"
function universal:initialize()
	device.initialize(self)
	self.name = self.name or "universal"
	self.state = ""
	self.cd = self.cd or 3
end


function universal:pipe(com,...)
	arg={...}
end
function universal:update(dt)
	device.update(self,dt)
end

return universal
