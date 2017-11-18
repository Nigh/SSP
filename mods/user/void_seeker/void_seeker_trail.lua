return {
	name = "void seeker trail",
	tag = "visual",
	text = "this is a sample visual mod",
	trail = {},
	initialize = function(self)
		visual.initialize(self)
		table.insert(self.trail,trail:new({type="point",content={type = "circle",radius=10},fade="shrink"}):setDuration(2))
	end,
	update=function(self,dt)
		for i,v in ipairs(self.trail) do
			local x,y=self.host:getXY()
			local dx,dy=math.axisRot(self.dx,self.dy,self.host:getROT())
			v:setPosition(x+dx,y+dy)
			v:update(dt)
		end
	end,
	draw=function(self)
		lg.push()
		lg.origin()
		lg.setColor(10,190,255,120)
		for i,v in ipairs(self.trail) do
			self.camera:draw(function()v:draw()end)
		end
		lg.pop()
	end,
}
