return{
	name = "blink_X1",
	tag = "uni",
	host = nil,
	cd_set = 5,
	pipe=function(self,com,...)
		arg={...}
		print(com,unpack(arg))
		if com=="call" then
			self:selector("circle",300)
		end
		if com=="xy" then					-- 接收到xy命令，移动宿主至传输的坐标，并开始CD
			self.host:setXY(arg[1],arg[2])
			self.cd = self.cd_set
		end
	end,
}
