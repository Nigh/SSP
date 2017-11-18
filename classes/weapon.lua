
local weapon=class("weapon",device)

weapon.tag="weapon"

weapon.update = function(self,dt)
	device.update(self,dt)
end

return weapon
