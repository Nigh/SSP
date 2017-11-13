
local base={}

function base:init()
	objects=require("base.objects")
	ship=require("base.ship")
	asteroid=require("base.asteroid")

	device=require("base.device")
	uni=require("base.universal")
	thruster=require("base.thruster")
	gyro=require("base.gyroscope")
	weapon=require("base.weapon")

	selector=require("base.selector")
	ctrl=require("base.controller")
	setmetatable(self, {__index = _G})
	return self
end

function base:new(prop)
	if prop and self[prop.tag] then
		local _=class(prop.name,self[prop.tag])
		_:include(prop)
		_:include({uid=uid(prop.tag)})
		local _=_:new(_.name)
		return _
	end
end

return base:init()
