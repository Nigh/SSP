
local weapon=class("weapon",device)

weapon.update = function(self,dt)
	device.update(self,dt)
end

return weapon
