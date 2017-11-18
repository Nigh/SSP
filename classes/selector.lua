
local selector=class("selector")

selector.tag = "selector"

function selector:initialize()
	self.name = "default selector"
	self.state = ""
	self.host = nil
	self.rot = 0
	self.keyboard = {}
	self.arg={}
	self.radius = 500
	self.slot = {}
	self.vmx=0		-- 光标有效位置
	self.vmy=0
	self.pmx=0		-- 光标物理位置
	self.pmy=0
	self.dx=0		-- 安装偏移
	self.dy=0
	self.ddx=0		-- 绘制偏移
	self.ddy=0
end

-- function selector:update(self,dt)
-- end

selector.draw = function(self)
	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.circle("line", 0, 0, self.radius)
	love.graphics.setColor(155, 255, 155, 200)
	love.graphics.circle("line", self.ddx, self.ddy, 10)
end

function selector:bind(who)
	if who=="mouse" then
		self.update = self.mouseFunc
	elseif who=="keyboard" then
		self.update = self.keyboardFunc
	end
end

function selector:getXY()
	if self.host then
		local x,y = self.host:getXY()
		local dx,dy = math.axisRot(self.dx,self.dy,self.host:getROT())
		return x+dx,y+dy
	else
		return 0,0
	end
end

function selector:getROT()
	if self.host then
		return self.rot+self.host:getROT()
	else
		return 0
	end
end


function selector:delete(index)
	self.host.slot[index] = nil
end

function selector:mouseFunc(dt)
end

function selector:keyboardFunc(dt)
end

return selector
