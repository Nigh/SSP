local frag={}
function math.axisRot_P(x,y,x1,y1,rot)
  x=x -x1
  y=y- y1
  local xx=math.cos(rot)*x-math.sin(rot)*y
  local yy=math.cos(rot)*y+math.sin(rot)*x
  return xx+x1,yy+y1
end



function frag:init(x,y,rot,canvas)	
	local new={}
	setmetatable(new,self)
	self.__index=self
	new.during=3
	new.life=new.during
	new.speed=0.1
	new.selfRot=0
	new.rate=4
	new.canvas=canvas
	new.quads={}
	new.sw=canvas:getWidth()
	new.sh=canvas:getHeight()
	new.sizeX=new.sw/new.rate
	new.sizeY=new.sh/new.rate
	new.x=x
	new.y=y
	new.rot=rot
	new:separate()
	new:setSpeed()
	return new
end

function frag:separate()
	for x= 1,self.rate do
		self.quads[x]={}
		for y= 1,self.rate do
			self.quads[x][y]  = love.graphics.newQuad((x-1)*self.sizeX,(y-1)*self.sizeY,
												self.sizeX, self.sizeY, self.sw, self.sh)
		end
	end
end

function frag:setSpeed()
	self.qX={}
	self.qY={}
	self.qSpeedX={}
	self.qSpeedY={}
	self.qSRot={}
	self.qSRotSpeed={}
	for x= 1,self.rate do
		self.qSpeedX[x]={}
		self.qSpeedY[x]={}
		self.qSRotSpeed[x]={}
		self.qSRot[x]={}
		self.qX[x]={}
		self.qY[x]={}

		for y= 1,self.rate do
			self.qSRotSpeed[x][y] = love.math.random()*0.03
			self.qSRot[x][y] = 0
			self.qX[x][y]=self.x-self.sw/2+self.sizeX*x-0.5*self.sizeX
			self.qY[x][y]=self.y-self.sh/2+self.sizeY*y-0.5*self.sizeY
			self.qX[x][y],self.qY[x][y]=math.axisRot_P(self.qX[x][y],self.qY[x][y],self.x,self.y,self.rot)
			self.qSpeedX[x][y]=(self.qX[x][y]-self.x)*self.speed*love.math.random()
			self.qSpeedY[x][y]=(self.qY[x][y]-self.y)*self.speed*love.math.random()			
			self.qSRot[x][y] = self.rot
		end
	end	

end

function frag:update(dt)
	self.life=self.life -dt
	if self.life<0 then self.destroyed=true end
	for x= 1,self.rate do
		for y= 1,self.rate do
			self.qX[x][y]=self.qX[x][y]+self.qSpeedX[x][y]
			self.qY[x][y]=self.qY[x][y]+self.qSpeedY[x][y]
			self.qSRot[x][y]=self.qSRot[x][y]+self.qSRotSpeed[x][y]		
		end
	end	
end


function frag:draw(offx,offy)
	offx=offx or 0
	offy=offy or 0
	love.graphics.setColor(255, 255, 255, 255*self.life/self.during)
	for x= 1,self.rate do
		for y= 1,self.rate do
			love.graphics.draw(self.canvas, self.quads[x][y],self.qX[x][y]+offx, self.qY[x][y]+offy, self.qSRot[x][y],1,1,self.sizeX/2,self.sizeY/2)			
		end
	end
end

return frag