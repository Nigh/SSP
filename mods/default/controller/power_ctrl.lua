return{
	name = "power_ctrl",
	tag = "ctrl",
	["w"]={
		['press']=function(self)self.host:pipe("throttle_on")end,
		['release']=function(self)self.host:pipe("throttle_off")end,
	},
	["s"]={
		['press']=function(self)self.host:pipe("break_on")end,
		['release']=function(self)self.host:pipe("break_off")end,
	},
}

-- TODO: 固化一个通用的仅用于控制推进器和动量轮的控制器
