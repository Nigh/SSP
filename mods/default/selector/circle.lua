return{
	name = "circle",
	tag = "selector",
	radius = 500,
	mouseFunc=function(self,dt)
		self.pmx, self.pmy = love.mouse.getXY()
		local x,y = self:getXY()
		local dx,dy = self.pmx-x, self.pmy-y
		local r = (dx^2+dy^2)^0.5
		if r>self.radius then
			local k = self.radius/r
			self.vmx,self.vmy = x+dx*k,y+dy*k
			self.ddx,self.ddy = math.axisRot(dx*k,dy*k,-self:getROT())
		else
			self.vmx,self.vmy = x+dx,y+dy
			self.ddx,self.ddy = math.axisRot(dx,dy,-self:getROT())
		end
		if love.mouse.isDown(1) then
			self.host:pipe("xy",self.vmx,self.vmy)
			self.gc = true
		end
	end
}
