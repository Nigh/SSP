return{
	name = "fire_ctrl",
	tag = "ctrl",
	["2"]={
		['press']=function(self)self.host:pipe("fire")end,
	},
}
