
local gyro=class("gyro",device)
gyro.tag = "gyro"

function gyro:initialize()
	self.name = self.name or "gyroscope"
	self.state = self.state or "standby"
	self.maxforce = self.maxforce or 110
	self.force = 0
	self.slot = {}
	self.breakforce = self.breakforce or 3
	self.max_speed = self.max_speed or 2.6	-- in radians/second.
	self.cd = 0
	self.cd_set = 0
end

function gyro:pipe(com,...)
	print(com)
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

function gyro:update(dt)
	device.update(self,dt)
	local vr=self.host.body:getAngularVelocity()
	local force = self.force
	if math.sign(vr)~=math.sign(force) then force = force*2 end
	self.host.body:applyTorque(force)
	if math.abs(vr)>self.max_speed then
		self.host.body:applyTorque(-math.sign(vr)*self.maxforce)
	end
end

return gyro
