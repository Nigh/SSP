return{
	name = "blink_X2",
	tag = "uni",
	host = nil,
	cd_set = 1,
	pipe=function(self,com,...)
		arg={...}
		if com=="call" then
			self:selector("circle",3000)
		end
		if com=="xy" then
			self.host.x = arg[1]
			self.host.y = arg[2]
			self.cd = self.cd_set
		end
	end
}
