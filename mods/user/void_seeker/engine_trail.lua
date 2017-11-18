return {
	name = "void engine trail",
	tag = "visual",
	text = "this is a sample visual mod",
	initialize = function(self)
		visual.initialize(self)
		self.trail = trail:new({
			type="mesh",
			content={
				type="image",
				width = 8,
				source = love.graphics.newImage(self.path.."circle.png",{mipmaps = true}),
				mode = "stretch"
			},
			duration = 1,
			fade = "grow"
		})
		-- self.trail = trail:new({type="point",content={type = "circle",radius=10},fade="shrink"}):setDuration(2)
	end,
	update=function(self,dt)
		local x,y=self.host:getXY()
		local dx,dy=math.axisRot(self.dx,self.dy,self.host:getROT())
		self.trail:setPosition(x+dx,y+dy)
		if self.host.state=="run" then
			self.trail:setWidth(28):setDuration(10)
		else
			self.trail:setWidth(6):setDuration(4)
		end
		self.trail:update(dt)
	end,
	draw=function(self)
		lg.push()
		lg.origin()
		lg.setColor(10,190,255,220)
		self.camera:draw(function()self.trail:draw()end)
		lg.pop()
	end,
}
