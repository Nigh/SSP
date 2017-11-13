
local gyro=class("gyro",device)

gyro.name = "gyroscope"
gyro.tag = "gyro"
gyro.state = "standby"
gyro.maxforce = 110
gyro.force = 0
gyro.breakforce = 3
gyro.max_speed = 2.6	-- in radians/second.

gyro.pipe = function(self,com,...)
	arg={...}
	if com=="left_on" then
		self.host.body:setAngularDamping(0)
		self.force = self.force-self.maxforce
	end
	if com=="left_off" then
		self.force = self.force+self.maxforce
		self.host.body:setAngularDamping(self.breakforce)
	end
	if com=="right_on" then
		self.host.body:setAngularDamping(0)
		self.force = self.force+self.maxforce
	end
	if com=="right_off" then
		self.force = self.force-self.maxforce
		self.host.body:setAngularDamping(self.breakforce)
	end
end

gyro.update = function(self,dt)
	device.update(self,dt)
	self.host.body:applyTorque(self.force)
	local vr=self.host.body:getAngularVelocity()
	if math.abs(vr)>self.max_speed then
		self.host.body:applyTorque(-math.sign(vr)*self.maxforce)
	end
end

return gyro
