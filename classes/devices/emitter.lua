
local emitter=class("emitter",device)

emitter.tag="emitter"

function emitter:initialize()
	device.initialize(self)
	self.name = self.name or "weapon_name"
	self.verts = self.verts or {0,-10,-10,0,-2,8,-2,18,2,18,2,8,10,0}
	self.tex = self.tex or nil
	self.edx = self.edx or 0	-- 发射口相对坐标
	self.edy = self.edy or 0
	if self.tex then
		self.tex_pic=lg.newImage(self.path..self.tex,{mipmaps = true})
		self.tex_draw=function(self)
			lg.draw(self.tex_pic,self.dx,self.dy,self.rot)
		end
	end
end

function emitter:draw()
	if self.tex_draw then self:tex_draw() else lg.outlinePolygon(self.verts,1,color.obj_fill,color.obj_line) end
	device.draw(self)
end

function emitter:update(dt)
	device.update(self,dt)
end

return emitter
