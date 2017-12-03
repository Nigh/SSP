
local dlp=class("default_laser_hit_particle",visual)

dlp.tag="default_laser_hit_particle"

function dlp:initialize()
	visual.initialize(self)
	self.name = self.name or "default laser hit"
	self.text = self.text or "this is a sample visual mod"
	self.coord_mode = "absolute"
	self.dx = self.dx or 0
	self.dy = self.dy or 0
	self.x = self.x or 0
	self.y = self.y or 0
	self.ps = lg.newParticleSystem(love.graphics.newImage( self.class_path.."default_particle1.png" ),80)
	self.ps:stop()
	self.ps:setParticleLifetime(0.4,0.8)
	self.ps:setEmissionRate(100)
	self.ps:setColors(
		200, 150, 255, 120,
		255, 155, 155, 200,
		0, 0, 255, 40,
		0, 0, 255, 0
	)
	self.ps:setSizes(0.7, 1.2, 0.6, 0.1, 0)
	self.ps:setSpin( -Pi,Pi )
	self.ps:setSpeed( 1200, 2000 )
	self.ps:setSpread( 2 )
	self.ps:setLinearDamping(5)
	self.ps:setEmitterLifetime(-1)
end

function dlp:hit_at(x,y,nx,ny)
	if not x or not y then
		self.ps:stop()
	else
		self.ps:setPosition(x,y)
		self.ps:setDirection(math.atan2(nx,ny))
		self.ps:start()
	end
end

function dlp:stop()
	self.ps:stop()
end

function dlp:draw()
	local r,g,b,a = lg.getColor()
	local mode = love.graphics.getBlendMode()
	lg.setBlendMode( "add" )
	lg.setColor(255,255,255,255)
	lg.push()
	lg.origin()
	global_camera:draw(function()lg.draw(self.ps,0,0)end)
	lg.pop()
	lg.setBlendMode(mode)
	lg.setColor(r,g,b,a)
end

function dlp:update(dt)
	self.ps:update(dt)
end

function dlp:particle()
	return self.ps
end

return dlp
