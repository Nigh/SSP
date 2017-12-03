return{
	name = "laser_X1",
	tag = "laser",
	host = nil,
	cd_set = 5,
	dx = -20,
	dy = -50,
	range = 3000,
	tex = "emitter.png",
	pipe=function(self,com,...)
		arg={...}
		if com=="fire" then
			self:fire()
		end
	end,
}
