
local laser=class("laser",emitter)

laser.tag="laser"

function laser:initialize()
	emitter.initialize(self)
	self.range = self.range or 3000
	self.damage = self.damage or 150
	self.charge_time = self.charge_time or 2
	self.fire_time = self.fire_time or 3
	self.statu = "standby"
	self._ps = classes:new("default_laser_particle")
	self._ps:install_to(self)
	self._hit_ps = classes:new("default_laser_hit_particle")
	self._hit_ps:install_to(self)

	self._t = 0
end

function laser:draw()
	emitter.draw(self)
end

function laser:update(dt)
	if self.statu ~= "standby" then
		self._t = self._t+dt
		self:fire()
	end
	emitter.update(self,dt)
end

function laser:fire()
	if self.statu == "standby" then
		self._ps:charge_effect()
		self.statu = "charge"
		self._t = 0
	elseif self.statu == "charge" then
		if self._t>self.charge_time then
			self._t = 0
			self.statu = "fire"
			self._ps:fire_effect()
		end
	elseif self.statu == "fire" then
		local x0,y0 = self:getXY()
		local rot = self:getROT()
		local dx,dy = math.axisRot(self.edx,self.edy,rot)
		local x1,y1 = x0+dx,y0+dy
		local dx,dy = math.axisRot(0,self.range,rot)
		local x2,y2 = x1+dx,y1+dy
		self._hit_ps:hit_at()
		physics.world:rayCast( x1, y1, x2, y2, 
			function(fixture, x, y, xn, yn, fraction) return self.rayCast_handler(self,fixture, x, y, xn, yn, fraction) end )
		if self._t>self.fire_time then
			self._ps:stop()
			self._hit_ps:stop()
			self.statu = "standby"
		end
	end
end

function laser:install_to(host,func)
	emitter.install_to(self,host,func)
end

function laser:rayCast_handler( fixture, x, y, xn, yn, fraction )
	self._hit_ps:hit_at(x,y,xn,yn)
	self._ps:length(fraction)
	return fraction
end	

return laser
