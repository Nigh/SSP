local exp = {}
local lifeMax = 3
local lv = 100
function exp:init()
	self.lines = {}
	return self
end

function exp:add(x,y,angle,verts,scale,color)
	color = color or {love.graphics.getColor()}
	local verts = math.polygonTrans(x,y,angle,scale,verts)
	for i = 1, #verts,2 do
		local line = {
			verts[i],verts[i+1],
			verts[i+2] or verts[1],verts[i+3] or verts[2],
		}
		local vx,vy = love.math.random(-lv,lv),love.math.random(-lv,lv)
		table.insert(self.lines,{
			line = line,
			vx = vx,vy = vy,
			life = lifeMax, color = color
			})
	end
end


function exp:update(dt)

	local newline = {}
	for i, obj in ipairs(self.lines) do
		obj.life = obj.life - dt
		if obj.life > 0 then
			local line = obj.line
			line[1],line[2] = line[1] + obj.vx*dt, line[2]+ obj.vy*dt
			line[3],line[4] = line[3] + obj.vx*dt, line[4]+ obj.vy*dt
			table.insert(newline,obj)
		end
	end
end


function exp:draw()
	
	for i, obj in ipairs(self.lines) do
		local color = obj.color
		love.graphics.setColor(color[1], color[2], color[3], color[4]*obj.life/lifeMax)
		love.graphics.line(obj.line)
	end
end

return exp