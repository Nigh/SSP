
local thruster=class("thruster",device)

thruster.tag = "thruster"
thruster.slot = {}

function thruster:initialize()
	self.name = self.name or "thruster"
	self.state = self.state or "standby"
	self.dx = self.dx or 0
	self.dy = self.dy or 0
	self.host = nil
	self.cd = self.cd or 0
	self.cd_set = self.cd_set or 0
	self.rot = self.rot or 0
	self.thrust = self.thrust or 20
	self.breakforce = self.breakforce or 1
	self.cruise_speed = self.cruise_speed or 700
	self.max_speed = self.max_speed or 1000
end

function thruster:pipe(com,...)
	arg={...}
	if com=="throttle_on" then
		self.state = "run"
	end
	if com=="throttle_off" then
		self.state = "standby"
	end
	if com=="break_on" then
		self.host.body:setLinearDamping(self.breakforce)
	end
	if com=="break_off" then
		self.host.body:setLinearDamping(0)
	end
end

function thruster:update(dt)
	device.update(self,dt)
	local vx,vy=self.host.body:getLinearVelocity()
	local vel=math.getNorm(vx,vy)
	if self.state=="run" then
		if vel<self.max_speed then
			self.host.body:applyForce(self.host.body:getWorldVector(0,self.thrust))
		end
	end
	if vel>self.cruise_speed then
		self.host.body:applyForce(-0.3*vx/vel*self.thrust,-0.3*vy/vel*self.thrust)
	end
end
return thruster
