
local objects = class('objects')
objects.tag = "obj"

function objects:initialize(name)
	self.name = name or "obj_name"
	self.physic = true
	self.scale = self.scale or 1
	self.ddx = self.ddx or 0
	self.ddy = self.ddy or 0
	self.mass = self.mass or 10
	self.rot = self.rot or -Pi
	self.x = self.x or 0
	self.y = self.y or 0
	self.verts = self.verts or {0,0,20,0,20,20,0,20,0,0}
	self.tex = self.tex or nil
	self.slot = {}
	self.linear_damping = 0.1		-- 线性阻尼，安装引擎会消除阻尼
	if self.tex then
		self.tex_pic=lg.newImage(self.path..self.tex,{mipmaps = true})
		self.tex_draw=function(self)
			lg.draw(self.tex_pic,0,0,0,self.scale,nil,self.ddx/self.scale,self.ddy/self.scale)
		end
	end
end

function objects:physic_init()
	self.body:setAngle(self.rot)
	self.body:setLinearDamping(self.linear_damping)
	-- self.body:setMass(self.mass)
	self.body:setUserData(self)
end

function objects:draw()
	lg.push()
	lg.translate(self.x,self.y)
	lg.rotate(self.rot)
	lg.setColor(255, 255, 255, 255)
	if self.tex then
		self:tex_draw()
	else
		lg.outlinePolygon(self.verts,1,color.obj_fill,color.obj_line)
	end
	for i,v in ipairs(self.slot) do if v.draw then v:draw() end end
	lg.pop()
end

function objects:update(dt)
	if self.body then
		self.x,self.y=self:getXY()
		self.rot=self.body:getAngle()
	end
	for i,v in pairs(self.slot) do v:update(dt) end
end

-- 转换材质原始坐标到质心坐标
function objects:toRealXY(x,y)
	print(x,self.scale,self.ddx)
	return x*self.scale-self.ddx,y*self.scale-self.ddy
end

function objects:setXY(x,y)
	self.body:setPosition(x,y)
end

function objects:getXY()
	return self.body:getPosition()
end

function objects:setROT(rot)
	self.body:setAngle(rot)
end

function objects:getROT()
	return self.body:getAngle()
end

return objects
