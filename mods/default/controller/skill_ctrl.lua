return{
	name = "skill_ctrl",
	tag = "ctrl",
	["1"]={
		['press']=function(self)self.host:pipe("call")end,
	},
}
