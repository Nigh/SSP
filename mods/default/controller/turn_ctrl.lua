return{
	name = "turn_ctrl",
	tag = "ctrl",
	["a"]={
		['press']=function(self)self.host:pipe("left_on")end,
		['release']=function(self)self.host:pipe("left_off")end,
	},
	["d"]={
		['press']=function(self)self.host:pipe("right_on")end,
		['release']=function(self)self.host:pipe("right_off")end,
	},
}
