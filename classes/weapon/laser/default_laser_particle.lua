
local dlp=class("default_laser_particle",visual)

dlp.tag="default_laser_particle"

function dlp:initialize()
	visual.initialize(self)
	self.name = self.name or "default laser particle"
	self.text = self.text or "this is a sample visual mod"
	self.dx = self.dx or 0
	self.dy = self.dy or 0
	self.frac = 1
	self.ER = 100
	self.ps = lg.newParticleSystem(love.graphics.newImage( self.class_path.."default_particle1.png" ),3300)
	self.ps:stop()
	-- self.ps:setParticleLifetime(3,5)
	-- self.ps:setEmissionRate(1600)
	-- self.ps:setColors(
	-- 	100, 150, 255, 0, 
	-- 	100, 150, 255, 120, 
	-- 	255, 255, 255, 200,
	-- 	200, 0, 0, 40,
	-- 	200, 0, 0, 0
	-- )
	-- self.ps:setSizes(1, 1, 0.6, 0.1, 1.5, 0, 0)
	-- self.ps:setSpin(-2,2)
	-- self.ps:setLinearDamping(0.5)
	self.ps:setLinearAcceleration( 0, 0 )
	self.ps:setSpeed(0)
	self.ps:setRadialAcceleration(0)
	self.ps:setTangentialAcceleration(0)
end

function dlp:install_to(host,func)
	visual.install_to(self,host,func)
end


function dlp:draw()
	local r,g,b,a = lg.getColor()
	local mode = love.graphics.getBlendMode()
	lg.setBlendMode( "add" )
	lg.setColor(255,255,255,255)
	lg.draw(self.ps,self.dx,self.dy)
	-- lg.circle("fill",self.dx,self.dy,30)
	lg.setBlendMode( mode )
	lg.setColor(r,g,b,a)
end

function dlp:length(frac)
	self.frac = frac
	-- print("frac",frac)
	-- self.ps:setOffset( 20, -0.5*self.host.range*self.frac )
	self.ps:setAreaSpread( "uniform", 0, 0.5*self.host.range*self.frac )
	self.ps:setEmissionRate(self.ER*self.frac)
end

function dlp:update(dt)
	self.ps:update(dt)
	-- if self.ps:getCount()==0 then
		-- self:_del()
	-- end
end

function dlp:charge_effect()
	self:length(1)
	print("range",self.host.range)
	self.ps:setRadialAcceleration(-100,0)
	self.ps:setLinearDamping(1)
	self.ps:setTangentialAcceleration(-20,20)
	self.ps:setSizes(1)
	self.ps:setColors(
		100, 150, 255, 0, 
		100, 150, 255, 100,
		200, 0, 0, 40,
		200, 0, 0, 0
	)
	self.ps:setParticleLifetime(5,5)
	self.ER = 400
	self.ps:setEmissionRate(self.ER)
	self.ps:start()
end

function dlp:fire_effect()
	self:length(1)
	print("range",self.host.range)
	self.ps:setLinearAcceleration(0,0)
	self.ps:setSpeed(0,20)
	-- self.ps:setRadialAcceleration(-2,2)
	-- self.ps:setLinearDamping(5)
	-- self.ps:setTangentialAcceleration(-100,100)
	self.ps:setColors(
		100, 150, 255, 0, 
		100, 150, 255, 0, 
		255, 255, 255, 200,
		200, 0, 0, 40,
		200, 0, 0, 0
	)
	self.ps:setSizes(1)
	self.ps:setParticleLifetime(0.1,2)
	self.ER = 4000
	self.ps:setEmissionRate(self.ER)
	self.ps:start()
end

function dlp:stop()
	self.ps:stop()
end

function dlp:particle()
	return self.ps
end

return dlp
