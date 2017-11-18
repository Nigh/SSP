
local ship=class("ship",obj)
ship.tag = "ship"

function ship:initialize(name)
	self.name = name or "ship_name"
	self.mass = 20
	self.verts = self.verts or {0,30,30,-30,0,-36,-30,-30}
	self.struct_max = 200
	self.rot=-Pi
	obj.initialize(self)
end

return ship
