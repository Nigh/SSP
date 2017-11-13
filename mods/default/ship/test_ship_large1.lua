return {
	name = "test_ship_L1",
	tag = "ship",
	mass = 2000,
	text = "this is a test ship",
	verts = {
		-3,-40,-3,0,-30,-60,-30,-120,-25,-125,-25,-130,-70,-200,-70,-250,-50,-210,-20,-265,-10,-270,-4,-240,
		4,-240,10,-270,20,-265,50,-210,70,-250,70,-200,25,-130,25,-125,30,-120,30,-60,3,0,3,-40,
	},
	struct_max = 20000,
	initialize=function(self)
		ship.initialize(self)
		for i,v in ipairs(self.verts) do
			self.verts[i]=self.verts[i]*3
		end
	end,
}
