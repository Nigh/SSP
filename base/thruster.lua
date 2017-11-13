
local thruster=class("thruster",device)
thruster.name = "thruster"
thruster.tag = "thruster"
thruster.state = "standby"
thruster.thrust = 20
thruster.breakforce = 1
thruster.cruise_speed = 700
thruster.max_speed = 1000
thruster.slot = {}
thruster.pipe = function(self,com,...)
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
