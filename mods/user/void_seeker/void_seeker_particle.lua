return {
	name = "void seeker particle",
	tag = "visual",
	text = "this is a sample visual mod",
	dx = 184,
	dy = 333,
	coord_mode = "relative",
	initialize = function(self)
		self.charge0 = lg.newParticleSystem(love.graphics.newImage( self.path.."circle.png" ),100)
		self.charge0:setParticleLifetime(1.3,1.3)
		self.charge0:setEmissionRate(60)
		self.charge0:setEmitterLifetime(-1)
		self.charge0:setColors(
			100, 150, 255, 0, 
			100, 150, 255, 0, 
			100, 150, 255, 120, 
			255, 255, 255, 200,
			255, 255, 255, 0
		)
		self.charge0:setSizes(0, 0, 0.5, 0.6, 1, 2)
		self.charge0:setSpin( -1,1 )
		self.charge0:setSpread( 2*math.pi )
		self.charge0:setSpeed( 510,540 )
		self.charge0:setLinearDamping(3)
		self.charge0:setRadialAcceleration( -500,-500 )

		self.charge1 = lg.newParticleSystem(love.graphics.newImage( self.path.."circle.png" ),100)
		self.charge1:setParticleLifetime(1.3,1.3)
		self.charge1:setEmissionRate(30)
		self.charge1:setEmitterLifetime(-1)
		self.charge1:setColors(
			100, 150, 255, 0, 
			100, 150, 255, 120, 
			255, 255, 255, 200,
			255, 255, 255, 0
		)
		self.charge1:setSizes(1)
		self.charge1:setSpread( 2*math.pi )
		self.charge1:setSpeed( 130,20 )
		self.charge1:setLinearDamping(0)
		self.charge1:setRadialAcceleration( -150,-150 )

		visual.initialize(self)
	end,
	update=function(self,dt)
		self.charge0:update(dt)
		self.charge1:update(dt)
	end,
	draw=function(self)
		local mode = love.graphics.getBlendMode()
		love.graphics.setBlendMode( "add" )
		lg.draw(self.charge0,self.dx,self.dy)
		lg.draw(self.charge1,self.dx,self.dy)
		love.graphics.setBlendMode( mode )
	end,
}
