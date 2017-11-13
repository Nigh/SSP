
-- return the rule of the physic world

local collision={}

local world={collision=collision}

local function begin(a,b,coll)
	local objA=a:getBody():getUserData()
	local objB=b:getBody():getUserData()
	if objA.tag == "ship" and objB.tag == "ship" then
		print("ship hit ship")
		return
	end
	-- 	coll:setEnabled(false)
	-- 	return 
	-- end
	-- if objA.tag == "bullet" and objB.tag == "bullet" then
	-- 	coll:setEnabled(false)
	-- 	return
	-- end

	-- if objA.tag == "missile" and objB.tag == "bullet" then
	-- 	objA:destory()
	-- 	objB:destroy()
	-- 	return
	-- end

	-- if (objA.tag == "bullet" or objA.tag == "missile") and objB.tag == "ship" then
	-- 	objA:hit(objB)
	-- end
end

local function pre(a,b,coll)
	-- local objA=a:getUserData()
	-- local objB=b:getUserData()
	-- if objA.ship == objB  or objB.ship == objA then
	-- 	coll:setEnabled(false)
	-- 	return
	-- end
end

local function post(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

local function endC(a,b,coll)
end

function collision.begin(a,b,coll)
	begin(a,b,coll)
	begin(b,a,coll)
end

function collision.leave(a,b,coll)
	endC(a,b,coll)
	endC(b,a,coll)
end

function collision.pre(a,b,coll)
	pre(a,b,coll)
end

function collision.post(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	post(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	post(b, a, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

function world:init()
	self.objs = {}
	self.objs_index = {}
	love.physics.setMeter(200)
	self.physics_world = love.physics.newWorld(0, 0, true)
	self.physics_world:setCallbacks(collision.begin,collision.leave,collision.pre,collision.post)
	physics.world = self.physics_world
	return self
end

function world:add(obj)
	local index=#self.objs+1
	table.insert(self.objs,index,obj)
	self.objs_index[obj]=index
	if obj.physic and obj.verts then
		local body = physics.anyPolygon(obj.x,obj.y,obj.verts,nil,1)

		-- adjust center of mass with verts
		local dx,dy=body:getLocalCenter()
		for i=1,#obj.verts/2 do
			obj.verts[i*2-1]=obj.verts[i*2-1]-dx
			obj.verts[i*2]=obj.verts[i*2]-dy
		end
		body:destroy()

		obj.body = physics.anyPolygon(obj.x,obj.y,obj.verts,nil,1)
		-- obj.body = physics.newBox(obj.x,obj.y,20,20)
		if obj.physic_init then obj:physic_init() end
	end
end

function world:del(obj)
	self.objs[self.objs_index[obj]]=nil
	self.objs_index[obj]=nil
end

function world:new_phys_obj(b)
	local _ = base:new(b)

	if _.physic then
		assert(_.verts, "physic objs need verts to create the shape.")
	end
	world:add(_)
	return _
end

function world:update(dt)
	self.physics_world:update(dt)

	for i,v in ipairs(self.objs) do
		if v.update then v:update(dt) end
	end
end

function world:draw()
	for i,v in ipairs(self.objs) do
		if v.draw then v:draw() end
	end
end


return world:init()
