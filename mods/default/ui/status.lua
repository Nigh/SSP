local status = {}
local unit
function status:init(ui)
	self.ui = ui
	self.ship = ui.ship
	self.hud = ui.hud
	self.color = ui.color
	unit = self.ui.unit
	self.panel = {x = 10,y = h()-10-unit*20,w = unit*35,h=unit*20 }
	self.miniship = {x = 10+ unit, y =h()-10-unit*20+unit, w = unit*10,h = unit*10, obj = self.hud.ship }
	self.buff = {x = 10+ unit, y =h()-10-unit*10+5*unit, w = unit*4, h = unit*4}
	self.bar = {offx = 6*unit, offy = unit*3, x = 10+ 12*unit, y= h()-10-unit*18,w = unit*15 ,h = unit*1.5}
	return self
end

function status:update(dt)
	local panel = self.panel
	suit.Panel(panel.x,panel.y,panel.w,panel.h)
	local buff = self.buff
	for i = 1,8 do
		suit.Button("buff\n"..i,buff.x + (i-1)*(buff.w+2),buff.y,buff.w,buff.h)
	end
end

function status:draw()
	if self.ship.destroyed then return end
	local ship = self.miniship
	love.graphics.setColor(self.color.normal.fg)
	love.graphics.rectangle("line", ship.x, ship.y, ship.w, ship.h)
	love.graphics.push()
	love.graphics.translate(ship.x + ship.w/2,ship.y+ship.h/2)

	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("-Y", -ship.w/2, -ship.h/2,ship.w,"center")
	love.graphics.printf("+Y", -ship.w/2, ship.h/2 -love.graphics.getFont():getHeight(),ship.w,"center")
	love.graphics.print("-X", -ship.w/2, -love.graphics.getFont():getHeight()/2)
	love.graphics.print("+X", ship.w/2 -love.graphics.getFont():getWidth("+X") , -love.graphics.getFont():getHeight()/2)
	love.graphics.setColor(self.color.normal.bg)
	love.graphics.line(-ship.w/2, 0, ship.w/2, 0)
	love.graphics.line(0, -ship.h/2, 0, ship.h/2)
	love.graphics.circle("line", 0, 0, ship.w/2)

	love.graphics.setColor(255, 10, 155, 255)
	local vx,vy = ship.obj.body:getLinearVelocity()
	local angle = math.getRot(vx,vy,0,0)
	love.graphics.circle("fill", -math.sin(angle)*ship.w/2, math.cos(angle)*ship.w/2,3)
	love.graphics.rotate(ship.obj.angle)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.outlinePolygon(ship.obj.verts,unit*2)
	
	love.graphics.pop()

	love.graphics.printf(string.format(lang.coord..": %2d,%2d",ship.obj.x,ship.obj.y),ship.x,ship.y+ship.h+unit,ship.w+unit*3,"center")
	love.graphics.printf(string.format(lang.speed..": %2d,%2d",vx,vy),ship.x + ship.w+unit*5,ship.y+ship.h+unit,ship.w+unit*3,"center")
	local bar = self.bar
	love.graphics.print(lang.struct, bar.x,bar.y )
	love.graphics.print(lang.energy, bar.x,bar.y + bar.offy )
	love.graphics.print(lang.heat, bar.x,bar.y + bar.offy*2)

	local player = self.ship
    love.graphics.setColor(50, 255, 50, 50)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y, bar.w, bar.h)
    love.graphics.setColor(50, 255, 50, 255)
    love.graphics.rectangle("fill", bar.x + bar.offx, bar.y, bar.w*player.struct/player.struct_max ,bar.h)
 
    love.graphics.setColor(255, 55, 250, 50)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy, bar.w, bar.h)
    love.graphics.setColor(255, 55, 250, 255)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy, bar.w*player.energy/player.energy_max, bar.h)
    love.graphics.setColor(100, 100, 100, 255)
    love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy, bar.w*player.energy_occupied/player.energy_max, bar.h)
    love.graphics.setColor(255, 255, 0, 50)
    --love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy*2, bar.w, bar.h)
    --love.graphics.setColor(255, 255, 0, 255)
    --love.graphics.rectangle("fill", bar.x + bar.offx , bar.y + bar.offy*2, bar.w*player.heat/player.heat_max,bar.h)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf(string.format("%3d/%3d",player.struct,player.struct_max),
     bar.x + bar.offx , bar.y , bar.w,"center")
    love.graphics.printf(string.format("%3d/%3d/%3d",player.energy_occupied,player.energy-player.energy_occupied,player.energy_max),
    	bar.x + bar.offx , bar.y + bar.offy, bar.w,"center")
    --love.graphics.printf(string.format("%3d/%3d",player.heat,player.heat_max),
    --	bar.x + bar.offx , bar.y + bar.offy*2, bar.w,"center")
end


return status