local resource = {}
local unit
function resource:init(ui)
	self.ui = ui
	self.ship = ui.ship
	self.hud = ui.hud
	self.color = ui.color
	unit = self.ui.unit
	self.x = w()-51*unit
	self.y = unit
	self.w = 50*unit 
	self.h = 4*unit
	return self
end

function resource:update(dt)
	suit.Panel(self.x,self.y,self.w,self.h)
end



function resource:draw()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle("fill", self.x+unit, self.y+unit, 15, 15)
	love.graphics.setColor(100, 100, 100, 255)
	love.graphics.rectangle("line", self.x+unit, self.y+unit, 15, 15)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("R: 21801", self.x+3*unit, self.y+unit+1)

	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.rectangle("fill", self.x+unit*10, self.y+unit, 15, 15)
	love.graphics.setColor(100, 100, 100, 255)
	love.graphics.rectangle("line", self.x+unit*10, self.y+unit, 15, 15)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("G: 21801", self.x+12*unit, self.y+unit+1)

	love.graphics.setColor(0, 0, 255, 255)
	love.graphics.rectangle("fill", self.x+unit*20, self.y+unit, 15, 15)
	love.graphics.setColor(100, 100, 100, 255)
	love.graphics.rectangle("line", self.x+unit*20, self.y+unit, 15, 15)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("B: 21801", self.x+22*unit, self.y+unit+1)

	love.graphics.setColor(255, 0, 255, 255)
	love.graphics.rectangle("fill", self.x+unit*30, self.y+unit, 15, 15)
	love.graphics.setColor(100, 100, 100, 255)
	love.graphics.rectangle("line", self.x+unit*30, self.y+unit, 15, 15)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("P: 21801", self.x+32*unit, self.y+unit+1)

	love.graphics.setColor(255, 255, 0, 255)
	love.graphics.rectangle("fill", self.x+unit*40, self.y+unit, 15, 15)
	love.graphics.setColor(100, 100, 100, 255)
	love.graphics.rectangle("line", self.x+unit*40, self.y+unit, 15, 15)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Y: 21801", self.x+42*unit, self.y+unit+1)
end


return resource