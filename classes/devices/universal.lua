
local universal=class("universal",device)

universal.name = "universal"
universal.tag = "uni"
universal.state = ""
universal.cd = 3
universal.cd_set = 3
universal.host = nil
universal.slot = {}

universal.pipe = function(self,com,...)
	arg={...}
end
universal.update = function(self,dt)
	device.update(self,dt)
end

return universal
