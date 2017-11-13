local map = {}
local unit
function map:init(ui)
	self.ui = ui
	self.ship = ui.ship
	self.hud = ui.hud
	self.color = ui.color
	unit = self.ui.unit
	self.x = w()-22*unit-10
	self.y = h()-10-22*unit
	self.w = 22*unit
	self.h = 22*unit
	return self
end

function map:update(dt)
	suit.Panel(self.x,self.y,self.w,self.h)
end

function map:draw()
	if not self.ship.data.visual_radius then return end
	local ship = self.ship
	local world_w = ship.data.visual_radius*2
	local fire_ctrl_w = ship.data.fire_ctrl_radius or 1000
	love.graphics.push()
	love.graphics.setLineWidth(1)
	love.graphics.translate(self.x + self.w/2, self.y + self.h/2)
	love.graphics.setColor(self.color.normal.bg)
	love.graphics.line(-self.w/2, 0, self.w/2, 0)
	love.graphics.line(0, -self.h/2, 0, self.h/2)
	love.graphics.circle("line", 0, 0, self.w*fire_ctrl_w/world_w/2)
	love.graphics.setColor(255, 0, 0, 255)
	
	for i,tar in ipairs(ship.data.world.visual) do
		local x,y = tar.x - ship.x, tar.y - ship.y
		if tar.tag == "ship" then
			love.graphics.circle("fill", x*self.w/world_w, y*self.h/world_w, 2)
		end
	end

	love.graphics.pop()
end


return map